page 76035 "Subform Hist. Préstamo"
{
    ApplicationArea = all;
    DelayedInsert = true;
    Editable = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Histórico Lín. Préstamo";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Tipo CxC"; rec."Tipo CxC")
                {
                }
                field("No. Préstamo"; rec."No. Préstamo")
                {
                    Visible = false;
                }
                field("Código Empleado"; rec."Código Empleado")
                {
                }
                field("No. Cuota"; rec."No. Cuota")
                {
                }
                field("Fecha Transacción"; rec."Fecha Transacción")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Débito"; rec.Débito)
                {
                }
                field("Crédito"; rec.Crédito)
                {
                }
            }
        }
    }

    actions
    {
    }
}

