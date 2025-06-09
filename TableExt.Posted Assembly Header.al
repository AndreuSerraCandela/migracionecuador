tableextension 50171 tableextension50171 extends "Posted Assembly Header"
{
    fields
    {
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Item Rcpt. Entry No.")
        {
            Caption = 'Item Rcpt. Entry No.';
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
        field(56004; "Revertido completamente"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#14195';
        }
        field(56005; "Ultima Fecha Reversion"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(56006; "Ultimo Almacen Reversion"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '#36407';
        }
    }
}

