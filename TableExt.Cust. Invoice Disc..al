tableextension 50026 tableextension50026 extends "Cust. Invoice Disc."
{


    trigger OnBeforeInsert()
    begin
        cRep.Customer(Code);
    end;

    trigger OnBeforeModify()
    begin
        cRep.Customer(Code);
    end;

    var
        cRep: Codeunit "Funciones Replicador DsPOS";
}

