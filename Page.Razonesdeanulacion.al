page 76078 "Razones de anulacion"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Razones Anulacion NCF";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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

