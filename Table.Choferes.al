table 56041 Choferes
{
    Caption = 'Drivers';

    fields
    {
        field(1; "Cod. Chofer"; Code[20])
        {
            Caption = 'Driver Code';
        }
        field(2; Nombre; Text[100])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; "Cod. Chofer")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Chofer", Nombre)
        {
        }
    }
}

