report 50002 "Get Source Documents Modifi_"
{
    // ---------------------------------
    // YFC     : Yefrecis Francisco Cruz
    // FES     : Fausto Serrata
    // ------------------------------------------------------------------------
    // No.         Firma     Fecha            Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC      01/10/2020       SANTINAV-1410 - Creación de AEN- Modificación de formato impresión Picking masivo.
    // 002         FES      16-MAR-2021      SANTINAV-2241 - Adicionar a Mensaje de Error Text003 el No. del Pedido para identificar cual esta provando error en el proceso de pickig masivo
    //                                       (Boton EAN-Crear Picking Maviso en la lista de pedidos de venta)

    Caption = 'Get Source Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Warehouse Request"; "Warehouse Request")
        {
            DataItemTableView = WHERE("Document Status" = CONST(Released), "Completely Handled" = FILTER(false));
            RequestFilterFields = "Source Document", "Source No.";
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLink = "Document Type" = FIELD("Source Subtype"), "No." = FIELD("Source No.");
                DataItemTableView = SORTING("Document Type", "No.");
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                    trigger OnAfterGetRecord()
                    begin
                        if "Location Code" = "Warehouse Request"."Location Code" then;
                        /*  case RequestType of
                             RequestType::Receive:
                                 if WhseActivityCreate.CheckIfSalesLine2ReceiptLine("Sales Line") then begin
                                     if not OneHeaderCreated and not WhseHeaderCreated then
                                         CreateReceiptHeader;
                                     if not WhseActivityCreate.SalesLine2ReceiptLine(WhseReceiptHeader, "Sales Line") then
                                         ErrorOccured := true;
                                     LineCreated := true;
                                 end;
                             RequestType::Ship:
                                 if WhseActivityCreate.CheckIfFromSalesLine2ShptLine("Sales Line") then begin
                                     if Cust.Blocked <> Cust.Blocked::" " then begin
                                         if not SalesHeaderCounted then begin
                                             SkippedSourceDoc += 1;
                                             SalesHeaderCounted := true;
                                         end;
                                         CurrReport.Skip;
                                     end;

                                     if not OneHeaderCreated and not WhseHeaderCreated then
                                         CreateShptHeader;
                                     if not WhseActivityCreate.FromSalesLine2ShptLine(WhseShptHeader, "Sales Line") then
                                         ErrorOccured := true;
                                     LineCreated := true;
                                 end;
                         end;
                          */
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Type, Type::Item);
                        if (("Warehouse Request".Type = "Warehouse Request".Type::Outbound) and
                            ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Sales Order")) or
                           (("Warehouse Request".Type = "Warehouse Request".Type::Inbound) and
                            ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Sales Return Order"))
                        then
                            SetFilter("Outstanding Quantity", '>0')
                        else
                            SetFilter("Outstanding Quantity", '<0');
                        SetRange("Drop Shipment", false);
                        SetRange("Job No.", '');
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TestField("Sell-to Customer No.");
                    Cust.Get("Sell-to Customer No.");
                    if not SkipBlockedCustomer then
                        Cust.CheckBlockedCustOnDocs(Cust, "Document Type", false, false);
                    SalesHeaderCounted := false;
                end;

                trigger OnPreDataItem()
                begin
                    if "Warehouse Request"."Source Type" <> DATABASE::"Sales Line" then
                        CurrReport.Break;
                end;
            }
            dataitem("Purchase Header"; "Purchase Header")
            {
                DataItemLink = "Document Type" = FIELD("Source Subtype"), "No." = FIELD("Source No.");
                DataItemTableView = SORTING("Document Type", "No.");
                dataitem("Purchase Line"; "Purchase Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                    trigger OnAfterGetRecord()
                    begin
                        /*    if "Location Code" = "Warehouse Request"."Location Code" then
                               case RequestType of
                                   RequestType::Receive:
                                       if WhseActivityCreate.CheckIfPurchLine2ReceiptLine("Purchase Line") then begin
                                           if not OneHeaderCreated and not WhseHeaderCreated then
                                               CreateReceiptHeader;
                                           if not WhseActivityCreate.PurchLine2ReceiptLine(WhseReceiptHeader, "Purchase Line") then
                                               ErrorOccured := true;
                                           LineCreated := true;
                                       end;
                                   RequestType::Ship:
                                       if WhseActivityCreate.CheckIfFromPurchLine2ShptLine("Purchase Line") then begin
                                           if not OneHeaderCreated and not WhseHeaderCreated then
                                               CreateShptHeader;
                                           if not WhseActivityCreate.FromPurchLine2ShptLine(WhseShptHeader, "Purchase Line") then
                                               ErrorOccured := true;
                                           LineCreated := true;
                                       end;
                               end; */
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Type, Type::Item);
                        if (("Warehouse Request".Type = "Warehouse Request".Type::Inbound) and
                            ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Purchase Order")) or
                           (("Warehouse Request".Type = "Warehouse Request".Type::Outbound) and
                            ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Purchase Return Order"))
                        then
                            SetFilter("Outstanding Quantity", '>0')
                        else
                            SetFilter("Outstanding Quantity", '<0');
                        SetRange("Drop Shipment", false);
                        SetRange("Job No.", '');
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if "Warehouse Request"."Source Type" <> DATABASE::"Purchase Line" then
                        CurrReport.Break;
                end;
            }
            dataitem("Transfer Header"; "Transfer Header")
            {
                DataItemLink = "No." = FIELD("Source No.");
                DataItemTableView = SORTING("No.");
                dataitem("Transfer Line"; "Transfer Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.");

                    trigger OnAfterGetRecord()
                    begin
                        /*  case RequestType of
                             RequestType::Receive:
                                 if WhseActivityCreate.CheckIfTransLine2ReceiptLine("Transfer Line") then begin
                                     if not OneHeaderCreated and not WhseHeaderCreated then
                                         CreateReceiptHeader;
                                     if not WhseActivityCreate.TransLine2ReceiptLine(WhseReceiptHeader, "Transfer Line") then
                                         ErrorOccured := true;
                                     LineCreated := true;
                                 end;
                             RequestType::Ship:
                                 if WhseActivityCreate.CheckIfFromTransLine2ShptLine("Transfer Line") then begin
                                     if not OneHeaderCreated and not WhseHeaderCreated then
                                         CreateShptHeader;
                                     if not WhseActivityCreate.FromTransLine2ShptLine(WhseShptHeader, "Transfer Line") then
                                         ErrorOccured := true;
                                     LineCreated := true;
                                 end;
                         end; */
                    end;

                    trigger OnPreDataItem()
                    begin
                        case "Warehouse Request"."Source Subtype" of
                            0:
                                SetFilter("Outstanding Quantity", '>0');
                            1:
                                SetFilter("Qty. in Transit", '>0');
                        end;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if "Warehouse Request"."Source Type" <> DATABASE::"Transfer Line" then
                        CurrReport.Break;
                end;
            }
            dataitem("Service Header"; "Service Header")
            {
                DataItemLink = "Document Type" = FIELD("Source Subtype"), "No." = FIELD("Source No.");
                DataItemTableView = SORTING("Document Type", "No.");
                dataitem("Service Line"; "Service Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                    trigger OnAfterGetRecord()
                    begin
                        /*  if "Location Code" = "Warehouse Request"."Location Code" then
                             case RequestType of
                                 RequestType::Ship:
                                     if WhseActivityCreate.CheckIfFromServiceLine2ShptLin("Service Line") then begin
                                         if not OneHeaderCreated and not WhseHeaderCreated then
                                             CreateShptHeader;
                                         if not WhseActivityCreate.FromServiceLine2ShptLine(WhseShptHeader, "Service Line") then
                                             ErrorOccured := true;
                                         LineCreated := true;
                                     end;
                             end; */
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Type, Type::Item);
                        if (("Warehouse Request".Type = "Warehouse Request".Type::Outbound) and
                            ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Service Order"))
                        then
                            SetFilter("Outstanding Quantity", '>0')
                        else
                            SetFilter("Outstanding Quantity", '<0');
                        SetRange("Job No.", '');
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TestField("Bill-to Customer No.");
                    Cust.Get("Bill-to Customer No.");
                    if not SkipBlockedCustomer then
                        Cust.CheckBlockedCustOnDocs(Cust, "Document Type", false, false)
                    else
                        if Cust.Blocked <> Cust.Blocked::" " then
                            CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    if "Warehouse Request"."Source Type" <> DATABASE::"Service Line" then
                        CurrReport.Break;
                end;
            }

            trigger OnAfterGetRecord()
            var
                WhseSetup: Record "Warehouse Setup";
            begin
                WhseHeaderCreated := false;
                case Type of
                    Type::Inbound:
                        begin
                            if not Location.RequireReceive("Location Code") then begin
                                if "Location Code" = '' then
                                    WhseSetup.TestField("Require Receive");
                                Location.Get("Location Code");
                                Location.TestField("Require Receive");
                            end;
                            if not OneHeaderCreated then
                                RequestType := RequestType::Receive;
                        end;
                    Type::Outbound:
                        begin
                            if not Location.RequireShipment("Location Code") then begin
                                if "Location Code" = '' then
                                    WhseSetup.TestField("Require Shipment");
                                Location.Get("Location Code");
                                Location.TestField("Require Shipment");
                            end;
                            if not OneHeaderCreated then
                                RequestType := RequestType::Ship;
                        end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if WhseHeaderCreated or OneHeaderCreated then begin
                    WhseShptHeader.SortWhseDoc;
                    WhseReceiptHeader.SortWhseDoc;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if OneHeaderCreated then begin
                    case RequestType of
                        RequestType::Receive:
                            Type := Type::Inbound;
                        RequestType::Ship:
                            Type := Type::Outbound;
                    end;
                    SetRange(Type, Type);
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DoNotFillQtytoHandle; DoNotFillQtytoHandle)
                    {
                        Caption = 'Do Not Fill Qty. to Handle';
                        ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        SpecialHandlingMessage: Text[1024];
    begin
        case RequestType of
            RequestType::Receive:
                begin
                    if DoNotFillQtytoHandle then begin
                        WhseReceiptLine.Reset;
                        WhseReceiptLine.SetRange("No.", WhseReceiptHeader."No.");
                        WhseReceiptLine.DeleteQtyToReceive(WhseReceiptLine);
                    end;
                    if not HideDialog then begin
                        if not LineCreated then
                            Error(Text000);

                        if ErrorOccured then
                            SpecialHandlingMessage := ' ' + StrSubstNo(Text005, WhseReceiptHeader.TableCaption,
                                WhseReceiptLine.FieldCaption("Bin Code"));
                        if (ActivitiesCreated = 0) and LineCreated and ErrorOccured then
                            Message(SpecialHandlingMessage);
                        if ActivitiesCreated = 1 then
                            Message(StrSubstNo(Text001, ActivitiesCreated, WhseReceiptHeader.TableCaption) + SpecialHandlingMessage);
                        if ActivitiesCreated > 1 then
                            Message(StrSubstNo(Text002, ActivitiesCreated) + SpecialHandlingMessage);
                    end;
                end;
            RequestType::Ship:
                if not HideDialog then begin
                    if not LineCreated then
                        Error(Text003, "Sales Header"."No.");        //002+-

                    if ErrorOccured then
                        SpecialHandlingMessage := ' ' + StrSubstNo(Text005, WhseShptHeader.TableCaption,
                            WhseShptLine.FieldCaption("Bin Code"));
                    // ++ 001-YFC
                    /*
                     IF (ActivitiesCreated = 0) AND LineCreated AND ErrorOccured THEN
                      MESSAGE(SpecialHandlingMessage);
                    IF ActivitiesCreated = 1 THEN
                      MESSAGE(STRSUBSTNO(Text001,ActivitiesCreated,WhseShptHeader.TABLECAPTION) + SpecialHandlingMessage);
                    IF ActivitiesCreated > 1 THEN
                      MESSAGE(STRSUBSTNO(Text004,ActivitiesCreated) + SpecialHandlingMessage);

                   */
                    // -- 001-YFC
                end;
        end;
        if SkippedSourceDoc > 0 then
            Message(CustomerIsBlockedMsg, SkippedSourceDoc);
        Completed := true;

    end;

    trigger OnPreReport()
    begin
        ActivitiesCreated := 0;
        LineCreated := false;
    end;

    var
        Text000: Label 'There are no Warehouse Receipt Lines created.';
        Text001: Label '%1 %2 has been created.';
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        Location: Record Location;
        Cust: Record Customer;
        WhseActivityCreate: Codeunit "Whse.-Create Source Document";
        ActivitiesCreated: Integer;
        OneHeaderCreated: Boolean;
        Completed: Boolean;
        LineCreated: Boolean;
        WhseHeaderCreated: Boolean;
        DoNotFillQtytoHandle: Boolean;
        HideDialog: Boolean;
        SkipBlockedCustomer: Boolean;
        RequestType: Option Receive,Ship;
        SalesHeaderCounted: Boolean;
        SkippedSourceDoc: Integer;
        Text002: Label '%1 Warehouse Receipts have been created.';
        Text003: Label 'There are no Warehouse Shipment Lines created for the order %1.';
        Text004: Label '%1 Warehouse Shipments have been created.';
        ErrorOccured: Boolean;
        Text005: Label 'One or more of the lines on this %1 require special warehouse handling. The %2 for such lines has been set to blank.';
        CustomerIsBlockedMsg: Label '%1 source documents were not included because the customer is blocked.';


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;


    procedure SetOneCreatedShptHeader(WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        RequestType := RequestType::Ship;
        WhseShptHeader := WhseShptHeader2;
        if WhseShptHeader.Find then
            OneHeaderCreated := true;
    end;


    procedure SetOneCreatedReceiptHeader(WhseReceiptHeader2: Record "Warehouse Receipt Header")
    begin
        RequestType := RequestType::Receive;
        WhseReceiptHeader := WhseReceiptHeader2;
        if WhseReceiptHeader.Find then
            OneHeaderCreated := true;
    end;


    procedure SetDoNotFillQtytoHandle(DoNotFillQtytoHandle2: Boolean)
    begin
        DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
    end;


    procedure GetLastShptHeader(var WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        RequestType := RequestType::Ship;
        WhseShptHeader2 := WhseShptHeader;
    end;


    procedure GetLastReceiptHeader(var WhseReceiptHeader2: Record "Warehouse Receipt Header")
    begin
        RequestType := RequestType::Receive;
        WhseReceiptHeader2 := WhseReceiptHeader;
    end;


    procedure NotCancelled(): Boolean
    begin
        exit(Completed);
    end;

    local procedure CreateShptHeader()
    begin
        WhseShptHeader.Init;
        WhseShptHeader."No." := '';
        WhseShptHeader."Location Code" := "Warehouse Request"."Location Code";
        if Location.Code = WhseShptHeader."Location Code" then
            WhseShptHeader."Bin Code" := Location."Shipment Bin Code";
        WhseShptLine.LockTable;
        WhseShptHeader.Insert(true);
        ActivitiesCreated := ActivitiesCreated + 1;
        WhseHeaderCreated := true;
        Commit;
    end;

    local procedure CreateReceiptHeader()
    begin
        WhseReceiptHeader.Init;
        WhseReceiptHeader."No." := '';
        WhseReceiptHeader."Location Code" := "Warehouse Request"."Location Code";
        if Location.Code = WhseReceiptHeader."Location Code" then
            WhseReceiptHeader."Bin Code" := Location."Receipt Bin Code";
        WhseReceiptLine.LockTable;
        WhseReceiptHeader.Insert(true);
        ActivitiesCreated := ActivitiesCreated + 1;
        WhseHeaderCreated := true;
        Commit;
    end;


    procedure SetSkipBlocked(Skip: Boolean)
    begin
        SkipBlockedCustomer := Skip;
    end;
}

