page 76333 "Padres - Aficiones"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Padres - Aficiones";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Padre"; rec."Cod. Padre")
                {
                }
                field("Nombre Padre"; rec."Nombre Padre")
                {
                }
                field("Cod. aficion"; rec."Cod. aficion")
                {
                }
                field("Descripcion aficion"; rec."Descripcion aficion")
                {
                }
            }
        }
    }

    actions
    {
    }
}

