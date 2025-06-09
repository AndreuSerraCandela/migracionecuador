tableextension 50064 tableextension50064 extends "Dimension Value Combination"
{

    trigger OnBeforeInsert()
    var
        myInt: Integer;
    begin
        cRep.Dimension("Dimension 1 Code");
        cRep.Dimension("Dimension 2 Code");
    end;

    trigger OnBeforeModify()
    var
        myInt: Integer;
    begin
        cRep.Dimension("Dimension 1 Code");
        cRep.Dimension("Dimension 2 Code");
    end;

    var
        cRep: Codeunit "Funciones Replicador DsPOS";
}

