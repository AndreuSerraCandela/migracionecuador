table 64834 "Scheduler Tag"
{

    fields
    {
        field(1; "Scheduler No."; Code[20])
        {
            TableRelation = Scheduler."No.";
        }
        field(2; "No."; Code[10])
        {
        }
        field(5; Value; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Scheduler No.", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

