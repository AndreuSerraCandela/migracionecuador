pageextension 50104 pageextension50104 extends "Transfer Orders"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Transfer Orders"(Page 5742)".


    //Unsupported feature: Property Insertion (SourceTableView) on ""Transfer Orders"(Page 5742)".

    layout
    {
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
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        addafter(Status)
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Receipt Date")
        {
            field(Despachado; rec.Despachado)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
    }
    actions
    {
        modify("In&vt. Put-away/Pick Lines")
        {
            ToolTip = 'View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.';
        }
        modify("&Print")
        {
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify("Re&lease")
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify("Reo&pen")
        {
            ToolTip = 'Reopen the transfer order after being released for warehouse handling.';
        }
        modify("Create &Whse. Receipt")
        {
            Caption = 'Create &Whse. Receipt';
        }
        modify("Get Bin Content")
        {
            ToolTip = 'Use a function to create transfer lines with items to put away or pick based on the actual content in the specified bin.';
        }
        modify(Post)
        {
            ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
        }
        modify(PostAndPrint)
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
    }
}

