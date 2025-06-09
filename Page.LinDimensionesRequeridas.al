page 76264 "Lin. Dimensiones Requeridas"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Lin. Dimensiones Req.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Dimension"; rec."Cod. Dimension")
                {
                }
                field("Registro valor"; rec."Registro valor")
                {
                }
            }
        }
    }

    actions
    {
    }
}

