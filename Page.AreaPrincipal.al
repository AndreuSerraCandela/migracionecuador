page 76095 "Area Principal"
{
    ApplicationArea = all;
    Caption = 'Main area';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING ("Tipo registro", Codigo)
                      WHERE ("Tipo registro" = CONST ("Area principal"));

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

