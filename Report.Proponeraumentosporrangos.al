report 76254 "Proponer aumentos por rangos"
{
    Caption = 'Propose salary rise by ranges';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            CalcFields = Salario;
            DataItemTableView = WHERE(Status = FILTER(<> Terminated));

            trigger OnAfterGetRecord()
            begin
                if (Salario >= Desde) and (Salario <= Hasta) then begin
                    DiarioPromSal.Init;
                    DiarioPromSal.Validate("No. empleado", "No.");
                    DiarioPromSal."No. Linea" := 1000;
                    DiarioPromSal."Fecha Efectividad" := FechaEfectividad;
                    DiarioPromSal."Salario actual" := Salario;
                    DiarioPromSal."Nuevo salario" := NuevoSalario;
                    DiarioPromSal."Tipo Aumento" := DiarioPromSal."Tipo Aumento"::"Gral. por Rango de Salarios";
                    DiarioPromSal.Insert;
                end;
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
                field(Desde; Desde)
                {
                    Caption = 'From';
                    ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                }
                field(Hasta; Hasta)
                {
                    Caption = 'To';
                    ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                }
                field(NuevoSalario; NuevoSalario)
                {
                    Caption = 'New salary';
                    ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                }
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
    }

    labels
    {
    }

    var
        Err001: Label 'Specify month to run';
        Err002: Label 'Specify year to run';
        Err003: Label 'Specify the payroll key';
        Err004: Label 'Month can not be greather than 12';
        DiarioPromSal: Record "Diario de aumentos generales";
        Desde: Decimal;
        Hasta: Decimal;
        NuevoSalario: Decimal;
        FechaEfectividad: Date;
}