page 76298 "Lista Lin. Cuest. Evaluacion"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'Profile Questn. Line List';
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "Lin. Cuestionario Evaluacion";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Line No."; rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the profile questionnaire line. This field is used internally by the program.';
                }
                field(Question; rec.Question)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Question';
                    ToolTip = 'Specifies the question in the profile questionnaire.';
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Answer';
                    ToolTip = 'Specifies the profile question or answer.';
                }
                field("From Value"; rec."From Value")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the value from which the automatic classification of your contacts starts.';
                    Visible = false;
                }
                field("To Value"; rec."To Value")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the value that the automatic classification of your contacts stops at.';
                    Visible = false;
                }
                field("No. of Employee"; rec."No. of Employee")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of contacts that have given this answer.';
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

