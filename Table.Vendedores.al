table 76228 Vendedores
{

    fields
    {
        field(76046; Tienda; Code[20])
        {
            Description = 'DsPOS Standar';
            TableRelation = Tiendas."Cod. Tienda";
        }
        field(76029; Codigo; Code[10])
        {
            Description = 'DsPOS Standar';
        }
        field(76011; Nombre; Text[50])
        {
            Description = 'DsPOS Standar';
        }
    }

    keys
    {
        key(Key1; Tienda, Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Tienda, Codigo, Nombre)
        {
        }
    }

    trigger OnInsert()
    begin

        TestField(Tienda);
        TestField(Codigo);
        TestField(Nombre);
    end;
}

