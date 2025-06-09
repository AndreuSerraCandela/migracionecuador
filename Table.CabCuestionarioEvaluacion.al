table 76340 "Cab. Cuestionario Evaluacion"
{
    Caption = 'Profile Questionnaire Header';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "Lista Cuestionario Evaluacion";
    LookupPageID = "Cab. Planif. Entrenamiento";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; Priority; Option)
        {
            Caption = 'Priority';
            InitValue = Normal;
            OptionCaption = 'Very Low,Low,Normal,High,Very High';
            OptionMembers = "Very Low",Low,Normal,High,"Very High";

            trigger OnValidate()
            var
                EmptProfileAnswer: Record "Employee Profile Answer";
            begin
                EmptProfileAnswer.SetCurrentKey("Profile Questionnaire Code");
                EmptProfileAnswer.SetRange("Profile Questionnaire Code", Code);
                EmptProfileAnswer.ModifyAll("Profile Questionnaire Priority", Priority);
                Modify;
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ProfileQuestnLine.Reset;
        ProfileQuestnLine.SetRange("Profile Questionnaire Code", Code);
        ProfileQuestnLine.DeleteAll(true);
    end;

    var
        ProfileQuestnLine: Record "Lin. Cuestionario Evaluacion";
}

