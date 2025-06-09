page 55006 "Tipo Contribuyente - Retencion"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Tipo Contribuyente - Retencion";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Codigo Retencion"; rec."Codigo Retencion")
                {
                }
                field("Tipos Agente de Retencion"; rec."Tipos Agente de Retencion")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

