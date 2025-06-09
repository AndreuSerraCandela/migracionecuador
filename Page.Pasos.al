page 76341 Pasos
{
    ApplicationArea = all;
    Caption = 'Steps';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING ("Tipo registro", Codigo)
                      WHERE ("Tipo registro" = CONST (Paso));

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

