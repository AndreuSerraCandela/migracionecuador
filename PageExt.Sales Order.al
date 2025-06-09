pageextension 50054 pageextension50054 extends "Sales Order"
{
    //Unsupported feature: Property Insertion (InsertAllowed) on ""Sales Order"(Page 42)".

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

        //Unsupported feature: Property Modification (ImplicitType) on ""Sell-to City"(Control 86)".

        modify(Control123)
        {
            Description = 'IsSellToCountyVisible';
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
        modify("Package Tracking No.")
        {
            ToolTip = 'Specifies the shipping agent''s package number.';
        }
        modify("Bill-to Name")
        {
            Enabled = BillToOptions = BillToOptions::"Another Customer";
            Editable = BillToOptions = BillToOptions::"Another Customer";
        }
        modify("Bill-to Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }

        //Unsupported feature: Property Modification (ImplicitType) on ""Bill-to City"(Control 24)".

        modify("Bill-to County")
        {
            ToolTip = 'Specifies the state, province or county of the address.';
        }
        modify("Location Code")
        {
            ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
        }
        modify("Transport Method")
        {
            ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
        }
        modify("Area")
        {
            ToolTip = 'Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.';
        }

        //Unsupported feature: Property Deletion (Visible) on "Control123(Control 123)".

        // modify("CFDI Export Code")
        // {
        //     Visible = false;
        // }

        //Unsupported feature: Code Modification on ""Bill-to Name"(Control 18).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if not ((BillToOptions = BillToOptions::"Custom Address") and not ShouldSearchForCustByName) then begin
          if GetFilter("Bill-to Customer No.") = xRec."Bill-to Customer No." then
            if "Bill-to Customer No." <> xRec."Bill-to Customer No." then
              SetRange("Bill-to Customer No.");

          CurrPage.SaveRecord;
          if ApplicationAreaMgmtFacade.IsFoundationEnabled then
            SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

          CurrPage.Update(false);
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        if GetFilter("Bill-to Customer No.") = xRec."Bill-to Customer No." then
          if "Bill-to Customer No." <> xRec."Bill-to Customer No." then
            SetRange("Bill-to Customer No.");

        CurrPage.SaveRecord;
        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
          SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

        CurrPage.Update(false);
        */
        //end;

        // modify(ElectronicDocument)
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
        addafter("Sell-to Contact")
        {
            field("Sell-to Phone"; rec."Sell-to Phone")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to Phone"; rec."Ship-to Phone")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("No. of Archived Versions")
        {
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Establecimiento Factura"; rec."Establecimiento Factura")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Punto de Emision Factura"; rec."Punto de Emision Factura")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = All;
            }
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie NCF Remision"; rec."No. Serie NCF Remision")
            {
                ApplicationArea = Basic, Suite;
            }
            field("% de aprobacion"; rec."% de aprobacion")
            {
                ApplicationArea = Basic, Suite;
            }
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
            field("Numero Guia"; rec."Numero Guia")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nombre Guia"; rec."Nombre Guia")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Procesar EAN-Picking Masivo"; rec."Procesar EAN-Picking Masivo")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Estatus EAN-Picking Masivo"; rec."Estatus EAN-Picking Masivo")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Grupo de Negocio"; rec."Grupo de Negocio")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Order Date")
        {

        }
        addafter("Due Date")
        {

        }
        addafter("External Document No.")
        {
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
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = All;
            }
        }
        addafter("Ship-to Name")
        {
            field("Ship-to Phone2"; rec."Ship-to Phone")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        // addafter("Ship-to UPS Zone")
        // {
        //     field("Location Code2"; rec."Location Code")
        //     {
        //         ApplicationArea = Basic, Suite;
        //     }
        // }
        addafter("Shipping Agent Code")
        {
            field("Fecha inicio trans."; rec."Fecha inicio trans.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha fin trans."; rec."Fecha fin trans.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Control91)
        {
            field("Shipment Date2"; rec."Shipment Date")
            {
                ApplicationArea = Basic, Suite;
                Importance = Promoted;
            }
        }
        addafter("Foreign Trade")
        {
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
                field("Tipo Exportacion"; rec."Tipo Exportacion")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bExportac;

                    trigger OnValidate()
                    begin
                        //#34853
                        ActivaNoRefrendo;
                    end;
                }
                field("Con Refrendo"; rec."Con Refrendo")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = bExportac;
                    Visible = false;

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
                    Editable = bExportac;
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
        modify(CalculateInvoiceDiscount)
        {
            ToolTip = 'Calculate the invoice discount that applies to the sales order.';
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
        modify(OrderPromising)
        {
            ToolTip = 'Calculate the shipment and delivery dates based on the item''s known and expected availability dates, and then promise the dates to the customer.';
        }

        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }

        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify("Remove From Job Queue")
        {
            ToolTip = 'Remove the scheduled processing of this record from the job queue.';
        }
        // modify("Report Picking List by Order")
        // {
        //     Caption = 'Picking List by Order';
        // }



        // addafter("Report Picking List by Order")
        // {
        //     action("Exportar Excel Pedido Venta")
        //     {
        //     ApplicationArea = All;
        //         Image = Excel;

        //         trigger OnAction()
        //         var
        //             SalesHeader: Record "Sales Header";
        //         begin
        //             //002++
        //             SalesHeader := Rec;
        //             SalesHeader.SetRecFilter;
        //             REPORT.RunModal(REPORT::"Exportar a Excel Pedido Venta", true, false, SalesHeader);
        //             //002+-
        //         end;
        //     }
        // }
    }

    var
        "***Santillana****": Integer;
        SH: Record "Sales Header";
        GestBO: Boolean;
        AjusBO: Report "Ajusta Backorder";
        SalesLine: Record "Sales Line";
        ReleaseSalesDoc: Codeunit "Release Sales Document";

        bExportac: Boolean;


    trigger OnAfterGetCurrRecord()
    begin
        // Establecer la propiedad de edición dinámica
        // Lógica adicional para "Venta Call Center"
        if rec."Venta Call Center" then begin
            ShipToOptions := ShipToOptions::"Custom Address";
            BillToOptions := BillToOptions::"Custom Address";
        end;
    end;


    trigger OnClosePage()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        // Verificar si el flujo de trabajo de aprobaciones de ventas está habilitado
        if not ApprovalsMgmt.IsSalesApprovalsWorkflowEnabled(Rec) then begin
            // Filtrar líneas de ventas relevantes
            SalesLine.SETRANGE("Document Type", rec."Document Type");
            SalesLine.SETRANGE("Document No.", rec."No.");
            SalesLine.SETFILTER(Type, '>0');
            SalesLine.SETFILTER(Quantity, '<>0');

            // Si se encuentran líneas válidas, realizar la liberación manual del documento
            if SalesLine.FIND('-') then
                ReleaseSalesDoc.PerformManualRelease(Rec);
        end else
            // Verificar si es posible enviar una solicitud de aprobación
            if ApprovalsMgmt.CheckSalesApprovalPossible(Rec) then;
    end;








    procedure GestBackOrd(GestionBO_loc: Boolean)
    begin
        GestBO := GestionBO_loc;
    end;

    procedure ActivaNoRefrendo()
    begin

        //#34853
        //bRefrendo := ("Con Refrendo") AND (Exportación);
        bRefrendo := (rec."Tipo Exportacion" = rec."Tipo Exportacion"::"01") and (rec.Exportación);
    end;

    procedure ActivaExportac()
    begin
        bExportac := rec.Exportación;
        ActivaNoRefrendo;
    end;

    var
        bRefrendo: Boolean;
}

