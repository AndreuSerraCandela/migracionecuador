pageextension 50089 pageextension50089 extends "Dimension Values"
{
    layout
    {
        movefirst(Control1; "Dimension Code")
        addafter(Name)
        {
            field(Indentation; rec.Indentation)
            {
            ApplicationArea = All;
            }
        }
    }

    var
        cFunMdM: Codeunit "Funciones MdM";

    trigger OnDeleteRecord(): Boolean
    begin
        // -MdM
        cFunMdM.GetDimValueEditable(Rec, true);
        // +MdM
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // -MdM
        cFunMdM.GetDimValueEditable(Rec, true);
        // +MdM
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        // -MdM
        cFunMdM.GetDimValueEditable(Rec, true);
        // +MdM
    end;
}

