page 76363 "Promotores - Docentes"
{
    ApplicationArea = all;

    PageType = Card;
    SourceTable = "Promotor - Docentes";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Codigo Docente"; rec."Codigo Docente")
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Nombre Docente"; rec."Nombre Docente")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                }
            }
        }
    }

    actions
    {
    }
}

