table 76152 "Pedidos Aparcados"
{
    // #81410  17/07/2017  PLB: Renumerado de 76439


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Numero Cliente"; Text[100])
        {
        }
        field(3; "Numero Colegio"; Text[100])
        {
        }
        field(4; Identificacion; Code[20])
        {
            Caption = 'Vat Reg. No.';
        }
        field(5; Nombre; Text[100])
        {
            Caption = 'Name';
        }
        field(6; Direccion; Text[100])
        {
            Caption = 'Address';
        }
        field(7; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
        }
        field(8; Telefono; Code[30])
        {
            Caption = 'Phone';
        }
        field(9; "Tipo Documento"; Text[30])
        {
        }
        field(10; "Nombre Colegio"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

