pageextension 50011 pageextension50011 extends "Posted Sales Credit Memo"
{
    Caption = 'Posted Sales Credit Memo';
    layout
    {
        modify("Sell-to Customer Name")
        {
            Editable = true;
        }
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
        modify("Tax Liable")
        {
            ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
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
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = All;
                Caption = 'Fiscal Document No.';
            }
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                ApplicationArea = All;
                Caption = 'Retaled NCF document No.';
            }
            field("Tipo de ingreso"; rec."Tipo de ingreso")
            {
                ApplicationArea = All;
            }
            field("Ultimo. No. NCF"; rec."Ultimo. No. NCF")
            {
                ApplicationArea = All;
            }
            field("Razon anulacion NCF"; rec."Razon anulacion NCF")
            {
                ApplicationArea = All;
                Caption = 'NCF Void reason';
            }
        }
        addafter("Responsibility Center")
        {
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Establecimiento Factura"; rec."Establecimiento Factura")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Invoice Location';
                Editable = false;
            }
            field("Punto de Emision Factura"; rec."Punto de Emision Factura")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Invoice Issue Point';
                Editable = false;
            }
            field("Establecimiento Fact. Rel"; rec."Establecimiento Fact. Rel")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Punto de Emision Fact. Rel."; rec."Punto de Emision Fact. Rel.")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter("No. Printed")
        {
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = All;
            }
        }
        addafter(SalesCrMemoLines)
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
                field("Anula a Documento"; rec."Anula a Documento")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No. Comprobante Fiscal Rel.3"; rec."No. Comprobante Fiscal Rel.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. Comprobante Fiscal Rel.';
                }
            }
        }
        addafter("Shipping and Billing")
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
        addafter(IncomingDocAttachFactBox)
        {
            part(Control1000000041; "FactBox FE")
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
        // modify("Export E-Document as &XML")
        // {
        //     ToolTip = 'Export the posted sales credit memo as an electronic credit memo, an XML file, and save it to a specified location.';
        // }
        modify(Customer)
        {
            ToolTip = 'View or edit detailed information about the customer.';
        }
        modify(Print)
        {
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        modify(SelectIncomingDoc)
        {
            ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
        }
        modify(IncomingDocAttachFile)
        {
            ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';
        }
        addafter(DocAttach)
        {
            separator(Action1000000007)
            {
            }
            action("<Action1000000010>")
            {
                ApplicationArea = All;
                Caption = 'Movs. comprobrantes electrónicos';
                Image = Entries;
                RunObject = Page "Log comprobantes electronicos";
                RunPageLink = "Tipo documento" = CONST(NotaCredito),
                              "No. documento" = FIELD("No.");
                RunPageView = SORTING("Tipo documento", "No. documento");
            }
            separator(Action1000000006)
            {
            }
            action("Modificar Datos Exportación")
            {
                ApplicationArea = All;
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Datos Exportación - Nota Cr.";
                RunPageLink = "No." = FIELD("No.");
            }
        }
        addafter(IncomingDocument)
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

                    /*                trigger OnAction()
                                   var
                                       cduFE: Codeunit "Comprobantes electronicos";
                                   begin
                                       if Confirm(Text001, false, "No.") then
                                           cduFE.EnviarNotaCredito(Rec, true);
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
                    /* 
                                        trigger OnAction()
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
        Text001: Label '¿Desea enviar la nota de crédito %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de la nota de crédito %1 en contingencia?';
}

