pageextension 50022 pageextension50022 extends "Customer Posting Group Card"
{
    layout
    {
        modify("Additional Fee Account")
        {
            ToolTip = 'Specifies the general ledger account to use when you post additional fees from reminders and finance charge memos for customers in this posting group.';
        }
        addafter("Service Charge Acc.")
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

