table 50134 Cursos
{
/*     DrillDownPageID = 50030;
    LookupPageID = 50030; */

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
    }
}

