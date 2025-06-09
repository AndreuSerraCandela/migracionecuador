codeunit 76059 "Profile Management Eval. Des."
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'General';
        Text001: Label 'No profile questionnaire is created for this employee.';
        ProfileQuestnHeaderTemp: Record "Cab. Cuestionario Evaluacion" temporary;

    local procedure FindLegalProfileQuestionnaire(Emp: Record Employee)
    var
        ProfileQuestnHeader: Record "Cab. Cuestionario Evaluacion";
        ContProfileAnswer: Record "Employee Profile Answer";
        Valid: Boolean;
    begin
        ProfileQuestnHeaderTemp.DeleteAll;

        ProfileQuestnHeader.Reset;
        if ProfileQuestnHeader.Find('-') then
            repeat
                Valid := true;
                /*
                IF ("Contact Type" = "Contact Type"::Companies) AND
                   (Cont.Type <> Cont.Type::Company)
                THEN
                  Valid := FALSE;

                IF ("Contact Type" = "Contact Type"::People) AND
                   (Cont.Type <> Cont.Type::Person)
                THEN
                  Valid := FALSE;
                IF Valid AND ("Business Relation Code" <> '') THEN
                  IF NOT ContBusRel.GET(Cont."Company No.","Business Relation Code") THEN
                    Valid := FALSE;
                */
                if not Valid then begin
                    ContProfileAnswer.Reset;
                    ContProfileAnswer.SetRange("Employee No.", Emp."No.");
                    ContProfileAnswer.SetRange("Profile Questionnaire Code", ProfileQuestnHeader.Code);
                    if ContProfileAnswer.FindFirst then
                        Valid := true;
                end;
                if Valid then begin
                    ProfileQuestnHeaderTemp := ProfileQuestnHeader;
                    ProfileQuestnHeaderTemp.Insert;
                end;
            until ProfileQuestnHeader.Next = 0;

    end;

    procedure GetQuestionnaire(): Code[20]
    var
        ProfileQuestnHeader: Record "Profile Questionnaire Header";
    begin
        if ProfileQuestnHeader.FindFirst then
            exit(ProfileQuestnHeader.Code);

        ProfileQuestnHeader.Init;
        ProfileQuestnHeader.Code := Text000;
        ProfileQuestnHeader.Description := Text000;
        ProfileQuestnHeader.Insert;
        exit(ProfileQuestnHeader.Code);
    end;

    procedure ProfileQuestionnaireAllowed(Emp: Record Employee; ProfileQuestnHeaderCode: Code[20]): Code[20]
    begin
        FindLegalProfileQuestionnaire(Emp);

        if ProfileQuestnHeaderTemp.Get(ProfileQuestnHeaderCode) then
            exit(ProfileQuestnHeaderCode);
        if ProfileQuestnHeaderTemp.FindFirst then
            exit(ProfileQuestnHeaderTemp.Code);

        Error(Text001);
    end;

    procedure ShowContactQuestionnaireCard(Emp: Record Employee; ProfileQuestnLineCode: Code[20]; ProfileQuestnLineLineNo: Integer)
    var
        ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion";
        EmpProfileAnswers: Page "Preguntas Cuest. Evaluacion";
    begin
        EmpProfileAnswers.SetParameters(Emp, ProfileQuestionnaireAllowed(Emp, ''), ProfileQuestnLineCode, ProfileQuestnLineLineNo);
        if ProfileQuestnHeaderTemp.Get(ProfileQuestnLineCode) then begin
            ProfileQuestnLine.Get(ProfileQuestnLineCode, ProfileQuestnLineLineNo);
            EmpProfileAnswers.SetRecord(ProfileQuestnLine);
        end;
        EmpProfileAnswers.RunModal;
    end;

    procedure CheckName(CurrentQuestionsChecklistCode: Code[20]; var Emp: Record Employee)
    begin
        FindLegalProfileQuestionnaire(Emp);
        ProfileQuestnHeaderTemp.Get(CurrentQuestionsChecklistCode);
    end;

    procedure SetName(ProfileQuestnHeaderCode: Code[20]; var ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion"; ContactProfileAnswerLine: Integer)
    begin
        ProfileQuestnLine.FilterGroup := 2;
        ProfileQuestnLine.SetRange("Profile Questionnaire Code", ProfileQuestnHeaderCode);
        ProfileQuestnLine.FilterGroup := 0;
        if ContactProfileAnswerLine = 0 then
            if ProfileQuestnLine.Find('-') then;
    end;

    procedure LookupName(var ProfileQuestnHeaderCode: Code[20]; var ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion"; var Cont: Record Employee)
    begin
        Commit;
        FindLegalProfileQuestionnaire(Cont);
        if ProfileQuestnHeaderTemp.Get(ProfileQuestnHeaderCode) then;
        if PAGE.RunModal(PAGE::"Lista Cuestionario Evaluacion", ProfileQuestnHeaderTemp) = ACTION::LookupOK then
            ProfileQuestnHeaderCode := ProfileQuestnHeaderTemp.Code;

        SetName(ProfileQuestnHeaderCode, ProfileQuestnLine, 0);
    end;

    procedure ShowAnswerPoints(CurrProfileQuestnLine: Record "Lin. Cuestionario Evaluacion")
    begin
        CurrProfileQuestnLine.SetRange("Profile Questionnaire Code", CurrProfileQuestnLine."Profile Questionnaire Code");
        PAGE.RunModal(PAGE::"Answer Points", CurrProfileQuestnLine);
    end;
}

