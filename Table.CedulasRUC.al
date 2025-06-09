table 55004 "Cedulas/RUC"
{

    fields
    {
        field(1; "Cedula/Ruc"; Code[20])
        {
            Caption = 'Vat Reg. No.';
        }
        field(2; Nombre; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Direccion; Text[100])
        {
            Caption = 'Address';
        }
        field(4; Telefono; Code[30])
        {
            Caption = 'Phone';
        }
    }

    keys
    {
        key(Key1; "Cedula/Ruc")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

