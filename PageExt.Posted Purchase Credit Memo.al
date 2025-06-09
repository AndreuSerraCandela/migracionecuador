pageextension 50016 pageextension50016 extends "Posted Purchase Credit Memo"
{
    Caption = 'Posted Purchase Credit Memo';
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
        // modify("Tax Liable")
        // {
        //     ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
        // }
        // modify("Tax Area Code")
        // {
        //     ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
        // }
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
        addafter("Vendor Cr. Memo No.")
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
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field(Proporcionalidad; rec.Proporcionalidad)
            {
                ApplicationArea = Basic, Suite;

            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000015; "FactBox FE")
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
        modify(Vendor)
        {
            ToolTip = 'View or edit detailed information about the vendor on the purchase document.';
        }
        modify("&Print")
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
        addafter(Approvals)
        {
            separator(Action1000000007)
            {
            }
            action("<Action1000000004>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Retention';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Ret. Documentos Registrados";
                RunPageLink = "Cód. Proveedor" = FIELD("Buy-from Vendor No."),
                              "No. documento" = FIELD("No.");
            }
            separator(Action1000000005)
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
        moveafter("Movs. comprobrantes electrónicos"; DocAttach)
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
        }
    }

    var
        Text001: Label '¿Desea enviar el comprobante de retención de la nota de crédito %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de la retención de la nota de crédito %1 en contingencia?';
}

