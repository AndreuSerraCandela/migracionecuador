page 56029 Edicion
{
    ApplicationArea = all;
    Caption = 'Edition';
    PageType = List;
    SourceTable = Edicion;

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

