page 76291 "Lista Eventos"
{
    ApplicationArea = all;

    Caption = 'Event Lists';
    CardPageID = "Ficha Talleres - Eventos";
    Editable = false;
    PageType = List;
    SourceTable = Eventos;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No."; rec."No.")
                {
                }
                field("Tipo de Evento"; rec."Tipo de Evento")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Fecha creacion"; rec."Fecha creacion")
                {
                }
                field("Capacidad de vacantes"; rec."Capacidad de vacantes")
                {
                }
                field("Horas programadas"; rec."Horas programadas")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000006; "Exposit. - Eventos  ListPart")
            {
                SubPageLink = "Cod. Evento" = FIELD("No.");
            }
        }
    }

    actions
    {
    }
}

