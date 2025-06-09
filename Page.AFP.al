page 76085 AFP
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = AFP;

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

