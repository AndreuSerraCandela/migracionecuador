codeunit 55007 "value entry macro"
{
    Permissions = TableData "Value Entry" = rimd;

    trigger OnRun()
    var
        r5802: Record "Value Entry";
    begin

        if Confirm(CompanyName) then begin
            r5802.SetRange("Document No.", 'VR-343656');
            if r5802.FindFirst then
                r5802.DeleteAll;
        end;
    end;
}

