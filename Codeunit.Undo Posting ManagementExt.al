codeunit 55045 "Undo Posting ManagementExt"
{
    // TODO: Replace 'OnBeforeTestPostedWhseReceiptLine' with an existing event from "Undo Posting Management" codeunit.
    // Example: If there is an event called 'OnBeforeUndoPosting', subscribe to that instead.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Posting Management", 'OnAfterTestAllTransactions', '', false, false)]
    local procedure OnBeforeUndoPosting(
        UndoLineNo: Integer;
        SourceType: Integer;
        SourceSubtype: Integer;
        SourceID: Code[20];
        SourceRefNo: Integer;
         UndoType: Integer;
        UndoID: Code[20])
    var
        PostedAsmHeader: Record "Posted Assembly Header";
    begin
        if UndoType = DATABASE::"Posted Assembly Header" then begin
            PostedAsmHeader.Get(UndoID);
            if not PostedAsmHeader.IsAsmToOrder then begin
                // Tu lógica personalizada:
                TestWarehouseBinContent(SourceType, SourceSubtype, SourceID, SourceRefNo, PostedAsmHeader."Cantidad (Base) a Revertir");
            end;
        end;

    end;

    local procedure TestWarehouseBinContent(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; UndoQtyBase: Decimal)
    var
        WhseEntry: Record "Warehouse Entry";
        BinContent: Record "Bin Content";
        QtyAvailToTake: Decimal;
        Text015: Label 'The quantity %1 of item %2, variant %3, unit of measure %4, location %5, bin %6 is not available to take.';
    begin
        WhseEntry.SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, true);
        if not WhseEntry.FindFirst() then
            exit;

        BinContent.Get(
            WhseEntry."Location Code",
            WhseEntry."Bin Code",
            WhseEntry."Item No.",
            WhseEntry."Variant Code",
            WhseEntry."Unit of Measure Code");
        QtyAvailToTake := BinContent.CalcQtyAvailToTake(0);
        if QtyAvailToTake < UndoQtyBase then
            Error(Text015,
                WhseEntry."Item No.",
                WhseEntry."Variant Code",
                WhseEntry."Unit of Measure Code",
                WhseEntry."Location Code",
                WhseEntry."Bin Code",
                UndoQtyBase,
                QtyAvailToTake);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Posting Management", 'OnCheckItemLedgEntriesOnBeforeCheckTempItemLedgEntry', '', false, false)]
    local procedure OnCheckItemLedgEntriesOnBeforeCheckTempItemLedgEntry(var TempItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        PostedAsmHeader: Record "Posted Assembly Header";
    begin
        IF TempItemLedgEntry."Order Type" <> TempItemLedgEntry."Order Type"::Assembly THEN
            TempItemLedgEntry.TESTFIELD(TempItemLedgEntry."Remaining Quantity", TempItemLedgEntry.Quantity)
        ELSE
            IF TempItemLedgEntry."Order Type" <> TempItemLedgEntry."Order Type"::Assembly THEN
                TempItemLedgEntry.TESTFIELD(TempItemLedgEntry."Shipped Qty. Not Returned", TempItemLedgEntry.Quantity);
    end;
}