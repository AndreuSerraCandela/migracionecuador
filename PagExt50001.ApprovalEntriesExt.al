pageextension 50001 ApprovalEntriesExt extends "Approval Entries"
{
    procedure Setfilters(TableId: Integer; DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20])
    var
        RecRef: Record "Approval Entry";
    begin
        if TableId <> 0 then begin
            RecRef.FILTERGROUP(2);
            RecRef.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval");
            RecRef.SETRANGE("Table ID", TableId);
            RecRef.SETRANGE("Document Type", DocumentType);
            if DocumentNo <> '' then
                RecRef.SETRANGE("Document No.", DocumentNo);
            RecRef.FILTERGROUP(0);
        end;
    end;
}