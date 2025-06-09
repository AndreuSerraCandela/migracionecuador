table 64830 "Database Company"
{
/*     DrillDownPageID = 64830;
    LookupPageID = 64830; */

    fields
    {
        field(1; "Database Code"; Code[20])
        {
        }
        field(2; "Company Name"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Database Code", "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

