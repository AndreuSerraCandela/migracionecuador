page 76274 "Lista Campos Requeridos"
{
    ApplicationArea = all;

    CardPageID = "Cab. Campos Requeridos";
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Campos Requeridos";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Tabla"; rec."No. Tabla")
                {
                }
                field(Nombre; rec.Nombre)
                {
                }
                field(Activo; rec.Activo)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

