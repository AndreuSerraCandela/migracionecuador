page 56016 "Lin. Hoja de Ruta Reg."
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Lin. Hoja de Ruta Reg.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Conduce"; rec."No. Conduce")
                {
                }
                field("Cod. Cliente"; rec."Cod. Cliente")
                {
                }
                field("Ship-to City"; rec."Ship-to City")
                {
                }
                field("Nombre Cliente"; rec."Nombre Cliente")
                {
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
                    Visible = false;
                }
                field("Unidad Medida"; rec."Unidad Medida")
                {
                }
                field(Valor; rec.Valor)
                {
                    Visible = false;
                }
                field("No. Guia"; rec."No. Guia")
                {
                    Visible = false;
                }
                field(Comentarios; rec.Comentarios)
                {
                }
                field("Fecha Entrega Requerida"; rec."Fecha Entrega Requerida")
                {
                    Visible = false;
                }
                field("Condiciones de Envio"; rec."Condiciones de Envio")
                {
                    Visible = false;
                }
                field("No. Pedido"; rec."No. Pedido")
                {
                }
                field("Fecha Pedido"; rec."Fecha Pedido")
                {
                    Visible = false;
                }
                field("No entregado"; rec."No entregado")
                {
                }
                field("Comprobante Fiscal"; rec."Comprobante Fiscal")
                {
                }
                field("Numero Guia"; rec."Numero Guia")
                {
                    Editable = false;
                }
                field("Nombre Guia"; rec."Nombre Guia")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

