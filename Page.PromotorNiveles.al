page 76367 "Promotor - Niveles"
{
    ApplicationArea = all;
    DataCaptionFields = "Cod. Promotor", "Nombre Promotor";
    PageType = Card;
    SourceTable = "Promotor - Niveles";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Visible = false;
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                }
                field("Descripcion Nivel"; rec."Descripcion Nivel")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

