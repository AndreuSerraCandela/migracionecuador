codeunit 76048 "Macro POS - Tiendas"
{

    trigger OnRun()
    var
        Text001: Label 'Este proceso BORRA TODOS LOS DATOS DEL POS\ Solo debería ejecutarlo Dynasoft Solutions \ ¿Continuar?';
        rConfTPV: Record "Configuracion TPV";
    begin

        Iconos;
        exit;


        rConfTPV.Reset;
        rConfTPV.SetFilter("Usuario windows", '<>%1', '');
        if rConfTPV.FindFirst then
            Tiendas
        else
            Central;

        Message('finalizado');
    end;


    procedure Tiendas()
    var
        rTrans: Record "Transacciones TPV";
        rTransCaja: Record "Transacciones Caja TPV";
        rControl: Record "Control de TPV";
        rArq: Record "Arqueo de caja";
        rLinCaja: Record "Lin. declaracion caja";
        rTurnos: Record "Turnos TPV";
    begin

        rControl.Reset;
        if rControl.FindFirst then begin
            repeat

                rControl."Id Replicacion" := StrSubstNo('%1', Date2DMY(rControl.Fecha, 1)) + StrSubstNo('%1', Date2DMY(rControl.Fecha, 2)) + StrSubstNo('%1', Date2DMY(rControl.Fecha, 3));
                rControl.Modify(false);

                //modificamos las tablas hijas
                rTrans.Reset;
                rTrans.SetRange(Fecha, rControl.Fecha);
                if rTrans.FindFirst then
                    repeat
                        rTrans."Id Replicacion" := rControl."Id Replicacion";
                        rTrans.Modify;
                    until rTrans.Next = 0;

                rTransCaja.Reset;
                rTransCaja.SetRange(Fecha, rControl.Fecha);
                if rTransCaja.FindFirst then
                    repeat
                        rTransCaja."Id Replicacion" := rControl."Id Replicacion";
                        rTransCaja.Modify;
                    until rTransCaja.Next = 0;

                rArq.Reset;
                rArq.SetRange(Fecha, rControl.Fecha);
                if rArq.FindFirst then
                    repeat
                        rArq."Id Replicacion" := rControl."Id Replicacion";
                        rArq.Modify;
                    until rArq.Next = 0;

                rLinCaja.Reset;
                rLinCaja.SetRange(Fecha, rControl.Fecha);
                if rLinCaja.FindFirst then
                    repeat
                        rLinCaja."Id Replicacion" := rControl."Id Replicacion";
                        rLinCaja.Modify;
                    until rLinCaja.Next = 0;

                rTurnos.Reset;
                rTurnos.SetRange(Fecha, rControl.Fecha);
                if rTurnos.FindFirst then
                    repeat
                        rTurnos."Id Replicacion" := rControl."Id Replicacion";
                        rTurnos.Modify;
                    until rTurnos.Next = 0;

            until rControl.Next = 0;
        end;
    end;


    procedure Central()
    var
        rItem: Record Item;
        rCustomer: Record Customer;
        rDimen: Record Dimension;
        rSource: Record "Source Code";
    begin

        //fes mig
        /* rItem.MODIFYALL("Source Counter POS",1);
        rCustomer.MODIFYALL("Source Counter POS",1);
        rDimen.MODIFYALL("Source Counter POS",1);
        rSource.MODIFYALL("Source Counter POS",1);
        */
        //fes mig

    end;


    procedure Iconos()
    var
        rFormPago: Record "Formas de Pago";
    begin

        if rFormPago.FindSet then
            repeat
                rFormPago.CalcFields(Icono);
                if rFormPago.Icono.HasValue then begin
                    rFormPago."Icono Nav" := rFormPago.Icono;
                    rFormPago.Modify;
                end;
            until rFormPago.Next = 0;
    end;
}

