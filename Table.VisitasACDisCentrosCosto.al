table 76282 "Visitas A/C-Dis. Centros Costo"
{

    fields
    {
        field(1; "No. Visita Consultor/Asesor"; Code[20])
        {
        }
        field(2; "Código"; Code[20])
        {
            Editable = false;
        }
        field(3; "Descripción"; Text[60])
        {
            Editable = false;
        }
        field(4; Porcentaje; Decimal)
        {
            Caption = '%';
            MaxValue = 100;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "No. Visita Consultor/Asesor", "Código")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

