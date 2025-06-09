page 56073 "Sello/Marca"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Sello/Marca";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Sello/Marca"; rec."Cod. Sello/Marca")
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

