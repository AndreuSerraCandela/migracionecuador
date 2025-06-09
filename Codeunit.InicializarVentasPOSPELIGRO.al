codeunit 76045 "Inicializar Ventas POS-PELIGRO"
{

    trigger OnRun()
    var
        Text001: Label 'Este proceso BORRA TODOS LOS DATOS DEL POS\ Solo debería ejecutarlo Dynasoft Solutions \ ¿Continuar?';
        r1: Record "Sales Header";
        r2: Record "Sales Line";
        r3: Record "Pagos TPV";
        r4: Record "Transacciones TPV";
        r5: Record "Transacciones Caja TPV";
        r6: Record "Control de TPV";
        r7: Record "Arqueo de caja";
        r8: Record "Lin. declaracion caja";
        r9: Record "_Clientes TPV";
        r10: Record "Turnos TPV";
        r11: Record "_Pedidos Aparcados";
    begin

        if not Confirm(Text001, false) then
            exit;


        r1.SetRange("Venta TPV", true);
        if r1.FindSet then begin
            repeat
                r2.Reset;
                r2.SetRange("Document No.", r1."No.");
                if r2.FindSet then
                    r2.DeleteAll(false);
            until r1.Next = 0;
            r1.DeleteAll(false);
        end;

        r3.DeleteAll(false);

        r4.DeleteAll(false);

        r5.DeleteAll(false);

        r6.DeleteAll(false);

        r7.DeleteAll(false);

        r8.DeleteAll(false);

        r9.DeleteAll(false);

        r10.DeleteAll(false);

        r11.DeleteAll(false);
    end;

    var
        wFecha: Date;
        PagFecha: Page "Petición de Fecha";
}

