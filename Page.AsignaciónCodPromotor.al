page 76100 "Asignación Cod. Promotor"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "User Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; rec."User ID")
                {
                    Editable = false;
                }
                field("Salespers./Purch. Code"; rec."Salespers./Purch. Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

