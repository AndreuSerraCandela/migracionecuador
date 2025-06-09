table 76007 "Config. Localizacion"
{
    Caption = 'Localization Setup';
    DataPerCompany = false;

    fields
    {
        field(1; Codigo; Code[10])
        {
        }
        field(2; "URL DGII consulta NCF"; Text[250])
        {
        }
        field(3; "URL DGII consulta RNC"; Text[250])
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

