page 76233 "Grupos de Negocio"
{
    ApplicationArea = all;

    Caption = 'Business groups';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = WHERE("Tipo registro" = CONST("Grupo de Negocio"));
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

