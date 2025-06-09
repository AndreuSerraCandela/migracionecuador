pageextension 50005 pageextension50005 extends "Vendor Posting Groups"
{
    layout
    {
        modify("Payables Account")
        {
            ToolTip = 'Specifies the general ledger account to use when you post payables due to vendors in this posting group.';
        }
        modify("Invoice Rounding Account")
        {
            ToolTip = 'Specifies the general ledger account to use when amounts result from invoice rounding when you post transactions that involve vendors.';
        }
        modify("Payment Tolerance Debit Acc.")
        {
            ToolTip = 'Specifies the general ledger account number to use when you post purchase tolerance amounts and payments for purchases. This applies to this particular combination of business posting group and product posting group.';
        }
        modify("Payment Tolerance Credit Acc.")
        {
            ToolTip = 'Specifies the general ledger account number to use when you post purchase tolerance amounts and payments for purchases. This applies to this particular combination of business posting group and product posting group.';
        }
        addafter(Description)
        {
            field("Permite Emitir NCF"; rec."Permite Emitir NCF")
            {
                ApplicationArea = Basic, Suite;
            }
            field("NCF Obligatorio"; rec."NCF Obligatorio")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Factura Compra"; rec."No. Serie NCF Factura Compra")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Abonos Compra"; rec."No. Serie NCF Abonos Compra")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purch. Credit Memo NCF Serial No.';
            }
            field(Internacional; rec.Internacional)
            {
            ApplicationArea = All;
            }
        }
    }
}

