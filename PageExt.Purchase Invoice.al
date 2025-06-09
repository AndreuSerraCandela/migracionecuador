pageextension 50074 pageextension50074 extends "Purchase Invoice"
{
    layout
    {
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
            ToolTip = 'Specifies the state, province or county of the address.';
        }
        modify("Buy-from Contact No.")
        {
            ToolTip = 'Specifies the number of your contact at the vendor.';
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
        modify("Pmt. Discount Date")
        {
            ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
        }
        modify("Tax Liable")
        {
            ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        modify(ShippingOptionWithLocation)
        {
            ToolTip = 'Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company''s location addresses. Custom Address: Any ship-to address that you specify in the fields below.';
        }
        modify("Ship-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the state, province or state of the address.';
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
            ToolTip = 'Specifies the state, province or state of the address.';
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

        addafter("Buy-from Vendor Name")
        {
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Buy-from Contact")
        {

            field("Base Retencion Indefinida"; rec."Base Retencion Indefinida")
            {
                ApplicationArea = Basic, Suite;
            }

        }
        addafter("Document Date")
        {
            field(Establecimiento; rec.Establecimiento)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Punto de Emision"; rec."Punto de Emision")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Desc. Tipo de Comprobante"; rec."Desc. Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Caption = ' ';
                Editable = false;
            }
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Factura eletrónica"; rec."Factura eletrónica")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Authorization Voucher No.';
            }
            field("Fecha Caducidad"; rec."Fecha Caducidad")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Retencion"; rec."No. Serie NCF Retencion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Aplica Retención"; rec."Aplica Retención")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Correction; rec.Correction)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Rappel; rec.Rappel)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Taller; rec.Taller)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Taller"; rec."Cod. Taller")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nombre Colegio"; rec."Nombre Colegio")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Document Date2"; rec."Document Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sustento del Comprobante"; rec."Sustento del Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Desc. Sustento Comprobante"; rec."Desc. Sustento Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Caption = ' ';
                Editable = false;
            }
            field("Vendor Invoice No.2"; rec."Vendor Invoice No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Purchaser Code")
        {
            field("Fecha vencimiento NCF"; rec."Fecha vencimiento NCF")
            {
            ApplicationArea = All;
            }
            field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
            {
            ApplicationArea = All;
            }
            field("Tipo ITBIS"; rec."Tipo ITBIS")
            {
            ApplicationArea = All;
            }
            field(Proporcionalidad; rec.Proporcionalidad)
            {
            ApplicationArea = All;
            }
        }
        addafter("Currency Code")
        {
            field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Control56)
        {
            field("Applies-to Doc. Type"; rec."Applies-to Doc. Type")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Applies-to Doc. No."; rec."Applies-to Doc. No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {

        modify(SelectIncomingDoc)
        {
            ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
        }
        modify(IncomingDocAttachFile)
        {
            ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';
        }
        modify(Approve)
        {
            ToolTip = 'Approve the requested changes.';
        }
        modify(Comment)
        {
            ToolTip = 'View or add comments for the record.';
        }
        modify("Re&lease")
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify(Reopen)
        {
            ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
        }
        modify(CalculateInvoiceDiscount)
        {
            ToolTip = 'Calculate the invoice discount for the entire purchase invoice.';
        }
        modify(GetRecurringPurchaseLines)
        {
            ToolTip = 'Insert purchase document lines that you have set up for the vendor as recurring. Recurring purchase lines could be for a monthly replenishment order or a fixed freight expense.';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }
        /*       modify(CreateFlow)
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
        modify(RemoveFromJobQueue)
        {
            ToolTip = 'Remove the scheduled processing of this record from the job queue.';
        }


        //Code Modification on "Statistics(Action 57).OnAction". Se cambio el metodo por PurchaseStatistics
        //CurrPage.PurchLines.PAGE.ForceTotalsCalculation;
        //Ya no existe esta línea 


        addafter(DocAttach)
        {
            action(Retenciones)
            {
            ApplicationArea = All;
                Caption = '&Retentinos';
                Image = CalculateCost;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Retencion Doc. Proveedores";
                RunPageLink = "Cód. Proveedor" = FIELD("Buy-from Vendor No."),
                              "Tipo documento" = field("Document Type"),
                              "No. documento" = FIELD("No.");
                RunPageView = SORTING("Cód. Proveedor", "Código Retención", "Tipo documento", "No. documento")
                              ORDER(Ascending);
            }
            separator(Action1000000006)
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
            action("Facturas de reembolso")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Facturas de reembolso';
                RunObject = Page "Facturas Reembolso";
                RunPageLink =
                              "Document No." = FIELD("No.");
            }
        }
        addafter(CancelApprovalRequest)
        {
            separator(Action1000000011)
            {
            }
            action(Excel)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Lines from Excel';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ImportaLineas: Report "Importa Lin. Compras";
                begin
                    ImportaLineas.RecibeParametros(1, rec."No.");
                    ImportaLineas.RunModal;
                end;
            }
            separator(Action1000000009)
            {
            }
            action("Importar Facturas de Reembolso")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Importar Facturas de Reembolso';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ImportaReembolso: Report "Importa Lin. Reembolso";
                    Err001: Label 'Esta acción solo se permite realizar si el documento tiene el Tipo de Comprobante  41.';
                begin

                    if rec."Tipo de Comprobante" <> '41' then
                        Error(Err001);
                    ImportaReembolso.RecibeParametros(1, rec."No.");
                    ImportaReembolso.RunModal;
                end;
            }
        }
    }
}

