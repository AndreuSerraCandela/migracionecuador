page 76316 "Lista ventas caja TPV"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Transacciones TPV";

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
                field("No. Transaccion"; rec."No. Transaccion")
                {
                }
                field("Tipo Transaccion"; rec."Tipo Transaccion")
                {
                }
                field("Id. cajero"; rec."Id. cajero")
                {
                }
                field(Hora; rec.Hora)
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Importe IVA inc."; rec."Importe IVA inc.")
                {
                }
                field("No. Borrador"; rec."No. Borrador")
                {
                    Caption = 'No. Borrador';
                }
                field("No. Registrado"; rec."No. Registrado")
                {
                    Caption = 'No. Registrado';
                }
            }
        }
    }

    actions
    {
    }
}

