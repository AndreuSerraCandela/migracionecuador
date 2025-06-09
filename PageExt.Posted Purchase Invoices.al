pageextension 50020 pageextension50020 extends "Posted Purchase Invoices"
{
    layout
    {
        modify("Vendor Invoice No.")
        {
            ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
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
        modify("Posting Date")
        {
            ToolTip = 'Specifies the date the purchase header was posted.';
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
        addfirst(Control1)
        {
            field("User ID"; rec."User ID")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Currency Code")
        {
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Amount Including VAT")
        {
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = All;
            }
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                ApplicationArea = All;
            }
            field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
            {
                ApplicationArea = All;
            }
            field("Fecha vencimiento NCF"; rec."Fecha vencimiento NCF")
            {
                ApplicationArea = All;
            }
            field("Tipo de ingreso"; rec."Tipo de ingreso")
            {
                ApplicationArea = All;
            }
        }
        addafter("Buy-from Country/Region Code")
        {
            field("Sustento del Comprobante"; rec."Sustento del Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Aplica Retención"; rec."Aplica Retención")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000019; "FactBox FE")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No. documento" = FIELD("No.");
            }
        }
    }
    actions
    {
        modify(Statistics)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        modify(IncomingDoc)
        {
            ToolTip = 'View or create an incoming document record that is linked to the entry or document.';
        }
        modify("&Print")
        {
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        }
        // modify("Outstanding Purch. Order Aging")
        // {
        //     Caption = 'Outstanding Purch. Order Aging';
        // }
        modify(Vendor)
        {
            ToolTip = 'View or edit detailed information about the vendor on the purchase document.';
        }
        modify("Update Document")
        {
            ToolTip = 'Add new information that is relevant to the document, such as a payment reference. You can only edit a few fields because the document has already been posted.';
        }
        addafter("&Invoice")
        {
            separator(Action1000000006)
            {
            }
            action("Movs. comprobrantes electrónicos")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Movs. comprobrantes electrónicos';
                Image = Entries;
                RunObject = Page "Log comprobantes electronicos";
                RunPageLink = "Tipo documento" = CONST(Retencion),
                              "No. documento" = FIELD("No.");
                RunPageView = SORTING("Tipo documento", "No. documento");
            }
        }
        moveafter("Movs. comprobrantes electrónicos"; IncomingDoc)
        addafter("Update Document")
        {
            group("<Action1000000005>")
            {
                Caption = 'Comprobantes electrónicos';
                action("Enviar comprobante electrónico")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Enviar comprobante retención';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    /*              trigger OnAction()
                                 var
                                     cduFE: Codeunit "Comprobantes electronicos";
                                 begin
                                     if Confirm(Text001, false, "No.") then
                                         cduFE.EnviarComprobanteRetencionFac(Rec, true);
                                 end; */
                }
                action("Comprobar autorización")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comprobar autorización';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    /*              trigger OnAction()
                                 var
                                     cduFE: Codeunit "Comprobantes electronicos";
                                 begin
                                     cduFE.ComprobarAutorizacion("No.", true, 0);
                                 end; */
                }
                action("Imprimir comprobante electrónico")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imprimir comprobante electrónico retención';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    /*            trigger OnAction()
                               var
                                   cduFE: Codeunit "Comprobantes electronicos";
                               begin
                                   cduFE.ImprimirDocumentoFE("No.");
                               end; */
                }
            }
        }
    }

    var
        Text001: Label '¿Desea enviar el comprobante de retención de la factura %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de retención de la factura %1 en contingencia?';

    trigger OnOpenPage()
    var
        HasFilters: Boolean;
    begin
        HasFilters := Rec.GetFilters <> '';
        if HasFilters then
            if Rec.FindFirst then;
    end;
}

