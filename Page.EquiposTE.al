#pragma implicitwith disable
page 76202 "Equipos T&E"
{
    ApplicationArea = all;
    Caption = 'Equipment Workshops and Events';
    DataCaptionExpression = Format(Rec."Tipo registro");
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING("Tipo registro", Codigo)
                      WHERE("Tipo registro" = CONST("Equipos T&E"));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Tipo registro" := Rec."Tipo registro"::"Equipos T&E";
    end;
}

#pragma implicitwith restore

