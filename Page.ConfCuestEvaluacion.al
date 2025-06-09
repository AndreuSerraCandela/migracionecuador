#pragma implicitwith disable
page 76151 "Conf. Cuest. Evaluacion"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'Profile Questionnaire Setup';
    DataCaptionExpression = CaptionExpr;
    PageType = List;
    SaveValues = true;
    SourceTable = "Lin. Cuestionario Evaluacion";

    layout
    {
        area(content)
        {
            field(ProfileQuestionnaireCodeName; CurrentQuestionsChecklistCode)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Profile Questionnaire Code';
                ToolTip = 'Specifies the profile questionnaire.';
                Visible = ProfileQuestionnaireCodeNameVi;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    Commit;
                    if PAGE.RunModal(0, ProfileQuestnHeader) = ACTION::LookupOK then begin
                        ProfileQuestnHeader.Get(ProfileQuestnHeader.Code);
                        CurrentQuestionsChecklistCode := ProfileQuestnHeader.Code;
                        //001 ProfileManagement.SetName(CurrentQuestionsChecklistCode,Rec,0);
                        CurrPage.Update(false);
                    end;
                end;

                trigger OnValidate()
                begin
                    ProfileQuestnHeader.Get(CurrentQuestionsChecklistCode);
                    CurrentQuestionsChecklistCodeO;
                end;
            }
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies whether the entry is a question or an answer.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the profile question or answer.';
                }
                field("Multiple Answers"; Rec."Multiple Answers")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the question has more than one possible answer.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = RelationshipMgmt;
                    HideValue = PriorityHideValue;
                    ToolTip = 'Specifies the priority you give to the answer and where it should be displayed on the lines of the Contact Card. There are five options:';
                }
                field("Auto Employee Classification"; Rec."Auto Employee Classification")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    ToolTip = 'Specifies that the question is automatically answered when you run the Update Contact Classification batch job.';
                }
                field("From Value"; Rec."From Value")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the value from which the automatic classification of your contacts starts.';
                }
                field("To Value"; Rec."To Value")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the value that the automatic classification of your contacts stops at.';
                }
                field("No. of Employee"; Rec."No. of Employee")
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Question Details")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Question Details';
                    Image = Questionaire;
                    Promoted = true;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View detailed information about the questions within the questionnaire.';

                    trigger OnAction()
                    begin
                        case Rec.Type of
                            Rec.Type::Question:
                                PAGE.RunModal(PAGE::"Preguntas Cuest. Evaluacion", Rec);
                            Rec.Type::Answer:
                                Error(Text000);
                        end;
                    end;
                }
                action("Answer Where-Used")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Answer Where-Used';
                    Image = Trace;
                    ToolTip = 'View which questions the current answer is based on with the number of points given.';

                    trigger OnAction()
                    var
                        Rating: Record Rating;
                    begin
                        case Rec.Type of
                            Rec.Type::Question:
                                Error(Text001);
                            Rec.Type::Answer:
                                begin
                                    Rating.SetRange("Rating Profile Quest. Code", Rec."Profile Questionnaire Code");
                                    Rating.SetRange("Rating Profile Quest. Line No.", Rec."Line No.");
                                    PAGE.RunModal(PAGE::"Answer Where-Used", Rating);
                                end;
                        end;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                separator(Action34)
                {
                }
                action("Update &Classification")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Update &Classification';
                    Image = Refresh;
                    ToolTip = 'Update automatic classification of your contacts. This batch job updates all the answers to the profile questions that are automatically answered by the program, based on customer, vendor or contact data.';

                    trigger OnAction()
                    var
                        ProfileQuestnHeader: Record "Cab. Cuestionario Evaluacion";
                    begin
                        ProfileQuestnHeader.Get(CurrentQuestionsChecklistCode);
                        ProfileQuestnHeader.SetRecFilter;
                        REPORT.Run(REPORT::"Update Employee Classification", true, false, ProfileQuestnHeader);
                    end;
                }
                separator(Action31)
                {
                }
                action("Move &Up")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Move &Up';
                    Image = MoveUp;
                    Promoted = true;
                    Scope = Repeater;
                    ToolTip = 'Change the sorting order of the lines.';

                    trigger OnAction()
                    begin
                        Rec.MoveUp;
                    end;
                }
                action("Move &Down")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Move &Down';
                    Image = MoveDown;
                    Promoted = true;
                    Scope = Repeater;
                    ToolTip = 'Change the sorting order of the lines.';

                    trigger OnAction()
                    begin
                        Rec.MoveDown
                    end;
                }
                separator(Action32)
                {
                    Caption = '', Locked = true;
                }
                action(Print)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Print';
                    Image = Print;
                    ToolTip = 'Print the information in the window. A print request window opens where you can specify what to include on the print-out.';

                    trigger OnAction()
                    var
                        ProfileQuestnHeader: Record "Cab. Cuestionario Evaluacion";
                    begin
                        ProfileQuestnHeader.SetRange(Code, CurrentQuestionsChecklistCode);
                        REPORT.Run(REPORT::"Recibo Nomina sin copia - coop", true, false, ProfileQuestnHeader);
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Test Report';
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    var
                        ProfileQuestnHeader: Record "Cab. Cuestionario Evaluacion";
                    begin
                        ProfileQuestnHeader.SetRange(Code, CurrentQuestionsChecklistCode);
                        REPORT.Run(REPORT::"Nominas por departamentos A4", true, false, ProfileQuestnHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PriorityHideValue := false;
        StyleIsStrong := false;
        DescriptionIndent := 0;

        if Rec.Type = Rec.Type::Question then begin
            StyleIsStrong := true;
            PriorityHideValue := true;
        end else
            DescriptionIndent := 1;
    end;

    trigger OnInit()
    begin
        ProfileQuestionnaireCodeNameVi := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Profile Questionnaire Code" := CurrentQuestionsChecklistCode;
        Rec.Type := Rec.Type::Answer;
    end;

    trigger OnOpenPage()
    var
        ProfileQuestionnaireHeader: Record "Profile Questionnaire Header";
    begin
        if Rec.GetFilter("Profile Questionnaire Code") <> '' then begin
            ProfileQuestionnaireHeader.SetFilter(Code, Rec.GetFilter("Profile Questionnaire Code"));
            if ProfileQuestionnaireHeader.Count = 1 then begin
                ProfileQuestionnaireHeader.FindFirst;
                CurrentQuestionsChecklistCode := ProfileQuestionnaireHeader.Code;
            end;
        end;

        if CurrentQuestionsChecklistCode = '' then
            CurrentQuestionsChecklistCode := ProfileManagement.GetQuestionnaire;

        //001 ProfileManagement.SetName(CurrentQuestionsChecklistCode,Rec,0);

        CaptionExpr := Rec."Profile Questionnaire Code";
        ProfileQuestionnaireCodeNameVi := false;
    end;

    var
        Text000: Label 'Details only available for questions.';
        ProfileQuestnHeader: Record "Cab. Cuestionario Evaluacion";
        ProfileManagement: Codeunit "Func. Cuestionario Evaluacion";
        CurrentQuestionsChecklistCode: Code[20];
        Text001: Label 'Where-Used only available for answers.';
        CaptionExpr: Text[100];
        ProfileQuestionnaireCodeNameVi: Boolean;
        DescriptionIndent: Integer;
        StyleIsStrong: Boolean;
        PriorityHideValue: Boolean;

    local procedure CurrentQuestionsChecklistCodeO()
    begin
        //001 ProfileManagement.SetName(CurrentQuestionsChecklistCode,Rec,0);
    end;
}

#pragma implicitwith restore

