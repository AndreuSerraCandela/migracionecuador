page 76104 "Asist. Ent - Entrenam  Factbox"
{
    ApplicationArea = all;
    Caption = 'Training';
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
                field("Titulo entrenamiento"; rec."Titulo entrenamiento")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Fecha programacion"; rec."Fecha programacion")
                {
                }
                field("No. entrenamiento"; rec."No. entrenamiento")
                {
                }
                field("Tipo entrenamiento"; rec."Tipo entrenamiento")
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

