pageextension 50091 pageextension50091 extends "Default Dimensions"
{
    layout
    {
        modify(Control1)
        {
            Editable = wEditable;
        }
        modify("Dimension Code")
        {
            Style = Strong;
            StyleExpr = NOT wEditable;

            trigger OnAfterValidate()
            begin
                cFunMdm.GetDimEditable(Rec, true); // MdM
            end;
        }
        modify("Dimension Value Code")
        {
            ToolTip = 'Specifies the dimension value code to suggest as the default dimension.';
            Style = Strong;
            StyleExpr = NOT wEditable;
        }
        modify("Value Posting")
        {
            ToolTip = 'Specifies how default dimensions and their values must be used.';
            Style = Strong;
            StyleExpr = NOT wEditable;
        }
        addfirst(Control1)
        {
            field("Table ID"; rec."Table ID")
            {
            ApplicationArea = All;
            }
            field("No."; rec."No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    var
        cFunMdm: Codeunit "Funciones MdM";
        wEditable: Boolean;

    trigger OnAfterGetRecord()
    begin
        // <MdM>
        wEditable := cFunMdm.GetDimEditable(Rec, false); // MdM
        CurrPage.Editable := wEditable;
        // <\MdM>
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        // <MdM>
        wEditable := cFunMdm.GetDimEditable(Rec, false); // MdM
        exit(wEditable);
        // <\MdM>
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        // <MdM>
        wEditable := cFunMdm.GetDimEditable(Rec, false); // MdM
        exit(wEditable);
        // <\MdM>
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        // <MdM>
        wEditable := cFunMdm.GetDimEditable(Rec, false); // MdM
        exit(wEditable);
        // <\MdM>
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        wEditable := cFunMdm.GetDimEditable(Rec, false); // MdM
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        wEditable := true; // MdM
    end;
}

