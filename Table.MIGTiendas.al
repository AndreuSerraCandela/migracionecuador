table 82504 "MIG Tiendas"
{
    Caption = 'Stores';
    LookupPageID = "Lista Menus TPV";

    fields
    {
        field(1; "Cod. Tienda"; Code[20])
        {
            Caption = 'Store Code';
            NotBlank = true;
        }
        field(2; Descripcion; Text[200])
        {
            Caption = 'Description';
        }
        field(3; "Cod. Almacen"; Code[20])
        {
            Caption = 'Location code';
            TableRelation = Location;

            trigger OnValidate()
            var
                Location: Record Location;
            begin
                Location.Get("Cod. Almacen");
                Direccion := Location.Address;
                Telefono := Location."Phone No.";
                "Direccion 2" := Location."Address 2";
                "Pagina web" := Location."Home Page";
                "Telefono 2" := Location."Phone No. 2";
            end;
        }
        field(4; "Descripcion recibo TPV"; Text[250])
        {
            Caption = 'POS Receipt text';
        }
        field(5; Direccion; Text[250])
        {
            Caption = 'Address';
        }
        field(6; Telefono; Text[30])
        {
            Caption = 'Phone no.';
        }
        field(7; Fax; Text[30])
        {
        }
        field(8; "Direccion 2"; Text[250])
        {
            Caption = 'Address 2';
        }
        field(9; "Pagina web"; Text[250])
        {
            Caption = 'Web page';
        }
        field(10; "Telefono 2"; Text[30])
        {
            Caption = 'Phono no. 2';
        }
        field(11; RNC; Text[50])
        {
            Caption = 'VAT Registration No.';
        }
        field(12; "Cod. Banco"; Code[20])
        {
            Caption = 'Bank Account';
            TableRelation = "Bank Account";
        }
        field(13; "Nombre Banco"; Text[100])
        {
            Caption = 'Bank Name';
        }
        field(14; "BD Central"; Boolean)
        {
            Caption = 'Central DB';
        }
        field(15; "Descripcion recibo TPV 2"; Text[250])
        {
            Caption = 'POS Receipt text';
        }
        field(16; "Descripcion recibo TPV 3"; Text[250])
        {
            Caption = 'POS Receipt text';
        }
        field(17; "Descripcion recibo TPV 4"; Text[250])
        {
            Caption = 'POS Receipt text';
        }
    }

    keys
    {
        key(Key1; "Cod. Tienda")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

