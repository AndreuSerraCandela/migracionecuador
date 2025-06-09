page 76267 "Lin. Hist. prest. cooperativa"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Hist. Lin. Prest. cooperativa";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Prestamo"; rec."No. Prestamo")
                {
                    Visible = false;
                }
                field("Código Empleado"; rec."Código Empleado")
                {
                    Visible = false;
                }
                field("No. Cuota"; rec."No. Cuota")
                {
                }
                field("Fecha Transaccion"; rec."Fecha Transaccion")
                {
                }
                field("Saldo inicial"; rec."Saldo inicial")
                {
                }
                field(Interes; rec.Interes)
                {
                }
                field("Importe cuota"; rec."Importe cuota")
                {
                }
                field(Amortizacion; rec.Amortizacion)
                {
                }
                field("Saldo final"; rec."Saldo final")
                {
                }
                field("Importe mora"; rec."Importe mora")
                {
                    Visible = false;
                }
                field("Fecha mora"; rec."Fecha mora")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

