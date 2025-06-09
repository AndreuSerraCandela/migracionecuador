page 56030 "Tipo Edicion"
{
    ApplicationArea = all;
    Caption = 'Edtion Type';
    PageType = List;
    SourceTable = "Tipo Edicion";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Tipo Edicion"; rec."Cod. Tipo Edicion")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }
}

