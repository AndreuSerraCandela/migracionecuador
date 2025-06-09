table 56046 "Año Escolar."
{
    Caption = 'School Year';
    LookupPageID = "Año Escolar";

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
        fieldgroup(DropDown; "Cod. Ano", Descripcion, "Fecha Desde", "Fecha Hasta")
        {
        }
    }
}

