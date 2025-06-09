page 56090 "Texto Configurable"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Texto Configurable";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Id. Tabla"; rec."Id. Tabla")
                {
                }
                field("Sección"; rec.Sección)
                {
                }
                field("No. Linea"; rec."No. Linea")
                {
                }
                field(Texto; rec.Texto)
                {
                }
            }
        }
    }

    actions
    {
    }
}

