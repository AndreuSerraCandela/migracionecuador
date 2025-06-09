report 76081 "Cierra Prestamos"
{
    Caption = 'Close Loans';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Histórico Cab. Préstamo"; "Histórico Cab. Préstamo")
        {
            CalcFields = "Importe Pendiente";
            DataItemTableView = SORTING ("Employee No.", "No. Préstamo") WHERE (Pendiente = CONST (true));
            RequestFilterFields = "No. Préstamo", "Employee No.";

            trigger OnAfterGetRecord()
            begin
                if "Importe Pendiente" = 0 then
                    CurrReport.Skip;

                HLP.Reset;
                HLP.SetRange("No. Préstamo", "No. Préstamo");
                if not HLP.FindLast then
                    HLP."No. Línea" := 0;

                HLP2.Init;
                HLP2."No. Préstamo" := "No. Préstamo";
                HLP2."No. Línea" := HLP."No. Línea" + 1000;
                HLP2."Tipo CxC" := "Tipo CxC";
                HLP2."No. Cuota" := HLP."No. Cuota" + 1;
                HLP2."Fecha Transacción" := Today;
                HLP2."Código Empleado" := "Employee No.";
                HLP2.Validate(Importe, "Importe Pendiente" * -1);
                HLP2.Insert(true);


                Pendiente := false;
                Correccion := true;
                Modify;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        HLP: Record "Histórico Lín. Préstamo";
        Txt0001: Label 'To fix open balance';
        HLP2: Record "Histórico Lín. Préstamo";
}

