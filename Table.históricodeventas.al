table 59000 "histórico de ventas"
{

    fields
    {
        field(1; "Tipo Factura"; Text[30])
        {
        }
        field(2; "Cliente Santillana"; Code[20])
        {
        }
        field(3; "Destinatario Santillana"; Text[150])
        {
        }
        field(4; "Orden de compra del cliente"; Code[20])
        {
        }
        field(5; "Fecha Factura"; Text[30])
        {
        }
        field(6; "N° legal comprobante"; Code[20])
        {
        }
        field(7; Moneda; Code[20])
        {
        }
        field(8; "Código Material Santillana"; Code[20])
        {
        }
        field(9; ISBN; Code[20])
        {
        }
        field(10; "P.V.P."; Decimal)
        {
        }
        field(11; Descuento; Decimal)
        {
        }
        field(12; Cantidad; Decimal)
        {
        }
        field(13; NoDoc; Code[20])
        {
        }
        field(14; NoLin; Integer)
        {
        }
    }

    keys
    {
        key(Key1; NoDoc, NoLin)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

