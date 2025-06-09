pageextension 50021 pageextension50021 extends "Posted Purchase Credit Memos"
{
    Caption = 'Posted Purchase Credit Memos';
    layout
    {
        modify("Buy-from Vendor No.")
        {
            ToolTip = 'Specifies the name of the vendor who delivered the items.';
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
        addafter(Paid)
        {
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = All;
            }
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Ship-to Post Code")
        {
            field("Pre-Assigned No."; rec."Pre-Assigned No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(IncomingDocAttachFactBox)
        {
            part(Control1000000009; "FactBox FE")
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
        // modify("Outstanding Purch. Order Aging")
        // {
        //     Caption = 'Outstanding Purch. Order Aging';
        // }
        addafter("&Cr. Memo")
        {
            separator(Action1000000003)
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
        addafter(Cancel)
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


                }
                action("Comprobar autorización")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comprobar autorización';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;


                }
                action("Imprimir comprobante electrónico")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imprimir comprobante electrónico';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                }
            }
        }
    }

    var
        Text001: Label '¿Desea enviar el comprobante de retención de la nota de crédito %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de retención de nota de crédito %1 en contingencia?';

    trigger OnOpenPage()
    var
        HasFilters: Boolean;
    begin
        HasFilters := Rec.GetFilters <> '';
        if HasFilters then
            if Rec.FindFirst then;
    end;
}

