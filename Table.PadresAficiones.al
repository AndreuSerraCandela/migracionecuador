table 76303 "Padres - Aficiones"
{

    fields
    {
        field(1; "Cod. Padre"; Code[20])
        {
            TableRelation = Padres;
        }
        field(2; "Nombre Padre"; Text[150])
        {
            CalcFormula = Lookup(Padres."Full name" WHERE(DNI = FIELD("Cod. Padre")));
            FieldClass = FlowField;
        }
        field(3; "Cod. aficion"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Aficiones));

            trigger OnValidate()
            begin
                if "Cod. aficion" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Aficiones);
                    DA.SetRange(Codigo, "Cod. aficion");
                    DA.FindFirst;
                    "Descripcion aficion" := DA.Descripcion;
                end;
            end;
        }
        field(4; "Descripcion aficion"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Padre", "Cod. aficion")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DA: Record "Datos auxiliares";
}

