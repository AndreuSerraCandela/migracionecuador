report 76330 "Proceso proponer vacaciones"
{
    Caption = 'Propose vacation';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", "Employee Posting Group", Departamento, "Job Type Code";

            trigger OnAfterGetRecord()
            begin
                PlanVac.Validate("No. empleado", "No.");
                if not PlanVac.Insert(true) then
                    PlanVac.Modify(true);

                Contador := Contador + 1;
                Ventana.Update(1, Round(Contador / AModificar, 1));
            end;

            trigger OnPostDataItem()
            begin
                Ventana.Close;
                Message(Msg001);
            end;

            trigger OnPreDataItem()
            begin
                AModificar := Count;
                Ventana.Open(Text001);

                AModificar := AModificar / 10000;
                Contador := 0;
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
        PlanVac: Record "Planificacion de vacaciones";
        Text001: Label 'Processing ...          \\    @1@@@@@@@@@@@@@    \';
        Msg001: Label 'End of process';
        Ventana: Dialog;
        AModificar: Decimal;
        Contador: Decimal;
}

