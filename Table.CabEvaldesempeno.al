table 76259 "Cab. Eval. desempeno"
{
    Caption = 'Performance eval. header';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "Profile Questionnaire List";
    LookupPageID = "Profile Questionnaires";

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
        LinEvaldesempeno.Reset;
        LinEvaldesempeno.SetRange(Code, Code);
        LinEvaldesempeno.DeleteAll(true);
    end;

    var
        LinEvaldesempeno: Record "Cab. Cuestionario Evaluacion";
}

