page 55009 "Cedula/RUC"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Cedulas/RUC";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cedula/Ruc"; rec."Cedula/Ruc")
                {
                }
                field(Nombre; rec.Nombre)
                {
                }
                field(Direccion; rec.Direccion)
                {
                }
                field(Telefono; rec.Telefono)
                {
                }
            }
        }
    }

    actions
    {
    }
}

