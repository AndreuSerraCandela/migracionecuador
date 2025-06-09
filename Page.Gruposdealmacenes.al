page 56060 "Grupos de almacenes"
{
    ApplicationArea = all;
    // 001 RRT 02.06.2014

    PageType = List;
    SourceTable = "Grupos de almacenes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Grupo; rec.Grupo)
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
            }
            part(AlmacenesRelacionados; "Productos x Almacen Subform")
            {
                SubPageLink = Grupo = FIELD (Grupo);
            }
        }
    }

    actions
    {
    }
}

