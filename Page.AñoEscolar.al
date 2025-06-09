page 56071 "Año Escolar"
{
    ApplicationArea = all;

    Caption = 'School year';
    PageType = List;
    SourceTable = "Año Escolar.";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Ano"; rec."Cod. Ano")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Fecha Desde"; rec."Fecha Desde")
                {
                }
                field("Fecha Hasta"; rec."Fecha Hasta")
                {
                }
            }
        }
    }

    actions
    {
    }
}

