page 76410 "Tarifas - Tipos de Evento"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Tarifas - Tipos de Eventos";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo Evento"; rec."Tipo Evento")
                {
                }
                field(Distrito; rec.Distrito)
                {
                }
                field(Pago; rec.Pago)
                {
                }
                field("Tipo Pago"; rec."Tipo Pago")
                {
                }
                field(Monto; rec.Monto)
                {
                }
            }
        }
    }

    actions
    {
    }
}

