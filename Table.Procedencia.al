table 50130 Procedencia
{
/*     DrillDownPageID = 50031;
    LookupPageID = 50031; */

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

