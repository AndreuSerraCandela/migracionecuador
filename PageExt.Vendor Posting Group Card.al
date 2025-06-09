pageextension 50023 pageextension50023 extends "Vendor Posting Group Card"
{
    layout
    {
        addafter("Service Charge Acc.")
        {
            field("NCF Obligatorio"; rec."NCF Obligatorio")
            {
            ApplicationArea = All;
            }
            field("No. Serie NCF Factura Compra"; rec."No. Serie NCF Factura Compra")
            {
            ApplicationArea = All;
            }
            field("No. Serie NCF Abonos Compra"; rec."No. Serie NCF Abonos Compra")
            {
            ApplicationArea = All;
            }
            field(Internacional; rec.Internacional)
            {
            ApplicationArea = All;
            }
        }
    }
}

