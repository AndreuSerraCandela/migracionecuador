pageextension 50105 pageextension50105 extends "Posted Transfer Shipment"
{
    layout
    {
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
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        modify("Transfer-from Name 2")
        {
            ToolTip = 'Specifies an additional part of the name of the sender at the location that the items are transferred from.';
        }
        modify("Transfer-from Address 2")
        {
            ToolTip = 'Specifies an additional part of the address of the location that items are transferred from.';
        }
        modify("Transfer-to Name 2")
        {
            ToolTip = 'Specifies an additional part of the name of the recipient at the location that the items are transferred to.';
        }
        modify("Transport Method")
        {
            ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
        }
        modify("Partner VAT ID")
        {
            Visible = false;
        }
        // modify(ElectronicDocument)
        // {
        //     Visible = false;
        // }
        // modify("CFDI Export Code")
        // {
        //     Visible = false;
        // }
        // modify("Transport Operators")
        // {
        //     Visible = false;
        // }
        // modify("Transit-from Date/Time")
        // {
        //     Visible = false;
        // }
        // modify("Transit Hours")
        // {
        //     Visible = false;
        // }
        // modify("Transit Distance")
        // {
        //     Visible = false;
        // }
        // modify("Vehicle Code")
        // {
        //     Visible = false;
        // }
        // modify("Trailer 1")
        // {
        //     Visible = false;
        // }
        // modify("Trailer 2")
        // {
        //     Visible = false;
        // }
        // modify(Control1310010)
        // {
        //     Visible = false;
        // }
        // modify("Insurer Name")
        // {
        //     Visible = false;
        // }
        // modify("Insurer Policy Number")
        // {
        //     Visible = false;
        // }
        // modify("Medical Insurer Name")
        // {
        //     Visible = false;
        // }
        // modify("Medical Ins. Policy Number")
        // {
        //     Visible = false;
        // }
        // modify("SAT Weight Unit Of Measure")
        // {
        //     Visible = false;
        // }
        // modify("Electronic Document Status")
        // {
        //     Visible = false;
        // }
        // modify("Date/Time Stamped")
        // {
        //     Visible = false;
        // }
        // modify("Date/Time Canceled")
        // {
        //     Visible = false;
        // }
        // modify("Error Code")
        // {
        //     Visible = false;
        // }
        // modify("Error Description")
        // {
        //     Visible = false;
        // }
        // modify("PAC Web Service Name")
        // {
        //     Visible = false;
        // }
        // modify("Fiscal Invoice Number PAC")
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
        addafter("Shortcut Dimension 2 Code")
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
            field("Establecimiento Remision"; rec."Establecimiento Remision")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Punto de Emision Remision"; rec."Punto de Emision Remision")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000012; "FactBox FE")
            {
                SubPageLink = "No. documento" = FIELD("No.");
                applicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("&Print")
        {
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        // modify("&Electronic Document")
        // {
        //     Visible = false;
        // }
        // modify("S&end")
        // {
        //     Visible = false;
        // }
        // modify("Export E-Document as &XML")
        // {
        //     Visible = false;
        // }
        // modify("&Cancel")
        // {
        //     Visible = false;
        // }
        // modify("Print Carta Porte Document")
        // {
        //     Visible = false;
        // }
        addafter(Dimensions)
        {
            separator(Action1000000001)
            {
            }
            action("<Action1000000010>")
            {
                ApplicationArea = All;
                Caption = 'Movs. comprobrantes electrónicos';
                RunObject = Page "Log comprobantes electronicos";
                RunPageLink = "Tipo documento" = CONST(Remision),
                              "No. documento" = FIELD("No.");
                RunPageView = SORTING("Tipo documento", "No. documento");
            }
        }
        addafter("&Navigate")
        {
            action("<Action1000000005>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Consigment format';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ConfSant.Get;
                    ConfSant.TestField("ID Formato Imp. Consignacion");
                    CurrPage.SetSelectionFilter(TSH);
                    REPORT.RunModal(ConfSant."ID Formato Imp. Consignacion", true, false, TSH);
                end;
            }
            group("<Action1000060005>")
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

                    /*                     trigger OnAction()
                                        var
                                            cduFE: Codeunit "Comprobantes electronicos";
                                        begin
                                            if Confirm(Text001, false, "No.") then
                                                cduFE.EnviarRemisionTrans(Rec, true);
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

                    /*                trigger OnAction()
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
        "***Santillana***": Integer;
        ConfSant: Record "Config. Empresa";
        TSH: Record "Transfer Shipment Header";
        Text001: Label '¿Desea enviar la remisión %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de la remisión %1 en contingencia?';
}

