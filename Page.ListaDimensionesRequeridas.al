page 76288 "Lista Dimensiones Requeridas"
{
    ApplicationArea = all;

    CardPageID = "Cab. Dimensiones Requeridas";
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Dimensiones Requeridas";
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
                }
            }
        }
    }

    actions
    {
    }
}

