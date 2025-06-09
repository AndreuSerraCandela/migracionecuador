page 76296 "Lista Hist. Prest. Cooperativa"
{
    ApplicationArea = all;
    Caption = 'Posted Cooperative Loans List';
    CardPageID = "Cab. Hist. prest. cooperativa";
    Editable = false;
    PageType = List;
    SourceTable = "Hist. Cab. Prest. cooperativa";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Prestamo"; rec."No. Prestamo")
                {
                }
                field("Employee No."; rec."Employee No.")
                {
                }
                field("Tipo de miembro"; rec."Tipo de miembro")
                {
                }
                field("Tipo prestamo"; rec."Tipo prestamo")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("% Interes"; rec."% Interes")
                {
                }
                field("Cantidad de Cuotas"; rec."Cantidad de Cuotas")
                {
                }
                field("Fecha Inicio Deduccion"; rec."Fecha Inicio Deduccion")
                {
                }
                field("Motivo Prestamo"; rec."Motivo Prestamo")
                {
                }
                field("Full name"; rec."Full name")
                {
                }
                field("Concepto Salarial"; rec."Concepto Salarial")
                {
                }
                field("Importe Pendiente"; rec."Importe Pendiente")
                {
                }
                field("Motivo de cierre"; rec."Motivo de cierre")
                {
                }
            }
        }
    }

    actions
    {
    }
}

