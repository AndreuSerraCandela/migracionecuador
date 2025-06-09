codeunit 76042 "Proceso Retenciones"
{
    // DSLoc1.02   GRN     23/06/2010    Modificamos la forma de calcular las retenciones para que no
    //                                   estemos obligados a lanzar el documento antes de calcularla.
    // 
    // Parametros para el calculo de la retencion:
    // 1. Si almenos en las lineas del documento hay una cuenta se calcula la retencion para todas las que esten configuradas
    //    aplica servicio.
    // 
    // 2. Si solo hay productos en las lineas del documento se calcula la retencion para todas las que esten configuradas
    //    aplica producto.
    // 
    // $001        JML     10/01/2015    Comprobentes electrónicos.
    //                                   Obtenemos datos Comprobante fiscal de la Retención en el momento del registro de las retenciones.
    // $002        JML     28/01/2015    Añado nº de serie de NCF para facturación electrónica.
    // #34584      MOI     26/10/2015    Se amplia el tamaño de la variable codNCF de 9 a 20.

    TableNo = "Purchase Header";

    trigger OnRun()
    begin

        rPurchHeader.Copy(Rec);
        RD.Reset;
        RD.SetRange("Cód. Proveedor", rPurchHeader."Pay-to Vendor No.");
        RD.SetRange("Tipo documento", rPurchHeader."Document Type");
        RD.SetRange("No. documento", rPurchHeader."No.");
        if RD.FindSet then begin
            repeat
                if (rPurchHeader."Document Type" = rPurchHeader."Document Type"::Invoice) or
                   (rPurchHeader."Document Type" = rPurchHeader."Document Type"::Order) then begin
                    if RD.Devengo = 0 then
                        RetieneAlFacturarNew(RD);
                end
                else
                    if rPurchHeader."Document Type" = rPurchHeader."Document Type"::"Credit Memo" then
                        if RD.Devengo = 0 then
                            RetieneAlAbonarNew(RD);
            until RD.Next = 0;
        end;
    end;

    var
        rGenJnlLine: Record "Gen. Journal Line";
        rPurchHeader: Record "Purchase Header";
        rProvRetencion: Record "Proveedor - Retencion";
        rPurchSetup: Record "Purchases & Payables Setup";
        NoLinea: Integer;
        cGenJnlPost: Codeunit "Gen. Jnl.-Post";
        rPurchInvheader: Record "Purch. Inv. Header";
        rPurchaseLines: Record "Purch. Inv. Line";
        rGenJnlTemplate: Record "Gen. Journal Template";
        rGenJnlBatch: Record "Gen. Journal Batch";
        rComprasYPagos: Record "Purchases & Payables Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        rConfRet: Record "Config. Retencion Proveedores";
        ConfSant: Record "Config. Empresa";
        RD: Record "Retencion Doc. Proveedores";
        VLE: Record "Vendor Ledger Entry";
        NoSerLine: Record "No. Series Line";
        BaseRet: Decimal;
        RetDocReg: Record "Retencion Doc. Reg. Prov.";
        HistRet: Record "Historico Retencion Prov.";
        Text001: Label 'El tipo de comprobante de la serie de rentención %1 debe ser 07 Comprobante de rentención';
        codEstablecimiento: Code[3];
        codPuntoEmision: Code[3];
        codNCF: Code[20];
        codSerieNCF: Code[10];


    procedure RetieneAlFacturar(rProveedorRetencion: Record "Proveedor - Retencion")
    var
        rGenJnlLine2: Record "Gen. Journal Line";
        rGenJnlLine3: Record "Gen. Journal Line";
        rPurchLine: Record "Purchase Line";
        Itbis: Decimal;
        BImponible: Decimal;
        TotalFra: Decimal;
        Importe: Decimal;
        ImporteRet: Decimal;
    begin
        Clear(Itbis);
        Clear(BImponible);
        Clear(TotalFra);
        Clear(Importe);

        rPurchSetup.Get();

        if rProveedorRetencion."Importe Retención" <> 0 then begin
            rGenJnlLine.Init;
            rGenJnlLine."Account Type" := rGenJnlLine."Account Type"::Vendor;
            rGenJnlLine.Validate("Posting Date", rPurchHeader."Posting Date");
            rGenJnlLine.Validate("Account No.", rProveedorRetencion."Cód. Proveedor");
            rGenJnlLine.Validate("Currency Code", rPurchHeader."Currency Code");
            rGenJnlLine."Document Type" := rGenJnlLine."Document Type"::Payment;
            rGenJnlLine."Document No." := Format(rPurchHeader."Last Posting No.");
            rGenJnlLine.Validate("Bal. Account Type", rGenJnlLine."Bal. Account Type"::"G/L Account");
            rProveedorRetencion.TestField("Cta. Contable");
            rGenJnlLine.Validate("Bal. Account No.", rProveedorRetencion."Cta. Contable");
            rGenJnlLine.Validate("Applies-to Doc. Type", rGenJnlLine."Applies-to Doc. Type"::Invoice);
            rGenJnlLine.Validate("Applies-to Doc. No.", rPurchHeader."Last Posting No.");
            rGenJnlLine."System-Created Entry" := true;
            rGenJnlLine."Retencion ITBIS" := rProveedorRetencion."Retencion IVA";

            rPurchLine.Reset;
            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
            rPurchLine.FindSet;
            repeat
                TotalFra += rPurchLine."Amount Including VAT"
            until rPurchLine.Next = 0;

            rConfRet.Get(rProveedorRetencion."Código Retención");
            if TotalFra >= rConfRet."Mayor de" then begin

                case rProveedorRetencion."Base Cálculo" of
                    0:
                        if rProveedorRetencion."Tipo Retención" = rProveedorRetencion."Tipo Retención"::Porcentaje then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            rPurchLine.FindSet;
                            repeat
                                Itbis += rPurchLine."Amount Including VAT" - rPurchLine.Amount
                            until rPurchLine.Next = 0;

                            rGenJnlLine."Debit Amount" := Itbis * rProveedorRetencion."Importe Retención" / 100;
                        end;
                    1:
                        if rProveedorRetencion."Tipo Retención" = rProveedorRetencion."Tipo Retención"::Porcentaje then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            rPurchLine.FindSet;
                            repeat
                                BImponible += rPurchLine.Amount
                            until rPurchLine.Next = 0;

                            rGenJnlLine."Debit Amount" := BImponible * rProveedorRetencion."Importe Retención" / 100;
                        end;
                    2:
                        if rProveedorRetencion."Tipo Retención" = rProveedorRetencion."Tipo Retención"::Porcentaje then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            rPurchLine.FindSet;
                            repeat
                                TotalFra += rPurchLine."Amount Including VAT";
                            until rPurchLine.Next = 0;

                            rGenJnlLine."Debit Amount" := TotalFra * rProveedorRetencion."Importe Retención" / 100;
                        end;
                    3:
                        if rProveedorRetencion."Tipo Retención" = rProveedorRetencion."Tipo Retención"::Importe then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            rPurchLine.FindSet;
                            repeat
                                Importe += rPurchLine."Amount Including VAT";
                            until rPurchLine.Next = 0;

                            rGenJnlLine."Debit Amount" := Importe - rProveedorRetencion."Importe Retención";
                        end;
                end;

                rGenJnlLine.Validate("Debit Amount");
                ImporteRet := rGenJnlLine."Debit Amount";
                rGenJnlLine."Dimension Set ID" := AñadirDimensionesNoGlobales(rGenJnlLine."Dimension Set ID", rPurchHeader."Dimension Set ID");
                if rGenJnlLine."Debit Amount" <> 0 then begin
                    GenJnlPostLine.RunWithCheck(rGenJnlLine);
                    InsertaHistRetDoc(rProveedorRetencion, ImporteRet);
                end;
            end;
        end;
    end;


    procedure RetieneAlPagar(rPurchInvHeader: Record "Purch. Inv. Header"; ImporteRetenido: Decimal; Documentos: Code[100])
    var
        rGenJnlLine2: Record "Gen. Journal Line";
        rPurchLine: Record "Purch. Inv. Line";
        Itbis: Decimal;
        "Base Imponible": Decimal;
        TotalFra: Decimal;
        Importe: Decimal;
    begin
        /*GRN Revisar luego
        rProvRetencion.RESET;
        rProvRetencion.SETRANGE("Cód. Proveedor",rPurchInvHeader."Buy-from Vendor No.");
        IF rProvRetencion.FINDFIRST THEN
           BEGIN
            IF rProvRetencion.Devengo = rProvRetencion.Devengo::Pago THEN
               BEGIN
                CLEAR(NoLinea);
                CLEAR(Itbis);
        
                rPurchSetup.GET();
                rPurchSetup.TESTFIELD("Nombre libro diario Retencion");
                rPurchSetup.TESTFIELD("Nombre Secc. diario Retencion");
        
                rGenJnlLine2.RESET;
                rGenJnlLine2.SETRANGE("Journal Template Name",rPurchSetup."Nombre libro diario Retencion");
                rGenJnlLine2.SETRANGE("Journal Batch Name",rPurchSetup."Nombre Secc. diario Retencion");
                IF rGenJnlLine2.FINDLAST THEN
                  NoLinea := rGenJnlLine2."Line No." + 1000
                ELSE
                  NoLinea := 1000;
        
                rGenJnlLine.INIT;
                rGenJnlLine.VALIDATE("Journal Template Name",rPurchSetup."Nombre libro diario Retencion");
                rGenJnlLine.VALIDATE("Journal Batch Name",rPurchSetup."Nombre Secc. diario Retencion");
                rGenJnlLine."Line No."                   := NoLinea;
                rGenJnlLine.VALIDATE("Shortcut Dimension 1 Code",rPurchInvHeader."Shortcut Dimension 1 Code");
                rGenJnlLine.VALIDATE("Shortcut Dimension 2 Code",rPurchInvHeader."Shortcut Dimension 2 Code");
                rGenJnlLine.VALIDATE("Account Type",rGenJnlLine."Account Type"::Vendor);
                rGenJnlLine.VALIDATE("Account No.",rPurchInvHeader."Buy-from Vendor No.");
        
                //AMS
                rGenJnlLine.VALIDATE("Currency Code",rPurchInvHeader."Currency Code");
        
                rGenJnlLine.VALIDATE("Account No.");
                rGenJnlLine.VALIDATE("Posting Date",WORKDATE);
                rGenJnlLine.VALIDATE("Document Type",rGenJnlLine."Document Type"::Payment);
                rGenJnlLine."Document No."               := 'RETENCION';
                rGenJnlLine.Description                  := 'Ret-' + Documentos;
                rGenJnlLine.VALIDATE("Bal. Account Type",rGenJnlLine."Bal. Account Type"::"G/L Account");
                rProveedorRetencion.testfield("Cta. Contable");
                rGenJnlLine.VALIDATE("Bal. Account No.",rProvRetencion."Cta. Contable");
                rGenJnlLine.VALIDATE("Applies-to Doc. Type",rGenJnlLine."Applies-to Doc. Type"::Invoice);
                rGenJnlLine.VALIDATE("Applies-to Doc. No.",rPurchInvHeader."No.");
                rGenJnlLine.VALIDATE("Debit Amount",ImporteRetenido);
                rGenJnlLine.INSERT;
              END;
        
          END;
        */

    end;


    procedure BuscaDeducc(rPurchInvHeader: Record "Purch. Inv. Header"; "%Apagar": Decimal): Decimal
    var
        rGenJnlLine2: Record "Gen. Journal Line";
        rPurchLine: Record "Purch. Inv. Line";
        Itbis: Decimal;
        "Base Imponible": Decimal;
        TotalFra: Decimal;
        Importe: Decimal;
    begin
        /*GRN Revisar luego
        rProvRetencion.RESET;
        rProvRetencion.SETRANGE("Cód. Proveedor",rPurchInvHeader."Buy-from Vendor No.");
        IF rProvRetencion.FINDSET THEN
          IF rProvRetencion.Devengo = rProvRetencion.Devengo::Pago THEN
            REPEAT
              CLEAR(NoLinea);
              CLEAR(Itbis);
        
              rPurchSetup.GET();
              rPurchSetup.TESTFIELD("Nombre libro diario Retencion");
              rPurchSetup.TESTFIELD("Nombre Secc. diario Retencion");
        
              CASE rProvRetencion."Base Cálculo" OF
                0:
                  BEGIN
                    IF rProvRetencion."Tipo Retención" = rProvRetencion."Tipo Retención"::Porcentaje THEN
                      BEGIN
                        rPurchLine.RESET;
                        rPurchLine.SETRANGE("Document No.",rPurchInvHeader."No.");
                        IF rPurchLine.FINDSET THEN
                          REPEAT
                            Itbis += rPurchLine."Amount Including VAT" - rPurchLine.Amount;
                          UNTIL rPurchLine.NEXT = 0;
        
                        IF "%Apagar" = 100 THEN
                          EXIT(Itbis * rProvRetencion."Importe Retención" / 100)
                        ELSE
                          BEGIN
                            Itbis := Itbis * rProvRetencion."Importe Retención" / 100;
                            EXIT(Itbis * "%Apagar" / 100);
                          END;
                      END;
                  END;
                1:
                  BEGIN
                    IF rProvRetencion."Tipo Retención" = rProvRetencion."Tipo Retención"::Porcentaje THEN
                      BEGIN
                        rPurchLine.RESET;
                        rPurchLine.SETRANGE("Document No.",rPurchInvHeader."No.");
                        IF rPurchLine.FINDSET THEN
                          REPEAT
                            "Base Imponible" +=  rPurchLine.Amount;
                          UNTIL rPurchLine.NEXT = 0;
        
                        IF "%Apagar" = 100 THEN
                          EXIT("Base Imponible" * rProvRetencion."Importe Retención" / 100)
                        ELSE
                          BEGIN
                            "Base Imponible" := "Base Imponible" * rProvRetencion."Importe Retención" / 100;
                            EXIT("Base Imponible" * "%Apagar" / 100);
                          END;
                      END;
                  END;
                2:
                  BEGIN
                    IF rProvRetencion."Tipo Retención" = rProvRetencion."Tipo Retención"::Porcentaje THEN
                      BEGIN
                        rPurchLine.RESET;
                        rPurchLine.SETRANGE("Document No.",rPurchInvHeader."No.");
                        IF rPurchLine.FINDSET THEN
                          REPEAT
                            TotalFra +=  rPurchLine."Amount Including VAT";
                          UNTIL rPurchLine.NEXT = 0;
        
                        IF "%Apagar" = 100 THEN
                          EXIT(TotalFra * rProvRetencion."Importe Retención" / 100)
                        ELSE
                          BEGIN
                            TotalFra := TotalFra * rProvRetencion."Importe Retención" / 100;
                            EXIT(TotalFra * "%Apagar" / 100);
                          END;
                      END;
                  END;
                3:
                  BEGIN
                    IF rProvRetencion."Tipo Retención" = rProvRetencion."Tipo Retención"::Importe THEN
                      BEGIN
                        rPurchLine.RESET;
                        rPurchLine.SETRANGE("Document No.",rPurchInvHeader."No.");
                        IF rPurchLine.FINDSET THEN
                          REPEAT
                            Importe +=  rPurchLine."Amount Including VAT";
                          UNTIL rPurchLine.NEXT = 0;
        
                        EXIT(Importe - rProvRetencion."Importe Retención");
                      END;
                  END;
              END;
        
            UNTIL rProvRetencion.NEXT = 0;
        */

    end;


    procedure RetieneAlAbonar(rProveedorRetencion: Record "Proveedor - Retencion")
    var
        rGenJnlLine2: Record "Gen. Journal Line";
        rPurchLine: Record "Purchase Line";
        Itbis: Decimal;
        "Base Imponible": Decimal;
        TotalFra: Decimal;
        Importe: Decimal;
        ImporteRet: Decimal;
    begin
        Clear(Itbis);
        Clear("Base Imponible");
        Clear(TotalFra);
        Clear(Importe);

        rPurchSetup.Get();

        if rProveedorRetencion."Importe Retención" <> 0 then begin
            rGenJnlLine.Init;
            rGenJnlLine."Account Type" := rGenJnlLine."Account Type"::Vendor;
            rGenJnlLine.Validate("Posting Date", rPurchHeader."Posting Date");
            rGenJnlLine.Validate("Account No.", rProveedorRetencion."Cód. Proveedor");
            rGenJnlLine.Validate("Currency Code", rPurchHeader."Currency Code");
            rGenJnlLine."Document Type" := rGenJnlLine."Document Type"::Payment;
            rGenJnlLine."Document No." := Format(rPurchHeader."Last Posting No.");
            rGenJnlLine.Validate("Bal. Account Type", rGenJnlLine."Bal. Account Type"::"G/L Account");
            rProveedorRetencion.TestField("Cta. Contable");
            rGenJnlLine.Validate("Bal. Account No.", rProveedorRetencion."Cta. Contable");
            rGenJnlLine.Validate("Applies-to Doc. Type", rGenJnlLine."Applies-to Doc. Type"::"Credit Memo");
            rGenJnlLine.Validate("Applies-to Doc. No.", rPurchHeader."Last Posting No.");
            rGenJnlLine."System-Created Entry" := true;
            rGenJnlLine."Retencion ITBIS" := rProveedorRetencion."Retencion IVA";

            case rProveedorRetencion."Base Cálculo" of
                0:
                    if rProveedorRetencion."Tipo Retención" = rProveedorRetencion."Tipo Retención"::Porcentaje then begin
                        rPurchLine.Reset;
                        rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                        rPurchLine.FindSet;
                        repeat
                            Itbis += rPurchLine."Amount Including VAT" - rPurchLine.Amount
                        until rPurchLine.Next = 0;

                        rGenJnlLine."Credit Amount" := Itbis * rProveedorRetencion."Importe Retención" / 100;
                    end;
                1:
                    if rProveedorRetencion."Tipo Retención" = rProveedorRetencion."Tipo Retención"::Porcentaje then begin
                        rPurchLine.Reset;
                        rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                        rPurchLine.FindSet;
                        repeat
                            "Base Imponible" += rPurchLine.Amount
                        until rPurchLine.Next = 0;

                        rGenJnlLine."Credit Amount" := "Base Imponible" * rProveedorRetencion."Importe Retención" / 100;
                    end;
                2:
                    if rProveedorRetencion."Tipo Retención" = rProveedorRetencion."Tipo Retención"::Porcentaje then begin
                        rPurchLine.Reset;
                        rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                        rPurchLine.FindSet;
                        repeat
                            TotalFra += rPurchLine."Amount Including VAT";
                        until rPurchLine.Next = 0;

                        rGenJnlLine."Credit Amount" := TotalFra * rProveedorRetencion."Importe Retención" / 100;
                    end;
                3:
                    if rProveedorRetencion."Tipo Retención" = rProveedorRetencion."Tipo Retención"::Importe then begin
                        rPurchLine.Reset;
                        rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                        rPurchLine.FindSet;
                        repeat
                            Importe += rPurchLine."Amount Including VAT";
                        until rPurchLine.Next = 0;

                        rGenJnlLine."Credit Amount" := Importe - rProveedorRetencion."Importe Retención";
                    end;
            end;

            rGenJnlLine.Validate("Credit Amount");
            ImporteRet := rGenJnlLine."Credit Amount";
            rGenJnlLine."Dimension Set ID" := AñadirDimensionesNoGlobales(rGenJnlLine."Dimension Set ID", rPurchHeader."Dimension Set ID");
            if rGenJnlLine."Credit Amount" <> 0 then begin
                GenJnlPostLine.RunWithCheck(rGenJnlLine);
                InsertaHistRetDoc(rProveedorRetencion, ImporteRet);
            end;
        end;
    end;


    procedure CalculaRetencion(rProveedorRetencionDoc: Record "Retencion Doc. Proveedores"; Itbis: Decimal; BaseImponible: Decimal; TotalFra: Decimal) wImporte: Decimal
    var
        wMonto: Decimal;
    begin
        rConfRet.Get(rProveedorRetencionDoc."Código Retención");
        if rConfRet."Mayor de" <> 0 then begin
            if TotalFra >= rConfRet."Mayor de" then begin
                case rProveedorRetencionDoc."Base Cálculo" of
                    0:
                        if rProveedorRetencionDoc."Tipo Retención" = rProveedorRetencionDoc."Tipo Retención"::Porcentaje then
                            wMonto := Itbis * rProveedorRetencionDoc."Importe Retención" / 100;
                    1:
                        if rProveedorRetencionDoc."Tipo Retención" = rProveedorRetencionDoc."Tipo Retención"::Porcentaje then
                            wMonto := BaseImponible * rProveedorRetencionDoc."Importe Retención" / 100;
                    2:
                        if rProveedorRetencionDoc."Tipo Retención" = rProveedorRetencionDoc."Tipo Retención"::Porcentaje then
                            wMonto := TotalFra * rProveedorRetencionDoc."Importe Retención" / 100;
                    3:
                        if rProveedorRetencionDoc."Tipo Retención" = rProveedorRetencionDoc."Tipo Retención"::Porcentaje then
                            wMonto := TotalFra * rProveedorRetencionDoc."Importe Retención" / 100;
                end;
            end
            else
                wMonto := 0;
        end
        else begin
            case rProveedorRetencionDoc."Base Cálculo" of
                0:
                    if rProveedorRetencionDoc."Tipo Retención" = rProveedorRetencionDoc."Tipo Retención"::Porcentaje then
                        wMonto := Itbis * rProveedorRetencionDoc."Importe Retención" / 100;
                1:
                    if rProveedorRetencionDoc."Tipo Retención" = rProveedorRetencionDoc."Tipo Retención"::Porcentaje then
                        wMonto := BaseImponible * rProveedorRetencionDoc."Importe Retención" / 100;
                2:
                    if rProveedorRetencionDoc."Tipo Retención" = rProveedorRetencionDoc."Tipo Retención"::Porcentaje then
                        wMonto := TotalFra * rProveedorRetencionDoc."Importe Retención" / 100;
                3:
                    if rProveedorRetencionDoc."Tipo Retención" = rProveedorRetencionDoc."Tipo Retención"::Porcentaje then
                        wMonto := TotalFra * rProveedorRetencionDoc."Importe Retención" / 100;
            end;

        end;

        wImporte := wMonto;
    end;


    procedure CalculaRetencionHist(rProveedorRetencionDocReg: Record "Historico Retencion Prov."; NoDoc: Code[20]) wImporte: Decimal
    var
        rPurchLine: Record "Purch. Inv. Line";
        wMonto: Decimal;
        Itbis: Decimal;
        BaseImponible: Decimal;
        TotalFra: Decimal;
        Importe: Decimal;
    begin
        case rProveedorRetencionDocReg."Base Cálculo" of
            0:
                begin
                    if rProveedorRetencionDocReg."Tipo Retención" = rProveedorRetencionDocReg."Tipo Retención"::Porcentaje then begin
                        rPurchLine.Reset;
                        rPurchLine.SetRange(rPurchLine."Document No.", NoDoc);
                        rPurchLine.SetRange("Parte del IVA", false);
                        rPurchLine.SetRange(Propina, false);
                        if rPurchLine.FindSet then
                            repeat
                                Itbis += rPurchLine."Amount Including VAT" - rPurchLine.Amount
                            until rPurchLine.Next = 0;

                        wMonto := Itbis * rProveedorRetencionDocReg."Importe Retención" / 100;
                    end;
                end;
            1:
                begin
                    if rProveedorRetencionDocReg."Tipo Retención" = rProveedorRetencionDocReg."Tipo Retención"::Porcentaje then begin
                        rPurchLine.Reset;
                        rPurchLine.SetRange("Document No.", NoDoc);
                        rPurchLine.SetRange("Parte del IVA", false);
                        rPurchLine.SetRange(Propina, false);
                        if rPurchLine.FindSet then
                            repeat
                                BaseImponible += rPurchLine.Amount
                            until rPurchLine.Next = 0;

                        wMonto := BaseImponible * rProveedorRetencionDocReg."Importe Retención" / 100;
                    end;
                end;
            2:
                begin
                    if rProveedorRetencionDocReg."Tipo Retención" = rProveedorRetencionDocReg."Tipo Retención"::Porcentaje then begin
                        rPurchLine.Reset;
                        rPurchLine.SetRange("Document No.", NoDoc);
                        rPurchLine.SetRange("Parte del IVA", false);
                        rPurchLine.SetRange(Propina, false);
                        if rPurchLine.FindSet then
                            repeat
                                TotalFra += rPurchLine."Amount Including VAT";
                            until rPurchLine.Next = 0;

                        wMonto := TotalFra * rProveedorRetencionDocReg."Importe Retención" / 100;
                    end;
                end;
            3:
                begin
                    if rProveedorRetencionDocReg."Tipo Retención" = rProveedorRetencionDocReg."Tipo Retención"::Importe then begin
                        rPurchLine.Reset;
                        rPurchLine.SetRange("Document No.", NoDoc);
                        rPurchLine.SetRange("Parte del IVA", false);
                        rPurchLine.SetRange(Propina, false);
                        if rPurchLine.FindSet then
                            repeat
                                Importe += rPurchLine."Amount Including VAT";
                            until rPurchLine.Next = 0;

                        wMonto := Importe - rProveedorRetencionDocReg."Importe Retención";
                    end;
                end;
        end;

        wImporte := wMonto;
    end;


    procedure InsertaHistRetDoc(rProveedorRetencion: Record "Proveedor - Retencion"; ImporteRet: Decimal)
    var
        rprovretenciondoc: Record "Retencion Doc. Proveedores";
        rProvRetencionDocReg: Record "Historico Retencion Prov.";
    begin
        //DSLoc1.02

        rProvRetencionDocReg.TransferFields(rProveedorRetencion);
        rProvRetencionDocReg."No. documento" := rPurchHeader."Last Posting No.";
        rProvRetencionDocReg."Importe Retenido" := ImporteRet;
        rProvRetencionDocReg.Insert;

        rprovretenciondoc.SetRange("Tipo documento", rPurchHeader."Document Type");
        rprovretenciondoc.SetRange("No. documento", rPurchHeader."No.");
        if rprovretenciondoc.FindSet(true) then
            rprovretenciondoc.DeleteAll;
        //DSLoc1.02
    end;


    procedure RetieneAlFacturarNew(RetDoc: Record "Retencion Doc. Proveedores")
    var
        rGenJnlLine2: Record "Gen. Journal Line";
        rGenJnlLine3: Record "Gen. Journal Line";
        rPurchLine: Record "Purchase Line";
        recLinSerie: Record "No. Series Line";
        Itbis: Decimal;
        BImponible: Decimal;
        TotalFra: Decimal;
        Importe: Decimal;
        ImporteRet: Decimal;
    begin
        Clear(Itbis);
        Clear(BImponible);
        Clear(TotalFra);
        Clear(Importe);
        Clear(BaseRet);

        rPurchSetup.Get();

        if (RetDoc.Devengo = RetDoc.Devengo::"Facturación") then begin

            rGenJnlLine.Init;
            rGenJnlLine."Account Type" := rGenJnlLine."Account Type"::Vendor;
            rGenJnlLine.Validate("Posting Date", rPurchHeader."Posting Date");
            rGenJnlLine.Validate("Account No.", RetDoc."Cód. Proveedor");
            rGenJnlLine.Validate("Currency Code", rPurchHeader."Currency Code");
            rGenJnlLine."Document Type" := rGenJnlLine."Document Type"::Payment;
            rGenJnlLine."Document No." := Format(rPurchHeader."Last Posting No.");
            rGenJnlLine.Validate("Bal. Account Type", rGenJnlLine."Bal. Account Type"::"G/L Account");

            if RetDoc."Importe Retención" <> 0 then begin
                RetDoc.TestField("Cta. Contable");
                rGenJnlLine.Validate("Bal. Account No.", RetDoc."Cta. Contable");
            end;

            rGenJnlLine.Validate("Applies-to Doc. Type", rGenJnlLine."Applies-to Doc. Type"::Invoice);
            rGenJnlLine.Validate("Applies-to Doc. No.", rPurchHeader."Last Posting No.");
            rGenJnlLine."System-Created Entry" := true;
            rGenJnlLine."Retencion ITBIS" := RetDoc."Retencion IVA";
            rPurchHeader.TestField("Vendor Posting Group"); //008
            rGenJnlLine."Posting Group" := rPurchHeader."Vendor Posting Group"; //008

            //Solo debe hacerlo la primera vez.
            if codNCF = '' then
                ObtenerDatosNCF;

            rGenJnlLine.Establecimiento := codEstablecimiento;
            rGenJnlLine."Punto de Emision" := codPuntoEmision;
            rGenJnlLine."No. Comprobante Fiscal" := codNCF;
            rGenJnlLine."No. serie NCF" := codSerieNCF;  //$002

            rPurchLine.Reset;
            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
            rPurchLine.FindSet;
            repeat
                TotalFra += rPurchLine."Amount Including VAT"
            until rPurchLine.Next = 0;

            rConfRet.Get(RetDoc."Código Retención");
            if TotalFra >= rConfRet."Mayor de" then begin

                case RetDoc."Base Cálculo" of
                    0:
                        if RetDoc."Tipo Retención" = RetDoc."Tipo Retención"::Porcentaje then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            rPurchLine.SetRange(Propina, false);
                            rPurchLine.FindSet;
                            repeat
                                if rPurchLine."Parte del IVA" then
                                    Itbis += (rPurchLine."Amount Including VAT" - rPurchLine.Amount) + rPurchLine.Amount
                                else
                                    Itbis += (rPurchLine."Amount Including VAT" - rPurchLine.Amount);

                            until rPurchLine.Next = 0;

                            BaseRet := Itbis;
                            ImporteRet := Itbis * RetDoc."Importe Retención" / 100;

                        end;
                    1:
                        if RetDoc."Tipo Retención" = RetDoc."Tipo Retención"::Porcentaje then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            rPurchLine.SetRange("Parte del IVA", false);
                            rPurchLine.SetRange(Propina, false);
                            rPurchLine.FindSet;
                            repeat
                                BImponible += rPurchLine.Amount
                            until rPurchLine.Next = 0;

                            BaseRet := BImponible;
                            ImporteRet := BImponible * RetDoc."Importe Retención" / 100;

                        end;
                    2:
                        if RetDoc."Tipo Retención" = RetDoc."Tipo Retención"::Porcentaje then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            rPurchLine.SetRange("Parte del IVA", false);
                            rPurchLine.SetRange(Propina, false);
                            rPurchLine.FindSet;
                            repeat
                                Importe += rPurchLine."Amount Including VAT";
                            until rPurchLine.Next = 0;

                            BaseRet := Importe;
                            ImporteRet := Importe * RetDoc."Importe Retención" / 100;

                        end;
                    3:
                        if RetDoc."Tipo Retención" = RetDoc."Tipo Retención"::Porcentaje then begin
                            rPurchHeader.TestField("Base Retencion Indefinida");
                            BaseRet := rPurchHeader."Base Retencion Indefinida";
                            ImporteRet := BaseRet * RetDoc."Importe Retención" / 100;
                        end;
                end;


                if RetDoc.Redondeo = RetDoc.Redondeo::"Hacia el alza" then
                    ImporteRet := Round(ImporteRet, 1, '>');

                if RetDoc.Redondeo = RetDoc.Redondeo::"Hacia la baja" then
                    ImporteRet := Round(ImporteRet, 1, '<');

                rGenJnlLine."Debit Amount" := ImporteRet;
                rGenJnlLine.Validate("Debit Amount");
                rGenJnlLine."Dimension Set ID" := AñadirDimensionesNoGlobales(rGenJnlLine."Dimension Set ID", rPurchHeader."Dimension Set ID");

                if ImporteRet <> 0 then
                    GenJnlPostLine.RunWithCheck(rGenJnlLine);

                InsertaHistRetDocNew(RetDoc, ImporteRet, BaseRet);
                RetRegDocumento(RetDoc, ImporteRet, BaseRet);

            end;

        end;
    end;


    procedure RetieneAlAbonarNew(RetDoc: Record "Retencion Doc. Proveedores")
    var
        rGenJnlLine2: Record "Gen. Journal Line";
        rPurchLine: Record "Purchase Line";
        recLinSerie: Record "No. Series Line";
        Itbis: Decimal;
        "Base Imponible": Decimal;
        TotalFra: Decimal;
        Importe: Decimal;
        ImporteRet: Decimal;
    begin
        Clear(Itbis);
        Clear("Base Imponible");
        Clear(TotalFra);
        Clear(Importe);
        Clear(BaseRet);

        rPurchSetup.Get();

        if RetDoc."Importe Retención" <> 0 then begin
            rGenJnlLine.Init;
            rGenJnlLine."Account Type" := rGenJnlLine."Account Type"::Vendor;
            rGenJnlLine.Validate("Posting Date", rPurchHeader."Posting Date");
            rGenJnlLine.Validate("Account No.", RetDoc."Cód. Proveedor");
            rGenJnlLine.Validate("Currency Code", rPurchHeader."Currency Code");
            rGenJnlLine."Document Type" := rGenJnlLine."Document Type"::Payment;
            rGenJnlLine."Document No." := Format(rPurchHeader."Last Posting No.");
            rGenJnlLine.Validate("Bal. Account Type", rGenJnlLine."Bal. Account Type"::"G/L Account");
            RetDoc.TestField("Cta. Contable");
            rGenJnlLine.Validate("Bal. Account No.", RetDoc."Cta. Contable");
            rGenJnlLine.Validate("Applies-to Doc. Type", rGenJnlLine."Applies-to Doc. Type"::"Credit Memo");
            rGenJnlLine.Validate("Applies-to Doc. No.", rPurchHeader."Last Posting No.");
            rGenJnlLine."System-Created Entry" := true;
            rGenJnlLine."Retencion ITBIS" := RetDoc."Retencion IVA";
            rPurchHeader.TestField("Vendor Posting Group"); //008
            rGenJnlLine."Posting Group" := rPurchHeader."Vendor Posting Group"; //008

            //$031
            //    ConfSant.GET;
            //    IF ConfSant."Genera NCF en Retencion" THEN
            //      BEGIN
            //        rConfRet.GET(RetDoc."Código Retención");
            //        rConfRet.TESTFIELD("No. Serie NCF");
            //        rGenJnlLine."No. Comprobante Fiscal" := NoSerieMang.GetNextNo(rConfRet."No. Serie NCF",rPurchHeader."Posting Date",TRUE);
            //      END;

            //Solo debe hacerlo la primera vez.
            if codNCF = '' then
                ObtenerDatosNCF;

            rGenJnlLine.Establecimiento := codEstablecimiento;
            rGenJnlLine."Punto de Emision" := codPuntoEmision;
            rGenJnlLine."No. Comprobante Fiscal" := codNCF;
            //$031

            rPurchLine.Reset;
            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
            rPurchLine.SetRange("Parte del IVA", false);
            rPurchLine.SetRange(Propina, false);
            rPurchLine.FindSet;
            repeat
                TotalFra += rPurchLine."Amount Including VAT"
            until rPurchLine.Next = 0;

            rConfRet.Get(RetDoc."Código Retención");
            if TotalFra >= rConfRet."Mayor de" then begin
                case RetDoc."Base Cálculo" of
                    0:
                        if RetDoc."Tipo Retención" = RetDoc."Tipo Retención"::Porcentaje then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            //rPurchLine.SETRANGE("Parte del IVA",FALSE);
                            rPurchLine.SetRange(Propina, false);
                            rPurchLine.FindSet;
                            repeat
                                if rPurchLine."Parte del IVA" then
                                    Itbis += (rPurchLine."Amount Including VAT" - rPurchLine.Amount) + rPurchLine.Amount
                                else
                                    Itbis += (rPurchLine."Amount Including VAT" - rPurchLine.Amount);

                            until rPurchLine.Next = 0;
                            BaseRet := Itbis;
                            rGenJnlLine."Credit Amount" := Itbis * RetDoc."Importe Retención" / 100;
                        end;
                    1:
                        if RetDoc."Tipo Retención" = RetDoc."Tipo Retención"::Porcentaje then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            rPurchLine.SetRange("Parte del IVA", false);
                            rPurchLine.SetRange(Propina, false);
                            rPurchLine.FindSet;
                            repeat
                                "Base Imponible" += rPurchLine.Amount
                            until rPurchLine.Next = 0;
                            BaseRet := "Base Imponible";
                            rGenJnlLine."Credit Amount" := "Base Imponible" * RetDoc."Importe Retención" / 100;
                        end;
                    2:
                        if RetDoc."Tipo Retención" = RetDoc."Tipo Retención"::Porcentaje then begin
                            rPurchLine.Reset;
                            rPurchLine.SetRange("Document No.", rPurchHeader."No.");
                            rPurchLine.SetRange("Parte del IVA", false);
                            rPurchLine.SetRange(Propina, false);

                            rPurchLine.FindSet;
                            repeat
                                Importe += rPurchLine."Amount Including VAT";
                            until rPurchLine.Next = 0;
                            BaseRet := Importe;
                            rGenJnlLine."Credit Amount" := Importe * RetDoc."Importe Retención" / 100;
                        end;
                    3:
                        if RetDoc."Tipo Retención" = RetDoc."Tipo Retención"::Porcentaje then begin
                            rPurchHeader.TestField("Base Retencion Indefinida");
                            BaseRet := rPurchHeader."Base Retencion Indefinida";
                            rGenJnlLine."Credit Amount" := BaseRet * RetDoc."Importe Retención" / 100;
                            ;
                        end;
                end;

                if RetDoc.Redondeo = RetDoc.Redondeo::"Hacia el alza" then
                    rGenJnlLine."Credit Amount" := Round(rGenJnlLine."Credit Amount", 1, '>');
                if RetDoc.Redondeo = RetDoc.Redondeo::"Hacia la baja" then
                    rGenJnlLine."Credit Amount" := Round(rGenJnlLine."Credit Amount", 1, '<');

                rGenJnlLine.Validate("Credit Amount");
                ImporteRet := rGenJnlLine."Credit Amount";
                rGenJnlLine."Dimension Set ID" := AñadirDimensionesNoGlobales(rGenJnlLine."Dimension Set ID", rPurchHeader."Dimension Set ID");
                //AMS para evitar error en caso de que la factura no tenga ITBIS y el proveedor tenga la retencion de ITBIS configurada
                if rGenJnlLine."Credit Amount" <> 0 then begin
                    GenJnlPostLine.RunWithCheck(rGenJnlLine);
                    InsertaHistRetDocNew(RetDoc, ImporteRet, BaseRet);
                    RetRegDocumento(RetDoc, ImporteRet, BaseRet);
                end;
            end;
        end;
    end;


    procedure InsertaHistRetDocNew(RetDoc: Record "Retencion Doc. Proveedores"; ImporteRet: Decimal; Base: Decimal)
    var
        Retdoc1: Record "Retencion Doc. Proveedores";
        HistRet: Record "Historico Retencion Prov.";
    begin

        //DSLoc1.02
        HistRet.TransferFields(RetDoc);
        HistRet."No. documento" := rPurchHeader."Last Posting No.";
        HistRet."Importe Retenido" := ImporteRet;
        HistRet."Fecha Registro" := rGenJnlLine."Posting Date";
        HistRet."Importe Base Retencion" := Base;
        HistRet.Establecimiento := rGenJnlLine.Establecimiento;
        HistRet."Punto Emision" := rGenJnlLine."Punto de Emision";
        HistRet.NCF := rGenJnlLine."No. Comprobante Fiscal";
        HistRet."No. serie NCF" := rGenJnlLine."No. serie NCF";              //$002
        //$001

        HistRet."No. Documento Mov. Proveedor" := rPurchHeader."Last Posting No.";
        HistRet.Insert;

        Retdoc1.SetRange("Tipo documento", rPurchHeader."Document Type");
        Retdoc1.SetRange("No. documento", rPurchHeader."No.");
        Retdoc1.SetRange("Código Retención", HistRet."Código Retención");
        if Retdoc1.FindSet(true) then
            Retdoc1.DeleteAll;
        //DSLoc1.02
    end;


    procedure RetRegDocumento(RetDoc: Record "Retencion Doc. Proveedores"; ImporteRet: Decimal; Base: Decimal)
    var
        Retdoc1: Record "Retencion Doc. Proveedores";
        RetDocReg: Record "Retencion Doc. Reg. Prov.";
    begin
        //DSLoc1.02
        RetDocReg.TransferFields(RetDoc);
        RetDocReg."No. documento" := rPurchHeader."Last Posting No.";
        RetDocReg."Fecha Registro" := rGenJnlLine."Posting Date";
        RetDocReg."Importe Retenido" := ImporteRet;
        RetDocReg."Importe Base Retencion" := Base;

        RetDocReg.Establecimiento := rGenJnlLine.Establecimiento;
        RetDocReg."Punto Emision" := rGenJnlLine."Punto de Emision";
        RetDocReg.NCF := rGenJnlLine."No. Comprobante Fiscal";
        //$001

        RetDocReg."No. Documento Mov. Proveedor" := rPurchHeader."Last Posting No.";
        RetDocReg.Insert;

        Retdoc1.SetRange("Tipo documento", rPurchHeader."Document Type");
        Retdoc1.SetRange("No. documento", rPurchHeader."No.");
        Retdoc1.SetRange("Código Retención", RetDocReg."Código Retención");
        if Retdoc1.FindSet(true) then
            Retdoc1.DeleteAll;
        //DSLoc1.02
    end;


    procedure HabilitaNCFRet(TipoDoc_Loc: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; NoDoc_Loc: Code[20]; CodProv_Loc: Code[20]; Fecha_Loc: Date)
    begin
        RetDocReg.Reset;
        RetDocReg.SetRange("Cód. Proveedor", CodProv_Loc);
        RetDocReg.SetRange("Tipo documento", TipoDoc_Loc);
        RetDocReg.SetRange("No. documento", NoDoc_Loc);
        RetDocReg.SetRange("Fecha Registro", Fecha_Loc);
        if RetDocReg.FindSet then
            repeat

            until RetDocReg.Next = 0;
    end;


    procedure "AñadirDimensionesNoGlobales"(intPrmDimSet: Integer; "intPrmAñadirDimSet": Integer) intNewDimSet: Integer
    var
        cduDim: Codeunit DimensionManagement;
        recDimSet: Record "Dimension Set Entry";
        recTmpDimSet: Record "Dimension Set Entry" temporary;
    begin

        //Obtenemos dimensiones de la línea del diario
        cduDim.GetDimensionSet(recTmpDimSet, intPrmDimSet);

        //Añadimos nuevas dimensiones
        recDimSet.Reset;
        recDimSet.SetRange("Dimension Set ID", intPrmAñadirDimSet);
        if recDimSet.FindSet then
            repeat
                recTmpDimSet.Init;
                recTmpDimSet := recDimSet;
                if recTmpDimSet.Insert then;
            until recDimSet.Next = 0;

        //Genera nuevo ID de grupo
        intNewDimSet := cduDim.GetDimensionSetID(recTmpDimSet);
    end;


    procedure ObtenerDatosNCF()
    var
        recLinSerie: Record "No. Series Line";
        cduNoSerieMang: Codeunit "No. Series";
    begin

        rPurchHeader.TestField("No. Serie NCF Retencion");
        cduNoSerieMang.GetNoSeriesLine(recLinSerie, rPurchHeader."No. Serie NCF Retencion", rPurchHeader."Posting Date", true);
        recLinSerie.FindFirst;
        if recLinSerie."Tipo Comprobante" <> '07' then
            Error(Text001, rPurchHeader."No. Serie NCF Retencion");

        codEstablecimiento := recLinSerie.Establecimiento;
        codPuntoEmision := recLinSerie."Punto de Emision";
        codNCF := cduNoSerieMang.GetNextNo(rPurchHeader."No. Serie NCF Retencion", rPurchHeader."Posting Date", true);
        codSerieNCF := rPurchHeader."No. Serie NCF Retencion";  //$002
    end;
}

