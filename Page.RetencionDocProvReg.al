page 76378 "Retencion Doc. Prov. Reg."
{
    ApplicationArea = all;
    Editable = false;
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
                field(Redondeo; rec.Redondeo)
                {
                }
                field("Importe Retenido"; rec."Importe Retenido")
                {
                }
                field(NCF; rec.NCF)
                {
                }
                field("No. Documento Mov. Proveedor"; rec."No. Documento Mov. Proveedor")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

