page 76337 "Pagos a Expositores Subform"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Detalle Pago Expositores";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Evento"; rec."Cod. Evento")
                {
                }
                field("Descripción Evento"; rec."Descripción Evento")
                {
                }
                field(Secuencia; rec.Secuencia)
                {
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                }
                field("Cod. Expositor"; rec."Cod. Expositor")
                {
                    Editable = false;
                }
                field("Monto a Pagar"; rec."Monto a Pagar")
                {
                }
            }
        }
    }

    actions
    {
    }
}

