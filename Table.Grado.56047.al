table 56047 "Grado."
{
    Caption = 'Grade';
    LookupPageID = Grado;

    fields
    {
        field(1; "Cod. Grado"; Code[20])
        {
            Caption = 'Grade Code';
        }
        field(2; Descripcion; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Cod. Grado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Grado", Descripcion)
        {
        }
    }
}

