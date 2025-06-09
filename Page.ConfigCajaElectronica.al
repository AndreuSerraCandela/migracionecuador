page 50120 "Config. Caja Electronica"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Config. Caja Electronica";
    SourceTableView = ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Sucursal; rec.Sucursal)
                {
                }
                field("Caja ID"; rec."Caja ID")
                {
                }
                field(Location; rec.Location)
                {
                }
                field(Pais; rec.Pais)
                {
                }
                field(Situacion; rec.Situacion)
                {
                }
                field("Cod. Seguridad"; rec."Cod. Seguridad")
                {
                }
                field("Serie Factura"; rec."Serie Factura")
                {
                }
                field("Serie Nota de credito"; rec."Serie Nota de credito")
                {
                }
                field("Primer Factura"; rec."Primer Factura")
                {
                }
                field("Referencia Factura"; rec."Referencia Factura")
                {
                }
                field("Referencia Nota de credito"; rec."Referencia Nota de credito")
                {
                }
                field("Tienda POS"; rec."Tienda POS")
                {
                }
                field(Emisor; rec.Emisor)
                {
                }
                field(LenRandonSeguridad; rec.LenRandonSeguridad)
                {
                }
                field("Primer Nota de credito"; rec."Primer Nota de credito")
                {
                }
                field("Referencia Sucursal"; rec."Referencia Sucursal")
                {
                }
                field("Cliente Defecto"; rec."Cliente Defecto")
                {
                }
                field("Cliente SIC"; rec."Cliente SIC")
                {
                    Enabled = false;
                }
                field("mac address"; rec."mac address")
                {
                }
                field("Tienda ID"; rec."Tienda ID")
                {
                }
                field(TPV; rec.TPV)
                {
                }
                field("Secuencia electronica"; rec."Secuencia electronica")
                {
                }
                field("Cod. Vendedor"; rec."Cod. Vendedor")
                {
                }
                field("Secuencia electronica CR"; rec."Secuencia electronica CR")
                {
                }
                field("No. Serie Pedido"; rec."No. Serie Pedido")
                {
                }
                field("No. Serie Registro Nota C."; rec."No. Serie Registro Nota C.")
                {
                }
                field("No. Serie Registro Factura Pos"; rec."No. Serie Registro Factura Pos")
                {
                }
                field("No. Serie Nota Credito Pos"; rec."No. Serie Nota Credito Pos")
                {
                }
            }
        }
    }

    actions
    {
    }
}

