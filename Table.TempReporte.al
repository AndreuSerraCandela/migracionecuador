table 56052 "Temp Reporte"
{

    fields
    {
        field(1; "Customer code"; Code[20])
        {
        }
        field(2; "Dimension Value"; Code[20])
        {
        }
        field(3; "Line No"; Integer)
        {
        }
        field(4; Name; Text[100])
        {
        }
        field(5; Date; Date)
        {
        }
        field(6; "Original Amount"; Decimal)
        {
            Caption = 'Original Amount';
        }
        field(7; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
    }

    keys
    {
        key(Key1; "Customer code", "Dimension Value", "Line No")
        {
            Clustered = true;
        }
        key(Key2; "Dimension Value")
        {
        }
    }

    fieldgroups
    {
    }
}

