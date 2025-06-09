table 56090 "Texto Configurable"
{
    // #842 CAT Configurador de textos


    fields
    {
        field(1; "Id. Tabla"; Integer)
        {
            /*   TableRelation = Object.ID WHERE (Type = CONST (TableData)); */
        }
        field(2; "Sección"; Option)
        {
            OptionMembers = Cabecera,Detalle,Pie;
        }
        field(3; "No. Linea"; Integer)
        {
        }
        field(4; Texto; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Id. Tabla", "Sección", "No. Linea")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rConf: Record "Texto Configurable";
    begin
        rConf.SetRange("Id. Tabla", "Id. Tabla");
        rConf.SetRange(Sección, Sección);
        if rConf.FindLast then
            "No. Linea" := rConf."No. Linea" + 1
        else
            "No. Linea" := 1;
    end;
}

