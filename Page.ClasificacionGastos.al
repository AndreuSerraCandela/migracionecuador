page 76003 "Clasificacion Gastos"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Clasificacion Gastos";

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

