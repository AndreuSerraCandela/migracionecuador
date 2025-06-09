codeunit 56039 "Revisar Mov. Producto"
{
    Permissions = TableData "Item Ledger Entry" = rimd,
                  TableData "Item Application Entry" = rimd,
                  TableData "Warehouse Entry" = rimd;

    trigger OnRun()
    var
        TEST: Boolean;
        TextSelecc: Label 'Testear,Corregir';
        TxtCancelado: Label 'Proceso cancelado.';
    begin
        case (StrMenu(TextSelecc, 0, 'Seleccione una acción')) of
            1:
                TEST := true;
            2:
                TEST := false;
            else
                Error(TxtCancelado);
        end;

        InconsistenciaT32(TEST);
        InconsistenciaT32_T339(TEST);
        InconsistenciaT32_T7312(TEST);
        Message('Proceso finalizado');
    end;


    procedure CheckT32(pValidar: Boolean): Boolean
    var
        rMovProducto: Record "Item Ledger Entry";
        TotalCantidad: Decimal;
        TotalCantidadPendiente: Decimal;
        Contador: Integer;
        TotalContador: Integer;
        Ventana: Dialog;
        lTextContador: Label 'Revisando Mov Producto\MovProducto: #1########## @2@@@@@@@@@@';
        TotalInconsistencia: Integer;
        Tabla: Record "Revisar Mov. Producto";
        OldItem: Code[20];
        OldLocation: Code[10];
        TotalCantidadEntrada: Decimal;
        TotalCantidadPendienteEntrada: Decimal;
        TotalCantidadSalida: Decimal;
        TotalCantidadPendienteSalida: Decimal;
        lTextContador2: Label 'Validando Mov Producto\MovProducto: #1########## @2@@@@@@@@@@';
    begin
        Clear(TotalInconsistencia);

        Tabla.DeleteAll;

        rMovProducto.Reset;
        Clear(Contador);
        TotalContador := rMovProducto.Count;

        if pValidar then
            Ventana.Open(lTextContador2)
        else
            Ventana.Open(lTextContador);

        rMovProducto.SetCurrentKey("Item No.", "Location Code", Open, "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.");
        if rMovProducto.FindSet() then begin
            OldItem := rMovProducto."Item No.";
            OldLocation := rMovProducto."Location Code";
            Clear(TotalCantidad);
            Clear(TotalCantidadPendiente);
            repeat
                if (OldItem <> rMovProducto."Item No.") or (OldLocation <> rMovProducto."Location Code") then begin
                    if TotalCantidad <> TotalCantidadPendiente then begin
                        TotalInconsistencia += 1;
                        Tabla.Init;
                        Tabla."Item Code" := OldItem;
                        Tabla."Location Code" := OldLocation;
                        Tabla.Quantity := TotalCantidad;
                        Tabla."Remaining Quantity" := TotalCantidadPendiente;
                        Tabla.Diferencia := Tabla.Quantity - Tabla."Remaining Quantity";
                        Tabla."Cantidad Entrada" := TotalCantidadEntrada;
                        Tabla."Cantidad Pendiente Entrada" := TotalCantidadPendienteEntrada;
                        Tabla."Cantidad Salida" := TotalCantidadSalida;
                        Tabla."Cantidad Pendiente Salida" := TotalCantidadPendienteSalida;
                        Tabla.Insert(true);
                    end;
                    Clear(TotalCantidad);
                    Clear(TotalCantidadPendiente);
                    Clear(TotalCantidadEntrada);
                    Clear(TotalCantidadPendienteEntrada);
                    Clear(TotalCantidadSalida);
                    Clear(TotalCantidadPendienteSalida);
                    OldItem := rMovProducto."Item No.";
                    OldLocation := rMovProducto."Location Code";
                end;

                TotalCantidad += rMovProducto.Quantity;
                TotalCantidadPendiente += rMovProducto."Remaining Quantity";
                if rMovProducto.Positive then begin
                    TotalCantidadEntrada += rMovProducto.Quantity;
                    TotalCantidadPendienteEntrada += rMovProducto."Remaining Quantity";
                end
                else begin
                    TotalCantidadSalida += rMovProducto.Quantity;
                    TotalCantidadPendienteSalida += rMovProducto."Remaining Quantity";
                end;
                Contador += 1;
                Ventana.Update(1, Contador);
                Ventana.Update(2, Round(Contador / TotalContador * 10000, 1));
            until rMovProducto.Next = 0;
        end;

        Ventana.Close;
        if not pValidar then
            Message('Total inconsistencias T32: ' + Format(TotalInconsistencia));

        exit(TotalInconsistencia = 0);
    end;


    procedure CorregirT32()
    var
        Tabla: Record "Revisar Mov. Producto";
        oTipo: Option Todos,Entrada,Salida;
        lTextContador: Label 'Corrigiendo Mov Producto\MovProducto: #1########## @2@@@@@@@@@@';
        TotalContador: Integer;
        Contador: Integer;
        Ventana: Dialog;
    begin

        Clear(Contador);
        TotalContador := Tabla.Count;

        Ventana.Open(lTextContador);

        if Tabla.FindSet then begin
            repeat
                if Tabla.Quantity = 0 then
                    CerrarMovimientos(Tabla, oTipo::Todos)
                else begin
                    if Tabla.Quantity < 0 then
                        SaldoNegativo(Tabla)
                    else
                        SaldoPositivo(Tabla);
                end;
                Contador += 1;
                Ventana.Update(1, Contador);
                Ventana.Update(2, Round(Contador / TotalContador * 10000, 1));

            until Tabla.Next = 0;
        end;
        Ventana.Close;
        //ERROR('Finalizado');
    end;


    procedure CerrarMovimientos(var parTabla: Record "Revisar Mov. Producto"; pTipo: Option Todos,Entrada,Salida)
    var
        rMovProducto: Record "Item Ledger Entry";
    begin

        rMovProducto.Reset;
        rMovProducto.SetCurrentKey("Item No.", Positive, "Location Code", "Variant Code");
        rMovProducto.SetRange("Item No.", parTabla."Item Code");
        rMovProducto.SetRange("Location Code", parTabla."Location Code");
        case pTipo of
            pTipo::Entrada:
                rMovProducto.SetRange(Positive, true);
            pTipo::Salida:
                rMovProducto.SetRange(Positive, false);
        end;
        rMovProducto.SetRange(Open, true);
        rMovProducto.ModifyAll(Open, false);

        rMovProducto.Reset;
        rMovProducto.SetCurrentKey("Item No.", Positive, "Location Code", "Variant Code");
        rMovProducto.SetRange("Item No.", parTabla."Item Code");
        rMovProducto.SetRange("Location Code", parTabla."Location Code");
        case pTipo of
            pTipo::Entrada:
                rMovProducto.SetRange(Positive, true);
            pTipo::Salida:
                rMovProducto.SetRange(Positive, false);
        end;
        rMovProducto.SetFilter("Remaining Quantity", '<>%1', 0);
        rMovProducto.ModifyAll("Remaining Quantity", 0);
    end;


    procedure SaldoNegativo(var parTabla: Record "Revisar Mov. Producto")
    var
        oTipo: Option Todos,Entrada,Salida;
    begin

        //*** LAS ENTRADAS:  TIENEN QUE ESTAR NO PENDIENTES Y CANTIDAD PENDIENTE 0
        CerrarMovimientos(parTabla, oTipo::Entrada);

        //LAS SALIDAS: EL SUMATORIO DE LA CANTIDAD PENDIENTE DE LAS SALIDAS TIENE QUE IGUARLARSE CON EL SUMATORIO DE LA CANTIDAD DE TODOS LOS MOVIMIENTOS
        CorregirMovsProducto(parTabla, oTipo::Salida);
    end;


    procedure SaldoPositivo(var parTabla: Record "Revisar Mov. Producto")
    var
        rMovProducto: Record "Item Ledger Entry";
        oTipo: Option Todos,Entrada,Salida;
    begin


        //*** LAS SALIDAS:  TIENEN QUE ESTAR NO PENDIENTES Y CANTIDAD PENDIENTE 0
        CerrarMovimientos(parTabla, oTipo::Salida);

        //LAS ENTRADAS: EL SUMATORIO DE LA CANTIDAD PENDIENTE DE LAS ENTRADAS TIENE QUE IGUARLARSE CON EL SUMATORIO DE LA CANTIDAD DE TODOS LOS MOVIMIENTOS
        CorregirMovsProducto(parTabla, oTipo::Entrada);
    end;


    procedure CorregirMovsProducto(var parTabla: Record "Revisar Mov. Producto"; pTipo: Option Todos,Entrada,Salida)
    var
        rMovProducto: Record "Item Ledger Entry";
        CantPendTotalCorregir: Decimal;
        Accion: Option Agregar,Quitar;
        CantPendCorregir: Decimal;
    begin

        case pTipo of
            pTipo::Entrada:
                begin
                    CantPendTotalCorregir := (parTabla.Quantity - parTabla."Cantidad Pendiente Entrada");
                    if CantPendTotalCorregir > 0 then
                        Accion := Accion::Agregar
                    else
                        Accion := Accion::Quitar;
                end;
            pTipo::Salida:
                begin
                    CantPendTotalCorregir := (parTabla.Quantity - parTabla."Cantidad Pendiente Salida");
                    if CantPendTotalCorregir > 0 then
                        Accion := Accion::Quitar
                    else
                        Accion := Accion::Agregar;
                end;
        end;

        if CantPendTotalCorregir = 0 then
            exit;

        rMovProducto.Reset;
        rMovProducto.SetCurrentKey("Item No.", Positive, "Location Code", "Variant Code");
        rMovProducto.Ascending(false);
        rMovProducto.SetRange("Item No.", parTabla."Item Code");
        rMovProducto.SetRange("Location Code", parTabla."Location Code");
        case pTipo of
            pTipo::Entrada:
                rMovProducto.SetRange(Positive, true);
            pTipo::Salida:
                rMovProducto.SetRange(Positive, false);
        end;
        if rMovProducto.FindSet() then
            repeat
                if EvaluaMovimiento(rMovProducto, Accion) then begin
                    CantPendCorregir := EvaluaCantPendCorregir(rMovProducto, CantPendTotalCorregir, Accion, pTipo);
                    if CantPendCorregir <> 0 then begin
                        case Accion of
                            Accion::Agregar:
                                rMovProducto."Remaining Quantity" := rMovProducto."Remaining Quantity" + CantPendCorregir;
                            Accion::Quitar:
                                rMovProducto."Remaining Quantity" := rMovProducto."Remaining Quantity" - CantPendCorregir;
                        end;
                        if rMovProducto."Remaining Quantity" <> 0 then
                            rMovProducto.Open := true
                        else
                            rMovProducto.Open := false;
                        rMovProducto.Modify;
                        case Accion of
                            Accion::Agregar:
                                CantPendTotalCorregir := CantPendTotalCorregir - CantPendCorregir;
                            Accion::Quitar:
                                CantPendTotalCorregir := CantPendTotalCorregir + CantPendCorregir;
                        end;


                    end;
                end;
            until (rMovProducto.Next = 0) or (CantPendTotalCorregir = 0)
    end;


    procedure EvaluaMovimiento(rMovProducto: Record "Item Ledger Entry"; Accion: Option Agregar,Quitar): Boolean
    begin

        case Accion of
            Accion::Agregar:
                exit(rMovProducto.Quantity <> rMovProducto."Remaining Quantity");
            Accion::Quitar:
                exit(rMovProducto."Remaining Quantity" <> 0);
        end;
    end;


    procedure EvaluaCantPendCorregir(pMovProducto: Record "Item Ledger Entry"; pCantPendTotalCorregir: Decimal; pAccion: Option Agregar,Quitar; pTipo: Option Todos,Entrada,Salida) rtnValue: Decimal
    begin

        case pAccion of
            pAccion::Agregar:
                begin
                    case pTipo of
                        pTipo::Entrada:
                            begin
                                if (pMovProducto.Quantity - pMovProducto."Remaining Quantity") >= pCantPendTotalCorregir then
                                    rtnValue := pCantPendTotalCorregir
                                else
                                    rtnValue := (pMovProducto.Quantity - pMovProducto."Remaining Quantity");
                            end;
                        pTipo::Salida:
                            begin
                                if (pMovProducto.Quantity - pMovProducto."Remaining Quantity") <= pCantPendTotalCorregir then
                                    rtnValue := pCantPendTotalCorregir
                                else
                                    rtnValue := (pMovProducto.Quantity - pMovProducto."Remaining Quantity");
                            end;
                    end;
                end;
            pAccion::Quitar:
                begin
                    case pTipo of
                        pTipo::Entrada:
                            begin
                                if (pMovProducto."Remaining Quantity") >= -pCantPendTotalCorregir then
                                    rtnValue := -pCantPendTotalCorregir
                                else
                                    rtnValue := pMovProducto."Remaining Quantity";
                            end;
                        pTipo::Salida:
                            begin
                                if (pMovProducto."Remaining Quantity") <= -pCantPendTotalCorregir then
                                    rtnValue := -pCantPendTotalCorregir
                                else
                                    rtnValue := pMovProducto."Remaining Quantity";
                            end;
                    end;
                end;
        end;
    end;


    procedure InconsistenciaT32(pTest: Boolean)
    var
        Err001: Label 'El proceso de corrección no ha corregido las inconsistencias t32.';
    begin

        if not pTest then
            CorregirMarcaPendiente;

        CheckT32(false);

        if not pTest then begin
            CorregirT32;
            if not CheckT32(true) then
                Error(Err001);
        end;
    end;


    procedure CorregirMarcaPendiente()
    var
        rMovProducto: Record "Item Ledger Entry";
        lTextContador: Label 'Corrigiendo Marca Pendiente en Mov Producto\MovProducto: #1########## @2@@@@@@@@@@';
        Contador: Integer;
        TotalContador: Integer;
        Ventana: Dialog;
    begin

        Clear(Contador);
        TotalContador := rMovProducto.Count;

        Ventana.Open(lTextContador);

        if rMovProducto.FindSet then
            repeat

                if ((rMovProducto.Quantity) < (rMovProducto."Remaining Quantity")) and (rMovProducto.Quantity > 0) then begin
                    rMovProducto."Remaining Quantity" := rMovProducto.Quantity;
                    rMovProducto.Modify;
                end;

                if ((rMovProducto.Quantity) > (rMovProducto."Remaining Quantity")) and (rMovProducto.Quantity < 0) then begin
                    rMovProducto."Remaining Quantity" := rMovProducto.Quantity;
                    rMovProducto.Modify;
                end;

                if (rMovProducto."Remaining Quantity" = 0) and (rMovProducto.Open) then begin
                    rMovProducto.Open := false;
                    rMovProducto.Modify;
                end;

                if (rMovProducto."Remaining Quantity" <> 0) and (not rMovProducto.Open) then begin
                    rMovProducto.Open := true;
                    rMovProducto.Modify;

                end;
                Contador += 1;
                Ventana.Update(1, Contador);
                Ventana.Update(2, Round(Contador / TotalContador * 10000, 1));
            until rMovProducto.Next = 0;
        Ventana.Close;
    end;


    procedure InconsistenciaT32_T339(pTest: Boolean)
    var
        Err001: Label 'El proceso de corrección no ha corregido las inconsistencias t32-t339.';
    begin

        CheckT32_T339(false);
        if not pTest then begin
            CorregirT32_T339;
            if not CheckT32_T339(true) then
                Error(Err001);
        end;
    end;


    procedure CheckT32_T339(pValidar: Boolean): Boolean
    var
        rMovProducto: Record "Item Ledger Entry";
        lTextContador: Label 'Comparando tabla Item Ledger Entry contra Appl. Ledger Entry \MovProducto: #1########## @2@@@@@@@@@@';
        Contador: Integer;
        TotalContador: Integer;
        Ventana: Dialog;
        Cantidad_IAE: Decimal;
        lTextContador2: Label 'Validando tabla Item Ledger Entry contra Appl. Ledger Entry \MovProducto: #1########## @2@@@@@@@@@@';
        Error001: Label 'No se ha podido corregir las inconsistencias entre la tabla Item Ledger Entry y Application Ledger Entry';
        TotIncons: Decimal;
        Tabla: Record "Revisar Mov. Producto";
        CantSaldo: Decimal;
        CantInicial: Decimal;
        CantLiq: Decimal;
    begin

        Tabla.DeleteAll;

        Clear(TotIncons);
        Clear(Contador);
        rMovProducto.SetRange(Positive, true);
        if not rMovProducto.FindSet then
            exit(true);

        TotalContador := rMovProducto.Count;

        if pValidar then
            Ventana.Open(lTextContador2)
        else
            Ventana.Open(lTextContador);


        if rMovProducto.FindSet then
            repeat
                Clear(CantSaldo);
                Clear(CantInicial);
                Clear(CantLiq);
                Cantidad_ItemAppEntry(rMovProducto, CantSaldo, CantInicial, CantLiq);
                if (rMovProducto."Remaining Quantity" <> CantSaldo) then begin
                    TotIncons := TotIncons + 1;
                    Tabla.Init;
                    Tabla.Fecha := rMovProducto."Posting Date";
                    Tabla."No. Mov" := rMovProducto."Entry No.";
                    Tabla."Item Code" := rMovProducto."Item No.";
                    Tabla."Location Code" := rMovProducto."Location Code";
                    Tabla.Quantity := rMovProducto.Quantity;
                    Tabla."Remaining Quantity" := rMovProducto."Remaining Quantity";
                    Tabla."Cantidad Saldo IAE" := CantSaldo;
                    Tabla.Diferencia := Tabla."Remaining Quantity" - Tabla."Cantidad Saldo IAE";
                    Tabla."Cantidad Inicial IAE" := CantInicial;
                    Tabla."Cantidad Liq IAE" := CantLiq;
                    Tabla.Insert(true);
                end;
                Contador += 1;
                Ventana.Update(1, Contador);
                Ventana.Update(2, Round(Contador / TotalContador * 10000, 1));
            until rMovProducto.Next = 0;
        Ventana.Close;

        if not pValidar then
            Message('Inconsistencias T32-T339: ' + Format(TotIncons));


        exit(TotIncons = 0);
    end;


    procedure Cantidad_ItemAppEntry(pMov: Record "Item Ledger Entry"; var pCantSaldo: Decimal; var pCantInicial: Decimal; var pCantLiq: Decimal)
    var
        rItemAppEntry: Record "Item Application Entry";
    begin
        Clear(pCantSaldo);
        Clear(pCantInicial);
        Clear(pCantLiq);
        rItemAppEntry.Reset;
        if pMov.Positive then begin
            rItemAppEntry.SetCurrentKey("Inbound Item Entry No.", "Item Ledger Entry No.", "Outbound Item Entry No.", "Cost Application");
            rItemAppEntry.SetRange("Inbound Item Entry No.", pMov."Entry No.");
        end
        else begin
            rItemAppEntry.SetCurrentKey("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application", "Transferred-from Entry No.");
            rItemAppEntry.SetRange("Outbound Item Entry No.", pMov."Entry No.");
        end;
        if rItemAppEntry.FindSet then
            repeat
                if pMov.Positive then begin
                    if rItemAppEntry."Item Ledger Entry No." = rItemAppEntry."Inbound Item Entry No." then
                        pCantInicial := pCantInicial + rItemAppEntry.Quantity
                    else
                        pCantLiq := pCantLiq + rItemAppEntry.Quantity;
                end
                else begin
                    if rItemAppEntry."Item Ledger Entry No." = rItemAppEntry."Outbound Item Entry No." then
                        pCantInicial := pCantInicial + rItemAppEntry.Quantity
                    else
                        pCantLiq := pCantLiq + rItemAppEntry.Quantity;
                end;
                pCantSaldo := pCantSaldo + rItemAppEntry.Quantity;
            until rItemAppEntry.Next = 0;
    end;


    procedure CorregirT339(pTabla: Record "Revisar Mov. Producto")
    var
        rItemAppEntry: Record "Item Application Entry";
        rMov: Record "Item Ledger Entry";
    begin

        rMov.Get(pTabla."No. Mov");
        rItemAppEntry.Init;
        rItemAppEntry."Entry No." := UltimoItemApplEntry + 1;
        //rItemAppEntry."Item Ledger Entry No." :=
        if rMov.Positive then
            rItemAppEntry."Inbound Item Entry No." := rMov."Entry No."
        else
            rItemAppEntry."Outbound Item Entry No." := rMov."Entry No.";
        rItemAppEntry.Quantity := pTabla."Remaining Quantity" - pTabla."Cantidad Saldo IAE";
        rItemAppEntry."Posting Date" := pTabla.Fecha;
        rItemAppEntry."Cost Application" := rMov.Positive;
        rItemAppEntry."Created By User" := 'CORRECCION';
        rItemAppEntry.Insert;
    end;


    procedure CorregirT32_T339()
    var
        lTextContador: Label 'Comparando tabla Item Ledger Entry contra Appl. Ledger Entry \MovProducto: #1########## @2@@@@@@@@@@';
        Contador: Integer;
        TotalContador: Integer;
        Ventana: Dialog;
        lTextContador2: Label 'Validando tabla Item Ledger Entry contra Appl. Ledger Entry \MovProducto: #1########## @2@@@@@@@@@@';
        Error001: Label 'No se ha podido corregir las inconsistencias entre la tabla Item Ledger Entry y Application Ledger Entry';
        Tabla: Record "Revisar Mov. Producto";
    begin


        Clear(Contador);
        TotalContador := Tabla.Count;

        Ventana.Open(lTextContador);

        if Tabla.FindSet then begin
            repeat
                CorregirT339(Tabla);
                Contador += 1;
                Ventana.Update(1, Contador);
                Ventana.Update(2, Round(Contador / TotalContador * 10000, 1));
            until Tabla.Next = 0;
        end;
        Ventana.Close;
        //ERROR('Finalizado');
    end;


    procedure UltimoItemApplEntry() rtnValue: Integer
    var
        rItemAppEntry: Record "Item Application Entry";
    begin

        Clear(rtnValue);
        rItemAppEntry.Reset;
        if rItemAppEntry.FindLast then
            rtnValue := rItemAppEntry."Entry No.";
    end;


    procedure ExcluirMov(pMov: Record "Item Ledger Entry"; pCantSaldo: Decimal): Boolean
    begin

        if (not pMov.Positive) and (pMov.Quantity = pMov."Remaining Quantity") and (pCantSaldo = 0) then
            exit(true);

        exit(false);
    end;


    procedure InconsistenciaT32_T7312(pTest: Boolean)
    var
        Err001: Label 'El proceso de corrección no ha corregido las inconsistencias t32-t7312.';
    begin


        CheckT32_T7312(false);
        if not pTest then begin
            CorregirT32_T7312;
            if not CheckT32_T7312(true) then
                Error(Err001);
        end;
    end;


    procedure CheckT32_T7312(pValidar: Boolean): Boolean
    var
        rMovProducto: Record "Item Ledger Entry";
        lTextContador: Label 'Comparando tabla Item Ledger Entry contra Warehouse Entry \MovProducto: #1########## @2@@@@@@@@@@';
        Contador: Integer;
        TotalContador: Integer;
        Ventana: Dialog;
        lTextContador2: Label 'Validando tabla Item Ledger Entry contra Warehouse Entry \MovProducto: #1########## @2@@@@@@@@@@';
        Error001: Label 'No se ha podido corregir las inconsistencias entre la tabla Item Ledger Entry y Warehouse Entry';
        TotIncons: Decimal;
        Tabla: Record "Revisar Mov. Producto";
        rWHE: Record "Warehouse Entry";
    begin

        Tabla.DeleteAll;

        Clear(TotIncons);
        Clear(Contador);
        rWHE.Reset;
        rWHE.SetRange("Reference Document", rWHE."Reference Document"::"Posted Shipment");
        if not rWHE.FindSet then
            exit(true);

        TotalContador := rWHE.Count;

        if pValidar then
            Ventana.Open(lTextContador2)
        else
            Ventana.Open(lTextContador);


        if rWHE.FindSet then
            repeat
                rMovProducto.Reset;
                rMovProducto.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
                rMovProducto.SetRange(rMovProducto."Document No.", rWHE."Reference No.");
                rMovProducto.SetRange(rMovProducto."Item No.", rWHE."Item No.");
                rMovProducto.SetRange(rMovProducto."Location Code", rWHE."Location Code");
                if not rMovProducto.FindSet then begin
                    TotIncons := TotIncons + 1;
                    Tabla.Init;
                    Tabla.Fecha := rWHE."Registering Date";
                    Tabla."No. Mov" := rWHE."Entry No.";
                    Tabla."Item Code" := rWHE."Item No.";
                    Tabla."Location Code" := rWHE."Location Code";
                    Tabla.Quantity := rWHE.Quantity;
                    Tabla.Documento := rWHE."Reference No.";
                    Tabla.Insert(true);
                end;
                Contador += 1;
                Ventana.Update(1, Contador);
                Ventana.Update(2, Round(Contador / TotalContador * 10000, 1));
            until rWHE.Next = 0;
        Ventana.Close;

        if not pValidar then
            Message('Inconsistencias T32-T7312: ' + Format(TotIncons));


        exit(TotIncons = 0);
    end;


    procedure CorregirT32_T7312()
    var
        lTextContador: Label 'Comparando tabla Item Ledger Entry contra Appl. Ledger Entry \MovProducto: #1########## @2@@@@@@@@@@';
        Contador: Integer;
        TotalContador: Integer;
        Ventana: Dialog;
        lTextContador2: Label 'Validando tabla Item Ledger Entry contra Appl. Ledger Entry \MovProducto: #1########## @2@@@@@@@@@@';
        Error001: Label 'No se ha podido corregir las inconsistencias entre la tabla Item Ledger Entry y Application Ledger Entry';
        Tabla: Record "Revisar Mov. Producto";
        rWHE: Record "Warehouse Entry";
    begin


        Clear(Contador);
        TotalContador := Tabla.Count;

        Ventana.Open(lTextContador);

        if Tabla.FindSet then begin
            repeat
                rWHE.Get(Tabla."No. Mov");
                if (Tabla.Documento = rWHE."Reference No.") and (Tabla."Item Code" = rWHE."Item No.") then
                    rWHE.Delete
                else
                    Error('Error');
                Contador += 1;
                Ventana.Update(1, Contador);
                Ventana.Update(2, Round(Contador / TotalContador * 10000, 1));
            until Tabla.Next = 0;
        end;
        Ventana.Close;
        //ERROR('Finalizado');
    end;
}

