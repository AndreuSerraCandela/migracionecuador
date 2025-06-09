pageextension 50134 pageextension50134 extends "Assembly Orders"
{
    layout
    {
        modify("Document Type")
        {
            ToolTip = 'Specifies the type of assembly document the record represents in assemble-to-order scenarios.';
        }
        modify("Assemble to Order")
        {
            ToolTip = 'Specifies if the assembly order is linked to a sales order, which indicates that the item is assembled to order.';
        }
        modify("Unit Cost")
        {
            ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
        }
    }
    actions
    {
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
        modify("Event")
        {
            ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
        }
        modify(Variant)
        {
            ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
        }
        modify(Statistics)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        modify(Release)
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify(Reopen)
        {
            ToolTip = 'Reopen the document for additional warehouse activity.';
        }
        modify("P&ost")
        {
            ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
        }
        modify("Post &Batch")
        {
            Visible = false;
        }

        addafter("Post &Batch")
        {
            action("Post &Batch2")
            {
                ApplicationArea = Assembly;
                Caption = 'Post &Batch';
                Ellipsis = true;
                Image = PostBatch;
                ToolTip = 'Post several documents at once. A report request window opens where you can specify which documents to post.';

                trigger OnAction()
                begin
                    REPORT.RunModal(REPORT::"Batch Post Assembly Orders EC", true, true, Rec); //001+-
                    CurrPage.Update(false);
                end;
            }
        }
        modify("Post &Batch_Promoted")
        {
            Visible = false;
        }
        addafter("Post &Batch_Promoted")
        {
            actionref("Post &Batch_Promoted2"; "Post &Batch2")
            {
            }
        }
    }
}

