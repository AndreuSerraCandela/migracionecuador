tableextension 50123 tableextension50123 extends "Item Charge"
{
    fields
    {
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        field(55000; "Parte del IVA"; Boolean)
        {
            Caption = 'VAT part';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
    }
}

