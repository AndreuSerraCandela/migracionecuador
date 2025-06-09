pageextension 50060 pageextension50060 extends "Sales Credit Memo"
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
        // modify("Tax Area Code")
        // {
        //     ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
        // }
        // modify("Tax Liable")
        // {
        //     ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
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
        addafter("Sell-to Customer Name")
        {
            field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Documento SrI"; rec."Tipo Documento SrI")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sell-to Phone"; rec."Sell-to Phone")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to Phone"; rec."Ship-to Phone")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("External Document No.")
        {
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Abonos"; rec."No. Serie NCF Abonos")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Establecimiento Factura"; rec."Establecimiento Factura")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Location';
            }
            field("Punto de Emision Factura"; rec."Punto de Emision Factura")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Issue Point';
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fiscal Document No.';
                Editable = true;
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
                Caption = 'Related FDN';
                Editable = true;
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
        // addafter("CFDI Relation")
        // {
        //     field("Cod. Colegio"; rec."Cod. Colegio")
        //     {
        //     ApplicationArea = All;
        //     }
        // }
        addafter(Billing)
        {
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to Name"; rec."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Ship-to Address"; rec."Ship-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Ship-to Phone2"; rec."Ship-to Phone")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to Address 2"; rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Ship-to City"; rec."Ship-to City")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to County"; rec."Ship-to County")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                // field("Ship-to UPS Zone"; rec."Ship-to UPS Zone")
                // {
                //     ApplicationArea = Basic, Suite;
                // }
            }
        }
        addafter("Foreign Trade")
        {
            group(Application)
            {
                Caption = 'Application';

            }
            group("Datos Exportación")
            {
                Caption = 'Datos Exportación';
                field("Exportación"; rec.Exportación)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        ActivaExportac;
                    end;
                }
                field("Valor FOB"; rec."Valor FOB")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bExportac;
                }
                field("Valor FOB Comprobante Local"; rec."Valor FOB Comprobante Local")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bExportac;
                }
                field("Con Refrendo"; rec."Con Refrendo")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bExportac;

                    trigger OnValidate()
                    begin
                        ActivaNoRefrendo;
                    end;
                }
                field("No. refrendo - distrito adua."; rec."No. refrendo - distrito adua.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bRefrendo;
                }
                field("No. refrendo - Año"; rec."No. refrendo - Año")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bRefrendo;
                }
                field("No. refrendo - regimen"; rec."No. refrendo - regimen")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bRefrendo;
                }
                field("No. refrendo - Correlativo"; rec."No. refrendo - Correlativo")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bRefrendo;
                }
                field("Fecha embarque"; rec."Fecha embarque")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bRefrendo;
                }
                field("Nº Documento Transporte"; rec."Nº Documento Transporte")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bRefrendo;
                }
            }
        }
    }
    actions
    {

        modify(Customer)
        {
            ToolTip = 'View or edit detailed information about the customer.';
        }
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
        modify(GetPostedDocumentLinesToReverse)
        {
            ToolTip = 'Copy one or more posted sales document lines in order to reverse the original order.';
        }
        modify(ApplyEntries)
        {
            ToolTip = 'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.';
        }
        modify(CopyDocument)
        {
            ToolTip = 'Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.';
        }
        modify(SelectIncomingDoc)
        {
            ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
        }
        modify(IncomingDocAttachFile)
        {
            ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }

        modify(TestReport)
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify("Remove From Job Queue")
        {
            ToolTip = 'Remove the scheduled processing of this record from the job queue.';
        }



    }

    var



    trigger OnAfterGetRecord()
    begin
        // Configurar la apariencia de los controles


        // Activar lógica adicional para exportación y refrendo
        ActivaNoRefrendo;
        ActivaExportac;
    end;

    trigger OnOpenPage()

    begin

        // Activar lógica adicional para exportación y refrendo
        ActivaNoRefrendo;
        ActivaExportac;
    end;

    procedure ActivaNoRefrendo()
    begin

        bRefrendo := (rec."Con Refrendo") and (rec.Exportación);
    end;

    procedure ActivaExportac()
    begin
        bExportac := rec.Exportación;
        ActivaNoRefrendo;
    end;

    var
        bExportac: Boolean;
        bRefrendo: Boolean;
}

