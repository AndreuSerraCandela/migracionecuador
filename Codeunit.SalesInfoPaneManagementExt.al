codeunit 55051 "Sales Info-Pane Management Ext"
{
    var
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        SalesPriceCalcMgt: Codeunit "Sales Line - Price";
        AvailableToPromise: Codeunit "Available to Promise";

    procedure DocExist(CurrentSalesHeader: Record "Sales Header"; CustNo: Code[20]): Boolean
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnReceipt: Record "Return Receipt Header";
        TmpSalesHeader: Record "Sales Header";
    begin
        if CustNo = '' then
            exit(false);

        SalesInvHeader.SetRange("Sell-to Customer No.", CustNo);
        if not SalesInvHeader.IsEmpty then
            exit(true);

        SalesShptHeader.SetRange("Sell-to Customer No.", CustNo);
        if not SalesShptHeader.IsEmpty then
            exit(true);

        SalesCrMemoHeader.SetRange("Sell-to Customer No.", CustNo);
        if not SalesCrMemoHeader.IsEmpty then
            exit(true);

        TmpSalesHeader.SetRange("Sell-to Customer No.", CustNo);
        if TmpSalesHeader.FindFirst then begin
            if (TmpSalesHeader."Document Type" <> CurrentSalesHeader."Document Type") or
               (TmpSalesHeader."No." <> CurrentSalesHeader."No.") then
                exit(true);
            if TmpSalesHeader.Find('>') then
                exit(true);
        end;

        ReturnReceipt.SetRange("Sell-to Customer No.", CustNo);
        if not ReturnReceipt.IsEmpty then
            exit(true);

        exit(false);
    end;

    procedure CalcAvailabilityTransLine(var TransferLine: Record "Transfer Line"): Decimal
    var
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        LookaheadDateformula: DateFormula;
        AvailabilityDate: Date;
    begin
        if not GetItemTransLine(TransferLine) then
            exit(0);

        if TransferLine."Shipment Date" <> 0D then
            AvailabilityDate := TransferLine."Shipment Date"
        else
            AvailabilityDate := WorkDate();

        Item.Reset();
        Item.SetRange("Date Filter", 0D, AvailabilityDate);
        Item.SetRange("Variant Filter", TransferLine."Variant Code");
        Item.SetRange("Location Filter", TransferLine."Transfer-from Code");
        Item.SetRange("Drop Shipment Filter", false);

        exit(
            AvailableToPromise.CalcQtyAvailabletoPromise(
                Item,
                GrossRequirement,
                ScheduledReceipt,
                AvailabilityDate,
                Enum::"Analysis Period Type"::Day,
                LookaheadDateformula));
    end;

    procedure CalcAvailabilityTL_BackOrder(var TransferLine: Record "Transfer Line"): Decimal
    begin
        if not GetItemTransLine(TransferLine) then
            exit(0);

        Item.SetRange("Variant Filter", TransferLine."Variant Code");
        Item.SetRange("Location Filter", TransferLine."Transfer-from Code");
        Item.SetRange("Drop Shipment Filter", false);

        Item.CalcFields(
            "Qty. on Component Lines",
            "Planning Issues (Qty.)",
            "Qty. on Sales Order",
            "Qty. on Assembly Order",
            "Res. Qty. on Assembly Order",
            "Qty. on Service Order",
            Inventory,
            "Reserved Qty. on Inventory",
            "Trans. Ord. Shipment (Qty.)");

        exit(Item.Inventory - Item."Qty. on Sales Order" - Item."Qty. on Assembly Order" -
             Item."Res. Qty. on Assembly Order" - Item."Qty. on Service Order" - Item."Reserved Qty. on Inventory" -
             Item."Trans. Ord. Shipment (Qty.)");
    end;

    procedure CalcNoOfSubstitutionsTransLine(var TransferLine: Record "Transfer Line"): Integer
    begin
        if not GetItemTransLine(TransferLine) then
            exit(0);

        Item.CalcFields("No. of Substitutes");
        exit(Item."No. of Substitutes");
    end;

    procedure CalcAvailability_BackOrder(var SalesLine: Record "Sales Line"): Decimal
    begin
        if not GetItem(SalesLine) then
            exit(0);

        Item.SetRange("Variant Filter", SalesLine."Variant Code");
        Item.SetRange("Location Filter", SalesLine."Location Code");
        Item.SetRange("Drop Shipment Filter", false);

        Item.CalcFields(
            "Qty. on Component Lines",
            "Planning Issues (Qty.)",
            "Qty. on Sales Order",
            "Qty. on Assembly Order",
            "Res. Qty. on Assembly Order",
            "Qty. on Service Order",
            Inventory,
            "Reserved Qty. on Inventory",
            "Qty. on Pre Sales Order",
            "Trans. Ord. Shipment (Qty.)");

        exit(Item.Inventory - Item."Qty. on Sales Order" - Item."Qty. on Assembly Order" -
             Item."Res. Qty. on Assembly Order" - Item."Qty. on Service Order" - Item."Reserved Qty. on Inventory" -
             Item."Qty. on Pre Sales Order" - Item."Trans. Ord. Shipment (Qty.)");
    end;

    procedure CalcAvailability_Item(ItemNo: Code[20]; LocationCode: Code[20]): Decimal
    begin
        if ItemNo = '' then
            exit(0);

        Item.Get(ItemNo);
        Item.SetRange("Location Filter", LocationCode);
        Item.SetRange("Drop Shipment Filter", false);

        Item.CalcFields(
            "Qty. on Component Lines",
            "Planning Issues (Qty.)",
            "Qty. on Sales Order",
            "Qty. on Service Order",
            Inventory,
            "Reserved Qty. on Inventory",
            "Trans. Ord. Shipment (Qty.)");

        exit(Item.Inventory - Item."Qty. on Sales Order" - Item."Qty. on Service Order" -
             Item."Reserved Qty. on Inventory" - Item."Trans. Ord. Shipment (Qty.)");
    end;

    procedure CalcNoOfSalesPrices(var SalesLine: Record "Sales Line"): Integer
    begin
        GetSalesHeader(SalesLine);
        //exit(SalesPriceCalcMgt.NoOfSalesLinePrice(SalesHeader, SalesLine, true));
    end;

    procedure CalcNoOfSalesLineDisc(var SalesLine: Record "Sales Line"): Integer
    begin
        GetSalesHeader(SalesLine);
        //exit(SalesPriceCalcMgt.NoOfSalesLineLineDisc(SalesHeader, SalesLine, true));
    end;

    local procedure GetItem(var SalesLine: Record "Sales Line"): Boolean
    begin
        if (SalesLine.Type <> SalesLine.Type::Item) or (SalesLine."No." = '') then
            exit(false);
        if SalesLine."No." <> Item."No." then
            Item.Get(SalesLine."No.");
        exit(true);
    end;

    procedure GetItemTransLine(var TransferLine: Record "Transfer Line"): Boolean
    begin
        if TransferLine."Item No." = '' then
            exit(false);
        if TransferLine."Item No." <> Item."No." then
            Item.Get(TransferLine."Item No.");
        exit(true);
    end;

    local procedure GetSalesHeader(var SalesLine: Record "Sales Line")
    begin
        if (SalesLine."Document Type" <> SalesHeader."Document Type") or
           (SalesLine."Document No." <> SalesHeader."No.") then
            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
    end;
}
