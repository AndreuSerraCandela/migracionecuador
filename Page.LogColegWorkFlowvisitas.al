page 76318 "Log Coleg. - Work Flow visitas"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Log Coleg. - Work Flow visitas";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Fecha; rec.Fecha)
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field(Secuencia; rec.Secuencia)
                {
                }
                field(Resultado; rec.Resultado)
                {
                }
                field(Programado; rec.Programado)
                {
                }
                field(Paso; rec.Paso)
                {
                }
                field(Detalle; rec.Detalle)
                {
                }
                field(Mantenimiento; rec.Mantenimiento)
                {
                }
                field(Conquista; rec.Conquista)
                {
                }
                field("Area"; rec.Area)
                {
                }
            }
        }
    }

    actions
    {
    }
}

