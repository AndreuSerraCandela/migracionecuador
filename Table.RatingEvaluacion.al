table 76181 "Rating Evaluacion"
{
    Caption = 'Rating';

    fields
    {
        field(1; "Profile Questionnaire Code"; Code[20])
        {
            Caption = 'Profile Questionnaire Code';
            NotBlank = true;
            TableRelation = "Cab. Cuestionario Evaluacion";
        }
        field(2; "Profile Questionnaire Line No."; Integer)
        {
            Caption = 'Profile Questionnaire Line No.';
            NotBlank = true;
            TableRelation = "Lin. Cuestionario Evaluacion"."Line No." WHERE ("Profile Questionnaire Code" = FIELD ("Profile Questionnaire Code"),
                                                                             Type = CONST (Question),
                                                                             "Employee Class. Field" = CONST (Rating));
        }
        field(3; "Rating Profile Quest. Code"; Code[20])
        {
            Caption = 'Rating Profile Quest. Code';
            NotBlank = true;
            TableRelation = "Cab. Cuestionario Evaluacion";
        }
        field(4; "Rating Profile Quest. Line No."; Integer)
        {
            Caption = 'Rating Profile Quest. Line No.';
            NotBlank = true;
            TableRelation = "Lin. Cuestionario Evaluacion"."Line No." WHERE ("Profile Questionnaire Code" = FIELD ("Rating Profile Quest. Code"),
                                                                             Type = CONST (Answer));
        }
        field(5; Points; Decimal)
        {
            BlankZero = true;
            Caption = 'Points';
            DecimalPlaces = 0 : 0;
        }
        field(6; "Profile Question Description"; Text[50])
        {
            CalcFormula = Lookup ("Lin. Cuestionario Evaluacion".Description WHERE ("Profile Questionnaire Code" = FIELD ("Profile Questionnaire Code"),
                                                                                   "Line No." = FIELD ("Profile Questionnaire Line No.")));
            Caption = 'Profile Question Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Profile Questionnaire Code", "Profile Questionnaire Line No.", "Rating Profile Quest. Code", "Rating Profile Quest. Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Rating Profile Quest. Code", "Rating Profile Quest. Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        ProfileQuestionnaireLine: Record "Lin. Cuestionario Evaluacion";
    begin
        ProfileQuestionnaireLine.Get("Profile Questionnaire Code", "Profile Questionnaire Line No.");
        CalcFields("Profile Question Description");
        ErrorMessage := "Profile Question Description";
        if RatingDeadlock(ProfileQuestionnaireLine, Rec) then
            Error(CopyStr(
                StrSubstNo(Text000, ProfileQuestionnaireLine.Description) +
                "Profile Question Description" + ' -> ' + ErrorMessage, 1, 1024));
    end;

    var
        Text000: Label 'Rating deadlock involving question %1 - insert aborted.\';
        ErrorMessage: Text[1024];

    local procedure RatingDeadlock(TargetProfileQuestnLine: Record "Lin. Cuestionario Evaluacion"; NextRating: Record "Rating Evaluacion") Deadlock: Boolean
    var
        Rating2: Record "Rating Evaluacion";
        ProfileQuestionnaireLine: Record "Lin. Cuestionario Evaluacion";
    begin
        Deadlock := false;
        ProfileQuestionnaireLine.Get(NextRating."Rating Profile Quest. Code", NextRating."Rating Profile Quest. Line No.");

        Rating2.SetRange("Profile Questionnaire Code", NextRating."Rating Profile Quest. Code");
        Rating2.SetRange("Profile Questionnaire Line No.", ProfileQuestionnaireLine.FindQuestionLine);
        if Rating2.Find('-') then
            repeat
                ProfileQuestionnaireLine.Get(Rating2."Rating Profile Quest. Code", Rating2."Rating Profile Quest. Line No.");
                ProfileQuestionnaireLine.Get(Rating2."Rating Profile Quest. Code", ProfileQuestionnaireLine.FindQuestionLine);
                if (TargetProfileQuestnLine."Profile Questionnaire Code" = ProfileQuestionnaireLine."Profile Questionnaire Code") and
                   (TargetProfileQuestnLine."Line No." = ProfileQuestionnaireLine."Line No.")
                then
                    Deadlock := true
                else
                    if RatingDeadlock(TargetProfileQuestnLine, Rating2) then
                        Deadlock := true;
            until (Deadlock = true) or (Rating2.Next = 0);

        if Deadlock then begin
            Rating2.CalcFields("Profile Question Description");
            ErrorMessage := CopyStr(Rating2."Profile Question Description" + ' -> ' + ErrorMessage, 1, 1024);
        end;
    end;
}

