table 56007 Edicion
{
    DrillDownPageID = "Mov. Prod. Por Clientes";
    LookupPageID = "Mov. Prod. Por Clientes";

    fields
    {
        field(1; Codigo; Code[20])
        {
            Caption = 'Codigo';
        }
        field(2; Descripcion; Text[30])
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
    }
}

