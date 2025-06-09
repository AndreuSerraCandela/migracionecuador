page 76322 "Materiales Talleres y Eventos"
{
    ApplicationArea = all;

    AutoSplitKey = true;
    Caption = 'hops and Events';
    PageType = Card;
    SourceTable = "Materiales Talleres y Eventos";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Taller - Evento"; rec."Cod. Taller - Evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Description Taller"; rec."Description Taller")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                }
                field("Tipo de Material"; rec."Tipo de Material")
                {
                }
                field("Codigo Material"; rec."Codigo Material")
                {
                }
                field("Description Material"; rec."Description Material")
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("Costo Unitario"; rec."Costo Unitario")
                {
                }
            }
        }
    }

    actions
    {
    }
}

