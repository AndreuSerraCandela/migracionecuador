page 76129 "Carga Horaria"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Carga Horaria";

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

