page 76231 "Grupo - Colegios"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Grupo - Colegios";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Colegio"; rec."Cod. Colegio")
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

