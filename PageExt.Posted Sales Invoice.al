pageextension 50009 pageextension50009 extends "Posted Sales Invoice"
{

    PromotedActionCategories = 'New,Process,Report,Invoice,Correct,Print/Send,Navigate,Electronic Document';

    layout
    {
        modify("Sell-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Sell-to County")
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }
        modify("Document Exchange Status")
        {
            ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
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
        modify("Shipping Agent Code")
        {
            ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
        }
        modify("Package Tracking No.")
        {
            ToolTip = 'Specifies the shipping agent''s package number.';
        }
        modify("Ship-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }
        modify("Bill-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Bill-to County")
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }
        modify("Exit Point")
        {
            ToolTip = 'Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.';
        }
        // modify("CFDI Export Code")
        // {
        //     Visible = false;
        // }
        // modify("CFDI Cancellation Reason Code")
        // {
        //     Visible = false;
        // }
        // modify("Substitution Document No.")
        // {
        //     Visible = false;
        // }
        addfirst("Sell-to")
        {
            field("Sell-to Phone"; rec."Sell-to Phone")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter("Document Date")
        {
            field("Fecha entrega requerida"; rec."Fecha entrega requerida")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Order No.")
        {
            field("Tipo de ingreso"; rec."Tipo de ingreso")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Ultimo. No. NCF"; rec."Ultimo. No. NCF")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter("No. Printed")
        {
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Establecimiento Factura"; rec."Establecimiento Factura")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Punto de Emision Factura"; rec."Punto de Emision Factura")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Fecha Recepcion Documento"; rec."Fecha Recepcion Documento")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Aprobacion"; rec."Fecha Aprobacion")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Hora Aprobacion"; rec."Hora Aprobacion")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Fecha Creacion Pedido"; rec."Fecha Creacion Pedido")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Campaign No."; rec."Campaign No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Documento"; rec."Tipo Documento")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            /*        field("VAT Registration No."; rec."VAT Registration No.")
                   {
                       ApplicationArea = Basic, Suite;
                       Editable = false;
                   } */
            field("E-Mail"; rec."E-Mail")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Numero Guia"; rec."Numero Guia")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nombre Guia"; rec."Nombre Guia")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Grupo de Negocio"; rec."Grupo de Negocio")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Closed)
        {
            field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(SalesInvLines)
        {
            group(DsPOS)
            {
                Caption = 'DsPOS';
                Editable = false;
                field("Venta TPV"; rec."Venta TPV")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Tienda; rec.Tienda)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(TPV; rec.TPV)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Turno; rec.Turno)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("ID Cajero"; rec."ID Cajero")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Hora creacion"; rec."Hora creacion")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Anulado TPV"; rec."Anulado TPV")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Anulado por Documento"; rec."Anulado por Documento")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        addafter("Foreign Trade")
        {
            group("Datos Exportación")
            {
                Caption = 'Datos Exportación';
                field("Exportación"; rec.Exportación)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Valor FOB"; rec."Valor FOB")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Valor FOB Comprobante Local"; rec."Valor FOB Comprobante Local")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Con Refrendo"; rec."Con Refrendo")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("No. refrendo - distrito adua."; rec."No. refrendo - distrito adua.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("No. refrendo - Año"; rec."No. refrendo - Año")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("No. refrendo - regimen"; rec."No. refrendo - regimen")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("No. refrendo - Correlativo"; rec."No. refrendo - Correlativo")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Fecha embarque"; rec."Fecha embarque")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Nº Documento Transporte"; rec."Nº Documento Transporte")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000050; "FactBox FE")
            {
                SubPageLink = "No. documento" = FIELD("No.");
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify(Statistics)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        // modify("S&end")
        // {
        //     ToolTip = 'Send an email to the customer with the electronic invoice attached as an XML file.';
        // }
        modify(Print)
        {
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        modify(IncomingDocCard)
        {
            ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.';
        }
        modify("Update Document")
        {
            Visible = false;
        }
        addafter(ChangePaymentService)
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
                RunPageLink = "Tipo documento" = CONST(Factura),
                              "No. documento" = FIELD("No.");
                RunPageView = SORTING("Tipo documento", "No. documento");
            }
            separator(Action1000000004)
            {
            }
            action("Modificar Datos Exportación")
            {
                ApplicationArea = Basic, Suite;
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Datos Exportación - Factura";
                RunPageLink = "No." = FIELD("No.");
            }
        }
        addafter(Invoice)
        {
            group("<Action1000000005>")
            {
                Caption = 'Comprobantes electrónicos';
                action("Enviar comprobante electrónico")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Enviar comprobante electrónico';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    /*            trigger OnAction()
                               var
                                   cduFE: Codeunit "Comprobantes electronicos";
                               begin
                                   if Confirm(Text001, false, "No.") then
                                       cduFE.EnviarFactura(Rec, true);
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

                    /*                  trigger OnAction()
                                     var
                                         cduFE: Codeunit "Comprobantes electronicos";
                                     begin
                                         cduFE.ComprobarAutorizacion("No.", true, 0);
                                     end; */
                }
                action("Imprimir comprobante electrónico")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imprimir comprobante electrónico';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    /*               trigger OnAction()
                                  var
                                      cduFE: Codeunit "Comprobantes electronicos";
                                  begin
                                      cduFE.ImprimirDocumentoFE("No.");
                                  end */
                    ;
                }
            }
        }
    }

    var
        NoSerMagmnt: Codeunit "No. Series";
        txt0001: Label 'This reprint will void the actual correlative and will assing a new one %1. Confirm that you want to proceed';
        Text001: Label '¿Desea enviar la factura %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de la factura %1 en contingencia?';
}

