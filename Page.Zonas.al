page 76426 Zonas
{
    ApplicationArea = all;

    Caption = 'Zone';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING("Tipo registro", Codigo)
                      WHERE("Tipo registro" = CONST(Zonas));
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
        rec."Tipo registro" := rec."Tipo registro"::Zonas;
    end;
}

