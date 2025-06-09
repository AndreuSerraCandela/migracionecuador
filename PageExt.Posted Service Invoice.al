pageextension 50113 pageextension50113 extends "Posted Service Invoice"
{
    layout
    {
        modify(City)
        {
            ToolTip = 'Specifies the city of the address.';
        }
        modify(County)
        {
            ToolTip = 'Specifies the State in the customer''s address.';
        }
        modify("Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Document Exchange Status")
        {
            ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';
        }
        modify("Bill-to Customer No.")
        {
            ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
        }
        modify("Bill-to Name")
        {
            ToolTip = 'Specifies the name of the customer that you send or sent the invoice or credit memo to.';
        }
        modify("Bill-to Address")
        {
            ToolTip = 'Specifies the address of the customer to whom you sent the invoice.';
        }
        modify("Bill-to Address 2")
        {
            ToolTip = 'Specifies an additional line of the address.';
        }
        modify("Bill-to County")
        {
            ToolTip = 'Specifies the State in the customer''s address.';
        }
        modify("Bill-to Country/Region Code")
        {
            ToolTip = 'Specifies the country/region in the customer''s address.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Tax Liable")
        {
            ToolTip = 'Specifies if the customer is liable for sales tax.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the State in the customer''s address.';
        }
        modify("Ship-to Country/Region Code")
        {
            ToolTip = 'Specifies the country/region in the customer''s address.';
        }
        // modify("CFDI Export Code")
        // {
        //     Visible = false;
        // }
        // modify("CFDI Cancellation Reason Code")
        // {
        //     Visible = false;
        // }
        // modify("Substitution Document No.")
        // {
        //     Visible = false;
        // }
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
        modify("Service Document Lo&g")
        {
            ToolTip = 'View a list of the service document changes that have been logged. The program creates entries in the window when, for example, the response time or service order status changed, a resource was allocated, a service order was shipped or invoiced, and so on. Each line in this window identifies the event that occurred to the service document. The line contains the information about the field that was changed, its old and new value, the date and time when the change took place, and the ID of the user who actually made the changes.';
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

