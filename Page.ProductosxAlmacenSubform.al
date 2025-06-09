page 56061 "Productos x Almacen Subform"
{
    ApplicationArea = all;
    // 001 RRT 02.06.2014

    PageType = ListPart;
    SourceTable = "Almacenes x Grupo";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Almacen; rec.Almacen)
                {
                }
                field("Nombre Almacen"; rec."Nombre Almacen")
                {
                }
            }
        }
    }

    actions
    {
    }
}

