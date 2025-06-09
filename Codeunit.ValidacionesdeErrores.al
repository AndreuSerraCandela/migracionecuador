codeunit 50117 "Validaciones de  Errores"
{

    trigger OnRun()
    begin
        /*SH.RESET;
        SH.SETRANGE("No.",'VFR6-002906');
        IF SH.FINDFIRST THEN ;
          SH.VALIDATE(Status,SH.Status::Open);
          SH.MODIFY(TRUE);*/
        // CambiaNoBorrador;


    end;

    var
        ValidarCab: Boolean;
        ValidarMedPag: Boolean;
        Errores: Text[250];
        Text01: Label 'Campos en blanco: ';
        CabVentasSIC: Record "Cab. Ventas SIC";
        SH: Record "Sales Header";
        ConfigEmpresa: Record "Config. Empresa";
        rBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        ImporteLiquidadoBanco: Decimal;
        ImporteTotalSic: Decimal;
        Message001: Label 'The invoice %1 has already been paid.';
        Message002: Label 'The sales credit memo %1 has already been settled.';
        Error003: Label '%1 está desactivado en Config. Santillana.';

    procedure RegistrarCobrosFacturaTPV(SalesInvHeader: Record "Sales Invoice Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        NoLin: Integer;
        dImporte: Integer;
        ImporteNeto: Integer;
        MediosdePagoMG: Record "Medios de Pago SIC";
        MP: Record "Medios de Pago SIC";
        ConfMediosdepagos: Record "Conf. Medios de pago";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Msg001: Label 'Liq. pago Doc. %1';
        Bancostienda: Record "Bancos tienda";
        SIH: Record "Sales Invoice Header";
        SIH2: Record "Sales Invoice Header";
        SIH3: Record "Sales Invoice Header";
        MediosdePagoMG2: Record "Flash ventas (Cantidades)";
        MPMG2: Record "Flash ventas (Cantidades)";
        SCrMLine: Record "Sales Cr.Memo Line";
        SCRM: Record "Sales Cr.Memo Header";
        SCRM2: Record "Sales Cr.Memo Header";
        MontoIva: Decimal;
        MedPagoSIC: Record "Medios de Pago SIC";
        CantMedioPago: Integer;
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        DocNo: Code[20];
        CustLedgEntryNo: Integer;
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        _CustLegEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        Error001: Label 'No se ha liquidado Factura No. %1';
    begin
        NoLin := 0;
        dImporte := 0;
        ImporteNeto := 0;

        //MediosdePagoMG.LOCKTABLE;
        MediosdePagoMG.Reset;
        MediosdePagoMG.SetCurrentKey("Tipo documento", "No. documento", "No. documento SIC");
        MediosdePagoMG.SetRange("Tipo documento", 1);
        MediosdePagoMG.SetRange("No. documento", SalesInvHeader."External Document No.");
        MediosdePagoMG.SetRange("No. documento SIC", SalesInvHeader."No. Documento SIC");
        MediosdePagoMG.SetRange(Transferido, false);//002+-
        MediosdePagoMG.SetFilter(Importe, '<>%1', 0);
        if MediosdePagoMG.FindSet then begin
            repeat
                NoLin += 10000;
                ConfMediosdepagos.Get(MediosdePagoMG."Cod. medio de pago");
                if ConfMediosdepagos.Credito then
                    exit;

                Bancostienda.Reset;
                Bancostienda.SetRange("Cod. Tienda", SalesInvHeader.Tienda);
                Bancostienda.SetRange("Cod. Divisa", '');//MediosdePagoMG."Cod. divisa"
                if Bancostienda.FindFirst then;

                Bancostienda.TestField("Cod. Banco");
                GenJnlLine.Init;
                GenJnlLine."Line No." := NoLin;
                GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine."Document No." := SalesInvHeader."No.";
                GenJnlLine."Posting Date" := SalesInvHeader."Posting Date";
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.Validate("Account No.", SalesInvHeader."Sell-to Customer No.");
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.Validate("Bal. Account No.", Bancostienda."Cod. Banco");
                GenJnlLine.Description := CopyStr(StrSubstNo(Msg001, SalesInvHeader."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MaxStrLen(GenJnlLine.Description));
                GenJnlLine.Validate("Credit Amount", MediosdePagoMG.Importe);
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                GenJnlLine.Validate("Applies-to Doc. No.", SalesInvHeader."No.");
                GenJnlLine.Validate("External Document No.", SalesInvHeader."External Document No.");//034+-
                GenJnlLine."Salespers./Purch. Code" := SalesInvHeader."Salesperson Code";
                GenJnlLine.Validate("Shortcut Dimension 1 Code", SalesInvHeader."Shortcut Dimension 1 Code");
                GenJnlLine.Validate("Shortcut Dimension 2 Code", SalesInvHeader."Shortcut Dimension 2 Code");
                //GenJnlLine.VALIDATE("No. Tarjeta",MediosdePagoMG."Refencia Pago");//034+-Se inserta en numero de tarjeta del PUnto de Venta.
                GenJnlLine.Validate("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");//034+- Se inserta la forma de pago.

                OldCustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                OldCustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                OldCustLedgEntry.SetRange("Customer No.", SalesInvHeader."Sell-to Customer No.");
                OldCustLedgEntry.SetRange(Open, true);//034+-//01/01/2024
                if OldCustLedgEntry.FindFirst then begin
                    OldCustLedgEntry.Open := true;
                    OldCustLedgEntry."Forma de Pago" := ConfMediosdepagos."Cod. Forma Pago";//034+- Para que la forma de pago del pago sea la misma que la del documento registrado.
                    OldCustLedgEntry.Modify(true);
                end;
                GenJnlPostLine.RunWithCheck(GenJnlLine);
                MediosdePagoMG.Transferido := true;//002+-
                MediosdePagoMG.Modify;
            //END; //002+-
            until MediosdePagoMG.Next = 0;

            // 002+ Se marca como liquidado si los importes coinciden
            ImporteLiquidadoBanco := 0;
            ImporteTotalSic := 0;

            // Obtener importe liquidado del banco
            rBankAccountLedgerEntry.Reset;
            rBankAccountLedgerEntry.SetRange("Document Type", rBankAccountLedgerEntry."Document Type"::Payment);
            rBankAccountLedgerEntry.SetRange("Document No.", SalesInvHeader."No.");
            //rBankAccountLedgerEntry.SETRANGE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");
            if rBankAccountLedgerEntry.FindSet then
                repeat
                    ImporteLiquidadoBanco += rBankAccountLedgerEntry."Amount (LCY)";
                until rBankAccountLedgerEntry.Next = 0;

            // Obtener importe total SIC
            MedPagoSIC.Reset;
            MedPagoSIC.SetCurrentKey("Tipo documento", "No. documento", "No. documento SIC");
            MedPagoSIC.SetRange("Tipo documento", 1);
            MedPagoSIC.SetRange("No. documento SIC", SalesInvHeader."No. Documento SIC");
            MedPagoSIC.SetFilter(Importe, '<>%1', 0);
            if MedPagoSIC.FindSet then
                repeat
                    ImporteTotalSic += MedPagoSIC.Importe;
                until MedPagoSIC.Next = 0;

            // Comparar importes y marcar como liquidado si coinciden
            if Abs(ImporteTotalSic - ImporteLiquidadoBanco) < 1 then begin
                SIH.Reset;
                SIH.SetRange("No.", SalesInvHeader."No.");
                if SIH.FindFirst then begin
                    SIH."Liquidado TPV" := true;
                    SIH.Modify;
                end;
            end;
            // 002- Se marca como liquidado si los importes coinciden
        end;
    end;

    procedure RegistrarCobrosNotaCreditoTPV(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        NoLin: Integer;
        dImporte: Integer;
        ImporteNeto: Integer;
        MediosdePagoMG: Record "Medios de Pago SIC";
        MP: Record "Medios de Pago SIC";
        ConfMediosdepagos: Record "Conf. Medios de pago";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Msg001: Label 'Liq. pago Doc. %1';
        Bancostienda: Record "Bancos tienda";
        SIH: Record "Sales Invoice Header";
        SIH2: Record "Sales Invoice Header";
        SIH3: Record "Sales Invoice Header";
        MediosdePagoMG2: Record "Flash ventas (Cantidades)";
        MPMG2: Record "Flash ventas (Cantidades)";
        SCrMLine: Record "Sales Cr.Memo Line";
        SCRM: Record "Sales Cr.Memo Header";
        SCRM2: Record "Sales Cr.Memo Header";
        MontoIva: Decimal;
        MedPagoSIC: Record "Medios de Pago SIC";
        CantMedioPago: Integer;
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        DocNo: Code[20];
        CustLedgEntryNo: Integer;
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        _CustLegEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        Errror001: Label 'No se ha liquidado NCR No. %1';
    begin
        NoLin := 0;
        dImporte := 0;
        ImporteNeto := 0;

        MediosdePagoMG.LockTable;
        MediosdePagoMG.Reset;
        MediosdePagoMG.SetCurrentKey("Tipo documento", "No. documento", "No. documento SIC");
        MediosdePagoMG.SetRange("Tipo documento", 2);
        MediosdePagoMG.SetRange("No. documento", SalesCrMemoHeader."External Document No.");
        //MediosdePagoMG.SETRANGE("No. documento",SalesCrMemoHeader."Pre-Assigned No.");
        MediosdePagoMG.SetRange("No. documento SIC", SalesCrMemoHeader."No. Documento SIC");
        MediosdePagoMG.SetRange(Transferido, false);//002+-
        MediosdePagoMG.SetFilter(Importe, '<>%1', 0);
        if MediosdePagoMG.FindSet then begin
            repeat
                NoLin += 10000;
                ConfMediosdepagos.Get(MediosdePagoMG."Cod. medio de pago");
                Bancostienda.Reset;
                Bancostienda.SetRange("Cod. Tienda", SalesCrMemoHeader.Tienda);
                Bancostienda.SetRange("Cod. Divisa", '');
                if Bancostienda.FindFirst then;
                Bancostienda.TestField("Cod. Banco");

                GenJnlLine.Init;
                GenJnlLine."Line No." := NoLin;
                GenJnlLine."Document No." := SalesCrMemoHeader."No.";
                GenJnlLine."Posting Date" := SalesCrMemoHeader."Posting Date";
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.Validate("Account No.", SalesCrMemoHeader."Sell-to Customer No.");
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.Validate("Bal. Account No.", Bancostienda."Cod. Banco");
                GenJnlLine.Description := CopyStr(StrSubstNo(Msg001, SalesCrMemoHeader."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MaxStrLen(GenJnlLine.Description));
                GenJnlLine.Validate(Amount, MediosdePagoMG.Importe);
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::"Credit Memo");
                GenJnlLine.Validate("Applies-to Doc. No.", SalesCrMemoHeader."No.");
                GenJnlLine.Validate("External Document No.", SalesCrMemoHeader."Pre-Assigned No.");
                GenJnlLine."Currency Factor" := SalesCrMemoHeader."Currency Factor";
                GenJnlLine."Salespers./Purch. Code" := SalesCrMemoHeader."Salesperson Code";
                GenJnlLine.Validate("Shortcut Dimension 1 Code", SalesCrMemoHeader."Shortcut Dimension 1 Code");
                GenJnlLine.Validate("Shortcut Dimension 2 Code", SalesCrMemoHeader."Shortcut Dimension 2 Code");
                //GenJnlLine.VALIDATE("No. Tarjeta",MediosdePagoMG."Refencia Pago");//034+-Se inserta en numero de tarjeta del PUnto de Venta.
                GenJnlLine.Validate("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");

                OldCustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                OldCustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                OldCustLedgEntry.SetRange("Customer No.", SalesCrMemoHeader."Sell-to Customer No.");
                OldCustLedgEntry.SetRange(Open, true);
                if OldCustLedgEntry.FindFirst then begin
                    OldCustLedgEntry.Positive := false;
                    OldCustLedgEntry.Open := true;//034+-
                    OldCustLedgEntry.Modify(true);
                end;

                GenJnlPostLine.RunWithCheck(GenJnlLine);
                MediosdePagoMG.Transferido := true;//002+-
                MediosdePagoMG.Modify;
            //END; //002+-
            until MediosdePagoMG.Next = 0;

            // 002+ Se marca como liquidado si los importes coinciden
            ImporteLiquidadoBanco := 0;
            ImporteTotalSic := 0;

            // Obtener importe liquidado del banco
            rBankAccountLedgerEntry.Reset;
            rBankAccountLedgerEntry.SetRange("Document Type", rBankAccountLedgerEntry."Document Type"::Refund);
            rBankAccountLedgerEntry.SetRange("Document No.", SalesCrMemoHeader."No.");
            //rBankAccountLedgerEntry.SETRANGE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");
            if rBankAccountLedgerEntry.FindSet then
                repeat
                    ImporteLiquidadoBanco += rBankAccountLedgerEntry."Amount (LCY)";
                until rBankAccountLedgerEntry.Next = 0;

            // Obtener importe total SIC
            MedPagoSIC.Reset;
            MedPagoSIC.SetCurrentKey("Tipo documento", "No. documento", "No. documento SIC");
            MedPagoSIC.SetRange("Tipo documento", 1);
            MedPagoSIC.SetRange("No. documento SIC", SalesCrMemoHeader."No. Documento SIC");
            MedPagoSIC.SetFilter(Importe, '<>%1', 0);
            if MedPagoSIC.FindSet then
                repeat
                    ImporteTotalSic += MedPagoSIC.Importe;
                until MedPagoSIC.Next = 0;

            // Comparar importes y marcar como liquidado si coinciden
            if Abs(ImporteTotalSic - ImporteLiquidadoBanco) < 1 then begin
                SCRM.Reset;
                SCRM.SetRange("No.", SalesCrMemoHeader."No.");
                if SCRM.FindFirst then begin
                    SCRM."Liquidado TPV" := true;
                    SCRM.Modify;
                end;
            end;
            // 002- Se marca como liquidado si los importes coinciden
        end;
    end;

    procedure RegistrarCobrosFacturaTPVManual(SalesInvHeader: Record "Sales Invoice Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        NoLin: Integer;
        dImporte: Integer;
        ImporteNeto: Integer;
        MediosdePagoMG: Record "Medios de Pago SIC";
        MP: Record "Medios de Pago SIC";
        ConfMediosdepagos: Record "Conf. Medios de pago";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Msg001: Label 'Liq. pago Doc. %1';
        Bancostienda: Record "Bancos tienda";
        SIH: Record "Sales Invoice Header";
        SIH2: Record "Sales Invoice Header";
        SIH3: Record "Sales Invoice Header";
        MediosdePagoMG2: Record "Flash ventas (Cantidades)";
        MPMG2: Record "Flash ventas (Cantidades)";
        SCrMLine: Record "Sales Cr.Memo Line";
        SCRM: Record "Sales Cr.Memo Header";
        SCRM2: Record "Sales Cr.Memo Header";
        MontoIva: Decimal;
        MedPagoSIC: Record "Medios de Pago SIC";
        CantMedioPago: Integer;
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        DocNo: Code[20];
        CustLedgEntryNo: Integer;
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        _CustLegEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        Error001: Label 'No existen líneas de pagos sic pendientes a liquidar para la factura %1';
        Error002: Label 'No existen líneas Medios de Pagos en tabla "Medios de Pagos SIC"';
    begin

        ConfigEmpresa.Get;
        if not ConfigEmpresa."Liquidar Factura TPV" then
            Error(Error003, (ConfigEmpresa.FieldCaption("Liquidar Factura TPV")));

        if SalesInvHeader."Liquidado TPV" then begin
            Message(Message001, SalesInvHeader."No.");
            exit;
        end;

        NoLin := 0;
        dImporte := 0;
        ImporteNeto := 0;

        MediosdePagoMG.Reset;
        MediosdePagoMG.SetCurrentKey("Tipo documento", "No. documento", "No. documento SIC");
        MediosdePagoMG.SetRange("Tipo documento", 1);
        MediosdePagoMG.SetRange("No. documento", SalesInvHeader."External Document No.");
        MediosdePagoMG.SetRange("No. documento SIC", SalesInvHeader."No. Documento SIC");
        MediosdePagoMG.SetRange(Transferido, false);//002+-
        MediosdePagoMG.SetFilter(Importe, '<>%1', 0);
        if MediosdePagoMG.FindSet then begin
            repeat
                NoLin += 10000;
                ConfMediosdepagos.Get(MediosdePagoMG."Cod. medio de pago");
                if ConfMediosdepagos.Credito then
                    exit;

                Bancostienda.Reset;
                Bancostienda.SetRange("Cod. Tienda", SalesInvHeader.Tienda);
                Bancostienda.SetRange("Cod. Divisa", '');//MediosdePagoMG."Cod. divisa"
                if Bancostienda.FindFirst then;

                Bancostienda.TestField("Cod. Banco");
                GenJnlLine.Init;
                GenJnlLine."Line No." := NoLin;
                GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine."Document No." := SalesInvHeader."No.";
                GenJnlLine."Posting Date" := SalesInvHeader."Posting Date";
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.Validate("Account No.", SalesInvHeader."Sell-to Customer No.");
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.Validate("Bal. Account No.", Bancostienda."Cod. Banco");
                GenJnlLine.Description := CopyStr(StrSubstNo(Msg001, SalesInvHeader."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MaxStrLen(GenJnlLine.Description));
                GenJnlLine.Validate("Credit Amount", MediosdePagoMG.Importe);
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                GenJnlLine.Validate("Applies-to Doc. No.", SalesInvHeader."No.");
                GenJnlLine.Validate("External Document No.", SalesInvHeader."External Document No.");//034+-
                GenJnlLine."Salespers./Purch. Code" := SalesInvHeader."Salesperson Code";
                GenJnlLine.Validate("Shortcut Dimension 1 Code", SalesInvHeader."Shortcut Dimension 1 Code");
                GenJnlLine.Validate("Shortcut Dimension 2 Code", SalesInvHeader."Shortcut Dimension 2 Code");
                //GenJnlLine.VALIDATE("No. Tarjeta",MediosdePagoMG."Refencia Pago");//034+-Se inserta en numero de tarjeta del PUnto de Venta.
                GenJnlLine.Validate("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");//034+- Se inserta la forma de pago.

                OldCustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                OldCustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                OldCustLedgEntry.SetRange("Customer No.", SalesInvHeader."Sell-to Customer No.");
                OldCustLedgEntry.SetRange(Open, true);//034+-//01/01/2024
                if OldCustLedgEntry.FindFirst then begin
                    OldCustLedgEntry.Open := true;
                    OldCustLedgEntry."Forma de Pago" := ConfMediosdepagos."Cod. Forma Pago";//034+- Para que la forma de pago del pago sea la misma que la del documento registrado.
                    OldCustLedgEntry.Modify(true);
                end;
                GenJnlPostLine.RunWithCheck(GenJnlLine);
                MediosdePagoMG.Transferido := true;//002+-
                MediosdePagoMG.Modify;
            until MediosdePagoMG.Next = 0;

            // 002+ Se marca como liquidado si los importes coinciden
            ImporteLiquidadoBanco := 0;
            ImporteTotalSic := 0;

            // Obtener importe liquidado del banco
            rBankAccountLedgerEntry.Reset;
            rBankAccountLedgerEntry.SetRange("Document Type", rBankAccountLedgerEntry."Document Type"::Payment);
            rBankAccountLedgerEntry.SetRange("Document No.", SalesInvHeader."No.");
            //rBankAccountLedgerEntry.SETRANGE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");
            if rBankAccountLedgerEntry.FindSet then
                repeat
                    ImporteLiquidadoBanco += rBankAccountLedgerEntry."Amount (LCY)";
                until rBankAccountLedgerEntry.Next = 0;

            // Obtener importe total SIC
            MedPagoSIC.Reset;
            MedPagoSIC.SetCurrentKey("Tipo documento", "No. documento", "No. documento SIC");
            MedPagoSIC.SetRange("Tipo documento", 1);
            MedPagoSIC.SetRange("No. documento SIC", SalesInvHeader."No. Documento SIC");
            MedPagoSIC.SetFilter(Importe, '<>%1', 0);
            if MedPagoSIC.FindSet then
                repeat
                    ImporteTotalSic += MedPagoSIC.Importe;
                until MedPagoSIC.Next = 0;

            // Comparar importes y marcar como liquidado si coinciden
            if Abs(ImporteTotalSic - ImporteLiquidadoBanco) < 1 then begin
                SIH.Reset;
                SIH.SetRange("No.", SalesInvHeader."No.");
                if SIH.FindFirst then begin
                    SIH."Liquidado TPV" := true;
                    SIH.Modify;
                end;
            end;
            // 002- Se marca como liquidado si los importes coinciden
        end else
            Message(StrSubstNo(Error001, SalesInvHeader."No."));
    end;

    procedure RegistrarCobrosNotaCreditoTPVManual(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        NoLin: Integer;
        dImporte: Integer;
        ImporteNeto: Integer;
        MediosdePagoMG: Record "Medios de Pago SIC";
        MP: Record "Medios de Pago SIC";
        ConfMediosdepagos: Record "Conf. Medios de pago";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Msg001: Label 'Liq. pago Doc. %1';
        Bancostienda: Record "Bancos tienda";
        SIH: Record "Sales Invoice Header";
        SIH2: Record "Sales Invoice Header";
        SIH3: Record "Sales Invoice Header";
        MediosdePagoMG2: Record "Flash ventas (Cantidades)";
        MPMG2: Record "Flash ventas (Cantidades)";
        SCrMLine: Record "Sales Cr.Memo Line";
        SCRM: Record "Sales Cr.Memo Header";
        SCRM2: Record "Sales Cr.Memo Header";
        MontoIva: Decimal;
        MedPagoSIC: Record "Medios de Pago SIC";
        CantMedioPago: Integer;
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        DocNo: Code[20];
        CustLedgEntryNo: Integer;
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        _CustLegEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        Error001: Label 'No existen líneas de pagos sic pendientes a liquidar para nota credito %1';
    begin
        ConfigEmpresa.Get;
        if not ConfigEmpresa."Liquidar Nota Credito TPV" then
            Error(Error003, (ConfigEmpresa.FieldCaption("Liquidar Nota Credito TPV")));

        if SalesCrMemoHeader."Liquidado TPV" then begin
            Message(Message002, SalesCrMemoHeader."No.");
            exit;
        end;

        NoLin := 0;
        dImporte := 0;
        ImporteNeto := 0;

        MediosdePagoMG.Reset;
        MediosdePagoMG.SetCurrentKey("Tipo documento", "No. documento", "No. documento SIC");
        MediosdePagoMG.SetRange("Tipo documento", 2);
        MediosdePagoMG.SetRange("No. documento", SalesCrMemoHeader."External Document No.");
        //MediosdePagoMG.SETRANGE("No. documento",SalesCrMemoHeader."Pre-Assigned No.");
        MediosdePagoMG.SetRange("No. documento SIC", SalesCrMemoHeader."No. Documento SIC");
        MediosdePagoMG.SetRange(Transferido, false);//002+-
        MediosdePagoMG.SetFilter(Importe, '<>%1', 0);//002+-
        if MediosdePagoMG.FindSet then begin
            repeat
                NoLin += 10000;
                ConfMediosdepagos.Get(MediosdePagoMG."Cod. medio de pago");
                Bancostienda.Reset;
                Bancostienda.SetRange("Cod. Tienda", SalesCrMemoHeader.Tienda);
                Bancostienda.SetRange("Cod. Divisa", '');
                if Bancostienda.FindFirst then;
                Bancostienda.TestField("Cod. Banco");

                GenJnlLine.Init;
                GenJnlLine."Line No." := NoLin;
                GenJnlLine."Document No." := SalesCrMemoHeader."No.";
                GenJnlLine."Posting Date" := SalesCrMemoHeader."Posting Date";
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.Validate("Account No.", SalesCrMemoHeader."Sell-to Customer No.");
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.Validate("Bal. Account No.", Bancostienda."Cod. Banco");
                GenJnlLine.Description := CopyStr(StrSubstNo(Msg001, SalesCrMemoHeader."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MaxStrLen(GenJnlLine.Description));
                GenJnlLine.Validate(Amount, MediosdePagoMG.Importe);
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::"Credit Memo");
                GenJnlLine.Validate("Applies-to Doc. No.", SalesCrMemoHeader."No.");
                GenJnlLine.Validate("External Document No.", SalesCrMemoHeader."Pre-Assigned No.");
                GenJnlLine."Currency Factor" := SalesCrMemoHeader."Currency Factor";
                GenJnlLine."Salespers./Purch. Code" := SalesCrMemoHeader."Salesperson Code";
                GenJnlLine.Validate("Shortcut Dimension 1 Code", SalesCrMemoHeader."Shortcut Dimension 1 Code");
                GenJnlLine.Validate("Shortcut Dimension 2 Code", SalesCrMemoHeader."Shortcut Dimension 2 Code");
                //GenJnlLine.VALIDATE("No. Tarjeta",MediosdePagoMG."Refencia Pago");//034+-Se inserta en numero de tarjeta del PUnto de Venta.
                GenJnlLine.Validate("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");

                OldCustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                OldCustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                OldCustLedgEntry.SetRange("Customer No.", SalesCrMemoHeader."Sell-to Customer No.");
                OldCustLedgEntry.SetRange(Open, true);
                if OldCustLedgEntry.FindFirst then begin
                    OldCustLedgEntry.Positive := false;
                    OldCustLedgEntry.Open := true;//034+-
                    OldCustLedgEntry.Modify(true);
                end;

                GenJnlPostLine.RunWithCheck(GenJnlLine);
                MediosdePagoMG.Transferido := true;//002+-
                MediosdePagoMG.Modify;
            until MediosdePagoMG.Next = 0;

            // 002+ Se marca como liquidado si los importes coinciden
            ImporteLiquidadoBanco := 0;
            ImporteTotalSic := 0;

            // Obtener importe liquidado del banco
            rBankAccountLedgerEntry.Reset;
            rBankAccountLedgerEntry.SetRange("Document Type", rBankAccountLedgerEntry."Document Type"::Refund);
            rBankAccountLedgerEntry.SetRange("Document No.", SalesCrMemoHeader."No.");
            //rBankAccountLedgerEntry.SETRANGE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");
            if rBankAccountLedgerEntry.FindSet then
                repeat
                    ImporteLiquidadoBanco += rBankAccountLedgerEntry."Amount (LCY)";
                until rBankAccountLedgerEntry.Next = 0;

            // Obtener importe total SIC
            MedPagoSIC.Reset;
            MedPagoSIC.SetCurrentKey("Tipo documento", "No. documento", "No. documento SIC");
            MedPagoSIC.SetRange("Tipo documento", 1);
            MedPagoSIC.SetRange("No. documento SIC", SalesCrMemoHeader."No. Documento SIC");
            MedPagoSIC.SetFilter(Importe, '<>%1', 0);
            if MedPagoSIC.FindSet then
                repeat
                    ImporteTotalSic += MedPagoSIC.Importe;
                until MedPagoSIC.Next = 0;

            // Comparar importes y marcar como liquidado si coinciden
            if Abs(ImporteTotalSic - ImporteLiquidadoBanco) < 1 then begin
                SCRM.Reset;
                SCRM.SetRange("No.", SalesCrMemoHeader."No.");
                if SCRM.FindFirst then begin
                    SCRM."Liquidado TPV" := true;
                    SCRM.Modify;
                end;
            end;
            // 002- Se marca como liquidado si los importes coinciden
        end else
            Message(StrSubstNo(Error001, SCRM."No."));
    end;


    procedure ProcesaNoLiquidados()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        ImporteLiquidado: Decimal;
        FechaInicio: Date;
        CantidadDocs: Integer;
        MediosdePagoSIC: Record "Medios de Pago SIC";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        //SANTINAV-7551+ //LDP //04/02/2025
        //Facturas+
        //1. Buscar documentos no liquidados en SIH.
        GeneralLedgerSetup.Get;
        CantidadDocs := 0;
        //FechaInicio:= 020225D;
        SalesInvoiceHeader.Reset;
        SalesInvoiceHeader.SetRange("Venta TPV", true);
        SalesInvoiceHeader.SetRange("Liquidado TPV", false);
        SalesInvoiceHeader.SetFilter("No. Documento SIC", '<>%1', '');
        SalesInvoiceHeader.SetRange("Posting Date", GeneralLedgerSetup."Allow Posting From", GeneralLedgerSetup."Allow Posting To");
        //SalesInvoiceHeader.SETFILTER("Posting Date",'>%1',FechaInicio);
        CantidadDocs := SalesInvoiceHeader.Count;
        if SalesInvoiceHeader.FindSet then
            repeat
            begin
                //2. Validar que realmente no estén liquidados, no tenga un cobro en la tabla Movs. Banco (271).
                BankAccountLedgerEntry.Reset;
                BankAccountLedgerEntry.SetRange("Document Type", BankAccountLedgerEntry."Document Type"::Payment);
                BankAccountLedgerEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
                if not BankAccountLedgerEntry.FindSet then begin
                    MediosdePagoSIC.Reset;
                    MediosdePagoSIC.SetRange("No. documento SIC", SalesInvoiceHeader."No. Documento SIC");
                    if MediosdePagoSIC.FindSet then
                        repeat
                            MediosdePagoSIC.Transferido := false;
                            MediosdePagoSIC.Modify;
                            Commit;
                        until MediosdePagoSIC.Next = 0;

                    RegistrarCobrosFacturaTPV(SalesInvoiceHeader);
                end
            end;
            until SalesInvoiceHeader.Next = 0;
        //Facturas-


        //Nota Credito+
        //1. Buscar documentos no liquidados en SIH.
        CantidadDocs := 0;
        SalesCrMemoHeader.Reset;
        SalesCrMemoHeader.SetRange("Venta TPV", true);
        SalesCrMemoHeader.SetRange("Liquidado TPV", false);
        SalesCrMemoHeader.SetFilter("No. Documento SIC", '<>%1', '');
        SalesCrMemoHeader.SetRange("Posting Date", GeneralLedgerSetup."Allow Posting From", GeneralLedgerSetup."Allow Posting To");
        //SalesCrMemoHeader.SETFILTER("Posting Date",'>%1',FechaInicio);
        CantidadDocs := SalesCrMemoHeader.Count;
        if SalesCrMemoHeader.FindSet then
            repeat
            begin
                //2. Validar que realmente no estén liquidados, no tenga un cobro en la tabla Movs. Banco (271).
                BankAccountLedgerEntry.Reset;
                BankAccountLedgerEntry.SetRange("Document Type", BankAccountLedgerEntry."Document Type"::Refund);
                BankAccountLedgerEntry.SetRange("Document No.", SalesCrMemoHeader."No.");
                if not BankAccountLedgerEntry.FindSet then begin
                    MediosdePagoSIC.Reset;
                    MediosdePagoSIC.SetRange("No. documento SIC", SalesCrMemoHeader."No. Documento SIC");
                    if MediosdePagoSIC.FindSet then
                        repeat
                            MediosdePagoSIC.Transferido := false;
                            MediosdePagoSIC.Modify;
                        until MediosdePagoSIC.Next = 0;
                    RegistrarCobrosNotaCreditoTPV(SalesCrMemoHeader);
                end else begin
                    SalesCrMemoHeader."Liquidado TPV" := true;
                    SalesCrMemoHeader.Modify;
                end;
            end;
            until SalesCrMemoHeader.Next = 0;
        //Nota Credito-
        //SANTINAV-7551- //LDP //04/02/2025
    end;


    procedure ValidacionesCabecera(): Boolean
    begin
        /*
        WITH CabVentasICG DO BEGIN
          Errores := '';
          ValidarCab :=  FALSE;
        
          IF tipodoc = '' THEN
            Errores += 'tipodoc,';
        
          IF numdoc = '' THEN
            Errores += 'numdoc,';
        
          IF codcliente = '' THEN
            Errores += 'codcliente,';
        
          IF codmoneda = '' THEN
            Errores += 'codmoneda,';
        
          IF tasacambio = '' THEN
            Errores += 'tasacambio,';
        
          IF fecha = '' THEN
            Errores += 'fecha,';
        
          IF numcomprobante = '' THEN
            Errores += 'numcomprobante,';
        
          IF (ncf_afecta = '') AND (tipodoc = '2') THEN
            Errores += 'ncf_afecta,';
        
          IF codalmacen = '' THEN
            Errores += 'codalmacen,';
        
         // IF rnc_cliente = '' THEN
          //  Errores += 'rnc_cliente,';
        
          IF ("Source Counter" <= 0) THEN
            Errores += '"Source Counter",';
        
          IF fvenceserieresol = '' THEN
            Errores += 'fvenceserieresol';
        
          IF Errores <> '' THEN
            BEGIN
              Errores := Text01 + Errores;
              ValidarCab := TRUE;
            END;
        
           MODIFY;
           EXIT(ValidarCab);
        END;
        |*/

    end;


    procedure ValidacionesLineas()
    begin
        /*
        WITH LineasVtasICG DO BEGIN
          Errores := '';
          //ValidarLin :=  FALSE;
        
          IF numdoc = '' THEN
            Errores += 'numdoc,';
        
          IF numlinea = '' THEN
            Errores += 'numlinea,';
        
          IF codproducto = '' THEN
            Errores += 'codproducto,';
        
          IF unidad_medida = '' THEN
            Errores += 'unidad_medida,';
        
          IF cantidad = '' THEN
            Errores += 'cantidad,';
        
          IF precio_venta = '' THEN
            Errores += 'precio_venta,';
        
          IF importe_dto = '' THEN
            Errores += 'importe_dto,';
        
          IF "Source Counter" <= 0 THEN
            Errores += '"Source Counter",';
        
          IF Errores <> '' THEN
            BEGIN
              Errores := Text01 + Errores;
              //ValidarLin := TRUE;
        
              CabVentasICG.RESET;
              CabVentasICG.SETCURRENTKEY(numdoc);
              CabVentasICG.SETRANGE(numdoc, numdoc);
              IF CabVentasICG.FINDFIRST THEN
                BEGIN
                  CabVentasICG.ErroresLineas := TRUE;
                  CabVentasICG.MODIFY;
                END
            END;
        
           MODIFY;
          // EXIT(ValidarLin);
        END;
        */

    end;


    procedure ValidacionesCabeceraSIC(CabVentasSIC: Record "Cab. Ventas SIC"): Boolean
    begin

        Errores := '';
        ValidarCab := false;

        if CabVentasSIC."Tipo documento" = 0 then
            Errores += 'tipodoc,';

        if CabVentasSIC."No. documento" = '' then
            Errores += 'numdoc,';

        if CabVentasSIC."Cod. Cliente" = '' then
            Errores += 'codcliente,';

        if CabVentasSIC."Cod. Moneda" = '' then
            Errores += 'codmoneda,';

        if CabVentasSIC."Tasa de cambio" = 0 then
            Errores += 'tasacambio,';

        if CabVentasSIC.Fecha = 0D then
            Errores += 'fecha,';

        if CabVentasSIC."No. comprobante" = '' then
            Errores += 'numcomprobante,';

        if (CabVentasSIC."NCF Afectado" = '') and (CabVentasSIC."Tipo documento" = 2) then
            Errores += 'ncf_afecta,';

        if CabVentasSIC."No. documento SIC" = '' then
            Errores += 'No. Documento Sic,';

        //  IF CabVentasSIC."Cod. Almacen" = '' THEN
        //    Errores += 'codalmacen,';

        // IF rnc_cliente = '' THEN
        //  Errores += 'rnc_cliente,';

        //IF ("Source Counter" <= 0) THEN
        // Errores += '"Source Counter",';

        if CabVentasSIC."Fecha Venc. NCF" = 0D then
            Errores += 'fvenceserieresol';

        if CabVentasSIC.Errores <> '' then begin
            Errores := Text01 + Errores;
            ValidarCab := true;
        end;

        CabVentasSIC.Modify;
        exit(ValidarCab);
    end;

    local procedure CambiaNoBorrador()
    var
        MovCont: Record "G/L Entry";
        MovCont_Out: Record "G/L Entry";
        MovITBIS: Record "VAT Entry";
        MovProd: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        MovCte: Record "Cust. Ledger Entry";
        MovCteDet: Record "Detailed Cust. Ledg. Entry";
        MovContout: Record "G/L Entry";
        MovITBISout: Record "VAT Entry";
        MovProdout: Record "Item Ledger Entry";
        ValueEntryout: Record "Value Entry";
        MovCteout: Record "Cust. Ledger Entry";
        MovCteDetout: Record "Detailed Cust. Ledg. Entry";
        SIH: Record "Sales Invoice Header";
        SIL: Record "Sales Invoice Line";
        SIL_Out: Record "Sales Invoice Line";
        SIH_out: Record "Sales Invoice Header";
        Fecha: Date;
        SIH_outNo: Code[20];
        ConfigCajaElectronica: Record "Config. Caja Electronica";
        CabVentasSIC: Record "Cab. Ventas SIC";
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        SL_Out: Record "Sales Line";
        SH_out: Record "Sales Header";
    begin
        SH.Reset;
        SH.SetRange("No.", 'NCRLL2-2911');
        if SH.FindFirst then;
        SIH_outNo := SH."No.";
        SH."No." := 'NCLL2-' + CabVentasSIC."No. documento";
        SH_out.TransferFields(SH);

        CabVentasSIC.Reset;
        CabVentasSIC.SetRange("No. documento", SH."No. Documento SIC");
        CabVentasSIC.SetRange("Cod. Almacen", SH."Location Code");
        //CabVentasSIC.SETRANGE(Clave,SH."Transaction Id");

        if CabVentasSIC.FindFirst then;

        ConfigCajaElectronica.Reset;
        ConfigCajaElectronica.SetCurrentKey("Caja ID", Sucursal);
        ConfigCajaElectronica.SetRange("Caja ID", CabVentasSIC.Caja);
        ConfigCajaElectronica.SetRange(Sucursal, CabVentasSIC.Tienda);
        if ConfigCajaElectronica.FindFirst then;




        SL.SetRange("Document No.", SIH_outNo);
        SL.FindSet;
        repeat
            SL_Out.TransferFields(SL);
            SL_Out."Document No." := SH_out."No.";
            SL_Out.Insert;
        until SL.Next = 0;



        SL.SetRange("Document No.", SIH_outNo);
        SL.FindSet();
        repeat
            SL.Delete;
        until SL.Next = 0;

        //SH.DELETE;
    end;
}

