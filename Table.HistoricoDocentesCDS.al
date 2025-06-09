table 76122 "Historico Docentes - CDS"
{

    fields
    {
        field(1; Campana; Code[4])
        {
            Caption = 'Campaign';
        }
        field(2; "Cod. Docente"; Code[20])
        {
            Caption = 'Teacher code';
            TableRelation = Docentes;
        }
        field(3; "Pertenece al CDS"; Boolean)
        {
            Caption = 'Belong to CDS';
        }
        field(4; "Cod. CDS"; Code[20])
        {
            Caption = 'CDS code';
        }
        field(5; "Ult. fecha activacion"; Date)
        {
            Caption = 'Last activation date';
        }
        field(6; "Cod. Colegio"; Code[20])
        {
            Caption = 'School code';
            TableRelation = Contact;
        }
        field(7; "Cod. Nivel"; Code[20])
        {
            Caption = 'Level code';
        }
    }

    keys
    {
        key(Key1; Campana, "Cod. Docente")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

