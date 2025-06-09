pageextension 50101 pageextension50101 extends "Item Categories"
{
    layout
    {
        modify(Control1)
        {
            Editable = wEditable2;
        }
        modify("Code")
        {
            Editable = wEditable2;
        }
        modify(Description)
        {
            Editable = wEditable2;
        }
        addafter(Description)
        {
            field("Def. Gen. Prod. Posting Group"; rec."Def. Gen. Prod. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                Editable = wEditable2;
            }
            field("Def. Inventory Posting Group"; rec."Def. Inventory Posting Group")
            {
                ApplicationArea = Basic, Suite;
                Editable = wEditable2;
            }
            field("Def. VAT Prod. Posting Group"; rec."Def. VAT Prod. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                Editable = wEditable2;
            }
            field("Def. Costing Method"; rec."Def. Costing Method")
            {
                ApplicationArea = Basic, Suite;
                Editable = wEditable2;
            }
            field(MdM; rec.MdM)
            {
                ApplicationArea = Basic, Suite;
                Editable = wEditable2;
            }
            field(Bloqueado; rec.Bloqueado)
            {
                ApplicationArea = Basic, Suite;
                Editable = wEditable2;
                Visible = false;
            }
        }
    }
    actions
    {
        modify(Recalculate)
        {
            ToolTip = 'Update the tree of item categories based on recent changes.';
        }
    }

    var
        cFunMdm: Codeunit "Funciones MdM";
        wEditable: Boolean;
        wEditable2: Boolean;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        wEditable2 := wEditable or (not Rec.MdM);
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        wEditable2 := wEditable or (not Rec.MdM);
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        // +MdM
        wEditable := cFunMdm.GetEditable;
        // -MdM
    end;
}

