pageextension 50078 pageextension50078 extends "Sales Lines"
{
    layout
    {
        // modify("Package Tracking No.")
        // {
        //     ToolTip = 'Specifies the shipping agent''s package number.';
        // }
        modify("Location Code")
        {
            ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Outstanding Quantity")
        {
            ToolTip = 'Specifies how many units on the order line have not yet been shipped.';
        }
        addafter("Outstanding Quantity")
        {
            field("Cantidad Aprobada"; rec."Cantidad Aprobada")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cantidad Solicitada"; rec."Cantidad Solicitada")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Show Document")
        {
            ToolTip = 'Open the document that the selected line exists on.';
        }
        modify("Reservation Entries")
        {
            ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';
        }
        modify("Item &Tracking Lines")
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
    }
}

