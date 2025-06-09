page 76278 "Lista Cuestionario Evaluacion"
{
    ApplicationArea = all;
    Caption = 'Profile Questionnaire List';
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Cuestionario Evaluacion";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the profile questionnaire.';
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the profile questionnaire.';
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

