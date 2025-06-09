pageextension 50140 pageextension50140 extends "Sales Return Order List"
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
        modify("Salesperson Code")
        {
            ToolTip = 'Specifies which salesperson is associated with the shipment.';
        }
        modify("Payment Discount %")
        {
            ToolTip = 'Specifies the payment discount percentage that is granted if the customer pays on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.';
        }
        modify("Package Tracking No.")
        {
            ToolTip = 'Specifies the shipping agent''s package number.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Applies-to Doc. Type")
        {
            ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
        }
        addafter("Posting Description")
        {
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {

        modify(Release)
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify(Reopen)
        {
            ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';
        }
        modify("Send IC Return Order Cnfmn.")
        {
            Caption = 'Send IC Return Order Cnfmn.';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }
        modify("Create &Whse. Receipt")
        {
            Caption = 'Create &Whse. Receipt';
        }
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify("Post and &Print")
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
    }
}

