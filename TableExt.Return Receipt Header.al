tableextension 50136 tableextension50136 extends "Return Receipt Header"
{
    fields
    {
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

        //Unsupported feature: Property Modification (Data type) on ""VAT Registration No."(Field 70)".

        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
    }
}

