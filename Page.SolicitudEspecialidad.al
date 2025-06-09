page 76396 "Solicitud - Especialidad"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Solicitud -  Especialidad Asi.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Especialidad"; rec."Cod. Especialidad")
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

