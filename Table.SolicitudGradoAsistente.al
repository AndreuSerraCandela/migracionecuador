table 76368 "Solicitud -  Grado Asistente"
{

    fields
    {
        field(1; "No. Solicitud"; Code[20])
        {
        }
        field(2; "Cod. Grado"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Grados));

            trigger OnValidate()
            var
                DA: Record "Datos auxiliares";
            begin
                if "Cod. Grado" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Grados);
                    DA.SetRange(Codigo, "Cod. Grado");
                    DA.FindFirst;
                    Descripción := DA.Descripcion;
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
        key(Key1; "No. Solicitud", "Cod. Grado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

