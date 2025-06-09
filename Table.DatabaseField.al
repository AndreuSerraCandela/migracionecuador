table 64829 "Database Field"
{
/*     DrillDownPageID = 64829;
    LookupPageID = 64829; */

    fields
    {
        field(1; "Database Code"; Code[20])
        {
        }
        field(2; "Table No."; Integer)
        {
        }
        field(3; "Field No."; Integer)
        {
        }
        field(10; "Field Name"; Text[30])
        {
        }
        field(11; "Field Type"; Option)
        {
            OptionMembers = ,Option,Boolean,"Integer",ShortInteger,Text,"Code",Date,Time,Decimal,Blob,DateFormula,Binary,TableFilter,BigInteger,Datetime,Duration,GUID,RecordID;
        }
        field(12; "Field Length"; Integer)
        {
        }
        field(13; "Field Option"; Text[80])
        {
        }
        field(14; "Field Class"; Option)
        {
            OptionMembers = ,Normal,FlowField,FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Database Code", "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

