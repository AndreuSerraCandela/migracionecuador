#pragma implicitwith disable
page 76096 "Areas de interes"
{
    ApplicationArea = all;

    Caption = 'Areas of interest';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING("Tipo registro", Codigo)
                      WHERE("Tipo registro" = CONST("Areas de interés"));
    UsageCategory = Administration;

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
        Rec."Tipo registro" := Rec."Tipo registro"::"Areas de interés";
    end;
}

#pragma implicitwith restore

