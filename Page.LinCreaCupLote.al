page 56070 "Lin. Crea Cup. Lote"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Crear Cupon por Lote.";

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
                field("Precio Venta"; rec."Precio Venta")
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("% Descuento Padre"; rec."% Descuento Padre")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec."% Descuento Padre" := xRec."% Descuento Padre";
        rec."% Descuento Colegio" := xRec."% Descuento Colegio";
        rec.Cantidad := xRec.Cantidad;
        rec."Cod. Colegio" := xRec."Cod. Colegio";
        rec."Cod. Nivel" := xRec."Cod. Nivel";
        rec."Cod. Promotor" := xRec."Cod. Promotor";
        rec.Turno := xRec.Turno;
        rec.Campaña := xRec.Campaña;
    end;
}

