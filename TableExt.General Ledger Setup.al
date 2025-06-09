tableextension 50175 tableextension50175 extends "General Ledger Setup"
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Shortcut Dimension 3 Code")
        {
            Caption = 'Shortcut Dimension 3 Code';
        }
        modify("Shortcut Dimension 4 Code")
        {
            Caption = 'Shortcut Dimension 4 Code';
        }
        modify("Shortcut Dimension 5 Code")
        {
            Caption = 'Shortcut Dimension 5 Code';
        }
        modify("Shortcut Dimension 6 Code")
        {
            Caption = 'Shortcut Dimension 6 Code';
        }
        modify("Shortcut Dimension 7 Code")
        {
            Caption = 'Shortcut Dimension 7 Code';
        }
        modify("Shortcut Dimension 8 Code")
        {
            Caption = 'Shortcut Dimension 8 Code';
        }
        modify("Allow G/L Acc. Deletion Before")
        {
            Caption = 'Check G/L Acc. Deletion After';
        }
        modify("Check G/L Account Usage")
        {
            Caption = 'Check G/L Account Usage';
        }
        field(50000; "ITBIS al costo activo"; Boolean)
        {
            Caption = 'VAT to cost active';
            DataClassification = ToBeClassified;
        }
        field(56000; "Nombre Divisa Local"; Text[30])
        {
            Caption = 'Local Currency Description';
            DataClassification = ToBeClassified;
        }
    }
}

