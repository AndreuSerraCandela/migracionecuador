codeunit 56009 "wse entry"
{
    Permissions = TableData "Warehouse Entry" = rimd;

    trigger OnRun()
    var
        WhseEntry: Record "Warehouse Entry";
    begin
        if not Confirm(CompanyName) then
            exit;

        WhseEntry.Get('1168134');
        if (WhseEntry."Item No." = '101153001') and (WhseEntry.Quantity = -150) then
            WhseEntry.Delete
        else
            Error('error producto 1');

        WhseEntry.Get('1168137');
        if (WhseEntry."Item No." = '101153011') and (WhseEntry.Quantity = -150) then
            WhseEntry.Delete
        else
            Error('error producto 2');

        Message('fin');
    end;
}

