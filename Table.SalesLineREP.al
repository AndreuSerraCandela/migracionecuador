table 50037 "Sales Line REP"
{
    // Proyecto: Implementacion Microsoft Dynamics Nav
    // AMS     : Agustin Mendez
    // GRN     : Guillermo Roman
    // ------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     02-Enero-10     AMS           Funciones DS-POS
    // 002     18-Julio-11     AMS           Se crea el campo Cod. Vendedor en las lineas y se
    //                                       inserta por defecto el que esta en la cabecera de la
    //                                       factura.
    // 003     02-Sept-11      AMS           Se borra el No. de Cupon en al insertar cantidad
    // 004     17-Oct-2011     AMS           Se avisa al usuario en caso de que exista el mismo producto
    //                                       para el mismo cliente sin entregar en otro pedido.
    // 005     09-Jul-2012     AMS           Se controla por usuario que la descripcion de productos en
    //                                       las lineas de venta no se puedan modificar.
    // 006     18-Jul-2012     AMS           Se controla el precio de venta de acuerdo al tipo de venta
    // 011     27-Oct-12       AMS           Control de campos requeridos
    // 012     11-Marzo-13     AMS           Cargos a productos como IVA
    // 013     05-Abril-13     AMS           Tipo de Venta
    // 014     06-Abril-13     AMS           No se muestra mensaje para pedidos TPV
    // 015     07-Abril-13     AMS           Control de cantidad de lineas para pedidos TPV
    // 016     28-Nov-12       GRN           Campos para el APS. Se buscan los datos y se llenan los campos
    // $017    25/06/2014      PLB           Nueva función ActLinBO() (traida del page de la línea del pedido)
    //                                       Ajustes en la validación de "Cantidad anular"
    //                                       Cambios en varios textconstants para adaptarlos a varios campos

    Caption = 'Sales Line';
    DrillDownPageID = "Sales Lines";
    LookupPageID = "Sales Lines";
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Pre Order';
            //OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Pre Order";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Enum "Sales Line Type")
        {
            Caption = 'Type';
            //OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            //OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";

            trigger OnValidate()
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                GetSalesHeader;

                TestField("Qty. Shipped Not Invoiced", 0);
                TestField("Quantity Shipped", 0);
                TestField("Shipment No.", '');

                TestField("Return Qty. Rcd. Not Invd.", 0);
                TestField("Return Qty. Received", 0);
                TestField("Return Receipt No.", '');

                TestField("Prepmt. Amt. Inv.", 0);

                CheckAssocPurchOrder(FieldCaption(Type));

                if Type <> xRec.Type then
                    case xRec.Type of
                        Type::Item:
                            begin
                                //fes mig ATOLink.DeleteAsmFromSalesLine(Rec);
                                if Quantity <> 0 then begin
                                    SalesHeader.TestField(Status, SalesHeader.Status::Open);
                                    CalcFields("Reserved Qty. (Base)");
                                    TestField("Reserved Qty. (Base)", 0);
                                    //fes mig ReserveSalesLine.VerifyChange(Rec,xRec);
                                    //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                                end;
                            end;
                        Type::"Fixed Asset":
                            if Quantity <> 0 then
                                SalesHeader.TestField(Status, SalesHeader.Status::Open);
                        Type::"Charge (Item)":
                            DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");
                    end;

                //fes mig AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                //fes mig TempSalesLine := Rec;
                Init;
                Type := TempSalesLine.Type;
                "System-Created Entry" := TempSalesLine."System-Created Entry";

                if Type = Type::Item then
                    "Allow Item Charge Assignment" := true
                else
                    "Allow Item Charge Assignment" := false;
                if Type = Type::Item then begin
                    if SalesHeader.InventoryPickConflict("Document Type", "Document No.", SalesHeader."Shipping Advice") then
                        Error(Text056, SalesHeader."Shipping Advice");
                    if SalesHeader.WhseShipmentConflict("Document Type", "Document No.", SalesHeader."Shipping Advice") then
                        Error(Text052, SalesHeader."Shipping Advice");
                end;
            end;
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account"),
                                     "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                                               "Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account"),
                                                                                                        "System-Created Entry" = CONST(true)) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";

            trigger OnValidate()
            var
                PrepaymentMgt: Codeunit "Prepayment Mgt.";
                AdopcionesDetalle: Record "Colegio - Adopciones Detalle";
                ColNivel: Record "Colegio - Nivel";
                PromotorRuta: Record "Promotor - Rutas";
                CustomCalendarChange: array[2] of Record "Customized Calendar Change";
            begin
                //011
                if Type = Type::Item then begin
                    ValidaCampos.Maestros(27, "No.");
                    ValidaCampos.Dimensiones(15, "No.", 0, 0);
                end;

                if Type = Type::"G/L Account" then begin
                    ValidaCampos.Maestros(15, "No.");
                    ValidaCampos.Dimensiones(15, "No.", 0, 0);
                end;
                //011


                TestJobPlanningLine;
                TestStatusOpen;
                CheckItemAvailable(FieldNo("No."));

                if (xRec."No." <> "No.") and (Quantity <> 0) then begin
                    TestField("Qty. to Asm. to Order (Base)", 0);
                    CalcFields("Reserved Qty. (Base)");
                    TestField("Reserved Qty. (Base)", 0);
                    //fes mig IF Type = Type::Item THEN
                    //fes mig   WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                end;

                TestField("Qty. Shipped Not Invoiced", 0);
                TestField("Quantity Shipped", 0);
                TestField("Shipment No.", '');

                TestField("Prepmt. Amt. Inv.", 0);

                TestField("Return Qty. Rcd. Not Invd.", 0);
                TestField("Return Qty. Received", 0);
                TestField("Return Receipt No.", '');

                //fes mig IF "No." = '' THEN
                //fes mig   ATOLink.DeleteAsmFromSalesLine(Rec);
                CheckAssocPurchOrder(FieldCaption("No."));
                //fes mig AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                //fes mig TempSalesLine := Rec;
                Init;
                Type := TempSalesLine.Type;
                "No." := TempSalesLine."No.";
                if "No." = '' then
                    exit;
                if Type <> Type::" " then
                    Quantity := TempSalesLine.Quantity;

                "System-Created Entry" := TempSalesLine."System-Created Entry";
                GetSalesHeader;
                if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then begin
                    if (SalesHeader."Sell-to Customer No." = '') and
                       (SalesHeader."Sell-to Customer Templ. Code" = '')
                    then
                        Error(
                          Text031,
                          SalesHeader.FieldCaption("Sell-to Customer No."),
                          SalesHeader.FieldCaption("Sell-to Customer Templ. Code"));
                    if (SalesHeader."Bill-to Customer No." = '') and
                       (SalesHeader."Bill-to Customer Templ. Code" = '')
                    then
                        Error(
                          Text031,
                          SalesHeader.FieldCaption("Bill-to Customer No."),
                          SalesHeader.FieldCaption("Bill-to Customer Templ. Code"));
                end else
                    SalesHeader.TestField("Sell-to Customer No.");

                "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                "Currency Code" := SalesHeader."Currency Code";
                if not IsServiceItem then
                    "Location Code" := SalesHeader."Location Code";
                "Customer Price Group" := SalesHeader."Customer Price Group";
                "Customer Disc. Group" := SalesHeader."Customer Disc. Group";
                "Allow Line Disc." := SalesHeader."Allow Line Disc.";
                "Transaction Type" := SalesHeader."Transaction Type";
                "Transport Method" := SalesHeader."Transport Method";
                "Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
                "Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";
                "Exit Point" := SalesHeader."Exit Point";
                Area := SalesHeader.Area;
                "Transaction Specification" := SalesHeader."Transaction Specification";
                "Tax Area Code" := SalesHeader."Tax Area Code";
                "Tax Liable" := SalesHeader."Tax Liable";
                if not "System-Created Entry" and ("Document Type" = "Document Type"::Order) and (Type <> Type::" ") then
                    "Prepayment %" := SalesHeader."Prepayment %";
                "Prepayment Tax Area Code" := SalesHeader."Tax Area Code";
                "Prepayment Tax Liable" := SalesHeader."Tax Liable";
                "Responsibility Center" := SalesHeader."Responsibility Center";

                "Shipping Agent Code" := SalesHeader."Shipping Agent Code";
                "Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
                "Outbound Whse. Handling Time" := SalesHeader."Outbound Whse. Handling Time";
                "Shipping Time" := SalesHeader."Shipping Time";
                CalcFields("Substitution Available");

                "Promised Delivery Date" := SalesHeader."Promised Delivery Date";
                "Requested Delivery Date" := SalesHeader."Requested Delivery Date";
                CustomCalendarChange[1].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
                CustomCalendarChange[2].SetSource(CalChange."Source Type"::Location, "Location Code", '', '');
                "Shipment Date" := CalendarMgmt.CalcDateBOC2('', SalesHeader."Shipment Date", CustomCalendarChange, false);

                UpdateDates;

                case Type of
                    Type::" ":
                        begin
                            "Tax Area Code" := '';
                            "Tax Liable" := false;
                            StdTxt.Get("No.");
                            Description := StdTxt.Description;
                            "Allow Item Charge Assignment" := false;
                        end;
                    Type::"G/L Account":
                        begin
                            GLAcc.Get("No.");
                            GLAcc.CheckGLAcc;
                            if not "System-Created Entry" then
                                GLAcc.TestField("Direct Posting", true);
                            Description := GLAcc.Name;
                            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                            "Tax Group Code" := GLAcc."Tax Group Code";
                            "Allow Invoice Disc." := false;
                            "Allow Item Charge Assignment" := false;
                        end;
                    Type::Item:
                        begin
                            GetItem;
                            Item.TestField(Blocked, false);
                            Item.TestField("Gen. Prod. Posting Group");
                            if Item.Type = Item.Type::Inventory then begin
                                Item.TestField("Inventory Posting Group");
                                "Posting Group" := Item."Inventory Posting Group";
                            end;
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                            ISBN := Item.ISBN;//010
                            "Nivel Educativo" := Item."Nivel Educativo"; //+$018
                            GetUnitCost;
                            "Allow Invoice Disc." := Item."Allow Invoice Disc.";
                            "Units per Parcel" := Item."Units per Parcel";
                            "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                            "Tax Group Code" := Item."Tax Group Code";
                            "Package Tracking No." := SalesHeader."Package Tracking No.";
                            "Item Category Code" := Item."Item Category Code";
                            //"Product Group Code" := Item."Product Group Code";
                            Nonstock := Item."Created From Nonstock Item";
                            "Profit %" := Item."Profit %";
                            "Allow Item Charge Assignment" := true;
                            //fes mig PrepaymentMgt.SetSalesPrepaymentPct(Rec,SalesHeader."Posting Date");

                            if SalesHeader."Language Code" <> '' then
                                GetItemTranslation;

                            if Item.Reserve = Item.Reserve::Optional then
                                Reserve := SalesHeader.Reserve
                            else
                                Reserve := Item.Reserve;

                            "Unit of Measure Code" := Item."Sales Unit of Measure";

                            ActualizaInfoAdopcion; //016

                        end;
                    Type::Resource:
                        begin
                            Res.Get("No.");
                            Res.TestField(Blocked, false);
                            Res.TestField("Gen. Prod. Posting Group");
                            Description := Res.Name;
                            "Description 2" := Res."Name 2";
                            "Unit of Measure Code" := Res."Base Unit of Measure";
                            "Unit Cost (LCY)" := Res."Unit Cost";
                            "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
                            "Tax Group Code" := Res."Tax Group Code";
                            "Allow Item Charge Assignment" := false;
                            FindResUnitCost;
                        end;
                    Type::"Fixed Asset":
                        begin
                            FA.Get("No.");
                            FA.TestField(Inactive, false);
                            FA.TestField(Blocked, false);
                            GetFAPostingGroup;
                            Description := FA.Description;
                            "Description 2" := FA."Description 2";
                            "Allow Invoice Disc." := false;
                            "Allow Item Charge Assignment" := false;
                        end;
                    Type::"Charge (Item)":
                        begin
                            ItemCharge.Get("No.");
                            Description := ItemCharge.Description;
                            "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                            "Tax Group Code" := ItemCharge."Tax Group Code";
                            "Allow Invoice Disc." := false;
                            "Allow Item Charge Assignment" := false;
                            "Parte del IVA" := ItemCharge."Parte del IVA"//013
                        end;
                end;

                Validate("Prepayment %");

                if Type <> Type::" " then begin
                    if Type <> Type::"Fixed Asset" then
                        Validate("VAT Prod. Posting Group");
                    Validate("Unit of Measure Code");
                    if Quantity <> 0 then begin
                        InitOutstanding;
                        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
                            InitQtyToReceive
                        else
                            InitQtyToShip;
                        InitQtyToAsm;
                        UpdateWithWarehouseShip;
                    end;
                    UpdateUnitPrice(FieldNo("No."));
                end;

                /* CreateDim(
                  DimMgt.TypeToTableID3(Type), "No.",
                  DATABASE::Job, "Job No.",
                  DATABASE::"Responsibility Center", "Responsibility Center"); */

                if "No." <> xRec."No." then begin
                    if Type = Type::Item then
                        if (Quantity <> 0) and ItemExists(xRec."No.") then begin
                            //fes mig ReserveSalesLine.VerifyChange(Rec,xRec);
                            //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                        end;
                    GetDefaultBin;

                    /*
                    //GRN Para los clientes internos
                    CustPostGr.GET(SalesHeader."Customer Posting Group");
                    IF CustPostGr."Cliente Interno" THEN
                       VALIDATE("Unit Price","Unit Cost");
                    */

                    SH.Get("Document Type", "Document No.");
                    if ("Document Type" = "Document Type"::Order) then begin
                        if not Temporal then //AMS 07/02/12 Control para no desplegar el mensaje si la inserción
                                             //viene hecha por el proceso que calcula la tarifa
                          begin
                            SalesLine2.Reset;
                            SalesLine2.SetRange("Document Type", SalesLine2."Document Type"::Order);
                            SalesLine2.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                            SalesLine2.SetRange(Type, Type);
                            SalesLine2.SetRange("No.", "No.");
                            if SalesLine2.FindFirst then
                                if not Confirm(txt003, false, SalesLine2."Document No.") then
                                    Validate("No.", '');
                        end;
                    end;

                    AutoAsmToOrder;
                    DeleteItemChargeAssgnt("Document Type", "Document No.", "Line No.");
                    if Type = Type::"Charge (Item)" then
                        DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");
                end;

                GetItemCrossRef(FieldNo("No."));

                InitICPartner;

            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            var
                CustomCalendarChange: array[2] of Record "Customized Calendar Change";
            begin
                ValidaCampos.Maestros(14, "Location Code");//011
                ValidaCampos.Dimensiones(14, "Location Code", 0, 0);//011

                TestJobPlanningLine;
                TestStatusOpen;
                CheckAssocPurchOrder(FieldCaption("Location Code"));
                if "Location Code" <> '' then
                    if IsServiceItem then
                        Item.TestField(Type, Item.Type::Inventory);
                if xRec."Location Code" <> "Location Code" then begin
                    if not FullQtyIsForAsmToOrder then begin
                        CalcFields("Reserved Qty. (Base)");
                        TestField("Reserved Qty. (Base)", "Qty. to Asm. to Order (Base)");
                    end;
                    TestField("Qty. Shipped Not Invoiced", 0);
                    TestField("Shipment No.", '');
                    TestField("Return Qty. Rcd. Not Invd.", 0);
                    TestField("Return Receipt No.", '');
                end;

                GetSalesHeader;
                CustomCalendarChange[1].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
                CustomCalendarChange[2].SetSource(CalChange."Source Type"::Location, "Location Code", '', '');
                "Shipment Date" := CalendarMgmt.CalcDateBOC('', SalesHeader."Shipment Date", CustomCalendarChange, false);

                CheckItemAvailable(FieldNo("Location Code"));

                if not "Drop Shipment" then begin
                    if "Location Code" = '' then begin
                        if InvtSetup.Get then
                            "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                    end else
                        if Location.Get("Location Code") then
                            "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                end else
                    Evaluate("Outbound Whse. Handling Time", '<0D>');

                if "Location Code" <> xRec."Location Code" then begin
                    InitItemAppl(true);
                    GetDefaultBin;
                    InitQtyToAsm;
                    AutoAsmToOrder;
                    if Quantity <> 0 then begin
                        if not "Drop Shipment" then
                            UpdateWithWarehouseShip;
                        //fes mig IF NOT FullReservedQtyIsForAsmToOrder THEN
                        //fes mig ReserveSalesLine.VerifyChange(Rec,xRec);
                        //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                    end;
                end;

                UpdateDates;

                if (Type = Type::Item) and ("No." <> '') then
                    GetUnitCost;

                CheckWMS;

                if "Document Type" = "Document Type"::"Return Order" then
                    ValidateReturnReasonCode(FieldNo("Location Code"));

                ActualizaInfoAdopcion; //016
            end;
        }
        field(8; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = IF (Type = CONST(Item)) "Inventory Posting Group"
            ELSE
            IF (Type = CONST("Fixed Asset")) "FA Posting Group";
        }
        field(10; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
            begin
                TestStatusOpen;
                //fes mig IF CurrFieldNo <> 0 THEN
                //fes mig AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                if "Shipment Date" <> 0D then begin
                    if CurrFieldNo in [
                                       FieldNo("Planned Shipment Date"),
                                       FieldNo("Planned Delivery Date"),
                                       FieldNo("Shipment Date"),
                                       FieldNo("Shipping Time"),
                                       FieldNo("Outbound Whse. Handling Time"),
                                       FieldNo("Requested Delivery Date")]
                    then
                        CheckItemAvailable(FieldNo("Shipment Date"));
                    SalesHeader.Get("Document Type", "Document No.");
                    if ("Shipment Date" < WorkDate) and (Type <> Type::" ") then
                        if not (HideValidationDialog or HasBeenShown) and GuiAllowed then begin
                            Message(
                              Text014,
                              FieldCaption("Shipment Date"), "Shipment Date", WorkDate);
                            HasBeenShown := true;
                        end;
                end;

                AutoAsmToOrder;
                if (xRec."Shipment Date" <> "Shipment Date") and
                   (Quantity <> 0) and
                   (Reserve <> Reserve::Never) and
                   not StatusCheckSuspended
                then
                    //fes mig CheckDateConflict.SalesLineCheck(Rec,CurrFieldNo <> 0);

                    if not PlannedShipmentDateCalculated then
                        "Planned Shipment Date" := CalcPlannedShptDate(FieldNo("Shipment Date"));
                if not PlannedDeliveryDateCalculated then
                    "Planned Delivery Date" := CalcPlannedDeliveryDate(FieldNo("Shipment Date"));
            end;
        }
        field(11; Description; Text[160])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                //005
                if Type = Type::Item then begin
                    if Users.Get(UserId) then begin
                        if not Users."Modifica Desc. prod. Lin. Vta." then
                            if "Document Type" in ["Document Type"::Order, "Document Type"::Invoice] then
                                Error(Err001, FieldCaption(Description));
                    end
                    else
                        Error(Err001, FieldCaption(Description));
                end;
                //005
            end;
        }
        field(12; "Description 2"; Text[60])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                //003
                Validate("Cod. Cupon", '');
                //003

                TestJobPlanningLine;
                TestStatusOpen;

                CheckAssocPurchOrder(FieldCaption(Quantity));

                if "Shipment No." <> '' then
                    CheckShipmentRelation
                else
                    if "Return Receipt No." <> '' then
                        CheckRetRcptRelation;

                "Quantity (Base)" := CalcBaseQty(Quantity);

                if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then begin
                    if (Quantity * "Return Qty. Received" < 0) or
                       ((Abs(Quantity) < Abs("Return Qty. Received")) and ("Return Receipt No." = ''))
                    then
                        FieldError(Quantity, StrSubstNo(Text003, FieldCaption("Return Qty. Received")));
                    if ("Quantity (Base)" * "Return Qty. Received (Base)" < 0) or
                       ((Abs("Quantity (Base)") < Abs("Return Qty. Received (Base)")) and ("Return Receipt No." = ''))
                    then
                        FieldError("Quantity (Base)", StrSubstNo(Text003, FieldCaption("Return Qty. Received (Base)")));
                end else begin
                    if (Quantity * "Quantity Shipped" < 0) or
                       ((Abs(Quantity) < Abs("Quantity Shipped")) and ("Shipment No." = ''))
                    then
                        FieldError(Quantity, StrSubstNo(Text003, FieldCaption("Quantity Shipped")));
                    if ("Quantity (Base)" * "Qty. Shipped (Base)" < 0) or
                       ((Abs("Quantity (Base)") < Abs("Qty. Shipped (Base)")) and ("Shipment No." = ''))
                    then
                        FieldError("Quantity (Base)", StrSubstNo(Text003, FieldCaption("Qty. Shipped (Base)")));
                end;

                if (Type = Type::"Charge (Item)") and (CurrFieldNo <> 0) then begin
                    if (Quantity = 0) and ("Qty. to Assign" <> 0) then
                        FieldError("Qty. to Assign", StrSubstNo(Text009, FieldCaption(Quantity), Quantity));
                    if (Quantity * "Qty. Assigned" < 0) or (Abs(Quantity) < Abs("Qty. Assigned")) then
                        FieldError(Quantity, StrSubstNo(Text003, FieldCaption("Qty. Assigned")));
                end;

                //fes mig AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                if (xRec.Quantity <> Quantity) or (xRec."Quantity (Base)" <> "Quantity (Base)") then begin
                    InitOutstanding;
                    if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
                        InitQtyToReceive
                    else
                        InitQtyToShip;
                    InitQtyToAsm;
                end;

                CheckItemAvailable(FieldNo(Quantity));

                if (Quantity * xRec.Quantity < 0) or (Quantity = 0) then
                    InitItemAppl(false);

                if Type = Type::Item then begin
                    UpdateUnitPrice(FieldNo(Quantity));
                    if (xRec.Quantity <> Quantity) or (xRec."Quantity (Base)" <> "Quantity (Base)") then begin
                        //fes mig ReserveSalesLine.VerifyQuantity(Rec,xRec);
                        if not "Drop Shipment" then
                            UpdateWithWarehouseShip;
                        //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                        if ("Quantity (Base)" * xRec."Quantity (Base)" <= 0) and ("No." <> '') then begin
                            GetItem;
                            if (Item."Costing Method" = Item."Costing Method"::Standard) and not IsShipment then
                                GetUnitCost;
                        end;
                    end;
                    Validate("Qty. to Assemble to Order");
                    if (Quantity = "Quantity Invoiced") and (CurrFieldNo <> 0) then
                        CheckItemChargeAssgnt;
                    CheckApplFromItemLedgEntry(ItemLedgEntry);
                end else
                    Validate("Line Discount %");

                if (xRec.Quantity <> Quantity) and (Quantity = 0) and
                   ((Amount <> 0) or ("Amount Including VAT" <> 0) or ("VAT Base Amount" <> 0))
                then begin
                    Amount := 0;
                    "Amount Including VAT" := 0;
                    "VAT Base Amount" := 0;
                end;

                UpdatePrePaymentAmounts;

                CheckWMS;

                CalcFields("Reserved Qty. (Base)");
                Validate("Reserved Qty. (Base)");

                //006
                PreciosTipoVenta;

                ActualizaInfoAdopcion; //016
            end;
        }
        field(16; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(17; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if "Qty. to Invoice" = MaxQtyToInvoice then
                    InitQtyToInvoice
                else
                    "Qty. to Invoice (Base)" := CalcBaseQty("Qty. to Invoice");
                if ("Qty. to Invoice" * Quantity < 0) or
                   (Abs("Qty. to Invoice") > Abs(MaxQtyToInvoice))
                then
                    Error(
                      Text005,
                      MaxQtyToInvoice);
                if ("Qty. to Invoice (Base)" * "Quantity (Base)" < 0) or
                   (Abs("Qty. to Invoice (Base)") > Abs(MaxQtyToInvoiceBase))
                then
                    Error(
                      Text006,
                      MaxQtyToInvoiceBase);
                "VAT Difference" := 0;
                CalcInvDiscToInvoice;
                CalcPrepaymentToDeduct;
            end;
        }
        field(18; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                GetLocation("Location Code");
                if (CurrFieldNo <> 0) and
                   (Type = Type::Item) and
                   (not "Drop Shipment")
                then begin
                    if Location."Require Shipment" and
                       ("Qty. to Ship" <> 0)
                    then
                        CheckWarehouse;
                    //fes mig  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                end;

                if "Qty. to Ship" = "Outstanding Quantity" then
                    InitQtyToShip
                else begin
                    "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");
                    CheckServItemCreation;
                    InitQtyToInvoice;
                end;
                if ((("Qty. to Ship" < 0) xor (Quantity < 0)) and (Quantity <> 0) and ("Qty. to Ship" <> 0)) or
                   (Abs("Qty. to Ship") > Abs("Outstanding Quantity")) or
                   (((Quantity < 0) xor ("Outstanding Quantity" < 0)) and (Quantity <> 0) and ("Outstanding Quantity" <> 0))
                then
                    Error(
                      Text007,
                      "Outstanding Quantity");
                if ((("Qty. to Ship (Base)" < 0) xor ("Quantity (Base)" < 0)) and ("Qty. to Ship (Base)" <> 0) and ("Quantity (Base)" <> 0)) or
                   (Abs("Qty. to Ship (Base)") > Abs("Outstanding Qty. (Base)")) or
                   ((("Quantity (Base)" < 0) xor ("Outstanding Qty. (Base)" < 0)) and ("Quantity (Base)" <> 0) and ("Outstanding Qty. (Base)" <> 0))
                then
                    Error(
                      Text008,
                      "Outstanding Qty. (Base)");

                if (CurrFieldNo <> 0) and (Type = Type::Item) and ("Qty. to Ship" < 0) then
                    CheckApplFromItemLedgEntry(ItemLedgEntry);

                //fes mig ATOLink.UpdateQtyToAsmFromSalesLine(Rec);
            end;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FieldNo("Unit Price"));
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                CantidadSol := "Cantidad Solicitada";//013
                TestJobPlanningLine;
                TestStatusOpen;

                if ("Prepmt. Amt. Inv." <> 0) and
                   ("Unit Price" <> xRec."Unit Price")
                then
                    FieldError("Unit Price", StrSubstNo(Text050, xRec."Unit Price"));
                Validate("Line Discount %");
                Validate("Cantidad Solicitada", CantidadSol);//013
            end;
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost ($)';

            trigger OnValidate()
            begin
                if (CurrFieldNo = FieldNo("Unit Cost (LCY)")) and
                   ("Unit Cost (LCY)" <> xRec."Unit Cost (LCY)")
                then
                    CheckAssocPurchOrder(FieldCaption("Unit Cost (LCY)"));

                if (CurrFieldNo = FieldNo("Unit Cost (LCY)")) and
                   (Type = Type::Item) and ("No." <> '') and ("Quantity (Base)" <> 0)
                then begin
                    TestJobPlanningLine;
                    GetItem;
                    if (Item."Costing Method" = Item."Costing Method"::Standard) and not IsShipment then begin
                        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
                            Error(
                              Text037,
                              FieldCaption("Unit Cost (LCY)"), Item.FieldCaption("Costing Method"),
                              Item."Costing Method", FieldCaption(Quantity));
                        Error(
                          Text038,
                          FieldCaption("Unit Cost (LCY)"), Item.FieldCaption("Costing Method"),
                          Item."Costing Method", FieldCaption(Quantity));
                    end;
                end;

                GetSalesHeader;
                if SalesHeader."Currency Code" <> '' then begin
                    Currency.TestField("Unit-Amount Rounding Precision");
                    "Unit Cost" :=
                      Round(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          GetDate, SalesHeader."Currency Code",
                          "Unit Cost (LCY)", SalesHeader."Currency Factor"),
                        Currency."Unit-Amount Rounding Precision")
                end else
                    "Unit Cost" := "Unit Cost (LCY)";
            end;
        }
        field(25; "VAT %"; Decimal)
        {
            Caption = 'Tax %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                "Line Discount Amount" :=
                  Round(
                    Round(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100, Currency."Amount Rounding Precision");
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                TestField(Quantity);
                if xRec."Line Discount Amount" <> "Line Discount Amount" then
                    if Round(Quantity * "Unit Price", Currency."Amount Rounding Precision") <> 0 then
                        "Line Discount %" :=
                          Round(
                            "Line Discount Amount" / Round(Quantity * "Unit Price", Currency."Amount Rounding Precision") * 100,
                            0.00001)
                    else
                        "Line Discount %" := 0;
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(29; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;

            trigger OnValidate()
            begin
                Amount := Round(Amount, Currency."Amount Rounding Precision");
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            "VAT Base Amount" :=
                              Round(Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              Round(Amount + "VAT Base Amount" * "VAT %" / 100, Currency."Amount Rounding Precision");
                        end;
                    "VAT Calculation Type"::"Full VAT":
                        if Amount <> 0 then
                            FieldError(Amount,
                              StrSubstNo(
                                Text009, FieldCaption("VAT Calculation Type"),
                                "VAT Calculation Type"));
                    "VAT Calculation Type"::"Sales Tax":
                        begin
                            SalesHeader.TestField("VAT Base Discount %", 0);
                            "VAT Base Amount" := Round(Amount, Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              Amount +
                              SalesTaxCalculate.CalculateTax(
                                "Tax Area Code", "Tax Group Code", "Tax Liable", SalesHeader."Posting Date",
                                "VAT Base Amount", "Quantity (Base)", SalesHeader."Currency Factor");
                            if "VAT Base Amount" <> 0 then
                                "VAT %" :=
                                  Round(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                            else
                                "VAT %" := 0;
                            "Amount Including VAT" := Round("Amount Including VAT", Currency."Amount Rounding Precision");
                        end;
                end;

                InitOutstandingAmount;
            end;
        }
        field(30; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including Tax';
            Editable = false;

            trigger OnValidate()
            begin
                "Amount Including VAT" := Round("Amount Including VAT", Currency."Amount Rounding Precision");
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            Amount :=
                              Round(
                                "Amount Including VAT" /
                                (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                                Currency."Amount Rounding Precision");
                            "VAT Base Amount" :=
                              Round(Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                        end;
                    "VAT Calculation Type"::"Full VAT":
                        begin
                            Amount := 0;
                            "VAT Base Amount" := 0;
                        end;
                    "VAT Calculation Type"::"Sales Tax":
                        begin
                            SalesHeader.TestField("VAT Base Discount %", 0);
                            Amount :=
                              SalesTaxCalculate.ReverseCalculateTax(
                                "Tax Area Code", "Tax Group Code", "Tax Liable", SalesHeader."Posting Date",
                                "Amount Including VAT", "Quantity (Base)", SalesHeader."Currency Factor");
                            if Amount <> 0 then
                                "VAT %" :=
                                  Round(100 * ("Amount Including VAT" - Amount) / Amount, 0.00001)
                            else
                                "VAT %" := 0;
                            Amount := Round(Amount, Currency."Amount Rounding Precision");
                            "VAT Base Amount" := Amount;
                        end;
                end;

                InitOutstandingAmount;
            end;
        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Allow Invoice Disc." <> xRec."Allow Invoice Disc.") and
                   (not "Allow Invoice Disc.")
                then begin
                    "Inv. Discount Amount" := 0;
                    "Inv. Disc. Amount to Invoice" := 0;
                    UpdateAmounts;
                end;
            end;
        }
        field(34; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
        }
        field(37; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0 : 5;
        }
        field(38; "Appl.-to Item Entry"; Integer)
        {
            Caption = 'Appl.-to Item Entry';

            trigger OnLookup()
            begin
                SelectItemEntry(FieldNo("Appl.-to Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
                ItemTrackingLines: Page "Item Tracking Lines";
            begin
                if "Appl.-to Item Entry" <> 0 then begin
                    //fes mig AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                    TestField(Type, Type::Item);
                    TestField(Quantity);
                    if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then begin
                        if Quantity > 0 then
                            FieldError(Quantity, Text030);
                    end else begin
                        if Quantity < 0 then
                            FieldError(Quantity, Text029);
                    end;
                    ItemLedgEntry.Get("Appl.-to Item Entry");
                    ItemLedgEntry.TestField(Positive, true);
                    if (ItemLedgEntry."Lot No." <> '') or (ItemLedgEntry."Serial No." <> '') then
                        Error(Text040, ItemTrackingLines.Caption, FieldCaption("Appl.-to Item Entry"));
                    if Abs("Qty. to Ship (Base)") > ItemLedgEntry.Quantity then
                        Error(ShippingMoreUnitsThanReceivedErr, ItemLedgEntry.Quantity, ItemLedgEntry."Document No.");

                    Validate("Unit Cost (LCY)", CalcUnitCost(ItemLedgEntry));

                    "Location Code" := ItemLedgEntry."Location Code";
                    if not ItemLedgEntry.Open then
                        Message(Text042, "Appl.-to Item Entry");
                end;
            end;
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                //fes mig ATOLink.UpdateAsmDimFromSalesLine(Rec);
            end;
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                //fes mig ATOLink.UpdateAsmDimFromSalesLine(Rec);
            end;
        }
        field(42; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            Editable = false;
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Type = Type::Item then
                    UpdateUnitPrice(FieldNo("Customer Price Group"));
            end;
        }
        field(45; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            TableRelation = Job;
        }
        field(52; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";

            trigger OnValidate()
            begin
                if Type = Type::Resource then begin
                    TestStatusOpen;
                    if WorkType.Get("Work Type Code") then
                        Validate("Unit of Measure Code", WorkType."Unit of Measure Code");
                    UpdateUnitPrice(FieldNo("Work Type Code"));
                    Validate("Unit Price");
                    FindResUnitCost;
                end;
            end;
        }
        field(57; "Outstanding Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Outstanding Amount';
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
                GetSalesHeader;
                Currency2.InitRoundingPrecision;
                if SalesHeader."Currency Code" <> '' then
                    "Outstanding Amount (LCY)" :=
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          GetDate, "Currency Code",
                          "Outstanding Amount", SalesHeader."Currency Factor"),
                        Currency2."Amount Rounding Precision")
                else
                    "Outstanding Amount (LCY)" :=
                      Round("Outstanding Amount", Currency2."Amount Rounding Precision");
            end;
        }
        field(58; "Qty. Shipped Not Invoiced"; Decimal)
        {
            Caption = 'Qty. Shipped Not Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(59; "Shipped Not Invoiced"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Shipped Not Invoiced';
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
                GetSalesHeader;
                Currency2.InitRoundingPrecision;
                if SalesHeader."Currency Code" <> '' then
                    "Shipped Not Invoiced (LCY)" :=
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          GetDate, "Currency Code",
                          "Shipped Not Invoiced", SalesHeader."Currency Factor"),
                        Currency2."Amount Rounding Precision")
                else
                    "Shipped Not Invoiced (LCY)" :=
                      Round("Shipped Not Invoiced", Currency2."Amount Rounding Precision");
            end;
        }
        field(60; "Quantity Shipped"; Decimal)
        {
            Caption = 'Quantity Shipped';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(61; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(63; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            Editable = false;
        }
        field(64; "Shipment Line No."; Integer)
        {
            Caption = 'Shipment Line No.';
            Editable = false;
        }
        field(67; "Profit %"; Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(69; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            Editable = false;

            trigger OnValidate()
            begin
                CalcInvDiscToInvoice;
                UpdateAmounts;
            end;
        }
        field(71; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
            TableRelation = IF ("Drop Shipment" = CONST(true)) "Purchase Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            begin
                if (xRec."Purchase Order No." <> "Purchase Order No.") and (Quantity <> 0) then begin
                    //fes mig  ReserveSalesLine.VerifyChange(Rec,xRec);
                    //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                end;
            end;
        }
        field(72; "Purch. Order Line No."; Integer)
        {
            Caption = 'Purch. Order Line No.';
            Editable = false;
            TableRelation = IF ("Drop Shipment" = CONST(true)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                                                               "Document No." = FIELD("Purchase Order No."));

            trigger OnValidate()
            begin
                if (xRec."Purch. Order Line No." <> "Purch. Order Line No.") and (Quantity <> 0) then begin
                    //fes mig ReserveSalesLine.VerifyChange(Rec,xRec);
                    //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                end;
            end;
        }
        field(73; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment';
            Editable = true;

            trigger OnValidate()
            begin
                TestField("Document Type", "Document Type"::Order);
                TestField(Type, Type::Item);
                TestField("Quantity Shipped", 0);
                TestField("Job No.", '');
                TestField("Qty. to Asm. to Order (Base)", 0);

                if "Drop Shipment" then
                    TestField("Special Order", false);

                CheckAssocPurchOrder(FieldCaption("Drop Shipment"));

                if "Drop Shipment" then begin
                    Reserve := Reserve::Never;
                    Validate(Quantity, Quantity);
                    if "Drop Shipment" then begin
                        Evaluate("Outbound Whse. Handling Time", '<0D>');
                        Evaluate("Shipping Time", '<0D>');
                        UpdateDates;
                        "Bin Code" := '';
                    end;
                end else begin
                    GetItem;
                    if Item.Reserve = Item.Reserve::Optional then begin
                        GetSalesHeader;
                        Reserve := SalesHeader.Reserve;
                    end else
                        Reserve := Item.Reserve;
                    if "Special Order" then
                        Reserve := Reserve::Never;
                end;

                if "Drop Shipment" then
                    "Bin Code" := '';

                CheckItemAvailable(FieldNo("Drop Shipment"));

                //fes mig AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                if (xRec."Drop Shipment" <> "Drop Shipment") and (Quantity <> 0) then begin
                    if not "Drop Shipment" then begin
                        InitQtyToAsm;
                        AutoAsmToOrder;
                        UpdateWithWarehouseShip
                    end else
                        InitQtyToShip;
                    //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                    //fes mig IF NOT FullReservedQtyIsForAsmToOrder THEN
                    //fes mig ReserveSalesLine.VerifyChange(Rec,xRec);
                end;
            end;
        }
        field(74; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(75; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(77; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            Caption = 'Tax Calculation Type';
            Editable = false;
            //OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            //OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(78; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(79; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(80; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            Editable = false;
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("Document No."));
        }
        field(81; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(82; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(83; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            var
                TaxArea: Record "Tax Area";
                HeaderTaxArea: Record "Tax Area";
            begin
                GetSalesHeader;
                SalesHeader.TestField(Status, SalesHeader.Status::Open);
                if "Tax Area Code" <> '' then begin
                    TaxArea.Get("Tax Area Code");
                    SalesHeader.TestField("Tax Area Code");
                    HeaderTaxArea.Get(SalesHeader."Tax Area Code");
                    // if TaxArea."Country/Region" <> HeaderTaxArea."Country/Region" then
                    //     Error(
                    //       Text1020003,
                    //       TaxArea.FieldCaption("Country/Region"),
                    //       TaxArea.TableCaption,
                    //       TableCaption,
                    //       SalesHeader.TableCaption);
                    // if TaxArea."Use External Tax Engine" <> HeaderTaxArea."Use External Tax Engine" then
                    //     Error(
                    //       Text1020003,
                    //       TaxArea.FieldCaption("Use External Tax Engine"),
                    //       TaxArea.TableCaption,
                    //       TableCaption,
                    //       SalesHeader.TableCaption);
                end;
                UpdateAmounts;
            end;
        }
        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            Editable = false;

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(87; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(88; "VAT Clause Code"; Code[10])
        {
            Caption = 'Tax Clause Code';
            TableRelation = "VAT Clause";
        }
        field(89; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Tax Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                Validate("VAT Prod. Posting Group");
            end;
        }
        field(90; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Tax Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                "VAT Difference" := 0;
                "VAT %" := VATPostingSetup."VAT %";
                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                "VAT Identifier" := VATPostingSetup."VAT Identifier";
                "VAT Clause Code" := VATPostingSetup."VAT Clause Code";
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Reverse Charge VAT",
                  "VAT Calculation Type"::"Sales Tax":
                        "VAT %" := 0;
                    "VAT Calculation Type"::"Full VAT":
                        begin
                            TestField(Type, Type::"G/L Account");
                            VATPostingSetup.TestField("Sales VAT Account");
                            TestField("No.", VATPostingSetup."Sales VAT Account");
                        end;
                end;
                if SalesHeader."Prices Including VAT" and (Type in [Type::Item, Type::Resource]) then
                    "Unit Price" :=
                      Round(
                        "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                        Currency."Unit-Amount Rounding Precision");
                UpdateAmounts;
            end;
        }
        field(91; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(92; "Outstanding Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Outstanding Amount ($)';
            Editable = false;
        }
        field(93; "Shipped Not Invoiced (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Shipped Not Invoiced ($)';
            Editable = false;
        }
        field(95; "Reserved Quantity"; Decimal)
        {
            CalcFormula = - Sum("Reservation Entry".Quantity WHERE("Source ID" = FIELD("Document No."),
                                                                   "Source Ref. No." = FIELD("Line No."),
                                                                   "Source Type" = CONST(37),
                                                                   "Source Subtype" = FIELD("Document Type"),
                                                                   "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(96; Reserve; Enum "Reserve Method")
        {
            Caption = 'Reserve';
            //OptionCaption = 'Never,Optional,Always';
            //OptionMembers = Never,Optional,Always;

            trigger OnValidate()
            begin
                if Reserve <> Reserve::Never then begin
                    TestField(Type, Type::Item);
                    TestField("No.");
                end;
                CalcFields("Reserved Qty. (Base)");
                if (Reserve = Reserve::Never) and ("Reserved Qty. (Base)" > 0) then
                    TestField("Reserved Qty. (Base)", 0);

                if "Drop Shipment" or "Special Order" then
                    TestField(Reserve, Reserve::Never);
                if xRec.Reserve = Reserve::Always then begin
                    GetItem;
                    if Item.Reserve = Item.Reserve::Always then
                        TestField(Reserve, Reserve::Always);
                end;
            end;
        }
        field(97; "Blanket Order No."; Code[20])
        {
            Caption = 'Blanket Order No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST("Blanket Order"));
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            begin
                TestField("Quantity Shipped", 0);
                BlanketOrderLookup;
            end;

            trigger OnValidate()
            begin
                TestField("Quantity Shipped", 0);
                if "Blanket Order No." = '' then
                    "Blanket Order Line No." := 0
                else
                    Validate("Blanket Order Line No.");
            end;
        }
        field(98; "Blanket Order Line No."; Integer)
        {
            Caption = 'Blanket Order Line No.';
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = CONST("Blanket Order"),
                                                           "Document No." = FIELD("Blanket Order No."));
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            begin
                BlanketOrderLookup;
            end;

            trigger OnValidate()
            begin
                TestField("Quantity Shipped", 0);
                if "Blanket Order Line No." <> 0 then begin
                    SalesLine2.Get("Document Type"::"Blanket Order", "Blanket Order No.", "Blanket Order Line No.");
                    SalesLine2.TestField(Type, Type);
                    SalesLine2.TestField("No.", "No.");
                    SalesLine2.TestField("Bill-to Customer No.", "Bill-to Customer No.");
                    SalesLine2.TestField("Sell-to Customer No.", "Sell-to Customer No.");
                end;
            end;
        }
        field(99; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Tax Base Amount';
            Editable = false;
        }
        field(100; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(101; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FieldNo("Line Amount"));
            Caption = 'Line Amount';

            trigger OnValidate()
            begin
                TestField(Type);
                TestField(Quantity);
                TestField("Unit Price");
                GetSalesHeader;
                "Line Amount" := Round("Line Amount", Currency."Amount Rounding Precision");
                Validate(
                  "Line Discount Amount", Round(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Amount");
            end;
        }
        field(104; "VAT Difference"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Tax Difference';
            Editable = false;
        }
        field(105; "Inv. Disc. Amount to Invoice"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            Editable = false;
        }
        field(106; "VAT Identifier"; Code[10])
        {
            Caption = 'Tax Identifier';
            Editable = false;
        }
        field(107; "IC Partner Ref. Type"; Option)
        {
            Caption = 'IC Partner Ref. Type';
            OptionCaption = ' ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.';
            OptionMembers = " ","G/L Account",Item,,,"Charge (Item)","Cross Reference","Common Item No.";

            trigger OnValidate()
            begin
                if "IC Partner Code" <> '' then
                    "IC Partner Ref. Type" := "IC Partner Ref. Type"::"G/L Account";
                if "IC Partner Ref. Type" <> xRec."IC Partner Ref. Type" then
                    "IC Partner Reference" := '';
                if "IC Partner Ref. Type" = "IC Partner Ref. Type"::"Common Item No." then begin
                    if Item."No." <> "No." then
                        Item.Get("No.");
                    "IC Partner Reference" := Item."Common Item No.";
                end;
            end;
        }
        field(108; "IC Partner Reference"; Code[20])
        {
            Caption = 'IC Partner Reference';

            trigger OnLookup()
            var
                ICGLAccount: Record "IC G/L Account";
                ItemCrossReference: Record "Item Reference";
            begin
                if "No." <> '' then
                    case "IC Partner Ref. Type" of
                        "IC Partner Ref. Type"::"G/L Account":
                            begin
                                if ICGLAccount.Get("IC Partner Reference") then;
                                if PAGE.RunModal(PAGE::"IC G/L Account List", ICGLAccount) = ACTION::LookupOK then
                                    Validate("IC Partner Reference", ICGLAccount."No.");
                            end;
                        "IC Partner Ref. Type"::Item:
                            begin
                                if Item.Get("IC Partner Reference") then;
                                if PAGE.RunModal(PAGE::"Item List", Item) = ACTION::LookupOK then
                                    Validate("IC Partner Reference", Item."No.");
                            end;
                        "IC Partner Ref. Type"::"Cross Reference":
                            begin
                                ItemCrossReference.Reset;
                                ItemCrossReference.SetCurrentKey("Reference Type", "Reference Type No.");
                                ItemCrossReference.SetFilter(
                                  "Reference Type", '%1|%2',
                                  ItemCrossReference."Reference Type"::Customer,
                                  ItemCrossReference."Reference Type"::" ");
                                ItemCrossReference.SetFilter("Reference Type No.", '%1|%2', "Sell-to Customer No.", '');
                                if PAGE.RunModal(PAGE::"Item Reference List", ItemCrossReference) = ACTION::LookupOK then
                                    Validate("IC Partner Reference", ItemCrossReference."Reference No.");
                            end;
                    end;
            end;
        }
        field(109; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                GenPostingSetup: Record "General Posting Setup";
                GLAcc: Record "G/L Account";
            begin
                if ("Prepayment %" <> 0) and (Type <> Type::" ") then begin
                    TestField("Document Type", "Document Type"::Order);
                    TestField("No.");
                    if CurrFieldNo = FieldNo("Prepayment %") then
                        if "System-Created Entry" then
                            FieldError("Prepmt. Line Amount", StrSubstNo(Text045, 0));
                    if "System-Created Entry" then
                        "Prepayment %" := 0;
                    GenPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                    if GenPostingSetup."Sales Prepayments Account" <> '' then begin
                        GLAcc.Get(GenPostingSetup."Sales Prepayments Account");
                        VATPostingSetup.Get("VAT Bus. Posting Group", GLAcc."VAT Prod. Posting Group");
                    end else
                        Clear(VATPostingSetup);
                    "Prepayment VAT %" := VATPostingSetup."VAT %";
                    "Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
                    "Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
                    case "Prepmt. VAT Calc. Type" of
                        "VAT Calculation Type"::"Reverse Charge VAT",
                      "VAT Calculation Type"::"Sales Tax":
                            "Prepayment VAT %" := 0;
                        "VAT Calculation Type"::"Full VAT":
                            FieldError("Prepmt. VAT Calc. Type", StrSubstNo(Text041, "Prepmt. VAT Calc. Type"));
                    end;
                    "Prepayment Tax Group Code" := GLAcc."Tax Group Code";
                end;

                TestStatusOpen;
                if ("Prepmt. Amt. Inv." <> 0) and
                   ("Prepayment %" <> xRec."Prepayment %")
                then
                    FieldError("Prepayment %", StrSubstNo(Text050, xRec."Prepayment %"));
                if Type <> Type::" " then
                    UpdateAmounts;
            end;
        }
        field(110; "Prepmt. Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FieldNo("Prepmt. Line Amount"));
            Caption = 'Prepmt. Line Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
                PrePaymentLineAmountEntered := true;
                TestField("Line Amount");
                if "Prepmt. Line Amount" < "Prepmt. Amt. Inv." then
                    FieldError("Prepmt. Line Amount", StrSubstNo(Text044, "Prepmt. Amt. Inv."));
                if "Prepmt. Line Amount" > "Line Amount" then
                    FieldError("Prepmt. Line Amount", StrSubstNo(Text045, "Line Amount"));
                if "System-Created Entry" then
                    FieldError("Prepmt. Line Amount", StrSubstNo(Text045, 0));
                if Quantity <> 0 then
                    Validate("Prepayment %", Round("Prepmt. Line Amount" /
                        ("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity) * 100, 0.00001))
                else
                    Validate("Prepayment %", Round("Prepmt. Line Amount" * 100 / "Line Amount", 0.00001));
            end;
        }
        field(111; "Prepmt. Amt. Inv."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FieldNo("Prepmt. Amt. Inv."));
            Caption = 'Prepmt. Amt. Inv.';
            Editable = false;
        }
        field(112; "Prepmt. Amt. Incl. VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Incl. Tax';
            Editable = false;
        }
        field(113; "Prepayment Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount';
            Editable = false;
        }
        field(114; "Prepmt. VAT Base Amt."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Tax Base Amt.';
            Editable = false;
        }
        field(115; "Prepayment VAT %"; Decimal)
        {
            Caption = 'Prepayment Tax %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(116; "Prepmt. VAT Calc. Type"; Enum "Tax Calculation Type")
        {
            Caption = 'Prepmt. Tax Calc. Type';
            Editable = false;
            //OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            //OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(117; "Prepayment VAT Identifier"; Code[10])
        {
            Caption = 'Prepayment Tax Identifier';
            Editable = false;
        }
        field(118; "Prepayment Tax Area Code"; Code[20])
        {
            Caption = 'Prepayment Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(119; "Prepayment Tax Liable"; Boolean)
        {
            Caption = 'Prepayment Tax Liable';

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(120; "Prepayment Tax Group Code"; Code[10])
        {
            Caption = 'Prepayment Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(121; "Prepmt Amt to Deduct"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FieldNo("Prepmt Amt to Deduct"));
            Caption = 'Prepmt Amt to Deduct';
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Prepmt Amt to Deduct" > "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" then
                    FieldError(
                      "Prepmt Amt to Deduct",
                      StrSubstNo(Text045, "Prepmt. Amt. Inv." - "Prepmt Amt Deducted"));

                if "Prepmt Amt to Deduct" > "Qty. to Invoice" * "Unit Price" then
                    FieldError(
                      "Prepmt Amt to Deduct",
                      StrSubstNo(Text045, "Qty. to Invoice" * "Unit Price"));

                if ("Prepmt. Amt. Inv." - "Prepmt Amt to Deduct" - "Prepmt Amt Deducted") >
                   (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Unit Price"
                then
                    FieldError(
                      "Prepmt Amt to Deduct",
                      StrSubstNo(Text044,
                        "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Unit Price"));
            end;
        }
        field(122; "Prepmt Amt Deducted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FieldNo("Prepmt Amt Deducted"));
            Caption = 'Prepmt Amt Deducted';
            Editable = false;
        }
        field(123; "Prepayment Line"; Boolean)
        {
            Caption = 'Prepayment Line';
            Editable = false;
        }
        field(124; "Prepmt. Amount Inv. Incl. VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. Incl. Tax';
            Editable = false;
        }
        field(129; "Prepmt. Amount Inv. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. ($)';
            Editable = false;
        }
        field(130; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";

            trigger OnValidate()
            begin
                if "IC Partner Code" <> '' then begin
                    TestField(Type, Type::"G/L Account");
                    GetSalesHeader;
                    SalesHeader.TestField("Sell-to IC Partner Code", '');
                    SalesHeader.TestField("Bill-to IC Partner Code", '');
                    Validate("IC Partner Ref. Type", "IC Partner Ref. Type"::"G/L Account");
                end;
            end;
        }
        field(132; "Prepmt. VAT Amount Inv. (LCY)"; Decimal)
        {
            Caption = 'Prepmt. Tax Amount Inv. ($)';
            Editable = false;
        }
        field(135; "Prepayment VAT Difference"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Tax Difference';
            Editable = false;
        }
        field(136; "Prepmt VAT Diff. to Deduct"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Tax Diff. to Deduct';
            Editable = false;
        }
        field(137; "Prepmt VAT Diff. Deducted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Tax Diff. Deducted';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(900; "Qty. to Assemble to Order"; Decimal)
        {
            Caption = 'Qty. to Assemble to Order';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                SalesLineReserve: Codeunit "Sales Line-Reserve";
            begin
                //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);

                "Qty. to Asm. to Order (Base)" := CalcBaseQty("Qty. to Assemble to Order");

                if "Qty. to Asm. to Order (Base)" <> 0 then begin
                    TestField("Drop Shipment", false);
                    TestField("Special Order", false);
                    if "Qty. to Asm. to Order (Base)" < 0 then
                        FieldError("Qty. to Assemble to Order", StrSubstNo(Text009, FieldCaption("Quantity (Base)"), "Quantity (Base)"));
                    TestField("Appl.-to Item Entry", 0);

                    case "Document Type" of
                        "Document Type"::"Blanket Order",
                      "Document Type"::Quote:
                            //fes mig IF ("Quantity (Base)" = 0) OR ("Qty. to Asm. to Order (Base)" <= 0) OR SalesLineReserve.ReservEntryExist(Rec) THEN
                            //fes mig TESTFIELD("Qty. to Asm. to Order (Base)",0)
                            //fes mig ELSE
                            if "Quantity (Base)" <> "Qty. to Asm. to Order (Base)" then
                                FieldError("Qty. to Assemble to Order", StrSubstNo(Text031, 0, "Quantity (Base)"));
                        "Document Type"::Order:
                            ;
                        else
                            TestField("Qty. to Asm. to Order (Base)", 0);
                    end;
                end;

                CheckItemAvailable(FieldNo("Qty. to Assemble to Order"));
                if not (CurrFieldNo in [FieldNo(Quantity), FieldNo("Qty. to Assemble to Order")]) then
                    GetDefaultBin;
                AutoAsmToOrder;
            end;
        }
        field(901; "Qty. to Asm. to Order (Base)"; Decimal)
        {
            Caption = 'Qty. to Asm. to Order (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate("Qty. to Assemble to Order", "Qty. to Asm. to Order (Base)");
            end;
        }
        field(902; "ATO Whse. Outstanding Qty."; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding" WHERE("Source Type" = CONST(37),
                                                                                  "Source Subtype" = FIELD("Document Type"),
                                                                                  "Source No." = FIELD("Document No."),
                                                                                  "Source Line No." = FIELD("Line No."),
                                                                                  "Assemble to Order" = FILTER(true)));
            Caption = 'ATO Whse. Outstanding Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(903; "ATO Whse. Outstd. Qty. (Base)"; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE("Source Type" = CONST(37),
                                                                                         "Source Subtype" = FIELD("Document Type"),
                                                                                         "Source No." = FIELD("Document No."),
                                                                                         "Source Line No." = FIELD("Line No."),
                                                                                         "Assemble to Order" = FILTER(true)));
            Caption = 'ATO Whse. Outstd. Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1001; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Editable = false;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(1002; "Job Contract Entry No."; Integer)
        {
            Caption = 'Job Contract Entry No.';
            Editable = false;

            trigger OnValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
                JobPlanningLine.SetCurrentKey("Job Contract Entry No.");
                JobPlanningLine.SetRange("Job Contract Entry No.", "Job Contract Entry No.");
                JobPlanningLine.FindFirst;
                /* CreateDim(
                  DimMgt.TypeToTableID3(Type), "No.",
                  DATABASE::Job, JobPlanningLine."Job No.",
                  DATABASE::"Responsibility Center", "Responsibility Center"); */
            end;
        }
        field(1300; "Posting Date"; Date)
        {
            CalcFormula = Lookup("Sales Header"."Posting Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                      "No." = FIELD("Document No.")));
            Caption = 'Posting Date';
            FieldClass = FlowField;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            begin
                TestJobPlanningLine;
                if "Variant Code" <> '' then
                    TestField(Type, Type::Item);
                TestStatusOpen;
                CheckAssocPurchOrder(FieldCaption("Variant Code"));

                if xRec."Variant Code" <> "Variant Code" then begin
                    TestField("Qty. Shipped Not Invoiced", 0);
                    TestField("Shipment No.", '');

                    TestField("Return Qty. Rcd. Not Invd.", 0);
                    TestField("Return Receipt No.", '');
                    InitItemAppl(false);
                end;

                CheckItemAvailable(FieldNo("Variant Code"));

                if Type = Type::Item then begin
                    GetUnitCost;
                    UpdateUnitPrice(FieldNo("Variant Code"));
                end;

                GetDefaultBin;
                InitQtyToAsm;
                AutoAsmToOrder;
                if (xRec."Variant Code" <> "Variant Code") and (Quantity <> 0) then begin
                    //fes mig  IF NOT FullReservedQtyIsForAsmToOrder THEN
                    //fes mig ReserveSalesLine.VerifyChange(Rec,xRec);
                    //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                end;

                GetItemCrossRef(FieldNo("Variant Code"));
            end;
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = IF ("Document Type" = FILTER(Order | Invoice),
                                Quantity = FILTER(>= 0),
                                "Qty. to Asm. to Order (Base)" = CONST(0)) "Bin Content"."Bin Code" WHERE("Location Code" = FIELD("Location Code"),
                                                                                                         "Item No." = FIELD("No."),
                                                                                                         "Variant Code" = FIELD("Variant Code"))
            ELSE
            IF ("Document Type" = FILTER("Return Order" | "Credit Memo"),
                                                                                                                  Quantity = FILTER(< 0)) "Bin Content"."Bin Code" WHERE("Location Code" = FIELD("Location Code"),
                                                                                                                                                                       "Item No." = FIELD("No."),
                                                                                                                                                                       "Variant Code" = FIELD("Variant Code"))
            ELSE
            Bin.Code WHERE("Location Code" = FIELD("Location Code"));

            trigger OnLookup()
            var
                WMSManagement: Codeunit "WMS Management";
                BinCode: Code[20];
            begin
                if not IsInbound and ("Quantity (Base)" <> 0) then
                    BinCode := WMSManagement.BinContentLookUp("Location Code", "No.", "Variant Code", '', "Bin Code")
                else
                    BinCode := WMSManagement.BinLookUp("Location Code", "No.", "Variant Code", '');

                if BinCode <> '' then
                    Validate("Bin Code", BinCode);
            end;

            trigger OnValidate()
            var
                WMSManagement: Codeunit "WMS Management";
            begin
                if "Bin Code" <> '' then begin
                    if not IsInbound and ("Quantity (Base)" <> 0) and ("Qty. to Asm. to Order (Base)" = 0) then
                        WMSManagement.FindBinContent("Location Code", "Bin Code", "No.", "Variant Code", '')
                    else
                        WMSManagement.FindBin("Location Code", "Bin Code", '');
                end;

                if "Drop Shipment" then
                    CheckAssocPurchOrder(FieldCaption("Bin Code"));

                TestField(Type, Type::Item);
                TestField("Location Code");

                if (Type = Type::Item) and ("Bin Code" <> '') then begin
                    TestField("Drop Shipment", false);
                    GetLocation("Location Code");
                    Location.TestField("Bin Mandatory");
                    CheckWarehouse;
                end;
                //fes mig ATOLink.UpdateAsmBinCodeFromSalesLine(Rec);
            end;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5405; Planned; Boolean)
        {
            Caption = 'Planned';
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            IF (Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."))
            ELSE
            "Unit of Measure";

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
                GLSetup: Record "General Ledger Setup";
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                GLSetup.Get;
                // if GLSetup."PAC Environment" <> GLSetup."PAC Environment"::Disabled then
                //     TestField("Unit of Measure Code");
                TestField("Quantity Shipped", 0);
                TestField("Qty. Shipped (Base)", 0);
                if "Unit of Measure Code" <> xRec."Unit of Measure Code" then begin
                    TestField("Shipment No.", '');
                    TestField("Return Receipt No.", '');
                end;

                CheckAssocPurchOrder(FieldCaption("Unit of Measure Code"));

                if "Unit of Measure Code" = '' then
                    "Unit of Measure" := ''
                else begin
                    if not UnitOfMeasure.Get("Unit of Measure Code") then
                        UnitOfMeasure.Init;
                    "Unit of Measure" := UnitOfMeasure.Description;
                    GetSalesHeader;
                    if SalesHeader."Language Code" <> '' then begin
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", SalesHeader."Language Code");
                        if UnitOfMeasureTranslation.FindFirst then
                            "Unit of Measure" := UnitOfMeasureTranslation.Description;
                    end;
                end;
                GetItemCrossRef(FieldNo("Unit of Measure Code"));
                case Type of
                    Type::Item:
                        begin
                            GetItem;
                            GetUnitCost;
                            UpdateUnitPrice(FieldNo("Unit of Measure Code"));
                            CheckItemAvailable(FieldNo("Unit of Measure Code"));
                            "Gross Weight" := Item."Gross Weight" * "Qty. per Unit of Measure";
                            "Net Weight" := Item."Net Weight" * "Qty. per Unit of Measure";
                            "Unit Volume" := Item."Unit Volume" * "Qty. per Unit of Measure";
                            "Units per Parcel" := Round(Item."Units per Parcel" / "Qty. per Unit of Measure", 0.00001);
                            //fes mig IF (xRec."Unit of Measure Code" <> "Unit of Measure Code") AND (Quantity <> 0) THEN
                            //fes mig WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                            if "Qty. per Unit of Measure" > xRec."Qty. per Unit of Measure" then
                                InitItemAppl(false);
                        end;
                    Type::Resource:
                        begin
                            if "Unit of Measure Code" = '' then begin
                                GetResource;
                                "Unit of Measure Code" := Resource."Base Unit of Measure";
                            end;
                            ResUnitofMeasure.Get("No.", "Unit of Measure Code");
                            "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                            UpdateUnitPrice(FieldNo("Unit of Measure Code"));
                            FindResUnitCost;
                        end;
                    Type::"G/L Account", Type::"Fixed Asset", Type::"Charge (Item)", Type::" ":
                        "Qty. per Unit of Measure" := 1;
                end;
                Validate(Quantity);
            end;
        }
        field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestJobPlanningLine;
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Quantity (Base)");
                UpdateUnitPrice(FieldNo("Quantity (Base)"));
            end;
        }
        field(5416; "Outstanding Qty. (Base)"; Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(5417; "Qty. to Invoice (Base)"; Decimal)
        {
            Caption = 'Qty. to Invoice (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate("Qty. to Invoice", "Qty. to Invoice (Base)");
            end;
        }
        field(5418; "Qty. to Ship (Base)"; Decimal)
        {
            Caption = 'Qty. to Ship (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate("Qty. to Ship", "Qty. to Ship (Base)");
            end;
        }
        field(5458; "Qty. Shipped Not Invd. (Base)"; Decimal)
        {
            Caption = 'Qty. Shipped Not Invd. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5460; "Qty. Shipped (Base)"; Decimal)
        {
            Caption = 'Qty. Shipped (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5461; "Qty. Invoiced (Base)"; Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5495; "Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = - Sum("Reservation Entry"."Quantity (Base)" WHERE("Source ID" = FIELD("Document No."),
                                                                            "Source Ref. No." = FIELD("Line No."),
                                                                            "Source Type" = CONST(37),
                                                                            "Source Subtype" = FIELD("Document Type"),
                                                                            "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure");
                CalcFields("Reserved Quantity");
                Planned := "Reserved Quantity" = "Outstanding Quantity";
            end;
        }
        field(5600; "FA Posting Date"; Date)
        {
            Caption = 'FA Posting Date';
        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";

            trigger OnValidate()
            begin
                GetFAPostingGroup;
            end;
        }
        field(5605; "Depr. until FA Posting Date"; Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
        }
        field(5612; "Duplicate in Depreciation Book"; Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";

            trigger OnValidate()
            begin
                "Use Duplication List" := false;
            end;
        }
        field(5613; "Use Duplication List"; Boolean)
        {
            Caption = 'Use Duplication List';

            trigger OnValidate()
            begin
                "Duplicate in Depreciation Book" := '';
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                /* CreateDim(
                  DATABASE::"Responsibility Center", "Responsibility Center",
                  DimMgt.TypeToTableID3(Type), "No.",
                  DATABASE::Job, "Job No."); */
            end;
        }
        field(5701; "Out-of-Stock Substitution"; Boolean)
        {
            Caption = 'Out-of-Stock Substitution';
            Editable = false;
        }
        field(5702; "Substitution Available"; Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE(Type = CONST(Item),
                                                           "No." = FIELD("No."),
                                                           "Substitute Type" = CONST(Item)));
            Caption = 'Substitution Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5703; "Originally Ordered No."; Code[20])
        {
            Caption = 'Originally Ordered No.';
            TableRelation = IF (Type = CONST(Item)) Item;
        }
        field(5704; "Originally Ordered Var. Code"; Code[10])
        {
            Caption = 'Originally Ordered Var. Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("Originally Ordered No."));
        }
        field(5705; "Cross-Reference No."; Code[20])
        {
            Caption = 'Cross-Reference No.';

            trigger OnLookup()
            begin
                CrossReferenceNoLookUp;
            end;

            trigger OnValidate()
            var
                ReturnedCrossRef: Record "Item Reference";
            begin
                GetSalesHeader;
                "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                ReturnedCrossRef.Init;
                if "Cross-Reference No." <> '' then begin
                    //fes mig DistIntegration.ICRLookupSalesItem(Rec,ReturnedCrossRef);
                    if "No." <> ReturnedCrossRef."Item No." then
                        Validate("No.", ReturnedCrossRef."Item No.");
                    if ReturnedCrossRef."Variant Code" <> '' then
                        Validate("Variant Code", ReturnedCrossRef."Variant Code");

                    if ReturnedCrossRef."Unit of Measure" <> '' then
                        Validate("Unit of Measure Code", ReturnedCrossRef."Unit of Measure");
                end;

                "Unit of Measure (Cross Ref.)" := ReturnedCrossRef."Unit of Measure";
                "Cross-Reference Type" := ReturnedCrossRef."Reference Type";
                "Cross-Reference Type No." := ReturnedCrossRef."Reference Type No.";
                "Cross-Reference No." := ReturnedCrossRef."Reference No.";

                if ReturnedCrossRef.Description <> '' then
                    Description := ReturnedCrossRef.Description;

                UpdateUnitPrice(FieldNo("Cross-Reference No."));

                if SalesHeader."Send IC Document" and (SalesHeader."IC Direction" = SalesHeader."IC Direction"::Outgoing) then begin
                    "IC Partner Ref. Type" := "IC Partner Ref. Type"::"Cross Reference";
                    "IC Partner Reference" := "Cross-Reference No.";
                end;
            end;
        }
        field(5706; "Unit of Measure (Cross Ref.)"; Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(5707; "Cross-Reference Type"; Enum "Item Reference Type")
        {
            Caption = 'Cross-Reference Type';
            //OptionCaption = ' ,Customer,Vendor,Bar Code';
            //OptionMembers = " ",Customer,Vendor,"Bar Code";
        }
        field(5708; "Cross-Reference Type No."; Code[30])
        {
            Caption = 'Cross-Reference Type No.';
        }
        field(5709; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5710; Nonstock; Boolean)
        {
            Caption = 'Nonstock';
            Editable = false;
        }
        field(5711; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;

            trigger OnValidate()
            begin
                TestStatusOpen;
                TestField(Type, Type::Item);
                CheckAssocPurchOrder(FieldCaption(Type));

                if PurchasingCode.Get("Purchasing Code") then begin
                    "Drop Shipment" := PurchasingCode."Drop Shipment";
                    "Special Order" := PurchasingCode."Special Order";
                    if "Drop Shipment" or "Special Order" then begin
                        TestField("Qty. to Asm. to Order (Base)", 0);
                        CalcFields("Reserved Qty. (Base)");
                        TestField("Reserved Qty. (Base)", 0);
                        if (Quantity <> 0) and (Quantity = "Quantity Shipped") then
                            Error(SalesLineCompletelyShippedErr);
                        Reserve := Reserve::Never;
                        Validate(Quantity, Quantity);
                        if "Drop Shipment" then begin
                            Evaluate("Outbound Whse. Handling Time", '<0D>');
                            Evaluate("Shipping Time", '<0D>');
                            UpdateDates;
                            "Bin Code" := '';
                        end;
                    end;
                end else begin
                    "Drop Shipment" := false;
                    "Special Order" := false;

                    GetItem;
                    if Item.Reserve = Item.Reserve::Optional then begin
                        GetSalesHeader;
                        Reserve := SalesHeader.Reserve;
                    end else
                        Reserve := Item.Reserve;
                end;

                if ("Purchasing Code" <> xRec."Purchasing Code") and
                   (not "Drop Shipment") and
                   ("Drop Shipment" <> xRec."Drop Shipment")
                then begin
                    if "Location Code" = '' then begin
                        if InvtSetup.Get then
                            "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                    end else
                        if Location.Get("Location Code") then
                            "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                    if ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code") then
                        "Shipping Time" := ShippingAgentServices."Shipping Time"
                    else begin
                        GetSalesHeader;
                        "Shipping Time" := SalesHeader."Shipping Time";
                    end;
                    UpdateDates;
                end;
            end;
        }
        field(5712; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            //TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
            //TableRelation = "Item Category".Code WHERE("Parent Category" = FIELD("Item Category Code"));
        }
        field(5713; "Special Order"; Boolean)
        {
            Caption = 'Special Order';
            Editable = false;
        }
        field(5714; "Special Order Purchase No."; Code[20])
        {
            Caption = 'Special Order Purchase No.';
            TableRelation = IF ("Special Order" = CONST(true)) "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(5715; "Special Order Purch. Line No."; Integer)
        {
            Caption = 'Special Order Purch. Line No.';
            TableRelation = IF ("Special Order" = CONST(true)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                                                               "Document No." = FIELD("Special Order Purchase No."));
        }
        field(5749; "Whse. Outstanding Qty."; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding" WHERE("Source Type" = CONST(37),
                                                                                  "Source Subtype" = FIELD("Document Type"),
                                                                                  "Source No." = FIELD("Document No."),
                                                                                  "Source Line No." = FIELD("Line No.")));
            Caption = 'Whse. Outstanding Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5750; "Whse. Outstanding Qty. (Base)"; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE("Source Type" = CONST(37),
                                                                                         "Source Subtype" = FIELD("Document Type"),
                                                                                         "Source No." = FIELD("Document No."),
                                                                                         "Source Line No." = FIELD("Line No.")));
            Caption = 'Whse. Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752; "Completely Shipped"; Boolean)
        {
            Caption = 'Completely Shipped';
            Editable = false;
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Requested Delivery Date" <> xRec."Requested Delivery Date") and
                   ("Promised Delivery Date" <> 0D)
                then
                    Error(
                      Text028,
                      FieldCaption("Requested Delivery Date"),
                      FieldCaption("Promised Delivery Date"));

                if "Requested Delivery Date" <> 0D then
                    Validate("Planned Delivery Date", "Requested Delivery Date")
                else begin
                    GetSalesHeader;
                    Validate("Shipment Date", SalesHeader."Shipment Date");
                end;
            end;
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Promised Delivery Date" <> 0D then
                    Validate("Planned Delivery Date", "Promised Delivery Date")
                else
                    Validate("Requested Delivery Date");
            end;
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Drop Shipment" then
                    DateFormularZero("Shipping Time", FieldNo("Shipping Time"), FieldCaption("Shipping Time"));
                UpdateDates;
            end;
        }
        field(5793; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Drop Shipment" then
                    DateFormularZero("Outbound Whse. Handling Time",
                      FieldNo("Outbound Whse. Handling Time"), FieldCaption("Outbound Whse. Handling Time"));
                UpdateDates;
            end;
        }
        field(5794; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Planned Delivery Date" <> 0D then begin
                    PlannedDeliveryDateCalculated := true;

                    if Format("Shipping Time") <> '' then
                        Validate("Planned Shipment Date", CalcPlannedDeliveryDate(FieldNo("Planned Delivery Date")))
                    else
                        Validate("Planned Shipment Date", CalcPlannedShptDate(FieldNo("Planned Delivery Date")));

                    if "Planned Shipment Date" > "Planned Delivery Date" then
                        "Planned Delivery Date" := "Planned Shipment Date";
                end;
            end;
        }
        field(5795; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';

            trigger OnValidate()
            var
                CustomCalendarChange: array[2] of Record "Customized Calendar Change";
            begin
                TestStatusOpen;
                if "Planned Shipment Date" <> 0D then begin
                    PlannedShipmentDateCalculated := true;
                    CustomCalendarChange[1].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
                    CustomCalendarChange[2].SetSource(CalChange."Source Type"::Location, "Location Code", '', '');

                    if Format("Outbound Whse. Handling Time") <> '' then
                        Validate(
                          "Shipment Date",
                          CalendarMgmt.CalcDateBOC2(
                            Format("Outbound Whse. Handling Time"),
                            "Planned Shipment Date",
                            CustomCalendarChange,
                            false))
                    else
                        Validate(
                          "Shipment Date",
                          CalendarMgmt.CalcDateBOC(
                            Format(Format('')),
                            "Planned Shipment Date",
                            CustomCalendarChange,
                            false));
                end;
            end;
        }
        field(5796; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Shipping Agent Code" <> xRec."Shipping Agent Code" then
                    Validate("Shipping Agent Service Code", '');
            end;
        }
        field(5797; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Shipping Agent Service Code" <> xRec."Shipping Agent Service Code" then
                    Evaluate("Shipping Time", '<>');

                if "Drop Shipment" then begin
                    Evaluate("Shipping Time", '<0D>');
                    UpdateDates;
                end else begin
                    if ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code") then
                        "Shipping Time" := ShippingAgentServices."Shipping Time"
                    else begin
                        GetSalesHeader;
                        "Shipping Time" := SalesHeader."Shipping Time";
                    end;
                end;

                if ShippingAgentServices."Shipping Time" <> xRec."Shipping Time" then
                    Validate("Shipping Time", "Shipping Time");
            end;
        }
        field(5800; "Allow Item Charge Assignment"; Boolean)
        {
            Caption = 'Allow Item Charge Assignment';
            InitValue = true;

            trigger OnValidate()
            begin
                CheckItemChargeAssgnt;
            end;
        }
        field(5801; "Qty. to Assign"; Decimal)
        {
            CalcFormula = Sum("Item Charge Assignment (Sales)"."Qty. to Assign" WHERE("Document Type" = FIELD("Document Type"),
                                                                                       "Document No." = FIELD("Document No."),
                                                                                       "Document Line No." = FIELD("Line No.")));
            Caption = 'Qty. to Assign';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5802; "Qty. Assigned"; Decimal)
        {
            CalcFormula = Sum("Item Charge Assignment (Sales)"."Qty. Assigned" WHERE("Document Type" = FIELD("Document Type"),
                                                                                      "Document No." = FIELD("Document No."),
                                                                                      "Document Line No." = FIELD("Line No.")));
            Caption = 'Qty. Assigned';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5803; "Return Qty. to Receive"; Decimal)
        {
            Caption = 'Return Qty. to Receive';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                if (CurrFieldNo <> 0) and
                   (Type = Type::Item) and
                   ("Return Qty. to Receive" <> 0) and
                   (not "Drop Shipment")
                then
                    CheckWarehouse;

                if "Return Qty. to Receive" = Quantity - "Return Qty. Received" then
                    InitQtyToReceive
                else begin
                    "Return Qty. to Receive (Base)" := CalcBaseQty("Return Qty. to Receive");
                    InitQtyToInvoice;
                end;
                if ("Return Qty. to Receive" * Quantity < 0) or
                   (Abs("Return Qty. to Receive") > Abs("Outstanding Quantity")) or
                   (Quantity * "Outstanding Quantity" < 0)
                then
                    Error(
                      Text020,
                      "Outstanding Quantity");
                if ("Return Qty. to Receive (Base)" * "Quantity (Base)" < 0) or
                   (Abs("Return Qty. to Receive (Base)") > Abs("Outstanding Qty. (Base)")) or
                   ("Quantity (Base)" * "Outstanding Qty. (Base)" < 0)
                then
                    Error(
                      Text021,
                      "Outstanding Qty. (Base)");

                if (CurrFieldNo <> 0) and (Type = Type::Item) and ("Return Qty. to Receive" > 0) then
                    CheckApplFromItemLedgEntry(ItemLedgEntry);
            end;
        }
        field(5804; "Return Qty. to Receive (Base)"; Decimal)
        {
            Caption = 'Return Qty. to Receive (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate("Return Qty. to Receive", "Return Qty. to Receive (Base)");
            end;
        }
        field(5805; "Return Qty. Rcd. Not Invd."; Decimal)
        {
            Caption = 'Return Qty. Rcd. Not Invd.';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5806; "Ret. Qty. Rcd. Not Invd.(Base)"; Decimal)
        {
            Caption = 'Ret. Qty. Rcd. Not Invd.(Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5807; "Return Rcd. Not Invd."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Return Rcd. Not Invd.';
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
                GetSalesHeader;
                Currency2.InitRoundingPrecision;
                if SalesHeader."Currency Code" <> '' then
                    "Return Rcd. Not Invd. (LCY)" :=
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          GetDate, "Currency Code",
                          "Return Rcd. Not Invd.", SalesHeader."Currency Factor"),
                        Currency2."Amount Rounding Precision")
                else
                    "Return Rcd. Not Invd. (LCY)" :=
                      Round("Return Rcd. Not Invd.", Currency2."Amount Rounding Precision");
            end;
        }
        field(5808; "Return Rcd. Not Invd. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Return Rcd. Not Invd. ($)';
            Editable = false;
        }
        field(5809; "Return Qty. Received"; Decimal)
        {
            Caption = 'Return Qty. Received';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5810; "Return Qty. Received (Base)"; Decimal)
        {
            Caption = 'Return Qty. Received (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5811; "Appl.-from Item Entry"; Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;

            trigger OnLookup()
            begin
                SelectItemEntry(FieldNo("Appl.-from Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                if "Appl.-from Item Entry" <> 0 then begin
                    CheckApplFromItemLedgEntry(ItemLedgEntry);
                    Validate("Unit Cost (LCY)", CalcUnitCost(ItemLedgEntry));
                end;
            end;
        }
        field(5909; "BOM Item No."; Code[20])
        {
            Caption = 'BOM Item No.';
            TableRelation = Item;
        }
        field(6600; "Return Receipt No."; Code[20])
        {
            Caption = 'Return Receipt No.';
            Editable = false;
        }
        field(6601; "Return Receipt Line No."; Integer)
        {
            Caption = 'Return Receipt Line No.';
            Editable = false;
        }
        field(6608; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";

            trigger OnValidate()
            begin
                ValidateReturnReasonCode(FieldNo("Return Reason Code"));
            end;
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";

            trigger OnValidate()
            begin
                if Type = Type::Item then
                    UpdateUnitPrice(FieldNo("Customer Disc. Group"))
            end;
        }
        field(10000; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';
        }
        field(50000; "Cod. Procedencia"; Code[20])
        {
            TableRelation = Procedencia;
        }
        field(50001; "Cod. Edición"; Code[20])
        {
            // TableRelation = Table50131;
        }
        field(50002; Areas; Code[20])
        {
            // TableRelation = Table50132;
        }
        field(50003; "No. Paginas"; Decimal)
        {
        }
        field(50004; ISBN; Text[30])
        {
        }
        field(50005; "Componentes Prod."; Code[20])
        {
            TableRelation = "Componentes Prod.";
        }
        field(50006; "Nivel Educativo"; Code[20])
        {
            TableRelation = "Nivel Educativo APS";
        }
        field(50007; Cursos; Code[20])
        {
            TableRelation = Cursos;
        }
        field(50008; "Cantidad Inv. en Consignacion"; Decimal)
        {
        }
        field(50009; "Cantidad Consignacion Devuelta"; Decimal)
        {

            trigger OnValidate()
            begin
                //001
                Validate("Qty. to Ship", (Quantity - "Cantidad Consignacion Devuelta"));
            end;
        }
        field(50010; "No. Pedido Consignacion"; Code[20])
        {
        }
        field(50011; "No. Linea Pedido Consignacion"; Integer)
        {
        }
        field(50012; "No. Mov. Prod. Cosg. a Liq."; Integer)
        {
        }
        field(50013; "No. Estante"; Code[20])
        {
        }
        field(50014; "Cod. Cupon"; Code[20])
        {
            Caption = 'Coupon Code';
        }
        field(50015; "No. Linea Cupon"; Integer)
        {
            Caption = 'Coupon Line No.';
        }
        field(50016; "Cantidad Aprobada"; Decimal)
        {
            Caption = 'Approved Qty.';

            trigger OnValidate()
            var
                SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
            begin
                //008
                ConfSant.Get;
                if ConfSant."Cantidades sin Decimales" then begin
                    if Quantity mod 1 <> 0 then
                        Error(Error003);
                end;
                //008


                //007
                if Users.Get(UserId) then begin
                    if not Users."Aprueba Cantidades" then
                        Error(Error001);
                    Validate(Quantity, 0);
                    UpdateUnitPrice(FieldNo("Cantidad Aprobada"));
                    PreciosTipoVenta;//006
                    Modify;
                    Commit;

                    "Cantidad pendiente BO" := 0;
                    "Cantidad a Anular" := 0;
                    //fes mig CantDisp := SalesInfoPaneMgt.CalcAvailability_BackOrder(Rec);
                    if CantDisp >= "Cantidad Aprobada" then begin
                        Validate(Quantity, "Cantidad Aprobada");
                        UpdateUnitPrice(FieldNo("Cantidad Aprobada"));
                        PreciosTipoVenta;
                    end
                    else begin
                        Cust.Get("Sell-to Customer No.");
                        if CantDisp > 0 then begin
                            Validate(Quantity, CantDisp);
                            UpdateUnitPrice(FieldNo("Cantidad Aprobada"));
                            PreciosTipoVenta;
                        end;
                        if Cust."Admite Pendientes en Pedidos" then begin
                            if CantDisp >= 0 then
                                //VALIDATE("Cantidad pendiente BO","Cantidad Aprobada" - CantDisp) //-$019
                                Validate("Cantidad pendiente BO", "Cantidad Aprobada" - CantDisp - "Cantidad Anulada") //+$019
                            else begin
                                //VALIDATE("Cantidad pendiente BO","Cantidad Solicitada"); //-$019
                                Validate("Cantidad pendiente BO", "Cantidad Solicitada" - "Cantidad Anulada"); //+$019
                                Validate(Quantity, 0);
                            end;
                        end
                        //+$019
                        //ELSE
                        //  VALIDATE("Cantidad a Anular","Cantidad Aprobada" - CantDisp);
                        //-$019
                    end;
                    PreciosTipoVenta;
                end
                else
                    Error(Error001);
                //007
            end;
        }
        field(50017; "Cantidad pendiente BO"; Decimal)
        {
            Caption = 'BO Pending Qty.';

            trigger OnValidate()
            begin
                //"Cantidad a Anular" := "Cantidad pendiente BO";//005 //-$019
            end;
        }
        field(50018; "Cantidad a Anular"; Decimal)
        {
            Caption = 'Qty. to Void';

            trigger OnValidate()
            begin
                //+$017
                if "Cantidad a Anular" > "Cantidad pendiente BO" then
                    Error(Error002, FieldCaption("Cantidad a Anular"));

                if "Cantidad a Anular" < 0 then
                    Error(Error004, FieldCaption("Cantidad a Anular"));
                //-$017
            end;
        }
        field(50019; "Cantidad Solicitada"; Decimal)
        {
            Caption = 'Requested Qty.';

            trigger OnValidate()
            begin
                //008
                ConfSant.Get;
                if ConfSant."Cantidades sin Decimales" then begin
                    if Quantity mod 1 <> 0 then
                        Error(Error003);
                end;
                //008

                //007
                if Type <> Type::Item then
                    Validate(Quantity, "Cantidad Solicitada");
                //007
            end;
        }
        field(50020; Temporal; Boolean)
        {
            Caption = 'Temp';
        }
        field(50022; "Cantidad Anulada"; Decimal)
        {
            Caption = 'Qty. Canceled';
        }
        field(50040; "Cantidad a Ajustar"; Decimal)
        {
            Caption = 'Qty. To Adjust';

            trigger OnValidate()
            begin
                //007
                if "Cantidad a Ajustar" > "Cantidad pendiente BO" then
                    //ERROR(Error002); //-$017
                    Error(Error002, FieldCaption("Cantidad a Ajustar")); //+$017

                if "Cantidad a Ajustar" < 0 then
                    //ERROR(Error004); //-$017
                    Error(Error004, FieldCaption("Cantidad a Ajustar")); //+$017
                //007
            end;
        }
        field(50041; "Porcentaje Cant. Aprobada"; Decimal)
        {

            trigger OnValidate()
            var
                Error_L001: Label 'Porcentage must be between 0 and 100';
            begin
                //007
                if Type = Type::Item then begin
                    if ("Porcentaje Cant. Aprobada" > 100) or (("Porcentaje Cant. Aprobada" < 0)) then
                        Error(Error_L001);
                    Users.Get(UserId);
                    begin
                        if not Users."Aprueba Cantidades" then
                            Error(Error001);

                        Cantidad := (("Cantidad Solicitada" * "Porcentaje Cant. Aprobada") div 100);
                        //fes mig CantDisp := SalesInfoPaneMgt.CalcAvailability_BackOrder(Rec);
                        begin
                            Validate("Cantidad Aprobada", Cantidad);
                            Validate(Quantity, Cantidad);
                            UpdateUnitPrice(FieldNo("Porcentaje Cant. Aprobada"));
                            PreciosTipoVenta;//006
                        end;
                    end;
                end;
            end;
        }
        field(55012; "Parte del IVA"; Boolean)
        {
            Caption = 'VAT part';
            Description = 'Ecuador';
        }
        field(56001; "Disponible BackOrder"; Boolean)
        {
            Caption = 'Available';
            Description = 'Gestion BackOrder';
        }
        field(56002; "Cod. Oferta"; Code[20])
        {
        }
        field(76046; "Anulada en TPV"; Boolean)
        {
            Caption = 'POS Void';
            Description = 'DsPOS Standard';
        }
        field(76029; "Precio anulacion TPV"; Decimal)
        {
            Caption = 'Void POS Price';
            Description = 'DsPOS Standard';
        }
        field(76011; "Cantidad anulacion TPV"; Decimal)
        {
            Caption = 'Void POS Qty.';
            Description = 'DsPOS Standard';
        }
        field(76016; "Cantidad agregada"; Decimal)
        {
            Description = 'DsPOS Standard';
        }
        field(76018; "Cod. Vendedor"; Code[10])
        {
            Caption = 'Salesperson Code';
            Description = 'DsPOS Standard';
            TableRelation = Vendedores.Codigo;
        }
        field(76015; Devuelto; Boolean)
        {
            Description = 'DsPOS Standard';
        }
        field(76026; "Devuelto en Documento"; Code[20])
        {
            Description = 'DsPOS Standard';
        }
        field(76020; "Devuelto en Linea Documento"; Integer)
        {
            Description = 'DsPOS Standard';
        }
        field(76022; "Devuelve a Documento"; Code[20])
        {
            Description = 'DsPOS Standard';
        }
        field(76027; "Devuelve a Linea Documento"; Integer)
        {
            Description = 'DsPOS Standard';
        }
        field(76012; "Cantidad Alumnos"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Description = 'APS';
            Editable = false;
        }
        field(76034; Adopcion; Option)
        {
            Description = 'APS';
            Editable = false;
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(76014; "Cod. Colegio"; Code[20])
        {
            Description = 'APS';
            Editable = false;
            TableRelation = Contact;

            trigger OnValidate()
            var
                ColAdop: Record "Colegio - Log - Adopciones";
            begin
                //018
                if ("Cod. Colegio" <> '') and (Presupuesto = 0) then begin
                    ColAdop.Reset;
                    ColAdop.SetRange("Cod. Colegio", "Cod. Colegio");
                    ColAdop.SetRange("Cod. Producto", "No.");
                    if ColAdop.FindFirst then begin
                        Adopcion := ColAdop.Adopcion;
                        Presupuesto := ColAdop."Adopcion Real";
                    end;
                end;
            end;
        }
        field(76422; Presupuesto; Integer)
        {
            Description = 'APS';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount, "Amount Including VAT", "Outstanding Amount", "Shipped Not Invoiced", "Outstanding Amount (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Quantity";
        }
        key(Key2; "Document No.", "Line No.", "Document Type")
        {
        }
        key(Key3; "Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date")
        {
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key4; "Document Type", "Bill-to Customer No.", "Currency Code")
        {
            SumIndexFields = "Outstanding Amount", "Shipped Not Invoiced", "Outstanding Amount (LCY)", "Shipped Not Invoiced (LCY)", "Return Rcd. Not Invd. (LCY)";
        }
        key(Key5; "Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", "Shipment Date")
        {
            Enabled = false;
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key6; "Document Type", "Bill-to Customer No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Currency Code")
        {
            Enabled = false;
            SumIndexFields = "Outstanding Amount", "Shipped Not Invoiced", "Outstanding Amount (LCY)", "Shipped Not Invoiced (LCY)";
        }
        key(Key7; "Document Type", "Blanket Order No.", "Blanket Order Line No.")
        {
        }
        key(Key8; "Document Type", "Document No.", "Location Code")
        {
        }
        key(Key9; "Document Type", "Shipment No.", "Shipment Line No.")
        {
        }
        key(Key10; Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Document Type", "Shipment Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key11; "Document Type", "Sell-to Customer No.", "Shipment No.")
        {
            SumIndexFields = "Outstanding Amount (LCY)";
        }
        key(Key12; "Job Contract Entry No.")
        {
        }
        key(Key13; "Document Type", "Document No.", "Qty. Shipped Not Invoiced")
        {
        }
        key(Key14; "Document Type", "Document No.", Type, "No.")
        {
        }
        key(Key15; Type, "Document No.", "Document Type")
        {
            SumIndexFields = Quantity;
        }
        key(Key16; "No.", Type, "Shipment Date", "Location Code", "Document Type")
        {
        }
        key(Key17; "Location Code", "Shipment Date")
        {
        }
        key(Key18; "Disponible BackOrder")
        {
        }
        key(Key19; Devuelto, "Devuelve a Documento")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "Capable to Promise";
        JobCreateInvoice: Codeunit "Job Create-Invoice";
        SalesCommentLine: Record "Sales Comment Line";
    begin
        TestStatusOpen;
        if not StatusCheckSuspended and (SalesHeader.Status = SalesHeader.Status::Released) and
           (Type in [Type::"G/L Account", Type::"Charge (Item)", Type::Resource])
        then
            Validate(Quantity, 0);

        if (Quantity <> 0) and ItemExists("No.") then begin
            //fes mig ReserveSalesLine.DeleteLine(Rec);
            CalcFields("Reserved Qty. (Base)");
            TestField("Reserved Qty. (Base)", 0);
            if "Shipment No." = '' then
                TestField("Qty. Shipped Not Invoiced", 0);
            if "Return Receipt No." = '' then
                TestField("Return Qty. Rcd. Not Invd.", 0);
            //fes mig   WhseValidateSourceLine.SalesLineDelete(Rec);
        end;

        if ("Document Type" = "Document Type"::Order) and (Quantity <> "Quantity Invoiced") then
            TestField("Prepmt. Amt. Inv.", 0);

        CheckAssocPurchOrder('');
        //fes mig NonstockItemMgt.DelNonStockSales(Rec);

        if "Document Type" = "Document Type"::"Blanket Order" then begin
            SalesLine2.Reset;
            SalesLine2.SetCurrentKey("Document Type", "Blanket Order No.", "Blanket Order Line No.");
            SalesLine2.SetRange("Blanket Order No.", "Document No.");
            SalesLine2.SetRange("Blanket Order Line No.", "Line No.");
            if SalesLine2.FindFirst then
                SalesLine2.TestField("Blanket Order Line No.", 0);
        end;

        if Type = Type::Item then begin
            //fes mig ATOLink.DeleteAsmFromSalesLine(Rec);
            DeleteItemChargeAssgnt("Document Type", "Document No.", "Line No.");
        end;

        if Type = Type::"Charge (Item)" then
            DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");

        CapableToPromise.RemoveReqLines("Document No.", "Line No.", 0, false);

        if "Line No." <> 0 then begin
            SalesLine2.Reset;
            SalesLine2.SetRange("Document Type", "Document Type");
            SalesLine2.SetRange("Document No.", "Document No.");
            SalesLine2.SetRange("Attached to Line No.", "Line No.");
            SalesLine2.SetFilter("Line No.", '<>%1', "Line No.");
            SalesLine2.DeleteAll(true);
        end;

        if "Job Contract Entry No." <> 0 then
            //fes mig JobCreateInvoice.DeleteSalesLine(Rec);

            SalesCommentLine.SetRange("Document Type", "Document Type");
        SalesCommentLine.SetRange("No.", "Document No.");
        SalesCommentLine.SetRange("Document Line No.", "Line No.");
        if not SalesCommentLine.IsEmpty then
            SalesCommentLine.DeleteAll;
    end;

    trigger OnInsert()
    var
        SL: Record "Sales Line";
    begin
        TestStatusOpen;
        //fes mig IF Quantity <> 0 THEN
        //fes mig ReserveSalesLine.VerifyQuantity(Rec,xRec);
        LockTable;
        SalesHeader."No." := '';
        if Type = Type::Item then
            if SalesHeader.InventoryPickConflict("Document Type", "Document No.", SalesHeader."Shipping Advice") then
                Error(Text056, SalesHeader."Shipping Advice");
    end;

    trigger OnModify()
    begin
        if ("Document Type" = "Document Type"::"Blanket Order") and
           ((Type <> xRec.Type) or ("No." <> xRec."No."))
        then begin
            SalesLine2.Reset;
            SalesLine2.SetCurrentKey("Document Type", "Blanket Order No.", "Blanket Order Line No.");
            SalesLine2.SetRange("Blanket Order No.", "Document No.");
            SalesLine2.SetRange("Blanket Order Line No.", "Line No.");
            if SalesLine2.FindSet then
                repeat
                    SalesLine2.TestField(Type, Type);
                    SalesLine2.TestField("No.", "No.");
                until SalesLine2.Next = 0;
        end;

        //fes mig IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") AND NOT FullReservedQtyIsForAsmToOrder THEN
        //fes mig   ReserveSalesLine.VerifyChange(Rec,xRec);

        GetSalesHeader;                              //$015
        //fes mig SalesHeader.ControlClasificacionDevolucion;  //
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        Text000: Label 'You cannot delete the order line because it is associated with purchase order %1 line %2.';
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'You cannot change %1 because the order line is associated with purchase order %2 line %3.';
        Text003: Label 'must not be less than %1';
        Text005: Label 'You cannot invoice more than %1 units.';
        Text006: Label 'You cannot invoice more than %1 base units.';
        Text007: Label 'You cannot ship more than %1 units.';
        Text008: Label 'You cannot ship more than %1 base units.';
        Text009: Label ' must be 0 when %1 is %2';
        Text011: Label 'Automatic reservation is not possible.\Do you want to reserve items manually?';
        Text014: Label '%1 %2 is before work date %3';
        Text016: Label '%1 is required for %2 = %3.';
        Text017: Label '\The entered information may be disregarded by warehouse operations.';
        Text020: Label 'You cannot return more than %1 units.';
        Text021: Label 'You cannot return more than %1 base units.';
        Text026: Label 'You cannot change %1 if the item charge has already been posted.';
        CurrExchRate: Record "Currency Exchange Rate";
        SalesHeader: Record "Sales Header";
        SalesLine2: Record "Sales Line";
        TempSalesLine: Record "Sales Line";
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Resource: Record Resource;
        Currency: Record Currency;
        ItemTranslation: Record "Item Translation";
        Res: Record Resource;
        ResCost: Record "Price List Line";
        WorkType: Record "Work Type";
        VATPostingSetup: Record "VAT Posting Setup";
        StdTxt: Record "Standard Text";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        ReservEntry: Record "Reservation Entry";
        UnitOfMeasure: Record "Unit of Measure";
        FA: Record "Fixed Asset";
        ShippingAgentServices: Record "Shipping Agent Services";
        NonstockItem: Record "Nonstock Item";
        PurchasingCode: Record Purchasing;
        SKU: Record "Stockkeeping Unit";
        ItemCharge: Record "Item Charge";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        ReturnReason: Record "Return Reason";
        ATOLink: Record "Assemble-to-Order Link";
        Reservation: Page Reservation;
        ResFindUnitCost: Codeunit "Price Calculation - V16";
        //ResFindUnitCost: Codeunit "Resource-Find Cost";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        ReservMgt: Codeunit "Reservation Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        UOMMgt: Codeunit "Unit of Measure Management";
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        DimMgt: Codeunit DimensionManagement;
        ItemSubstitutionMgt: Codeunit "Item Subst.";
        DistIntegration: Codeunit "Dist. Integration";
        NonstockItemMgt: Codeunit "Catalog Item Management";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        JobPostLine: Codeunit "Job Post-Line";
        FullAutoReservation: Boolean;
        StatusCheckSuspended: Boolean;
        HasBeenShown: Boolean;
        PlannedShipmentDateCalculated: Boolean;
        PlannedDeliveryDateCalculated: Boolean;
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        ItemCategory: Record "Item Category";
        Text029: Label 'must be positive';
        Text030: Label 'must be negative';
        Text031: Label 'You must either specify %1 or %2.';
        CalendarMgmt: Codeunit "Calendar Management";
        CalChange: Record "Customized Calendar Change";
        Text034: Label 'The value of %1 field must be a whole number for the item included in the service item group if the %2 field in the Service Item Groups window contains a check mark.';
        Text035: Label 'Warehouse ';
        Text036: Label 'Inventory ';
        HideValidationDialog: Boolean;
        Text037: Label 'You cannot change %1 when %2 is %3 and %4 is positive.';
        Text038: Label 'You cannot change %1 when %2 is %3 and %4 is negative.';
        Text039: Label '%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.';
        Text040: Label 'You must use form %1 to enter %2, if item tracking is used.';
        Text041: Label 'You must cancel the existing approval for this document to be able to change the %1 field.';
        Text042: Label 'When posting the Applied to Ledger Entry %1 will be opened first';
        ShippingMoreUnitsThanReceivedErr: Label 'You cannot ship more than the %1 units that you have received for document no. %2.';
        Text044: Label 'cannot be less than %1';
        Text045: Label 'cannot be more than %1';
        Text046: Label 'You cannot return more than the %1 units that you have shipped for %2 %3.';
        Text047: Label 'must be positive when %1 is not 0.';
        TrackingBlocked: Boolean;
        Text048: Label 'You cannot use item tracking on a %1 created from a %2.';
        Text049: Label 'cannot be %1.';
        Text050: Label 'must be %1 when the Prepayment Invoice has already been posted', Comment = 'starts with a field name; %1 - numeric value';
        Text051: Label 'You cannot use %1 in a %2.';
        PrePaymentLineAmountEntered: Boolean;
        Text052: Label 'You cannot add an item line because an open warehouse shipment exists for the sales header and Shipping Advice is %1.\\You must add items as new lines to the existing warehouse shipment or change Shipping Advice to Partial.';
        Text053: Label 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text054: Label 'Canceled.';
        Text055: Label '%1 must not be greater than the sum of %2 and %3.', Comment = 'Quantity Invoiced must not be greater than the sum of Qty. Assigned and Qty. to Assign.';
        Text056: Label 'You cannot add an item line because an open inventory pick exists for the Sales Header and because Shipping Advice is %1.\\You must first post or delete the inventory pick or change Shipping Advice to Partial.';
        Text057: Label 'must have the same sign as the shipment';
        Text058: Label 'The quantity that you are trying to invoice is greater than the quantity in shipment %1.';
        Text059: Label 'must have the same sign as the return receipt';
        Text060: Label 'The quantity that you are trying to invoice is greater than the quantity in return receipt %1.';
        Text1020000: Label 'You must reopen the document since this will affect Sales Tax.';
        Text1020003: Label 'The %1 field in the %2 used on the %3 must match the %1 field in the %2 used on the %4.';
        SalesLineCompletelyShippedErr: Label 'You cannot change the purchasing code for a sales line that has been completely shipped.';
        Text50000: Label 'You''d reached the limit of sales lines allowed for a sales document.';
        Err001: Label 'This user is not allowed to modify %1';
        "*** Santillana ***": Integer;
        CustPostGr: Record "Customer Posting Group";
        "*** DSPos ***": Integer;
        cManejaParametros: Codeunit "Lanzador DsPOS";
        txt001: Label 'Este código de producto ya ha sido introducido previamente';
        txt002: Label 'This product is back ordered on request%1 for this same customer';
        txt003: Label 'Product is pending to serve the order %1 for this same customer. Please confirm if you want to continue';
        Users: Record "User Setup";
        ConfSant: Record "Config. Empresa";
        Error003: Label 'The current setup does not permit decimals quantities';
        Error001: Label 'User does not have permision to approve quantities in sales orders';
        Error002: Label 'Quantity to adjust cannot be grater than Remaining Qty. in BO';
        CantDisp: Decimal;
        Cust: Record Customer;
        Cantidad: Decimal;
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        CantidadSol: Decimal;
        Error005: Label 'You have reached the limit of allowed lines for an TPV order %1';
        Error004: Label 'Qty. to Adjust cannot be lower than 0';
        Error006: Label '%1 no puede ser mayor a la Disponibilidad';
        SH: Record "Sales Header";


    procedure InitOutstanding()
    begin
        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then begin
            "Outstanding Quantity" := Quantity - "Return Qty. Received";
            "Outstanding Qty. (Base)" := "Quantity (Base)" - "Return Qty. Received (Base)";
            "Return Qty. Rcd. Not Invd." := "Return Qty. Received" - "Quantity Invoiced";
            "Ret. Qty. Rcd. Not Invd.(Base)" := "Return Qty. Received (Base)" - "Qty. Invoiced (Base)";
        end else begin
            "Outstanding Quantity" := Quantity - "Quantity Shipped";
            "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Shipped (Base)";
            "Qty. Shipped Not Invoiced" := "Quantity Shipped" - "Quantity Invoiced";
            "Qty. Shipped Not Invd. (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
        end;
        CalcFields("Reserved Quantity");
        Planned := "Reserved Quantity" = "Outstanding Quantity";
        "Completely Shipped" := (Quantity <> 0) and ("Outstanding Quantity" = 0);
        InitOutstandingAmount;
    end;


    procedure InitOutstandingAmount()
    var
        AmountInclVAT: Decimal;
    begin
        if Quantity = 0 then begin
            "Outstanding Amount" := 0;
            "Outstanding Amount (LCY)" := 0;
            "Shipped Not Invoiced" := 0;
            "Shipped Not Invoiced (LCY)" := 0;
            "Return Rcd. Not Invd." := 0;
            "Return Rcd. Not Invd. (LCY)" := 0;
        end else begin
            GetSalesHeader;
            if SalesHeader."Prices Including VAT" then
                AmountInclVAT := "Line Amount" - "Inv. Discount Amount"
            else
                if "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" then
                    AmountInclVAT :=
                      "Line Amount" - "Inv. Discount Amount" +
                      Round(
                        SalesTaxCalculate.CalculateTax(
                          "Tax Area Code", "Tax Group Code", "Tax Liable", SalesHeader."Posting Date",
                          "Line Amount" - "Inv. Discount Amount", "Quantity (Base)", SalesHeader."Currency Factor"),
                        Currency."Amount Rounding Precision")
                else
                    AmountInclVAT :=
                      Round(
                        ("Line Amount" - "Inv. Discount Amount") *
                        (1 + "VAT %" / 100 * (1 - SalesHeader."VAT Base Discount %" / 100)),
                        Currency."Amount Rounding Precision");
            Validate(
              "Outstanding Amount",
              Round(
                AmountInclVAT * "Outstanding Quantity" / Quantity,
                Currency."Amount Rounding Precision"));
            if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
                Validate(
                  "Return Rcd. Not Invd.",
                  Round(
                    AmountInclVAT * "Return Qty. Rcd. Not Invd." / Quantity,
                    Currency."Amount Rounding Precision"))
            else
                Validate(
                  "Shipped Not Invoiced",
                  Round(
                    AmountInclVAT * "Qty. Shipped Not Invoiced" / Quantity,
                    Currency."Amount Rounding Precision"));
        end;
    end;


    procedure InitQtyToShip()
    begin
        "Qty. to Ship" := "Outstanding Quantity";
        "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";

        CheckServItemCreation;

        InitQtyToInvoice;
    end;


    procedure InitQtyToReceive()
    begin
        "Return Qty. to Receive" := "Outstanding Quantity";
        "Return Qty. to Receive (Base)" := "Outstanding Qty. (Base)";

        InitQtyToInvoice;
    end;


    procedure InitQtyToInvoice()
    begin
        "Qty. to Invoice" := MaxQtyToInvoice;
        "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
        "VAT Difference" := 0;
        CalcInvDiscToInvoice;
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then
            CalcPrepaymentToDeduct;
    end;

    local procedure InitItemAppl(OnlyApplTo: Boolean)
    begin
        "Appl.-to Item Entry" := 0;
        if not OnlyApplTo then
            "Appl.-from Item Entry" := 0;
    end;


    procedure MaxQtyToInvoice(): Decimal
    begin
        if "Prepayment Line" then
            exit(1);
        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
            exit("Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced");

        exit("Quantity Shipped" + "Qty. to Ship" - "Quantity Invoiced");
    end;


    procedure MaxQtyToInvoiceBase(): Decimal
    begin
        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
            exit("Return Qty. Received (Base)" + "Return Qty. to Receive (Base)" - "Qty. Invoiced (Base)");

        exit("Qty. Shipped (Base)" + "Qty. to Ship (Base)" - "Qty. Invoiced (Base)");
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(Round(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    local procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        SalesLine3: Record "Sales Line";
    begin
        ItemLedgEntry.SetRange("Item No.", "No.");
        if "Location Code" <> '' then
            ItemLedgEntry.SetRange("Location Code", "Location Code");
        ItemLedgEntry.SetRange("Variant Code", "Variant Code");

        if CurrentFieldNo = FieldNo("Appl.-to Item Entry") then begin
            ItemLedgEntry.SetCurrentKey("Item No.", Open);
            ItemLedgEntry.SetRange(Positive, true);
            ItemLedgEntry.SetRange(Open, true);
        end else begin
            ItemLedgEntry.SetCurrentKey("Item No.", Positive);
            ItemLedgEntry.SetRange(Positive, false);
            ItemLedgEntry.SetFilter("Shipped Qty. Not Returned", '<0');
        end;
        if PAGE.RunModal(PAGE::"Item Ledger Entries", ItemLedgEntry) = ACTION::LookupOK then begin
            //fes mig SalesLine3 := Rec;
            if CurrentFieldNo = FieldNo("Appl.-to Item Entry") then
                SalesLine3.Validate("Appl.-to Item Entry", ItemLedgEntry."Entry No.")
            else
                SalesLine3.Validate("Appl.-from Item Entry", ItemLedgEntry."Entry No.");
            CheckItemAvailable(CurrentFieldNo);
            //fes mig Rec := SalesLine3;
        end;
    end;


    procedure SetSalesHeader(NewSalesHeader: Record "Sales Header")
    begin
        SalesHeader := NewSalesHeader;

        if SalesHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            SalesHeader.TestField("Currency Factor");
            Currency.Get(SalesHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;

    local procedure GetSalesHeader()
    begin
        TestField("Document No.");
        if ("Document Type" <> SalesHeader."Document Type") or ("Document No." <> SalesHeader."No.") then begin
            SalesHeader.Get("Document Type", "Document No.");
            if SalesHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                SalesHeader.TestField("Currency Factor");
                Currency.Get(SalesHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;

    local procedure GetItem()
    begin
        TestField("No.");
        if "No." <> Item."No." then
            Item.Get("No.");
    end;


    procedure GetResource()
    begin
        TestField("No.");
        if "No." <> Resource."No." then
            Resource.Get("No.");
    end;

    local procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        GetSalesHeader;
        TestField("Qty. per Unit of Measure");

        case Type of
            Type::Item, Type::Resource:
                begin
                    //fes mig PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
                    //fes mig PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,CalledByFieldNo);
                end;
        end;


        //GRN Para los clientes internos
        CustPostGr.Get(SalesHeader."Customer Posting Group");
        if CustPostGr."Cliente Interno" then begin
            ConfSant.Get();
            if ConfSant."% Beneficio Vta. Cte. Internos" <> 0 then begin
                "Unit Price" := "Unit Cost" * (1 + (ConfSant."% Beneficio Vta. Cte. Internos" / 100));
                "Unit Price" := Round("Unit Price", Currency."Amount Rounding Precision");
            end
            else
                Validate("Unit Price", "Unit Cost");
        end
        else
            Validate("Unit Price");
    end;

    local procedure FindResUnitCost()
    begin
        ResCost.Init;
        ResCost."Asset Type" := ResCost."Asset Type"::Resource;
        ResCost."Product No." := "No.";
        ResCost."Work Type Code" := "Work Type Code";
        //ResFindUnitCost.Run(ResCost); //Unsupported feature
        Validate("Unit Cost (LCY)", ResCost."Unit Cost" * "Qty. per Unit of Measure");
    end;


    procedure UpdateAmounts()
    var
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        RemLineAmountToInvoice: Decimal;
    begin
        if CurrFieldNo <> FieldNo("Allow Invoice Disc.") then
            TestField(Type);
        GetSalesHeader;

        if "Line Amount" <> xRec."Line Amount" then
            "VAT Difference" := 0;
        if "Line Amount" <> Round(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Discount Amount" then begin
            "Line Amount" := Round(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Discount Amount";
            "VAT Difference" := 0;
        end;
        if SalesHeader."Tax Area Code" = '' then
            UpdateVATAmounts
        else
            if (CurrFieldNo <> 0) and (SalesHeader.Status = SalesHeader.Status::Released) then
                Error(Text1020000);
        if not "Prepayment Line" then begin
            if "Prepayment %" <> 0 then begin
                if Quantity < 0 then
                    FieldError(Quantity, StrSubstNo(Text047, FieldCaption("Prepayment %")));
                if "Unit Price" < 0 then
                    FieldError("Unit Price", StrSubstNo(Text047, FieldCaption("Prepayment %")));
            end;
            if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then begin
                "Prepayment VAT Difference" := 0;
                if not PrePaymentLineAmountEntered then
                    "Prepmt. Line Amount" := Round("Line Amount" * "Prepayment %" / 100, Currency."Amount Rounding Precision");
                if "Prepmt. Line Amount" < "Prepmt. Amt. Inv." then
                    FieldError("Prepmt. Line Amount", StrSubstNo(Text049, "Prepmt. Amt. Inv."));
                PrePaymentLineAmountEntered := false;
                if "Prepmt. Line Amount" <> 0 then begin
                    RemLineAmountToInvoice :=
                      Round("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity, Currency."Amount Rounding Precision");
                    if RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") then
                        FieldError("Prepmt. Line Amount", StrSubstNo(Text045, RemLineAmountToInvoice + "Prepmt Amt Deducted"));
                end;
            end;
        end;
        InitOutstandingAmount;
        if (CurrFieldNo <> 0) and
           not ((Type = Type::Item) and (CurrFieldNo = FieldNo("No.")) and (Quantity <> 0) and
                // a write transaction may have been started
                ("Qty. per Unit of Measure" <> xRec."Qty. per Unit of Measure")) and // ...continued condition
           ("Document Type" in ["Document Type"::Quote, "Document Type"::Order, "Document Type"::Invoice]) and
           (("Outstanding Amount" + "Shipped Not Invoiced") > 0)
        then
            //fes mig CustCheckCreditLimit.SalesLineCheck(Rec);

            if Type = Type::"Charge (Item)" then
                UpdateItemChargeAssgnt;

        if Quantity < xRec.Quantity then begin
            SalesCrMemoHdr.SetCurrentKey("Prepayment Order No.");
            SalesCrMemoHdr.SetRange("Prepayment Order No.", "Document No.");
            if SalesCrMemoHdr.FindFirst then begin
                SalesCrMemoHdr.CalcFields(Amount);
                if ("Prepmt. Amt. Inv." <> 0) and ("Prepayment %" <> 0) then
                    if "Line Amount" <> xRec."Line Amount" - SalesCrMemoHdr.Amount * 100 / "Prepayment %" then
                        FieldError("Line Amount", StrSubstNo(Text050, xRec."Line Amount"));
            end;
        end;
        CalcPrepaymentToDeduct;
    end;

    local procedure UpdateVATAmounts()
    var
        SalesLine2: Record "Sales Line";
        TotalLineAmount: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalQuantityBase: Decimal;
    begin
        GetSalesHeader;
        SalesLine2.SetRange("Document Type", "Document Type");
        SalesLine2.SetRange("Document No.", "Document No.");
        SalesLine2.SetFilter("Line No.", '<>%1', "Line No.");
        if "Line Amount" = 0 then
            if xRec."Line Amount" >= 0 then
                SalesLine2.SetFilter(Amount, '>%1', 0)
            else
                SalesLine2.SetFilter(Amount, '<%1', 0)
        else
            if "Line Amount" > 0 then
                SalesLine2.SetFilter(Amount, '>%1', 0)
            else
                SalesLine2.SetFilter(Amount, '<%1', 0);
        SalesLine2.SetRange("VAT Identifier", "VAT Identifier");
        SalesLine2.SetRange("Tax Group Code", "Tax Group Code");

        if "Line Amount" = "Inv. Discount Amount" then begin
            Amount := 0;
            "VAT Base Amount" := 0;
            "Amount Including VAT" := 0;
        end else begin
            TotalLineAmount := 0;
            TotalInvDiscAmount := 0;
            TotalAmount := 0;
            TotalAmountInclVAT := 0;
            TotalQuantityBase := 0;
            if ("VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax") or
               (("VAT Calculation Type" in
                 ["VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"Reverse Charge VAT"]) and ("VAT %" <> 0))
            then begin
                if SalesLine2.FindSet then
                    repeat
                        TotalLineAmount := TotalLineAmount + SalesLine2."Line Amount";
                        TotalInvDiscAmount := TotalInvDiscAmount + SalesLine2."Inv. Discount Amount";
                        TotalAmount := TotalAmount + SalesLine2.Amount;
                        TotalAmountInclVAT := TotalAmountInclVAT + SalesLine2."Amount Including VAT";
                        TotalQuantityBase := TotalQuantityBase + SalesLine2."Quantity (Base)";
                    until SalesLine2.Next = 0;
            end;

            if SalesHeader."Prices Including VAT" then
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            Amount :=
                              Round(
                                (TotalLineAmount - TotalInvDiscAmount + "Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                                Currency."Amount Rounding Precision") -
                              TotalAmount;
                            "VAT Base Amount" :=
                              Round(
                                Amount * (1 - SalesHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              TotalLineAmount + "Line Amount" -
                              Round(
                                (TotalAmount + Amount) * (SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                                Currency."Amount Rounding Precision", Currency.VATRoundingDirection) -
                              TotalAmountInclVAT - TotalInvDiscAmount - "Inv. Discount Amount";
                        end;
                    "VAT Calculation Type"::"Full VAT":
                        begin
                            Amount := 0;
                            "VAT Base Amount" := 0;
                        end;
                    "VAT Calculation Type"::"Sales Tax":
                        begin
                            SalesHeader.TestField("VAT Base Discount %", 0);
                            Amount :=
                              SalesTaxCalculate.ReverseCalculateTax(
                                "Tax Area Code", "Tax Group Code", "Tax Liable", SalesHeader."Posting Date",
                                TotalAmountInclVAT + "Amount Including VAT", TotalQuantityBase + "Quantity (Base)",
                                SalesHeader."Currency Factor") -
                              TotalAmount;
                            if Amount <> 0 then
                                "VAT %" :=
                                  Round(100 * ("Amount Including VAT" - Amount) / Amount, 0.00001)
                            else
                                "VAT %" := 0;
                            Amount := Round(Amount, Currency."Amount Rounding Precision");
                            "VAT Base Amount" := Amount;
                        end;
                end
            else
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            Amount := Round("Line Amount" - "Inv. Discount Amount", Currency."Amount Rounding Precision");
                            "VAT Base Amount" :=
                              Round(Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              TotalAmount + Amount +
                              Round(
                                (TotalAmount + Amount) * (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                                Currency."Amount Rounding Precision", Currency.VATRoundingDirection) -
                              TotalAmountInclVAT;
                        end;
                    "VAT Calculation Type"::"Full VAT":
                        begin
                            Amount := 0;
                            "VAT Base Amount" := 0;
                            "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount";
                        end;
                    "VAT Calculation Type"::"Sales Tax":
                        begin
                            Amount := Round("Line Amount" - "Inv. Discount Amount", Currency."Amount Rounding Precision");
                            "VAT Base Amount" := Amount;
                            "Amount Including VAT" :=
                              TotalAmount + Amount +
                              Round(
                                SalesTaxCalculate.CalculateTax(
                                  "Tax Area Code", "Tax Group Code", "Tax Liable", SalesHeader."Posting Date",
                                  TotalAmount + Amount, TotalQuantityBase + "Quantity (Base)",
                                  SalesHeader."Currency Factor"), Currency."Amount Rounding Precision") -
                              TotalAmountInclVAT;
                            if "VAT Base Amount" <> 0 then
                                "VAT %" :=
                                  Round(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                            else
                                "VAT %" := 0;
                        end;
                end;
        end;
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    begin
        if Reserve = Reserve::Always then
            exit;

        if "Shipment Date" = 0D then begin
            GetSalesHeader;
            if SalesHeader."Shipment Date" <> 0D then
                Validate("Shipment Date", SalesHeader."Shipment Date")
            else
                Validate("Shipment Date", WorkDate);
        end;

        if ((CalledByFieldNo = CurrFieldNo) or (CalledByFieldNo = FieldNo("Shipment Date"))) and GuiAllowed and
           ("Document Type" in ["Document Type"::Order, "Document Type"::Invoice]) and
           (Type = Type::Item) and ("No." <> '') and
           ("Outstanding Quantity" > 0) and
           ("Job Contract Entry No." = 0) and
           not (Nonstock or "Special Order")
        then
            //fes mig IF ItemCheckAvail.SalesLineCheck(Rec) THEN
            ItemCheckAvail.RaiseUpdateInterruptedError;
    end;


    procedure ShowReservation()
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        TestField(Reserve);
        Clear(Reservation);
        //fes mig Reservation.SetSalesLine(Rec);
        Reservation.RunModal;
    end;


    procedure ShowReservationEntries(Modal: Boolean)
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, true);
        //fes mig ReserveSalesLine.FilterReservFor(ReservEntry,Rec);
        if Modal then
            PAGE.RunModal(PAGE::"Reservation Entries", ReservEntry)
        else
            PAGE.Run(PAGE::"Reservation Entries", ReservEntry);
    end;


    procedure AutoReserve(ShowReservationForm: Boolean)
    var
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
    begin
        TestField(Type, Type::Item);
        TestField("No.");

        //fes mig ReserveSalesLine.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);
        if QtyToReserveBase <> 0 then begin
            //fes mig ReservMgt.SetSalesLine(Rec);
            TestField("Shipment Date");
            ReservMgt.AutoReserve(FullAutoReservation, '', "Shipment Date", QtyToReserve, QtyToReserveBase);
            Find;
            if not FullAutoReservation and ShowReservationForm then begin
                Commit;
                if Confirm(Text011, true) then begin
                    ShowReservation;
                    Find;
                end;
            end;
        end;
    end;


    procedure AutoAsmToOrder()
    begin
        //fes mig ATOLink.UpdateAsmFromSalesLine(Rec);
    end;


    procedure GetDate(): Date
    begin
        if SalesHeader."Posting Date" <> 0D then
            exit(SalesHeader."Posting Date");
        exit(WorkDate);
    end;


    procedure CalcPlannedDeliveryDate(CurrFieldNo: Integer): Date
    var
        CustomCalendarChange: array[2] of Record "Customized Calendar Change";
    begin
        if "Shipment Date" = 0D then
            exit("Planned Delivery Date");

        CustomCalendarChange[1].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
        CustomCalendarChange[2].SetSource(CalChange."Source Type"::Customer, "Sell-to Customer No.", '', '');

        case CurrFieldNo of
            FieldNo("Shipment Date"):
                exit(CalendarMgmt.CalcDateBOC(Format("Shipping Time"), "Planned Shipment Date", CustomCalendarChange, true));

            FieldNo("Planned Delivery Date"):
                exit(CalendarMgmt.CalcDateBOC2(Format("Shipping Time"), "Planned Delivery Date", CustomCalendarChange, true));
        end;
    end;


    procedure CalcPlannedShptDate(CurrFieldNo: Integer): Date
    var
        CustomCalendarChange: array[2] of Record "Customized Calendar Change";
    begin
        if "Shipment Date" = 0D then
            exit("Planned Shipment Date");

        case CurrFieldNo of
            FieldNo("Shipment Date"):
                begin
                    CustomCalendarChange[1].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
                    CustomCalendarChange[2].SetSource(CalChange."Source Type"::Location, "Location Code", '', '');
                    exit(CalendarMgmt.CalcDateBOC(Format("Outbound Whse. Handling Time"), "Shipment Date", CustomCalendarChange, true));
                    /*                     exit(CalendarMgmt.CalcDateBOC(
                                            Format("Outbound Whse. Handling Time"),
                                            "Shipment Date",
                                            CalChange."Source Type"::Location,
                                            "Location Code",
                                            '',
                                            CalChange."Source Type"::"Shipping Agent",
                                            "Shipping Agent Code",
                                            "Shipping Agent Service Code",
                                            true)); */
                end;
            FieldNo("Planned Delivery Date"):
                begin
                    CustomCalendarChange[1].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
                    CustomCalendarChange[2].SetSource(CalChange."Source Type"::Customer, "Sell-to Customer No.", '', '');
                    exit(CalendarMgmt.CalcDateBOC(Format(''), "Planned Delivery Date", CustomCalendarChange, true));
                    /*                     exit(CalendarMgmt.CalcDateBOC(
                                            Format(''),
                                            "Planned Delivery Date",
                                            CalChange."Source Type"::Customer,
                                            "Sell-to Customer No.",
                                            '',
                                            CalChange."Source Type"::"Shipping Agent",
                                            "Shipping Agent Code",
                                            "Shipping Agent Service Code",
                                            true)); */
                end;
        end;
    end;


    procedure SignedXX(Value: Decimal): Decimal
    begin
        case "Document Type" of
            "Document Type"::Quote,
          "Document Type"::Order,
          "Document Type"::Invoice,
          "Document Type"::"Blanket Order":
                exit(-Value);
            "Document Type"::"Return Order",
          "Document Type"::"Credit Memo":
                exit(Value);
        end;
    end;


    procedure BlanketOrderLookup()
    begin
        SalesLine2.Reset;
        SalesLine2.SetCurrentKey("Document Type", Type, "No.");
        SalesLine2.SetRange("Document Type", "Document Type"::"Blanket Order");
        SalesLine2.SetRange(Type, Type);
        SalesLine2.SetRange("No.", "No.");
        SalesLine2.SetRange("Bill-to Customer No.", "Bill-to Customer No.");
        SalesLine2.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
        if PAGE.RunModal(PAGE::"Sales Lines", SalesLine2) = ACTION::LookupOK then begin
            SalesLine2.TestField("Document Type", "Document Type"::"Blanket Order");
            "Blanket Order No." := SalesLine2."Document No.";
            Validate("Blanket Order Line No.", SalesLine2."Line No.");
        end;
    end;


    procedure ShowDimensions()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Document Type", "Document No.", "Line No."));
        VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        //fes mig ATOLink.UpdateAsmDimFromSalesLine(Rec);

        if OldDimSetID <> "Dimension Set ID" then
            Modify;
    end;


    procedure OpenItemTrackingLines()
    var
        Job: Record Job;
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        TestField("Quantity (Base)");
        if "Job Contract Entry No." <> 0 then
            Error(Text048, TableCaption, Job.TableCaption);
        //fes mig ReserveSalesLine.CallItemTracking(Rec);
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetSalesHeader;
        /*  "Dimension Set ID" :=
           DimMgt.GetDefaultDimID(
             TableID, No, SourceCodeSetup.Sales,
             "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
             SalesHeader."Dimension Set ID", DATABASE::Customer);
         DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code"); */
        //fes mig ATOLink.UpdateAsmDimFromSalesLine(Rec);
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure ShowItemSub()
    begin
        Clear(SalesHeader);
        TestStatusOpen;
        //fes mig ItemSubstitutionMgt.ItemSubstGet(Rec);
        //fes mig IF TransferExtendedText.SalesCheckIfAnyExtText(Rec,TRUE) THEN
        //fes mig TransferExtendedText.InsertSalesExtText(Rec);
    end;


    procedure ShowNonstock()
    begin
        TestField(Type, Type::Item);
        TestField("No.", '');
        if PAGE.RunModal(PAGE::"Catalog Item List", NonstockItem) = ACTION::LookupOK then begin
            NonstockItem.TestField("Item Templ. Code");
            ItemCategory.Get(NonstockItem."Item Templ. Code");
            ItemCategory.TestField("Def. Gen. Prod. Posting Group");
            ItemCategory.TestField("Def. Inventory Posting Group");

            "No." := NonstockItem."Entry No.";
            //fes mig   NonstockItemMgt.NonStockSales(Rec);
            Validate("No.", "No.");
            Validate("Unit Price", NonstockItem."Unit Price");
        end;
    end;

    local procedure GetFAPostingGroup()
    var
        LocalGLAcc: Record "G/L Account";
        FASetup: Record "FA Setup";
        FAPostingGr: Record "FA Posting Group";
        FADeprBook: Record "FA Depreciation Book";
        GLSetup: Record "General Ledger Setup";
    begin
        if (Type <> Type::"Fixed Asset") or ("No." = '') then
            exit;
        if "Depreciation Book Code" = '' then begin
            FASetup.Get;
            "Depreciation Book Code" := FASetup."Default Depr. Book";
            if not FADeprBook.Get("No.", "Depreciation Book Code") then
                "Depreciation Book Code" := '';
            if "Depreciation Book Code" = '' then
                exit;
        end;
        FADeprBook.Get("No.", "Depreciation Book Code");
        FADeprBook.TestField("FA Posting Group");
        FAPostingGr.Get(FADeprBook."FA Posting Group");
        FAPostingGr.TestField("Acq. Cost Acc. on Disposal");
        LocalGLAcc.Get(FAPostingGr."Acq. Cost Acc. on Disposal");
        LocalGLAcc.CheckGLAcc;
        GLSetup.Get;
        // if GLSetup."VAT in Use" then
        //     LocalGLAcc.TestField("Gen. Prod. Posting Group");
        "Posting Group" := FADeprBook."FA Posting Group";
        "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        "Tax Group Code" := LocalGLAcc."Tax Group Code";
        Validate("VAT Prod. Posting Group", LocalGLAcc."VAT Prod. Posting Group");
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(DATABASE::"Sales Line", FieldNumber);
        exit(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesHeader2: Record "Sales Header";
    begin
        if SalesHeader2.Get("Document Type", "Document No.") then;
        if SalesHeader2."Prices Including VAT" then
            exit('2,1,' + GetFieldCaption(FieldNumber))
        else
            exit('2,0,' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetSKU(): Boolean
    begin
        if (SKU."Location Code" = "Location Code") and
           (SKU."Item No." = "No.") and
           (SKU."Variant Code" = "Variant Code")
        then
            exit(true);
        if SKU.Get("Location Code", "No.", "Variant Code") then
            exit(true);

        exit(false);
    end;


    procedure GetUnitCost()
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        GetItem;
        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
        if GetSKU then
            Validate("Unit Cost (LCY)", SKU."Unit Cost" * "Qty. per Unit of Measure")
        else
            Validate("Unit Cost (LCY)", Item."Unit Cost" * "Qty. per Unit of Measure");
    end;

    local procedure CalcUnitCost(ItemLedgEntry: Record "Item Ledger Entry"): Decimal
    var
        ValueEntry: Record "Value Entry";
        UnitCost: Decimal;
    begin
        ValueEntry.SetCurrentKey("Item Ledger Entry No.");
        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
        if IsServiceItem then begin
            ValueEntry.CalcSums("Cost Amount (Non-Invtbl.)");
            UnitCost := ValueEntry."Cost Amount (Non-Invtbl.)" / ItemLedgEntry.Quantity;
        end else begin
            ValueEntry.CalcSums("Cost Amount (Actual)", "Cost Amount (Expected)");
            UnitCost :=
              (ValueEntry."Cost Amount (Expected)" + ValueEntry."Cost Amount (Actual)") / ItemLedgEntry.Quantity;
        end;

        exit(Abs(UnitCost * "Qty. per Unit of Measure"));
    end;


    procedure ShowItemChargeAssgnt()
    var
        ItemChargeAssgnts: Page "Item Charge Assignment (Sales)";
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
        ItemChargeAssgntLineAmt: Decimal;
    begin
        Get("Document Type", "Document No.", "Line No.");
        TestField(Type, Type::"Charge (Item)");
        TestField("No.");
        TestField(Quantity);

        GetSalesHeader;
        if SalesHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(SalesHeader."Currency Code");
        if ("Inv. Discount Amount" = 0) and
           ("Line Discount Amount" = 0) and
           (not SalesHeader."Prices Including VAT")
        then
            ItemChargeAssgntLineAmt := "Line Amount"
        else
            if SalesHeader."Prices Including VAT" then
                ItemChargeAssgntLineAmt :=
                  Round(("Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                    Currency."Amount Rounding Precision")
            else
                ItemChargeAssgntLineAmt := "Line Amount" - "Inv. Discount Amount";
        ItemChargeAssgntSales.Reset;
        ItemChargeAssgntSales.SetRange("Document Type", "Document Type");
        ItemChargeAssgntSales.SetRange("Document No.", "Document No.");
        ItemChargeAssgntSales.SetRange("Document Line No.", "Line No.");
        ItemChargeAssgntSales.SetRange("Item Charge No.", "No.");
        if not ItemChargeAssgntSales.FindLast then begin
            ItemChargeAssgntSales."Document Type" := "Document Type";
            ItemChargeAssgntSales."Document No." := "Document No.";
            ItemChargeAssgntSales."Document Line No." := "Line No.";
            ItemChargeAssgntSales."Item Charge No." := "No.";
            ItemChargeAssgntSales."Unit Cost" :=
              Round(ItemChargeAssgntLineAmt / Quantity,
                Currency."Unit-Amount Rounding Precision");
        end;

        ItemChargeAssgntLineAmt :=
          Round(
            ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),
            Currency."Amount Rounding Precision");

        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
            AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales, "Return Receipt No.")
        else
            AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales, "Shipment No.");
        Clear(AssignItemChargeSales);
        Commit;

        //fes mig ItemChargeAssgnts.Initialize(Rec,ItemChargeAssgntLineAmt);
        ItemChargeAssgnts.RunModal;
        CalcFields("Qty. to Assign");
    end;


    procedure UpdateItemChargeAssgnt()
    var
        ShareOfVAT: Decimal;
        TotalQtyToAssign: Decimal;
        TotalAmtToAssign: Decimal;
    begin
        CalcFields("Qty. Assigned", "Qty. to Assign");
        if Abs("Quantity Invoiced") > Abs(("Qty. Assigned" + "Qty. to Assign")) then
            Error(Text055, FieldCaption("Quantity Invoiced"), FieldCaption("Qty. Assigned"), FieldCaption("Qty. to Assign"));

        ItemChargeAssgntSales.Reset;
        ItemChargeAssgntSales.SetRange("Document Type", "Document Type");
        ItemChargeAssgntSales.SetRange("Document No.", "Document No.");
        ItemChargeAssgntSales.SetRange("Document Line No.", "Line No.");
        ItemChargeAssgntSales.CalcSums("Qty. to Assign");
        TotalQtyToAssign := ItemChargeAssgntSales."Qty. to Assign";
        if (CurrFieldNo <> 0) and (Amount <> xRec.Amount) then begin
            ItemChargeAssgntSales.SetFilter("Qty. Assigned", '<>0');
            if not ItemChargeAssgntSales.IsEmpty then
                Error(Text026,
                  FieldCaption(Amount));
            ItemChargeAssgntSales.SetRange("Qty. Assigned");
        end;

        if ItemChargeAssgntSales.FindSet then begin
            GetSalesHeader;
            if SalesHeader."Prices Including VAT" then
                TotalAmtToAssign :=
                  Round(("Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                    Currency."Amount Rounding Precision")
            else
                TotalAmtToAssign := "Line Amount" - "Inv. Discount Amount";
            repeat
                ShareOfVAT := 1;
                if SalesHeader."Prices Including VAT" then
                    ShareOfVAT := 1 + "VAT %" / 100;
                if Quantity <> 0 then
                    if ItemChargeAssgntSales."Unit Cost" <> Round(
                         ("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
                         Currency."Unit-Amount Rounding Precision")
                    then
                        ItemChargeAssgntSales."Unit Cost" :=
                          Round(("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
                            Currency."Unit-Amount Rounding Precision");
                if TotalQtyToAssign > 0 then begin
                    ItemChargeAssgntSales."Amount to Assign" :=
                      Round(ItemChargeAssgntSales."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                        Currency."Amount Rounding Precision");
                    TotalQtyToAssign -= ItemChargeAssgntSales."Qty. to Assign";
                    TotalAmtToAssign -= ItemChargeAssgntSales."Amount to Assign";
                end;
                ItemChargeAssgntSales.Modify;
            until ItemChargeAssgntSales.Next = 0;
            CalcFields("Qty. to Assign");
        end;
    end;

    local procedure DeleteItemChargeAssgnt(DocType: Enum "Sales Document Type"; DocNo: Code[20]; DocLineNo: Integer)
    begin
        ItemChargeAssgntSales.SetCurrentKey(
          "Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
        ItemChargeAssgntSales.SetRange("Applies-to Doc. Type", DocType);
        ItemChargeAssgntSales.SetRange("Applies-to Doc. No.", DocNo);
        ItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.", DocLineNo);
        if not ItemChargeAssgntSales.IsEmpty then
            ItemChargeAssgntSales.DeleteAll(true);
    end;

    local procedure DeleteChargeChargeAssgnt(DocType: Enum "Sales Document Type"; DocNo: Code[20]; DocLineNo: Integer)
    begin
        if DocType <> "Document Type"::"Blanket Order" then
            if "Quantity Invoiced" <> 0 then begin
                CalcFields("Qty. Assigned");
                TestField("Qty. Assigned", "Quantity Invoiced");
            end;
        ItemChargeAssgntSales.Reset;
        ItemChargeAssgntSales.SetRange("Document Type", DocType);
        ItemChargeAssgntSales.SetRange("Document No.", DocNo);
        ItemChargeAssgntSales.SetRange("Document Line No.", DocLineNo);
        if not ItemChargeAssgntSales.IsEmpty then
            ItemChargeAssgntSales.DeleteAll;
    end;


    procedure CheckItemChargeAssgnt()
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
    begin
        ItemChargeAssgntSales.SetCurrentKey(
          "Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
        ItemChargeAssgntSales.SetRange("Applies-to Doc. Type", "Document Type");
        ItemChargeAssgntSales.SetRange("Applies-to Doc. No.", "Document No.");
        ItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.", "Line No.");
        ItemChargeAssgntSales.SetRange("Document Type", "Document Type");
        ItemChargeAssgntSales.SetRange("Document No.", "Document No.");
        if ItemChargeAssgntSales.FindSet then begin
            TestField("Allow Item Charge Assignment");
            repeat
                ItemChargeAssgntSales.TestField("Qty. to Assign", 0);
            until ItemChargeAssgntSales.Next = 0;
        end;
    end;

    local procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetSalesHeader;
        if not "System-Created Entry" then
            if Type <> Type::" " then
                SalesHeader.TestField(Status, SalesHeader.Status::Open);
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure UpdateVATOnLines(QtyType: Option General,Invoicing,Shipping; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line")
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        InvDiscAmount: Decimal;
        LineAmountToInvoice: Decimal;
        LineAmountToInvoiceDiscounted: Decimal;
    begin
        if QtyType = QtyType::Shipping then
            exit;
        if SalesHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(SalesHeader."Currency Code");

        TempVATAmountLineRemainder.DeleteAll;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.LockTable;
        if SalesLine.FindSet then
            repeat
                if not ZeroAmountLine(QtyType) then begin
                    VATAmountLine.Get(SalesLine."VAT Identifier", SalesLine."VAT Calculation Type", SalesLine."Tax Group Code", false, SalesLine."Line Amount" >= 0);
                    if VATAmountLine.Modified then begin
                        if not TempVATAmountLineRemainder.Get(
                             SalesLine."VAT Identifier", SalesLine."VAT Calculation Type", SalesLine."Tax Group Code", false, SalesLine."Line Amount" >= 0)
                        then begin
                            TempVATAmountLineRemainder := VATAmountLine;
                            TempVATAmountLineRemainder.Init;
                            TempVATAmountLineRemainder.Insert;
                        end;

                        if QtyType = QtyType::General then
                            LineAmountToInvoice := SalesLine."Line Amount"
                        else
                            LineAmountToInvoice :=
                              Round(SalesLine."Line Amount" * SalesLine."Qty. to Invoice" / SalesLine.Quantity, Currency."Amount Rounding Precision");

                        if SalesLine."Allow Invoice Disc." then begin
                            if VATAmountLine."Inv. Disc. Base Amount" = 0 then
                                InvDiscAmount := 0
                            else begin
                                LineAmountToInvoiceDiscounted :=
                                  VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                                  VATAmountLine."Inv. Disc. Base Amount";
                                TempVATAmountLineRemainder."Invoice Discount Amount" :=
                                  TempVATAmountLineRemainder."Invoice Discount Amount" + LineAmountToInvoiceDiscounted;
                                InvDiscAmount :=
                                  Round(
                                    TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
                                LineAmountToInvoiceDiscounted := Round(LineAmountToInvoiceDiscounted, Currency."Amount Rounding Precision");
                                if (InvDiscAmount < 0) and (LineAmountToInvoiceDiscounted = 0) then
                                    InvDiscAmount := 0;
                                TempVATAmountLineRemainder."Invoice Discount Amount" :=
                                  TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                            end;
                            if QtyType = QtyType::General then begin
                                SalesLine."Inv. Discount Amount" := InvDiscAmount;
                                SalesLine.CalcInvDiscToInvoice;
                            end else
                                SalesLine."Inv. Disc. Amount to Invoice" := InvDiscAmount;
                        end else
                            InvDiscAmount := 0;

                        if QtyType = QtyType::General then
                            if SalesHeader."Prices Including VAT" then begin
                                if (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" = 0) or
                                   (SalesLine."Line Amount" = 0)
                                then begin
                                    VATAmount := 0;
                                    NewAmountIncludingVAT := 0;
                                end else begin
                                    VATAmount :=
                                      TempVATAmountLineRemainder."VAT Amount" +
                                      VATAmountLine."VAT Amount" *
                                      (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") /
                                      (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                                    NewAmountIncludingVAT :=
                                      TempVATAmountLineRemainder."Amount Including VAT" +
                                      VATAmountLine."Amount Including VAT" *
                                      (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") /
                                      (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                                end;
                                NewAmount :=
                                  Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision") -
                                  Round(VATAmount, Currency."Amount Rounding Precision");
                                NewVATBaseAmount :=
                                  Round(
                                    NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision");
                            end else begin
                                if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT" then begin
                                    VATAmount := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
                                    NewAmount := 0;
                                    NewVATBaseAmount := 0;
                                end else begin
                                    NewAmount := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
                                    NewVATBaseAmount :=
                                      Round(
                                        NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                                        Currency."Amount Rounding Precision");
                                    if VATAmountLine."VAT Base" = 0 then
                                        VATAmount := 0
                                    else
                                        VATAmount :=
                                          TempVATAmountLineRemainder."VAT Amount" +
                                          VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                                end;
                                NewAmountIncludingVAT := NewAmount + Round(VATAmount, Currency."Amount Rounding Precision");
                            end
                        else begin
                            if (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 then
                                VATDifference := 0
                            else
                                VATDifference :=
                                  TempVATAmountLineRemainder."VAT Difference" +
                                  VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) /
                                  (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                            if LineAmountToInvoice = 0 then
                                SalesLine."VAT Difference" := 0
                            else
                                SalesLine."VAT Difference" := Round(VATDifference, Currency."Amount Rounding Precision");
                        end;
                        if QtyType = QtyType::General then begin
                            SalesLine.Amount := NewAmount;
                            SalesLine."Amount Including VAT" := Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                            SalesLine."VAT Base Amount" := NewVATBaseAmount;
                        end;
                        SalesLine.InitOutstanding;
                        if SalesLine.Type = SalesLine.Type::"Charge (Item)" then
                            SalesLine.UpdateItemChargeAssgnt;
                        SalesLine.Modify;

                        TempVATAmountLineRemainder."Amount Including VAT" :=
                          NewAmountIncludingVAT - Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                        TempVATAmountLineRemainder."VAT Difference" := VATDifference - SalesLine."VAT Difference";
                        TempVATAmountLineRemainder.Modify;
                    end;
                end;
            until Next = 0;
    end;


    procedure CalcVATAmountLines(QtyType: Option General,Invoicing,Shipping; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line")
    var
        PrevVatAmountLine: Record "VAT Amount Line";
        Currency: Record Currency;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        TotalVATAmount: Decimal;
        QtyToHandle: Decimal;
        RoundingLineInserted: Boolean;
    begin
        if SalesHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(SalesHeader."Currency Code");

        VATAmountLine.DeleteAll;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet then
            repeat
                if not ZeroAmountLine(QtyType) then begin
                    if (SalesLine.Type = SalesLine.Type::"G/L Account") and not SalesLine."Prepayment Line" then
                        RoundingLineInserted := (SalesLine."No." = GetCPGInvRoundAcc(SalesHeader)) or RoundingLineInserted;
                    if SalesLine."VAT Calculation Type" in
                       [VATAmountLine."VAT Calculation Type"::"Reverse Charge VAT", VATAmountLine."VAT Calculation Type"::"Sales Tax"]
                    then
                        SalesLine."VAT %" := 0;
                    if not VATAmountLine.Get(
                         SalesLine."VAT Identifier", SalesLine."VAT Calculation Type", SalesLine."Tax Group Code", false, SalesLine."Line Amount" >= 0)
                    then begin
                        VATAmountLine.Init;
                        VATAmountLine."VAT Identifier" := SalesLine."VAT Identifier";
                        VATAmountLine."VAT Calculation Type" := SalesLine."VAT Calculation Type";
                        VATAmountLine."Tax Group Code" := SalesLine."Tax Group Code";
                        VATAmountLine."VAT %" := SalesLine."VAT %";
                        VATAmountLine.Modified := true;
                        VATAmountLine.Positive := SalesLine."Line Amount" >= 0;
                        VATAmountLine.Insert;
                    end;
                    case QtyType of
                        QtyType::General:
                            begin
                                VATAmountLine.Quantity := VATAmountLine.Quantity + SalesLine."Quantity (Base)";
                                VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + SalesLine."Line Amount";
                                if SalesLine."Allow Invoice Disc." then
                                    VATAmountLine."Inv. Disc. Base Amount" :=
                                      VATAmountLine."Inv. Disc. Base Amount" + SalesLine."Line Amount";
                                VATAmountLine."Invoice Discount Amount" :=
                                  VATAmountLine."Invoice Discount Amount" + SalesLine."Inv. Discount Amount";
                                VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + SalesLine."VAT Difference";
                                if SalesLine."Prepayment Line" then
                                    VATAmountLine."Includes Prepayment" := true;
                                VATAmountLine.Modify;
                            end;
                        QtyType::Invoicing:
                            begin
                                case true of
                                    (SalesLine."Document Type" in ["Document Type"::Order, "Document Type"::Invoice]) and
                                    (not SalesHeader.Ship) and SalesHeader.Invoice and (not SalesLine."Prepayment Line"):
                                        begin
                                            if SalesLine."Shipment No." = '' then begin
                                                QtyToHandle := GetAbsMin(SalesLine."Qty. to Invoice", SalesLine."Qty. Shipped Not Invoiced");
                                                VATAmountLine.Quantity :=
                                                  VATAmountLine.Quantity + GetAbsMin(SalesLine."Qty. to Invoice (Base)", SalesLine."Qty. Shipped Not Invd. (Base)");
                                            end else begin
                                                QtyToHandle := SalesLine."Qty. to Invoice";
                                                VATAmountLine.Quantity := VATAmountLine.Quantity + SalesLine."Qty. to Invoice (Base)";
                                            end;
                                        end;
                                    (SalesLine."Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) and
                                    (not SalesHeader.Receive) and SalesHeader.Invoice:
                                        begin
                                            if SalesLine."Return Receipt No." = '' then begin
                                                QtyToHandle := GetAbsMin(SalesLine."Qty. to Invoice", SalesLine."Return Qty. Rcd. Not Invd.");
                                                VATAmountLine.Quantity :=
                                                  VATAmountLine.Quantity + GetAbsMin(SalesLine."Qty. to Invoice (Base)", SalesLine."Ret. Qty. Rcd. Not Invd.(Base)");
                                            end else begin
                                                QtyToHandle := SalesLine."Qty. to Invoice";
                                                VATAmountLine.Quantity := VATAmountLine.Quantity + SalesLine."Qty. to Invoice (Base)";
                                            end;
                                        end;
                                    else begin
                                        QtyToHandle := SalesLine."Qty. to Invoice";
                                        VATAmountLine.Quantity := VATAmountLine.Quantity + SalesLine."Qty. to Invoice (Base)";
                                    end;
                                end;
                                VATAmountLine."Line Amount" :=
                                  VATAmountLine."Line Amount" + GetLineAmountToHandle(QtyToHandle);
                                if SalesLine."Allow Invoice Disc." then
                                    VATAmountLine."Inv. Disc. Base Amount" :=
                                      VATAmountLine."Inv. Disc. Base Amount" + GetLineAmountToHandle(QtyToHandle);
                                if SalesHeader."Invoice Discount Calculation" <> SalesHeader."Invoice Discount Calculation"::Amount then
                                    VATAmountLine."Invoice Discount Amount" :=
                                      VATAmountLine."Invoice Discount Amount" +
                                      Round(SalesLine."Inv. Discount Amount" * QtyToHandle / SalesLine.Quantity, Currency."Amount Rounding Precision")
                                else
                                    VATAmountLine."Invoice Discount Amount" :=
                                      VATAmountLine."Invoice Discount Amount" + SalesLine."Inv. Disc. Amount to Invoice";
                                VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + SalesLine."VAT Difference";
                                if SalesLine."Prepayment Line" then
                                    VATAmountLine."Includes Prepayment" := true;
                                VATAmountLine.Modify;
                            end;
                        QtyType::Shipping:
                            begin
                                if SalesLine."Document Type" in
                                   ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]
                                then begin
                                    QtyToHandle := SalesLine."Return Qty. to Receive";
                                    VATAmountLine.Quantity := VATAmountLine.Quantity + SalesLine."Return Qty. to Receive (Base)";
                                end else begin
                                    QtyToHandle := SalesLine."Qty. to Ship";
                                    VATAmountLine.Quantity := VATAmountLine.Quantity + SalesLine."Qty. to Ship (Base)";
                                end;
                                VATAmountLine."Line Amount" :=
                                  VATAmountLine."Line Amount" + GetLineAmountToHandle(QtyToHandle);
                                if SalesLine."Allow Invoice Disc." then
                                    VATAmountLine."Inv. Disc. Base Amount" :=
                                      VATAmountLine."Inv. Disc. Base Amount" + GetLineAmountToHandle(QtyToHandle);
                                VATAmountLine."Invoice Discount Amount" :=
                                  VATAmountLine."Invoice Discount Amount" +
                                  Round(SalesLine."Inv. Discount Amount" * QtyToHandle / SalesLine.Quantity, Currency."Amount Rounding Precision");
                                VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + SalesLine."VAT Difference";
                                if SalesLine."Prepayment Line" then
                                    VATAmountLine."Includes Prepayment" := true;
                                VATAmountLine.Modify;
                            end;
                    end;
                    TotalVATAmount := TotalVATAmount + SalesLine."Amount Including VAT" - SalesLine.Amount;
                end;
            until SalesLine.Next = 0;


        if VATAmountLine.FindSet then
            repeat
                if (PrevVatAmountLine."VAT Identifier" <> "VAT Identifier") or
                   (PrevVatAmountLine."VAT Calculation Type" <> "VAT Calculation Type") or
                   (PrevVatAmountLine."Tax Group Code" <> "Tax Group Code") or
                   (PrevVatAmountLine."Use Tax" <> VATAmountLine."Use Tax")
                then
                    PrevVatAmountLine.Init;
                if SalesHeader."Prices Including VAT" then begin
                    case "VAT Calculation Type" of
                        "VAT Calculation Type"::"Normal VAT",
                        "VAT Calculation Type"::"Reverse Charge VAT":
                            begin
                                VATAmountLine."VAT Base" :=
                                  Round(
                                    ("Line Amount" - VATAmountLine."Invoice Discount Amount") / (1 + "VAT %" / 100),
                                    Currency."Amount Rounding Precision") - "VAT Difference";
                                VATAmountLine."VAT Amount" :=
                                  "VAT Difference" +
                                  Round(
                                    PrevVatAmountLine."VAT Amount" +
                                    ("Line Amount" - VATAmountLine."Invoice Discount Amount" - VATAmountLine."VAT Base" - "VAT Difference") *
                                    (1 - SalesHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                                if VATAmountLine.Positive then
                                    PrevVatAmountLine.Init
                                else begin
                                    PrevVatAmountLine := VATAmountLine;
                                    PrevVatAmountLine."VAT Amount" :=
                                      ("Line Amount" - VATAmountLine."Invoice Discount Amount" - VATAmountLine."VAT Base" - "VAT Difference") *
                                      (1 - SalesHeader."VAT Base Discount %" / 100);
                                    PrevVatAmountLine."VAT Amount" :=
                                      PrevVatAmountLine."VAT Amount" -
                                      Round(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                end;
                            end;
                        "VAT Calculation Type"::"Full VAT":
                            begin
                                VATAmountLine."VAT Base" := 0;
                                VATAmountLine."VAT Amount" := "VAT Difference" + "Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Amount";
                            end;
                        "VAT Calculation Type"::"Sales Tax":
                            begin
                                VATAmountLine."Amount Including VAT" := "Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Base" :=
                                  Round(
                                    SalesTaxCalculate.ReverseCalculateTax(
                                      SalesHeader."Tax Area Code", VATAmountLine."Tax Group Code", SalesHeader."Tax Liable",
                                      SalesHeader."Posting Date", VATAmountLine."Amount Including VAT", VATAmountLine.Quantity, SalesHeader."Currency Factor"),
                                    Currency."Amount Rounding Precision");
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Amount Including VAT" - VATAmountLine."VAT Base";
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmountLine."VAT %" := 0
                                else
                                    VATAmountLine."VAT %" := Round(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                            end;
                    end;
                end else
                    case VATAmountLine."VAT Calculation Type" of
                        VATAmountLine."VAT Calculation Type"::"Normal VAT",
                        VATAmountLine."VAT Calculation Type"::"Reverse Charge VAT":
                            begin
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  Round(
                                    PrevVatAmountLine."VAT Amount" +
                                    VATAmountLine."VAT Base" * "VAT %" / 100 * (1 - SalesHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" + VATAmountLine."VAT Amount";
                                if VATAmountLine.Positive then
                                    PrevVatAmountLine.Init
                                else
                                    if not VATAmountLine."Includes Prepayment" then begin
                                        PrevVatAmountLine := VATAmountLine;
                                        PrevVatAmountLine."VAT Amount" :=
                                          VATAmountLine."VAT Base" * VATAmountLine."VAT %" / 100 * (1 - SalesHeader."VAT Base Discount %" / 100);
                                        PrevVatAmountLine."VAT Amount" :=
                                          PrevVatAmountLine."VAT Amount" -
                                          Round(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    end;
                            end;
                        VATAmountLine."VAT Calculation Type"::"Full VAT":
                            begin
                                VATAmountLine."VAT Base" := 0;
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Amount";
                            end;
                        VATAmountLine."VAT Calculation Type"::"Sales Tax":
                            begin
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  SalesTaxCalculate.CalculateTax(
                                    SalesHeader."Tax Area Code", VATAmountLine."Tax Group Code", SalesHeader."Tax Liable",
                                    SalesHeader."Posting Date", VATAmountLine."VAT Base", VATAmountLine.Quantity, SalesHeader."Currency Factor");
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmountLine."VAT %" := 0
                                else
                                    "VAT %" := Round(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  Round(VATAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                            end;
                    end;

                if RoundingLineInserted then
                    TotalVATAmount := TotalVATAmount - VATAmountLine."VAT Amount";
                VATAmountLine."Calculated VAT Amount" := VATAmountLine."VAT Amount" - "VAT Difference";
                VATAmountLine.Modify;
            until Next = 0;

        if RoundingLineInserted and (TotalVATAmount <> 0) then
            if VATAmountLine.Get(SalesLine."VAT Identifier", SalesLine."VAT Calculation Type",
                 SalesLine."Tax Group Code", false, SalesLine."Line Amount" >= 0)
            then begin
                VATAmountLine."VAT Amount" := VATAmountLine."VAT Amount" + TotalVATAmount;
                VATAmountLine."Amount Including VAT" := VATAmountLine."Amount Including VAT" + TotalVATAmount;
                VATAmountLine."Calculated VAT Amount" := VATAmountLine."Calculated VAT Amount" + TotalVATAmount;
                VATAmountLine.Modify;
            end;
    end;


    procedure GetCPGInvRoundAcc(var SalesHeader: Record "Sales Header"): Code[20]
    var
        Cust: Record Customer;
        /*    CustTemplate: Record "Customer Template"; */
        CustPostingGroup: Record "Customer Posting Group";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        if SalesSetup."Invoice Rounding" then
            if Cust.Get(SalesHeader."Bill-to Customer No.") then
                CustPostingGroup.Get(Cust."Customer Posting Group")
            else
                /*    if CustTemplate.Get(SalesHeader."Sell-to Customer Templ. Code") then
                       CustPostingGroup.Get(CustTemplate."Customer Posting Group"); */

        exit(CustPostingGroup."Invoice Rounding Account");
    end;

    local procedure CalcInvDiscToInvoice()
    var
        OldInvDiscAmtToInv: Decimal;
    begin
        GetSalesHeader;
        OldInvDiscAmtToInv := "Inv. Disc. Amount to Invoice";
        if Quantity = 0 then
            Validate("Inv. Disc. Amount to Invoice", 0)
        else
            Validate(
              "Inv. Disc. Amount to Invoice",
              Round(
                "Inv. Discount Amount" * "Qty. to Invoice" / Quantity,
                Currency."Amount Rounding Precision"));

        if OldInvDiscAmtToInv <> "Inv. Disc. Amount to Invoice" then begin
            "Amount Including VAT" := "Amount Including VAT" - "VAT Difference";
            "VAT Difference" := 0;
        end;
    end;


    procedure UpdateWithWarehouseShip()
    begin
        if Type = Type::Item then
            case true of
                ("Document Type" in ["Document Type"::Quote, "Document Type"::Order]) and (Quantity >= 0):
                    if Location.RequireShipment("Location Code") then
                        Validate("Qty. to Ship", 0)
                    else
                        Validate("Qty. to Ship", "Outstanding Quantity");
                ("Document Type" in ["Document Type"::Quote, "Document Type"::Order]) and (Quantity < 0):
                    if Location.RequireReceive("Location Code") then
                        Validate("Qty. to Ship", 0)
                    else
                        Validate("Qty. to Ship", "Outstanding Quantity");
                ("Document Type" = "Document Type"::"Return Order") and (Quantity >= 0):
                    if Location.RequireReceive("Location Code") then
                        Validate("Return Qty. to Receive", 0)
                    else
                        Validate("Return Qty. to Receive", "Outstanding Quantity");
                ("Document Type" = "Document Type"::"Return Order") and (Quantity < 0):
                    if Location.RequireShipment("Location Code") then
                        Validate("Return Qty. to Receive", 0)
                    else
                        Validate("Return Qty. to Receive", "Outstanding Quantity");
            end;
        SetDefaultQuantity;
    end;

    local procedure CheckWarehouse()
    var
        Location2: Record Location;
        WhseSetup: Record "Warehouse Setup";
        ShowDialog: Option " ",Message,Error;
        DialogText: Text[50];
    begin
        GetLocation("Location Code");
        if "Location Code" = '' then begin
            WhseSetup.Get;
            Location2."Require Shipment" := WhseSetup."Require Shipment";
            Location2."Require Pick" := WhseSetup."Require Pick";
            Location2."Require Receive" := WhseSetup."Require Receive";
            Location2."Require Put-away" := WhseSetup."Require Put-away";
        end else
            Location2 := Location;

        DialogText := Text035;
        if ("Document Type" in ["Document Type"::Order, "Document Type"::"Return Order"]) and
           Location2."Directed Put-away and Pick"
        then begin
            ShowDialog := ShowDialog::Error;
            if (("Document Type" = "Document Type"::Order) and (Quantity >= 0)) or
               (("Document Type" = "Document Type"::"Return Order") and (Quantity < 0))
            then
                DialogText :=
                  DialogText + Location2.GetRequirementText(Location2.FieldNo("Require Shipment"))
            else
                DialogText :=
                  DialogText + Location2.GetRequirementText(Location2.FieldNo("Require Receive"));
        end else begin
            if (("Document Type" = "Document Type"::Order) and (Quantity >= 0) and
                (Location2."Require Shipment" or Location2."Require Pick")) or
               (("Document Type" = "Document Type"::"Return Order") and (Quantity < 0) and
                (Location2."Require Shipment" or Location2."Require Pick"))
            then begin
                if WhseValidateSourceLine.WhseLinesExist(
                     DATABASE::"Sales Line",
                     "Document Type".AsInteger(),
                     "Document No.",
                     "Line No.",
                     0,
                     Quantity)
                then
                    ShowDialog := ShowDialog::Error
                else
                    if Location2."Require Shipment" then
                        ShowDialog := ShowDialog::Message;
                if Location2."Require Shipment" then
                    DialogText :=
                      DialogText + Location2.GetRequirementText(Location2.FieldNo("Require Shipment"))
                else begin
                    DialogText := Text036;
                    DialogText :=
                      DialogText + Location2.GetRequirementText(Location2.FieldNo("Require Pick"));
                end;
            end;

            if (("Document Type" = "Document Type"::Order) and (Quantity < 0) and
                (Location2."Require Receive" or Location2."Require Put-away")) or
               (("Document Type" = "Document Type"::"Return Order") and (Quantity >= 0) and
                (Location2."Require Receive" or Location2."Require Put-away"))
            then begin
                if WhseValidateSourceLine.WhseLinesExist(
                     DATABASE::"Sales Line",
                     "Document Type".AsInteger(),
                     "Document No.",
                     "Line No.",
                     0,
                     Quantity)
                then
                    ShowDialog := ShowDialog::Error
                else
                    if Location2."Require Receive" then
                        ShowDialog := ShowDialog::Message;
                if Location2."Require Receive" then
                    DialogText :=
                      DialogText + Location2.GetRequirementText(Location2.FieldNo("Require Receive"))
                else begin
                    DialogText := Text036;
                    DialogText :=
                      DialogText + Location2.GetRequirementText(Location2.FieldNo("Require Put-away"));
                end;
            end;
        end;

        case ShowDialog of
            ShowDialog::Message:
                Message(Text016 + Text017, DialogText, FieldCaption("Line No."), "Line No.");
            ShowDialog::Error:
                Error(Text016, DialogText, FieldCaption("Line No."), "Line No.");
        end;

        HandleDedicatedBin(true);
    end;


    procedure UpdateDates()
    begin
        if CurrFieldNo = 0 then begin
            PlannedShipmentDateCalculated := false;
            PlannedDeliveryDateCalculated := false;
        end;
        if "Promised Delivery Date" <> 0D then
            Validate("Promised Delivery Date")
        else
            if "Requested Delivery Date" <> 0D then
                Validate("Requested Delivery Date")
            else
                Validate("Shipment Date");
    end;


    procedure GetItemTranslation()
    begin
        GetSalesHeader;
        if ItemTranslation.Get("No.", "Variant Code", SalesHeader."Language Code") then begin
            Description := ItemTranslation.Description;
            "Description 2" := ItemTranslation."Description 2";
        end;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;


    procedure PriceExists(): Boolean
    begin
        if "Document No." <> '' then begin
            GetSalesHeader;
            //fes mig EXIT(PriceCalcMgt.SalesLinePriceExists(SalesHeader,Rec,TRUE));
        end;
        exit(false);
    end;


    procedure LineDiscExists(): Boolean
    begin
        if "Document No." <> '' then begin
            GetSalesHeader;
            //fes mig   EXIT(PriceCalcMgt.SalesLineLineDiscExists(SalesHeader,Rec,TRUE));
        end;
        exit(false);
    end;


    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        exit(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Line", "Document Type".AsInteger(),
            "Document No.", '', 0, "Line No."));
    end;

    procedure GetItemCrossRef(CalledByFieldNo: Integer)
    begin
        if CalledByFieldNo <> 0 then begin
            // fes mig: DistIntegration.EnterSalesItemCrossRef(Rec);
            exit;
        end;
    end;

    procedure GetDefaultBin()
    var
        WMSManagement: Codeunit "WMS Management";
    begin
        if Type <> Type::Item then
            exit;

        "Bin Code" := '';
        if "Drop Shipment" then
            exit;

        if ("Location Code" <> '') and ("No." <> '') then begin
            GetLocation("Location Code");
            if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then begin
                if ("Qty. to Assemble to Order" > 0) or IsAsmToOrderRequired then
                    if GetATOBin(Location, "Bin Code") then
                        exit;

                WMSManagement.GetDefaultBin("No.", "Variant Code", "Location Code", "Bin Code");
                HandleDedicatedBin(false);
            end;
        end;
    end;


    procedure GetATOBin(Location: Record Location; var BinCode: Code[20]): Boolean
    var
        AsmHeader: Record "Assembly Header";
    begin
        if not Location."Require Shipment" then
            BinCode := Location."Asm.-to-Order Shpt. Bin Code";
        if BinCode <> '' then
            exit(true);

        if AsmHeader.GetFromAssemblyBin(Location, BinCode) then
            exit(true);

        exit(false);
    end;


    procedure IsInbound(): Boolean
    begin
        case "Document Type" of
            "Document Type"::Order, "Document Type"::Invoice, "Document Type"::Quote, "Document Type"::"Blanket Order":
                exit("Quantity (Base)" < 0);
            "Document Type"::"Return Order", "Document Type"::"Credit Memo":
                exit("Quantity (Base)" > 0);
        end;

        exit(false);
    end;

    local procedure HandleDedicatedBin(IssueWarning: Boolean)
    var
        WhseIntegrationMgt: Codeunit "Whse. Integration Management";
    begin
        if not IsInbound and ("Quantity (Base)" <> 0) then
            WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Location Code", "Bin Code", IssueWarning);
    end;


    procedure CheckAssocPurchOrder(TheFieldCaption: Text[250])
    begin
        if TheFieldCaption = '' then begin // If sales line is being deleted
            if "Purch. Order Line No." <> 0 then
                Error(
                  Text000,
                  "Purchase Order No.",
                  "Purch. Order Line No.");
            if "Special Order Purch. Line No." <> 0 then
                Error(
                  Text000,
                  "Special Order Purchase No.",
                  "Special Order Purch. Line No.");
        end;
        if "Purch. Order Line No." <> 0 then
            Error(
              Text002,
              TheFieldCaption,
              "Purchase Order No.",
              "Purch. Order Line No.");
        if "Special Order Purch. Line No." <> 0 then
            Error(
              Text002,
              TheFieldCaption,
              "Special Order Purchase No.",
              "Special Order Purch. Line No.");
    end;


    procedure CrossReferenceNoLookUp()
    var
        ItemCrossReference: Record "Item Reference";
        ICGLAcc: Record "IC G/L Account";
    begin
        case Type of
            Type::Item:
                begin
                    GetSalesHeader;
                    ItemCrossReference.Reset;
                    ItemCrossReference.SetCurrentKey("Reference Type", "Reference Type No.");
                    ItemCrossReference.SetFilter(
                      "Reference Type", '%1|%2',
                      ItemCrossReference."Reference Type"::Customer,
                      ItemCrossReference."Reference Type"::" ");
                    ItemCrossReference.SetFilter("Reference Type No.", '%1|%2', SalesHeader."Sell-to Customer No.", '');
                    if PAGE.RunModal(PAGE::"Item Reference List", ItemCrossReference) = ACTION::LookupOK then begin
                        Validate("Cross-Reference No.", ItemCrossReference."Reference No.");
                        //fes mig PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
                        //fes mig PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,FIELDNO("Cross-Reference No."));
                        Validate("Unit Price");
                    end;
                end;
            Type::"G/L Account", Type::Resource:
                begin
                    GetSalesHeader;
                    SalesHeader.TestField("Sell-to IC Partner Code");
                    if PAGE.RunModal(PAGE::"IC G/L Account List") = ACTION::LookupOK then
                        "Cross-Reference No." := ICGLAcc."No.";
                end;
        end;
    end;


    procedure CheckServItemCreation()
    var
        ServItemGroup: Record "Service Item Group";
    begin
        if CurrFieldNo = 0 then
            exit;
        if Type <> Type::Item then
            exit;
        Item.Get("No.");
        if Item."Service Item Group" = '' then
            exit;
        if ServItemGroup.Get(Item."Service Item Group") then
            if ServItemGroup."Create Service Item" then
                if "Qty. to Ship (Base)" <> Round("Qty. to Ship (Base)", 1) then
                    Error(
                      Text034,
                      FieldCaption("Qty. to Ship (Base)"),
                      ServItemGroup.FieldCaption("Create Service Item"));
    end;


    procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record Item;
    begin
        if Type = Type::Item then
            if not Item2.Get(ItemNo) then
                exit(false);
        exit(true);
    end;


    procedure IsShipment(): Boolean
    begin
        exit(SignedXX("Quantity (Base)") < 0);
    end;

    local procedure GetAbsMin(QtyToHandle: Decimal; QtyHandled: Decimal): Decimal
    begin
        if Abs(QtyHandled) < Abs(QtyToHandle) then
            exit(QtyHandled);

        exit(QtyToHandle);
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure CheckApplFromItemLedgEntry(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemTrackingLines: Page "Item Tracking Lines";
        QtyNotReturned: Decimal;
        QtyReturned: Decimal;
    begin
        if "Appl.-from Item Entry" = 0 then
            exit;

        if "Shipment No." <> '' then
            exit;

        TestField(Type, Type::Item);
        TestField(Quantity);
        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then begin
            if Quantity < 0 then
                FieldError(Quantity, Text029);
        end else begin
            if Quantity > 0 then
                FieldError(Quantity, Text030);
        end;

        ItemLedgEntry.Get("Appl.-from Item Entry");
        ItemLedgEntry.TestField(Positive, false);
        ItemLedgEntry.TestField("Item No.", "No.");
        ItemLedgEntry.TestField("Variant Code", "Variant Code");
        if (ItemLedgEntry."Lot No." <> '') or (ItemLedgEntry."Serial No." <> '') then
            Error(Text040, ItemTrackingLines.Caption, FieldCaption("Appl.-from Item Entry"));

        if Abs("Quantity (Base)") > -ItemLedgEntry.Quantity then
            Error(
              Text046,
              -ItemLedgEntry.Quantity, ItemLedgEntry.FieldCaption("Document No."),
              ItemLedgEntry."Document No.");

        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
            if Abs("Outstanding Qty. (Base)") > -ItemLedgEntry."Shipped Qty. Not Returned" then begin
                QtyNotReturned := ItemLedgEntry."Shipped Qty. Not Returned";
                QtyReturned := ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned";
                if "Qty. per Unit of Measure" <> 0 then begin
                    QtyNotReturned :=
                      Round(ItemLedgEntry."Shipped Qty. Not Returned" / "Qty. per Unit of Measure", 0.00001);
                    QtyReturned :=
                      Round(
                        (ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned") /
                        "Qty. per Unit of Measure", 0.00001);
                end;
                Error(
                  Text039,
                  -QtyReturned, ItemLedgEntry.FieldCaption("Document No."),
                  ItemLedgEntry."Document No.", -QtyNotReturned);
            end;
    end;


    procedure CalcPrepaymentToDeduct()
    begin
        if ("Qty. to Invoice" <> 0) and ("Prepmt. Amt. Inv." <> 0) then begin
            GetSalesHeader;
            if ("Prepayment %" = 100) and not IsFinalInvoice then
                "Prepmt Amt to Deduct" := GetLineAmountToHandle("Qty. to Invoice")
            else
                "Prepmt Amt to Deduct" :=
                  Round(
                    ("Prepmt. Amt. Inv." - "Prepmt Amt Deducted") *
                    "Qty. to Invoice" / (Quantity - "Quantity Invoiced"), Currency."Amount Rounding Precision")
        end else
            "Prepmt Amt to Deduct" := 0
    end;


    procedure IsFinalInvoice(): Boolean
    begin
        exit("Qty. to Invoice" = Quantity - "Quantity Invoiced");
    end;


    procedure GetLineAmountToHandle(QtyToHandle: Decimal): Decimal
    var
        LineAmount: Decimal;
        LineDiscAmount: Decimal;
    begin
        GetSalesHeader;
        LineAmount := Round(QtyToHandle * "Unit Price", Currency."Amount Rounding Precision");
        LineDiscAmount := Round("Line Discount Amount" * QtyToHandle / Quantity, Currency."Amount Rounding Precision");
        exit(LineAmount - LineDiscAmount);
    end;


    procedure SetHasBeenShown()
    begin
        HasBeenShown := true;
    end;


    procedure TestJobPlanningLine()
    begin
        if "Job Contract Entry No." = 0 then
            exit;
        //fes mig JobPostLine.TestSalesLine(Rec);
    end;


    procedure BlockDynamicTracking(SetBlock: Boolean)
    begin
        TrackingBlocked := SetBlock;
        ReserveSalesLine.Block(SetBlock);
    end;


    procedure InitQtyToShip2()
    begin
        "Qty. to Ship" := "Outstanding Quantity";
        "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";

        //fes mig ATOLink.UpdateQtyToAsmFromSalesLine(Rec);

        CheckServItemCreation;

        "Qty. to Invoice" := MaxQtyToInvoice;
        "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
        "VAT Difference" := 0;

        CalcInvDiscToInvoice;

        CalcPrepaymentToDeduct;
    end;


    procedure ShowLineComments()
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentSheet: Page "Sales Comment Sheet";
    begin
        TestField("Document No.");
        TestField("Line No.");
        SalesCommentLine.SetRange("Document Type", "Document Type");
        SalesCommentLine.SetRange("No.", "Document No.");
        SalesCommentLine.SetRange("Document Line No.", "Line No.");
        SalesCommentSheet.SetTableView(SalesCommentLine);
        SalesCommentSheet.RunModal;
    end;


    procedure SetDefaultQuantity()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        if SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank then begin
            if ("Document Type" = "Document Type"::Order) or ("Document Type" = "Document Type"::Quote) then begin
                "Qty. to Ship" := 0;
                "Qty. to Ship (Base)" := 0;
                "Qty. to Invoice" := 0;
                "Qty. to Invoice (Base)" := 0;
            end;
            if "Document Type" = "Document Type"::"Return Order" then begin
                "Return Qty. to Receive" := 0;
                "Return Qty. to Receive (Base)" := 0;
                "Qty. to Invoice" := 0;
                "Qty. to Invoice (Base)" := 0;
            end;
        end;
    end;


    procedure UpdatePrePaymentAmounts()
    var
        ShipmentLine: Record "Sales Shipment Line";
        SalesOrderLine: Record "Sales Line";
        SalesOrderHeader: Record "Sales Header";
    begin
        if ("Document Type" <> "Document Type"::Invoice) or ("Prepayment %" = 0) then
            exit;

        if not ShipmentLine.Get("Shipment No.", "Shipment Line No.") then begin
            "Prepmt Amt to Deduct" := 0;
            "Prepmt VAT Diff. to Deduct" := 0;
        end else begin
            if SalesOrderLine.Get(SalesOrderLine."Document Type"::Order, ShipmentLine."Order No.", ShipmentLine."Order Line No.") then begin
                if ("Prepayment %" = 100) and (Quantity <> SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced") then
                    "Prepmt Amt to Deduct" := "Line Amount"
                else
                    "Prepmt Amt to Deduct" :=
                      Round((SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted") *
                        Quantity / (SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced"), Currency."Amount Rounding Precision");
                "Prepmt VAT Diff. to Deduct" := "Prepayment VAT Difference" - "Prepmt VAT Diff. Deducted";
                SalesOrderHeader.Get(SalesOrderHeader."Document Type"::Order, SalesOrderLine."Document No.");
            end else begin
                "Prepmt Amt to Deduct" := 0;
                "Prepmt VAT Diff. to Deduct" := 0;
            end;
        end;

        GetSalesHeader;
        SalesHeader.TestField("Prices Including VAT", SalesOrderHeader."Prices Including VAT");
        if SalesHeader."Prices Including VAT" then begin
            "Prepmt. Amt. Incl. VAT" := "Prepmt Amt to Deduct";
            "Prepayment Amount" :=
              Round(
                "Prepmt Amt to Deduct" / (1 + ("Prepayment VAT %" / 100)),
                Currency."Amount Rounding Precision");
        end else begin
            "Prepmt. Amt. Incl. VAT" :=
              Round(
                "Prepmt Amt to Deduct" * (1 + ("Prepayment VAT %" / 100)),
                Currency."Amount Rounding Precision");
            "Prepayment Amount" := "Prepmt Amt to Deduct";
        end;
        "Prepmt. Line Amount" := "Prepmt Amt to Deduct";
        "Prepmt. Amt. Inv." := "Prepmt. Line Amount";
        "Prepmt. VAT Base Amt." := "Prepayment Amount";
        "Prepmt. Amount Inv. Incl. VAT" := "Prepmt. Amt. Incl. VAT";
        "Prepmt Amt Deducted" := 0;
    end;


    procedure ZeroAmountLine(QtyType: Option General,Invoicing,Shipping): Boolean
    begin
        if Type = Type::" " then
            exit(true);
        if Quantity = 0 then
            exit(true);
        if "Unit Price" = 0 then
            exit(true);
        if QtyType = QtyType::Invoicing then
            if "Qty. to Invoice" = 0 then
                exit(true);
        exit(false);
    end;


    procedure FilterLinesWithItemToPlan(var Item: Record Item; DocumentType: Option)
    begin
        Reset;
        SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        SetRange("Document Type", DocumentType);
        SetRange(Type, Type::Item);
        SetRange("No.", Item."No.");
        SetFilter("Variant Code", Item.GetFilter("Variant Filter"));
        SetFilter("Location Code", Item.GetFilter("Location Filter"));
        SetFilter("Drop Shipment", Item.GetFilter("Drop Shipment Filter"));
        SetFilter("Shortcut Dimension 1 Code", Item.GetFilter("Global Dimension 1 Filter"));
        SetFilter("Shortcut Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
        SetFilter("Shipment Date", Item.GetFilter("Date Filter"));
        SetFilter("Outstanding Qty. (Base)", '<>0');
    end;


    procedure FindLinesWithItemToPlan(var Item: Record Item; DocumentType: Option): Boolean
    begin
        FilterLinesWithItemToPlan(Item, DocumentType);
        exit(Find('-'));
    end;


    procedure LinesWithItemToPlanExist(var Item: Record Item; DocumentType: Option): Boolean
    begin
        FilterLinesWithItemToPlan(Item, DocumentType);
        exit(not IsEmpty);
    end;

    local procedure DateFormularZero(var DateFormularValue: DateFormula; CalledByFieldNo: Integer; CalledByFieldCaption: Text[250])
    var
        DateFormularZero: DateFormula;
    begin
        Evaluate(DateFormularZero, '<0D>');
        if (DateFormularValue <> DateFormularZero) and (CalledByFieldNo = CurrFieldNo) then
            Error(Text051, CalledByFieldCaption, FieldCaption("Drop Shipment"));
        Evaluate(DateFormularValue, '<0D>');
    end;

    local procedure InitQtyToAsm()
    begin
        if not IsAsmToOrderAllowed then begin
            "Qty. to Assemble to Order" := 0;
            "Qty. to Asm. to Order (Base)" := 0;
            exit;
        end;

        if ((xRec."Qty. to Asm. to Order (Base)" = 0) and IsAsmToOrderRequired and ("Qty. Shipped (Base)" = 0)) or
           ((xRec."Qty. to Asm. to Order (Base)" <> 0) and
            (xRec."Qty. to Asm. to Order (Base)" = xRec."Quantity (Base)")) or
           ("Qty. to Asm. to Order (Base)" > "Quantity (Base)")
        then begin
            "Qty. to Assemble to Order" := Quantity;
            "Qty. to Asm. to Order (Base)" := "Quantity (Base)";
        end;
    end;


    procedure AsmToOrderExists(var AsmHeader: Record "Assembly Header"): Boolean
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin
        //fes mig IF NOT ATOLink.AsmExistsForSalesLine(Rec) THEN
        exit(false);
        exit(AsmHeader.Get(ATOLink."Assembly Document Type", ATOLink."Assembly Document No."));
    end;


    procedure FullQtyIsForAsmToOrder(): Boolean
    begin
        if "Qty. to Asm. to Order (Base)" = 0 then
            exit(false);
        exit("Quantity (Base)" = "Qty. to Asm. to Order (Base)");
    end;

    local procedure FullReservedQtyIsForAsmToOrder(): Boolean
    begin
        if "Qty. to Asm. to Order (Base)" = 0 then
            exit(false);
        CalcFields("Reserved Qty. (Base)");
        exit("Reserved Qty. (Base)" = "Qty. to Asm. to Order (Base)");
    end;


    procedure QtyBaseOnATO(): Decimal
    var
        AsmHeader: Record "Assembly Header";
    begin
        if AsmToOrderExists(AsmHeader) then
            exit(AsmHeader."Quantity (Base)");
        exit(0);
    end;


    procedure QtyAsmRemainingBaseOnATO(): Decimal
    var
        AsmHeader: Record "Assembly Header";
    begin
        if AsmToOrderExists(AsmHeader) then
            exit(AsmHeader."Remaining Quantity (Base)");
        exit(0);
    end;


    procedure QtyToAsmBaseOnATO(): Decimal
    var
        AsmHeader: Record "Assembly Header";
    begin
        if AsmToOrderExists(AsmHeader) then
            exit(AsmHeader."Quantity to Assemble (Base)");
        exit(0);
    end;


    procedure IsAsmToOrderAllowed(): Boolean
    begin
        if not ("Document Type" in ["Document Type"::Quote, "Document Type"::"Blanket Order", "Document Type"::Order]) then
            exit(false);
        if Quantity < 0 then
            exit(false);
        if Type <> Type::Item then
            exit(false);
        if "No." = '' then
            exit(false);
        if "Drop Shipment" or "Special Order" then
            exit(false);
        exit(true)
    end;


    procedure IsAsmToOrderRequired(): Boolean
    begin
        if (Type <> Type::Item) or ("No." = '') then
            exit(false);
        GetItem;
        if GetSKU then
            exit(SKU."Assembly Policy" = SKU."Assembly Policy"::"Assemble-to-Order");
        exit(Item."Assembly Policy" = Item."Assembly Policy"::"Assemble-to-Order");
    end;


    procedure CheckAsmToOrder(AsmHeader: Record "Assembly Header")
    begin
        TestField("Qty. to Assemble to Order", AsmHeader.Quantity);
        TestField("Document Type", AsmHeader."Document Type");
        TestField(Type, Type::Item);
        TestField("No.", AsmHeader."Item No.");
        TestField("Location Code", AsmHeader."Location Code");
        TestField("Unit of Measure Code", AsmHeader."Unit of Measure Code");
        TestField("Variant Code", AsmHeader."Variant Code");
        TestField("Shipment Date", AsmHeader."Due Date");
        if "Document Type" = "Document Type"::Order then begin
            AsmHeader.CalcFields("Reserved Qty. (Base)");
            AsmHeader.TestField("Reserved Qty. (Base)", AsmHeader."Remaining Quantity (Base)");
        end;
        TestField("Qty. to Asm. to Order (Base)", AsmHeader."Quantity (Base)");
        if "Outstanding Qty. (Base)" < AsmHeader."Remaining Quantity (Base)" then
            AsmHeader.FieldError("Remaining Quantity (Base)", StrSubstNo(Text045, AsmHeader."Remaining Quantity (Base)"));
    end;


    procedure ShowAsmToOrder()
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin
        //fes mig ATOLink.ShowAsm(Rec);
    end;


    procedure ShowAsmToOrderLines()
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin
        //fes mig ATOLink.ShowAsmToOrderLines(Rec);
    end;


    procedure FindOpenATOEntry(LotNo: Code[20]; SerialNo: Code[20]): Integer
    var
        PostedATOLink: Record "Posted Assemble-to-Order Link";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        TestField("Document Type", "Document Type"::Order);
        //fes mig IF PostedATOLink.FindLinksFromSalesLine(Rec) THEN
        repeat
            ItemLedgEntry.SetRange("Document Type", ItemLedgEntry."Document Type"::"Posted Assembly");
            ItemLedgEntry.SetRange("Document No.", PostedATOLink."Assembly Document No.");
            ItemLedgEntry.SetRange("Document Line No.", 0);
            ItemLedgEntry.SetRange("Serial No.", SerialNo);
            ItemLedgEntry.SetRange("Lot No.", LotNo);
            ItemLedgEntry.SetRange(Open, true);
            if ItemLedgEntry.FindFirst then
                exit(ItemLedgEntry."Entry No.");
        until PostedATOLink.Next = 0;
    end;


    procedure RollUpAsmCost()
    begin
        //fes mig ATOLink.RollUpCost(Rec);
    end;


    procedure RollupAsmPrice()
    begin
        GetSalesHeader;
        //fes mig ATOLink.RollUpPrice(SalesHeader,Rec);
    end;

    local procedure InitICPartner()
    var
        ICPartner: Record "IC Partner";
        ItemCrossReference: Record "Item Reference";
    begin
        if SalesHeader."Bill-to IC Partner Code" <> '' then
            case Type of
                Type::" ", Type::"Charge (Item)":
                    begin
                        "IC Partner Ref. Type" := Type.AsInteger();
                        "IC Partner Reference" := "No.";
                    end;
                Type::"G/L Account":
                    begin
                        "IC Partner Ref. Type" := Type.AsInteger();
                        "IC Partner Reference" := GLAcc."Default IC Partner G/L Acc. No";
                    end;
                Type::Item:
                    begin
                        if SalesHeader."Sell-to IC Partner Code" <> '' then
                            ICPartner.Get(SalesHeader."Sell-to IC Partner Code")
                        else
                            ICPartner.Get(SalesHeader."Bill-to IC Partner Code");
                        case ICPartner."Outbound Sales Item No. Type" of
                            ICPartner."Outbound Sales Item No. Type"::"Common Item No.":
                                Validate("IC Partner Ref. Type", "IC Partner Ref. Type"::"Common Item No.");
                            ICPartner."Outbound Sales Item No. Type"::"Internal No.":
                                begin
                                    "IC Partner Ref. Type" := "IC Partner Ref. Type"::Item;
                                    "IC Partner Reference" := "No.";
                                end;
                            ICPartner."Outbound Sales Item No. Type"::"Cross Reference":
                                begin
                                    Validate("IC Partner Ref. Type", "IC Partner Ref. Type"::"Cross Reference");
                                    ItemCrossReference.SetRange("Reference Type",
                                      ItemCrossReference."Reference Type"::Customer);
                                    ItemCrossReference.SetRange("Reference Type No.",
                                      "Sell-to Customer No.");
                                    ItemCrossReference.SetRange("Item No.", "No.");
                                    if ItemCrossReference.FindFirst then
                                        "IC Partner Reference" := ItemCrossReference."Reference No.";
                                end;
                        end;
                    end;
                Type::"Fixed Asset":
                    begin
                        "IC Partner Ref. Type" := "IC Partner Ref. Type"::" ";
                        "IC Partner Reference" := '';
                    end;
                Type::Resource:
                    begin
                        Resource.Get("No.");
                        "IC Partner Ref. Type" := "IC Partner Ref. Type"::"G/L Account";
                        "IC Partner Reference" := Resource."IC Partner Purch. G/L Acc. No.";
                    end;
            end;
    end;


    procedure OutstandingInvoiceAmountFromShipment(SellToCustomerNo: Code[20]): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetCurrentKey("Document Type", "Sell-to Customer No.", "Shipment No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
        SalesLine.SetRange("Sell-to Customer No.", SellToCustomerNo);
        SalesLine.SetFilter("Shipment No.", '<>%1', '');
        SalesLine.CalcSums("Outstanding Amount (LCY)");
        exit(SalesLine."Outstanding Amount (LCY)");
    end;

    local procedure CheckShipmentRelation()
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin
        SalesShptLine.Get("Shipment No.", "Shipment Line No.");
        if (Quantity * SalesShptLine."Qty. Shipped Not Invoiced") < 0 then
            FieldError("Qty. to Invoice", Text057);
        if Abs(Quantity) > Abs(SalesShptLine."Qty. Shipped Not Invoiced") then
            Error(Text058, SalesShptLine."Document No.");
    end;

    local procedure CheckRetRcptRelation()
    var
        ReturnRcptLine: Record "Return Receipt Line";
    begin
        ReturnRcptLine.Get("Return Receipt No.", "Return Receipt Line No.");
        if (Quantity * (ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced")) < 0 then
            FieldError("Qty. to Invoice", Text059);
        if Abs(Quantity) > Abs(ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced") then
            Error(Text060, ReturnRcptLine."Document No.");
    end;

    local procedure VerifyItemLineDim()
    begin
        if ("Dimension Set ID" <> xRec."Dimension Set ID") and (Type = Type::Item) then
            if ("Qty. Shipped Not Invoiced" <> 0) or ("Return Rcd. Not Invd." <> 0) then
                if not Confirm(Text053, true, TableCaption) then
                    Error(Text054);
    end;


    procedure InitType()
    begin
        if "Document No." <> '' then begin
            SalesHeader.Get("Document Type", "Document No.");
            if (SalesHeader.Status = SalesHeader.Status::Released) and
               (xRec.Type in [xRec.Type::Item, xRec.Type::"Fixed Asset"])
            then
                Type := Type::" "
            else
                Type := xRec.Type;
        end;
    end;


    procedure CalcSalesTaxLines(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        TaxArea: Record "Tax Area";
    begin
        if SalesHeader."Tax Area Code" = '' then
            exit;
        TaxArea.Get(SalesHeader."Tax Area Code");
        // SalesTaxCalculate.StartSalesTaxCalculation; // clear temp table

        // if TaxArea."Use External Tax Engine" then
        //     SalesTaxCalculate.CallExternalTaxEngineForSales(SalesHeader, true)
        // else begin
        //     SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        //     SalesLine.SetRange("Document No.", SalesHeader."No.");
        //     if SalesLine.FindSet then
        //         repeat
        //             if SalesLine.Type <> SalesLine.Type::" " then
        //                 SalesTaxCalculate.AddSalesLine(SalesLine);
        //         until Next = 0;
        //     SalesTaxCalculate.EndSalesTaxCalculation(SalesHeader."Posting Date");
        // end;
        // SalesLine2.CopyFilters(SalesLine);
        // SalesTaxCalculate.DistTaxOverSalesLines(SalesLine);
        SalesLine.CopyFilters(SalesLine2);
    end;

    local procedure CheckWMS()
    var
        DialogText: Text;
    begin
        DialogText := Text035;
        if (CurrFieldNo <> 0) and (Type = Type::Item) then
            if "Quantity (Base)" <> 0 then
                case "Document Type" of
                    "Document Type"::Invoice:
                        if "Shipment No." = '' then
                            if Location.Get("Location Code") and Location."Directed Put-away and Pick" then begin
                                DialogText += Location.GetRequirementText(Location.FieldNo("Require Shipment"));
                                //Error(Text016, DialogText, FieldCaption("Line No."), "Line No.");
                            end;
                    "Document Type"::"Credit Memo":
                        if "Return Receipt No." = '' then
                            if Location.Get("Location Code") and Location."Directed Put-away and Pick" then begin
                                DialogText += Location.GetRequirementText(Location.FieldNo("Require Receive"));
                                // Error(Text016, DialogText, FieldCaption("Line No."), "Line No.");
                            end;
                end;
    end;


    procedure IsServiceItem(): Boolean
    begin
        if Type <> Type::Item then
            exit(false);
        if "No." = '' then
            exit(false);
        GetItem;
        exit(Item.Type = Item.Type::Service);
    end;


    procedure CalcAmountIncludingTax(BaseAmount: Decimal): Decimal
    begin
        GetSalesHeader;
        exit(Round(BaseAmount * (1 + "VAT %" / 100), Currency."Amount Rounding Precision"));
    end;

    local procedure ValidateReturnReasonCode(CallingFieldNo: Integer)
    begin
        if CallingFieldNo = 0 then
            exit;
        if "Return Reason Code" = '' then
            UpdateUnitPrice(FieldNo("Return Reason Code"));

        if ReturnReason.Get("Return Reason Code") then begin
            if (CallingFieldNo <> FieldNo("Location Code")) and (ReturnReason."Default Location Code" <> '') then
                Validate("Location Code", ReturnReason."Default Location Code");
            if ReturnReason."Inventory Value Zero" then begin
                Validate("Unit Cost (LCY)", 0);
                Validate("Unit Price", 0);
            end else
                if "Unit Price" = 0 then
                    UpdateUnitPrice(FieldNo("Return Reason Code"));
        end;
    end;


    procedure PreciosTipoVenta()
    var
        SantSetup: Record "Config. Empresa";
    begin
        //006
        SantSetup.Get;
        SalesHeader.Get("Document Type", "Document No.");

        if SalesHeader."Tipo de Venta" = SalesHeader."Tipo de Venta"::Muestras then begin
            if Item.Get("No.") then begin
                if SantSetup."Precio de Venta Muestras" = SantSetup."Precio de Venta Muestras"::Costo then
                    Validate("Unit Price", Item."Unit Cost")
                else
                    Validate("Unit Price", 0);
            end;
        end;

        if SalesHeader."Tipo de Venta" = SalesHeader."Tipo de Venta"::Donaciones then begin
            if Item.Get("No.") then begin
                if SantSetup."Precio de Venta Donaciones" = SantSetup."Precio de Venta Donaciones"::Costo then
                    Validate("Unit Price", Item."Unit Cost")
                else
                    Validate("Unit Price", 0);
            end;
        end;
    end;


    procedure ActualizaInfoAdopcion()
    var
        AdopcionesDetalle: Record "Colegio - Adopciones Detalle";
        ColNivel: Record "Colegio - Nivel";
        PromotorRuta: Record "Promotor - Rutas";
    begin
        if ("Cod. Colegio" <> '') and ("Cantidad Alumnos" <> 0) then
            exit;
        //016 Se buscan las adopciones, si existe, se llenan los datos
        if SalesHeader."Salesperson Code" = '' then
            SalesHeader."Salesperson Code" := TempSalesLine."Cod. Vendedor";
        if SalesHeader."Salesperson Code" <> '' then begin
            //Se busca la Ruta del Promotor para tener el Nivel
            PromotorRuta.Reset;
            PromotorRuta.SetRange("Cod. Promotor", SalesHeader."Salesperson Code");
            if PromotorRuta.FindFirst then begin
                //Se buscar el Nivel de ese Colegio para esa Ruta
                ColNivel.Reset;
                ColNivel.SetRange("Cod. Colegio", SalesHeader."Bill-to Contact No.");
                ColNivel.SetRange(Ruta, PromotorRuta."Cod. Ruta");
                if ColNivel.FindFirst then;

                AdopcionesDetalle.Reset;
                AdopcionesDetalle.SetCurrentKey("Cod. Colegio", "Cod. Promotor", "Cod. Producto");
                AdopcionesDetalle.SetRange("Cod. Colegio", SalesHeader."Bill-to Contact No.");
                AdopcionesDetalle.SetRange("Cod. Promotor", SalesHeader."Salesperson Code");
                AdopcionesDetalle.SetRange("Cod. Nivel", ColNivel."Cod. Nivel");
                AdopcionesDetalle.SetRange("Cod. Producto", "No.");
                if AdopcionesDetalle.FindFirst then begin
                    Adopcion := AdopcionesDetalle.Adopcion;
                    "Cod. Vendedor" := SalesHeader."Salesperson Code";
                    "Cantidad Alumnos" := AdopcionesDetalle."Cantidad Alumnos";
                    "Cod. Colegio" := AdopcionesDetalle."Cod. Colegio";
                end;
            end;
        end;
    end;


    procedure ActLinBO()
    begin
        /*
        //fes mig
        //+$017
        SalesHeader.GET("Document Type","Document No.");
        SalesHeader.TESTFIELD(Status,0);
        IF "Cantidad a Ajustar" > "Cantidad pendiente BO" THEN
          ERROR(Error002, FIELDCAPTION("Cantidad a Ajustar"));
        
        IF "Cantidad a Ajustar" > 0 THEN BEGIN //+$019
          IF SalesInfoPaneMgt.CalcAvailability_BackOrder(Rec) >= "Cantidad a Ajustar" THEN
          BEGIN
            Quantity += "Cantidad a Ajustar";
            VALIDATE(Quantity);
              //+$019
              //VALIDATE("Cantidad pendiente BO","Cantidad Aprobada" - Quantity);
              "Cantidad pendiente BO" := "Cantidad Aprobada" - Quantity - "Cantidad Anulada";
              IF "Cantidad a Anular" > "Cantidad pendiente BO" THEN
                "Cantidad a Anular" := "Cantidad pendiente BO";
              //-$019
            "Cantidad a Ajustar" := 0;
          END
        ELSE
          ERROR(Error006, FIELDCAPTION("Cantidad a Ajustar"));
        
        //+$019
        END;
        IF "Cantidad a Anular" > 0 THEN BEGIN
          IF "Cantidad a Anular" <= "Cantidad pendiente BO" THEN BEGIN
            "Cantidad pendiente BO" -= "Cantidad a Anular";
            "Cantidad Anulada" += "Cantidad a Anular";
            "Cantidad a Anular" := 0;
          END
          ELSE
            ERROR(Error006, FIELDCAPTION("Cantidad a Anular"));
        END;
        //-$019
        */
        //fes mig

    end;
}

