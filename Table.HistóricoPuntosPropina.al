table 76251 "Histórico Puntos Propina"
{

    fields
    {
        field(1; "No. Empleado"; Code[20])
        {
        }
        field(2; "Fecha Aplicacion"; Date)
        {
        }
        field(3; Punto; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "No. Empleado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

