page 76057 "Ret. Documentos Registrados"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Retencion Doc. Reg. Prov.";

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
                field("Retencion ITBIS"; rec."Retencion ITBIS")
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
            }
        }
    }

    actions
    {
    }
}

