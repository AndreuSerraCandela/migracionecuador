pageextension 50018 pageextension50018 extends "Posted Sales Invoices"
{
    layout
    {
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
        modify("External Document No.")
        {
            ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
        }
        modify("Payment Discount %")
        {
            ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Document Exchange Status")
        {
            StyleExpr = DocExchStatusStyle;
            Visible = DocExchStatusVisible;
            ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';
        }
        /*         modify("Order No.")
                {
                    Visible = false;
                }
                modify("Posting Date")
                {
                    Visible = false;
                } */
        addfirst(Control1)
        {
            field("Venta TPV"; rec."Venta TPV")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Campaign No."; rec."Campaign No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field(TPV; rec.TPV)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Tienda; rec.Tienda)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("No.")
        {
            /*           field("Order No."; rec."Order No.")
              {
                  ApplicationArea = Basic, Suite;
              } */
            field("Hora creacion"; rec."Hora creacion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Hora Creacion Imp. Fiscal"; rec."Hora Creacion Imp. Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            /*          field("Posting Date"; rec."Posting Date")
             {
                 ApplicationArea = Basic, Suite;
             } */
            field("Posting Time"; rec."Posting Time")
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
            }
        }
        addafter("Sell-to Contact")
        {
            field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Documento"; rec."Tipo Documento")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            /*             field(Control1000000035; rec."Error Factura")
                {
                    AccessByPermission = TableData "Sales Invoice Header" = RIMDX;
                } */
            field("Establecimiento Factura"; rec."Establecimiento Factura")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Punto de Emision Factura"; rec."Punto de Emision Factura")
            {
                ApplicationArea = Basic, Suite;
            }
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        // addafter("Ship-to Name")
        // {
        //     field("Ship-to Address 2"; rec."Ship-to Address 2")
        //     {
        //         ApplicationArea = Basic, Suite;
        //     }
        // }
        addafter("Ship-to Contact")
        {
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
                Caption = 'Invoice NCF Series No.';
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                Caption = 'Fiscal Document No.';
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                Caption = 'Related Fiscal Doc. No.';
                ApplicationArea = Basic, Suite;
            }
            field("Ultimo. No. NCF"; rec."Ultimo. No. NCF")
            {
                Caption = 'Last NCF No.';
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("No. Printed")
        {
            field("Fecha entrega requerida"; rec."Fecha entrega requerida")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion Remision"; rec."No. Autorizacion Remision")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Document Date")
        {
            field("Fecha Recepcion Documento"; rec."Fecha Recepcion Documento")
            {
                ApplicationArea = Basic, Suite;
                Enabled = false;
            }
            field("Fecha Aprobacion"; rec."Fecha Aprobacion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Hora Aprobacion"; rec."Hora Aprobacion")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000034; "FactBox FE")
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
        // modify("S&end")
        // {
        //     ToolTip = 'Send an email to the customer with the electronic invoice attached as an XML file.';
        // }
        modify(Print)
        {
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify(Navigate)
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        addafter(Email)
        {
            action(Email2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send by &Email';
                Image = Email;
                ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    //001
                    ConfigSantillana.Get;
                    if not ConfigSantillana."Funcionalidad Imp. Fiscal Act." then begin
                        CurrPage.SetSelectionFilter(SalesInvHeader);
                        SalesInvHeader.PrintRecords(true);
                    end
                    else begin
                        Rec.CalcFields("Amount Including VAT");
                        if Rec."Amount Including VAT" <> 0 then begin
                            ConfigSantillana.TestField("Copia Fact. Imp. Fiscal Panama");
                            CurrPage.SetSelectionFilter(SalesInvHeader);
                            REPORT.RunModal(ConfigSantillana."Copia Fact. Imp. Fiscal Panama", true, false, SalesInvHeader);
                        end
                        else begin
                            ConfigSantillana.TestField("Impresion Muestras");
                            CurrPage.SetSelectionFilter(SalesInvHeader);
                            REPORT.RunModal(ConfigSantillana."Impresion Muestras", true, false, SalesInvHeader);
                        end;
                    end;
                    //001
                end;
            }
        }
        modify(Email)
        {
            Visible = false;
        }
        modify("Update Document")
        {
            Visible = false;
        }
        addafter(IncomingDoc)
        {
            separator(Action1000000005)
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

                    /*           trigger OnAction()
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
                    Caption = 'Imprimir comprobante electrónico';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    /*   trigger OnAction()
                      var
                          cduFE: Codeunit "Comprobantes electronicos";
                      begin
                          cduFE.ImprimirDocumentoFE("No.");
                      end; */
                }
                action("Error Factura")
                {
                    AccessByPermission = TableData "Sales Invoice Header" = RIMD;
                    Image = ErrorLog;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction()
                    begin
                        Clear(SelectedInvoiceNo);
                        SelectedInvoiceNo := Rec."No."; // Obtener el número seleccionado.
                        UpdateErrorFactura(SelectedInvoiceNo); // Llamar al procedimiento.
                    end;
                }
            }
        }
    }

    var
        DocExchStatusStyle: Text;
        DocExchStatusVisible: Boolean;
        ConfigSantillana: Record "Config. Empresa";
        Text001: Label '¿Desea enviar la factura %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de la factura %1 en contingencia?';
        LogerrorFact: Record "Log comprobantes electronicos";
        SelectedInvoiceNo: Code[20];

    trigger OnOpenPage()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        HasFilters: Boolean;
    begin
        HasFilters := Rec.GetFilters <> '';
        if HasFilters then
            if Rec.FindFirst then;
        SalesInvoiceHeader.CopyFilters(Rec);
        SalesInvoiceHeader.SetFilter("Document Exchange Status", '<>%1', Rec."Document Exchange Status"::"Not Sent");
        DocExchStatusVisible := not SalesInvoiceHeader.IsEmpty;
    end;

    trigger OnAfterGetRecord()
    begin
        if DocExchStatusVisible then
            DocExchStatusStyle := Rec.GetDocExchStatusStyle();
    end;

    local procedure UpdateErrorFactura(var SelectedInvoiceNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        LogerrorFact: Record "Log comprobantes electronicos";
    begin

        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", SelectedInvoiceNo);
        if SalesInvoiceHeader.FindFirst then begin
            LogerrorFact.Reset();
            LogerrorFact.SetCurrentKey("No. documento", Estado);
            LogerrorFact.SetRange("No. documento", SalesInvoiceHeader."No.");
            LogerrorFact.SetRange(Estado, LogerrorFact.Estado::Error);
            LogerrorFact.SetRange(Estado, LogerrorFact.Estado::Rechazado);
            LogerrorFact.SetRange(Estado, LogerrorFact.Estado::"No autorizado");

            if LogerrorFact.FindLast then
                SalesInvoiceHeader."Error Factura" := LogerrorFact."Respuesta SRI"
            else
                SalesInvoiceHeader."Error Factura" := '';

            SalesInvoiceHeader.Modify();
        end;
    end;
}

