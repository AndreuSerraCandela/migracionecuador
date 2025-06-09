table 76215 "Divisas DsPOS"
{

    fields
    {
        field(1; Tienda; Code[20])
        {
            Description = 'DsPOS Standar';
            TableRelation = Tiendas;
        }
        field(2; TPV; Code[20])
        {
            Description = 'DsPOS Standar';
            TableRelation = "Configuracion TPV";
        }
        field(10; Divisa; Code[10])
        {
            Description = 'DsPOS Standar';
            TableRelation = Currency;
        }
        field(20; Descripcion; Text[30])
        {
            Description = 'DsPOS Standar';
        }
        field(30; "Tipo Cambio"; Decimal)
        {
            Description = 'DsPOS Standar';
        }
        field(40; "Fecha Valor"; Date)
        {
            Description = 'DsPOS Standar';
        }
    }

    keys
    {
        key(Key1; Tienda, TPV, Divisa)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

