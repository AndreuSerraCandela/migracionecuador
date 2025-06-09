pageextension 50116 pageextension50116 extends "Purchase Return Order"
{
    layout
    {
        modify("Buy-from Vendor No.")
        {
            ToolTip = 'Specifies the number of the vendor who returns the products.';
        }
        modify("Buy-from County")
        {
            ToolTip = 'Specifies the State of the address.';
        }
        modify("Buy-from Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Buy-from City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
        }
        modify("Buy-from Contact No.")
        {
            ToolTip = 'Specifies the number of your contact at the vendor.';
        }
        modify("Vendor Cr. Memo No.")
        {
            ToolTip = 'Specifies the number that the vendor uses for the credit memo you are creating in this purchase return order.';
        }
        modify("Prices Including VAT")
        {
            ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without tax.';
        }
        modify("VAT Bus. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
        }
        modify("Payment Terms Code")
        {
            ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
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
        modify("Tax Liable")
        {
            ToolTip = 'Specifies that purchases from the vendor on the purchase header are liable for sales tax.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area code used for this purchase to calculate and post sales tax.';
        }
        modify(ShipToOptions)
        {
            ToolTip = 'Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company''s location addresses. Custom Address: Any ship-to address that you specify in the fields below.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the State of the address.';
        }
        modify("Ship-to Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Ship-to City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
        }
        modify("Pay-to County")
        {
            ToolTip = 'Specifies the State of the address.';
        }
        modify("Pay-to Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Pay-to City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
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
        addafter("Purchaser Code")
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
            field("Posting Description"; rec."Posting Description")
            {
            ApplicationArea = All;
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
            ApplicationArea = All;
            }
            field("Aplica Retención"; rec."Aplica Retención")
            {
            ApplicationArea = All;
            }
            field("No. Validar Comprobante Rel."; rec."No. Validar Comprobante Rel.")
            {
            ApplicationArea = All;
            }
            field(Correction; rec.Correction)
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
        }
    }
    actions
    {
        modify(Vendor)
        {
            ToolTip = 'View or edit detailed information about the vendor on the purchase document.';
        }
        modify(Approve)
        {
            ToolTip = 'Approve the requested changes.';
        }
        modify(Comment)
        {
            ToolTip = 'View or add comments for the record.';
        }
        modify("&Print")
        {
            ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify("Re&lease")
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify(Reopen)
        {
            ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';
        }
        modify("Send IC Return Order")
        {
            Caption = 'Send IC Return Order';
            ToolTip = 'Prepare to send the return order to an intercompany partner.';
        }
        modify(Post)
        {
            ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
        }
        modify(TestReport)
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify(PostAndPrint)
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
        addafter(CopyDocument)
        {
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
            separator(Action1000000000)
            {
            }
        }
    }


    //Unsupported feature: Code Modification on "PricesIncludingVATOnAfterValid(PROCEDURE 19009096)".
    //No se puede quitar esta línea 
    //CurrPage.PurchLines.PAGE.ForceTotalsCalculation;
}

