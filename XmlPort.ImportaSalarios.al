xmlport 76001 "Importa Salarios"
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(ImportaSalarios)
        {
            tableelement(Integer; Integer)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'Salarios';
                textelement(NoEmp)
                {
                }
                textelement(Sueldo)
                {
                }

                trigger OnBeforeInsertRecord()
                begin


                    esqsal.Reset;
                    esqsal.SetRange("No. empleado", NoEmp);
                    esqsal.SetRange("Salario Base", true);
                    esqsal.FindSet();
                    repeat
                        esqsal.Cantidad := 1;
                        Evaluate(esqsal.Importe, Sueldo);
                        esqsal.Validate(Importe);
                        esqsal.Modify;
                    until esqsal.Next = 0;
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
        Empl: Record Employee;
        esqsal: Record "Perfil Salarial";
}

