pageextension 50006 pageextension50006 extends "General Ledger Setup"
{
    layout
    {
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Show Amounts")
        {
            Importance = Standard;
        }
        addafter(SEPAExportWoBankAccData)
        {
            field("ITBIS al costo activo"; rec."ITBIS al costo activo")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Cash Flow Setup")
        {
            ToolTip = 'Set up the accounts where cash flow figures for sales, purchase, and fixed-asset transactions are stored.';
        }
        modify("General Posting Setup")
        {
            ToolTip = 'Set up combinations of general business and general product posting groups by specifying account numbers for posting of sales and purchase transactions.';
        }
        modify("Gen. Business Posting Groups")
        {
            Caption = 'Gen. Business Posting Groups';
        }
        modify("Gen. Product Posting Groups")
        {
            Caption = 'Gen. Product Posting Groups';
        }
        modify("VAT Business Posting Groups")
        {
            Caption = 'VAT Business Posting Groups';
            ToolTip = 'Set up the trade-type posting groups that you assign to customer and vendor cards to link Tax amounts with the appropriate general ledger account.';
        }
        modify("VAT Product Posting Groups")
        {
            Caption = 'VAT Product Posting Groups';
        }
        modify("Bank Account Posting Groups")
        {
            Caption = 'Bank Account Posting Groups';
        }
        /*        modify("Intrastat Templates")
               {
                   ToolTip = 'Define how you want to set up and keep track of journals to report Intrastat.';
               } */
    }
}

