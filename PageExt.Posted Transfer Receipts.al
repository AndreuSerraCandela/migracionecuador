pageextension 50108 pageextension50108 extends "Posted Transfer Receipts"
{
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
        addafter("Transfer-from Code")
        {
            field("Transfer Order No."; rec."Transfer Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("&Print")
        {
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
    }
}

