page 76051 "Solicitud de etiquetas"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Solicitud de etiquetas";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID Reporte"; rec."ID Reporte")
                {
                }
                field("Nombre reporte"; rec."Nombre reporte")
                {
                }
                field(Confirmada; rec.Confirmada)
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("Cod. barra"; rec."Cod. barra")
                {
                }
                field("No. producto"; rec."No. producto")
                {
                }
                field("Descripcion producto"; rec."Descripcion producto")
                {
                }
                field("Fecha solicitud"; rec."Fecha solicitud")
                {
                }
                label(g)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Ejecutar impresión")
            {
                Caption = 'Ejecutar impresión';
            }
        }
    }

    var
    /*     rObject: Record "Object";

 */
}

