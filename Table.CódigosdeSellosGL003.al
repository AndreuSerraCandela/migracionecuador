table 70002 "Códigos de Sellos GL003"
{

    fields
    {
        field(1; "Código Sello"; Code[60])
        {
        }
        field(2; "Descripción Sello"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Código Sello")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

