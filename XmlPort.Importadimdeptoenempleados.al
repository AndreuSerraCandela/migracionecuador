xmlport 58012 "Importa dim depto en empleados"
{
    Format = VariableText;

    schema
    {
        textelement(ImportaDimDepartamento)
        {
            tableelement(Integer; Integer)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'DimDepartamento';
                textelement(CodEmpl)
                {
                }
                textelement(DimDepto)
                {
                }

                trigger OnBeforeInsertRecord()
                begin

                    if Empl.Get(CodEmpl) then begin
                        Empl.Validate("Global Dimension 1 Code", DimDepto);
                        Empl.Modify;
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
        Empl: Record Employee;
}

