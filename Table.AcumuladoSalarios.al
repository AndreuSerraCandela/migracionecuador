table 76338 "Acumulado Salarios"
{

    fields
    {
        field(1; "Empresa cotización"; Code[10])
        {
            TableRelation = "Empresas Cotizacion";
        }
        field(2; "No. empleado"; Code[20])
        {
            TableRelation = Employee;
        }
        field(4; "Fecha Desde"; Date)
        {
        }
        field(5; "Fecha Hasta"; Date)
        {
        }
        field(6; Importe; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Empresa cotización", "No. empleado", "Fecha Desde")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

