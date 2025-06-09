table 56003 "Sello/Marca"
{
    Caption = 'Seal/Brand';
    LookupPageID = "Sello/Marca";

    fields
    {
        field(1; "Cod. Sello/Marca"; Code[20])
        {
            Caption = 'Seal/Brand Code';
        }
        field(2; Descripcion; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Cod. Sello/Marca")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

