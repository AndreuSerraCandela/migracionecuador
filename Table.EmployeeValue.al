table 76345 "Employee Value"
{
    Caption = 'Contact Value';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(2; Value; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Value';
        }
        field(3; "Last Date Updated"; Date)
        {
            Caption = 'Last Date Updated';
        }
        field(4; "Questions Answered (%)"; Decimal)
        {
            Caption = 'Questions Answered (%)';
        }
    }

    keys
    {
        key(Key1; "Employee No.")
        {
            Clustered = true;
        }
        key(Key2; Value)
        {
        }
    }

    fieldgroups
    {
    }
}

