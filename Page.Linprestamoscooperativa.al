page 76268 "Lin. prestamos cooperativa"
{
    ApplicationArea = all;
    Caption = 'Cooperative loan lines';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Lin. Prestamos cooperativa";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Código Empleado"; rec."Código Empleado")
                {
                    Visible = false;
                }
                field("No. Cuota"; rec."No. Cuota")
                {
                }
                field("Tipo prestamo"; rec."Tipo prestamo")
                {
                    Visible = false;
                }
                field("Fecha Transaccion"; rec."Fecha Transaccion")
                {
                    Visible = false;
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
                field(Capital; rec.Capital)
                {
                }
                field(Saldo; rec.Saldo)
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

