table 76078 "Razones Anulacion NCF"
{
    Caption = 'NCF Void reasons';
    DataPerCompany = false;

    fields
    {
        field(1; Codigo; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Descripcion; Text[250])
        {
            Caption = 'Description';
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
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }
}

