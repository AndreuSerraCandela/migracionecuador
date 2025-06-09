page 76323 Materias
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING ("Tipo registro", Codigo)
                      WHERE ("Tipo registro" = CONST (Materia));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
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

