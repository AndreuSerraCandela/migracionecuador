codeunit 55046 "Inventory AdjustmentExt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", 'OnForwardAppliedCostOnAfterSetAppliedQty', '', false, false)]
    local procedure OnForwardAppliedCostOnAfterSetAppliedQty(ItemLedgerEntry: Record "Item Ledger Entry"; var AppliedQty: Decimal)
    var
        OutbndItemLedgEntry: Record "Item Ledger Entry";
    begin
        //+#398050
        //... Se ha visto algun caso en que se han eliminado registros en "Mov. Producto".
        //... Se intenta que el proceso pueda continuar.....
        //OutbndItemLedgEntry.GET(OutbndItemLedgEntryNo);
        if not OutbndItemLedgEntry.Get(ItemLedgerEntry."Entry No.") then begin
            if TestPermitirQueFalteMovProducto(ItemLedgerEntry."Entry No.") then
                exit
            else
                OutbndItemLedgEntry.Get(ItemLedgerEntry."Entry No.");
        end;
        //-#398050
    end;

    local procedure TestPermitirQueFalteMovProducto(pEntryNo: Integer): Boolean
    var
        lrCfgEmpresa: Record 56001;
        lResult: Boolean;
    begin
        //+#398050

        lResult := false;
        if lrCfgEmpresa.FindFirst() then
            if lrCfgEmpresa.Country = 'EC' then
                if (pEntryNo >= 1652400) and (pEntryNo <= 1652439) then
                    lResult := true;

        exit(lResult);
    end;
}