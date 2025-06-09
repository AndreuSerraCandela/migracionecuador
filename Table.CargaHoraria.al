table 76129 "Carga Horaria"
{
    DrillDownPageID = "Carga Horaria";
    LookupPageID = "Carga Horaria";

    fields
    {
        field(1; Codigo; Code[20])
        {
        }
        field(2; Descripcion; Text[100])
        {
        }
        field(3; "Cantidad horas"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

