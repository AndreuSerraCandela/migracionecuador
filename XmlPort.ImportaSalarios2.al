xmlport 76031 "Importa Salarios2"
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
                textelement(Basura1)
                {
                }
                textelement(Basura2)
                {
                }
                textelement(Ced)
                {
                }
                textelement(Basura3)
                {
                }
                textelement(Sueldo)
                {
                }
                textelement(Incentivo)
                {
                }
                textelement(SegMed)
                {
                }

                trigger OnBeforeInsertRecord()
                begin

                    Empl.SetRange("Document ID", Ced);
                    Empl.Find('-');
                    esqsal.Reset;
                    esqsal.SetRange("No. empleado", Empl."No.");
                    esqsal.SetRange("Salario Base", true);
                    esqsal.Find('-');
                    repeat
                        Evaluate(esqsal.Importe, Sueldo);
                        esqsal.Validate(Importe);
                        esqsal.Modify;
                    until esqsal.Next = 0;

                    esqsal.Reset;
                    esqsal.SetRange("No. empleado", Empl."No.");
                    esqsal.SetRange("Concepto salarial", 'ARS');
                    esqsal.Find('-');
                    repeat

                        Evaluate(esqsal.Importe, SegMed);
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

