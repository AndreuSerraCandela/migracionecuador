table 75011 "Precios Futuro"
{

    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(10; Producto; Code[20])
        {
            TableRelation = Item;
        }
        field(11; Fecha; Date)
        {
        }
        field(12; Tipo; Option)
        {
            OptionMembers = Inicio,Fin;
        }
        field(20; PricePos; RecordID)
        {
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
        key(Key2; Fecha, Producto)
        {
        }
        key(Key3; Producto, Fecha)
        {
        }
    }

    fieldgroups
    {
    }
}

