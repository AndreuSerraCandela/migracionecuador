pageextension 50049 pageextension50049 extends "Item Ledger Entries"
{
    layout
    {
        modify("Global Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        modify("Global Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        modify("Drop Shipment")
        {
            ToolTip = 'Specifies if your vendor ships the items directly to your customer.';
        }
        modify("Prod. Order Comp. Line No.")
        {
            ToolTip = 'Specifies the line number of the production order component.';
        }
        modify("Job Task No.")
        {
            ToolTip = 'Specifies the number of the related job task.';
        }
        modify("Dimension Set ID")
        {
            ToolTip = 'Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.';
        }
        addafter(Quantity)
        {
            field("Cod. Procedencia"; rec."Cod. Procedencia")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        moveafter("Cod. Procedencia"; "Source Type", "Source No.")
        moveafter("Qty. per Unit of Measure"; "Unit of Measure Code")
        addafter("Dimension Set ID")
        {
            field(Correction; rec.Correction)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Applied E&ntries")
        {
            ToolTip = 'View the ledger entries that have been applied to this record.';
        }
        modify("Order &Tracking")
        {
            ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec.GetFilters <> '' then
            if Rec.FindFirst then;
    end;
}

