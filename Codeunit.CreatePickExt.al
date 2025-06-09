
codeunit 55052 "Create Pick Ext"
{
    Subtype = Normal;

    var
        ExpiredItemMessageText: Text[100];

    PROCEDURE GetExpiredItemMessage() : Text[100];
    BEGIN
      EXIT(ExpiredItemMessageText);
    END;

}
