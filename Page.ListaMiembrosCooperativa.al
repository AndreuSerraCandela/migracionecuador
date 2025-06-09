page 76300 "Lista Miembros Cooperativa"
{
    ApplicationArea = all;
    Caption = 'Cooperative member list';
    CardPageID = "Ficha Miembros Coop.";
    Editable = false;
    PageType = List;
    SourceTable = "Miembros cooperativa";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo de miembro"; rec."Tipo de miembro")
                {
                }
                field("Employee No."; rec."Employee No.")
                {
                }
                field("Full name"; rec."Full name")
                {
                }
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                }
                field("Tipo de aporte"; rec."Tipo de aporte")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Ahorro acumulado"; rec."Ahorro acumulado")
                {
                }
                field("Prestamos pendientes"; rec."Prestamos pendientes")
                {
                }
                field("Importe pendiente"; rec."Importe pendiente")
                {
                }
                field(Status; rec.Status)
                {
                }
            }
        }
        area(factboxes)
        {
            /*          chartpart("Q9150-01"; "Q9150-01")
                     {
                     } */
        }
    }

    actions
    {
    }
}

