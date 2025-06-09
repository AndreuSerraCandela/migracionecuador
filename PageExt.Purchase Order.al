pageextension 50069 pageextension50069 extends "Purchase Order"
{
    layout
    {
        modify("Buy-from City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
        }
        modify("Buy-from County")
        {
            ToolTip = 'Specifies the state, province or county of the address.';
        }
        modify("Buy-from Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Posting Date")
        {
            ToolTip = 'Specifies the posting date of the record.';
        }
        modify("Vendor Invoice No.")
        {
            ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
        }
        modify("Vendor Order No.")
        {
            ToolTip = 'Specifies the vendor''s order number.';
        }
        modify(Status)
        {
            ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
        }
        modify("Expected Receipt Date")
        {
            ToolTip = 'Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date.';
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
            ToolTip = 'Specifies if this vendor charges you sales tax for purchases.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area code used for this purchase to calculate and post sales tax.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        modify("Ship-to City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the state, province or county of the address.';
        }
        modify("Pay-to Name")
        {
            Enabled = PayToOptions = PayToOptions::"Another Vendor";
            Editable = PayToOptions = PayToOptions::"Another Vendor";
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                //Cambio el if que entra de manera standar para que si no entro antes entre en este metodo
                if (PayToOptions = PayToOptions::"Custom Address") and not Rec.ShouldSearchForVendorByName(Rec."Buy-from Vendor No.") then begin
                    if Rec.GetFilter("Pay-to Vendor No.") = xRec."Pay-to Vendor No." then
                        if Rec."Pay-to Vendor No." <> xRec."Pay-to Vendor No." then
                            Rec.SetRange("Pay-to Vendor No.");

                    CurrPage.Update();
                end;
            end;
        }
        modify("Pay-to City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
        }
        modify("Pay-to County")
        {
            ToolTip = 'Specifies the state, province or county of the address.';
        }
        modify("Pay-to Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
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
        addafter("Document Date")
        {
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
            field("Factura eletrónica"; rec."Factura eletrónica")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Electronic bill';
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Authorization Voucher No.';
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
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Retencion"; rec."No. Serie NCF Retencion")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Rappel; rec.Rappel)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Taller; rec.Taller)
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Taller"; rec."Cod. Taller")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Payment Terms Code")
        {

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
        modify(Release)
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify(Reopen)
        {
            ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';
        }
        // modify("Import Electronic Invoice")
        // {
        //     ToolTip = 'Import an electronic invoice that is returned from PAC with a digital stamp.';
        // }
        modify(SelectIncomingDoc)
        {
            ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
        }
        /*        modify(CreateFlow)
               {
                   ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
               } */
        modify("Create &Whse. Receipt")
        {
            Caption = 'Create &Whse. Receipt';
        }
        modify("Post and &Print")
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify("&Print")
        {
            ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
        }


        //Code Modification on "Statistics(Action 63).OnAction". Cambio a PurchaseStatistics 
        //CurrPage.PurchLines.PAGE.ForceTotalsCalculation;
        //Ya no existe esta línea Validar

        addafter("Whse. Receipt Lines")
        {
            separator(Action1000000002)
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
            separator(Action1000000000)
            {
            }
            separator(Action1000000006)
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
            action("<Action1000000009>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Split Item charge';

                trigger OnAction()
                begin
                    CurrPage.PurchLines.PAGE.SplitIC;
                end;
            }
            separator(Action1000000003)
            {
            }
        }
    }
}

