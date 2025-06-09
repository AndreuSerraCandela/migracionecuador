pageextension 50062 pageextension50062 extends "Sales List"
{
    layout
    {
        modify("External Document No.")
        {
            ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
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
        modify("Location Code")
        {
            ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Sales Reservation Avail.")
        {
            ToolTip = 'View, print, or save an overview of availability of items for shipment on sales documents, filtered on shipment status.';
        }
    }
}

