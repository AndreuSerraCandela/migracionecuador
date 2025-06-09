page 56006 "Cont. Caja Registrada"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Contenido Cajas Packing Reg.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Producto"; rec."No. Producto")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Cod. Barras"; rec."Cod. Barras")
                {
                }
                field("Cod. Unidad de Medida"; rec."Cod. Unidad de Medida")
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("No. Picking"; rec."No. Picking")
                {
                }
                field("No. Linea Picking"; rec."No. Linea Picking")
                {
                }
            }
        }
    }

    actions
    {
    }
}

