table 64838 "Change Register"
{

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
        }
        field(2; "Specification No."; Code[20])
        {
            TableRelation = Specification."No.";
        }
        field(3; "Source Database"; Code[20])
        {
            TableRelation = DatabaseUPG.Code;
        }
        field(4; "Dest. Database"; Code[20])
        {
            TableRelation = DatabaseUPG.Code;
        }
        field(5; "Changes Made"; Option)
        {
            OptionMembers = ,update,add,delete;
        }
        field(6; "Table No."; Integer)
        {
        }
        field(7; "Table Name"; Text[30])
        {
        }
        field(8; "Key Fields Values"; Text[250])
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
        field(12; "Scheduler No."; Code[20])
        {
        }
        field(13; "User ID"; Code[10])
        {
        }
        field(15; "Field No."; Integer)
        {
        }
        field(16; "Field Name"; Text[30])
        {
        }
        field(20; "Old Value"; Text[250])
        {
        }
        field(21; "New Value"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Specification No.")
        {
        }
    }

    fieldgroups
    {
    }
}

