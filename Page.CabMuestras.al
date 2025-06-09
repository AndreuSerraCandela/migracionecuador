#pragma implicitwith disable
page 76118 "Cab. Muestras"
{
    ApplicationArea = all;
    // Documentation()
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
    // 004     25-Mayo-10      AMS           Impresion reporte de Bultos
    // 
    // 005     06-Agosto-10    AMS           Deshacer Envio Transferencia
    // 
    // 006     10-Mayo-11      AMS           Desde este form se marca como pedido de Consignacion.

    Caption = 'Transfer Order';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Transfer Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE("Devolucion Consignacion" = FILTER(false),
                            "Pedido Consignacion" = CONST(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        //006
                        if Cliente.Get(Rec."Transfer-to Code") then
                            if Cliente.Blocked <> Cliente.Blocked::" " then
                                Error(Error003, Cliente.Blocked);
                        //006
                    end;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    Editable = false;
                }
                field("Cod. Ubicacion Alm. Origen"; Rec."Cod. Ubicacion Alm. Origen")
                {
                    Editable = false;
                }
                field("Desc. Ubic. Alm. Origen"; Rec."Desc. Ubic. Alm. Origen")
                {
                    Editable = false;
                }
                field("Cod. Ubicacion Alm. Destino"; Rec."Cod. Ubicacion Alm. Destino")
                {
                    Editable = false;
                }
                field("Desc. Ubic. Alm. Destino"; Rec."Desc. Ubic. Alm. Destino")
                {
                    Editable = false;
                }
                field("Cliente.Name"; Cliente.Name)
                {
                    Caption = 'Nombre';
                    Editable = false;
                }
                field("Cliente.Address"; Cliente.Address)
                {
                    Caption = 'Direccion';
                    Editable = false;
                }
                field("Cliente.City"; Cliente.City)
                {
                    Caption = 'Ciudad';
                    Editable = false;
                }
                field("Saldo Cliente"; Rec."Saldo Cliente")
                {
                    Editable = false;
                }
                field("Importe Consignacion Orginal"; Rec."Importe Consignacion Orginal")
                {
                    Editable = false;
                    MultiLine = true;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    Editable = false;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    Editable = false;
                }
                field("Importe Consignacion"; Rec."Importe Consignacion")
                {
                    Caption = 'Importe PVA';
                    Editable = false;
                }
                field("Cod. Vendedor"; Rec."Cod. Vendedor")
                {
                    Editable = false;
                }
                field("Pedido Consignacion"; Rec."Pedido Consignacion")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Enabled = false;
                }
                field("Limite de credito cliente"; Rec."Limite de credito cliente")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("""Saldo Cliente"" +""Importe Consignacion Orginal"""; Rec."Saldo Cliente" + Rec."Importe Consignacion Orginal")
                {
                    Caption = 'Saldo estimado';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(CREstimado; Rec."Limite de credito cliente" - (Rec."Saldo Cliente" + Rec."Importe Consignacion Orginal"))
                {
                    Caption = 'Credito Estimado';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
            part(TransferLines; "Transfer Order Subform Muestra")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Derived From Line No." = CONST(0);
            }
            group("Transfer-from")
            {
                Caption = 'Transfer-from';
                Editable = false;
                field("Transfer-from Name"; Rec."Transfer-from Name")
                {
                }
                field("Transfer-from Name 2"; Rec."Transfer-from Name 2")
                {
                }
                field("Transfer-from Address"; Rec."Transfer-from Address")
                {
                }
                field("Transfer-from Address 2"; Rec."Transfer-from Address 2")
                {
                }
                field("Transfer-from City"; Rec."Transfer-from City")
                {
                }
                field("Transfer-from County"; Rec."Transfer-from County")
                {
                    Caption = 'Transfer-from State / ZIP Code';
                }
                field("Transfer-from Post Code"; Rec."Transfer-from Post Code")
                {
                }
                field("Transfer-from Contact"; Rec."Transfer-from Contact")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Outbound Whse. Handling Time"; Rec."Outbound Whse. Handling Time")
                {

                    trigger OnValidate()
                    begin
                        OutboundWhseHandlingTimeOnAfte;
                    end;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {

                    trigger OnValidate()
                    begin
                        ShippingAgentCodeOnAfterValida;
                    end;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {

                    trigger OnValidate()
                    begin
                        ShippingAgentServiceCodeOnAfte;
                    end;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {

                    trigger OnValidate()
                    begin
                        ShippingTimeOnAfterValidate;
                    end;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                Editable = false;
                field("Transfer-to Name"; Rec."Transfer-to Name")
                {
                }
                field("Transfer-to Name 2"; Rec."Transfer-to Name 2")
                {
                }
                field("Transfer-to Address"; Rec."Transfer-to Address")
                {
                }
                field("Transfer-to Address 2"; Rec."Transfer-to Address 2")
                {
                }
                field("Transfer-to City"; Rec."Transfer-to City")
                {
                }
                field("Transfer-to County"; Rec."Transfer-to County")
                {
                    Caption = 'Transfer-to State / ZIP Code';
                }
                field("Transfer-to Post Code"; Rec."Transfer-to Post Code")
                {
                }
                field("Transfer-to Contact"; Rec."Transfer-to Contact")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {

                    trigger OnValidate()
                    begin
                        ReceiptDateOnAfterValidate;
                    end;
                }
                field("Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
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
                Editable = false;
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                }
                field("Transport Method"; Rec."Transport Method")
                {
                }
                field("Area"; Rec."Area")
                {
                }
                field("Entry/Exit Point"; Rec."Entry/Exit Point")
                {
                }
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
                        Rec.ShowDocDim;
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
            group("&Line")
            {
                Caption = '&Line';
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    action(Period)
                    {
                        Caption = 'Period';

                        trigger OnAction()
                        begin
                            // CurrPage.TransferLines.PAGE.ItemAvailability(0);
                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';

                        trigger OnAction()
                        begin
                            // CurrPage.TransferLines.PAGE.ItemAvailability(1);
                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';

                        trigger OnAction()
                        begin
                            // CurrPage.TransferLines.PAGE.ItemAvailability(2);
                        end;
                    }
                }
                action(Action64)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //CurrPage.TransferLines.PAGE.ShowDimensions;
                    end;
                }
                group("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    action(Shipment)
                    {
                        Caption = 'Shipment';

                        trigger OnAction()
                        begin
                            // CurrPage.TransferLines.PAGE.OpenItemTrackingLines(0);
                        end;
                    }
                    action(Receipt)
                    {
                        Caption = 'Receipt';

                        trigger OnAction()
                        begin
                            //CurrPage.TransferLines.PAGE.OpenItemTrackingLines(1);
                        end;
                    }
                }
            }
            group(Imprimir)
            {
                Caption = 'Imprimir';
                action(Action1000000039)
                {
                    Caption = 'Imprimir';

                    trigger OnAction()
                    var
                        DocPrint: Codeunit "Document-Print";
                    begin
                        DocPrint.PrintTransferHeader(Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Reserve")
                {
                    Caption = '&Reserve';

                    trigger OnAction()
                    begin
                        //  CurrPage.TransferLines.PAGE.ShowReservation;
                    end;
                }
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
                        Rec.CreateInvtPutAwayPick;
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
                        BinContent.SetRange("Location Code", Rec."Transfer-from Code");
                        GetBinContent.SetTableView(BinContent);
                        GetBinContent.InitializeTransferHeader(Rec);
                        GetBinContent.RunModal;
                    end;
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    RunObject = Codeunit "Release Transfer Document";
                    ShortCutKey = 'Ctrl+F9';
                }
                action("Reo&pen")
                {
                    Caption = 'Reo&pen';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseTransferDoc: Codeunit "Release Transfer Document";
                    begin
                        ReleaseTransferDoc.Reopen(Rec);
                    end;
                }
                separator(Action1000000002)
                {
                }
                action("Select &Samples")
                {
                    Caption = 'Select &Samples';
                    Image = EntriesList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SelProdMuestras: Page "Seleccionar Productos Muestras";
                        Promotor: Record "Salesperson/Purchaser";
                    begin
                        /*Promotor.RESET;
                        Promotor.SETRANGE("Location code","Transfer-from Code");
                        Promotor.FINDFIRST;
                        */
                        SelProdMuestras.RecibeParametros(Rec."No.", Promotor.Code);
                        SelProdMuestras.RunModal;
                        Clear(SelProdMuestras);

                    end;
                }
                separator(Action1000000027)
                {
                }
                action("Enviar Pedido por E-mail")
                {
                    Caption = 'Enviar Pedido por E-mail';

                    trigger OnAction()
                    begin
                        //002

                        CFuncSantillana.CreaEmailPedidoConsg(Rec);
                        CurrPage.Update;
                        //002
                    end;
                }
                separator(Action1000000041)
                {
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
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
                        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
                    begin
                        ConfAPS.Get();

                        if ConfAPS."Movilidad Activada" then begin
                            if not Rec.Blocked then begin
                                Rec.Blocked := true;
                                Rec.Modify;
                                Message(Msg001);
                            end;
                            CurrPage.Close;
                        end
                        else begin
                            TransferPostShipment.Run(Rec);
                            TransferPostReceipt.Run(Rec);
                        end;
                    end;
                }
            }
            action("Pro&ductos")
            {
                Caption = 'Pro&ductos';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //003
                    //cuManejaParametros.Recibe_Consig_PantallaVend("No.",0,0);
                    PAGE.RunModal(50011);
                    //003
                end;
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.PrintTransferHeader(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //003
        if not Cliente.Get(Rec."Transfer-to Code") then
            Clear(Cliente);
        LimitedecreditoclienteSaldoCli;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TestField(Status, Rec.Status::Open);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //006
        Rec."Pedido Consignacion" := true;
    end;

    var
        ConfAPS: Record "Commercial Setup";
        CFuncSantillana: Codeunit "Funciones Santillana";
        rTransHeader: Record "Transfer Header";
        NombreCliente: Text[200];
        DireccionCliente: Text[200];
        "**003**": Integer;
        Cliente: Record Customer;
        cuManejaParametros: Codeunit "Lanzador DsPOS";
        I: Integer;
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        DefDim: Record "Default Dimension";
        wCantidad: Decimal;
        wPrecio: Decimal;
        wCantidadAenviar: Decimal;
        wDescuentoPorc: Decimal;
        wDescuentoImporte: Decimal;
        Error003: Label 'Cliente Bloqueado %1';
        CodComercial: Code[20];
        CodColegio: Code[20];
        CodAlmFrom: Code[20];
        CodAlmTo: Code[20];
        Bins: Record Bin;
        Msg001: Label 'Samples had been posted successfully';


    procedure RecibeParametros(AlmOrigen: Code[20]; AlmDestino: Code[20]; Comercial: Code[20]; Colegio: Code[20])
    begin
        CodComercial := Comercial;
        CodColegio := Colegio;
        CodAlmFrom := AlmOrigen;
        CodAlmTo := AlmDestino;
    end;

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

    local procedure LimitedecreditoclienteSaldoCli()
    begin
        if (Rec."Limite de credito cliente" - (Rec."Saldo Cliente" + Rec."Importe Consignacion Orginal")) < 0 then;
    end;
}

#pragma implicitwith restore

