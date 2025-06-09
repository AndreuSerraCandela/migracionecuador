pageextension 50079 pageextension50079 extends "Purchase Credit Memo"
{
    layout
    {
        modify("Posting Description")
        {
            Visible = true;
        }
        modify("Buy-from Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Buy-from City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
        }
        modify("Buy-from County")
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }
        modify("Buy-from Contact No.")
        {
            ToolTip = 'Specifies the number of your contact at the vendor.';
        }
        modify("Vendor Cr. Memo No.")
        {
            ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
        }
        modify("Payment Method Code")
        {
            ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
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
        modify("Tax Liable")
        {
            ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
        }
        modify(ShipToOptions)
        {
            ToolTip = 'Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company''s location addresses. Custom Address: Any ship-to address that you specify in the fields below.';
        }
        modify("Ship-to Name")
        {
            ToolTip = 'Specifies the name of the company at the address to which you want the items in the purchase order to be shipped.';
        }
        modify("Ship-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Ship-to City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }
        modify("Ship-to Contact")
        {
            ToolTip = 'Specifies the name of a contact person for the address where the items in the purchase order should be shipped.';
        }
        modify("Pay-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Pay-to City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
        }
        modify("Pay-to County")
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }
        modify("Pay-to Contact No.")
        {
            ToolTip = 'Specifies the number of the contact who sends the invoice.';
        }
        modify("Transport Method")
        {
            ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
        }
        modify("Area")
        {
            ToolTip = 'Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.';
        }
        modify("Applies-to Doc. Type")
        {
            ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
        }
        modify("Applies-to Doc. No.")
        {
            ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
        }
        modify("Applies-to ID")
        {
            ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
        }
        addafter("Vendor Cr. Memo No.")
        {
            field("No. Serie NCF Abonos"; rec."No. Serie NCF Abonos")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sustento del Comprobante"; rec."Sustento del Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Establecimiento; rec.Establecimiento)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Punto de Emision"; rec."Punto de Emision")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Caducidad"; rec."Fecha Caducidad")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Retencion"; rec."No. Serie NCF Retencion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Factura eletrónica"; rec."Factura eletrónica")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Aplica Retención"; rec."Aplica Retención")
            {
                ApplicationArea = Basic, Suite;
            }

            field("No. Validar Comprobante Rel."; rec."No. Validar Comprobante Rel.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Base Retencion Indefinida"; rec."Base Retencion Indefinida")
            {
                ApplicationArea = Basic, Suite;
            }
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
            field("Fecha vencimiento NCF"; rec."Fecha vencimiento NCF")
            {
                ApplicationArea = All;
            }
            field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
            {
                ApplicationArea = All;
            }
            field(Proporcionalidad; rec.Proporcionalidad)
            {
                ApplicationArea = All;
            }
        }
        // addafter("Tax Exemption No.")
        // {

        // }
    }
    actions
    {

        modify(Approve)
        {
            ToolTip = 'Approve the requested changes.';
        }
        modify(Comment)
        {
            ToolTip = 'View or add comments for the record.';
        }
        modify(Release)
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify(Reopen)
        {
            ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
        }
        modify("Copy Document")
        {
            ToolTip = 'Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.';
        }
        modify(SelectIncomingDoc)
        {
            ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
        }
        modify(IncomingDocAttachFile)
        {
            ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }
        /*      modify(CreateFlow)
             {
                 ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
             } */
        modify(TestReport)
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify(PostAndPrint)
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
        modify("Remove From Job Queue")
        {
            ToolTip = 'Remove the scheduled processing of this record from the job queue.';
        }

        //Code Modification on "Statistics(Action 49).OnAction".
        //CurrPage.PurchLines.PAGE.ForceTotalsCalculation;
        //Se había quitado esta línea pero ya cambio al metodo PurchaseStatics y no contiene esa línea

        addafter(Approvals)
        {
            separator(Action1000000007)
            {
            }
            action("<Action1000000004>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Retention';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Retencion Doc. Proveedores";
                RunPageLink =
                              "No. documento" = FIELD("No."),
                              "Tipo documento" = field("Document Type"),
                              "Cód. Proveedor" = FIELD("Buy-from Vendor No.");
            }
        }
    }
}

