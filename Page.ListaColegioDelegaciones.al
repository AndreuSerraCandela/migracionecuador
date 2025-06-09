page 76276 "Lista Colegio - Delegaciones"
{
    ApplicationArea = all;
    Editable = false;
    PageType = Card;
    SourceTable = "Talleres y Eventos - Grados";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No. Solicitud"; rec."No. Solicitud")
                {
                    Visible = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Descripcion Nivel"; rec."Descripcion Nivel")
                {
                }
                field("Descripcion Grado"; rec."Descripcion Grado")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Branch")
            {
                Caption = '&Branch';
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Ficha Colegio - Delegaciones";
                    RunPageLink = "No. Solicitud" = FIELD ("No. Solicitud");
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }
}

