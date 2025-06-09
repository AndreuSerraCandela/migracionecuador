table 56016 "Lin. Identificación Devolución"
{

    fields
    {
        field(1; "No. Ident. Devolucion"; Code[20])
        {
            Caption = 'Return Identifier No.';
        }
        field(2; "No. Bulto"; Integer)
        {
            Caption = 'No. of package';
        }
        field(3; Comentarios; Text[250])
        {
            Caption = 'Comments';
        }
        field(4; Ubicacion; Text[250])
        {
            Caption = 'Place';
        }
    }

    keys
    {
        key(Key1; "No. Ident. Devolucion", "No. Bulto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

