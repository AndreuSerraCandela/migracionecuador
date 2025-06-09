table 75014 "Filtro Valor Campo Buffer"
{
    // Esta tabla se creó para utilizarse como temporal unicamente

    Caption = 'Valores';
    DrillDownPageID = "Filtro Valor Campo";
    LookupPageID = "Filtro Valor Campo";

    fields
    {
        field(1; "Table Id"; Integer)
        {
        }
        field(2; "Field No"; Integer)
        {
        }
        field(3; Id; Integer)
        {
        }
        field(10; Value; Text[100])
        {
            Caption = 'Valor';
        }
        field(11; Description; Text[100])
        {
            Caption = 'Descripción';
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Value, Description)
        {
        }
    }
}

