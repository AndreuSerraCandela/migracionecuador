page 76361 "Promotor - Entrega de Muestras"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Promotor - Entrega Muestras";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Visible = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field(Fecha; rec.Fecha)
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field("Fecha Visita"; rec."Fecha Visita")
                {
                }
                field("Hora Inicial Visita"; rec."Hora Inicial Visita")
                {
                }
                field("Hora Inicial Final"; rec."Hora Inicial Final")
                {
                }
                field("Fecha Proxima Visita"; rec."Fecha Proxima Visita")
                {
                }
                field(Comentario; rec.Comentario)
                {
                }
            }
        }
    }

    actions
    {
    }
}

