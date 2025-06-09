#pragma implicitwith disable
page 76127 "Canales de ventas"
{
    ApplicationArea = all;

    Caption = 'Sales channels';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING("Tipo registro", Codigo)
                      WHERE("Tipo registro" = CONST("Canal de venta"));
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
        Rec."Tipo registro" := Rec."Tipo registro"::"Canal de venta";
    end;
}

#pragma implicitwith restore

