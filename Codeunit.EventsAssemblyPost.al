codeunit 55034 "Events Assembly-Post"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRun(var AssemblyHeader: Record "Assembly Header")
    begin
        ValidateEndingDate(AssemblyHeader);//004+-
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnAfterPost', '', false, false)]
    local procedure OnAfterPost(PostedAssemblyHeader: Record "Posted Assembly Header")
    begin
        // #209115 MdM
        cFunMdM.ContrlFechasEns(PostedAssemblyHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnBeforePostItemConsumption', '', false, false)]
    local procedure OnBeforePostItemConsumption(var AssemblyHeader: Record "Assembly Header"; var AssemblyLine: Record "Assembly Line"; var ItemJournalLine: Record "Item Journal Line")
    begin
        if ItemJournalLine.Correction then begin
            if AssemblyHeader."Location Code" <> '' then
                ItemJournalLine.Validate("Location Code", AssemblyHeader."Location Code");
            if AssemblyHeader."Bin Code" <> '' then
                ItemJournalLine."Bin Code" := AssemblyHeader."Bin Code";
        end;
    end;
    /* El metodo modificado manda como parametro  el almacen y bin code de la tabla AssemblyLine y de la tabla AssemblyHeader cuando es correccion
    si no es correcion no debe modificarse pero si lo es si mantengo el código original para comparar
    // ++ 001-YFC
            IF Almacen <> '' THEN
                ItemJnlLine.VALIDATE("Location Code", Almacen)
            ELSE
                ItemJnlLine.VALIDATE("Location Code", "Location Code");
            // --   001-YFC

            // ++ 001-YFC
            IF Bincode <> '' THEN
                ItemJnlLine."Bin Code" := Bincode
            ELSE
                ItemJnlLine."Bin Code" := "Bin Code";
    */

    //Pendiente en metodo PostCorrectionItemJnLine comentar lineas 717-719, 723-725 para que no agregue campo Quantity, Quantity(Base)

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnBeforeCheckPossibleToUndo', '', false, false)]
    local procedure OnBeforeCheckPossibleToUndo(PostedAssemblyHeader: Record "Posted Assembly Header")
    begin
        //+#14195
        CantidadDesensamblar(PostedAssemblyHeader);
        //-#14195

        //+#14195
        AssemblyPost.SetPostingDate(true, PostedAssemblyHeader."Ultima Fecha Reversion"); //Pendiente validar que remplace la fecha y si el primer parametro debe ir en false o true
        //PostingDate := PostedAssemblyHeader."Ultima Fecha Reversion";
        //-14195
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnAfterRecreateAsmOrderWithUndo', '', false, false)]
    local procedure OnAfterRecreateAsmOrderWithUndo(PostedAssemblyHeader: Record "Posted Assembly Header")
    begin
        //+#14195
        CantidadDesensamblada(PostedAssemblyHeader);
        //-#14195
    end;

    PROCEDURE SetEndingDate(NewReplaceEndingDate: Boolean; NewEndingDate: Date);
    BEGIN
        //004+
        EndingDateExists := TRUE;
        ReplaceEndingDate := NewReplaceEndingDate;
        EndingDate := NewEndingDate;
        //004-
    END;

    LOCAL PROCEDURE ValidateEndingDate(VAR AssemblyHeader: Record "Assembly Header");
    VAR
        //BatchPostParameterTypes: Codeunit "Batch Post Parameter Types"; //Pendiente metodos no estandar 
        BatchPostParameterTypes: Codeunit BatchPostParameterTypesExt;
    BEGIN
        //004+
        IF NOT EndingDateExists THEN
            //Pendiente el metodo aun no se crea lo creará Nicolas en un CU que el esta trabajando 
            EndingDateExists :=
          GetParameterBoolean(
            AssemblyHeader.RECORDID, BatchPostParameterTypes.ReplaceEndingDate, ReplaceEndingDate) AND
          GetParameterDate(AssemblyHeader.RECORDID, BatchPostParameterTypes.EndingDate, EndingDate);

        IF EndingDateExists AND (ReplaceEndingDate OR (AssemblyHeader."Ending Date" = 0D)) THEN
            AssemblyHeader."Ending Date" := EndingDate;
        //004-
    END;

    //Pendiente UndoPostLines poder borrar y cambiar líneas 1103-1124
    /*
    IF "Cantidad (Base) a Revertir" <> 0 THEN BEGIN
              CASE Type OF
                Type::Item:
                  PostItemConsumption(
                    AsmHeader,
                    AsmLine,
                    PostedAsmHeader."No. Series",
                    -"Cantidad a Revertir",
                    -"Cantidad (Base) a Revertir",ItemJnlPostLine,WhseJnlRegisterLine,"Document No.",TRUE,"Item Shpt. Entry No.",PostedAsmHeader."Ultimo Almacen Reversion",PostedAsmHeader."Bin Code"); //001-YFC
                    //-"Cantidad (Base) a Revertir",ItemJnlPostLine,WhseJnlRegisterLine,"Document No.",TRUE,"Item Shpt. Entry No.",AsmLine."Location Code");

                Type::Resource:
                  PostResourceConsumption(
                    AsmHeader,
                    AsmLine,
                    PostedAsmHeader."No. Series",
                    -"Cantidad a Revertir",
                    -"Cantidad (Base) a Revertir",
                    ResJnlPostLine,ItemJnlPostLine,"Document No.",TRUE);
              END;
              IF (PostedAsmHeader."Cantidad a Revertir" + PostedAsmHeader."Cantidad Revertida" = PostedAsmHeader.Quantity) THEN
                InsertLineItemEntryRelation(PostedAsmLine,ItemJnlPostLine,0);
              MODIFY;
            END;
            //-#14195
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnBeforePostItemOutputProcedure', '', false, false)]
    local procedure OnBeforePostItemOutputProcedure(IsCorrection: Boolean; AssemblyHeader: Record "Assembly Header"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line";
                                var IsHandled: Boolean; DocumentNo: Code[20])
    var
        PostedAsmHeader: Record "Posted Assembly Header";
    begin
        if IsCorrection then begin
            PostedAsmHeader.Get(DocumentNo);
            PostItemEntryOutput(AssemblyHeader, PostedAsmHeader, ItemJnlPostLine, WhseJnlRegisterLine);
            //-50911

            IsHandled := true;
        end;
    end;

    //Pendiente agregar el siguiente filtro antes de InsertHeaderItemEntryRelation en el metodo UndoPostHeader
    //IF ("Cantidad a Revertir" + "Cantidad Revertida" = Quantity) THEN //+#14195

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnAfterUpdateAsmOrderWithUndo', '', false, false)]
    local procedure OnAfterUpdateAsmOrderWithUndo(var PostedAssemblyHeader: Record "Posted Assembly Header")
    begin
        //+#14195
        CantidadDesensamblada(PostedAssemblyHeader);
        //-#14195
    end;

    //Pendiente modificar cantidad y cantidad base en los metodos RecreateAsmOrderWithUndo, UpdateAsmOrderWithUndo para la cabecera y líneas  solo se pudo el siguiente
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnBeforeRecreatedAsmHeaderInsert', '', false, false)]
    local procedure OnBeforeRecreatedAsmHeaderInsert(var AssemblyHeader: Record "Assembly Header"; PostedAssemblyHeader: Record "Posted Assembly Header")
    begin
        //+#14195
        AssemblyHeader."Posting Date" := PostedAssemblyHeader."Ultima Fecha Reversion";
        AssemblyHeader.Quantity := PostedAssemblyHeader."Cantidad a Revertir" + AssemblyHeader."Assembled Quantity";
        AssemblyHeader."Quantity (Base)" := PostedAssemblyHeader."Cantidad (Base) a Revertir" + AssemblyHeader."Assembled Quantity (Base)";
        //-#14195
    end;

    //Pendiente Modificar campo a evaluar y parametro en el metodo CheckPossibleToUndo
    //+#14195
    //1.- TESTFIELD(Reversed,FALSE); --> TESTFIELD("Revertido completamente",FALSE);
    //2.- UndoPostingMgt.CollectItemLedgEntries(
    //  TempItemLedgEntry,DATABASE::"Posted Assembly Header","No.",0,"Quantity (Base)","Item Rcpt. Entry No."); -->
    //UndoPostingMgt.CollectItemLedgEntries(
    //TempItemLedgEntry,DATABASE::"Posted Assembly Header","No.",0,"Cantidad (Base) a Revertir","Item Rcpt. Entry No.");
    //-#14195
    //+#14195
    //3.- UndoPostingMgt.CollectItemLedgEntries(
    //  TempItemLedgEntry,DATABASE::"Posted Assembly Line","Document No.","Line No.","Quantity (Base)","Item Shpt. Entry No."); -->
    //UndoPostingMgt.CollectItemLedgEntries(
    //TempItemLedgEntry,DATABASE::"Posted Assembly Line","Document No.","Line No.","Cantidad (Base) a Revertir","Item Shpt. Entry No.");
    //-#14195
    //+#36407
    //4.- //TESTFIELD("Location Code",PostedAsmHeader."Location Code"); comentar
    //5.- //TESTFIELD("Bin Code",PostedAsmHeader."Bin Code");
    //+#36407

    PROCEDURE CantidadDesensamblar(VAR PostedAsmHeader: Record "Posted Assembly Header");
    VAR
        PostedAsmLine: Record "Posted Assembly Line";
        Dialogo: Page "Cantidad deshacer-desarmar";
        CantidadDeshacer: Decimal;
        Err001: Label 'Proceso cancelado por el usuario.';
        Err002: Label 'La cantidad a deshacer no puede ser superior de %1';
        Err003: Label 'La cantidad a deshacer deber ser positiva.';
        Err004: Label 'No ha ingresado una fecha.';
        Fecha: Date;
        Err005: Label 'La fecha de reversi¢n no puede ser inferior a la fecha de ensamblado.';
        CodAlm: Code[20];
        rAlm: Record Location;
        Err006: Label 'El almacén ingresado no existe.';
        Err007: Label 'No ha ingresado un almacén.';
    BEGIN
        //+#14195
        Dialogo.SetCantidad((PostedAsmHeader.Quantity - PostedAsmHeader."Cantidad Revertida"));
        //+#36407
        Dialogo.SetAlmacen(PostedAsmHeader."Location Code");
        //-#36407
        Dialogo.LOOKUPMODE(TRUE);
        IF Dialogo.RUNMODAL = ACTION::LookupOK THEN BEGIN
            CantidadDeshacer := Dialogo.CantidadIngresada;
            Fecha := Dialogo.FechaIngresada;
            //+#36407
            CodAlm := Dialogo.AlmacenIngresado;
            //-#36407
        END
        ELSE
            ERROR(Err001);

        IF CantidadDeshacer <= 0 THEN
            ERROR(Err003);

        IF Fecha = 0D THEN
            ERROR(Err004);

        IF CantidadDeshacer > (PostedAsmHeader.Quantity - PostedAsmHeader."Cantidad Revertida") THEN
            ERROR(STRSUBSTNO(Err002, (PostedAsmHeader.Quantity - PostedAsmHeader."Cantidad Revertida")));

        IF Fecha < PostedAsmHeader."Posting Date" THEN
            ERROR(Err005);

        //+#36407
        IF CodAlm = '' THEN
            ERROR(Err007);

        IF NOT rAlm.GET(CodAlm) THEN
            ERROR(Err006);
        //-#36407

        PostedAsmHeader."Cantidad a Revertir" := CantidadDeshacer;
        PostedAsmHeader."Cantidad (Base) a Revertir" := ROUND(PostedAsmHeader."Cantidad a Revertir" * PostedAsmHeader."Qty. per Unit of Measure", 0.00001);
        PostedAsmHeader."Ultima Fecha Reversion" := Fecha;
        //+#36407
        PostedAsmHeader."Ultimo Almacen Reversion" := CodAlm;
        //-#36407

        //#45569:Inicio
        PostedAsmHeader."Bin Code" := rAlm."From-Assembly Bin Code";
        //#45569:Fin
        PostedAsmHeader.MODIFY;

        PostedAsmLine.RESET;
        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
        IF PostedAsmLine.FINDSET THEN
            REPEAT
                PostedAsmLine."Cantidad a Revertir" := PostedAsmLine.Quantity * (PostedAsmHeader."Cantidad a Revertir" / PostedAsmHeader.Quantity);
                PostedAsmLine."Cantidad (Base) a Revertir" := ROUND(PostedAsmLine."Cantidad a Revertir" * PostedAsmLine."Qty. per Unit of Measure", 0.00001);
                PostedAsmLine.MODIFY;
            UNTIL PostedAsmLine.NEXT = 0;

        COMMIT;
        //-#14195
    END;

    PROCEDURE CantidadDesensamblada(VAR PostedAsmHeader: Record "Posted Assembly Header");
    VAR
        PostedAsmLine: Record "Posted Assembly Line";
        Dialogo: Page "Cantidad deshacer-desarmar";
        CantidadDeshacer: Decimal;
        Err001: Label 'Proceso cancelado por el usuario.';
        Err002: Label 'La cantidad a deshacer no puede ser superior de %1';
    BEGIN
        //+#14195
        PostedAsmHeader."Cantidad Revertida" += PostedAsmHeader."Cantidad a Revertir";
        PostedAsmHeader."Cantidad (Base) Revertida" += PostedAsmHeader."Cantidad (Base) a Revertir";
        PostedAsmHeader."Cantidad a Revertir" := 0;
        PostedAsmHeader."Cantidad (Base) a Revertir" := 0;

        IF PostedAsmHeader.Quantity = PostedAsmHeader."Cantidad Revertida" THEN
            PostedAsmHeader."Revertido completamente" := TRUE;

        PostedAsmHeader.MODIFY;

        PostedAsmLine.RESET;
        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
        IF PostedAsmLine.FINDSET THEN
            REPEAT
                PostedAsmLine."Cantidad Revertida" += PostedAsmLine."Cantidad a Revertir";
                PostedAsmLine."Cantidad (Base) Revertida" += PostedAsmLine."Cantidad (Base) a Revertir";
                PostedAsmLine."Cantidad a Revertir" := 0;
                PostedAsmLine."Cantidad (Base) a Revertir" := 0;
                PostedAsmLine.MODIFY;
            UNTIL PostedAsmLine.NEXT = 0;
        //-#14195
    END;

    PROCEDURE DevuelveMovimiento(PostedAsmHeader: Record "Posted Assembly Header"): Integer;
    VAR
        ItemLedgerEntry: Record "Item Ledger Entry";
        BinContent: Record "Bin Content";
        WhseEntry: Record "Warehouse Entry";
        QtyAvailToTake: Decimal;
        MovPrincipal: Boolean;
        ItemLedgerEntry2: Record "Item Ledger Entry";
        MovSecundario: Boolean;
        Err001: Label 'No es posible aplicar el desensamblando en el almacÉn %1.';
    BEGIN
        //+#20233

        MovSecundario := FALSE;
        MovPrincipal := FALSE;

        ItemLedgerEntry.GET(PostedAsmHeader."Item Rcpt. Entry No.");
        //+#36407
        IF (ItemLedgerEntry."Location Code" = PostedAsmHeader."Ultimo Almacen Reversion") AND (ItemLedgerEntry."Remaining Quantity" >= PostedAsmHeader."Cantidad a Revertir") THEN BEGIN
            //+#36407
            MovPrincipal := TRUE;
            WhseEntry.RESET;
            WhseEntry.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.");
            WhseEntry.SETRANGE("Source Type", 900);
            WhseEntry.SETRANGE("Source Subtype", 1);
            WhseEntry.SETRANGE("Source No.", ItemLedgerEntry."Order No.");
            WhseEntry.SETRANGE("Source Line No.", 0);
            IF WhseEntry.FINDFIRST THEN BEGIN
                BinContent.GET(WhseEntry."Location Code", WhseEntry."Bin Code", WhseEntry."Item No.", WhseEntry."Variant Code", WhseEntry."Unit of Measure Code");
                QtyAvailToTake := BinContent.CalcQtyAvailToTake(0);
                IF QtyAvailToTake < (PostedAsmHeader."Cantidad a Revertir") THEN
                    MovPrincipal := FALSE;
            END;
        END;

        IF NOT MovPrincipal THEN BEGIN
            ItemLedgerEntry2.RESET;
            ItemLedgerEntry2.SETCURRENTKEY("Item No.", Positive, "Location Code", "Variant Code");
            //+#36407
            ItemLedgerEntry2.SETRANGE("Location Code", PostedAsmHeader."Ultimo Almacen Reversion");
            //-#36407
            ItemLedgerEntry2.SETRANGE("Item No.", ItemLedgerEntry."Item No.");
            ItemLedgerEntry2.SETRANGE(Positive, TRUE);
            ItemLedgerEntry2.SETRANGE(Open, TRUE);
            IF ItemLedgerEntry2.FINDSET THEN
                REPEAT
                    IF (ItemLedgerEntry2."Remaining Quantity") >= (PostedAsmHeader."Cantidad a Revertir") THEN BEGIN
                        MovSecundario := TRUE;
                        WhseEntry.RESET;
                        WhseEntry.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.");
                        WhseEntry.SETRANGE("Source Type", 900);
                        WhseEntry.SETRANGE("Source Subtype", 1);
                        WhseEntry.SETRANGE("Source No.", ItemLedgerEntry2."Order No.");
                        WhseEntry.SETRANGE("Source Line No.", 0);
                        IF WhseEntry.FINDFIRST THEN BEGIN
                            BinContent.GET(WhseEntry."Location Code", WhseEntry."Bin Code", WhseEntry."Item No.", WhseEntry."Variant Code", WhseEntry."Unit of Measure Code");
                            QtyAvailToTake := BinContent.CalcQtyAvailToTake(0);
                            IF QtyAvailToTake < (PostedAsmHeader."Cantidad a Revertir") THEN
                                MovSecundario := FALSE;
                        END;
                    END;
                UNTIL (ItemLedgerEntry2.NEXT = 0) OR (MovSecundario);
        END;

        //+#36407
        IF (NOT MovPrincipal) AND (NOT MovSecundario) THEN
            ERROR(STRSUBSTNO(Err001, PostedAsmHeader."Ultimo Almacen Reversion"));
        //+#36407
        IF MovPrincipal THEN
            EXIT(PostedAsmHeader."Item Rcpt. Entry No.")
        ELSE
            EXIT(ItemLedgerEntry2."Entry No.");

        //-#20233
    END;

    LOCAL PROCEDURE PostItemEntryOutput(VAR AsmHeader: Record "Assembly Header"; PostedAsmHeader: Record "Posted Assembly Header"; VAR ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; VAR WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line"): Integer;
    VAR
        ItemLedgerEntry: Record "Item Ledger Entry";
        BinContent: Record "Bin Content";
        WhseEntry: Record "Warehouse Entry";
        QtyAvailToTake: Decimal;
        QtyToOutput: Decimal;
        QtyToOutputBase: Decimal;
        EntryQtyToOutput: Decimal;
        EntryQtyToOutputBase: Decimal;
        Ltext001: Label 'No hay stock suficiente para el producto %1 en el almacen %2 y la ubicacion %3.';
    BEGIN
        //+#50911
        QtyToOutput := PostedAsmHeader."Cantidad a Revertir";
        QtyToOutputBase := PostedAsmHeader."Cantidad (Base) a Revertir";

        ItemLedgerEntry.GET(PostedAsmHeader."Item Rcpt. Entry No.");
        //IF ItemLedgerEntry.Open  THEN BEGIN // 002-YFC
        IF (ItemLedgerEntry.Open) AND (ItemLedgerEntry."Location Code" = PostedAsmHeader."Ultimo Almacen Reversion") THEN BEGIN // 002-YFC

            EntryQtyToOutput := 0;
            WhseEntry.RESET;
            WhseEntry.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.");
            WhseEntry.SETRANGE("Source Type", 900);
            WhseEntry.SETRANGE("Source Subtype", 1);
            WhseEntry.SETRANGE("Source No.", ItemLedgerEntry."Order No.");
            WhseEntry.SETRANGE("Source Line No.", 0);
            IF WhseEntry.FINDFIRST THEN BEGIN
                BinContent.GET(WhseEntry."Location Code", WhseEntry."Bin Code", WhseEntry."Item No.", WhseEntry."Variant Code", WhseEntry."Unit of Measure Code");
                QtyAvailToTake := BinContent.CalcQtyAvailToTake(0);
                IF QtyAvailToTake > 0 THEN BEGIN
                    IF QtyAvailToTake < QtyToOutput THEN
                        EntryQtyToOutput := QtyAvailToTake
                    ELSE
                        EntryQtyToOutput := QtyToOutput;
                END;
            END
            ELSE BEGIN
                IF ItemLedgerEntry."Remaining Quantity" < QtyToOutput THEN
                    EntryQtyToOutput := ItemLedgerEntry."Remaining Quantity"
                ELSE
                    EntryQtyToOutput := QtyToOutput;
            END;

            IF EntryQtyToOutput > 0 THEN BEGIN
                EntryQtyToOutputBase := ROUND(EntryQtyToOutput * AsmHeader."Qty. per Unit of Measure", 0.00001);
                //Pendiente el metodo es local y si se crea hay variables a las que no hay acceso 
                //PostItemOutput(
                //AsmHeader, AsmHeader."No. Series", -EntryQtyToOutput, -EntryQtyToOutputBase, ItemJnlPostLine, WhseJnlRegisterLine, PostedAsmHeader."No.", TRUE, PostedAsmHeader."Item Rcpt. Entry No.");

                QtyToOutput -= EntryQtyToOutput;
                QtyToOutputBase -= EntryQtyToOutputBase;
            END;
        END;

        IF QtyToOutput > 0 THEN BEGIN
            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETCURRENTKEY("Item No.", Positive, "Location Code", "Variant Code");
            ItemLedgerEntry.SETRANGE("Location Code", PostedAsmHeader."Ultimo Almacen Reversion");  //002-YFC

            ItemLedgerEntry.SETRANGE("Item No.", ItemLedgerEntry."Item No.");
            ItemLedgerEntry.SETRANGE(Positive, TRUE);
            ItemLedgerEntry.SETRANGE(Open, TRUE);
            ItemLedgerEntry.SETRANGE(Correction, FALSE);// 003-YFC
            IF ItemLedgerEntry.FINDSET THEN
                REPEAT
                    EntryQtyToOutput := 0;
                    WhseEntry.RESET;
                    WhseEntry.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.");
                    WhseEntry.SETRANGE("Source Type", 900);
                    WhseEntry.SETRANGE("Source Subtype", 1);
                    WhseEntry.SETRANGE("Source No.", ItemLedgerEntry."Order No.");
                    WhseEntry.SETRANGE("Source Line No.", 0);
                    IF WhseEntry.FINDFIRST THEN BEGIN
                        // ++ 003-YFC
                        IF NOT BinContent.GET(WhseEntry."Location Code", WhseEntry."Bin Code", WhseEntry."Item No.", WhseEntry."Variant Code", WhseEntry."Unit of Measure Code") THEN
                            BinContent.GET(ItemLedgerEntry."Location Code", WhseEntry."Bin Code", ItemLedgerEntry."Item No.", WhseEntry."Variant Code", WhseEntry."Unit of Measure Code");

                        // -- 003-YFC
                        QtyAvailToTake := BinContent.CalcQtyAvailToTake(0);
                        IF QtyAvailToTake > 0 THEN BEGIN
                            IF QtyAvailToTake < QtyToOutput THEN
                                EntryQtyToOutput := QtyAvailToTake
                            ELSE
                                EntryQtyToOutput := QtyToOutput;
                        END;
                    END
                    ELSE BEGIN
                        IF ItemLedgerEntry."Remaining Quantity" < QtyToOutput THEN
                            EntryQtyToOutput := ItemLedgerEntry."Remaining Quantity"
                        ELSE
                            EntryQtyToOutput := QtyToOutput;
                    END;

                    IF EntryQtyToOutput > 0 THEN BEGIN
                        EntryQtyToOutputBase := ROUND(EntryQtyToOutput * AsmHeader."Qty. per Unit of Measure", 0.00001);
                        //Pendiente el metodo es local y si se crea hay variables a las que no hay acceso 
                        //PostItemOutput(
                        //AsmHeader, AsmHeader."No. Series", -EntryQtyToOutput, -EntryQtyToOutputBase, ItemJnlPostLine, WhseJnlRegisterLine, PostedAsmHeader."No.", TRUE, ItemLedgerEntry."Entry No.");

                        QtyToOutput -= EntryQtyToOutput;
                        QtyToOutputBase -= EntryQtyToOutputBase;
                    END;
                UNTIL (ItemLedgerEntry.NEXT = 0) OR (QtyToOutput = 0);
        END;

        IF QtyToOutput > 0 THEN
            ERROR(Ltext001, PostedAsmHeader."Item No.", PostedAsmHeader."Ultimo Almacen Reversion", PostedAsmHeader."Bin Code");  //002-YFC
        //-#50911
    END;

    local procedure GetParameterBoolean(RecordID: RecordID; ParameterId: Integer; VAR ParameterValue: Boolean): Boolean
    var
        Result: Boolean;
        Value: Text[250];
    begin
        IF NOT GetParameterText(RecordID, ParameterId, Value) THEN
            EXIT(FALSE);

        IF NOT EVALUATE(Result, Value) THEN
            EXIT(FALSE);

        ParameterValue := Result;
        EXIT(TRUE);
    end;

    local procedure GetParameterText(RecordID: RecordID; ParameterId: Integer; VAR ParameterValue: Text[250]): Boolean
    var
        BatchProcessingParameter: Record "Batch Processing Parameter";
        BatchProcessingSessionMap: Record "Batch Processing Session Map";
    begin
        BatchProcessingSessionMap.SETRANGE("Record ID", RecordID);
        BatchProcessingSessionMap.SETRANGE("User ID", USERSECURITYID);
        BatchProcessingSessionMap.SETRANGE("Session ID", SESSIONID);

        IF NOT BatchProcessingSessionMap.FINDFIRST THEN
            EXIT(FALSE);

        IF NOT BatchProcessingParameter.GET(BatchProcessingSessionMap."Batch ID", ParameterId) THEN
            EXIT(FALSE);

        ParameterValue := BatchProcessingParameter."Parameter Value";
        EXIT(TRUE);
    end;

    local procedure GetParameterDate(RecordID: RecordID; ParameterId: Integer; VAR ParameterValue: Date): Boolean
    var
        Result: Date;
        Value: Text[250];
    begin
        IF NOT GetParameterText(RecordID, ParameterId, Value) THEN
            EXIT(FALSE);

        IF NOT EVALUATE(Result, Value) THEN
            EXIT(FALSE);

        ParameterValue := Result;
        EXIT(TRUE);
    end;


    var
        //Traducción Frances Text006
        SourceCode: Code[10];
        cFunMdM: Codeunit "Funciones MdM";
        EndingDate: Date;
        EndingDateExists: Boolean;
        ReplaceEndingDate: Boolean;
        AssemblyPost: Codeunit "Assembly-Post";

    /*

  #14195 26/03/15 CAT Se permite deshacer un pedido de ensamblado parcialmente.
  #20233 14/10/15 CAT Si el producto no tiene cantidad pendiente en el movimiento del ensamblado, buscar  en otros movimientos
  #36407 11/12/15 CAT Desensamblamos en el almacen seleccionado por el usuario.
  #45569  29/02/2016  MOI   Al desensamblar el codigo de ubicacion tiene que ser el que esta configurado en el almacen como Cod. ubic. desde ensamblado
  #209115     JPT        04/04/2019    MdM - Automatizar fecha entrada almacen

  ---------------------------------
  YFC     : Yefrecis Francisco Cruz
  ------------------------------------------------------------------------
  No.         Firma     Fecha            Descripcion
  ------------------------------------------------------------------------
  001         YFC      29/06/2020       SANTINAV-1521  desarme de combos - bodega origen
  002/#50911  YFC      19/10/2020       SANTINAV-1524/SANTINAV-1452 (Pasar  #50911 Ampliacion de la modificacion #20233. Si la cantidad pendiente esta repartida en varios movimientos
                                         realizara el desensamblado en cada uno de ellos hasta cumplir la cantidad a desensamblar. )
  003         YFC      22/0/2021       SANTINAV-1900 DESARME - COMBOS CON COMPONENTES DE OTROS COMBOS
  004         LDP      10/04/2024      SANTINAV-5892: Pedidos de Ensamblado - fecha final - cambio masivo.
*/
}