table 82509 "MIG Colores"
{
    LookupPageID = "Lista Formas de Pago";

    fields
    {
        field(1; Color; Code[10])
        {
        }
        field(2; Descripcion; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; Color)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*
        //Replicador
        rRec.GETTABLE(Rec);
        cuReplicatorFun.OnDelete(rRec);
        //Replicador
        */

    end;

    var
        rRec: RecordRef;
}

