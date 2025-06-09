table 55003 "Grpo. Exist. Consig. Defecto"
{
    Caption = 'Consignment Location by Default';

    fields
    {
        field(1; "Grupo Contable Exist."; Code[20])
        {
            Caption = 'Grupo Contable Exist.';
            TableRelation = "Inventory Posting Group";
        }
        field(2; "Cod. Cuenta"; Code[20])
        {
            Caption = 'Account Code';
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Grupo Contable Exist.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

