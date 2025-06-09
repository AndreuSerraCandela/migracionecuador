page 76004 "Lista Pagos TPV"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Pagos TPV";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Fecha; rec.Fecha)
                {
                }
                field(Tienda; rec.Tienda)
                {
                }
                field(TPV; rec.TPV)
                {
                }
                field(Cajero; rec.Cajero)
                {
                }
                field("Forma pago TPV"; rec."Forma pago TPV")
                {
                }
                field("No. Borrador"; rec."No. Borrador")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("No. Factura"; rec."No. Factura")
                {
                }
                field("No. Nota Credito"; rec."No. Nota Credito")
                {
                }
                field(Hora; rec.Hora)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var

    begin


    end;
}

