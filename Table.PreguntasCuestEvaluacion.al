table 76344 "Preguntas Cuest. Evaluacion"
{
    Caption = 'Contact Profile Answer';
    DrillDownPageID = "Profile Contacts";

    fields
    {
        field(1; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            NotBlank = true;
            TableRelation = Contact;

            trigger OnValidate()
            var
                Cont: Record Contact;
            begin
                /*IF Cont.GET(Desde) THEN
                  "Cantidad de dias" := Cont."Company No."
                ELSE
                  "Cantidad de dias" := '';
                  */

            end;
        }
        field(2; "Contact Company No."; Code[20])
        {
            Caption = 'Contact Company No.';
            NotBlank = true;
            TableRelation = Contact WHERE(Type = CONST(Company));
        }
        field(3; "Profile Questionnaire Code"; Code[20])
        {
            Caption = 'Profile Questionnaire Code';
            NotBlank = true;
            TableRelation = "Cab. Cuestionario Evaluacion";

            trigger OnValidate()
            var
                ProfileQuestnHeader: Record "Profile Questionnaire Header";
            begin
                ProfileQuestnHeader.Get("Profile Questionnaire Code");
                "Profile Questionnaire Priority" := ProfileQuestnHeader.Priority;
            end;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            TableRelation = "Lin. Cuestionario Evaluacion"."Line No." WHERE("Profile Questionnaire Code" = FIELD("Profile Questionnaire Code"),
                                                                             Type = CONST(Answer));

            trigger OnValidate()
            var
                ProfileQuestnLine: Record "Profile Questionnaire Line";
            begin
                ProfileQuestnLine.Get("Profile Questionnaire Code", "Line No.");
                "Answer Priority" := ProfileQuestnLine.Priority;
            end;
        }
        field(5; Answer; Text[50])
        {
            CalcFormula = Lookup("Lin. Cuestionario Evaluacion".Description WHERE("Profile Questionnaire Code" = FIELD("Profile Questionnaire Code"),
                                                                                   "Line No." = FIELD("Line No.")));
            Caption = 'Answer';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Contact Company Name"; Text[100])
        {
            CalcFormula = Lookup(Contact."Company Name" WHERE("No." = FIELD("Contact No.")));
            Caption = 'Contact Company Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Contact Name"; Text[100])
        {
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Contact No.")));
            Caption = 'Contact Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Profile Questionnaire Priority"; Enum "Profile Questionnaire Priority")
        {
            Caption = 'Profile Questionnaire Priority';
            Editable = false;
            //OptionCaption = 'Very Low,Low,Normal,High,Very High';
            //OptionMembers = "Very Low",Low,Normal,High,"Very High";
        }
        field(9; "Answer Priority"; Enum "Profile Answer Priority")
        {
            Caption = 'Answer Priority';
            //OptionCaption = 'Very Low (Hidden),Low,Normal,High,Very High';
            //OptionMembers = "Very Low (Hidden)",Low,Normal,High,"Very High";
        }
        field(10; "Last Date Updated"; Date)
        {
            Caption = 'Last Date Updated';
        }
        field(11; "Questions Answered (%)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Questions Answered (%)';
            DecimalPlaces = 0 : 0;
        }
        field(5088; "Profile Questionnaire Value"; Text[250])
        {
            Caption = 'Profile Questionnaire Value';
        }
    }

    keys
    {
        key(Key1; "Contact No.", "Profile Questionnaire Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Contact No.", "Answer Priority", "Profile Questionnaire Priority")
        {
        }
        key(Key3; "Profile Questionnaire Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Contact: Record Contact;
        ProfileQuestnLine: Record "Profile Questionnaire Line";
    begin
        /*ProfileQuestnLine.GET("Profile Questionnaire Code",QuestionLineNo);
        ProfileQuestnLine.TESTFIELD("Auto Contact Classification",FALSE);
        
        IF PartOfRating THEN BEGIN
          DELETE;
          UpdateContactClassification.UpdateRating(Desde);
          INSERT;
        END;
        
        Contact.TouchContact(Desde);
        */

    end;

    trigger OnInsert()
    var
        Contact: Record Contact;
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestnLine: Record "Profile Questionnaire Line";
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
        ProfileQuestnLine3: Record "Profile Questionnaire Line";
    begin
        /*
        ProfileQuestnLine.GET("Profile Questionnaire Code","Line No.");
        ProfileQuestnLine.TESTFIELD(Type,ProfileQuestnLine.Type::Answer);
        
        ProfileQuestnLine2.GET("Profile Questionnaire Code",QuestionLineNo);
        ProfileQuestnLine2.TESTFIELD("Auto Contact Classification",FALSE);
        
        IF NOT ProfileQuestnLine2."Multiple Answers" THEN BEGIN
          ContProfileAnswer.RESET;
          ProfileQuestnLine3.RESET;
          ProfileQuestnLine3.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
          ProfileQuestnLine3.SETRANGE(Type,ProfileQuestnLine3.Type::Question);
          ProfileQuestnLine3.SETFILTER("Line No.",'>%1',ProfileQuestnLine2."Line No.");
          IF ProfileQuestnLine3.FINDFIRST THEN
            ContProfileAnswer.SETRANGE(
              "Line No.",ProfileQuestnLine2."Line No.",ProfileQuestnLine3."Line No.")
          ELSE
            ContProfileAnswer.SETFILTER("Line No.",'>%1',ProfileQuestnLine2."Line No.");
          ContProfileAnswer.SETRANGE("Contact No.",Desde);
          ContProfileAnswer.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
          IF NOT ContProfileAnswer.ISEMPTY THEN
            ERROR(Text000,ProfileQuestnLine2.FIELDCAPTION("Multiple Answers"));
        END;
        
        IF PartOfRating THEN BEGIN
          INSERT;
          UpdateContactClassification.UpdateRating(Desde);
          DELETE;
        END;
        
        Contact.TouchContact(Desde);
        */

    end;

    trigger OnModify()
    var
        Contact: Record Contact;
    begin
        //Contact.TouchContact(Desde);
    end;

    trigger OnRename()
    var
        Contact: Record Contact;
    begin
        /*IF xRec.Desde = Desde THEN
          Contact.TouchContact(Desde)
        ELSE BEGIN
          Contact.TouchContact(Desde);
          Contact.TouchContact(xRec.Desde);
        END;
        */

    end;

    var
        Text000: Label 'This Question does not allow %1.';
        UpdateContactClassification: Report "Update Contact Classification";

    procedure Question(): Text[50]
    var
        ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion";
    begin
        if ProfileQuestnLine.Get("Profile Questionnaire Code", QuestionLineNo) then
            exit(ProfileQuestnLine.Description)
    end;

    local procedure QuestionLineNo(): Integer
    var
        ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion";
    begin
        ProfileQuestnLine.Reset;
        ProfileQuestnLine.SetRange("Profile Questionnaire Code", Rec."Profile Questionnaire Code");
        ProfileQuestnLine.SetFilter("Line No.", '<%1', Rec."Line No.");
        ProfileQuestnLine.SetRange(Type, ProfileQuestnLine.Type::Question);
        if ProfileQuestnLine.FindLast then
            exit(ProfileQuestnLine."Line No.");
    end;

    local procedure PartOfRating(): Boolean
    var
        Rating: Record "Rating Evaluacion";
        ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion";
        ProfileQuestnLine2: Record "Lin. Cuestionario Evaluacion";
    begin
        Rating.SetCurrentKey("Rating Profile Quest. Code", "Rating Profile Quest. Line No.");
        Rating.SetRange("Rating Profile Quest. Code", "Profile Questionnaire Code");

        ProfileQuestnLine.Get("Profile Questionnaire Code", "Line No.");
        ProfileQuestnLine.Get("Profile Questionnaire Code", ProfileQuestnLine.FindQuestionLine);

        ProfileQuestnLine2 := ProfileQuestnLine;
        ProfileQuestnLine2.SetRange(Type, ProfileQuestnLine2.Type::Question);
        ProfileQuestnLine2.SetRange("Profile Questionnaire Code", ProfileQuestnLine2."Profile Questionnaire Code");
        if ProfileQuestnLine2.Next <> 0 then
            Rating.SetRange("Rating Profile Quest. Line No.", ProfileQuestnLine."Line No.", ProfileQuestnLine2."Line No.")
        else
            Rating.SetFilter("Rating Profile Quest. Line No.", '%1..', ProfileQuestnLine."Line No.");

        exit(Rating.FindFirst);
    end;
}

