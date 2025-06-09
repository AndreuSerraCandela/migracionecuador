tableextension 50063 tableextension50063 extends "Dimension Combination"
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

