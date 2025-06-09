pageextension 50114 pageextension50114 extends "Sales Return Order"
{
    layout
    {
        modify("Sell-to County")
        {
            ToolTip = 'Specifies the State of the address.';
        }

        //Unsupported feature: Property Modification (ImplicitType) on ""Sell-to City"(Control 69)".

        modify("External Document No.")
        {
            ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
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
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
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
            ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area code for the customer.';
        }
        modify("Shipping Agent Code")
        {
            ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
        }
        modify("Shipping Agent Service Code")
        {
            ToolTip = 'Specifies which shipping agent service is used to transport the items on the sales document to the customer.';
        }
        modify("Package Tracking No.")
        {
            ToolTip = 'Specifies the shipping agent''s package number.';
        }
        modify("Location Code")
        {
            ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
        }
        modify("Ship-to Name")
        {
            ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
        }
        modify("Ship-to Address")
        {
            ToolTip = 'Specifies the address that products on the sales document will be shipped to.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the State of the address.';
        }

        //Unsupported feature: Property Modification (ImplicitType) on ""Ship-to City"(Control 38)".

        modify("Bill-to Name")
        {
            ToolTip = 'Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.';
        }
        modify("Bill-to Address")
        {
            ToolTip = 'Specifies the address of the customer that you will send the invoice to.';
        }
        modify("Bill-to County")
        {
            ToolTip = 'Specifies the State of the address.';
        }

        //Unsupported feature: Property Modification (ImplicitType) on ""Bill-to City"(Control 26)".

        modify("Transport Method")
        {
            ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
        }
        modify("Exit Point")
        {
            ToolTip = 'Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.';
        }
        modify("Area")
        {
            ToolTip = 'Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.';
        }
        addafter("Sell-to Contact")
        {
            field("No. Validar Comprobante Rel."; rec."No. Validar Comprobante Rel.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Responsibility Center")
        {
            field("No. documento Rem. a Anular"; rec."No. documento Rem. a Anular")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Abonos"; rec."No. Serie NCF Abonos")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Establecimiento Factura"; rec."Establecimiento Factura")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Location';
            }
            field("Punto de Emision Factura"; rec."Punto de Emision Factura")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Issue Point';
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fiscal Document No.';
            }
            field("Establecimiento Fact. Rel"; rec."Establecimiento Fact. Rel")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Punto de Emision Fact. Rel."; rec."Punto de Emision Fact. Rel.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Status)
        {
            field("Tipo Documento SrI"; rec."Tipo Documento SrI")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
            {
                ApplicationArea = Basic, Suite;
            }

        }
        // addafter("CFDI Relation")
        // {
        //     field("Cod. Colegio"; rec."Cod. Colegio")
        //     {
        //     ApplicationArea = All;
        //     }
        // }
        addafter("Ship-to Name")
        {
            field("Ship-to Code"; rec."Ship-to Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Bill-to Contact")
        {
            field("Sell-to Phone"; rec."Sell-to Phone")
            {
                ApplicationArea = Basic, Suite;
            }
            field("E-Mail"; rec."E-Mail")
            {
                ApplicationArea = Basic, Suite;
            }
        }
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
            ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';
        }
        modify("Apply Entries")
        {
            ToolTip = 'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.';
        }
        modify(CopyDocument)
        {
            ToolTip = 'Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.';
        }
        modify("Post and &Print")
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
        modify("Send IC Return Order Cnfmn.")
        {
            Caption = 'Send IC Return Order Cnfmn.';
            ToolTip = 'Prepare to send the return order confirmation to an intercompany partner.';
        }
        modify(Post)
        {
            ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
        }
        modify("Create &Whse. Receipt")
        {
            Caption = 'Create &Whse. Receipt';
        }
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
    }

    var



    //Unsupported feature: Code Modification on "PricesIncludingVATOnAfterValid(PROCEDURE 19009096)".

    //procedure PricesIncludingVATOnAfterValid();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CurrPage.SalesLines.PAGE.ForceTotalsCalculation;
    CurrPage.Update;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CurrPage.Update;
    */
    //end;

    procedure ActivaExportac()
    bExportac: Boolean;
    begin
        bExportac := rec.Exportación;
        ActivaNoRefrendo;
    end;

    procedure ActivaNoRefrendo()
    var
        bRefrendo: Boolean;
    begin

        bRefrendo := (rec."Con Refrendo") and (rec.Exportación);
    end;
}

