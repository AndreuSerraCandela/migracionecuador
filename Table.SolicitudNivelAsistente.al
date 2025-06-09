table 76285 "Solicitud -  Nivel Asistente"
{

    fields
    {
        field(1; "No. Solicitud"; Code[20])
        {
        }
        field(2; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Nivel Educativo APS";

            trigger OnValidate()
            var
                Nivel: Record "Nivel Educativo APS";
            begin
                if "Cod. Nivel" <> '' then begin
                    Nivel.Get("Cod. Nivel");
                    Descripción := Nivel.Descripción;
                end;
            end;
        }
        field(3; "Descripción"; Text[80])
        {
        }
        field(4; "No. Asistentes"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No. Solicitud", "Cod. Nivel")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

