pageextension 50019 pageextension50019 extends "Posted Sales Credit Memos"
{
    Caption = 'Posted Sales Credit Memos';
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
        modify("Applies-to Doc. Type")
        {
            ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
        }
        modify("Document Exchange Status")
        {
            StyleExpr = DocExchStatusStyle;
            Visible = DocExchStatusVisible;
            ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';
        }
        addfirst(Control1)
        {
            field("Venta TPV"; rec."Venta TPV")
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
            field("Return Order No."; rec."Return Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Sell-to Customer Name")
        {
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Punto de Emision Factura"; rec."Punto de Emision Factura")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Establecimiento Factura"; rec."Establecimiento Factura")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
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
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nombre Colegio"; rec."Nombre Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Posting Date")
        {
            field("No. Serie NCF Abonos"; rec."No. Serie NCF Abonos")
            {
                ApplicationArea = All;
                Caption = 'Credit Memo NCF Series Number';
            }
            field("Ultimo. No. NCF"; rec."Ultimo. No. NCF")
            {
                ApplicationArea = All;
            }
            field("Tipo de ingreso"; rec."Tipo de ingreso")
            {
                ApplicationArea = All;
            }
            field("Razon anulacion NCF"; rec."Razon anulacion NCF")
            {
                ApplicationArea = All;
                Caption = 'Void NCF Reason';
            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000026; "FactBox FE")
            {
                applicationArea = Basic, Suite;
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
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected posted sales document.';
        }
        // modify("Outstanding Sales Order Aging")
        // {
        //     ToolTip = 'View customer orders aged by their target shipping date. Only orders that have not been shipped appear on the report.';
        // }
        // modify("Outstanding Sales Order Status")
        // {
        //     ToolTip = 'View detailed outstanding order information for each customer. This report includes shipping information, quantities ordered, and the amount that is back ordered.';
        // }
        // modify("Daily Invoicing Report")
        // {
        //     ToolTip = 'View the total invoice or credit memo activity, or both. This report can be run for a particular day, or range of dates. The report shows one line for each invoice or credit memo. You can view the bill-to customer number, name, payment terms, salesperson code, amount, sales tax, amount including tax, and total of all invoices or credit memos.';
        // }
        // modify("&Print")
        // {
        //     ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        // }
        // addafter("&Cancel")
        // {
        //     separator(Action1000000007)
        //     {
        //     }
        //     action("<Action1000000010>")
        //     {
        //         ApplicationArea = Basic, Suite;
        //         Caption = 'Movs. comprobrantes electrónicos';
        //         Image = Entries;
        //         RunObject = Page "Log comprobantes electronicos";
        //         RunPageLink = "Tipo documento" = CONST(NotaCredito),
        //                       "No. documento" = FIELD("No.");
        //         RunPageView = SORTING("Tipo documento", "No. documento");
        //     }
        // }
        // addafter("Sales - Credit Memo")
        // {
        //     group("<Action1000000005>")
        //     {
        //         Caption = 'Comprobantes electrónicos';
        //         action("<Action1000000007>")
        //         {
        //             ApplicationArea = Basic, Suite;
        //             Caption = 'Enviar comprobante electrónico';
        //             Image = Export;
        //             Promoted = true;
        //             PromotedCategory = Category4;
        //             PromotedIsBig = false;

        //             /*              trigger OnAction()
        //                          var
        //                              cduFE: Codeunit "Comprobantes electronicos";
        //                          begin
        //                              if Confirm(Text001, false, "No.") then
        //                                  cduFE.EnviarNotaCredito(Rec, true);
        //                          end */
        //             ;
        //         }
        //         action("Comprobar autorización")
        //         {
        //             ApplicationArea = Basic, Suite;
        //             Caption = 'Comprobar autorización';
        //             Image = Approve;
        //             Promoted = true;
        //             PromotedCategory = Category4;
        //             PromotedIsBig = false;

        //             /*            trigger OnAction()
        //                        var
        //                            cduFE: Codeunit "Comprobantes electronicos";
        //                        begin
        //                            cduFE.ComprobarAutorizacion("No.", true, 0);
        //                        end; */
        //         }
        //         action("Imprimir comprobante electrónico")
        //         {
        //             ApplicationArea = Basic, Suite;
        //             Caption = 'Imprimir comprobante electrónico';
        //             Image = Print;
        //             Promoted = true;
        //             PromotedCategory = Category4;
        //             PromotedIsBig = false;

        //             /*            trigger OnAction()
        //                        var
        //                            cduFE: Codeunit "Comprobantes electronicos";
        //                        begin
        //                            cduFE.ImprimirDocumentoFE("No.");
        //                        end; */
        //         }
        //     }
        // }
    }

    var
        DocExchStatusVisible: Boolean;
        DocExchStatusStyle: Text;
        Text001: Label '¿Desea enviar la nota de crédito %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de la nota de crédito %1 en contingencia?';

    trigger OnAfterGetRecord()
    begin
        if DocExchStatusVisible then
            DocExchStatusStyle := Rec.GetDocExchStatusStyle();
    end;

    trigger OnOpenPage()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        HasFilters: Boolean;
    begin
        HasFilters := Rec.GetFilters() <> '';
        Rec.SetSecurityFilterOnRespCenter();
        if HasFilters and not Rec.Find() then
            if Rec.FindFirst() then;
        SalesCrMemoHeader.CopyFilters(Rec);
        SalesCrMemoHeader.SetFilter("Document Exchange Status", '<>%1', Rec."Document Exchange Status"::"Not Sent");
        DocExchStatusVisible := not SalesCrMemoHeader.IsEmpty();
    end;
}

