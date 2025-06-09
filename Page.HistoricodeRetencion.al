page 76056 "Historico de Retencion"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Historico Retencion Prov.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cód. Proveedor"; rec."Cód. Proveedor")
                {
                }
                field("Código Retención"; rec."Código Retención")
                {
                }
                field("Cta. Contable"; rec."Cta. Contable")
                {
                }
                field("Base Cálculo"; rec."Base Cálculo")
                {
                }
                field(Devengo; rec.Devengo)
                {
                }
                field("Importe Retención"; rec."Importe Retención")
                {
                }
                field("Tipo Retención"; rec."Tipo Retención")
                {
                }
                field("Aplica Productos"; rec."Aplica Productos")
                {
                }
                field("Aplica Servicios"; rec."Aplica Servicios")
                {
                }
                field("Retencion IVA"; rec."Retencion IVA")
                {
                }
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field("No. documento"; rec."No. documento")
                {
                }
                field("Importe Retenido"; rec."Importe Retenido")
                {
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field(NCF; rec.NCF)
                {
                }
                field("No. Documento Mov. Proveedor"; rec."No. Documento Mov. Proveedor")
                {
                }
                field(Redondeo; rec.Redondeo)
                {
                }
                field("Cod. Divisa"; rec."Cod. Divisa")
                {
                }
                field("Importe Retenido DL"; rec."Importe Retenido DL")
                {
                }
                field("Importe Base Retencion"; rec."Importe Base Retencion")
                {
                }
                field(Anulada; rec.Anulada)
                {
                }
                field("Fecha Impresion"; rec."Fecha Impresion")
                {
                }
                field("No. autorizacion NCF"; rec."No. autorizacion NCF")
                {
                }
            }
        }
    }

    actions
    {
    }
}

