page 76168 "Detalle Atenciones"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Detalle Atenciones";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Tipo; rec.Tipo)
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("Precio Unitario"; rec."Precio Unitario")
                {
                }
                field("Monto total"; rec."Monto total")
                {
                }
            }
        }
    }

    actions
    {
    }
}

