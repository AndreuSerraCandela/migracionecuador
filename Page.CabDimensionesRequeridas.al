page 76116 "Cab. Dimensiones Requeridas"
{
    ApplicationArea = all;
    PageType = Document;
    SourceTable = "Cab. Dimensiones Requeridas";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No. Tabla"; rec."No. Tabla")
                {
                }
                field(Nombre; rec.Nombre)
                {
                }
                field(Activo; rec.Activo)
                {
                }
            }
            part(Control1000000005; "Lin. Dimensiones Requeridas")
            {
                SubPageLink = "No. Tabla" = FIELD ("No. Tabla");
                SubPageView = SORTING ("No. Tabla", "Cod. Dimension")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
    }
}

