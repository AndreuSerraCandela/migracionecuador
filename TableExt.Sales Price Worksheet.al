tableextension 50140 tableextension50140 extends "Price Worksheet Line" //TableExt.Sales Price Worksheet
{
    fields
    {
        modify("VAT Bus. Posting Gr. (Price)")
        {
            Caption = 'Tax Bus. Posting Gr. (Price)';
        }
        modify(Description) //"Sales Description"
        {
            Description = '#56924';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
    }
}

