table 76323 "Dis. Centros Costo"
{

    fields
    {
        field(1; "No. Solicitud"; Code[20])
        {
        }
        field(2; "Código"; Code[20])
        {
        }
        field(3; "Descripción"; Text[60])
        {
        }
        field(4; Porcentaje; Decimal)
        {
            Caption = '%';
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "Cod. Taller - Evento"; Code[20])
        {
            TableRelation = Eventos."No.";
        }
        field(6; "Tipo Evento"; Code[20])
        {
            TableRelation = "Tipos de Eventos";
        }
        field(8; Expositor; Code[20])
        {
        }
        field(9; Secuencia; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No. Solicitud", "Cod. Taller - Evento", Expositor, Secuencia, "Código")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

