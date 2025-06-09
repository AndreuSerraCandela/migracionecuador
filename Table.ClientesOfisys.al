table 70514 "Clientes Ofisys"
{

    fields
    {
        field(1; "Cod. Cliente"; Code[20])
        {
        }
        field(2; "Nombre Cliente"; Text[200])
        {
        }
        field(3; "Fecha Ingreso"; Date)
        {
        }
        field(4; "Tipo Cliente"; Code[20])
        {
        }
        field(5; "Tipo Persona"; Code[10])
        {
        }
        field(6; "Tipo Documento Ident."; Code[10])
        {
        }
        field(7; "Numero Documento Identidad"; Code[40])
        {
        }
        field(8; "Numero RUC"; Code[40])
        {
        }
        field(9; "Condicion Pago"; Code[10])
        {
        }
        field(10; "Porcentaje descuento"; Decimal)
        {
        }
        field(11; "Codigo Colegio"; Code[20])
        {
        }
        field(12; "Tipo Vendedor"; Code[20])
        {
        }
        field(13; "Codigo Vendedor"; Code[20])
        {
        }
        field(14; Situacion; Code[10])
        {
        }
        field(15; "Codigo Documento Sunat"; Code[10])
        {
        }
        field(16; "Numero Documento Sunat"; Code[40])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Cliente")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

