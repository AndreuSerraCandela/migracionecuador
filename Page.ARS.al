page 76099 ARS
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = ARS;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; rec.Code)
                {
                }
                field(Description; rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

