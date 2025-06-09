page 76109 Atenciones
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Hist. Promotor - Ppto Muestras";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Cod. Producto"; rec."Cod. Producto")
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

