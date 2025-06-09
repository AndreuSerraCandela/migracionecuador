page 50119 "Conf. Medios de pagos"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Conf. Medios de pago";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. med. pago"; rec."Cod. med. pago")
                {
                }
                field(Credito; rec.Credito)
                {
                }
                field("Account Type"; rec."Account Type")
                {
                }
                field("Account No."; rec."Account No.")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Cod. Forma Pago"; rec."Cod. Forma Pago")
                {
                }
                field("ID Agrupacion"; rec."ID Agrupacion")
                {
                }
            }
        }
    }

    actions
    {
    }
}

