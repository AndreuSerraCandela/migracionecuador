table 59998 "Configuracion CardNet"
{

    fields
    {
        field(1; "Puerto Com"; Option)
        {
            OptionMembers = COM1,COM2,COM3,COM4;
        }
        field(2; Velocidad; Integer)
        {
        }
        field(3; "Bits por Datos"; Integer)
        {
        }
        field(4; "Bit de Parada"; Option)
        {
            OptionMembers = "0","1","2";
        }
        field(5; Clave; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; Clave)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

