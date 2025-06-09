page 76053 "Pagos Electronicos"
{
    ApplicationArea = all;
    Caption = 'Electronic Payment Income Distribution';
    PageType = List;
    SourceTable = "Distrib. Ingreso Pagos Elect.";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No. empleado"; rec."No. empleado")
                {
                    Visible = false;
                }
                field("Cod. Banco"; rec."Cod. Banco")
                {
                }
                field("Tipo Cuenta"; rec."Tipo Cuenta")
                {
                }
                field("Numero Cuenta"; rec."Numero Cuenta")
                {
                }
                field("Nro. tarjeta"; rec."Nro. tarjeta")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Fecha vencimiento"; rec."Fecha vencimiento")
                {
                }
                field("Tipo Importe"; rec."Tipo Importe")
                {
                }
            }
        }
    }

    actions
    {
    }
}

