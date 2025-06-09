xmlport 58010 "Importa cambios salario"
{
    Format = VariableText;

    schema
    {
        textelement(ImportaCambiosSalario)
        {
            tableelement(Integer; Integer)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'CambiosSalario';
                textelement(CodEmp)
                {
                }
                textelement(sal)
                {
                }

                trigger OnBeforeInsertRecord()
                begin

                    if Emp.Get(CodEmp) then begin
                        PerfSal.Reset;
                        PerfSal.SetRange("No. empleado", Emp."No.");
                        PerfSal.SetRange("Salario Base", true);
                        PerfSal.FindFirst;
                        Evaluate(PerfSal.Importe, sal);
                        PerfSal.Modify;
                    end;
                end;
            }
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

    var
        Emp: Record Employee;
        PerfSal: Record "Perfil Salarial";
}

