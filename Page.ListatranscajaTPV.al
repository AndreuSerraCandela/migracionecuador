page 76314 "Lista trans. caja TPV"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Transacciones Caja TPV";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. tienda"; rec."Cod. tienda")
                {
                }
                field("Cod. TPV"; rec."Cod. TPV")
                {
                }
                field(Fecha; rec.Fecha)
                {
                }
                field("No. turno"; rec."No. turno")
                {
                }
                field("No. transaccion"; rec."No. transaccion")
                {
                }
                field("Tipo transaccion"; rec."Tipo transaccion")
                {
                }
                field("No. Registrado"; rec."No. Registrado")
                {
                }
                field("Id. cajero"; rec."Id. cajero")
                {
                }
                field(Hora; rec.Hora)
                {
                }
                field("Forma de pago"; rec."Forma de pago")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Importe (DL)"; rec."Importe (DL)")
                {
                }
                field("Cod. divisa"; rec."Cod. divisa")
                {
                }
                field("Factor divisa"; rec."Factor divisa")
                {
                }
                field(Cambio; rec.Cambio)
                {
                }
            }
        }
    }

    actions
    {
    }
}

