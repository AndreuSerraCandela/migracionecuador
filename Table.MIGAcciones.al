table 82508 "MIG Acciones"
{
    Caption = 'Actions';
    LookupPageID = "Ficha Formas de Pago";

    fields
    {
        field(1; "ID Accion"; Code[20])
        {
            Caption = 'Action ID';
            NotBlank = true;
        }
        field(2; Descripcion; Text[250])
        {
            Caption = 'Description';
        }
        field(3; Tipo; Option)
        {
            OptionCaption = 'Action,Item,Customer';
            OptionMembers = Accion,Producto,Cliente;
        }
        field(4; "Cod. Accion"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "ID Accion")
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

