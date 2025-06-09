report 76059 "Copia Esq. Salarios"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                Empl.Get(AEmpl);
                //Empl.TESTFIELD("Job Type Code");
                EsqSalFrom.SetRange("No. empleado", "No.");
                if EsqSalFrom.FindSet() then
                    repeat
                        EsqSalTo.Copy(EsqSalFrom);
                        EsqSalTo."No. empleado" := AEmpl;
                        EsqSalTo.Cargo := Empl."Job Type Code";
                        EsqSalTo.Cantidad := 0;
                        EsqSalTo.Importe := 0;
                        EsqSalTo.Insert(true);
                    until EsqSalFrom.Next = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("A empleado"; AEmpl)
                {
                ApplicationArea = All;
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
        Empl: Record Employee;
        EsqSalFrom: Record "Perfil Salarial";
        EsqSalTo: Record "Perfil Salarial";
        AEmpl: Code[20];
}

