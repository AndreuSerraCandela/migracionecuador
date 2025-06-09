pageextension 50026 pageextension50026 extends "G/L Account Card"
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
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
        }
        addafter("Direct Posting")
        {
            field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Gen. Prod. Posting Group")
        {
            field("Gen. Prod. Posting Group 2"; rec."Gen. Prod. Posting Group 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field("VAT Prod. Posting Group 2"; rec."VAT Prod. Posting Group 2")
            {
                ApplicationArea = All;
            }
            field("VAT Prod. Posting G. TipoITBIS"; rec."VAT Prod. Posting G. TipoITBIS")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        /*modify("E&xtended Text") //No existe la acción validar en Nav
        {
            ToolTip = 'View additional information about a general ledger account, this supplements the Description field.';
        }*/
        modify("G/L &Account Balance")
        {
            ToolTip = 'View a summary of the debit and credit balances for different time periods, for the account that you select in the chart of accounts.';
        }
        /*modify("Tax Posting Setup") //No existe la acción validar en Nav
        {
            ToolTip = 'View or edit combinations of Tax business posting groups and Tax product posting groups.';
        }*/
        modify("G/L Register")
        {
            ToolTip = 'View posted G/L entries.';
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

