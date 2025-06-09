table 76281 "Promotor - Niveles"
{
    DrillDownPageID = "Promotor - Niveles";
    LookupPageID = "Promotor - Niveles";

    fields
    {
        field(1; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE (Tipo = CONST (Vendedor));
        }
        field(2; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Nivel Educativo APS";

            trigger OnValidate()
            begin
                if "Cod. Nivel" <> '' then begin
                    Nivel.Get("Cod. Nivel");
                    "Descripcion Nivel" := Nivel.Descripción;
                end;
            end;
        }
        field(3; "Nombre Promotor"; Text[100])
        {
            CalcFormula = Lookup ("Salesperson/Purchaser".Name WHERE (Code = FIELD ("Cod. Promotor")));
            FieldClass = FlowField;
        }
        field(4; "Descripcion Nivel"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Promotor", "Cod. Nivel")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Nivel: Record "Nivel Educativo APS";
}

