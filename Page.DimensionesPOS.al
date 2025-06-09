page 76176 "Dimensiones POS"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Dimensiones POS";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Dimension; rec.Dimension)
                {
                }
                field("Valor dimension"; rec."Valor dimension")
                {
                }
            }
        }
    }

    actions
    {
    }
}

