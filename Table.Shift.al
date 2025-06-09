table 76385 Shift
{
    DrillDownPageID = Shift;
    LookupPageID = Shift;

    fields
    {
        field(1; Codigo; Code[10])
        {
        }
        field(2; Descripcion; Text[30])
        {
        }
        field(3; "Hora Inicio"; Time)
        {
        }
        field(4; "Hora Fin"; Time)
        {
        }
        field(5; "Incluir Hora de almuerzo"; Boolean)
        {
            Caption = 'Include lunchtime';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }
}

