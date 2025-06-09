codeunit 75008 "MdM Notifica Precios"
{
    // Una problematica con la que nos encontramos es que MdM no tiene encuenta las fechas para los precios, por lo que el ultimo precio notificado es el bueno
    // Eso choca con Navision ya que se pueden configurar precios de compra a fecha futura
    // En cuanto se Crea precio con fecha futura, se genera un movimiento de cola de proyecto que activará la notificación a la fecha de inicio del precio
    // 
    // JPT $001 02/04/2019 - Nueva funcionalidad: Modificamos para que no se cree una cola de proyecto para cada producto sino una por día..

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin

        if StrPos(Rec."Parameter String", Text001) = 1 then
            GestPrecio(Rec."Parameter String");
        // Sea como sea lanza el segundo proceso
        GestPrecio2;
    end;

    var
        Text001: Label 'Precio';
        cGestMaestros: Codeunit "Gest. Maestros MdM";
        rConfMdM: Record "Configuracion MDM";
        Text002: Label 'MdM. Activa Notificación precios de producto ';


    procedure GetParam(pwIdProd: Code[20]) Result: Text
    begin
        // GetParam

        Result := StrSubstNo('%1(%2)', Text001, pwIdProd);
    end;


    procedure GestPrecio(pwParam: Text)
    var
        lwParm: Text;
        lwPos: Integer;
        lrProd: Record Item;
    begin
        // GestPrecio

        lwParm := UpperCase(DelChr(pwParam, '<>'));
        lwPos := StrPos(lwParm, UpperCase(Text001));
        if lwPos <> 1 then
            exit;
        lwParm := CopyStr(lwParm, StrLen(Text001) + 1);
        lwParm := DelChr(lwParm, '<>', '()');

        if lrProd.Get(lwParm) then
            cGestMaestros.GestNotityPrecProd(lrProd);
    end;


    procedure GestPrecio2()
    var
        lwFecha: Date;
        lrPrecFt: Record "Precios Futuro";
        lwPrd: Code[20];
        lrProd: Record Item;
    begin
        // GestPrecio2
        // $001

        lwFecha := Today;

        Clear(lrPrecFt);
        lrPrecFt.SetCurrentKey(Producto, Fecha);
        lrPrecFt.SetFilter(Fecha, '<=%1', lwFecha);
        if lrPrecFt.FindSet then begin
            Clear(lwPrd);
            repeat
                if lwPrd <> lrPrecFt.Producto then begin
                    lwPrd := lrPrecFt.Producto;
                    if lrProd.Get(lwPrd) then
                        cGestMaestros.GestNotityPrecProd(lrProd);
                end;
            until lrPrecFt.Next = 0;
            lrPrecFt.DeleteAll;
        end;
    end;


    procedure CreaNotif(var prPrec: Record "Price List Line"; pwDelete: Boolean)
    var
        lwFecha: Date;
        lwFecha2: Date;
        lrJQueueE: Record "Job Queue Entry";
        lwExist: Boolean;
        lwOk: Boolean;
    begin
        // CreaNotif
        // Crea la cola de proyecto la cual a su vez generará una notificación de precios al MdM cuando llegue la fecha indicada
        // Obsoleto

        // Solo si se trata de fechas futuras
        lwFecha := cGestMaestros.GestFechaPrecio;

        if not rConfMdM.Activo then
            rConfMdM.Get;

        // Solo precios futuros
        //IF ((prPrec."Ending Date" <= lwFecha) AND (prPrec."Ending Date" <> 0D)) THEN
        // Modificación para que tenga en cuenta solo precios futuros... con fecha de inicio futura
        if ((prPrec."Ending Date" <= lwFecha) and (prPrec."Ending Date" <> 0D)) or (prPrec."Starting Date" <= lwFecha) then
            pwDelete := true;

        lwExist := lrJQueueE.Get(prPrec.IdJobQueueEntry);
        if lwExist then
            lwExist := lrJQueueE."Job Queue Category Code" = rConfMdM."Job Queue Category";

        if lwExist then begin
            if pwDelete then
                lrJQueueE.Delete(true)
            else begin
                lwFecha2 := prPrec."Starting Date";
                if lwFecha2 <= lwFecha then
                    lwFecha2 := CalcDate('<+1D>', lwFecha); // Mañana
                lrJQueueE."Earliest Start Date/Time" := CreateDateTime(lwFecha2, HoraInicio);
                lrJQueueE.Modify(true);
                cGestMaestros.ActColaProy; // Nos aseguramos que la cola está activada
                                           //lwOk := CODEUNIT.RUN(75001); // Nos aseguramos que la cola está activada
            end;
        end;

        if (not lwExist) and (not pwDelete) then begin
            // Crea un movimiento de cola de proyecto nuevo
            Clear(lrJQueueE);
            lrJQueueE.Insert(true);
            lrJQueueE.Validate("Job Queue Category Code", rConfMdM."Job Queue Category");
            lrJQueueE.Validate(Description, Text002);
            lrJQueueE.Validate("Object Type to Run", lrJQueueE."Object Type to Run"::Codeunit);
            lrJQueueE.Validate("Object ID to Run", 75008);
            lrJQueueE.Validate("Parameter String", GetParam(prPrec."Product No."));
            lwFecha2 := prPrec."Starting Date";
            if lwFecha2 <= lwFecha then
                lwFecha2 := CalcDate('<+1D>', lwFecha); // Mañana
            lrJQueueE."Earliest Start Date/Time" := CreateDateTime(lwFecha2, HoraInicio);
            lrJQueueE.Modify(true);

            prPrec.IdJobQueueEntry := lrJQueueE.ID; // Anotamos la id de la cola de proyecto en la línea de precio
                                                    //prPrec.MODIFY;  // No debe de modifiarse ya que el precio viene por referencia
            cGestMaestros.ActColaProy; // Nos aseguramos que la cola está activada
                                       //lwOk := CODEUNIT.RUN(75001); // Nos aseguramos que la cola está activada
        end;
    end;


    procedure CreaNotif2(var XprPrec: Record "Price List Line"; var prPrec: Record "Price List Line"; pwDelete: Boolean)
    var
        lwFecha: Date;
        lwOk: Boolean;
    begin
        // CreaNotif2
        // $001 Una línea de precios a futuro que servira para que se lance la notificación el día de vencimiento

        if not rConfMdM.Activo then
            rConfMdM.Get;

        if pwDelete then begin
            GestPrecFut(prPrec, prPrec."Starting Date", 0, true);
            GestPrecFut(prPrec, prPrec."Ending Date", 1, true);
        end
        else begin
            if (XprPrec."Starting Date" <> prPrec."Starting Date") then begin
                GestPrecFut(XprPrec, XprPrec."Starting Date", 0, true);
                GestPrecFut(prPrec, prPrec."Starting Date", 0, false);
            end;
            if (XprPrec."Ending Date" <> prPrec."Ending Date") then begin
                GestPrecFut(XprPrec, XprPrec."Ending Date", 1, true);
                GestPrecFut(prPrec, prPrec."Ending Date", 1, false);
            end;
        end;

        cGestMaestros.ActColaProy; // Nos aseguramos que la cola está activada
    end;


    procedure GestPrecFut(var prPrec: Record "Price List Line"; pwFecha: Date; pwTipo: Option Inicio,Fin; pwDelete: Boolean)
    var
        lwFecha: Date;
        lwExist: Boolean;
        lrPrecFt: Record "Precios Futuro";
        lrRecRf: RecordRef;
        lwOK: Boolean;
        lwDel2: Boolean;
    begin
        // GestPrecFut
        // $001 Una línea de precios a futuro que servira para que se lance la notificación el día de vencimiento

        if pwFecha = 0D then
            exit;

        // Solo si se trata de fechas futuras
        if not pwDelete then begin
            lwFecha := cGestMaestros.GestFechaPrecio;
            if pwFecha < lwFecha then
                pwDelete := true;
        end;

        lrRecRf.GetTable(prPrec);

        Clear(lrPrecFt);
        lrPrecFt.SetRange(Producto, prPrec."Product No.");
        lrPrecFt.SetRange(Fecha, pwFecha);
        lrPrecFt.SetRange(Tipo, pwTipo);
        lrPrecFt.SetRange(PricePos, lrRecRf.RecordId);
        lwExist := lrPrecFt.FindFirst;

        if lwExist then begin
            if pwDelete then begin
                lrPrecFt.Delete;
                lwOK := true;
            end;
        end;

        if (not lwExist) and (not pwDelete) then begin
            // Crea un registro nuevo
            Clear(lrPrecFt);
            lrPrecFt.Producto := prPrec."Product No.";
            lrPrecFt.Fecha := pwFecha;
            lrPrecFt.PricePos := lrRecRf.RecordId;
            lrPrecFt.Tipo := pwTipo;
            lrPrecFt.Insert(true);
            lwOK := true;
        end;

        // Ahora Gestionamos la cola de proyecto
        if lwOK then begin
            Clear(lrPrecFt);
            lrPrecFt.SetRange(Fecha, pwFecha);
            lwDel2 := lrPrecFt.IsEmpty;
            GestMovCola2(pwFecha, lwDel2);
        end;
    end;


    procedure GestMovCola2(pwFecha: Date; pwDelete: Boolean)
    var
        lwFecha: Date;
        lwFecha2: Date;
        lrJQueueE: Record "Job Queue Entry";
        lwExist: Boolean;
        lwOk: Boolean;
        lwIdCdUn: Integer;
        lwDT: DateTime;
    begin
        // GestMovCola2
        // $001 JPT 01/04/2019 Nueva funcionalidad
        // Crea la cola de proyecto la cual a su vez generará una notificación de precios al MdM cuando llegue la fecha indicada

        if pwFecha = 0D then
            exit;

        // Solo si se trata de fechas futuras
        if not pwDelete then begin
            lwFecha := cGestMaestros.GestFechaPrecio;
            if pwFecha < lwFecha then
                pwDelete := true;
        end;

        if not rConfMdM.Activo then
            rConfMdM.Get;

        lwIdCdUn := 75008;
        lwDT := CreateDateTime(pwFecha, HoraInicio);

        Clear(lrJQueueE);
        lrJQueueE.SetRange("Job Queue Category Code", rConfMdM."Job Queue Category");
        lrJQueueE.SetRange("Object Type to Run", lrJQueueE."Object Type to Run"::Codeunit);
        lrJQueueE.SetRange("Object ID to Run", lwIdCdUn);
        lrJQueueE.SetRange("Earliest Start Date/Time", lwDT);
        //lrJQueueE.SETRANGE("Parameter String"        ,'');
        lwExist := lrJQueueE.FindFirst;

        if lwExist then begin
            if pwDelete then
                lrJQueueE.Delete(true)
        end;

        if (not lwExist) and (not pwDelete) then begin
            // Crea un movimiento de cola de proyecto nuevo
            Clear(lrJQueueE);
            lrJQueueE.Insert(true);
            lrJQueueE.Validate("Job Queue Category Code", rConfMdM."Job Queue Category");
            lrJQueueE.Validate(Description, Text002);
            lrJQueueE.Validate("Object Type to Run", lrJQueueE."Object Type to Run"::Codeunit);
            lrJQueueE.Validate("Object ID to Run", lwIdCdUn);
            lrJQueueE."Earliest Start Date/Time" := lwDT;
            lrJQueueE.Modify(true);
        end;

        cGestMaestros.ActColaProy; // Nos aseguramos que la cola está activada
    end;


    procedure HoraInicio() Result: Time
    begin
        // HoraInicio
        // Diez minutos pasados medianoche
        Result := 001000T;
    end;
}

