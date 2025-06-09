pageextension 50027 pageextension50027 extends "G/L Account List"
{
    layout
    {
        modify("Income/Balance")
        {
            ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
        }
        modify("VAT Bus. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
        }
        modify("VAT Prod. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
        }
        addafter("No.")
        {
            field(Indentation; rec.Indentation)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Reconciliation Account")
        {
            field("Date Filter"; rec."Date Filter")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("E&xtended Texts")
        {
            ToolTip = 'View additional information about a general ledger account, this supplements the Description field.';
        }
        modify("G/L &Account Balance")
        {
            ToolTip = 'View a summary of the debit and credit balances for different time periods, for the account that you select in the chart of accounts.';
        }
    }
}

