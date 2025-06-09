page 76377 "Requisitos del Cargo"
{
    ApplicationArea = all;
    Caption = 'Job requisites';
    PageType = List;
    SourceTable = "Requisitos del Cargo";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Cargo"; rec."Cod. Cargo")
                {
                    Visible = false;
                }
                field("Cod. requisito"; rec."Cod. requisito")
                {
                }
                field("Cualificacion requerida"; rec."Cualificacion requerida")
                {
                }
                field(Requerido; rec.Requerido)
                {
                }
            }
        }
    }

    actions
    {
    }
}

