tableextension 50097 tableextension50097 extends "Employee Qualification"
{
    fields
    {
        field(76200; "Acuerdo de permanencia"; Boolean)
        {
            Caption = 'Contract agreement';
            DataClassification = ToBeClassified;
            Description = 'NOMDS1.01';
        }
        field(76060; "Cod. Entrenamiento"; Code[20])
        {
            Caption = 'Training code';
            DataClassification = ToBeClassified;
            Description = 'NOMDS1.02';
        }
    }
}

