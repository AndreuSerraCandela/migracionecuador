table 76330 AFP
{
    DrillDownPageID = AFP;
    LookupPageID = AFP;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "Reporte Planilla"; Integer)
        {
            /*             TableRelation = Object.ID WHERE (Type = CONST (Report)); */
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
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}

