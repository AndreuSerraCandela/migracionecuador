page 76108 "Asociacion Educativa"
{
    ApplicationArea = all;

    Caption = 'Educational association';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = WHERE("Tipo registro" = CONST("Asociacion educativa"));
    UsageCategory = Administration;

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

