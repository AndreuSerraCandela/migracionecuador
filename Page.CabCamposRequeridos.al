page 76115 "Cab. Campos Requeridos"
{
    ApplicationArea = all;
    PageType = Document;
    SourceTable = "Cab. Campos Requeridos";

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
            part(Control1000000004; "Lin. Campos Requeridos")
            {
                SubPageLink = "No. Tabla" = FIELD ("No. Tabla");
                SubPageView = SORTING ("No. Tabla", "No. Campo")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
    }
}

