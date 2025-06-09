codeunit 55014 "Events Item Jnl Post Line"
{
    /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforePostLineByEntryType', '', false, false)] //Pendiente
    local procedure OnBeforePostLineByEntryType(var ItemJournalLine: Record "Item Journal Line")
    var
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
    begin
        IF ItemJournalLine."Value Entry Type" = ItemJournalLine."Value Entry Type"::Revaluation THEN
            IF Item.GET(ItemJournalLine."Item No.") AND (Item."Costing Method" = Item."Costing Method"::Average) THEN BEGIN
                GLSetup.Get();
                if GLSetup."Additional Reporting Currency" <> '' then
                    Currency.Get(GLSetup."Additional Reporting Currency");
                RoundingResidualAmount := ItemJournalLine.Quantity *
                  (ItemJournalLine."Unit Cost" - ROUND(ItemJournalLine."Unit Cost" / QtyPerUnitOfMeasure, GLSetup."Unit-Amount Rounding Precision"));
                RoundingResidualAmountACY := ItemJournalLine.Quantity *
                  (ItemJournalLine."Unit Cost (ACY)" - ROUND(ItemJournalLine."Unit Cost (ACY)" / QtyPerUnitOfMeasure, Currency."Unit-Amount Rounding Precision"));
                IF ABS(RoundingResidualAmount) < GLSetup."Amount Rounding Precision" THEN
                    RoundingResidualAmount := 0;
                IF ABS(RoundingResidualAmountACY) < Currency."Amount Rounding Precision" THEN
                    RoundingResidualAmountACY := 0;
            END;
    end;*/

    //PostSplitJnlLine IsNotInternalWhseMovement

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnPostOutputOnAfterSetMfgUnitCost', '', false, false)]
    local procedure OnPostOutputOnAfterSetMfgUnitCost(var ItemJournalLine: Record "Item Journal Line"; var MfgUnitCost: Decimal; var ProdOrderLine: Record "Prod. Order Line")
    begin
        if ItemJournalLine.Subcontracting then
            MfgUnitCost := ProdOrderLine."Unit Cost"
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeUnApply', '', false, false)] //Pendiente //ReApply
    local procedure OnBeforeUnApply(var ItemApplnEntry: Record "Item Application Entry")
    var
        InventoryPeriod: Record "Inventory Period";
        ItemLE: Record "Item Ledger Entry";
    begin
        // ++ 005-YFC //Pendiente Existia orifginalmente en el metodo PrepareItem no tengo acceso a itemJnlLine por lo que busco Item Ledger Entry validar funcionamiento
        /*IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Assembly Output" THEN
            IsEnsamblado := TRUE;*/
        ItemLE.Get(ItemApplnEntry."Item Ledger Entry No.");

        //IF NOT IsEnsamblado THEN BEGIN
        if ItemLE."Entry Type" = ItemLE."Entry Type"::"Assembly Output" then
            // -- 005-YFC
            IF NOT InventoryPeriod.IsValidDate(ItemApplnEntry."Posting Date") THEN
                InventoryPeriod.ShowError(ItemApplnEntry."Posting Date");
        // 005-YFC
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterApplyItemLedgEntrySetFilters', '', false, false)]
    local procedure OnAfterApplyItemLedgEntrySetFilters(var ItemLedgerEntry2: Record "Item Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry")
    var
        Location: Record Location;
    begin
        ItemLedgerEntry2.SetRange("Order Type");
        ItemLedgerEntry2.SetRange("Order No.");
        IF Location.GET(ItemLedgerEntry."Location Code") THEN
            IF Location."Use As In-Transit" THEN BEGIN
                ItemLedgerEntry2.SETRANGE("Order Type", ItemLedgerEntry."Order Type"::Transfer);
                ItemLedgerEntry2.SETRANGE("Order No.", ItemLedgerEntry."Order No.");
            END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line")
    begin
        //001
        NewItemLedgEntry."Precio Unitario Cons. Inicial" := ItemJournalLine."Precio Unitario Cons. Inicial";
        NewItemLedgEntry."Descuento % Cons. Inicial" := ItemJournalLine."Descuento % Cons. Inicial";
        NewItemLedgEntry."Importe Cons. bruto Inicial" := ItemJournalLine."Importe Cons. bruto Inicial";
        NewItemLedgEntry."Importe Cons. Neto Inicial" := ItemJournalLine."Importe Cons Neto Inicial";
        NewItemLedgEntry."No. Mov. Prod. Cosg. a Liq." := ItemJournalLine."No. Mov. Prod. Cosg. a Liq.";
        NewItemLedgEntry."Pedido Consignacion" := ItemJournalLine."Pedido Consignacion";
        NewItemLedgEntry."Devolucion Consignacion" := ItemJournalLine."Devolucion Consignacion";
        NewItemLedgEntry."Precio Unitario Cons. Act." := ItemJournalLine."Precio Unitario Cons. Inicial";
        NewItemLedgEntry."Descuento % Cons. Actualizado" := ItemJournalLine."Descuento % Cons. Inicial";
        NewItemLedgEntry."Importe Cons. bruto Act." := ItemJournalLine."Importe Cons. bruto Inicial";
        NewItemLedgEntry."Importe Cons. Neto Act." := ItemJournalLine."Importe Cons Neto Inicial";
        //001

        //004
        NewItemLedgEntry."No aplica Derechos de Autor" := ItemJournalLine."No aplica Derechos de Autor";
        NewItemLedgEntry.Promocion := ItemJournalLine.Promocion;
        NewItemLedgEntry."Cod. Colegio" := ItemJournalLine."Cod. Colegio";
        //004
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforePostInventoryToGL', '', false, false)]
    local procedure OnBeforePostInventoryToGL(CalledFromAdjustment: Boolean; PostToGL: Boolean; var IsHandled: Boolean; var ItemJnlLine: Record "Item Journal Line"; var ValueEntry: Record "Value Entry")
    var
        Location: Record Location;
        InventoryPostingToGL: Codeunit "Inventory Posting To G/L";
        Item: Record Item;
    begin
        if Item.Get(ValueEntry."Item No.") then;
        IF ValueEntry.Inventoriable AND NOT Item."Inventory Value Zero" THEN
            exit;

        IF CalledFromAdjustment AND NOT PostToGL THEN
            exit;

        InventoryPostingToGL.SetRunOnlyCheck(true, not PostToGL, false);
        PostInvtBuffer(ValueEntry);

        if ValueEntry."Expected Cost" then begin
            if (ValueEntry."Cost Amount (Expected)" = 0) and (ValueEntry."Cost Amount (Expected) (ACY)" = 0) then
                SetValueEntry(ValueEntry, 1, 1, false)
            else
                SetValueEntry(ValueEntry, ValueEntry."Cost Amount (Expected)", ValueEntry."Cost Amount (Expected) (ACY)", false);
            InventoryPostingToGL.SetRunOnlyCheck(true, true, false);
            PostInvtBuffer(ValueEntry);
            SetValueEntry(ValueEntry, 0, 0, true);
        end else
            if (ValueEntry."Cost Amount (Actual)" = 0) and (ValueEntry."Cost Amount (Actual) (ACY)" = 0) then begin
                SetValueEntry(ValueEntry, 1, 1, false);
                InventoryPostingToGL.SetRunOnlyCheck(true, true, false);
                PostInvtBuffer(ValueEntry);
                SetValueEntry(ValueEntry, 0, 0, false);
            end;

        IsHandled := true;
    end;

    local procedure PostInvtBuffer(var ValueEntry: Record "Value Entry")
    var
        InventoryPostingToGL: Codeunit "Inventory Posting To G/L";
    begin
        if InventoryPostingToGL.BufferInvtPosting(ValueEntry) then begin
            GetInvtSetup();
            GetGLSetup();
            if GLSetup."Journal Templ. Name Mandatory" then
                InventoryPostingToGL.SetGenJnlBatch(
                    InvtSetup."Invt. Cost Jnl. Template Name", InvtSetup."Invt. Cost Jnl. Batch Name");
            InventoryPostingToGL.PostInvtPostBufPerEntry(ValueEntry);
        end;
    end;

    local procedure SetValueEntry(var ValueEntry: Record "Value Entry"; CostAmtActual: Decimal; CostAmtActACY: Decimal; ExpectedCost: Boolean)
    begin
        ValueEntry."Cost Amount (Actual)" := CostAmtActual;
        ValueEntry."Cost Amount (Actual) (ACY)" := CostAmtActACY;
        ValueEntry."Expected Cost" := ExpectedCost;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeItemApplnEntryInsert', '', false, false)] //Pendiente
    local procedure OnBeforeItemApplnEntryInsert(var ItemApplicationEntry: Record "Item Application Entry"; GlobalItemLedgerEntry: Record "Item Ledger Entry")
    var
        Location: Record Location;
    begin
        //if AverageTransfer then begin
        if (ItemApplicationEntry.Quantity > 0) or (GlobalItemLedgerEntry."Document Type" = GlobalItemLedgerEntry."Document Type"::"Transfer Receipt") then
            ItemApplicationEntry."Cost Application" :=
              ItemApplicationEntry.IsOutbndItemApplEntryCostApplication(ItemApplicationEntry."Item Ledger Entry No.");
        //end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitValueEntryOnAfterAssignFields', '', false, false)]
    local procedure OnInitValueEntryOnAfterAssignFields(var ValueEntry: Record "Value Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        //001
        ValueEntry."Precio Unitario Consignacion" := ItemJnlLine."Precio Unitario Cons. Inicial";
        ValueEntry."Descuento % Consignacion" := ItemJnlLine."Descuento % Cons. Inicial";
        ValueEntry."Importe Consignacion bruto" := ItemJnlLine."Importe Cons. bruto Inicial";
        ValueEntry."Importe Consignacion Neto" := ItemJnlLine."Importe Cons Neto Inicial";
        ValueEntry."Pedido Consignacion" := ItemJnlLine."Pedido Consignacion";
        ValueEntry."Devolucion Consignacion" := ItemJnlLine."Devolucion Consignacion";
        //001
    end;

    //Pendiente en el metodo CalcOutboundCostAmt cambiar MustConsiderUnitCostRoundingOnRevaluation por 
    /*
    IF (ValueEntry."Entry Type" = ValueEntry."Entry Type"::Revaluation) AND
           (Item."Costing Method" = Item."Costing Method"::Average)
        THEN BEGIN
    */

    LOCAL PROCEDURE IsNotInternalWhseMovement(ItemJnlLine: Record "Item Journal Line"): Boolean;
    BEGIN
        IF (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer) AND
           (ItemJnlLine."Location Code" = ItemJnlLine."New Location Code") AND
           (ItemJnlLine."Dimension Set ID" = ItemJnlLine."New Dimension Set ID") AND
           (ItemJnlLine."Value Entry Type" = ItemJnlLine."Value Entry Type"::"Direct Cost") AND
           NOT ItemJnlLine.Adjustment
        THEN
            EXIT(FALSE);
        EXIT(TRUE)
    END;


    //Pendiente añadir en CostAdjust no lo llama dentro del cu 
    /*
    IF NOT IsEnsamblado THEN // 005-YFC
        InventoryPeriod.IsValidDate(Opendate); //ya existe
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnPostItemOnBeforeTransferReservFromJobPlanningLine', '', false, false)]
    local procedure OnPostItemOnBeforeTransferReservFromJobPlanningLine(var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    var
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
    begin
        if ItemJournalLine."Job Contract Entry No." <> 0 then begin
            JobPlanningLine.SetCurrentKey("Job Contract Entry No.");
            JobPlanningLine.SetRange("Job Contract Entry No.", ItemJournalLine."Job Contract Entry No.");
            JobPlanningLine.FindFirst();

            if JobPlanningLine."Remaining Qty. (Base)" >= ItemJournalLine."Quantity (Base)" then
                JobPlanningLine."Remaining Qty. (Base)" := JobPlanningLine."Remaining Qty. (Base)" - ItemJournalLine."Quantity (Base)"
            else
                JobPlanningLine."Remaining Qty. (Base)" := 0;

            JobPlanningLineReserve.TransferJobLineToItemJnlLine(JobPlanningLine, ItemJournalLine, ItemJournalLine."Quantity (Base)");
        end;

        IsHandled := true;
    end;




    local procedure GetGLSetup()
    begin
        if not GLSetupRead then begin
            GLSetup.Get();
            if GLSetup."Additional Reporting Currency" <> '' then begin
                Currency.Get(GLSetup."Additional Reporting Currency");
                Currency.TestField("Unit-Amount Rounding Precision");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
        GLSetupRead := true;
    end;

    local procedure GetInvtSetup()
    begin
        if not InvtSetupRead then begin
            InvtSetup.Get();
            SourceCodeSetup.Get();
        end;
        InvtSetupRead := true;
    end;

    var
        //Text011 traducción Frances
        IsEnsamblado: Boolean;
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        InvtSetup: Record "Inventory Setup";
        SourceCodeSetup: Record "Source Code Setup";
        InvtSetupRead: Boolean;
        GLSetupRead: Boolean;

    /*
      Proyecto: Microsoft Dynamics Nav 2009
      AMS: Agustin Mendez
      --------------------------------------------------------------------------
      No.     Fecha           Firma         Descripcion
      ------------------------------------------------------------------------
      001     03-Junio-09     AMS           Pasamos los campos Precio venta e Importe
                                            a los movimientos de productos para poder
                                            tener los datos en las fichas de los clientes.

      002     09-Junio-2010   AMS           Pasamos el campo "Cod. Categoria producto" a los Mov. Valor
                                            para facilitar los reportes al area de sistemas.

      003     01-Agosto-2011  AMS           Se actualizan Los valores de la consignacion original.

      004     02/04/2012      AMS           Se pasa al mov. producto el dato si aplica para derecho de autor y Promocion.

      005         YFC      19/10/2020       SANTINAV-1524/SANTINAV-1452 (Pasar  #50911 Ampliacion de la modificacion #20233. Si la cantidad pendiente esta repartida en varios movimientos
                                             realizara el desensamblado en cada uno de ellos hasta cumplir la cantidad a desensamblar. )
    */
}