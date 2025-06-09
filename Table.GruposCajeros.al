table 76020 "Grupos Cajeros"
{
    Caption = 'Cashier Group';
    DrillDownPageID = "Lista Grupo Cajeros";
    LookupPageID = "Ficha Grupo Cajeros";

    fields
    {
        field(76046; Tienda; Code[20])
        {
            Description = 'DsPOS Standar';
            TableRelation = Tiendas."Cod. Tienda";
        }
        field(76029; Grupo; Code[20])
        {
            Description = 'DsPOS Standar';
        }
        field(76011; Descripcion; Text[250])
        {
            Description = 'DsPOS Standar';
        }
        field(76016; "Cliente al contado"; Code[20])
        {
            Caption = 'Cash Customer';
            Description = 'DsPOS Standar';
            TableRelation = Customer."No.";
        }
    }

    keys
    {
        key(Key1; Tienda, Grupo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField(Tienda);
        TestField(Grupo);
    end;
}

