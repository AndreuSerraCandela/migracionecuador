table 76388 "Hist. Docente - Aficiones"
{
    DrillDownPageID = "Docentes - Aficiones";
    LookupPageID = "Docentes - Aficiones";

    fields
    {
        field(1; "Cod. Docente"; Code[20])
        {
            TableRelation = Docentes;
        }
        field(2; "Nombre Docente"; Text[70])
        {
            CalcFormula = Lookup(Docentes."Full Name" WHERE("No." = FIELD("Cod. Docente")));
            FieldClass = FlowField;
        }
        field(3; "Cod. aficion"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Aficiones));

            trigger OnValidate()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::Aficiones);
                DA.SetRange(Codigo, "Cod. aficion");
                DA.FindFirst;
                "Descripcion aficion" := DA.Descripcion;
            end;
        }
        field(4; "Descripcion aficion"; Text[100])
        {
        }
        field(5; Campana; Integer)
        {
            Caption = 'Campaign';
        }
    }

    keys
    {
        key(Key1; Campana, "Cod. Docente", "Cod. aficion")
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

