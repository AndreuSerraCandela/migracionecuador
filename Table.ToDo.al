table 64826 ToDo
{

    fields
    {
        field(1; "Sender Database"; Code[20])
        {
            NotBlank = true;
            TableRelation = DatabaseUPG.Code;
        }
        field(2; "Entry No."; BigInteger)
        {
        }
        field(5; "Receiver Database"; Code[20])
        {
            NotBlank = true;
            TableRelation = DatabaseUPG.Code;
        }
        field(6; Processed; Boolean)
        {
        }
        field(7; Private; Boolean)
        {
        }
        field(8; "Action"; Option)
        {
            OptionMembers = Update,Add,Delete;
        }
        field(20; "ToDo Type"; Code[10])
        {
        }
        field(21; Message; Text[80])
        {
        }
        field(30; "Remark Table Name"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,Item,Resource,Job,,"Resource Group","Bank Account",Campaign;
        }
        field(31; "Remark No."; Code[20])
        {
        }
        field(32; "Remark Line No."; Integer)
        {
        }
        field(33; "Remark Date"; Date)
        {
        }
        field(34; "Remark Code"; Code[10])
        {
        }
        field(35; "Remark Comment"; Text[80])
        {
        }
        field(37; "Remark Comment No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Sender Database", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

