page 76103 "Asist. Ent - Empleados Factbox"
{
    ApplicationArea = all;
    Caption = 'Enrolled';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Asistentes entrenamientos";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No. empleado"; rec."No. empleado")
                {
                }
                field("Nombre completo"; rec."Nombre completo")
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

