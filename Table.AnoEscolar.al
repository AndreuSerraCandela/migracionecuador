table 51013 "Ano Escolar"
{
    Caption = 'School Year';
    //LookupPageID = 51008;

    fields
    {
        field(1; "Cod. Ano"; Code[20])
        {
            Caption = 'Year Code';
        }
        field(2; Descripcion; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Fecha Desde"; Date)
        {
            Caption = 'Date From';
        }
        field(4; "Fecha Hasta"; Date)
        {
            Caption = 'Date To:';
        }
    }

    keys
    {
        key(Key1; "Cod. Ano")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

