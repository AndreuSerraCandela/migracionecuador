tableextension 50172 tableextension50172 extends "Posted Assembly Line"
{
    fields
    {
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Item Shpt. Entry No.")
        {
            Caption = 'Item Shpt. Entry No.';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        field(56000; "Cantidad a Revertir"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '#14195';
        }
        field(56001; "Cantidad Revertida"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '#14195';
        }
        field(56002; "Cantidad (Base) a Revertir"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '#14195';
        }
        field(56003; "Cantidad (Base) Revertida"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '#14195';
        }
    }
}

