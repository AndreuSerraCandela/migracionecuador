table 76155 "Log Importación"
{

    fields
    {
        field(1; Usuario; Code[50])
        {
        }
        field(4; Secuencia; Integer)
        {
        }
        field(5; Descripcion; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; Usuario, Secuencia)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

