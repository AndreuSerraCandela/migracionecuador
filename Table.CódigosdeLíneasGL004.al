table 70003 "Códigos de Líneas GL004"
{

    fields
    {
        field(1; "Código Línea"; Code[60])
        {
            Description = '(3 Primeros dígitos, corresponden al Sello)';
        }
        field(2; "Descripción Línea"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Código Línea")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

