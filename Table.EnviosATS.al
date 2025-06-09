table 56076 "Envios ATS"
{
    //  #34860 11/1/15 Nuevo campo "No. Establecimientos".


    fields
    {
        field(10; "Primary Key"; Integer)
        {
        }
        field(20; Mes; Integer)
        {
        }
        field(30; "Año"; Integer)
        {
        }
        field(40; "Fecha generación"; Date)
        {
        }
        field(41; "No. Establecimientos"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        "Primary Key" := 1;
        if rRec.FindLast then
            "Primary Key" := rRec."Primary Key" + 1;
    end;

    var
        rRec: Record "Envios ATS";
}

