page 76299 "Lista materiales"
{
    ApplicationArea = all;
    Editable = false;
    PageType = Card;
    SourceTable = "Temp Estadistica APS";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Editorial"; rec."Cod. Editorial")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
            }
        }
    }

    actions
    {
    }
}

