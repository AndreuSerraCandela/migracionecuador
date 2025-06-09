pageextension 50017 pageextension50017 extends "Posted Sales Shipments"
{
    layout
    {
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
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        modify("Package Tracking No.")
        {
            ToolTip = 'Specifies the shipping agent''s package number.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        addfirst(Control1)
        {
            field("Order No."; rec."Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Bill-to Contact")
        {
            field("No. Serie NCF Remision"; rec."No. Serie NCF Remision")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fisc. Remision"; rec."No. Comprobante Fisc. Remision")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Location Code")
        {
            field("No. Autorizacion Remision"; rec."No. Autorizacion Remision")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000005; "FactBox FE")
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
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        modify("Update Document")
        {
            ToolTip = 'Add new information that is relevant to the document, such as information from the shipping agent. You can only edit a few fields because the document has already been posted.';
        }
        addafter(PrintCertificateofSupply)
        {
            separator(Action1000000006)
            {
            }
            action("<Action1000000010>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Movs. comprobrantes electrónicos';
                Image = Entries;
                RunObject = Page "Log comprobantes electronicos";
                RunPageLink = "Tipo documento" = CONST(Remision),
                              "No. documento" = FIELD("No.");
                RunPageView = SORTING("Tipo documento", "No. documento");
            }
        }
        // addafter("Shipping Labels")
        // {
        //     group("<Action1000000005>")
        //     {
        //         Caption = 'Comprobantes electrónicos';
        //         action("Enviar comprobante electrónico")
        //         {
        //             ApplicationArea = Basic, Suite;
        //             Caption = 'Enviar comprobante electrónico';
        //             Image = Export;
        //             Promoted = true;
        //             PromotedCategory = Category4;
        //             PromotedIsBig = false;

        //             /*                 trigger OnAction()
        //                             var
        //                                 cduFE: Codeunit "Comprobantes electronicos";
        //                             begin
        //                                 if Confirm(Text001, false, "No.") then
        //                                     cduFE.EnviarRemisionVenta(Rec, true);
        //                             end; */
        //         }
        //         action("Comprobar autorización")
        //         {
        //             ApplicationArea = Basic, Suite;
        //             Caption = 'Comprobar autorización';
        //             Image = Approve;
        //             Promoted = true;
        //             PromotedCategory = Category4;
        //             PromotedIsBig = false;

        //             /*               trigger OnAction()
        //                           var
        //                               cduFE: Codeunit "Comprobantes electronicos";
        //                           begin
        //                               cduFE.ComprobarAutorizacion("No.", true, 0);
        //                           end; */
        //         }
        //         action("Imprimir comprobante electrónico")
        //         {
        //             ApplicationArea = Basic, Suite;
        //             Caption = 'Imprimir comprobante electrónico';
        //             Image = Print;
        //             Promoted = true;
        //             PromotedCategory = Category4;
        //             PromotedIsBig = false;

        //             /*                     trigger OnAction()
        //                                 var
        //                                     cduFE: Codeunit "Comprobantes electronicos";
        //                                 begin
        //                                     cduFE.ImprimirDocumentoFE("No.");
        //                                 end; */
        //         }
        //     }
        // }
    }

    var
        Text001: Label '¿Desea enviar la remisión %1 al SRI?';
        Text002: Label '¿Desea emitir el comprobante de la remisión %1 en contingencia?';

    trigger OnOpenPage()
    var
        HasFilters: Boolean;
    begin
        HasFilters := Rec.GetFilters <> '';
        if HasFilters then
            if Rec.FindFirst then;
    end;
}

