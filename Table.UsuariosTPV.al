table 76011 "Usuarios TPV"
{
    Caption = 'POS Users';
    LookupPageID = "Ficha Grupo Cajeros";

    fields
    {
        field(1; ID; Code[20])
        {
            Caption = 'ID';
            NotBlank = true;
        }
        field(2; Descripcion; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Grupo Cajero"; Code[20])
        {
            Caption = 'Cashier Group';
            TableRelation = "Configuracion TPV";
        }
        field(4; "Contraseña"; Text[30])
        {
            Caption = 'Password';
        }
        field(5; Tienda; Code[20])
        {
            Caption = 'Store';
            TableRelation = "Bancos tienda";
        }
        field(6; Tipo; Option)
        {
            OptionCaption = 'Cashier, Supervisor';
            OptionMembers = Cajero,Supervisor;
        }
    }

    keys
    {
        key(Key1; ID, Tipo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

