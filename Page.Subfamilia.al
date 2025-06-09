page 76404 "Sub familia"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = WHERE ("Tipo registro" = CONST ("Sub familia"));

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

