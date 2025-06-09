pageextension 50013 pageextension50013 extends "Posted Purchase Invoice"
{
    PromotedActionCategories = 'New,Process,Report,Correct,Invoice,Print/Send,Navigate';

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
            ToolTip = 'Specifies the state, province or county as a part of the address.';
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
        modify("Ship-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Ship-to City")
        {
            ToolTip = 'Specifies the city of the vendor on the purchase document.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
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
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }
        addafter("Buy-from Vendor Name")
        {
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Order No.")
        {
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Establecimiento; rec.Establecimiento)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Punto de Emision"; rec."Punto de Emision")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Sustento del Comprobante"; rec."Sustento del Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field(Rappel; rec.Rappel)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Vendor Order No.")
        {
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nombre Colegio"; rec."Nombre Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(Proporcionalidad; rec.Proporcionalidad)
            {
                ApplicationArea = All;
            }
        }
        addafter("Responsibility Center")
        {
            field(Taller; rec.Taller)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Payment Terms Code")
        {
            // field("Payment Method Code"; rec."Payment Method Code")
            // {
            //     ApplicationArea = Basic, Suite;
            // }
        }
        addafter("Shipping and Payment")
        {
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Liquidacion.""No. documento"""; Liquidacion."No. documento")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. Liquidacion';
                    Editable = false;
                }
                field("Liquidacion.""Estado autorizacion"""; Liquidacion."Estado autorizacion")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Estado Autorizacion';
                    Editable = false;
                }
                field("Liquidacion.""No. autorizacion"""; Liquidacion."No. autorizacion")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. Autorizacion';
                    Editable = false;
                }
            }
        }
        addafter(IncomingDocAttachFactBox)
        {
            part(Control1000000037; "FactBox FE")
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
        modify(Print)
        {
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify(Navigate)
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        modify(Vendor)
        {
            ToolTip = 'View or edit detailed information about the vendor on the purchase document.';
        }
        modify(SelectIncomingDoc)
        {
            ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
        }
        modify(IncomingDocAttachFile)
        {
            ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';
        }
        modify("Update Document")
        {
            ToolTip = 'Add new information that is relevant to the document, such as a payment reference. You can only edit a few fields because the document has already been posted.';
        }
        addfirst("&Invoice")
        {
            action("&Retentinos")
            {
                ApplicationArea = All;
                Caption = '&Retentinos';
                Image = CalculateCost;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Historico Retencion Prov.";
                RunPageLink = "Cód. Proveedor" = FIELD("Pay-to Vendor No."),
                              "Tipo documento" = FILTER(Invoice),
                              "No. documento" = FIELD("No.");
                RunPageView = SORTING("Tipo documento", "No. documento", "Código Retención")
                              ORDER(Ascending);
            }
        }
        addafter("&Invoice")
        {
            separator(Action1000000009)
            {
            }
            action("<Action1000000003>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Retention';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Ret. Documentos Registrados";
                RunPageLink = "No. documento" = FIELD("No."),
                              "Cód. Proveedor" = FIELD("Buy-from Vendor No.");
                RunPageView = SORTING("Cód. Proveedor", "Código Retención", "Tipo documento", "No. documento")
                              ORDER(Ascending);
            }
            separator(Action1000000007)
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
            separator(Action1000000005)
            {
            }
            action("Facturas Reembolso")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Facturas Reembolso';
                RunObject = Page "Facturas Reembolso";
                RunPageLink = "Document Type" = CONST(Invoice),
                              "Document No." = FIELD("No.");
            }
        }
        addafter(Print)
        {
            action("Imprimir &Retencion")
            {
                ApplicationArea = All;
                Caption = 'Imprimir &Retencion';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                //ConfSant: Codeunit "Configuracion Santandereana";
                //HRP: Record "HRP Retencion Proveedor";
                begin
                    //ConfSant.GET;
                    //ConfSant.TESTFIELD("ID Reporte Comprobante Ret.");
                    PurchInvHeader.Reset;
                    //PurchInvHeader.SETRANGE("Tipo documento","Tipo documento");
                    PurchInvHeader.SetRange("No.", rec."No.");
                    //HRP.SETRANGE("Código Retención","Código Retención");
                    PurchInvHeader.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                    REPORT.RunModal(55009, true, false, PurchInvHeader);
                end;
            }
        }
        addafter(Navigate)
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

                    trigger OnAction()
                    var

                    begin

                    end;
                }
                action("Comprobar autorización")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comprobar autorización';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var

                    begin

                    end;
                }
                action("Imprimir comprobante electrónico")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imprimir comprobante electrónico';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var

                    begin

                    end;
                }
            }
            group("<Action1000000006>")
            {
                Caption = 'Comprobantes electrónicos    Liquidacion';
                action("Enviar comprobante Liquidacion")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Enviar comprobante electrónico Liquidacion';
                    Enabled = LiquidacionEdit;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var

                    begin


                    end;
                }
                action("Comprobar autorización Liquidacion")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comprobar autorización Liquidacion';
                    Enabled = LiquidacionEdit;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var

                    begin

                    end;
                }
                action("Imprimir comprobante Liquidacion")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imprimir comprobante electrónico Liquidacion';
                    Enabled = LiquidacionEdit;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var

                    begin

                    end;
                }
            }
        }
    }

    var
        Liquidacion: Record "Documento FE";
        LiquidacionEdit: Boolean;
        Text001: Label '¿Desea enviar el comprobante de retención de la factura %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de la reténción de la factura %1 en contingencia?';
        Text003: Label '¿Desea enviar el comprobante de liquidación de la factura %1 ?';
        Text004: Label '¿Desea emitir el comprobante de la  liquidación de la factura %1 en contingencia?';

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Clear(Liquidacion);
        if Liquidacion.Get(Rec."No." + '-L') then;
        ValidateType;
    end;

    procedure ValidateType()
    begin
        if (rec."Tipo de Comprobante" = '41') or (rec."Tipo de Comprobante" = '03') then
            LiquidacionEdit := true
        else
            LiquidacionEdit := false;
    end;
}

