page 76332 "Orden Religiosa"
{
    ApplicationArea = all;

    Caption = 'Religious order';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = WHERE("Tipo registro" = CONST("Orden religiosa"));
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
}

