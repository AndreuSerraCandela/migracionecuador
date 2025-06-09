page 76389 "Seleccion Tipo Eventos"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    SourceTable = "Tipos de Eventos";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Seleccionar; rec.Seleccionar)
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }
}

