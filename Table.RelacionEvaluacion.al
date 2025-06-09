table 76190 "Relacion Evaluacion"
{
    Caption = 'Business Relation';
    DataCaptionFields = "Code", Description;
    LookupPageID = "Business Relations";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "No. of Contacts"; Integer)
        {
            CalcFormula = Count ("Contact Business Relation" WHERE ("Business Relation Code" = FIELD (Code)));
            Caption = 'No. of Contacts';
            Editable = false;
            FieldClass = FlowField;
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
}

