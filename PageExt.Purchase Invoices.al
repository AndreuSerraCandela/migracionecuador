pageextension 50142 pageextension50142 extends "Purchase Invoices"
{
    layout
    {
        modify("Buy-from Vendor No.")
        {
            ToolTip = 'Specifies the name of the vendor who delivered the items.';
        }
        modify("Buy-from Vendor Name")
        {
            ToolTip = 'Specifies the name of the vendor who delivered the items.';
        }
        modify("Buy-from Post Code")
        {
            ToolTip = 'Specifies the ZIP Code of the vendor who delivered the items.';
        }
        modify("Buy-from Country/Region Code")
        {
            ToolTip = 'Specifies the city of the vendor who delivered the items.';
        }
        modify("Buy-from Contact")
        {
            ToolTip = 'Specifies the name of the contact person at the vendor who delivered the items.';
        }
        modify("Pay-to Country/Region Code")
        {
            ToolTip = 'Specifies the country/region code of the address.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Payment Discount %")
        {
            ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        addafter("Location Code")
        {
            field("Responsibility Center"; rec."Responsibility Center")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Rappel; rec.Rappel)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Amount)
        {
            field("Amount Including VAT"; rec."Amount Including VAT")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {

        modify(Vendor)
        {
            ToolTip = 'View or edit detailed information about the vendor on the purchase document.';
        }
        modify(Release)
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify(Reopen)
        {
            ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }
        modify(TestReport)
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify(PostAndPrint)
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
        modify(RemoveFromJobQueue)
        {
            ToolTip = 'Remove the scheduled processing of this record from the job queue.';
        }
        addafter(CancelApprovalRequest)
        {
            action("Excel Import")
            {
            ApplicationArea = All;
                Caption = 'Excel Import';
                Ellipsis = true;
                Image = Excel;

                trigger OnAction()
                begin
                    //fes mig ReportImportfromExcel.RUNMODAL;
                end;
            }
        }
    }
}

