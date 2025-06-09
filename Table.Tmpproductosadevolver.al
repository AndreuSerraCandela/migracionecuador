table 86000 "Tmp productos a devolver"
{

    fields
    {
        field(1; "Customer No."; Code[20])
        {
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Item No."; Code[20])
        {
        }
        field(4; Cantidad; Decimal)
        {
        }
        field(5; "Cantidad defectuosa"; Decimal)
        {
        }
        field(10; "Inventario en Consignacion"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Document No.", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

