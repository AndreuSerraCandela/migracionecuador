table 76015 Cajeros
{
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.

    Caption = 'POS Users';

    fields
    {
        field(76046; Tienda; Code[20])
        {
            Caption = 'Store';
            Description = 'DsPOS Standar';
            TableRelation = Tiendas."Cod. Tienda";
        }
        field(76029; ID; Code[20])
        {
            Caption = 'ID';
            Description = 'DsPOS Standar';
            NotBlank = true;
        }
        field(76011; Descripcion; Text[100])
        {
            Caption = 'Description';
            Description = 'DsPOS Standar';
        }
        field(76016; "Grupo Cajero"; Code[20])
        {
            Caption = 'Cashier Group';
            Description = 'DsPOS Standar';
            TableRelation = "Grupos Cajeros".Grupo WHERE (Tienda = FIELD (Tienda));
        }
        field(76018; Contrasena; Text[30])
        {
            Caption = 'Password';
            Description = 'DsPOS Standar';
            ExtendedDatatype = Masked;
        }
        field(76015; Tipo; Option)
        {
            Description = 'DsPOS Standar';
            OptionCaption = 'Cashier, Supervisor';
            OptionMembers = Cajero,Supervisor;
        }
    }

    keys
    {
        key(Key1; Tienda, ID)
        {
            Clustered = true;
        }
        key(Key2; Tipo)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Tienda, ID, Descripcion)
        {
        }
    }

    trigger OnInsert()
    begin

        TestField(ID);
        TestField(Tienda);
        TestField("Grupo Cajero");
        TestField(Contrasena);
    end;
}

