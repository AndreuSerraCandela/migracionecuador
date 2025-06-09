page 76036 Incentivos
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Incentivos/Propinas";

    layout
    {
        area(content)
        {
            repeater(Control1100000)
            {
                ShowCaption = false;
                field("Concepto Salarial"; rec."Concepto Salarial")
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Fecha de Corte"; rec."Fecha de Corte")
                {
                }
                field("Monto a Distribuir"; rec."Monto a Distribuir")
                {
                }
                field("Fecha Ult. Corte"; rec."Fecha Ult. Corte")
                {
                }
            }
        }
    }

    actions
    {
    }
}

