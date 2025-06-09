page 76143 "Colegio - Ranking - Nivel"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Colegio - Ranking - Nivel";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Categoria colegio"; rec."Categoria colegio")
                {
                }
            }
        }
    }

    actions
    {
    }
}

