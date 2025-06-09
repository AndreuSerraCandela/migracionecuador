pageextension 50000 "Vendor List" extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Ven&dor")
        {
            action(Desbloquear)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    Vendor.Reset();
                    Vendor.ModifyAll("Blocked", Vendor."Blocked"::" ");
                end;
            }
        }
    }

    var
        myInt: Integer;
}