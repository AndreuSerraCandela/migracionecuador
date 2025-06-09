table 76165 "Shift schedule"
{
    Caption = 'Shift schedule';
    DrillDownPageID = Shift;
    LookupPageID = Shift;

    fields
    {
        field(1; "Codigo turno"; Code[10])
        {
            Caption = 'Shift Code';
            TableRelation = Shift;

            trigger OnValidate()
            begin
                if Turno.Get("Codigo turno") then
                    Descripcion := Turno.Descripcion;
            end;
        }
        field(4; Descripcion; Text[30])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5; "Hora Inicio"; Time)
        {
            Caption = 'Date in';
        }
        field(6; "Hora Fin"; Time)
        {
            Caption = 'Date Out';
        }
    }

    keys
    {
        key(Key1; "Codigo turno", "Hora Inicio")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Codigo turno")
        {
        }
    }

    var
        Turno: Record Shift;
}

