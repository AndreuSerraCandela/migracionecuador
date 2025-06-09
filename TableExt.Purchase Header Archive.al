tableextension 50094 tableextension50094 extends "Purchase Header Archive"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name 2"(Field 6)".


        //Unsupported feature: Property Modification (Data type) on ""Pay-to Address 2"(Field 8)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name 2"(Field 14)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Address 2"(Field 16)".

        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Vendor Cr. Memo No.")
        {
            Caption = 'Vendor Cr. Memo No.';
        }

        //Unsupported feature: Property Modification (Data type) on ""VAT Registration No."(Field 70)".

        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }

        //Unsupported feature: Property Modification (Data type) on ""Buy-from Vendor Name 2"(Field 80)".


        //Unsupported feature: Property Modification (Data type) on ""Buy-from Address 2"(Field 82)".

        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("Prepmt. Pmt. Discount Date")
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
    }
}

