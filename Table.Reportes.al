table 56014 Reportes
{

    fields
    {
        field(1; "No. Mov."; Integer)
        {
        }
        field(2; "Tipo Mov."; Text[50])
        {
        }
        field(3; Cantidad; Decimal)
        {
        }
        field(4; PVP; Decimal)
        {
        }
        field(5; "Precio Liquido"; Decimal)
        {
        }
        field(6; "Fecha Registro"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; "No. Producto"; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(8; "User ID"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No. Mov.")
        {
            Clustered = true;
        }
        key(Key2; "No. Producto", "Tipo Mov.", "Fecha Registro", PVP, "Precio Liquido")
        {
        }
        key(Key3; "User ID")
        {
        }
    }

    fieldgroups
    {
    }
}

