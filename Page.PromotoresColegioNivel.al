page 76362 "Promotores - Colegio - Nivel"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Colegio - Nivel";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field(Turno; rec.Turno)
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
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

