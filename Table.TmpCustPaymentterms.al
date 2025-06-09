table 56009 "Tmp Cust. Payment terms"
{
    Caption = 'Temp Customer Payment Terms';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(2; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
    }

    keys
    {
        key(Key1; "Customer No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

