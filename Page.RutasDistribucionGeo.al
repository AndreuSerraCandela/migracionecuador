page 76380 "Rutas - Distribucion Geo."
{
    ApplicationArea = all;
    DataCaptionFields = "Cod. Ruta", "Name of route";
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Rutas - CP";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Ruta"; rec."Cod. Ruta")
                {
                }
                field("Name of route"; rec."Name of route")
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
                field(County; rec.County)
                {
                }
                field("Post Code"; rec."Post Code")
                {
                }
                field(City; rec.City)
                {
                }
            }
        }
    }

    actions
    {
    }
}

