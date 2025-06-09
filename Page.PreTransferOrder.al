page 56055 "Pre Transfer Order"
{
    ApplicationArea = all;
    // Proyecto: Implementacion Microsoft Dynamics Nav
    // AMS     : Agustin Mendez
    // GRN     : Guillermo Roman
    // ---------------------------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ---------------------------------------------------------------------------------------------
    // 001     27-Oct-12       AMS           Anulacion de NCF en Remision de Transferencia para Peru
    // 002     30-Oct-12       AMS           Prepedido de Transferencia
    // 007     16-Octubre-12   AMS           Mostrar el próximo numero de correlativo a utliizar

    Caption = 'Transfer Order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Transfer Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE("Pre pedido" = FILTER(true),
                            "Pedido Consignacion" = FILTER(false));

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
                field("Transfer-from Code"; rec."Transfer-from Code")
                {
                    Importance = Promoted;
                }
                field("Transfer-from Name"; rec."Transfer-from Name")
                {
                }
                field("Transfer-to Code"; rec."Transfer-to Code")
                {
                    Importance = Promoted;
                }
                field("In-Transit Code"; rec."In-Transit Code")
                {
                }
                field("Transfer-to Name"; rec."Transfer-to Name")
                {
                }
                field("Transfer-to Address"; rec."Transfer-to Address")
                {
                }
                field("Transfer-to Address 2"; rec."Transfer-to Address 2")
                {
                }
                field("Transfer-to Post Code"; rec."Transfer-to Post Code")
                {
                }
                field("Transfer-to City"; rec."Transfer-to City")
                {
                }
                field("Transfer-to County"; rec."Transfer-to County")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {

                    trigger OnValidate()
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field("Pedido Consignacion"; rec."Pedido Consignacion")
                {
                    Caption = 'Consignment Order';
                    Editable = false;
                }
                field("% de aprobacion"; rec."% de aprobacion")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                }
                field("No. Envio"; rec."No. Envio")
                {
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                }
                field(Status; rec.Status)
                {
                    Importance = Promoted;
                }
                field("Cod. Vendedor"; rec."Cod. Vendedor")
                {
                }
                field("No. Serie Comprobante Fiscal"; rec."No. Serie Comprobante Fiscal")
                {
                    Caption = 'Invoice FDN Serial No.';
                }
                field(ProximoNo; ProximoNo)
                {
                    Caption = 'Next NCF Number';
                    Editable = false;
                }
                field("% de aprobacion2"; rec."% de aprobacion")
                {
                }
                field("Fecha Aprobacion"; rec."Fecha Aprobacion")
                {
                    Importance = Additional;
                }
                field("Hora Aprobacion"; rec."Hora Aprobacion")
                {
                    Importance = Additional;
                }
                field("Fecha Creacion Pedido"; rec."Fecha Creacion Pedido")
                {
                    AutoFormatType = 0;
                    Importance = Additional;
                }
            }
            part(TransferLines; "Transfer Order Subform")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Derived From Line No." = CONST(0);
            }
            group("Transfer-from")
            {
                Caption = 'Transfer-from';
                field("Transfer-from Name2"; rec."Transfer-from Name")
                {
                }
                field("Transfer-from Name 2"; rec."Transfer-from Name 2")
                {
                }
                field("Transfer-from Address"; rec."Transfer-from Address")
                {
                }
                field("Transfer-from Address 2"; rec."Transfer-from Address 2")
                {
                }
                field("Transfer-from City"; rec."Transfer-from City")
                {
                }
                field("Transfer-from County"; rec."Transfer-from County")
                {
                    Caption = 'Transfer-from State / ZIP Code';
                }
                field("Transfer-from Post Code"; rec."Transfer-from Post Code")
                {
                }
                field("Transfer-from Contact"; rec."Transfer-from Contact")
                {
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Outbound Whse. Handling Time"; rec."Outbound Whse. Handling Time")
                {

                    trigger OnValidate()
                    begin
                        OutboundWhseHandlingTimeOnAfte;
                    end;
                }
                field("Shipment Method Code"; rec."Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; rec."Shipping Agent Code")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        ShippingAgentCodeOnAfterValida;
                    end;
                }
                field("Shipping Agent Service Code"; rec."Shipping Agent Service Code")
                {

                    trigger OnValidate()
                    begin
                        ShippingAgentServiceCodeOnAfte;
                    end;
                }
                field("Shipping Time"; rec."Shipping Time")
                {

                    trigger OnValidate()
                    begin
                        ShippingTimeOnAfterValidate;
                    end;
                }
                field("Shipping Advice"; rec."Shipping Advice")
                {
                    Importance = Promoted;
                }
            }
            group(Void)
            {
                Caption = 'Void';
                field(Correccion; rec.Correccion)
                {
                }
                field("No. Correlativo a Anular"; rec."No. Correlativo a Anular")
                {

                    trigger OnValidate()
                    begin
                        //001
                        if not rec.Correccion then
                            Error(txt001);
                        //001
                    end;
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name2"; rec."Transfer-to Name")
                {
                }
                field("Transfer-to Name 2"; rec."Transfer-to Name 2")
                {
                }
                field("Transfer-to Address2"; rec."Transfer-to Address")
                {
                }
                field("Transfer-to Address 22"; rec."Transfer-to Address 2")
                {
                }
                field("Transfer-to City2"; rec."Transfer-to City")
                {
                }
                field("Transfer-to County2"; rec."Transfer-to County")
                {
                    Caption = 'Transfer-to State / ZIP Code';
                }
                field("Transfer-to Post Code2"; rec."Transfer-to Post Code")
                {
                }
                field("Transfer-to Contact"; rec."Transfer-to Contact")
                {
                }
                field("Receipt Date"; rec."Receipt Date")
                {

                    trigger OnValidate()
                    begin
                        ReceiptDateOnAfterValidate;
                    end;
                }
                field("Inbound Whse. Handling Time"; rec."Inbound Whse. Handling Time")
                {

                    trigger OnValidate()
                    begin
                        InboundWhseHandlingTimeOnAfter;
                    end;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Type"; rec."Transaction Type")
                {
                    Importance = Promoted;
                }
                field("Transaction Specification"; rec."Transaction Specification")
                {
                }
                field("Transport Method"; rec."Transport Method")
                {
                    Importance = Promoted;
                }
                field("Area"; rec.Area)
                {
                }
                field("Entry/Exit Point"; rec."Entry/Exit Point")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
            part(Control1000000004; "Transfer Line FactBox")
            {
                Provider = TransferLines;
                SubPageLink = "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                SubPageView = SORTING("Document No.", "Line No.")
                              ORDER(Ascending);
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
                    RunObject = Page "Transfer Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inventory Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Transfer Order"),
                                  "No." = FIELD("No.");
                }
                action("S&hipments")
                {
                    Caption = 'S&hipments';
                    RunObject = Page "Posted Transfer Shipments";
                    RunPageLink = "Transfer Order No." = FIELD("No.");
                }
                action("Re&ceipts")
                {
                    Caption = 'Re&ceipts';
                    Image = PostedReceipts;
                    RunObject = Page "Posted Transfer Receipts";
                    RunPageLink = "Transfer Order No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Whse. Shi&pments")
                {
                    Caption = 'Whse. Shi&pments';
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type" = CONST(5741),
                                  "Source Subtype" = CONST("0"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action("&Whse. Receipts")
                {
                    Caption = '&Whse. Receipts';
                    RunObject = Page "Whse. Receipt Lines";
                    RunPageLink = "Source Type" = CONST(5741),
                                  "Source Subtype" = CONST("1"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    Caption = 'In&vt. Put-away/Pick Lines';
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document" = FILTER("Inbound Transfer" | "Outbound Transfer"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Document", "Source No.", "Location Code");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Create &Whse. Receipt")
                {
                    Caption = 'Create &Whse. Receipt';
                    Enabled = false;
                    Visible = false;

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.CreateFromInbndTransferOrder(Rec);
                    end;
                }
                action("Create Whse. S&hipment")
                {
                    Caption = 'Create Whse. S&hipment';
                    Enabled = false;
                    Visible = false;

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                    end;
                }
                action("Create Inventor&y Put-away / Pick")
                {
                    Caption = 'Create Inventor&y Put-away / Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;

                    trigger OnAction()
                    begin
                        rec.CreateInvtPutAwayPick;
                    end;
                }
                action("Get Bin Content")
                {
                    Caption = 'Get Bin Content';
                    Ellipsis = true;
                    Image = GetBinContent;

                    trigger OnAction()
                    var
                        BinContent: Record "Bin Content";
                        GetBinContent: Report "Whse. Get Bin Content";
                    begin
                        BinContent.SetRange("Location Code", rec."Transfer-from Code");
                        GetBinContent.SetTableView(BinContent);
                        GetBinContent.InitializeTransferHeader(Rec);
                        GetBinContent.RunModal;
                    end;
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Release Transfer Document";
                    ShortCutKey = 'Ctrl+F9';
                }
                action("Reo&pen")
                {
                    Caption = 'Reo&pen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseTransferDoc: Codeunit "Release Transfer Document";
                    begin
                        ReleaseTransferDoc.Reopen(Rec);
                    end;
                }
                action("&Convert in Transfer Order")
                {
                    Caption = '&Convert in Transfer Order';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Pre Tr-Order to Tr-Order (Y/N)", Rec);
                    end;
                }
                separator(Action1000000019)
                {
                }
                action("<Action1000000011>")
                {
                    Caption = '&UpLoad Order From Excel';
                    Image = ImportExport;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //008
                        Clear(ImportLineas);
                        ImportLineas.RecibeNoPedido(rec."No.");
                        ImportLineas.RunModal;
                        //008
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Enabled = false;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "TransferOrder-Post (Yes/No)";
                    ShortCutKey = 'F9';
                    Visible = false;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Enabled = false;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "TransferOrder-Post + Print";
                    ShortCutKey = 'Shift+F9';
                    Visible = false;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.PrintTransferHeader(Rec);
                end;
            }
        }
        area(reporting)
        {
            action("Inventory - Inbound Transfer")
            {
                Caption = 'Inventory - Inbound Transfer';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Inbound Transfer";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //007
        rec.CalcFields(rec."Siguiente No. NCF Rem.");
        ProximoNo := (rec."Siguiente No. NCF Rem.");
        ProximoNo := IncStr(ProximoNo);
        //007
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        rec.TestField(Status, rec.Status::Open);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //002
        rec."Pre pedido" := true;
        //002
    end;

    var
        txt001: Label 'To select a correlative to void the you must select the correction field for the transfer';
        ProximoNo: Code[30];
        ImportLineas: Report "Imp. Lineas Transferencias";

    local procedure PostingDateOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ShippingAgentServiceCodeOnAfte()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ShippingAgentCodeOnAfterValida()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ShippingTimeOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure OutboundWhseHandlingTimeOnAfte()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ReceiptDateOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure InboundWhseHandlingTimeOnAfter()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;
}

