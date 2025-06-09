pageextension 50107 pageextension50107 extends "Posted Transfer Shipments"
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
        addafter("No.")
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("Transfer Order No."; rec."Transfer Order No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = All;
            }
        }
        addafter("Receipt Date")
        {
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie Comprobante Fiscal"; rec."No. Serie Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000011; "FactBox FE")
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
        addafter(Dimensions)
        {
            separator(Action1000000000)
            {
            }
            action("<Action1000000010>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Movs. comprobrantes electrónicos';
                RunObject = Page "Log comprobantes electronicos";
                RunPageLink = "Tipo documento" = CONST(Remision),
                              "No. documento" = FIELD("No.");
                RunPageView = SORTING("Tipo documento", "No. documento");
            }
        }
        addafter("&Navigate")
        {
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

                    /*           trigger OnAction()
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

                    /*                   trigger OnAction()
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
                    /* 
                                        trigger OnAction()
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
        Text001: Label '¿Desea enviar la remisión %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de la remisión %1 en contingencia?';
}

