page 56018 "Inventario Disponible"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Inventario Disp. Movil.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Producto"; rec."Cod. Producto")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Cod. Almancen"; rec."Cod. Almancen")
                {
                }
                field(Inventario; rec.Inventario)
                {
                }
                field("Fecha Ult. Actualizacion"; rec."Fecha Ult. Actualizacion")
                {
                }
                field("Linea de Negocio"; rec."Linea de Negocio")
                {
                }
                field("Cod. Categoria Producto"; rec."Cod. Categoria Producto")
                {
                }
                field("Nombre Categoria Producto"; rec."Nombre Categoria Producto")
                {
                }
            }
        }
    }

    actions
    {
    }
}

