codeunit 75005 "MdM Async Manager"
{
    SingleInstance = true;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        // FindCabs es más bien para utilizar el Jobs Queue...
        FindCabs;
    end;

    var
        rTmp: Record "Imp.MdM Cabecera" temporary;
        rConfMdM: Record "Configuracion MDM";
        rConfSant: Record "Config. Empresa";
        rAsSender: Codeunit "MdM Async Sender";
        cGest: Codeunit "Gest. Maestros MdM";
        cTrasp: Codeunit "MdM Gen. Prod.";
        rCab: Record "Imp.MdM Cabecera";


    procedure FindCabs()
    var
        lwOK: Boolean;
        lwInt: Integer;
        lwInt2: Integer;
        lwMin: Integer;
        lwCDT: DateTime;
        lwNInts: Integer;
    begin
        // FindCabs

        Clear(rCab);
        //rCab.SETRANGE(Entrada , rCab.Entrada::INT_WS);
        rCab.SetFilter(Entrada, '%1|%2', rCab.Entrada::INT_WS, rCab.Entrada::NOTIFICA);
        rCab.SetFilter("Estado Envio", '<%1', rCab."Estado Envio"::Finalizado);

        //rCab.GET(159425);

        lwCDT := CurrentDateTime;
        //IF rCab.FINDFIrst THEN BEGIN
        if rCab.FindSet then begin
            repeat
                lwNInts := rCab.Attempt + 1;
                rCab.GetIntDates2(lwInt2, lwInt, lwNInts);

                lwOK := (rCab."Last Attempt" = 0DT);
                if not lwOK then begin
                    // Primero 5 intentos cada 5 minutos
                    // Despues 5 intentos cada 15 minutos
                    // Finalmente 5 intentos cada 3 horas
                    case lwInt2 of
                        1:
                            lwMin := 5;
                        2:
                            lwMin := 15;
                        3:
                            lwMin := 180;
                    end;
                    if lwInt2 < 4 then
                        lwOK := ((lwCDT - rCab."Last Attempt") * 60000) > lwMin
                    else begin // Si pasa de los 3 intentos cada 3 horas la desestimamos
                        rCab."Estado Envio" := rCab."Estado Envio"::Desestimada;
                        rCab.Modify;
                    end;
                end;

                if lwOK then begin
                    if not rTmp.Get(rCab.Id) then begin
                        rTmp.Copy(rCab);
                        rTmp.Insert;
                    end;
                end;

            until rCab.Next = 0;
            Ejecuta;
        end;

        // Por si acaso, al final de todo, elimino registros antiguos
        BorraRegsAntiguos;

        // Desactivamos la cola si no hay nada que mandar
        SetHoldQ;
    end;


    procedure Ejecuta()
    var
        lwTipo: Option Insert,Update,Delete,Error;
        lwErrCode: Code[20];
        lwErrDescription: Text[1024];
        lwIsError: Boolean;
    begin
        //Ejecuta

        Commit;
        // Solo procesamos lo que tenemos en el temporal
        if rTmp.Find('-') then begin
            repeat
                // Recuperamos el registro real
                Clear(rCab);
                if rCab.Get(rTmp.Id) then
                    TraspasaCab(rCab);
            until rTmp.Next = 0;
        end;
    end;


    procedure TraspasaCab(var prCab: Record "Imp.MdM Cabecera")
    var
        lwErrCode: Code[20];
        lwErrDescription: Text;
        lwIsError: Boolean;
    begin
        // TraspasaCab

        if prCab.Entrada = prCab.Entrada::INT_Excel then
            exit;

        ClearLastError;
        Commit;
        prCab.NewIntent;
        lwIsError := false;
        //prCab."Texto Error" := '';
        if prCab.Entrada = prCab.Entrada::INT_WS then begin
            if prCab.Estado = prCab.Estado::Pendiente then begin
                lwIsError := not cTrasp.Run(prCab);
                if lwIsError then begin
                    prCab.Estado := prCab.Estado::Error;
                    lwErrDescription := GetLastErrorText;
                    prCab."Texto Error" := CopyStr(lwErrDescription, 1, 250);
                end
                else
                    prCab."Texto Error" := '';
            end
            else begin
                if prCab.Estado = prCab.Estado::Error then
                    lwErrDescription := prCab."Texto Error";
            end;

            if prCab.Estado = prCab.Estado::Error then begin
                lwErrCode := '100';
                rAsSender.BuildXMLError(prCab, lwErrCode, lwErrDescription);
            end
            else begin
                rAsSender.BuildXMLRequest(prCab);
            end;
        end;

        rAsSender.Send(prCab); // Enviamos la respuesta asincrona

        cGest.GestColaProy(0); // Nos aseguramos que la cola de proyecto está activada
        prCab.Modify;
    end;


    procedure BorraRegsAntiguos()
    var
        lrCab: Record "Imp.MdM Cabecera";
        lwFechaB: DateTime;
        lwDias: Text;
    begin
        // BorraRegsAntiguos
        // Se eliminan todos los registros anteriores a n dias

        if not rConfMdM.Activo then
            rConfMdM.Get;
        if rConfMdM."Dias Borrado Historico" = 0 then
            exit;

        lwDias := StrSubstNo('<-%1D>', rConfMdM."Dias Borrado Historico");
        lwFechaB := CreateDateTime(CalcDate(lwDias, Today), 000000T);

        Clear(lrCab);
        lrCab.SetFilter("Fecha Creacion", '<%1', lwFechaB);
        //lrCab.SETFILTER(Entrada, '<>%1',  lrCab.Entrada::NOTIFICA);
        lrCab.SetFilter(Estado, '<>%1', lrCab.Estado::Pendiente);
        lrCab.SetRange(Entrada, lrCab.Entrada::INT_WS, lrCab.Entrada::INT_Excel);
        lrCab.DeleteAll(true);

        // Borramos tambien las notificaciones
        Clear(lrCab);
        lrCab.SetFilter("Fecha Creacion", '<%1', lwFechaB);
        lrCab.SetRange(Entrada, lrCab.Entrada::NOTIFICA);
        lrCab.SetRange("Estado Envio", lrCab."Estado Envio"::Finalizado);
        lrCab.DeleteAll(true);
    end;


    procedure SetHoldQ()
    var
        lrCab2: Record "Imp.MdM Cabecera";
    begin
        // SetHoldQ

        // Desactivamos la cola si no hay nada que mandar
        Clear(lrCab2);
        lrCab2.SetFilter(Entrada, '<>%1', lrCab2.Entrada::INT_Excel);
        lrCab2.SetFilter("Estado Envio", '<%1', lrCab2."Estado Envio"::Finalizado);
        if lrCab2.IsEmpty then
            cGest.GestColaProy(1);
    end;


    procedure GetSistemaOrigen() Result: Text
    begin
        // GetSistemaOrigen

        if not rConfMdM.Activo then
            rConfMdM.Get;
        Result := DelChr(rConfMdM."Sistema Origen", '<>');

        if Result = '' then begin
            rConfSant.Get;
            Result := rConfSant.GetSistemaOrigen;
        end;
    end;
}

