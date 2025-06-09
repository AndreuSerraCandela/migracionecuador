table 70508 MCliente03
{

    fields
    {
        field(1; Cliente; Code[20])
        {
        }
        field(2; Descuento; Text[10])
        {
        }
        field(3; Sello; Text[30])
        {
        }
        field(4; "Cod. Descuento Producto"; Text[30])
        {
        }
        field(5; Coleccion; Text[30])
        {
        }
        field(6; "Fecha Ini Validez"; Date)
        {
        }
        field(7; "Fecha Fin Validez"; Date)
        {
        }
        field(13; "Tipo Venta"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign;
        }
    }

    keys
    {
        key(Key1; Cliente)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

