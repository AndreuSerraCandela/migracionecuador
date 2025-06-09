tableextension 50043 tableextension50043 extends "Check Ledger Entry"
{
    fields
    {
        modify("Bank Account Ledger Entry No.")
        {
            Caption = 'Bank Account Ledger Entry No.';
        }
        field(76041; Beneficiario; Text[250])
        {
            Caption = 'Beneficiary';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
    }
}

