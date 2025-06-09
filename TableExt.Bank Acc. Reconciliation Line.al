tableextension 50044 tableextension50044 extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
    }

    //Unsupported feature: Code Modification on "GetAppliesToID(PROCEDURE 62)".
    //Se modifico el proceso y se llama desde CU 370, 426, 1255 Y Table 1293
    procedure GetAppliesToID2(): Code[50]
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        exit(CopyStr(Format("Statement No.") + '-' + Format("Statement Line No."), 1, MaxStrLen(CustLedgerEntry."Applies-to ID")));
    end;
}

