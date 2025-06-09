page 76071 DISPONIBLE
{
    ApplicationArea = all;
    PageType = Document;
    SourceTable = "Tipos de acciones personal";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Tipo de accion"; rec."Tipo de accion")
                {
                }
                field("Emitir documento"; rec."Emitir documento")
                {
                }
            }
        }
    }

    actions
    {
    }
}

