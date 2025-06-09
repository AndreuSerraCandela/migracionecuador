table 50012 "Productos - Ventas por cliente"
{
/*     DrillDownPageID = 50012;
    LookupPageID = 50012; */

    fields
    {
        field(1; "Cod. cliente"; Code[20])
        {
        }
        field(2; "Nombre cliente"; Text[100])
        {
        }
        field(3; Producto; Code[20])
        {
        }
        field(4; "Descripcion producto"; Text[100])
        {
        }
        field(5; "Grupo contable producto"; Code[20])
        {
        }
        field(6; Cantidad; Decimal)
        {
        }
        field(7; "Ventas brutas"; Decimal)
        {
        }
        field(8; "Costo de venta"; Decimal)
        {
        }
        field(9; "No. Documento"; Code[20])
        {
        }
        field(10; "Fecha Registro"; Date)
        {
        }
        field(11; "No. Movimiento"; Integer)
        {
        }
        field(12; Valor; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "No. Movimiento")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

