codeunit 55044 "Inventory Posting To G/L Ext"
{
    var
    DimBufMgt: Codeunit "Dimension Buffer Management";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Posting To G/L", 'OnPostInvtPostBufOnAfterInitGenJnlLine', '', false, false)]
    local procedure OnPostInvtPostBufOnAfterInitGenJnlLineHandler(var GenJournalLine: Record "Gen. Journal Line"; ValueEntry: Record "Value Entry")
    begin
        // Quitar el valor asignado al campo "Prod. Order No."
        GenJournalLine."Prod. Order No." := '';
    end;

    procedure GetDimBuf(DimEntryNo: Integer; var TempDimBuf: Record "Dimension Buffer" temporary)
    begin
        TempDimBuf.DeleteAll();
        DimBufMgt.GetDimensions(DimEntryNo, TempDimBuf);
    end;    
}
