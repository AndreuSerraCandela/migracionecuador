page 56047 "Pedido Devolucion Consignacion"
{
    ApplicationArea = all;
    // Proyecto: Microsoft Dynamics Nav 2009
    // AMS     : Agustin Mendez
    // ------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     06-Julio-09     AMS           Se estima si el cliente excedera el limite de credito
    // 
    // 002     18-Enero-09     AMS           Envio de Pedido de venta por Correo Electronico.
    // 
    // 003     19-Enero-09     AMS           Datos Cliente.
    // 
    // 004     20-Enero-09     AMS           Para controlar pantalla de devolucion de consignacion.
    // 
    // 005     09-Sept-09      AMS           Impresion de bultos desde devolucion

    Caption = 'Consignment Return Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Consignment,Category5,Category6,Category7,Category8,Category9,Category10';
    RefreshOnActivate = true;
    SourceTable = "Transfer Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE("Devolucion Consignacion" = FILTER(true),
                            "Pedido Consignacion" = CONST(true));

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
                field("Transfer-to Code"; rec."Transfer-to Code")
                {
                    Importance = Promoted;
                }
                field("Transfer-from Code"; rec."Transfer-from Code")
                {
                    Importance = Promoted;
                }
                field("In-Transit Code"; rec."In-Transit Code")
                {
                }
                field("Cliente.Name"; Cliente.Name)
                {
                    Caption = 'Name';
                    Editable = false;
                }
                field("Cliente.Address"; Cliente.Address)
                {
                    Caption = 'Address';
                    Editable = false;
                }
                field("Cliente.City"; Cliente.City)
                {
                    Caption = 'City';
                    Editable = false;
                }
                field("Limite de credito cliente"; rec."Limite de credito cliente")
                {
                    Caption = 'Credit Limit';
                    Editable = false;
                }
                field("Saldo Cliente"; rec."Saldo Cliente")
                {
                    Caption = 'Balance';
                    Editable = false;
                }
                field("""Saldo Cliente"" +""Importe Consignacion Orginal"""; rec."Saldo Cliente" + rec."Importe Consignacion Orginal")
                {
                    Caption = 'Estimate Balance';
                    Editable = false;
                }
                field("""Limite de credito cliente"" - (""Saldo Cliente"" +""Importe Consignacion Orginal"")"; rec."Limite de credito cliente" - (rec."Saldo Cliente" + rec."Importe Consignacion Orginal"))
                {
                    Caption = 'Estimate Credit';
                }
                field("Cod. Contacto"; rec."Cod. Contacto")
                {
                }
                field("Nombre Contacto"; rec."Nombre Contacto")
                {
                }
                field("Pedido Consignacion"; rec."Pedido Consignacion")
                {
                    Caption = 'Consignment Order';
                    Editable = false;
                }
                field("Devolucion Consignacion"; rec."Devolucion Consignacion")
                {
                    Caption = 'Consignment Return';
                    Editable = false;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    trigger OnValidate()
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field("Cod. Vendedor"; rec."Cod. Vendedor")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                }
                field(Status; rec.Status)
                {
                    Importance = Promoted;
                }
                field("Importe Consignacion Orginal"; rec."Importe Consignacion Orginal")
                {
                    Caption = 'Consignment Amount';
                    Editable = false;
                }
            }
            part(TransferLines; "Transfer Order Subform Cosing.")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Derived From Line No." = CONST(0);
            }
            group("Transfer-from")
            {
                Caption = 'Transfer-from';
                field("Transfer-from Name"; rec."Transfer-from Name")
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
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name"; rec."Transfer-to Name")
                {
                }
                field("Transfer-to Name 2"; rec."Transfer-to Name 2")
                {
                }
                field("Transfer-to Address"; rec."Transfer-to Address")
                {
                }
                field("Transfer-to Address 2"; rec."Transfer-to Address 2")
                {
                }
                field("Transfer-to City"; rec."Transfer-to City")
                {
                }
                field("Transfer-to County"; rec."Transfer-to County")
                {
                    Caption = 'Transfer-to State / ZIP Code';
                }
                field("Transfer-to Post Code"; rec."Transfer-to Post Code")
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
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        rec.ShowDocDim;
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
                separator(Action1000000009)
                {
                }
                action("Calculate Consignment Inventory")
                {
                    Caption = 'Calculate Consignment Inventory';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        //004
                        //Se valida que antes de llamar inv. en consignacion no hayan lineas en el pedido
                        //El objetivo es evitar que llamen el Inv. Consignado mas de 1 vez.
                        TransferLine.Reset;
                        TransferLine.SetRange("Document No.", rec."No.");
                        if TransferLine.FindFirst then
                            Error(Error001);

                        rec.TestField("Pedido Consignacion");
                        rec.TestField("Devolucion Consignacion");
                        CFuncSantillana.RecibeNoDoc(rec."No.");
                        //CFuncSantillana.InvConsTransf("Transfer-from Code");
                        CFuncSantillana.InvConsTransf(rec."Transfer-from Code");
                        CurrPage.Update;
                        //004
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
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "TransferOrder-Post (Yes/No)";
                    ShortCutKey = 'F9';
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "TransferOrder-Post + Print";
                    ShortCutKey = 'Shift+F9';
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
        //003
        if not Cliente.Get(rec."Transfer-from Code") then
            Clear(Cliente);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        rec.TestField(Status, rec.Status::Open);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //006
        rec."Pedido Consignacion" := true;
        rec."Devolucion Consignacion" := true;
        //006
    end;

    var
        frmPantallaScanner: Page "Pantalla Scanner manual";
        CFuncSantillana: Codeunit "Funciones Santillana";
        TransHeader: Record "Transfer Header";
        NombreCliente: Text[200];
        DireccionCliente: Text[200];
        "**003**": Integer;
        Cliente: Record Customer;
        ConfSantillana: Record "Config. Empresa";
        TransferLine: Record "Transfer Line";
        wCantidad: Decimal;
        wPrecio: Decimal;
        wCantidadAenviar: Decimal;
        wDescuentoPorc: Decimal;
        I: Integer;
        cuManejaParametros: Codeunit "Lanzador DsPOS";
        TransferHeader: Record "Transfer Header";
        Error001: Label 'Before calling the Inv. Consigned you must delete the order lines';

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

