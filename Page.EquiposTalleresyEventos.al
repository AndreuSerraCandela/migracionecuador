page 76201 "Equipos Talleres y Eventos"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Equipos Talleres y Eventos";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Taller - Evento"; rec."Cod. Taller - Evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Codigo Equipo"; rec."Codigo Equipo")
                {
                }
                field("Description Taller"; rec."Description Taller")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Descripcion Equipo"; rec."Descripcion Equipo")
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("Costo Unitario"; rec."Costo Unitario")
                {
                }
                field(Secuencia; rec.Secuencia)
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

