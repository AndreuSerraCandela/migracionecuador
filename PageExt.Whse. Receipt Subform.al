pageextension 50110 pageextension50110 extends "Whse. Receipt Subform"
{
    layout
    {
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        addfirst(Control1)
        {
            field("Nº Documento Proveedor"; rec."Nº Documento Proveedor")
            {
                ApplicationArea = Warehouse;
            }
        }
    }
    actions
    {
        modify("Event")
        {
            ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
        }
        modify(Variant)
        {
            ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
        }
        modify(ItemTrackingLines)
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
    }
}

