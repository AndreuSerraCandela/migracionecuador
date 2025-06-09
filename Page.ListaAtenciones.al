page 76270 "Lista Atenciones"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Datos auxiliares";
    SourceTableView = WHERE ("Tipo registro" = CONST (Atenciones));

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
                field("Costo Unitario"; rec."Costo Unitario")
                {
                }
            }
        }
    }

    actions
    {
    }
}

