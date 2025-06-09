table 75012 "Valores Filtros Tipologia MdM"
{
    // Este Tabla se creó para utilizars unicamente como temnporal

    DrillDownPageID = "Valores Filtros Tipologia MdM";
    LookupPageID = "Valores Filtros Tipologia MdM";

    fields
    {
        field(1; Id; Integer)
        {
        }
        field(2; "Id Filtro"; Integer)
        {
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Código';
        }
        field(5; Description; Text[50])
        {
            Caption = 'Descripción';
        }
        field(10; "Filtro Tipologia"; Code[10])
        {
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
            TableRelation = "Item Category";
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
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}

