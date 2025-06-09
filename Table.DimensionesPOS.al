table 76098 "Dimensiones POS"
{
    // #81410  17/07/2017  PLB: Renumerado de 76438

    Caption = 'Dimensiones POS';

    fields
    {
        field(10; Dimension; Code[20])
        {
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(20; "Valor dimension"; Code[10])
        {
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD (Dimension));
        }
    }

    keys
    {
        key(Key1; Dimension)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

