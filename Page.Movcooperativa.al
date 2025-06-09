page 76326 "Mov. cooperativa"
{
    ApplicationArea = all;
    Caption = 'Cooperative entries';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Mov. cooperativa";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Movimiento"; rec."No. Movimiento")
                {
                }
                field("Tipo miembro"; rec."Tipo miembro")
                {
                }
                field("Employee No."; rec."Employee No.")
                {
                }
                field("Fecha registro"; rec."Fecha registro")
                {
                }
                field("No. documento"; rec."No. documento")
                {
                }
                field("Tipo transaccion"; rec."Tipo transaccion")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Full name"; rec."Full name")
                {
                }
                field("Concepto salarial"; rec."Concepto salarial")
                {
                }
            }
        }
    }

    actions
    {
    }
}

