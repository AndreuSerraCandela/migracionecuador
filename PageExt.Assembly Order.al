pageextension 50130 pageextension50130 extends "Assembly Order"
{
    layout
    {
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Assemble to Order")
        {
            ToolTip = 'Specifies if the assembly order is linked to a sales order, which indicates that the item is assembled to order.';
        }
        modify("Indirect Cost %")
        {
            ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
        }
        modify("Unit Cost")
        {
            ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
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
        modify("Item Tracking Lines")
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        modify(Action14)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        modify("Item Ledger Entries")
        {
            ToolTip = 'View the item ledger entries of the item on the document or journal line.';
        }
        modify("Capacity Ledger Entries")
        {
            ToolTip = 'View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).';
        }
        modify("Resource Ledger Entries")
        {
            ToolTip = 'View the ledger entries for the resource.';
        }
        modify("Value Entries")
        {
            ToolTip = 'View the value entries of the item on the document or journal line.';
        }
        modify("Reservation Entries")
        {
            ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';
        }
        modify("Re&lease")
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
            ApplicationArea = Basic, Suite, Assembly;
        }
        modify("Re&open")
        {
            ToolTip = 'Reopen the document for additional warehouse activity.';
        }
        modify("&Reserve")
        {
            ToolTip = 'Reserve the quantity that is required on the document line that you opened this window for.';
        }
        modify("Copy Document")
        {
            ToolTip = 'Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.';
        }
        modify("Order &Tracking")
        {
            ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.';
        }
        modify("P&ost")
        {
            ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
        }
    }
}

