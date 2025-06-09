table 55012 "Retenciones FE"
{

    fields
    {
        field(10; "No. documento"; Code[20])
        {
        }
        field(20; Codigo; Integer)
        {
        }
        field(30; "Codigo retencion"; Code[5])
        {
        }
        field(40; "Base imponible"; Decimal)
        {
        }
        field(50; "Porcentaje retener"; Decimal)
        {
        }
        field(60; "Valor retenido"; Decimal)
        {
        }
        field(70; "Cod. doc. sustento"; Code[2])
        {
        }
        field(80; "Num. doc. sustento"; Code[20])
        {
        }
        field(90; "Fecha emision doc. sustento"; Date)
        {
        }
        field(100; Comprobante; Text[50])
        {
            Description = 'Para el RIDE';
        }
        field(110; "Ejercicio fiscal"; Text[30])
        {
            Description = 'Para el RIDE';
        }
        field(120; Impuesto; Code[10])
        {
            Description = 'Para el RIDE';
        }
    }

    keys
    {
        key(Key1; "No. documento", Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

