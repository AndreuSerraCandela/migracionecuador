page 76009 "Dimension Set Entries TPV"
{
    ApplicationArea = all;
    Caption = 'POS Dimension Set Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Dimension Set Entry TPV";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Dimension Code"; rec."Dimension Code")
                {
                }
                field("Dimension Name"; rec."Dimension Name")
                {
                    Visible = false;
                }
                field(DimensionValueCode; rec."Dimension Value Code")
                {
                }
                field("Dimension Value Name"; rec."Dimension Value Name")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if FormCaption <> '' then
            CurrPage.Caption := FormCaption;
    end;

    trigger OnInit()
    begin
        if FormCaption <> '' then
            CurrPage.Caption := FormCaption;
    end;

    var
        FormCaption: Text[250];


    procedure SetFormCaption(NewFormCaption: Text[250])
    begin
        FormCaption := CopyStr(NewFormCaption + ' - ' + CurrPage.Caption, 1, MaxStrLen(FormCaption));
    end;
}

