page 55027 "Histórico Retenciones Clientes"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Histórico Retenciones Clientes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field("Cód. Cliente"; rec."Cód. Cliente")
                {
                }
                field("Nombre Cliente"; rec."Nombre Cliente")
                {
                }
                field("Tipo Retención"; rec."Tipo Retención")
                {
                }
                field("Tipo Documento"; rec."Tipo Documento")
                {
                }
                field("No. documento"; rec."No. documento")
                {
                }
                field("Establecimiento Factura"; rec."Establecimiento Factura")
                {
                }
                field("Punto de Emision Factura"; rec."Punto de Emision Factura")
                {
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
                {
                }
                field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
                {
                }
                field("Importe Retenido"; rec."Importe Retenido")
                {
                }
            }
        }
    }

    actions
    {
    }
}

