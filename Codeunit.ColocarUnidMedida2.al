codeunit 56007 ColocarUnidMedida2
{
    // FAA   12/03/2015  Colocar Unidad de Medida a Producto.  Incidencia 17768

    Permissions = TableData "Item Ledger Entry" = rm,
                  TableData "Sales Shipment Header" = rm,
                  TableData "Posted Assembly Header" = rm,
                  TableData "Warehouse Entry" = rm;

    trigger OnRun()
    begin
        /*
        rILEntry.RESET;
        rILEntry.SETRANGE(rILEntry."Item No.", '500000105');
        rILEntry.SETRANGE(rILEntry."Entry No.", 1667044);
        rILEntry.SETRANGE(rILEntry."Document No.", 'LMR-000065');
        IF rILEntry.FINDSET THEN
          rILEntry."Unit of Measure Code" := '01';
        
        rILEntry.MODIFY;
        
        
        
        rPAHeader.RESET;
        rPAHeader.SETRANGE(rPAHeader."No.", 'LMR-000065');
        rPAHeader.SETRANGE(rPAHeader."Item No.", '500000105');
        
        IF rPAHeader.FINDSET THEN
          rPAHeader."Unit of Measure Code" := '01';
        
        rPAHeader.MODIFY;
        
        
        rWHEntry.RESET;
        rWHEntry.SETRANGE(rWHEntry."Item No.", '500000105');
        rWHEntry.SETRANGE(rWHEntry."Entry No.", 1194910);
        //rWHEntry.SETRANGE(rWHEntry."Reference No.", 'LMR-000065');
        
        IF  rWHEntry.FINDSET THEN
          rWHEntry."Unit of Measure Code" := '01';
        
        rWHEntry.MODIFY;
        
        rSMthod.RESET;
        rSMthod.SETRANGE(rSMthod."No.", 'VR-344371');
        rSMthod.SETRANGE(rSMthod."Sell-to Customer No.", 'G22728');  */

        if rSMthod.FindSet then
            rSMthod."Ship-to Name" := 'Corporación de la asociación de los adventistas';

        rSMthod.Modify;

    end;

    var
        rILEntry: Record "Item Ledger Entry";
        rPAHeader: Record "Posted Assembly Header";
        rWHEntry: Record "Warehouse Entry";
        rSMthod: Record "Sales Shipment Header";
}

