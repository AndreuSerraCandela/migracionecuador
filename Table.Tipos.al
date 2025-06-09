table 56006 Tipos
{
    Caption = 'Types';
    DrillDownPageID = "Puestos de Packing";
    LookupPageID = "Puestos de Packing";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[60])
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
}

