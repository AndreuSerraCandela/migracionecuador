page 76216 "Ficha Colegio - Delegaciones"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Talleres y Eventos - Grados";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No. Solicitud"; rec."No. Solicitud")
                {
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
                field("Descripcion Grado"; rec."Descripcion Grado")
                {
                    Caption = 'State / ZIP Code';
                }
                field("Descripcion Nivel"; rec."Descripcion Nivel")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
            }
        }
    }

    actions
    {
    }
}

