page 76306 "Lista prestamos cooperativa"
{
    ApplicationArea = all;
    Caption = 'Cooperative loans list';
    CardPageID = "Cab. prestamos cooperativa";
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Prestamos cooperativa";

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
                field("No. afiliado"; rec."No. afiliado")
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
                field("1ra Quincena"; rec."1ra Quincena")
                {
                }
                field("2da Quincena"; rec."2da Quincena")
                {
                }
                field("Motivo Prestamo"; rec."Motivo Prestamo")
                {
                }
                field("Full name"; rec."Full name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

