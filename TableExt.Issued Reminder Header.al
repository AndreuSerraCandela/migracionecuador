tableextension 50050 tableextension50050 extends "Issued Reminder Header"
{
    fields
    {
        modify(Name)
        {
            Description = '#56924';
        }
        modify("Your Reference")
        {
            Caption = 'Customer PO No.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Fin. Charge Terms Code")
        {
            Caption = 'Fin. Charge Terms Code';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
    }
}

