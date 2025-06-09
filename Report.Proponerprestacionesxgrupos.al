report 76256 "Proponer prestaciones x grupos"
{
    Caption = 'Propose bulk settlement calculation';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = WHERE(Status = FILTER(<> Terminated));
            RequestFilterFields = Departamento, "Job Type Code", Categoria, "Tipo Empleado", "Global Dimension 1 Code", "Global Dimension 2 Code";

            trigger OnAfterGetRecord()
            begin
                PrestMasivas.Init;
                PrestMasivas.Validate("Cod. Empleado", "No.");
                PrestMasivas.Validate("Termination Date", FechaEfectividad);
                PrestMasivas.Insert;
            end;

            trigger OnPostDataItem()
            begin
                Message(Msg001);
            end;

            trigger OnPreDataItem()
            begin
                if FechaEfectividad = 0D then
                    FechaEfectividad := Today
                else
                    if FechaEfectividad < Today then
                        Error(StrSubstNo(Err002, Today));

                if Employee.GetFilters() = '' then
                    Error(Err001);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(FechaEfectividad; FechaEfectividad)
                {
                    Caption = 'Application date';
                    ApplicationArea = Basic, Suite; // Se agrega ApplicationArea

                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if FechaEfectividad = 0D then
                FechaEfectividad := Today;
        end;
    }

    labels
    {
    }

    var
        Err001: Label 'Specify filter criteria for selection';
        Err002: Label 'Effective date cannot be earlier than %1';
        PrestMasivas: Record "Prestaciones masivas";
        FechaEfectividad: Date;
        Msg001: Label 'Selection process completed';
}

