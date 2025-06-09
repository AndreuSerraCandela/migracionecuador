page 76156 "Consulta Distrib. Centro Costo"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Dis. Centros Costo";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Código"; rec.Código)
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field(Porcentaje; rec.Porcentaje)
                {
                }
            }
        }
    }

    actions
    {
    }
}

