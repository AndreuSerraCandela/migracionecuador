page 76344 "Payroll -Job JNL Template List"
{
    ApplicationArea = all;
    Caption = 'Job Journal Template List';
    Editable = false;
    PageType = List;
    SourceTable = "Payroll - Job Journal Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; rec.Name)
                {
                }
                field(Description; rec.Description)
                {
                }
                field("Test Report ID"; rec."Test Report ID")
                {
                    Visible = false;
                }
                field("Page ID"; rec."Page ID")
                {
                    Visible = false;
                }
                field("Posting Report ID"; rec."Posting Report ID")
                {
                    Visible = false;
                }
                field("Force Posting Report"; rec."Force Posting Report")
                {
                    Visible = false;
                }
                field("Test Report Caption"; rec."Test Report Caption")
                {
                    Visible = false;
                }
                field("Page Caption"; rec."Page Caption")
                {
                    Visible = false;
                }
                field("Posting Report Caption"; rec."Posting Report Caption")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

