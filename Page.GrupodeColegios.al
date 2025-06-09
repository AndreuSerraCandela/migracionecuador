page 76232 "Grupo de Colegios"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Grupo de Colegios";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Grupo"; rec."Cod. Grupo")
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Asociar Colegios")
            {
                Caption = 'Asociar Colegios';
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Grupo - Colegios";
                RunPageLink = "Cod. grupo" = FIELD ("Cod. Grupo");
            }
        }
    }
}

