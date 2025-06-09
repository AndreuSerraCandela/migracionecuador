table 75015 "Tipo Filtros Tipo. MdM Buffer"
{
    Caption = 'Tipo Filtros Tipologia MdM Buffer';
    DrillDownPageID = "Tipo Filtros Tipologia MdM";
    LookupPageID = "Tipo Filtros Tipologia MdM";

    fields
    {
        field(1; Id; Integer)
        {
        }
        field(3; "Code"; Text[30])
        {
        }
        field(11; Tipo; Option)
        {
            OptionMembers = Dimension,"Dato MdM",Otros;
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
        fieldgroup(DropDown; "Code")
        {
        }
    }
}

