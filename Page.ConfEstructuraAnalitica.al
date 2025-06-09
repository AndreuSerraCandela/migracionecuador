page 75009 "Conf. Estructura Analitica"
{
    ApplicationArea = all;
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'Analytical Structure Setup';
    PageType = List;
    SourceTable = "Conf. Estructura Analitica";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; rec.Id)
                {
                    Visible = false;
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Nivel; rec.Nivel)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Id Field"; rec."Id Field")
                {
                }
                field(FieldName; rec.FieldName)
                {
                }
                field(Valor; rec.Valor)
                {
                }
            }
        }
    }

    actions
    {
    }
}

