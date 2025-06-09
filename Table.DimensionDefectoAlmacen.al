table 76019 "Dimension Defecto Almacen"
{

    fields
    {
        field(76046; "Cod. Almacen"; Code[20])
        {
            Caption = 'Location Code';
            Description = 'DsPOS Standar';
            NotBlank = true;
            TableRelation = Location.Code;
        }
        field(76029; "Codigo Dimension"; Code[20])
        {
            Caption = 'Dimension Code';
            Description = 'DsPOS Standar';
            NotBlank = true;
            TableRelation = Dimension.Code;
        }
        field(76011; "Valor Dimension"; Text[100])
        {
            Caption = 'Dimension Value';
            Description = 'DsPOS Standar';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Codigo Dimension"));
        }
    }

    keys
    {
        key(Key1; "Cod. Almacen", "Codigo Dimension")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Cod. Almacen");
    end;
}

