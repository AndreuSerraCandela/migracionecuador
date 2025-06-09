page 76125 Campos
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Field";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field("Field Caption"; rec."Field Caption")
                {
                }
            }
        }
    }

    actions
    {
    }
}

