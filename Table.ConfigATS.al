table 56077 "Config. ATS"
{

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Ruta ficheros XML"; Text[250])
        {
            Caption = 'Ruta ficheros XML';
        }
        field(30; "Subcarpeta generados"; Text[30])
        {
            Caption = 'Subcarpeta generados';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

