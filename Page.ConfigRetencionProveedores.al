page 76042 "Config. Retencion Proveedores"
{
    ApplicationArea = all;

    PageType = List;
    SourceTable = "Config. Retencion Proveedores";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Código Retención"; rec."Código Retención")
                {
                }
                field("Descripción"; rec.Descripción)
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
                field("Retencion Defecto Sub-Cont."; rec."Retencion Defecto Sub-Cont.")
                {
                }
                field("Tipo retencion ISR"; rec."Tipo retencion ISR")
                {
                }
                field("Tipo Contribuyente"; rec."Tipo Contribuyente")
                {
                }
            }
        }
    }

    actions
    {
    }
}

