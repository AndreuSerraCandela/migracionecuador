table 56005 "Nivel Educativo"
{
    DrillDownPageID = "Nivel Educativo";
    LookupPageID = "Nivel Educativo";

    fields
    {
        field(1; "Código"; Code[20])
        {
        }
        field(2; "Descripción"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Código")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Código", "Descripción")
        {
        }
    }
}

