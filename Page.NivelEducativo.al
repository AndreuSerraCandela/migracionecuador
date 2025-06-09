page 56031 "Nivel Educativo"
{
    ApplicationArea = all;

    Caption = 'Education level';
    PageType = List;
    SourceTable = "Nivel Educativo";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Código"; rec.Código)
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
            }
        }
    }

    actions
    {
    }
}

