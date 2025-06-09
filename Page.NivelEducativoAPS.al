page 76328 "Nivel Educativo APS"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Nivel Educativo APS";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Código"; rec.Código)
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
            }
        }
    }

    actions
    {
    }
}

