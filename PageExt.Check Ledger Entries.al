pageextension 50048 pageextension50048 extends "Check Ledger Entries"
{
    layout
    {
        addafter("Bank Account No.")
        {
            field(Beneficiario; rec.Beneficiario)
            {
            ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("Statement Status"; rec."Statement Status")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec.GetFilters <> '' then
            if Rec.FindFirst then;
    end;

}

