tableextension 50066 tableextension50066 extends "Default Dimension Priority"
{
    trigger OnAfterInsert()
    begin
        cRep.SourceCode("Source Code");
    end;

    trigger OnAfterModify()
    begin
        cRep.SourceCode("Source Code");
    end;

    var
        cRep: Codeunit "Funciones Replicador DsPOS";
}

