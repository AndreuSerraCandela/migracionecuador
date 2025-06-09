table 64827 "Activity Register"
{
    //DrillDownPageID = 64827;
    //LookupPageID = 64827;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
        }
        field(3; "Scheduler No."; Code[20])
        {
            TableRelation = Scheduler."No.";
        }
        field(4; "Specification No."; Code[20])
        {
            TableRelation = Specification."No.";
        }
        field(5; "Replicator Group Code"; Code[20])
        {
            TableRelation = "Replicator Group".Code;
        }
        field(6; "Source Database"; Code[20])
        {
            TableRelation = DatabaseUPG.Code;
        }
        field(7; "Dest. Database"; Code[20])
        {
            TableRelation = DatabaseUPG.Code;
        }
        field(8; "Source Counter"; BigInteger)
        {
        }
        field(9; Company; Text[30])
        {
        }
        field(10; Date; Date)
        {
        }
        field(11; Time; Time)
        {
        }
        field(12; Error; Boolean)
        {
        }
        field(15; Text; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Specification No.", "Source Database", "Dest. Database", "Source Counter", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

