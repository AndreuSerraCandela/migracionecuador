page 76354 "Preguntas Cuest. Evaluacion"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'Employee Profile Answers';
    DataCaptionExpression = CaptionStr;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "Lin. Cuestionario Evaluacion";

    layout
    {
        area(content)
        {
            field(CurrentQuestionsChecklistCode; CurrentQuestionsChecklistCode)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Profile Questionnaire Code';
                ToolTip = 'Specifies the profile questionnaire.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ProfileManagement.LookupName(CurrentQuestionsChecklistCode, Rec, Emp);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ProfileManagement.CheckName(CurrentQuestionsChecklistCode, Emp);
                    CurrentQuestionsChecklistCodeO;
                end;
            }
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                ShowCaption = false;
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies whether the entry is a question or an answer.';
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the profile question or answer.';
                }
                field("No. of Employee"; rec."No. of Employee")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of contacts that have given this answer.';
                    Visible = false;
                }
                field(Set; Set)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Set';
                    ToolTip = 'Specifies the answer to the question.';

                    trigger OnValidate()
                    begin
                        UpdateProfileAnswer;
                    end;
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

    trigger OnAfterGetRecord()
    begin
        Set := EmpProfileAnswer.Get(Emp."No.", rec."Profile Questionnaire Code", rec."Line No.");

        StyleIsStrong := rec.Type = rec.Type::Question;
        if rec.Type <> rec.Type::Question then
            DescriptionIndent := 1
        else
            DescriptionIndent := 0;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        ProfileQuestionnaireLine2.Copy(Rec);

        if not ProfileQuestionnaireLine2.Find(Which) then
            exit(false);

        ProfileQuestLineQuestion := ProfileQuestionnaireLine2;
        if ProfileQuestionnaireLine2.Type = rec.Type::Answer then
            ProfileQuestLineQuestion.Get(ProfileQuestionnaireLine2."Profile Questionnaire Code", ProfileQuestLineQuestion.FindQuestionLine);

        OK := true;
        if ProfileQuestLineQuestion."Auto Employee Classification" then begin
            OK := false;
            repeat
                if Which = '+' then
                    GoNext := ProfileQuestionnaireLine2.Next(-1) <> 0
                else
                    GoNext := ProfileQuestionnaireLine2.Next(1) <> 0;
                if GoNext then begin
                    ProfileQuestLineQuestion := ProfileQuestionnaireLine2;
                    if ProfileQuestionnaireLine2.Type = rec.Type::Answer then
                        ProfileQuestLineQuestion.Get(
                          ProfileQuestionnaireLine2."Profile Questionnaire Code", ProfileQuestLineQuestion.FindQuestionLine);
                    OK := not ProfileQuestLineQuestion."Auto Employee Classification";
                end;
            until (not GoNext) or OK;
        end;

        if not OK then
            exit(false);

        Rec := ProfileQuestionnaireLine2;
        exit(true);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ActualSteps: Integer;
        Step: Integer;
        NoOneFound: Boolean;
    begin
        ProfileQuestionnaireLine2.Copy(Rec);

        if Steps > 0 then
            Step := 1
        else
            Step := -1;

        repeat
            if ProfileQuestionnaireLine2.Next(Step) <> 0 then begin
                if ProfileQuestionnaireLine2.Type = rec.Type::Answer then
                    ProfileQuestLineQuestion.Get(
                      ProfileQuestionnaireLine2."Profile Questionnaire Code", ProfileQuestionnaireLine2.FindQuestionLine);
                if ((not ProfileQuestLineQuestion."Auto Employee Classification") and
                    (ProfileQuestionnaireLine2.Type = rec.Type::Answer)) or
                   ((ProfileQuestionnaireLine2.Type = rec.Type::Question) and (not ProfileQuestionnaireLine2."Auto Employee Classification"))
                then begin
                    ActualSteps := ActualSteps + Step;
                    if Steps <> 0 then
                        Rec := ProfileQuestionnaireLine2;
                end;
            end else
                NoOneFound := true
        until (ActualSteps = Steps) or NoOneFound;

        exit(ActualSteps);
    end;

    trigger OnOpenPage()
    begin
        if EmpProfileAnswerCode = '' then
            CurrentQuestionsChecklistCode :=
              ProfileManagement.ProfileQuestionnaireAllowed(Emp, CurrentQuestionsChecklistCode)
        else
            CurrentQuestionsChecklistCode := EmpProfileAnswerCode;

        ProfileManagement.SetName(CurrentQuestionsChecklistCode, Rec, EmpProfileAnswerLine);

        /*
        IF (Emp."Company No." <> '') AND (Emp."No." <> Emp."Company No.") THEN BEGIN
          CaptionStr := COPYSTR(Emp."Company No." + ' ' + Emp."Company Name",1,MAXSTRLEN(CaptionStr));
          CaptionStr := COPYSTR(CaptionStr + ' ' + Emp."No." + ' ' + Emp.Name,1,MAXSTRLEN(CaptionStr));
        END ELSE
        */
        CaptionStr := CopyStr(Emp."No." + ' ' + Emp."Full Name", 1, MaxStrLen(CaptionStr));

    end;

    var
        Emp: Record Employee;
        EmpProfileAnswer: Record "Employee Profile Answer";
        ProfileQuestionnaireLine2: Record "Lin. Cuestionario Evaluacion";
        ProfileQuestLineQuestion: Record "Lin. Cuestionario Evaluacion";
        ProfileManagement: Codeunit "Profile Management Eval. Des.";
        CurrentQuestionsChecklistCode: Code[20];
        EmpProfileAnswerCode: Code[20];
        EmpProfileAnswerLine: Integer;
        Set: Boolean;
        GoNext: Boolean;
        OK: Boolean;
        CaptionStr: Text[260];
        RunFormCode: Boolean;

        StyleIsStrong: Boolean;
        DescriptionIndent: Integer;

    procedure SetParameters(var SetEmp: Record Employee; SetProfileQuestionnaireCode: Code[20]; SetEmpProfileAnswerCode: Code[20]; SetEmpProfileAnswerLine: Integer)
    begin
        Emp := SetEmp;
        CurrentQuestionsChecklistCode := SetProfileQuestionnaireCode;
        EmpProfileAnswerCode := SetEmpProfileAnswerCode;
        EmpProfileAnswerLine := SetEmpProfileAnswerLine;
    end;

    procedure UpdateProfileAnswer()
    begin
        if not RunFormCode and Set then
            rec.TestField(Type, rec.Type::Answer);

        if Set then begin
            EmpProfileAnswer.Init;
            EmpProfileAnswer."Employee No." := Emp."No.";
            //EmpProfileAnswer."Employee Company No." := Emp."Company No.";
            EmpProfileAnswer.Validate("Profile Questionnaire Code", CurrentQuestionsChecklistCode);
            EmpProfileAnswer.Validate("Line No.", rec."Line No.");
            EmpProfileAnswer."Last Date Updated" := Today;
            EmpProfileAnswer.Insert(true);
        end else
            if EmpProfileAnswer.Get(Emp."No.", CurrentQuestionsChecklistCode, rec."Line No.") then
                EmpProfileAnswer.Delete(true);
    end;

    procedure SetRunFromForm(var ProfileQuestionnaireLine: Record "Lin. Cuestionario Evaluacion"; EmpFrom: Record Employee; CurrQuestionsChecklistCodeFrom: Code[20])
    begin
        Set := true;
        RunFormCode := true;
        Emp := EmpFrom;
        CurrentQuestionsChecklistCode := CurrQuestionsChecklistCodeFrom;
        Rec := ProfileQuestionnaireLine;
    end;

    local procedure CurrentQuestionsChecklistCodeO()
    begin
        CurrPage.SaveRecord;
        ProfileManagement.SetName(CurrentQuestionsChecklistCode, Rec, 0);
        CurrPage.Update(false);
    end;
}

