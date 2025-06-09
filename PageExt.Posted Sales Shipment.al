pageextension 50008 pageextension50008 extends "Posted Sales Shipment"
{
    layout
    {
        modify("Sell-to County")
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }
        modify("Ship-to Country/Region Code")
        {
            ToolTip = 'Specifies the customer''s country/region.';
        }
        modify("Location Code")
        {
            ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the shipment method for the shipment.';
        }
        modify("Shipping Agent Code")
        {
            ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
        }
        modify("Shipping Agent Service Code")
        {
            ToolTip = 'Specifies which shipping agent service is used to transport the items on the sales document to the customer.';
        }
        modify("Package Tracking No.")
        {
            ToolTip = 'Specifies the shipping agent''s package number.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Bill-to County")
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
        // modify(ElectronicDocument)
        // {
        //     Visible = false;
        // }
        // modify("CFDI Export Code")
        // {
        //     Visible = false;
        // }
        // /*      modify("Transit-to Location")
        //      {
        //          Visible = false;
        //      } */
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
        // modify("Foreign Trade")
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
        addafter("External Document No.")
        {
            field("No. Comprobante Fisc. Remision"; rec."No. Comprobante Fisc. Remision")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Remission NCF';
                Editable = false;
            }
            field("No. Autorizacion Remision"; rec."No. Autorizacion Remision")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Tipo Comprobante Remision"; rec."Tipo Comprobante Remision")
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
        addafter("Responsibility Center")
        {
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
            field("Grupo de Negocio"; rec."Grupo de Negocio")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Shipping Agent Code")
        {
            field("Fecha inicio trans."; rec."Fecha inicio trans.")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Fecha fin trans."; rec."Fecha fin trans.")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000017; "FactBox FE")
            {
                SubPageLink = "No. documento" = FIELD("No.");
                applicationArea = Basic, Suite;
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
        // modify("Electronic Document")
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
        addafter(PrintCertificateofSupply)
        {
            separator(Action1000000001)
            {
            }
            action("<Action1000000010>")
            {
                ApplicationArea = All;
                Caption = 'Movs. comprobrantes electrónicos';
                Image = Entries;
                RunObject = Page "Log comprobantes electronicos";
                RunPageLink = "Tipo documento" = CONST(Remision),
                              "No. documento" = FIELD("No.");
                RunPageView = SORTING("Tipo documento", "No. documento");
            }
        }
        addafter("Update Document")
        {
            group("<Action1000000005>")
            {
                Caption = 'Comprobantes electrónicos';
                action("Enviar comprobante electrónico")
                {
                    ApplicationArea = All;
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
                                                cduFE.EnviarRemisionVenta(Rec, true);
                                        end; */
                }
                action("Comprobar autorización")
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
                    Caption = 'Imprimir comprobante electrónico';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    /*                 trigger OnAction()
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

