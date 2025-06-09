pageextension 50112 pageextension50112 extends "Posted Service Invoices"
{
    layout
    {
        modify("Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Bill-to Customer No.")
        {
            ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
        }
        modify("Bill-to Name")
        {
            ToolTip = 'Specifies the name of the customer that you send or sent the invoice or credit memo to.';
        }
        modify("Bill-to Country/Region Code")
        {
            ToolTip = 'Specifies the country/region code of the customer''s billing address.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Document Exchange Status")
        {
            ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';
        }
        addafter("Posting Date")
        {
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
            ApplicationArea = All;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
            ApplicationArea = All;
            }
            field("Fecha vencimiento NCF"; rec."Fecha vencimiento NCF")
            {
            ApplicationArea = All;
            }
            field("Tipo de ingreso"; rec."Tipo de ingreso")
            {
            ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(Statistics)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        modify("Update Document")
        {
            Visible = false;
        }
    }
}

