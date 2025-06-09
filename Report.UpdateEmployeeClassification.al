report 76236 "Update Employee Classification"
{
    Caption = 'Update Contact Classification';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cab. Cuestionario Evaluacion"; "Cab. Cuestionario Evaluacion")
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code", Description;
            dataitem("Lin. Cuestionario Evaluacion"; "Lin. Cuestionario Evaluacion")
            {
                DataItemLink = "Profile Questionnaire Code" = FIELD(Code);
                DataItemTableView = SORTING("Profile Questionnaire Code", "Line No.") WHERE(Type = CONST(Question), "Auto Employee Classification" = CONST(true), "Employee Class. Field" = FILTER(<> Rating));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(3, "Line No.");
                    if NoOfQuestions = 0 then
                        NoOfQuestions := Count;
                    QuestionCount := QuestionCount + 1;
                    Window.Update(4, Round(10000 * QuestionCount / NoOfQuestions, 1));
                    RecCount := 0;

                    EmployeeValue.DeleteAll;

                    if (Format("Starting Date Formula") = '') or (Format("Ending Date Formula") = '') then
                        Error(
                          Text005,
                          FieldCaption("Starting Date Formula"),
                          FieldCaption("Ending Date Formula"),
                          "Cab. Cuestionario Evaluacion".Code,
                          Description);

                    if "Classification Method" = "Classification Method"::" " then
                        Error(
                          Text008,
                          FieldCaption("Classification Method"),
                          "Cab. Cuestionario Evaluacion".Code,
                          Description);

                    AnswersExists("Lin. Cuestionario Evaluacion", '', true);
                    TotalValue := 0;

                    //CASE TRUE OF
                    //  "Employee Class. Field" <> "Employee Class. Field"::" ":
                    FindEmployeeValues("Lin. Cuestionario Evaluacion");
                    //END;

                    MarkEmployeeByMethod("Lin. Cuestionario Evaluacion", '');
                end;

                trigger OnPreDataItem()
                begin
                    NoOfQuestions := 0;
                    QuestionCount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, Code);
                if NoOfProfiles = 0 then
                    NoOfProfiles := Count;
                ProfileCount := ProfileCount + 1;
                Window.Update(2, Round(10000 * ProfileCount / NoOfProfiles, 1));
                NoOfQuestions := 0;
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                UpdateRating('');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Date; Date)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Date';
                        ToolTip = 'Specifies the date on which you update the contact classification.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        Date := WorkDate;
    end;

    trigger OnPreReport()
    begin
        Window.Open(
          Text000 +
          Text001 +
          Text002);
    end;

    var
        Text000: Label 'Profile Questionnaire #1######## @2@@@@@@@@@@@@@\\';
        Text001: Label 'Question Line No.     #3######## @4@@@@@@@@@@@@@\';
        Text002: Label 'Finding Values        #5######## @6@@@@@@@@@@@@@\';
        Text003: Label '%1 results in a date before the result of the %2.';
        EmployeeValue: Record "Employee Value" temporary;
        Window: Dialog;
        Date: Date;
        NoOfProfiles: Integer;
        ProfileCount: Integer;
        NoOfQuestions: Integer;
        QuestionCount: Integer;
        NoOfRecs: Integer;
        RecCount: Integer;
        TotalValue: Decimal;
        Text004: Label 'Two or more questions are causing the rating calculation to loop.';
        Text005: Label 'You must specify %1 and %2 in Profile Questionnaire %3, question %4. To find additional errors, run the Test report.', Comment = '%1 = Starting Date Formula;%2 = Ending Date Formula;%3 = Profile Questionaire Code;%4 = Question Description';
        Text008: Label 'You must specify %1 in Profile Questionnaire %2, question %3. To find additional errors, run the Test report.', Comment = '%1 = Sorting Method;%2 = Profile Questionaire Code;%3 = Question Description';

    local procedure AnswersExists(var ProfileQuestionnaireLine: Record "Lin. Cuestionario Evaluacion"; UpdateEmpNo: Code[20]; Delete: Boolean): Boolean
    var
        ContProfileAnswer: Record "Employee Profile Answer";
        ProfileQuestnLine2: Record "Lin. Cuestionario Evaluacion";
    begin
        ContProfileAnswer.SetCurrentKey("Profile Questionnaire Code", "Line No.");
        ContProfileAnswer.SetRange("Profile Questionnaire Code", ProfileQuestionnaireLine."Profile Questionnaire Code");

        ProfileQuestnLine2.Reset;
        ProfileQuestnLine2 := ProfileQuestionnaireLine;
        ProfileQuestnLine2.SetRange(Type, ProfileQuestnLine2.Type::Question);
        ProfileQuestnLine2.SetRange("Profile Questionnaire Code", ProfileQuestionnaireLine."Profile Questionnaire Code");
        if ProfileQuestnLine2.Next <> 0 then
            ContProfileAnswer.SetRange("Line No.", ProfileQuestionnaireLine."Line No.", ProfileQuestnLine2."Line No.")
        else
            ContProfileAnswer.SetFilter("Line No.", '%1..', ProfileQuestionnaireLine."Line No.");
        if UpdateEmpNo <> '' then begin
            ContProfileAnswer.SetRange("Employee No.", UpdateEmpNo);
            ContProfileAnswer.SetCurrentKey("Employee No.", "Profile Questionnaire Code", "Line No.");
        end;

        if Delete then
            ContProfileAnswer.DeleteAll
        else
            exit(not ContProfileAnswer.IsEmpty);
    end;

    local procedure FindEmployeeValues(ProfileQuestionnaireLine: Record "Lin. Cuestionario Evaluacion")
    var
        Emp: Record Employee;
        ContNo: Code[20];
        NoOfYears: Decimal;
        WonCount: Integer;
        LostCount: Integer;
        FromDate: Date;
        ToDate: Date;
    begin
        /*
        NoOfRecs := Emp.COUNT;
        IF Emp.FIND('-') THEN
          REPEAT
            RecCount := RecCount + 1;
            Window.UPDATE(5,Emp."No.");
            Window.UPDATE(6,ROUND(10000 * RecCount / NoOfRecs,1));
            ContNo := EmployeeNo(ProfileQuestionnaireLine,DATABASE::Employee,Emp."No.");
            IF ContNo <> '' THEN BEGIN
              Emp.RESET;
              FromDate := CALCDATE(ProfileQuestionnaireLine."Starting Date Formula",Date);
              ToDate := CALCDATE(ProfileQuestionnaireLine."Ending Date Formula",Date);
              IF ToDate < FromDate THEN
                ProfileQuestionnaireLine.FIELDERROR("Ending Date Formula",
                  STRSUBSTNO(Text003,
                    ProfileQuestionnaireLine.FIELDCAPTION("Ending Date Formula"),
                    ProfileQuestionnaireLine.FIELDCAPTION("Starting Date Formula")));
              Emp.SETRANGE("Date Filter",FromDate,ToDate);
              CASE ProfileQuestionnaireLine."Employee Class. Field" OF
                ProfileQuestionnaireLine."Employee Class. Field"::"Interaction Quantity":
                  BEGIN
                    Emp.CALCFIELDS("No. of Interactions");
                    InsertEmployeeValue(ProfileQuestionnaireLine,Emp."No.",Emp."No. of Interactions",0D,0);
                  END;
                ProfileQuestionnaireLine."Employee Class. Field"::"Interaction Frequency (No./Year)":
                  BEGIN
                    Emp.CALCFIELDS("No. of Interactions");
                    NoOfYears := (ToDate - FromDate + 1) / 365;
                    InsertEmployeeValue(ProfileQuestionnaireLine,Emp."No.",Emp."No. of Interactions" / NoOfYears,0D,0);
                  END;
                ProfileQuestionnaireLine."Employee Class. Field"::"Avg. Interaction Cost (LCY)":
                  BEGIN
                    Emp.CALCFIELDS("No. of Interactions","Cost (LCY)");
                    IF Emp."No. of Interactions" <> 0 THEN
                      InsertEmployeeValue(ProfileQuestionnaireLine,Emp."No.",Emp."Cost (LCY)" / Emp."No. of Interactions",0D,0)
                    ELSE
                      InsertEmployeeValue(ProfileQuestionnaireLine,Emp."No.",0,0D,0);
                  END;
                ProfileQuestionnaireLine."Employee Class. Field"::"Avg. Interaction Duration (Min.)":
                  BEGIN
                    Emp.CALCFIELDS("No. of Interactions","Duration (Min.)");
                    IF Emp."No. of Interactions" <> 0 THEN
                      InsertEmployeeValue(ProfileQuestionnaireLine,Emp."No.",Emp."Duration (Min.)" / Emp."No. of Interactions",0D,0)
                    ELSE
                      InsertEmployeeValue(ProfileQuestionnaireLine,Emp."No.",0,0D,0);
                  END;
                ProfileQuestionnaireLine."Employee Class. Field"::"Opportunity Won (%)":
                  BEGIN
                    Emp.SETRANGE("Action Taken Filter",Emp."Action Taken Filter"::Won);
                    Emp.CALCFIELDS("No. of Opportunities");
                    WonCount := Emp."No. of Opportunities";
                    Emp.SETRANGE("Action Taken Filter",Emp."Action Taken Filter"::Lost);
                    Emp.CALCFIELDS("No. of Opportunities");
                    LostCount := Emp."No. of Opportunities";
                    IF (LostCount + WonCount) <> 0 THEN
                      InsertEmployeeValue(ProfileQuestionnaireLine,Emp."No.",100 * WonCount / (LostCount + WonCount),0D,0)
                    ELSE
                      InsertEmployeeValue(ProfileQuestionnaireLine,Emp."No.",0,0D,0);
                  END;
              END;
            END;
          UNTIL Emp.NEXT = 0
        */

    end;

    local procedure EmployeeNo(ProfileQuestionnaireLine: Record "Lin. Cuestionario Evaluacion"; TableID: Integer; No: Code[20]) EmployeeNo: Code[20]
    var
        Emp: Record Employee;
        ProfileQuestnHeader: Record "Cab. Cuestionario Evaluacion";
    begin
        ProfileQuestnHeader.Get(ProfileQuestionnaireLine."Profile Questionnaire Code");
        if TableID = DATABASE::Employee then
            EmployeeNo := No;
        /*
        ELSE
          WITH ContBusRel DO BEGIN
            RESET;
            SETCURRENTKEY("Link to Table","No.");
            CASE TableID OF
              DATABASE::Customer:
                SETRANGE("Link to Table","Link to Table"::Customer);
              DATABASE::Vendor:
                SETRANGE("Link to Table","Link to Table"::Vendor);
            END;
        
        
            SETRANGE("No.",No);
            IF FINDFIRST THEN
              EmployeeNo := "Employee No."
            ELSE
              EXIT('');
          END;
        */

        Emp.Get(EmployeeNo);
        /*
        IF (ProfileQuestnHeader."Employee Type" = ProfileQuestnHeader."Employee Type"::Companies) AND
           (Emp.Type <> Emp.Type::Company)
        THEN
          EXIT('');
        
        IF ProfileQuestnHeader."Business Relation Code" = '' THEN
        */
        exit(EmployeeNo);
        /*
        ContBusRel.RESET;
        IF TableID = DATABASE::Employee THEN
          ContBusRel.SETRANGE("Employee No.",Emp."Company No.")
        ELSE
          ContBusRel.SETRANGE("Employee No.",EmployeeNo);
        ContBusRel.SETRANGE("Business Relation Code",ProfileQuestnHeader."Business Relation Code");
        IF NOT ContBusRel.ISEMPTY THEN
          EXIT(EmployeeNo);
        EmployeeNo := '';
        */

    end;

    local procedure MarkByDefinedValue(ProfileQuestnLineQuestion: Record "Lin. Cuestionario Evaluacion"; ProfileQuestnLineAnswer: Record "Lin. Cuestionario Evaluacion")
    begin
        EmployeeValue.Reset;
        if EmployeeValue.Find('-') then
            repeat
                if InRange(EmployeeValue.Value, ProfileQuestnLineAnswer."From Value", ProfileQuestnLineAnswer."To Value") then
                    MarkEmployee(
                      ProfileQuestnLineQuestion, ProfileQuestnLineAnswer, EmployeeValue."Employee No.",
                      EmployeeValue."Last Date Updated", EmployeeValue."Questions Answered (%)")
            until EmployeeValue.Next = 0;
    end;

    local procedure MarkByPercentageOfValue(ProfileQuestnLineQuestion: Record "Lin. Cuestionario Evaluacion"; ProfileQuestnLineAnswer: Record "Lin. Cuestionario Evaluacion")
    var
        Prc: Decimal;
    begin
        EmployeeValue.Reset;
        EmployeeValue.SetCurrentKey(Value);

        if ProfileQuestnLineQuestion."Sorting Method" = ProfileQuestnLineQuestion."Sorting Method"::" " then
            Error(
              Text008,
              ProfileQuestnLineQuestion.FieldCaption("Sorting Method"),
              ProfileQuestnLineQuestion."Profile Questionnaire Code",
              ProfileQuestnLineQuestion.Description);

        case ProfileQuestnLineQuestion."Sorting Method" of
            ProfileQuestnLineQuestion."Sorting Method"::Descending:
                EmployeeValue.Ascending(false);
            ProfileQuestnLineQuestion."Sorting Method"::Ascending:
                EmployeeValue.Ascending(true);
        end;

        if EmployeeValue.FindSet then
            repeat
                if TotalValue <> 0 then
                    Prc := Round(100 * EmployeeValue.Value / TotalValue, 1 / Power(10, ProfileQuestnLineQuestion."No. of Decimals"))
                else
                    Prc := 0;
                if InRange(Prc, ProfileQuestnLineAnswer."From Value", ProfileQuestnLineAnswer."To Value") then
                    MarkEmployee(
                      ProfileQuestnLineQuestion, ProfileQuestnLineAnswer, EmployeeValue."Employee No.",
                      EmployeeValue."Last Date Updated", EmployeeValue."Questions Answered (%)");
            until EmployeeValue.Next = 0
    end;

    local procedure MarkByPercentageOfEmployee(ProfileQuestnLineQuestion: Record "Lin. Cuestionario Evaluacion"; ProfileQuestnLineAnswer: Record "Lin. Cuestionario Evaluacion")
    var
        EmployeeValueCount: Integer;
        RecNo: Integer;
        Prc: Decimal;
    begin
        EmployeeValue.Reset;
        EmployeeValue.SetCurrentKey(Value);

        if ProfileQuestnLineQuestion."Sorting Method" = ProfileQuestnLineQuestion."Sorting Method"::" " then
            Error(
              Text008,
              ProfileQuestnLineQuestion.FieldCaption("Sorting Method"),
              ProfileQuestnLineQuestion."Profile Questionnaire Code",
              ProfileQuestnLineQuestion.Description);

        case ProfileQuestnLineQuestion."Sorting Method" of
            ProfileQuestnLineQuestion."Sorting Method"::Descending:
                EmployeeValue.Ascending(false);
            ProfileQuestnLineQuestion."Sorting Method"::Ascending:
                EmployeeValue.Ascending(true);
        end;

        if EmployeeValue.Find('-') then begin
            EmployeeValueCount := EmployeeValue.Count;
            RecNo := 0;
            repeat
                RecNo := RecNo + 1;
                Prc := Round(100 * RecNo / EmployeeValueCount, 1 / Power(10, ProfileQuestnLineQuestion."No. of Decimals"));
                if InRange(Prc, ProfileQuestnLineAnswer."From Value", ProfileQuestnLineAnswer."To Value") then
                    MarkEmployee(
                      ProfileQuestnLineQuestion, ProfileQuestnLineAnswer, EmployeeValue."Employee No.",
                      EmployeeValue."Last Date Updated", EmployeeValue."Questions Answered (%)")
            until EmployeeValue.Next = 0
        end;
    end;

    local procedure InRange(Value: Decimal; FromValue: Decimal; ToValue: Decimal): Boolean
    begin
        if (FromValue <> 0) and (ToValue <> 0) and (Value >= FromValue) and (Value <= ToValue) then
            exit(true);
        if (FromValue <> 0) and (ToValue = 0) and (Value >= FromValue) then
            exit(true);
        if (FromValue = 0) and (ToValue <> 0) and (Value <= ToValue) then
            exit(true);
    end;

    local procedure MarkEmployee(ProfileQuestnLineQuestion: Record "Lin. Cuestionario Evaluacion"; ProfileQuestnLineAnswer: Record "Lin. Cuestionario Evaluacion"; EmpNo: Code[20]; UpdateDate: Date; QuestionsAnsweredPrc: Decimal)
    var
        Emp: Record Employee;
        EmpPers: Record Employee;
        EmpProfileAnswer: Record "Employee Profile Answer";
        ProfileQuestnHeader2: Record "Cab. Cuestionario Evaluacion";
    begin
        ProfileQuestnHeader2.Get(ProfileQuestnLineQuestion."Profile Questionnaire Code");

        Emp.Get(EmpNo);
        /*
        IF (Emp.Type = Emp.Type::Company) AND
           (ProfileQuestnLineQuestion."Employee Class. Field" = ProfileQuestnLineQuestion."Employee Class. Field"::" ") AND
           (ProfileQuestnHeader2."Employee Type" <> ProfileQuestnHeader2."Employee Type"::Companies)
        THEN BEGIN
          ContPers.RESET;
          ContPers.SETCURRENTKEY("Company No.");
          ContPers.SETRANGE("Company No.",Emp."No.");
          ContPers.SETRANGE(Type,Emp.Type::Person);
          IF ContPers.FIND('-') THEN
            REPEAT
              MarkEmployee(ProfileQuestnLineQuestion,ProfileQuestnLineAnswer,ContPers."No.",UpdateDate,QuestionsAnsweredPrc);
            UNTIL ContPers.NEXT = 0
        END;
        
        IF (ProfileQuestnHeader2."Employee Type" = ProfileQuestnHeader2."Employee Type"::People) AND
           (Emp.Type <> Emp.Type::Person)
        THEN
          EXIT;
        IF (ProfileQuestnHeader2."Employee Type" = ProfileQuestnHeader2."Employee Type"::Companies) AND
           (Emp.Type <> Emp.Type::Company)
        THEN
          EXIT;
        */
        EmpProfileAnswer.Init;
        EmpProfileAnswer."Employee No." := Emp."No.";
        EmpProfileAnswer."Profile Questionnaire Code" := ProfileQuestnLineAnswer."Profile Questionnaire Code";
        EmpProfileAnswer."Line No." := ProfileQuestnLineAnswer."Line No.";
        //ContProfileAnswer."Employee Company No." := Emp."Company No.";
        EmpProfileAnswer."Profile Questionnaire Priority" := ProfileQuestnHeader2.Priority;
        EmpProfileAnswer."Answer Priority" := ProfileQuestnLineAnswer.Priority;
        EmpProfileAnswer."Questions Answered (%)" := QuestionsAnsweredPrc;
        if UpdateDate = 0D then
            EmpProfileAnswer."Last Date Updated" := Today
        else
            EmpProfileAnswer."Last Date Updated" := UpdateDate;
        EmpProfileAnswer.Insert;

    end;


    procedure UpdateRating(UpdateEmpNo: Code[20])
    var
        ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion";
        ProfileQuestnLine2: Record "Lin. Cuestionario Evaluacion";
        Rating: Record "Rating Evaluacion";
        RatingQuestion: Record "Rating Evaluacion";
        Emp: Record Employee;
        Leaf: Boolean;
        Changed: Boolean;
        EmpNo: Code[20];
        NoOfRatingLines: Integer;
        RatingLineNo: Integer;
        Points: Integer;
        UpdateDate: Date;
        QuestionsAnsweredPrc: Decimal;
    begin
        // Mark all non-calculated rating questions
        ProfileQuestnLine.Reset;
        ProfileQuestnLine.SetRange("Employee Class. Field", ProfileQuestnLine."Employee Class. Field"::Rating);
        if "Cab. Cuestionario Evaluacion".Code <> '' then
            ProfileQuestnLine.SetRange("Profile Questionnaire Code", "Cab. Cuestionario Evaluacion".Code);
        if not ProfileQuestnLine.Find('-') then
            exit;
        repeat
            ProfileQuestnLine.Mark(true);
            NoOfRatingLines := NoOfRatingLines + 1;
        until ProfileQuestnLine.Next = 0;
        ProfileQuestnLine.MarkedOnly(true);

        // Calculate Ratings
        repeat
            Changed := false;
            if ProfileQuestnLine.Find('-') then
                repeat
                    Leaf := true;
                    Rating.SetRange("Profile Questionnaire Code", ProfileQuestnLine."Profile Questionnaire Code");
                    Rating.SetRange("Profile Questionnaire Line No.", ProfileQuestnLine."Line No.");
                    if Rating.Find('-') then
                        repeat
                            ProfileQuestnLine2.Get(Rating."Rating Profile Quest. Code", Rating."Rating Profile Quest. Line No.");
                            RatingQuestion.SetRange("Profile Questionnaire Code", Rating."Rating Profile Quest. Code");
                            RatingQuestion.SetRange("Profile Questionnaire Line No.", ProfileQuestnLine2.FindQuestionLine);
                            if RatingQuestion.FindFirst then begin
                                ProfileQuestnLine2 := ProfileQuestnLine;
                                ProfileQuestnLine.Get(
                                  RatingQuestion."Profile Questionnaire Code", RatingQuestion."Profile Questionnaire Line No.");
                                if ProfileQuestnLine.Mark then
                                    Leaf := false;
                                ProfileQuestnLine := ProfileQuestnLine2;
                            end;
                        until (Rating.Next = 0) or (not Leaf);

                    // Calculate Rating
                    if Leaf then begin
                        if UpdateEmpNo = '' then begin
                            RatingLineNo := RatingLineNo + 1;
                            Window.Update(1, ProfileQuestnLine."Profile Questionnaire Code");
                            Window.Update(3, ProfileQuestnLine."Line No.");
                            Window.Update(4, Round(10000 * RatingLineNo / NoOfRatingLines, 1));
                            NoOfRecs := Emp.Count;
                            RecCount := 0;
                            TotalValue := 0;
                        end;
                        EmployeeValue.DeleteAll;
                        AnswersExists(ProfileQuestnLine, UpdateEmpNo, true);
                        if UpdateEmpNo <> '' then
                            Emp.SetRange("No.", UpdateEmpNo);
                        if Emp.Find('-') then
                            repeat
                                if UpdateEmpNo = '' then begin
                                    RecCount := RecCount + 1;
                                    Window.Update(5, Emp."No.");
                                    Window.Update(6, Round(10000 * RecCount / NoOfRecs, 1));
                                end;
                                EmpNo := EmployeeNo(ProfileQuestnLine, DATABASE::Employee, Emp."No.");
                                if EmpNo <> '' then begin
                                    Points := FindEmployeeRatingValue(ProfileQuestnLine, Emp, UpdateDate, QuestionsAnsweredPrc);
                                    //GRN  IF QuestionsAnsweredPrc >= ProfileQuestnLine."Min. % Questions Answered" THEN
                                    //GRN    InsertEmployeeValue(ProfileQuestnLine,Emp."No.",Points,UpdateDate,QuestionsAnsweredPrc);
                                end;
                            until Emp.Next = 0;
                        MarkEmployeeByMethod(ProfileQuestnLine, UpdateEmpNo);
                        ProfileQuestnLine.Mark(false);
                        Changed := true;
                    end;
                until ProfileQuestnLine.Next = 0;
        until Changed = false;

        if ProfileQuestnLine.Find('-') then
            Error(Text004);
    end;

    local procedure FindEmployeeRatingValue(ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion"; Emp: Record Employee; var UpdateDate: Date; var QuestionsAnsweredPrc: Decimal) Value: Decimal
    var
        Rating: Record "Rating Evaluacion";
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestionnaireLine: Record "Lin. Cuestionario Evaluacion";
        TempProfileQuestnLine: Record "Lin. Cuestionario Evaluacion" temporary;
        NoOfAnsweredQuestions: Integer;
    begin
        UpdateDate := Today;
        Rating.SetRange("Profile Questionnaire Code", ProfileQuestnLine."Profile Questionnaire Code");
        Rating.SetRange("Profile Questionnaire Line No.", ProfileQuestnLine."Line No.");
        if Rating.Find('-') then
            repeat
                ProfileQuestionnaireLine.Get(Rating."Rating Profile Quest. Code", Rating."Rating Profile Quest. Line No.");
                ProfileQuestionnaireLine.Get(
                  ProfileQuestionnaireLine."Profile Questionnaire Code", ProfileQuestionnaireLine.FindQuestionLine);
                if not TempProfileQuestnLine.Get(
                     ProfileQuestionnaireLine."Profile Questionnaire Code", ProfileQuestionnaireLine."Line No.")
                then begin
                    TempProfileQuestnLine.Init;
                    TempProfileQuestnLine."Profile Questionnaire Code" := ProfileQuestionnaireLine."Profile Questionnaire Code";
                    TempProfileQuestnLine."Line No." := ProfileQuestionnaireLine."Line No.";
                    TempProfileQuestnLine.Insert;
                    if AnswersExists(ProfileQuestionnaireLine, Emp."No.", false) then
                        NoOfAnsweredQuestions := NoOfAnsweredQuestions + 1;
                end;

                if ContProfileAnswer.Get(
                     Emp."No.", Rating."Rating Profile Quest. Code", Rating."Rating Profile Quest. Line No.")
                then begin
                    Value := Value + Rating.Points;
                    if ContProfileAnswer."Last Date Updated" < UpdateDate then
                        UpdateDate := ContProfileAnswer."Last Date Updated";
                end;
            until Rating.Next = 0;

        if TempProfileQuestnLine.Count <> 0 then
            QuestionsAnsweredPrc := NoOfAnsweredQuestions / TempProfileQuestnLine.Count * 100
        else
            QuestionsAnsweredPrc := 0;
    end;

    local procedure MarkEmployeeByMethod(ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion"; UpdateEmpNo: Code[20])
    var
        ProfileQuestnLine2: Record "Lin. Cuestionario Evaluacion";
    begin
        ProfileQuestnLine2.Reset;
        ProfileQuestnLine2 := ProfileQuestnLine;
        ProfileQuestnLine2.SetRange("Profile Questionnaire Code", ProfileQuestnLine."Profile Questionnaire Code");
        if ProfileQuestnLine2.Find('>') and
           (ProfileQuestnLine2.Type = ProfileQuestnLine2.Type::Answer)
        then
            repeat
                if UpdateEmpNo = '' then
                    Window.Update(3, ProfileQuestnLine2."Line No.");
                case ProfileQuestnLine."Classification Method" of
                    ProfileQuestnLine."Classification Method"::"Defined Value":
                        MarkByDefinedValue(ProfileQuestnLine, ProfileQuestnLine2);
                    ProfileQuestnLine."Classification Method"::"Percentage of Value":
                        MarkByPercentageOfValue(ProfileQuestnLine, ProfileQuestnLine2);
                    ProfileQuestnLine."Classification Method"::"Percentage of employees":
                        MarkByPercentageOfEmployee(ProfileQuestnLine, ProfileQuestnLine2);
                end;
            until (ProfileQuestnLine2.Next = 0) or
                  (ProfileQuestnLine2.Type = ProfileQuestnLine2.Type::Question);
    end;
}

