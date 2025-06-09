tableextension 50102 tableextension50102 extends "Human Resources Setup"
{
    fields
    {
        field(76200; "Candidate Nos."; Code[20])
        {
            Caption = 'Candidate Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(76060; "No. serie acciones personal"; Code[20])
        {
            Caption = 'Personnel actions serial no.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(76000; "No. serie entrenamientos"; Code[20])
        {
            Caption = 'Training serial no.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}

