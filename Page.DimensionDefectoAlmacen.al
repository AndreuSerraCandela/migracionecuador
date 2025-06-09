page 76019 "Dimension Defecto Almacen"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Dimension Defecto Almacen";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Codigo Dimension"; rec."Codigo Dimension")
                {
                }
                field("Valor Dimension"; rec."Valor Dimension")
                {
                }
            }
        }
    }

    actions
    {
    }
}

