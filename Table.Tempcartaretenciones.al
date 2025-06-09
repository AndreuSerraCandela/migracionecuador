table 76355 "Temp carta retenciones"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; Description; Text[60])
        {
        }
        field(3; "Amount including vat"; Decimal)
        {
        }
        field(4; "Amount 10"; Decimal)
        {
        }
        field(5; "Amount 30"; Decimal)
        {
        }
        field(6; "Amount 100"; Decimal)
        {
        }
        field(7; Amount; Decimal)
        {
        }
        field(8; "Document date"; Date)
        {
        }
        field(9; "VAT Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

