table 56024 "Inventario Disp. Movil."
{

    fields
    {
        field(1; "Cod. Producto"; Code[20])
        {
            Caption = 'Item Code';
            TableRelation = Item;
        }
        field(2; Descripcion; Text[200])
        {
            Caption = 'Description';
        }
        field(3; "Cod. Almancen"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(4; Inventario; Decimal)
        {
            Caption = 'Inventory';
        }
        field(5; "Fecha Ult. Actualizacion"; Date)
        {
            Caption = 'Last Update Date';
        }
        field(6; "Linea de Negocio"; Code[20])
        {
            Caption = 'Bussines Line';
        }
        field(7; "Cod. Categoria Producto"; Code[10])
        {
            Caption = 'Item Category Code';
        }
        field(8; "Nombre Categoria Producto"; Text[200])
        {
            Caption = 'Item Category Code Name';
        }
    }

    keys
    {
        key(Key1; "Cod. Producto", "Cod. Almancen")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

