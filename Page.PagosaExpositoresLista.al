page 76336 "Pagos a Expositores Lista"
{
    ApplicationArea = all;

    CardPageID = "Pagos a Expositores Ficha";
    Editable = false;
    PageType = List;
    SourceTable = "Pago a Expositores";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID Pago"; rec."ID Pago")
                {
                }
                field("Cod. Expositor"; rec."Cod. Expositor")
                {
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                }
                field(Fecha; rec.Fecha)
                {
                }
                field("No. Documento"; rec."No. Documento")
                {
                }
                field("Estado Pago"; rec."Estado Pago")
                {
                }
            }
        }
    }

    actions
    {
    }
}

