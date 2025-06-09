tableextension 50125 tableextension50125 extends "Capacity Ledger Entry"
{
    fields
    {
        field(50100; "Description 2"; Text[160])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }

        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Work Center Group Code")
        {
            Caption = 'Work Center Group Code';
        }
    }
}

