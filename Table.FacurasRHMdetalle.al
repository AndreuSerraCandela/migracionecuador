table 59004 "Facuras RHM - detalle"
{

    fields
    {
        field(1; Documento; Code[20])
        {
        }
        field(2; "Fecha registro"; Date)
        {
        }
        field(3; "No. Linea"; Integer)
        {
        }
        field(4; "Cod. Producto"; Code[20])
        {
        }
        field(5; Descripcion; Text[120])
        {
        }
        field(6; Cliente; Code[20])
        {
        }
        field(7; Nombre; Text[100])
        {
        }
        field(8; Cantidad; Decimal)
        {
        }
        field(9; "Importe bruto"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Documento, "No. Linea")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

