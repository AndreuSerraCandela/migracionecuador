table 50015 "Razones anulacion factura"
{
/*     DrillDownPageID = 50015;
    LookupPageID = 50015; */

    fields
    {
        field(1; Codigo; Code[10])
        {
            NotBlank = true;
        }
        field(2; Descripcion; Text[250])
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

