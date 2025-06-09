table 76097 "Areas de interes padres"
{
    Caption = 'Tandas';

    fields
    {
        field(1; "DNI Padre"; Code[20])
        {
            TableRelation = Padres;
        }
        field(2; "Cod. Area Interes"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Areas de interés"));

            trigger OnValidate()
            begin
                if "Cod. Area Interes" <> '' then begin
                    DA.Reset;
                    DA.Get(1, "Cod. Area Interes");
                    "Descripcion Area Interes" := DA.Descripcion;
                end;
            end;
        }
        field(3; "Nombre Padre"; Text[150])
        {
            CalcFormula = Lookup(Padres."Full name" WHERE(DNI = FIELD("DNI Padre")));
            FieldClass = FlowField;
        }
        field(4; "Descripcion Area Interes"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "DNI Padre", "Cod. Area Interes")
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

