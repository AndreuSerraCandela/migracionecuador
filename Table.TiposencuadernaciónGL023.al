table 70004 "Tipos encuadernación GL023"
{

    fields
    {
        field(1; "Código"; Code[2])
        {
            Description = 'Ojo en SAP son 2 posiciones.';
        }
        field(2; "Descripción"; Text[40])
        {
        }
    }

    keys
    {
        key(Key1; "Código")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

