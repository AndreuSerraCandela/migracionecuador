table 82501 "MIG Grupo cajeros"
{
    Caption = 'Cashier Group';
    LookupPageID = "Ficha Tienda";

    fields
    {
        field(1; Grupo; Code[10])
        {
        }
        field(2; Descripcion; Text[250])
        {
        }
        field(3; "Cliente al contado"; Code[20])
        {
            Caption = 'Cash Customer';
            TableRelation = Customer;
        }
    }

    keys
    {
        key(Key1; Grupo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

