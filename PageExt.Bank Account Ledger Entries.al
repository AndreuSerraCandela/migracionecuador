pageextension 50047 pageextension50047 extends "Bank Account Ledger Entries"
{
    Caption = 'Bank Account Ledger Entries';
    layout
    {
        modify("Global Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        modify("Global Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        modify("Currency Code")
        {
            ToolTip = 'Specifies the currency that is used on the entry.';
        }
        modify("Debit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent debits.';
        }
        modify("Debit Amount (LCY)")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent debits, expressed in $.';
        }
        modify("Credit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent credits.';
        }
        modify("Dimension Set ID")
        {
            ToolTip = 'Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.';
        }
        addafter("Bank Account No.")
        {
            field(Beneficiario; rec.Beneficiario)
            {
            ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify("Check Ledger E&ntries")
        {
            Caption = 'Check Ledger E&ntries';
            ToolTip = 'View check ledger entries that result from posting transactions in a payment journal for the relevant bank account.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
    }
}

