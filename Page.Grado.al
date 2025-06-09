page 56072 Grado
{
    ApplicationArea = all;

    Caption = 'Grade';
    PageType = List;
    SourceTable = "Grado.";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Grado"; rec."Cod. Grado")
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

