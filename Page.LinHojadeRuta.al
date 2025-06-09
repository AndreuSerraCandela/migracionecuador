page 56010 "Lin. Hoja de Ruta"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Lin. Hoja de Ruta";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo Envio"; rec."Tipo Envio")
                {
                }
                field("No. Conduce"; rec."No. Conduce")
                {
                }
                field("Ship-to City"; rec."Ship-to City")
                {
                }
                field("Cod. Cliente"; rec."Cod. Cliente")
                {
                }
                field("Nombre Cliente"; rec."Nombre Cliente")
                {
                }
                field("Direccion de Envio"; rec."Direccion de Envio")
                {
                    Caption = 'Dirección de Envio';
                }
                field("Horario Entrega"; rec."Horario Entrega")
                {
                }
                field("Entrega En"; rec."Entrega En")
                {
                }
                field("Cantidad de Bultos"; rec."Cantidad de Bultos")
                {
                }
                field(Peso; rec.Peso)
                {
                }
                field("Unidad Medida"; rec."Unidad Medida")
                {
                }
                field(Valor; rec.Valor)
                {
                }
                field("No. Guia"; rec."No. Guia")
                {
                }
                field(Comentarios; rec.Comentarios)
                {
                }
                field("Fecha Entrega Requerida"; rec."Fecha Entrega Requerida")
                {
                }
                field("Condiciones de Envio"; rec."Condiciones de Envio")
                {
                }
                field("No. Pedido"; rec."No. Pedido")
                {
                }
                field("Fecha Pedido"; rec."Fecha Pedido")
                {
                }
                field("Comprobante Fiscal"; rec."Comprobante Fiscal")
                {
                    Caption = 'Comprobante Fiscal';
                    DrillDown = false;
                    Editable = true;
                    TableRelation = IF ("Tipo Envio" = CONST ("Pedido Venta")) "Sales Shipment Header"."No. Comprobante Fiscal Factura"
                    ELSE
                    IF ("Tipo Envio" = CONST (Transferencia)) "Transfer Shipment Header"."No. Comprobante Fiscal";
                }
                field(Alias; rec.Alias)
                {
                    Caption = 'Alias';
                }
                field("Numero Guia"; rec."Numero Guia")
                {
                    Editable = true;
                }
                field("Nombre Guia"; rec."Nombre Guia")
                {
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }
}

