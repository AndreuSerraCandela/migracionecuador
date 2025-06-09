tableextension 50105 tableextension50105 extends "Prod. Order Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 14)".

        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Expected Operation Cost Amt.")
        {
            Caption = 'Expected Operation Cost Amt.';
        }
        modify("Expected Component Cost Amt.")
        {
            Caption = 'Expected Component Cost Amt.';
        }
    }
}

