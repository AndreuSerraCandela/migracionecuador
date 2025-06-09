table 55018 "ATS Ventas x Cliente"
{

    fields
    {
        field(1; "Tipo Identificacion Cliente"; Code[2])
        {
            Caption = 'Tipo Identificacion Cliente';
        }
        field(2; "No. Identificación Cliente"; Code[15])
        {
            Caption = 'No. Identificación Cliente';
        }
        field(3; "Codigo Tipo Comprobante"; Code[2])
        {
            Caption = 'Codigo Tipo Comprobante';
        }
        field(4; "No. de Comprobantes"; Integer)
        {
            Caption = 'No. de Comprobantes';
        }
        field(5; "Base Imponible No objeto IVA"; Decimal)
        {
            Caption = 'Base Imponible No objeto IVA';
        }
        field(6; "Base Imponible 0% IVA"; Decimal)
        {
            Caption = 'Base Imponible 0% IVA';
        }
        field(7; "Base Imposible 12% IVA"; Decimal)
        {
            Caption = 'Base Imposible 12% IVA';
        }
        field(8; "Monto IVA"; Decimal)
        {
            Caption = 'Monto IVA';
        }
        field(9; "Valor IVA retenido"; Decimal)
        {
            Caption = 'Valor IVA retenido';
        }
        field(10; "Cod.Cliente"; Code[20])
        {
            Caption = 'Cod.Cliente';
        }
        field(11; "Nombre Cliente"; Text[100])
        {
            Caption = 'Nombre Cliente';
        }
        field(12; "Mes -  Periodo"; Integer)
        {
            Caption = 'Mes -  Periodo';
        }
        field(13; "Año - Periodo"; Integer)
        {
            Caption = 'Año - Periodo';
        }
        field(14; "Valor Renta retenido"; Decimal)
        {
            Caption = 'Valor Renta retenido';
        }
        field(15; "Parte Relacionada"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Cod.Cliente", "Codigo Tipo Comprobante")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

