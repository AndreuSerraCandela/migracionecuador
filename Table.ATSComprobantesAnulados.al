table 56078 "ATS Comprobantes Anulados"
{

    fields
    {
        field(1; "Tipo Comprobante anulado"; Code[2])
        {
        }
        field(2; Establecimiento; Code[3])
        {
        }
        field(3; "Punto Emision"; Code[3])
        {
        }
        field(4; "No. secuencial - Desde"; Code[9])
        {
        }
        field(5; "No. secuencial - Hasta"; Code[9])
        {
        }
        field(6; "No. autorización"; Code[37])
        {
        }
        field(7; "Mes -  Periodo"; Integer)
        {
            Caption = 'Mes -  Periodo';
        }
        field(8; "Año - Periodo"; Integer)
        {
            Caption = 'Año - Periodo';
        }
    }

    keys
    {
        key(Key1; "Tipo Comprobante anulado", Establecimiento, "Punto Emision", "No. secuencial - Desde")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

