pageextension 50004 pageextension50004 extends "Customer Posting Groups"
{
    layout
    {
        modify("Receivables Account")
        {
            ToolTip = 'Specifies the general ledger account to use when you post receivables from customers in this posting group.';
        }
        modify("Service Charge Acc.")
        {
            ToolTip = 'Specifies the general ledger account to use when you post service charges for customers in this posting group.';
        }
        modify("Additional Fee Account")
        {
            ToolTip = 'Specifies the general ledger account to use when you post additional fees from reminders and finance charge memos for customers in this posting group.';
        }
        addafter(Description)
        {
            field("Permite emitir NCF"; rec."Permite emitir NCF")
            {
            ApplicationArea = All;
            }
            field("No. Serie NCF Factura Venta"; rec."No. Serie NCF Factura Venta")
            {
            ApplicationArea = All;
            }
            field("No. Serie NCF Abonos Venta"; rec."No. Serie NCF Abonos Venta")
            {
            ApplicationArea = All;
            }
        }
    }
}

