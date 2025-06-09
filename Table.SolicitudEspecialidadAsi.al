table 76371 "Solicitud -  Especialidad Asi."
{

    fields
    {
        field(1; "No. Solicitud"; Code[20])
        {
        }
        field(2; "Cod. Especialidad"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Especialidades));

            trigger OnValidate()
            var
                DA: Record "Datos auxiliares";
            begin
                if "Cod. Especialidad" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Especialidades);
                    DA.SetRange(Codigo, "Cod. Especialidad");
                    DA.FindFirst;
                    Descripción := DA.Descripcion;
                end;
            end;
        }
        field(3; "Descripción"; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "No. Solicitud", "Cod. Especialidad")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

