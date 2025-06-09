page 76180 "Documentos operac. comerciales"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Datos auxiliares";
    SourceTableView = WHERE ("Tipo registro" = CONST (Documentos));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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

