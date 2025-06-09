page 76384 "Seguim.Visita Asesor/Consultor"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Seguim.Visita Asesor/Consultor";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Cambio"; rec."No. Cambio")
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field(Fecha; rec.Fecha)
                {
                }
                field(Usuario; rec.Usuario)
                {
                }
                field(Hora; rec.Hora)
                {
                }
            }
        }
    }

    actions
    {
    }
}

