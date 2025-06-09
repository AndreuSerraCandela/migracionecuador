table 82505 "MIG Dim. por Def. Almacen"
{

    fields
    {
        field(1; "Cod. Almacen"; Code[20])
        {
            Caption = 'Location Code';
            NotBlank = true;
        }
        field(2; "Codigo Dimension"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(3; "Valor Dimension"; Text[100])
        {
            Caption = 'Dimension Value';
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

    var
        rRec: RecordRef;
}

