page 55016 "Envios de Transferencias"
{
    ApplicationArea = all;
    // 001 RRT #2080, 17.02.2014 - Creación del objeto.

    Editable = false;
    PageType = List;
    SourceTable = "Transfer Shipment Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Shipment date"; rec."Shipment Date")
                {
                }
                field("Nombre Almacen Desde"; rec."Nombre Almacen Desde")
                {
                    Caption = 'From Location Code';
                }
                field("Nombre Almacen Hasta"; rec."Nombre Almacen Hasta")
                {
                    Caption = 'To Location Name';
                }
                field("Document No."; rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field("Transfer Order No."; rec."Transfer Order No.")
                {
                    Caption = 'Transfer Order No.';
                }
                field("Item No."; rec."Item No.")
                {
                }
                field(Description; rec.Description)
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
            }
        }
    }

    actions
    {
    }
}

