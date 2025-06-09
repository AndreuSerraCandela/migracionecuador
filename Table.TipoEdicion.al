table 56004 "Tipo Edicion"
{
    Caption = 'Edition Type';
    LookupPageID = "Lin. Packing Registrada";

    fields
    {
        field(1; "Cod. Tipo Edicion"; Code[20])
        {
            Caption = 'Edition Type Code';
        }
        field(2; Descripcion; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Cod. Tipo Edicion")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

