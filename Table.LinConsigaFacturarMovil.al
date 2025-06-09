table 56017 "Lin. Consig a Facturar Movil."
{
    Caption = 'Consignment Line to invoice';
    DrillDownPageID = "Sales Lines";
    LookupPageID = "Sales Lines";
    PasteIsValid = false;

    fields
    {
        field(2; "Cod. Cliente"; Code[20])
        {
            Caption = 'Customer Code';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                ICPartner: Record "IC Partner";
                ItemCrossReference: Record "Item Reference";
                PrepaymentMgt: Codeunit "Prepayment Mgt.";
                KitUnitPrice: Decimal;
            begin
            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(11; Description; Text[60])
        {
            Caption = 'Description';
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
            end;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(29; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(30; "Amount Including VAT"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including Tax';
            Editable = false;
        }
        field(31; "Cantidad Inv. en Consignacion"; Decimal)
        {
        }
        field(32; "Cantidad Consignacion Devuelta"; Decimal)
        {
        }
        field(33; "No. Pedido Consignacion"; Code[20])
        {
        }
        field(34; "No. Linea Pedido Consignacion"; Integer)
        {
        }
        field(35; "No. Mov. Prod. Cosg. a Liq."; Integer)
        {
        }
        field(36; "ID Usuario"; Code[50])
        {
            Caption = 'User ID';
        }
        field(37; Marcada; Boolean)
        {
            Caption = 'Marked';
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(50000; "Cantidad a Facturar"; Integer)
        {
            Caption = 'Qty. To Invoice';

            trigger OnValidate()
            begin
                if "Cantidad a Facturar" > Quantity then
                    Error(Error001);
            end;
        }
        field(50001; "Fecha Inventario"; Date)
        {
            Caption = 'Inventory Date';
        }
    }

    keys
    {
        key(Key1; "Cod. Cliente", "No.", "ID Usuario")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

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
        Text011: Label 'Automatic reservation is not possible.\Reserve items manually?';
        Text012: Label 'Change %1 from %2 to %3?';
        Text014: Label '%1 %2 is before work date %3';
        Text016: Label '%1 is required for %2 = %3.';
        Text017: Label '\The entered information will be disregarded by warehouse operations.';
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
        WorkType: Record "Work Type";
        JobLedgEntry: Record "Job Ledger Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        StdTxt: Record "Standard Text";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        ReservEntry: Record "Reservation Entry";
        ItemVariant: Record "Item Variant";
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
        //SalesTaxDifference: Record "Sales Tax Amount Difference";
        JobLedgEntries: Page "Job Ledger Entries";
        Reservation: Page Reservation;
        ItemAvailByDate: Page "Item Availability by Periods";
        ItemAvailByVar: Page "Item Availability by Variant";
        ItemAvailByLoc: Page "Item Availability by Location";
        /*  PriceCalcMgt: Codeunit "Sales Price Calc. Mgt."; */
        /*  CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit"; */
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
        Text043: Label 'cannot be %1';
        Text044: Label 'cannot be less than %1';
        Text045: Label 'cannot be more than %1';
        Text046: Label 'You cannot return more than the %1 units that you have shipped for %2 %3.';
        Text047: Label 'must be positive when %1 is not 0.';
        TrackingBlocked: Boolean;
        Text048: Label 'You cannot use item tracking on a %1 created from a %2.';
        Text049: Label 'cannot be %1.';
        Text25000: Label 'The existing components for this line will be deleted before %1 can be unchecked. Do you want to continue?';
        Text25001: Label 'Canceled.';
        ForceKitRefresh: Boolean;
        Text25002: Label 'Item tracking is defined for one or more components for this kit item.\Do you want to continue to delete the kit sales lines?';
        Text25003: Label 'The existing components for this line cannot be deleted when a related %1 exist.';
        Text1020002: Label 'Operation canceled to preserve Tax Differences.';
        Text1020001: Label 'This operation will remove the Tax Differences that were previously entered. Are you sure you want to continue?';
        Text1020000: Label 'You must reopen the document since this will affect Sales Tax.';
        Text1020003: Label 'The %1 field in the %2 used on the %3 must match the %1 field in the %2 used on the %4.';
        Text050: Label 'You''d reached the limit of sales lines allowed for a sales document.';
        Err001: Label 'This user is not allowed to modify the Sales Price in this document';
        "*** Santillana ***": Integer;
        CustPostGr: Record "Customer Posting Group";
        "*** DSPos ***": Integer;
        cManejaParametros: Codeunit "Lanzador DsPOS";
        txt001: Label 'Este código de producto ya ha sido introducido previamente';
        txt002: Label 'This product is back ordered on request %1 for this same customer';
        txt003: Label 'Product is pending to serve the order %1 for this same customer. Please confirm if you want to continue';
        rSalesHeader: Record "Sales Header";
        Error001: Label 'Qty. to Invoice cannot be grater than Qty.';


    procedure InitOutstanding()
    begin
    end;


    procedure InitOutstandingAmount()
    var
        AmountInclVAT: Decimal;
    begin
    end;


    procedure InitQtyToShip()
    begin
    end;


    procedure InitQtyToReceive()
    begin
    end;


    procedure InitQtyToInvoice()
    begin
    end;

    local procedure InitItemAppl(OnlyApplTo: Boolean)
    begin
    end;


    procedure MaxQtyToInvoice(): Decimal
    begin
    end;


    procedure MaxQtyToInvoiceBase(): Decimal
    begin
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
    end;

    local procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        SalesLine3: Record "Sales Line";
    begin
    end;


    procedure SetSalesHeader(NewSalesHeader: Record "Sales Header")
    begin
    end;

    local procedure GetSalesHeader()
    begin
    end;

    local procedure GetItem()
    begin
    end;


    procedure GetResource()
    begin
    end;

    local procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    begin
    end;

    local procedure FindResUnitCost()
    begin
    end;


    procedure UpdateAmounts()
    begin
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
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    begin
    end;


    procedure ShowReservation()
    begin
    end;


    procedure ShowReservationEntries(Modal: Boolean)
    begin
    end;


    procedure AutoReserve(ShowReservationForm: Boolean)
    begin
    end;


    procedure GetDate(): Date
    begin
    end;


    procedure SignedXX(Value: Decimal): Decimal
    begin
    end;


    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
    end;


    procedure BlanketOrderLookup()
    begin
    end;


    procedure ShowDimensions()
    begin
    end;


    procedure OpenItemTrackingLines()
    var
        Job: Record Job;
    begin
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
    end;


    procedure ShowItemSub()
    begin
    end;


    procedure ShowNonstock()
    begin
    end;

    local procedure GetFAPostingGroup()
    var
        LocalGLAcc: Record "G/L Account";
        FASetup: Record "FA Setup";
        FAPostingGr: Record "FA Posting Group";
        FADeprBook: Record "FA Depreciation Book";
    begin
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesHeader2: Record "Sales Header";
    begin
    end;

    local procedure GetSKU(): Boolean
    begin
    end;


    procedure GetUnitCost()
    begin
    end;

    local procedure CalcUnitCost(ItemLedgEntry: Record "Item Ledger Entry"): Decimal
    var
        ValueEntry: Record "Value Entry";
        UnitCost: Decimal;
    begin
    end;


    procedure ShowItemChargeAssgnt()
    var
        ItemChargeAssgnts: Page "Item Charge Assignment (Sales)";
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
    begin
    end;


    procedure UpdateItemChargeAssgnt()
    var
        ShareOfVAT: Decimal;
    begin
    end;

    local procedure DeleteItemChargeAssgnt(DocType: Option; DocNo: Code[20]; DocLineNo: Integer)
    begin
    end;

    local procedure DeleteChargeChargeAssgnt(DocType: Option; DocNo: Code[20]; DocLineNo: Integer)
    begin
    end;


    procedure CheckItemChargeAssgnt()
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
    begin
    end;

    local procedure TestStatusOpen()
    begin
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
    end;

    //Se comentó el parametro y la variable de la función para quitar el warning ya que no se ocupa este metodo
    procedure UpdateVATOnLines(QtyType: Option General,Invoicing,Shipping; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line") //; var VATAmountLine: Record "VAT Amount Line")
    var
        //TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        RecRef: RecordRef;
        xRecRef: RecordRef;
        ChangeLogMgt: Codeunit "Change Log Management";
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        InvDiscAmount: Decimal;
        LineAmountToInvoice: Decimal;
    begin
    end;


    //Se comentó el parametro y la variable de la función para quitar el warning ya que no se ocupa este metodo
    procedure CalcVATAmountLines(QtyType: Option General,Invoicing,Shipping; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")//; var VATAmountLine: Record "VAT Amount Line")
    var
        //PrevVatAmountLine: Record "VAT Amount Line";
        Currency: Record Currency;
        Cust: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        QtyToHandle: Decimal;
        SalesSetup: Record "Sales & Receivables Setup";
        RoundingLineInserted: Boolean;
        TotalVATAmount: Decimal;
    begin
    end;

    local procedure CalcInvDiscToInvoice()
    var
        OldInvDiscAmtToInv: Decimal;
    begin
    end;


    procedure UpdateWithWarehouseShip()
    begin
    end;

    local procedure CheckWarehouse()
    var
        Location2: Record Location;
        WhseSetup: Record "Warehouse Setup";
        ShowDialog: Option " ",Message,Error;
        DialogText: Text[50];
    begin
    end;


    procedure UpdateDates()
    begin
    end;


    procedure GetItemTranslation()
    begin
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
    end;


    procedure PriceExists(): Boolean
    begin
    end;


    procedure LineDiscExists(): Boolean
    begin
    end;


    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
    end;


    procedure GetItemCrossRef(CalledByFieldNo: Integer)
    begin
    end;

    local procedure GetDefaultBin()
    var
        WMSManagement: Codeunit "WMS Management";
    begin
    end;


    procedure CheckAssocPurchOrder(TheFieldCaption: Text[250])
    begin
    end;


    procedure CrossReferenceNoLookUp()
    var
        ItemCrossReference: Record "Item Reference";
        ICGLAcc: Record "IC G/L Account";
    begin
    end;


    procedure CheckServItemCreation()
    var
        ServItemGroup: Record "Service Item Group";
    begin
    end;


    procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record Item;
    begin
    end;


    procedure IsShipment(): Boolean
    begin
    end;

    local procedure GetAbsMin(QtyToHandle: Decimal; QtyHandled: Decimal): Decimal
    begin
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
    end;

    local procedure CheckApplFromItemLedgEntry(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemTrackingLines: Page "Item Tracking Lines";
        QtyBase: Decimal;
        QtyNotReturned: Decimal;
        QtyReturned: Decimal;
    begin
    end;


    procedure CalcPrepaymentToDeduct()
    begin
    end;


    procedure SetHasBeenShown()
    begin
    end;


    procedure TestJobPlanningLine()
    begin
    end;


    procedure BlockDynamicTracking(SetBlock: Boolean)
    begin
    end;


    procedure InitQtyToShip2()
    begin
    end;


    procedure ShowLineComments()
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentSheet: Page "Sales Comment Sheet";
    begin
    end;


    procedure SetDefaultQuantity()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
    end;


    procedure UpdatePrePaymentAmounts()
    var
        ShipmentLine: Record "Sales Shipment Line";
        SalesOrderLine: Record "Sales Line";
    begin
    end;


    procedure ZeroAmountLine(QtyType: Option General,Invoicing,Shipping): Boolean
    begin
    end;


    procedure CalcSalesTaxLines(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        TaxArea: Record "Tax Area";
    begin
    end;

    local procedure CheckForTaxDifferences()
    begin
    end;


    procedure TecNum_Cant()
    begin
    end;


    procedure TecNum_Prec()
    begin
    end;


    procedure TecNum_Desc()
    begin
    end;


    procedure Desc_Predef(Porciento_Desc: Decimal)
    begin
    end;


    procedure Anula_Linea()
    begin
    end;


    procedure Unidad_Medida()
    begin
    end;


    procedure TecNum_Desc_DtoGral()
    begin
    end;


    procedure AplicaCupon()
    begin
    end;
}

