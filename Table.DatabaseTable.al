table 64828 "Database Table"
{
/*     DrillDownPageID = 64828;
    LookupPageID = 64828;
 */
    fields
    {
        field(1; "Database Code"; Code[20])
        {
        }
        field(2; "Table No."; Integer)
        {
        }
        field(10; "Table Name"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Database Code", "Table No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

