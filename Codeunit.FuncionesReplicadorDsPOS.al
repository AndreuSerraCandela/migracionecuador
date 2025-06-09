codeunit 76033 "Funciones Replicador DsPOS"
{

    trigger OnRun()
    begin
    end;


    procedure Item(pProd: Code[20])
    var
        ritem: Record Item;
    begin

        if ritem.Get(pProd) then
            if ritem.Delete(false) then
                ritem.Insert(false);
    end;


    procedure Cupon(pCupon: Code[20])
    var
        rCupon: Record "Cab. Cupon.";
    begin

        if rCupon.Get(pCupon) then
            if rCupon.Delete(false) then
                rCupon.Insert(false);
    end;


    procedure Customer(pClie: Code[20])
    var
        rCustomer: Record Customer;
    begin

        if rCustomer.Get(pClie) then
            if rCustomer.Delete(false) then
                rCustomer.Insert(false);
    end;


    procedure Dimension(pDimension: Code[20])
    var
        rDimension: Record Dimension;
    begin

        if rDimension.Get(pDimension) then
            if rDimension.Delete(false) then
                rDimension.Insert(false);
    end;


    procedure SourceCode(pSource: Code[20])
    var
        rSource: Record "Source Code";
    begin

        if rSource.Get(pSource) then
            if rSource.Delete(false) then
                rSource.Insert(false);
    end;
}

