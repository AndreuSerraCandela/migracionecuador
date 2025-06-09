pageextension 50059 pageextension50059 extends "Sales Invoice"
{
    layout
    {
        modify("Sell-to Address")
        {
            ToolTip = 'Specifies the address where the customer is located.';
        }
        modify("Sell-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Sell-to County")
        {
            ToolTip = 'Specifies the state, province or county of the address.';
        }
        modify("Sell-to Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("External Document No.")
        {
            ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        // modify("Tax Liable")
        // {
        //     ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
        // }
        // modify("Tax Area Code")
        // {
        //     ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
        // }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Location Code")
        {
            ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
        }
        modify("Ship-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the state, province or county of the address.';
        }
        modify("Ship-to Country/Region Code")
        {
            ToolTip = 'Specifies the customer''s country/region.';
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
        modify("Bill-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Bill-to County")
        {
            ToolTip = 'Specifies the state, province or county of the address.';
        }
        modify("Bill-to Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Transport Method")
        {
            ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
        }
        modify("Area")
        {
            ToolTip = 'Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.';
        }
        // modify("CFDI Export Code")
        // {
        //     Visible = false;
        // }
        // modify(ElectronicDocument)
        // {
        //     Visible = false;
        // }
        /*         modify("Transit-to Location")
                {
                    Visible = false;
                } */
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
        // modify(Control1310005)
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
        addfirst("Sell-to")
        {
            field("Sell-to Phone"; rec."Sell-to Phone")
            {
                ApplicationArea = All;
            }
        }
        addafter("External Document No.")
        {
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
                ApplicationArea = All;
            }
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                ApplicationArea = All;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
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
            }
        }
        addafter("Salesperson Code")
        {
            field("Establecimiento Factura"; rec."Establecimiento Factura")
            {
                ApplicationArea = All;
            }
            field("Punto de Emision Factura"; rec."Punto de Emision Factura")
            {
                ApplicationArea = All;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = All;
            }
            field("Tipo Documento SrI"; rec."Tipo Documento SrI")
            {
                ApplicationArea = All;
            }
            field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
            {
                ApplicationArea = All;
            }

        }
        addafter("Job Queue Status")
        {
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = All;
            }
            field("No. Serie NCF Remision"; rec."No. Serie NCF Remision")
            {
                ApplicationArea = All;
            }
        }
        // addafter("CFDI Relation")
        // {
        //     field(Correction; rec.Correction)
        //     {
        //         ApplicationArea = All;
        //     }
        //     field("No. Nota Credito a Anular"; rec."No. Nota Credito a Anular")
        //     {
        //         ApplicationArea = All;
        //     }
        //     field("Correlativo NCR a Anular"; rec."Correlativo NCR a Anular")
        //     {
        //         ApplicationArea = All;
        //     }
        //     field("Cod. Colegio"; rec."Cod. Colegio")
        //     {
        //         ApplicationArea = All;
        //     }
        // }
        addafter("Payment Terms Code")
        {
            field("Due Date2"; rec."Due Date")
            {
                Importance = Promoted;
                ApplicationArea = All;
            }
            field("Payment Discount %2"; rec."Payment Discount %")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shipping Agent Code")
        {
            field("Fecha inicio trans."; rec."Fecha inicio trans.")
            {
                ApplicationArea = All;
            }
            field("Fecha fin trans."; rec."Fecha fin trans.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Foreign Trade")
        {
            group("Datos Exportación")
            {
                Caption = 'Datos Exportación';
                field("Exportación"; rec.Exportación)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ActivaExportac;
                    end;
                }
                field("Valor FOB"; rec."Valor FOB")
                {
                    ApplicationArea = All;
                    Editable = bExportac;
                }
                field("Valor FOB Comprobante Local"; rec."Valor FOB Comprobante Local")
                {
                    ApplicationArea = All;
                    Editable = bExportac;
                }
                field("Tipo Exportacion"; rec."Tipo Exportacion")
                {
                    ApplicationArea = All;
                    Editable = bExportac;

                    trigger OnValidate()
                    begin
                        ActivaNoRefrendo;
                    end;
                }
                field("Con Refrendo"; rec."Con Refrendo")
                {
                    ApplicationArea = All;
                    Editable = bExportac;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ActivaNoRefrendo;
                    end;
                }
                field("No. refrendo - distrito adua."; rec."No. refrendo - distrito adua.")
                {
                    ApplicationArea = All;
                    Editable = bRefrendo;
                }
                field("No. refrendo - Año"; rec."No. refrendo - Año")
                {
                    ApplicationArea = All;
                    Editable = bRefrendo;
                }
                field("No. refrendo - regimen"; rec."No. refrendo - regimen")
                {
                    ApplicationArea = All;
                    Editable = bRefrendo;
                }
                field("No. refrendo - Correlativo"; rec."No. refrendo - Correlativo")
                {
                    ApplicationArea = All;
                    Editable = bRefrendo;
                }
                field("Fecha embarque"; rec."Fecha embarque")
                {
                    ApplicationArea = All;
                    Editable = bExportac;
                }
                field("Nº Documento Transporte"; rec."Nº Documento Transporte")
                {
                    ApplicationArea = All;
                    Editable = bRefrendo;
                }
            }
        }
    }
    actions
    {

        modify(Approve)
        {
            ToolTip = 'Approve the requested changes.';
        }
        modify(Comment)
        {
            ToolTip = 'View or add comments for the record.';
        }
        modify(Release)
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify(Reopen)
        {
            ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
        }
        modify(GetRecurringSalesLines)
        {
            ToolTip = 'Insert sales document lines that you have set up for the customer as recurring. Recurring sales lines could be for a monthly replenishment order or a fixed freight expense.';
        }
        modify(CopyDocument)
        {
            ToolTip = 'Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.';
        }
        modify(IncomingDocCard)
        {
            ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }
        /*         modify(CreateFlow)
                {
                    ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
                } */
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify("Remove From Job Queue")
        {
            ToolTip = 'Remove the scheduled processing of this record from the job queue.';
        }


        //Code Modification on "Statistics(Action 59).OnAction". cambio por "Sales Statistics"
        //CurrPage.SalesLines.PAGE.ForceTotalsCalculation;
        //Ya no existe la línea que se había quitado para Santillana
    }

    var
        bRefrendo: Boolean;

        bExportac: Boolean;

    procedure ActivaNoRefrendo()
    begin

        //+#34853
        //bRefrendo := ("Con Refrendo") AND (Exportación);
        bRefrendo := (rec."Tipo Exportacion" = rec."Tipo Exportacion"::"01") and (rec.Exportación);
        //-#34853
    end;

    procedure ActivaExportac()
    begin
        bExportac := rec.Exportación;
        ActivaNoRefrendo;
    end;
}

