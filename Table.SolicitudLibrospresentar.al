table 76204 "Solicitud - Libros presentar"
{

    fields
    {
        field(1; "Núm. Solicitud"; Code[20])
        {
        }
        field(2; "Cod. Producto"; Code[20])
        {
            TableRelation = Item;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("Cod. Producto") then
                    "Descripción Producto" := Item.Description;
            end;
        }
        field(3; "Descripción Producto"; Text[100])
        {
        }
        field(4; "Horas por semana"; Decimal)
        {
        }
        field(5; "Año adopción"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Núm. Solicitud", "Cod. Producto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

