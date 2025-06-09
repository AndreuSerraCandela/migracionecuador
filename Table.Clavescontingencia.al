table 55017 "Claves contingencia"
{
    Caption = 'Claves contingencia';

    fields
    {
        field(10; Ambiente; Option)
        {
            Caption = 'Ambiente';
            OptionCaption = 'Pruebas,Producción';
            OptionMembers = Pruebas,Produccion;
        }
        field(20; Clave; Text[49])
        {
            Caption = 'Clave';
        }
        field(30; Utilizada; Boolean)
        {
            Caption = 'Utilizada';
        }
        field(40; Comprobante; Code[20])
        {
            Caption = 'Comprobante';
        }
    }

    keys
    {
        key(Key1; Ambiente, Clave)
        {
            Clustered = true;
        }
        key(Key2; Ambiente, Utilizada)
        {
        }
    }

    fieldgroups
    {
    }
}

