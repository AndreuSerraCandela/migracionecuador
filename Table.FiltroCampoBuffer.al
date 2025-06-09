table 75013 "Filtro Campo Buffer"
{
    // Esta tabla se creó para utilizarse como temporal unicamente

    DrillDownPageID = "Filtro Campo";
    LookupPageID = "Filtro Campo";

    fields
    {
        field(1; "Table Id"; Integer)
        {
        }
        field(2; "Field No"; Integer)
        {
        }
        field(10; Name; Text[30])
        {
            Caption = 'Nombre';
        }
        field(11; Caption; Text[100])
        {
            Caption = 'Campo';
        }
    }

    keys
    {
        key(Key1; "Table Id", "Field No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Field No", Caption)
        {
        }
    }
}

