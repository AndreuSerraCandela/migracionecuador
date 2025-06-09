page 56022 "Sales Order PreSales"
{
    ApplicationArea = all;
    // Proyecto: Microsoft Dynamics Nav 2009 - Santillana
    // AMS     : Agustin Mendez
    // GRN     : Guillermo Roman
    // --------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     13-Sep-12       AMS           Funcionalidad de Prepedido
    // 002     03-Junio-09     AMS           Proceso para traer al pedido el inventario
    //                                       en consignacion en el cliente.
    // 003     16-Octubre-12   AMS           Mostrar el próximo numero de correlativo a utliizar
    // 004     04-Marzo-13     AMS           Importar lineas desde excel
    // 005     01-Junio-13     AMS           No se permite copiar lineas desde un pedido Consignacion
    // 006     15-02-2023      LDP           SANTINAV-4179: Se Agrega reporte Excel para importar lso datos del pedido.

    Caption = 'Sales Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Consignment,Category5,Category6,Category7,Category8,Category9,Category10';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = SORTING("Document Type", "No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(Order),
                            "Pre pedido" = FILTER(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No."; rec."Sell-to Contact No.")
                {
                    Importance = Additional;
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                }
                field("Sell-to Address"; rec."Sell-to Address")
                {
                    Importance = Additional;
                }
                field("Sell-to Address 2"; rec."Sell-to Address 2")
                {
                    Importance = Additional;
                }
                field("Sell-to City"; rec."Sell-to City")
                {
                }
                field("Sell-to County"; rec."Sell-to County")
                {
                    Caption = 'Sell-to State / ZIP Code';
                }
                field("Sell-to Post Code"; rec."Sell-to Post Code")
                {
                    Importance = Additional;
                }
                field("Tipo de Venta"; rec."Tipo de Venta")
                {
                }
                field("Sell-to Contact"; rec."Sell-to Contact")
                {
                    Importance = Additional;
                }
                field("No. of Archived Versions"; rec."No. of Archived Versions")
                {
                    Importance = Additional;
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Order Date"; rec."Order Date")
                {
                    Editable = false;
                    Importance = Promoted;
                    Visible = true;
                }
                field("Document Date"; rec."Document Date")
                {
                    Visible = false;
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                }
                field("Requested Delivery Date"; rec."Requested Delivery Date")
                {
                }
                field("Fecha Lanzado"; rec."Fecha Lanzado")
                {
                    Editable = false;
                }
                field("Hora Lanzado"; rec."Hora Lanzado")
                {
                    Editable = false;
                }
                field("Creado por usuario"; rec."Creado por usuario")
                {
                    Editable = false;
                }
                field("Promised Delivery Date"; rec."Promised Delivery Date")
                {
                    Importance = Additional;
                }
                field("Fecha Recepcion"; rec."Fecha Recepcion")
                {
                }
                field("Quote No."; rec."Quote No.")
                {
                    Importance = Additional;
                }
                field("Location Code"; rec."Location Code")
                {
                }
                field("Reason Code"; rec."Reason Code")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                    Importance = Promoted;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Nombre Vendedor"; rec."Nombre Vendedor")
                {
                    Editable = false;
                }
                field("Campaign No."; rec."Campaign No.")
                {
                    Importance = Additional;
                }
                field("Opportunity No."; rec."Opportunity No.")
                {
                    Importance = Additional;
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                    Importance = Additional;
                }
                field("Pedido Consignacion"; rec."Pedido Consignacion")
                {
                }
                field(Status; rec.Status)
                {
                    Importance = Promoted;
                }
                field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
                {
                    Caption = 'Invoice FDN Serial No.';

                    trigger OnValidate()
                    begin
                        //003
                        rec.CalcFields("Siguiente No.");
                        ProximoNo := rec."Siguiente No.";
                        ProximoNo := IncStr(ProximoNo);
                        //003
                    end;
                }
                field("Establecimiento Factura"; rec."Establecimiento Factura")
                {
                }
                field("Punto de Emision Factura"; rec."Punto de Emision Factura")
                {
                }
                field("No. Serie NCF Remision"; rec."No. Serie NCF Remision")
                {
                }
                field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
                {
                }
                field("Tipo Documento SrI"; rec."Tipo Documento SrI")
                {
                }
                field("VAT Registration No."; rec."VAT Registration No.")
                {
                }
                field("% de aprobacion"; rec."% de aprobacion")
                {
                }
                field(ProximoNo; ProximoNo)
                {
                    Caption = 'Next Invoice/Ticket No.';
                    Editable = false;
                }
                field("Customer Posting Group"; rec."Customer Posting Group")
                {
                }
                field("Responsibility Center"; rec."Responsibility Center")
                {
                    Editable = false;
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
            }
            part(SalesLines; "Sales Order Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; rec."Bill-to Contact No.")
                {
                    Importance = Additional;
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                }
                field("Bill-to Address"; rec."Bill-to Address")
                {
                    Importance = Additional;
                }
                field("Bill-to Address 2"; rec."Bill-to Address 2")
                {
                    Importance = Additional;
                }
                field("Bill-to City"; rec."Bill-to City")
                {
                }
                field("Bill-to County"; rec."Bill-to County")
                {
                    Caption = 'State / ZIP Code';
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                    Importance = Additional;
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {
                    Importance = Promoted;
                }
                field("Due Date"; rec."Due Date")
                {
                    Importance = Promoted;
                }
                field("Customer Posting Group2"; rec."Customer Posting Group")
                {
                }
                field("Payment Discount %"; rec."Payment Discount %")
                {
                }
                field("Pmt. Discount Date"; rec."Pmt. Discount Date")
                {
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {
                }
                field("Tax Liable"; rec."Tax Liable")
                {
                    Importance = Promoted;
                }
                field("Tax Area Code"; rec."Tax Area Code")
                {
                    Importance = Promoted;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; rec."Ship-to Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to Name"; rec."Ship-to Name")
                {
                }
                field("Ship-to Address"; rec."Ship-to Address")
                {
                    Importance = Additional;
                }
                field("Ship-to Address 2"; rec."Ship-to Address 2")
                {
                    Importance = Additional;
                }
                field("Ship-to City"; rec."Ship-to City")
                {
                }
                field("Ship-to County"; rec."Ship-to County")
                {
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {
                    Importance = Additional;
                }
                // field("Ship-to UPS Zone"; rec."Ship-to UPS Zone")
                // {
                // }
                field("Location Code2"; rec."Location Code")
                {
                }
                field("Outbound Whse. Handling Time"; rec."Outbound Whse. Handling Time")
                {
                    Importance = Additional;
                }
                field("Shipment Method Code"; rec."Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; rec."Shipping Agent Code")
                {
                    Importance = Additional;
                }
                field("Fecha inicio trans."; rec."Fecha inicio trans.")
                {
                }
                field("Fecha fin trans."; rec."Fecha fin trans.")
                {
                }
                field("Shipping Agent Service Code"; rec."Shipping Agent Service Code")
                {
                    Importance = Additional;
                }
                field("Shipping Time"; rec."Shipping Time")
                {
                }
                field("Late Order Shipping"; rec."Late Order Shipping")
                {
                    Importance = Additional;
                }
                field("Package Tracking No."; '')
                {
                    Importance = Additional;
                }
                field("Shipment Date2"; rec."Shipment Date")
                {
                    Importance = Promoted;
                }
                field("Shipping Advice"; rec."Shipping Advice")
                {
                    Importance = Promoted;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; rec."Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter(rec."Currency Code", rec."Currency Factor", rec."Posting Date");
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
                field("EU 3-Party Trade"; rec."EU 3-Party Trade")
                {
                }
                field("Transaction Type"; rec."Transaction Type")
                {
                }
                field("Transaction Specification"; rec."Transaction Specification")
                {
                }
                field("Transport Method"; rec."Transport Method")
                {
                }
                field("Exit Point"; rec."Exit Point")
                {
                }
                field("Area"; rec.Area)
                {
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                field("Prepayment %"; rec."Prepayment %")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        Prepayment37OnAfterValidate;
                    end;
                }
                field("Compress Prepayment"; rec."Compress Prepayment")
                {
                }
                field("Prepmt. Payment Terms Code"; rec."Prepmt. Payment Terms Code")
                {
                }
                field("Prepayment Due Date"; rec."Prepayment Due Date")
                {
                    Importance = Promoted;
                }
                field("Prepmt. Payment Discount %"; rec."Prepmt. Payment Discount %")
                {
                }
                field("Prepmt. Pmt. Discount Date"; rec."Prepmt. Pmt. Discount Date")
                {
                }
                // field("Prepmt. Include Tax"; rec."Prepmt. Include Tax")
                // {
                // }
            }
        }
        area(factboxes)
        {
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = true;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1906127307; "Sales Line FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = true;
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1906354007; "Approval FactBox")
            {
                SubPageLink = "Table ID" = CONST(36),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No."),
                              Status = CONST(Open);
                Visible = false;
            }
            part(Control1907012907; "Resource Details FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        rec.CalcInvDiscForHeader;
                        Commit;
                        if rec."Tax Area Code" = '' then
                            PAGE.RunModal(PAGE::"Sales Order Statistics", Rec);
                        // else
                        //     PAGE.RunModal(PAGE::"Sales Order Stats.", Rec)
                    end;
                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action("S&hipments")
                {
                    Caption = 'S&hipments';
                    RunObject = Page "Posted Sales Shipments";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                }
                action(Invoices)
                {
                    Caption = 'Invoices';
                    Image = Invoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                }
                action("Prepa&yment Invoices")
                {
                    Caption = 'Prepa&yment Invoices';
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action("Prepayment Credi&t Memos")
                {
                    Caption = 'Prepayment Credi&t Memos';
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action("A&pprovals")
                {
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.SetRecordFilters(DATABASE::"Sales Header", rec."Document Type", rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                separator(Action173)
                {
                }
                action("Whse. Shipment Lines")
                {
                    Caption = 'Whse. Shipment Lines';
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type" = CONST(37),

                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    Caption = 'In&vt. Put-away/Pick Lines';
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document" = CONST("Sales Order"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Document", "Source No.", "Location Code");
                }
                separator(Action120)
                {
                }
                action("Pla&nning")
                {
                    Caption = 'Pla&nning';

                    trigger OnAction()
                    var
                        SalesPlanForm: Page "Sales Order Planning";
                    begin
                        SalesPlanForm.SetSalesOrder(rec."No.");
                        SalesPlanForm.RunModal;
                    end;
                }
                action("Order &Promising")
                {
                    Caption = 'Order &Promising';

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "Order Promising Line" temporary;
                    begin
                        OrderPromisingLine.SetRange("Source Type", rec."Document Type");
                        OrderPromisingLine.SetRange("Source ID", rec."No.");
                        PAGE.RunModal(PAGE::"Order Promising Lines", OrderPromisingLine);
                    end;
                }
                separator(Action258)
                {
                }
                action("Credit Cards Transaction Lo&g Entries")
                {
                    Caption = 'Credit Cards Transaction Lo&g Entries';
                    /*RunObject = Page Page829; No existe ya esa pagina en Nav tampoco 
                    RunPageLink = Field2 = FIELD("Document Type"),
                                  Field3 = FIELD("No."),
                                  Field4 = FIELD("Bill-to Customer No.");*/
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Calculate &Invoice Discount")
                {
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                separator(Action172)
                {
                }
                action("Get St&d. Cust. Sales Codes")
                {
                    Caption = 'Get St&d. Cust. Sales Codes';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        StdCustSalesCode: Record "Standard Customer Sales Code";
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }
                separator(Action171)
                {
                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        rec.TestField("Pedido Consignacion", false);//005
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RunModal;
                        Clear(CopySalesDoc);
                    end;
                }
                action("Archi&ve Document")
                {
                    Caption = 'Archi&ve Document';

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchiveSalesDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action("Move Negative Lines")
                {
                    Caption = 'Move Negative Lines';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        Clear(MoveNegSalesLines);
                        MoveNegSalesLines.SetSalesHeader(Rec);
                        MoveNegSalesLines.RunModal;
                        MoveNegSalesLines.ShowDocument;
                    end;
                }
                separator(Action195)
                {
                }
                action("Create &Whse. Shipment")
                {
                    Caption = 'Create &Whse. Shipment';

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromSalesOrder(Rec);

                        if not rec.Find('=><') then
                            rec.Init;
                    end;
                }
                action("Create Inventor&y Put-away / Pick")
                {
                    Caption = 'Create Inventor&y Put-away / Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        rec.CreateInvtPutAwayPick;

                        if not rec.Find('=><') then
                            rec.Init;
                    end;
                }
                separator(Action174)
                {
                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                        "Release Sales Document": Codeunit "Release Sales Document";
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN; //MIGEC
                        if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                            ApprovalMgt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                        "Release Sales Document": Codeunit "Release Sales Document";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN; //MIGEC
                        ApprovalMgt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(rec.RecordId);
                    end;
                }
                separator(Action175)
                {
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
                separator(Action608)
                {
                }
                action(Authorize)
                {
                    Caption = 'Authorize';

                    trigger OnAction()
                    begin
                        //fes mig Authorize;
                    end;
                }
                action("Void A&uthorize")
                {
                    Caption = 'Void A&uthorize';

                    trigger OnAction()
                    begin
                        //fes mig Void;
                    end;
                }
                separator(Action1000000015)
                {
                }
                action("Get Consignment Inventory")
                {
                    Caption = 'Get Consignment Inventory';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        //002
                        rec.TestField("Pedido Consignacion");
                        cFunSantillana.RecibeNoDoc(rec."No.");
                        cFunSantillana.InvConsPedidoVenta(rec."Sell-to Customer No.");
                        CurrPage.Update;
                        //002
                    end;
                }
                separator(Action1000000002)
                {
                }
                action("Make &Order")
                {
                    Caption = 'Make &Order';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalMgt.PrePostApprovalCheckSales(Rec) then
                            CODEUNIT.Run(CODEUNIT::"PreSales-Ord. to Ord. (Yes/No)", Rec);
                    end;
                }
                separator(Action1000000010)
                {
                }
                action("&UpLoad Order From Excel")
                {
                    Caption = '&UpLoad Order From Excel';
                    Image = ImportExport;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //004
                        Clear(ImportLineas);
                        ImportLineas.RecibeNoPedido(rec."No.");
                        ImportLineas.RunModal;
                        //004
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN //MIGEC
                        if ApprovalMgt.PrePostApprovalCheckSales(Rec) then begin
                            //IF ApprovalMgt.TestSalesPrepayment(Rec) THEN //MIGEC
                            if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                                Error(StrSubstNo(Text001, rec."Document Type", rec."No."))
                            else begin
                                //IF ApprovalMgt.TestSalesPrepayment(Rec) THEN //MIGEC
                                if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                                    Error(StrSubstNo(Text002, rec."Document Type", rec."No."))
                                else
                                    CODEUNIT.Run(CODEUNIT::"Sales-Post (Yes/No)", Rec);
                            end;
                        end;
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN //MIGEC
                        if ApprovalMgt.PrePostApprovalCheckSales(Rec) then begin
                            //IF ApprovalMgt.TestSalesPrepayment(Rec) THEN //MIGEC
                            if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                                Error(StrSubstNo(Text001, rec."Document Type", rec."No."))
                            else begin
                                //IF ApprovalMgt.TestSalesPrepayment(Rec) THEN //MIGEC
                                if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                                    Error(StrSubstNo(Text002, rec."Document Type", rec."No."))
                                else
                                    CODEUNIT.Run(CODEUNIT::"Sales-Post + Print", Rec);
                            end;
                        end;
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;
                    Visible = false;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Batch Post Sales Orders", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
                separator(Action230)
                {
                }
                group("Prepa&yment")
                {
                    Caption = 'Prepa&yment';
                    Visible = false;
                    action("Prepayment &Test Report")
                    {
                        Caption = 'Prepayment &Test Report';
                        Ellipsis = true;

                        trigger OnAction()
                        begin
                            ReportPrint.PrintSalesHeaderPrepmt(Rec);
                        end;
                    }
                    action("Post Prepayment &Invoice")
                    {
                        Caption = 'Post Prepayment &Invoice';
                        Ellipsis = true;

                        trigger OnAction()
                        var
                            PurchaseHeader: Record "Purchase Header";
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            if ApprovalMgt.PrePostApprovalCheckSales(Rec) then
                                SalesPostYNPrepmt.PostPrepmtInvoiceYN(Rec, false);
                        end;
                    }
                    action("Post and Print Prepmt. Invoic&e")
                    {
                        Caption = 'Post and Print Prepmt. Invoic&e';
                        Ellipsis = true;

                        trigger OnAction()
                        var
                            PurchaseHeader: Record "Purchase Header";
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            if ApprovalMgt.PrePostApprovalCheckSales(Rec) then
                                SalesPostYNPrepmt.PostPrepmtInvoiceYN(Rec, true);
                        end;
                    }
                    action("Post Prepayment &Credit Memo")
                    {
                        Caption = 'Post Prepayment &Credit Memo';
                        Ellipsis = true;

                        trigger OnAction()
                        var
                            PurchaseHeader: Record "Purchase Header";
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            if ApprovalMgt.PrePostApprovalCheckSales(Rec) then
                                SalesPostYNPrepmt.PostPrepmtCrMemoYN(Rec, false);
                        end;
                    }
                    action("Post and Print Prepmt. Cr. Mem&o")
                    {
                        Caption = 'Post and Print Prepmt. Cr. Mem&o';
                        Ellipsis = true;

                        trigger OnAction()
                        var
                            PurchaseHeader: Record "Purchase Header";
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            if ApprovalMgt.PrePostApprovalCheckSales(Rec) then
                                SalesPostYNPrepmt.PostPrepmtCrMemoYN(Rec, true);
                        end;
                    }
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                action("Order Confirmation")
                {
                    Caption = 'Order Confirmation';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Order Confirmation");
                    end;
                }
                action("Work Order")
                {
                    Caption = 'Work Order';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Work Order");
                    end;
                }
                action("Pick Ticket")
                {
                    Caption = 'Pick Ticket';

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Pick Ticket");
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Drop Shipment Status")
            {
                Caption = 'Drop Shipment Status';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                //RunObject = Report "Drop Shipment Status";
            }
            action("Picking List by Order")
            {
                Caption = 'Picking List by Order';
                Promoted = true;
                PromotedCategory = "Report";
                //RunObject = Report "Picking List by Order";
            }
            action("Exportar Excel Pedido Venta")
            {
                Image = Excel;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    //002++
                    SalesHeader := Rec;
                    SalesHeader.SetRecFilter;
                    REPORT.RunModal(REPORT::"Exportar a Excel Pedido Venta", true, false, SalesHeader);
                    //002+-
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //003
        rec.CalcFields("Siguiente No.");
        ProximoNo := (rec."Siguiente No.");
        ProximoNo := IncStr(ProximoNo);
        //003
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(rec.ConfirmDeletion);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec.CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec."Responsibility Center" := UserMgt.GetSalesFilter();

        //001
        rec."Pre pedido" := true;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetSalesFilter() <> '' then begin
            rec.FilterGroup(2);
            rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter());
            rec.FilterGroup(0);
        end;

        rec.SetRange("Date Filter", 0D, WorkDate - 1);
    end;

    var
        Text000: Label 'Unable to execute this function while in view only mode.';
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management Ext";
        SalesSetup: Record "Sales & Receivables Setup";
        ChangeExchangeRate: Page "Change Exchange Rate";
        UserMgt: Codeunit "User Setup Management";
        Usage: Option "Order Confirmation","Work Order","Pick Ticket";
        Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';

        SalesHistoryBtnVisible: Boolean;

        BillToCommentPictVisible: Boolean;

        BillToCommentBtnVisible: Boolean;

        SalesHistoryStnVisible: Boolean;
        cFunSantillana: Codeunit "Funciones Santillana";
        ProximoNo: Code[20];
        SH: Record "Sales Header";
        ImportLineas: Report "Imp. Lineas Ped. Venta";


    procedure UpdateAllowed(): Boolean
    begin
        if CurrPage.Editable = false then
            Error(Text000);
        exit(true);
    end;

    local procedure UpdateInfoPanel()
    var
        DifferSellToBillTo: Boolean;
    begin
        DifferSellToBillTo := rec."Sell-to Customer No." <> rec."Bill-to Customer No.";
        SalesHistoryBtnVisible := DifferSellToBillTo;
        BillToCommentPictVisible := DifferSellToBillTo;
        BillToCommentBtnVisible := DifferSellToBillTo;
        SalesHistoryStnVisible := SalesInfoPaneMgt.DocExist(Rec, rec."Sell-to Customer No.");
        if DifferSellToBillTo then
            SalesHistoryBtnVisible := SalesInfoPaneMgt.DocExist(Rec, rec."Bill-to Customer No.");
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

