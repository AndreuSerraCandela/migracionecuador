codeunit 56018 MACROmodin
{
    Permissions = TableData "Sales Header" = rimd,
                  TableData "Sales Line" = rimd,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Cr.Memo Header" = rm,
                  TableData "Sales Header X" = rimd,
                  TableData "Sales Line X" = rimd;

    trigger OnRun()
    var
        l: Text;
        c: Codeunit "Funciones Ecuador";
        r36: Record "Sales Header";
        r36b: Record "Sales Header";
        r37: Record "Sales Line";
        r114: Record "Sales Cr.Memo Header";
        r112: Record "Sales Invoice Header";
        lcomprobante: Code[20];
        lPrefijo: Code[20];
        lCorrelativo: Code[20];
        lConta: Integer;
    begin
        EliminarDatosDuplicados;
    end;

    var
        r: Record "Claves para volver a publicar.";

    local procedure EliminarDatosDuplicados()
    var
        r36: Record "Sales Header";
        r36Del: Record "Sales Header";
        rBck36: Record "Sales Header X";
        r37: Record "Sales Line";
        r37Del: Record "Sales Line";
        rBck37: Record "Sales Line X";
        r112: Record "Sales Invoice Header";
        r114: Record "Sales Cr.Memo Header";
        lEliminar: Boolean;
        lWindow: Dialog;
        lCuantos: Integer;
        lTope: Integer;
    begin

        lWindow.Open('Documento #######################1');

        r36.Reset;
        r36.SetRange("Venta TPV", true);
        r36.SetFilter(Tienda, '<>%1', '');
        if r36.FindFirst then
            repeat

                lWindow.Update(1, r36."No.");

                lEliminar := false;

                if r36."Document Type" = r36."Document Type"::Invoice then
                    if r112.Get(r36."Posting No.") then
                        lEliminar := true;

                if r36."Document Type" = r36."Document Type"::"Credit Memo" then
                    if r114.Get(r36."Posting No.") then
                        lEliminar := true;


                if lEliminar then begin

                    lWindow.Update(1, r36."No.");

                    lCuantos := lCuantos + 1;
                    lTope := lTope + 1;
                    if lTope >= 500 then begin
                        lTope := 0;
                        Commit;
                    end;

                    r37.Reset;
                    r37.SetRange("Document Type", r36."Document Type");
                    r37.SetRange("Document No.", r36."No.");
                    if r37.FindFirst then
                        repeat
                            rBck37.Init;
                            rBck37.TransferFields(r37);
                            if rBck37.Insert then;

                            r37Del := r37;
                            r37Del.Delete;

                        until r37.Next = 0;

                    rBck36.Init;
                    rBck36.TransferFields(r36);
                    if rBck36.Insert then;

                    r36Del := r36;
                    r36Del.Delete;

                end;

            until r36.Next = 0;

        lWindow.Close;
        Message(Format(lCuantos));
    end;


    procedure DiagnosticoEstadosErroneos()
    var
        lrLog: Record "Log comprobantes electronicos";
        lrAux: Record "Revisar estado documentos";
        lrLogAux: Record "Log comprobantes electronicos";
        lrDocumentoFE: Record "Documento FE";
        lWindow: Dialog;
    begin
        //+35029
        lWindow.Open('Documento ################1');

        /*
        lrAux.RESET;
        lrAux.SETRANGE(DUMMY,FALSE);
        lrAux.DELETEALL;
        */

        lrLog.Reset;
        lrLog.SetRange("Respuesta SRI", 'CLAVE ACCESO REGISTRADA');
        if lrLog.FindFirst then
            repeat

                lWindow.Update(1, lrLog."No. documento");

                if not lrAux.Get(lrLog."No. documento") then begin

                    //... Grabamos el estado ACTUAL.
                    lrDocumentoFE.Get(lrLog."No. documento");
                    lrAux.Init;
                    lrAux.Documento := lrDocumentoFE."No. documento";
                    lrAux."Estado envio actual" := lrDocumentoFE."Estado envio";
                    lrAux."Estado autorizacion actual" := lrDocumentoFE."Estado autorizacion";
                    lrAux."Fecha emision" := lrDocumentoFE."Fecha emision";
                    lrAux."Estado envio (Presunto)" := lrAux."Estado envio actual";
                    lrAux."Estado autorizacion (Presunto)" := lrAux."Estado autorizacion actual";
                    lrAux.Insert;

                    //... Miramos ahora, si en el LOG hay constancia que haya sido ENVIADA y AUTORIZADA.
                    //... En ese caso, lo anotamos.
                    lrLogAux.Reset;
                    lrLogAux.SetCurrentKey("Tipo documento", "No. documento");
                    lrLogAux.SetRange("Tipo documento", lrLog."Tipo documento");
                    lrLogAux.SetRange("No. documento", lrLog."No. documento");
                    lrLogAux.SetRange(Estado, lrLogAux.Estado::Enviado);
                    if lrLogAux.FindFirst then begin
                        lrAux."Estado envio (Presunto)" := lrAux."Estado envio (Presunto)"::Enviado;
                        lrAux.Modify;
                    end;

                    lrLogAux.SetRange(Estado, lrLogAux.Estado::Autorizado);
                    if lrLogAux.FindFirst then begin
                        lrAux."Estado autorizacion (Presunto)" := lrAux."Estado autorizacion (Presunto)"::Autorizado;
                        lrAux.Modify;
                    end
                    else begin
                        lrLogAux.SetRange(Estado, lrLogAux.Estado::"No autorizado");
                        if lrLogAux.FindFirst then begin
                            lrAux."Estado autorizacion (Presunto)" := lrAux."Estado autorizacion (Presunto)"::"No autorizado";
                            lrAux.Modify;
                        end;
                    end;

                    if (lrAux."Estado envio actual" <> lrAux."Estado envio (Presunto)") or
                       (lrAux."Estado autorizacion actual" <> lrAux."Estado autorizacion (Presunto)") then begin
                        lrAux.Revisar := true;
                        lrAux.Modify;
                    end;

                end;
            until lrLog.Next = 0;

        lWindow.Close;

    end;


    procedure Re_Publica0()
    var
        lrAux: Record "Claves para volver a publicar.";
        lrLog: Record "Log comprobantes electronicos";
        lrDocFE: Record "Documento FE";
        lWindow: Dialog;
    begin
        lWindow.Open('Documento ####################################################1');

        lrAux.Reset;
        if lrAux.FindFirst then
            repeat
                lWindow.Update(1, lrAux.Clave);
                lrLog.Reset;
                lrLog.SetRange("Fichero XML", lrAux.Clave);
                if lrLog.FindFirst then
                    if lrDocFE.Get(lrLog."No. documento") then begin
                        lrAux.Documento := lrDocFE."No. documento";
                        lrAux."Fecha emision" := lrDocFE."Fecha emision";
                        lrAux."Tipo documento" := lrDocFE."Tipo documento";
                        lrAux."Subtipo documento" := lrDocFE."Subtipo documento";
                        lrAux."Estado envio" := lrDocFE."Estado envio";
                        lrAux."Estado autorizacion" := lrDocFE."Estado autorizacion";
                        lrAux.Modify;
                    end;
            until lrAux.Next = 0;

        lWindow.Close;
    end;


    procedure Re_Publica1()
    var
        lrAux: Record "Claves para volver a publicar.";
        lWindow: Dialog;
    /*   cRRT: Codeunit "Comprobantes electronicos RRT"; */
    begin
        lWindow.Open('Documento ####################################################1');

        lrAux.Reset;
        //lrAux.SETRANGE(Documento,'ET-020156');
        lrAux.SetRange("Estado envio", lrAux."Estado envio"::Enviado);
        lrAux.SetRange("Estado autorizacion", lrAux."Estado autorizacion"::Autorizado);
        lrAux.SetRange("Fichero autorizacion", '');

        if lrAux.FindFirst then
            repeat
                lWindow.Update(1, lrAux.Clave);
            //cRRT.ComprobarAutorizacion(lrAux.Documento,FALSE,lrAux)
            until lrAux.Next = 0;

        lWindow.Close;
    end;


    procedure Re_Publica2()
    var
        lDestino: Text[512];
        lSufijo: Text[512];
        lLong: Integer;
        lLeidos: Text[512];
        w: Dialog;
        lConta: Integer;
    begin
        /*    lConta := 0;
           w.Open('Contador #######1');
           r.Reset;
           r.SetFilter("Fichero autorizacion", '<>%1', '');
           if r.FindFirst then
               repeat
                   r.Marcar := false;
                   r.Modify;
                   lConta := lConta + 1;
                   w.Update(1, lConta);

                   if r."Fichero autorizacion" <> '' then
                       if Exists(r."Fichero autorizacion") then begin
                           lDestino := '';
                           lLeidos := '';
                           case r."Tipo documento" of

                               r."Tipo documento"::Retencion:
                                   begin
                                       lDestino := '\\SECNAVSQL02\ProduccionFE\Retenciones\Autorizados\';
                                       lDestino := '\\SECNAVSQL02\ProduccionFE\Retenciones\Reenviar\';
                                       lLeidos := '\\SECNAVSQL02\ProduccionFE\Retenciones\Leidos\';
                                   end;

                               r."Tipo documento"::Remision:
                                   begin
                                       lDestino := '\\SECNAVSQL02\ProduccionFE\Remisiones\Autorizados\';
                                       lDestino := '\\SECNAVSQL02\ProduccionFE\Remisiones\Reenviar\';
                                       lLeidos := '\\SECNAVSQL02\ProduccionFE\Remisiones\Leidos\';
                                   end;

                               r."Tipo documento"::Factura:
                                   begin
                                       lDestino := '\\SECNAVSQL02\ProduccionFE\Facturas\Autorizados\';
                                       lDestino := '\\SECNAVSQL02\ProduccionFE\Facturas\Reenviar\';
                                       lLeidos := '\\SECNAVSQL02\ProduccionFE\Facturas\Leidos\';
                                   end;

                               r."Tipo documento"::NotaCredito:
                                   begin
                                       lDestino := '\\SECNAVSQL02\ProduccionFE\NotasCredito\Autorizados\';
                                       lDestino := '\\SECNAVSQL02\ProduccionFE\NotasCredito\Reenviar\';
                                       lLeidos := '\\SECNAVSQL02\ProduccionFE\NotasCredito\Leidos\';
                                   end;

                           end;
                           lLong := StrLen(r.Clave);
                           lSufijo := '';
                           if CopyStr(r.Clave, lLong - 3, 4) <> '.xml' then
                               lSufijo := r.Clave + '.xml'
                           else
                               lSufijo := r.Clave;

                           if (lSufijo <> '') and (lDestino <> '') and (lLeidos <> '') then begin
                               //IF EXISTS(lLeidos+lSufijo) THEN
                               //  FILE.COPY(lLeidos+lSufijo,'\\SECNAVSQL02\ProduccionFE\Dynasoft\BCK\'+lSufijo);

                               FILE.Copy(r."Fichero autorizacion", lDestino + lSufijo);

                               r.Marcar := true;
                               r.Modify;
                           end;

                       end;

               until (r.Next = 0) or (lConta >= 20000);
           w.Close; */
    end;


    procedure CambiarEstados()
    var
        lrAux: Record "Revisar estado documentos";
        lWindow: Dialog;
        lrDocumentoFE: Record "Documento FE";
    begin
        lWindow.Open('Documento ##################1');

        lrAux.Reset;
        lrAux.SetRange(Revisar, true);
        if lrAux.FindFirst then
            repeat

                lWindow.Update(1, lrAux.Documento);

                lrDocumentoFE.Get(lrAux.Documento);

                //... Grabamos el estado ACTUAL.
                lrDocumentoFE.Get(lrAux.Documento);
                lrDocumentoFE."Estado envio" := lrAux."Estado envio (Presunto)";
                lrDocumentoFE."Estado autorizacion" := lrAux."Estado autorizacion (Presunto)";
                lrDocumentoFE.Modify;

            until lrAux.Next = 0;

        lWindow.Close;
    end;


    procedure TraspasoDatos()
    var
        l11: Record "_Clientes TPV";
        l12: Record "Clientes TPV";
        l21: Record "_Autoriz. Manuales TPV BO";
        l22: Record "Autorizaciones Manuales TPV";
        l31: Record "_Pedidos Aparcados";
        l32: Record "Pedidos Aparcados";
        l41: Record "_Dimensiones POS";
        l42: Record "Dimensiones POS";
    begin
        l11.Reset;
        if l11.FindFirst then
            repeat
                l12.Init;
                l12.TransferFields(l11);
                l12.Insert;
            until l11.Next = 0;

        l21.Reset;
        if l21.FindFirst then
            repeat
                l22.Init;
                l22.TransferFields(l22);
                l22.Insert;
            until l21.Next = 0;

        l31.Reset;
        if l31.FindFirst then
            repeat
                l32.Init;
                l32.TransferFields(l31);
                l32.Insert;
            until l31.Next = 0;


        l41.Reset;
        if l41.FindFirst then
            repeat
                l42.Init;
                l42.TransferFields(l41);
                l42.Insert;
            until l41.Next = 0;

        Message('Ya esta');
    end;


    procedure EliminarDatos()
    var
        l11: Record "_Clientes TPV";
        l21: Record "_Autoriz. Manuales TPV BO";
        l31: Record "_Pedidos Aparcados";
        l41: Record "_Dimensiones POS";
    begin
        Error('NO');
        l11.DeleteAll;
        l21.DeleteAll;
        l31.DeleteAll;
        l41.DeleteAll;
        Message('Ya esta');
    end;


    procedure CambiarDireccionFactura(pDoc: Code[20])
    var
        r112: Record "Sales Invoice Header";
    begin
        r112.Get(pDoc);
        if (r112."Bill-to Name" = 'N/C') or (r112."Bill-to Name" = '') then begin
            r112."Bill-to Name" := 'CONSUMIDOR FINAL';
            r112.Modify;
        end;
    end;


    procedure RelacionarFactura()
    var
        r114: Record "Sales Cr.Memo Header";
        r114b: Record "Sales Cr.Memo Header";
        r112: Record "Sales Invoice Header";
    begin
        r114.Reset;
        r114.SetRange("Venta TPV", true);
        r114.SetRange("Posting Date", 20210518D, 20210523D);
        r114.SetRange("Establecimiento Fact. Rel", '');
        r114.SetRange("No.", 'NCRU-000071');

        if r114.FindFirst then
            repeat
                //IF (r114."No. Comprobante Fiscal Rel." <> '') OR (r114."Anula a Documento" = '') THEN
                //  ERROR('Revisar '+r114."No.");

                r112.Get(r114."Anula a Documento");

                if r112."No. Comprobante Fiscal" = '' then
                    Error('Revisar 2 ' + r112."No.");

                //r114."No. Comprobante Fiscal Rel." := r112."No. Comprobante Fiscal";
                r114b := r114;
                r114b."Punto de Emision Fact. Rel." := r112."Punto de Emision Factura";
                r114b."Establecimiento Fact. Rel" := r112."Establecimiento Factura";
                r114b.Modify;

            until r114.Next = 0;
    end;


    procedure CambioDatosRUC()
    var
        lr: Record "Temporal cambios RUC";
        lr112: Record "Sales Invoice Header";
        lr2: Record "Temporal cambios RUC";
        lrDoc: Record "Documento FE";
    begin
        //Primero comprobamos que la informacion cuadre con lo existente.
        /*
        lr.RESET;
        lr.SETRANGE(Procesado,FALSE);
        IF lr.FINDFIRST THEN
          REPEAT
            lr112.GET(lr."No.");
            lr112.TESTFIELD("VAT Registration No.",lr."RUC existente");
        
            CASE lr112."Tipo Documento" OF
              lr112."Tipo Documento"::RUC:
                lr.TESTFIELD("TD existente",'RUC');
        
              lr112."Tipo Documento"::Cedula:
                lr.TESTFIELD("TD existente",'Cedula');
        
            END;
          UNTIL lr.NEXT=0;
        */

        lr.Reset;
        lr.SetRange(Procesado, false);
        if lr.FindFirst then
            repeat
                lr112.Get(lr."No.");
                lr112."VAT Registration No." := lr."RUC _nuevo";


                case lr112."Tipo Documento" of

                    lr112."Tipo Documento"::RUC:
                        if lr."TD _nuevo" = 'CEDULA' then
                            lr112."Tipo Documento" := lr112."Tipo Documento"::Cedula;

                    lr112."Tipo Documento"::Cedula:
                        if lr."TD _nuevo" = 'RUC' then
                            lr112."Tipo Documento" := lr112."Tipo Documento"::RUC;
                end;


                lr112.Modify;


                lrDoc.Get(lr."No.");
                lrDoc.TestField(lrDoc."Estado envio", lrDoc."Estado envio"::Enviado);
                lrDoc.TestField("Estado autorizacion", lrDoc."Estado autorizacion"::"No autorizado");

                lrDoc."Estado envio" := lrDoc."Estado envio"::Pendiente;
                lrDoc.Modify;


                lr2 := lr;
                lr2.Procesado := true;
                lr2.Modify;

            until lr.Next = 0;

    end;
}

