table 76194 "Employee Profile Answer"
{
    Caption = 'Employee Profile Answer';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            var
                Cont: Record Contact;
            begin
                /*GRN no va
                IF Cont.GET("Employee No.") THEN
                  "Employee Company No." := Cont."Company No."
                ELSE
                  "Employee Company No." := '';
                */

            end;
        }
        field(3; "Profile Questionnaire Code"; Code[20])
        {
            Caption = 'Profile Questionnaire Code';
            NotBlank = true;
            TableRelation = "Cab. Cuestionario Evaluacion";

            trigger OnValidate()
            var
                ProfileQuestnHeader: Record "Cab. Cuestionario Evaluacion";
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
                ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion";
            begin
                ProfileQuestnLine.Get("Profile Questionnaire Code", "Line No.");
                "Answer Priority" := ProfileQuestnLine.Priority;
            end;
        }
        field(5; Answer; Text[250])
        {
            CalcFormula = Lookup("Profile Questionnaire Line".Description WHERE("Profile Questionnaire Code" = FIELD("Profile Questionnaire Code"),
                                                                                 "Line No." = FIELD("Line No.")));
            Caption = 'Answer';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Employee Full Name"; Text[50])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            Caption = 'Employee Full Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Profile Questionnaire Priority"; Option)
        {
            Caption = 'Profile Questionnaire Priority';
            Editable = false;
            OptionCaption = 'Very Low,Low,Normal,High,Very High';
            OptionMembers = "Very Low",Low,Normal,High,"Very High";
        }
        field(9; "Answer Priority"; Option)
        {
            Caption = 'Answer Priority';
            OptionCaption = 'Very Low (Hidden),Low,Normal,High,Very High';
            OptionMembers = "Very Low (Hidden)",Low,Normal,High,"Very High";
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
        key(Key1; "Employee No.", "Profile Questionnaire Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Answer Priority", "Profile Questionnaire Priority")
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
        Employee: Record Employee;
        ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion";
    begin
        ProfileQuestnLine.Get("Profile Questionnaire Code", QuestionLineNo);
        ProfileQuestnLine.TestField("Auto Employee Classification", false);

        if PartOfRating then begin
            Delete;
            UpdateEmpClassification.UpdateRating("Employee No.");
            Insert;
        end;

        //Esto es para poner la ult. hora de modif. Employee.TouchEmployee("Employee No.");
    end;

    trigger OnInsert()
    var
        Employee: Record Employee;
        EmpProfileAnswer: Record "Employee Profile Answer";
        ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion";
        ProfileQuestnLine2: Record "Lin. Cuestionario Evaluacion";
        ProfileQuestnLine3: Record "Lin. Cuestionario Evaluacion";
    begin
        ProfileQuestnLine.Get("Profile Questionnaire Code", "Line No.");
        ProfileQuestnLine.TestField(Type, ProfileQuestnLine.Type::Answer);

        ProfileQuestnLine2.Get("Profile Questionnaire Code", QuestionLineNo);
        ProfileQuestnLine2.TestField("Auto Employee Classification", false);

        if not ProfileQuestnLine2."Multiple Answers" then begin
            EmpProfileAnswer.Reset;
            ProfileQuestnLine3.Reset;
            ProfileQuestnLine3.SetRange("Profile Questionnaire Code", "Profile Questionnaire Code");
            ProfileQuestnLine3.SetRange(Type, ProfileQuestnLine3.Type::Question);
            ProfileQuestnLine3.SetFilter("Line No.", '>%1', ProfileQuestnLine2."Line No.");
            if ProfileQuestnLine3.FindFirst then
                EmpProfileAnswer.SetRange(
                  "Line No.", ProfileQuestnLine2."Line No.", ProfileQuestnLine3."Line No.")
            else
                EmpProfileAnswer.SetFilter("Line No.", '>%1', ProfileQuestnLine2."Line No.");
            EmpProfileAnswer.SetRange("Employee No.", "Employee No.");
            EmpProfileAnswer.SetRange("Profile Questionnaire Code", "Profile Questionnaire Code");
            if not EmpProfileAnswer.IsEmpty then
                Error(Text000, ProfileQuestnLine2.FieldCaption("Multiple Answers"));
        end;

        if PartOfRating then begin
            Insert;
            UpdateEmpClassification.UpdateRating("Employee No.");
            Delete;
        end;

        //Esto es para poner la ult. hora de modif. Employee.TouchEmployee("Employee No.");
    end;

    trigger OnModify()
    var
        Contact: Record Contact;
    begin
        //Esto es para poner la ult. hora de modif. Employee.TouchEmployee("Employee No.");
    end;

    trigger OnRename()
    var
        Contact: Record Contact;
    begin
        /*
        //Esto es para poner la ult. hora de modif.
        IF xRec."Employee No." = "Employee No." THEN
          Employee.TouchEmployee("Employee No.")
        ELSE BEGIN
          Employee.TouchEmployee("Employee No.");
          Employee.TouchEmployee(xRec."Employee No.");
        END;
        */

    end;

    var
        Text000: Label 'This Question does not allow %1.';
        UpdateEmpClassification: Report "Update Employee Classification";

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
            exit(ProfileQuestnLine."Line No.")
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

