page 76079 "Retencion Doc. Proveedores"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Retencion Doc. Proveedores";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Código Retención"; rec."Código Retención")
                {
                    NotBlank = true;
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
            }
        }
    }

    actions
    {
    }
}

