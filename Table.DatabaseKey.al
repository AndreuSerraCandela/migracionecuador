table 64831 "Database Key"
{
/*     DrillDownPageID = 64831;
    LookupPageID = 64831; */

    fields
    {
        field(1; "Database Code"; Code[20])
        {
        }
        field(2; "Table No."; Integer)
        {
        }
        field(3; "Key Sequence No."; Integer)
        {
        }
        field(10; "Key Field No."; Text[200])
        {
        }
        field(11; "Key Field Names"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Database Code", "Table No.", "Key Sequence No.", "Key Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

