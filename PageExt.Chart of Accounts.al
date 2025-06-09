pageextension 50024 pageextension50024 extends "Chart of Accounts"
{
    layout
    {
        modify("Income/Balance")
        {
            ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
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
        modify("Debit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent debits.';
        }
        modify("Credit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent credits.';
        }
        modify("Consol. Debit Acc.")
        {
            ToolTip = 'Specifies the account number in a consolidated company to transfer credit balances.';
        }
        addafter("No.")
        {
            field(Indentation; rec.Indentation)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Consol. Translation Method")
        {
            field("Exchange Rate Adjustment"; rec."Exchange Rate Adjustment")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Date Filter"; rec."Date Filter")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Dimensions-&Multiple")
        {
            ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';
        }
        modify("Receivables-Payables")
        {
            ToolTip = 'View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.';
        }
        modify("G/L &Account Balance")
        {
            ToolTip = 'View a summary of the debit and credit balances for different time periods, for the account that you select in the chart of accounts.';
        }
        modify("G/L Balance by &Dimension")
        {
            ToolTip = 'View a summary of the debit and credit balances by dimensions for the current account.';
        }
        modify("G/L Register")
        {
            ToolTip = 'View posted G/L entries.';
        }
        modify(IndentChartOfAccounts)
        {
            ToolTip = 'Indent accounts between a Begin-Total and the matching End-Total one level to make the chart of accounts easier to read.';
        }
        modify(DocsWithoutIC)
        {
            ToolTip = 'Show a list of posted purchase and sales documents under the G/L account that do not have related incoming document records.';
        }
        modify(Action1900210206)
        {
            ToolTip = 'View posted G/L entries.';
        }
        // modify("Trial Balance Detail/Summary")
        // {
        //     ToolTip = 'View general ledger account balances and activities for all the selected accounts, one transaction per line. You can include general ledger accounts which have a balance and including the closing entries within the period.';
        // }
        // modify("Trial Balance, Spread G. Dim.")
        // {
        //     ToolTip = 'View the chart of accounts with balances or net changes, with each department in a separate column. This report can be used at the close of an accounting period or fiscal year.';
        // }
    }
}

