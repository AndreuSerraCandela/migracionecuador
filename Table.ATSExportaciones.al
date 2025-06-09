table 56080 "ATS Exportaciones"
{

    fields
    {
        field(1; "Tipo Exportación"; Code[2])
        {
        }
        field(2; "Tipo de Comprobante"; Code[2])
        {
        }
        field(3; "No. refrendo - distrito adua."; Code[3])
        {
        }
        field(4; "No. refrendo - Año"; Code[4])
        {
        }
        field(5; "No. refrendo - regimen"; Code[2])
        {
        }
        field(6; "No. refrendo - Correlativo"; Code[8])
        {
        }
        field(7; "No. de documento de transporte"; Code[13])
        {
        }
        field(8; "Fecha de Embarque"; Date)
        {
        }
        field(9; "No. de FUE"; Code[13])
        {
        }
        field(10; "Valor FOB"; Decimal)
        {
        }
        field(11; "Valor del comprobante local"; Decimal)
        {
        }
        field(12; "Establecimiento comprobante"; Code[3])
        {
        }
        field(13; "Punto emision comprobante"; Code[3])
        {
        }
        field(14; "No. Secuencial comprobante"; Code[9])
        {
        }
        field(15; "No. autorización comprobante"; Code[49])
        {
        }
        field(16; "Fecha emision comprobante"; Date)
        {
        }
        field(17; "No. Documento"; Code[10])
        {
        }
        field(18; "Mes -  Periodo"; Integer)
        {
            Caption = 'Mes -  Periodo';
        }
        field(19; "Año - Periodo"; Integer)
        {
            Caption = 'Año - Periodo';
        }
        field(20; "Tipo Identificacion Cliente"; Code[2])
        {
        }
        field(21; "No. Identificación Cliente"; Code[17])
        {
        }
        field(22; "Parte Relacionada"; Boolean)
        {
        }
        field(23; "Pais Exportación"; Code[3])
        {
        }
        field(24; "Reg. fiscal preferente/paraiso"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No. Documento")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

