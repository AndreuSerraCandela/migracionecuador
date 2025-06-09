codeunit 55013 "Events Gen. Jnl.-Post Line"
{
    Permissions =
                tabledata "Bank Account" = rimd,
                tabledata "Bank Account Posting Group" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeRunWithCheck', '', false, false)]
    local procedure OnBeforeRunWithCheck(var GenJournalLine2: Record "Gen. Journal Line")
    begin
        IF GenJournalLine2."Cheque Posfechado" THEN
            GenJournalLine2.TestField("Salespers./Purch. Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterRunWithCheck', '', false, false)]
    local procedure OnAfterRunWithCheck(var GenJnlLine: Record "Gen. Journal Line")
    begin
        IF GenJnlLine."Cheque Posfechado" THEN
            GenJnlLine.TestField("Salespers./Purch. Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
        //Cambia e valor para poder entrar al proceso PostGLAcc y guarda el valor original 
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::"Provisión Insolvencias", GenJournalLine."Account Type"::"Cancelar Prov. Insol.":
                begin
                    GenJournalLine."Account Type Modified" := GenJournalLine."Account Type";
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGenJnlLine', '', false, false)]
    local procedure OnAfterPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; sender: Codeunit "Gen. Jnl.-Post Line")
    begin
        //regresa el valor original 
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::"Provisión Insolvencias", GenJournalLine."Account Type"::"Cancelar Prov. Insol.":
                GenJournalLine."Account Type" := GenJournalLine."Account Type Modified";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertVATEntry', '', false, false)] //Pendiente
    local procedure OnAfterInsertVATEntry(GLEntryNo: Integer; VATEntry: Record "VAT Entry")
    begin
        GLEntryVATEntryLink.InsertLink(GLEntryNo, VATEntry."Entry No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostGLAccOnAfterInitGLEntry', '', false, false)]
    local procedure OnPostGLAccOnAfterInitGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
    begin
        //+#144
        IF GenJournalLine."Account Type Modified" IN [GenJournalLine."Account Type Modified"::"Provisión Insolvencias", GenJournalLine."Account Type Modified"::"Cancelar Prov. Insol."] THEN
            IF GenJournalLine."Applies-to Doc. No." <> '' THEN BEGIN
                CustLedgEntry.SETRANGE("Document Type", GenJournalLine."Applies-to Doc. Type");
                CustLedgEntry.SETRANGE("Document No.", GenJournalLine."Applies-to Doc. No.");
                IF CustLedgEntry.FINDSET THEN BEGIN
                    CustLedgEntry.CALCFIELDS("Importe provisionado");
                    GLEntry."No. Mov. cliente provisionado" := CustLedgEntry."Entry No.";
                    IF GenJournalLine."Account Type Modified" = GenJournalLine."Account Type Modified"::"Provisión Insolvencias" THEN
                        CustLedgEntry."Provisionado por insolvencia" := TRUE
                    ELSE
                        CustLedgEntry."Provisionado por insolvencia" := FALSE;
                    CustLedgEntry."Fecha ult. provision" := GenJournalLine."Posting Date"; //281014
                    CustLedgEntry.MODIFY;
                END;
            END;
        //-#144

        //+#144
        IF GenJournalLine."Bal. Account Type" IN [GenJournalLine."Bal. Account Type"::"Allocation Account"] THEN BEGIN
            Cust.GET(GenJournalLine."Bal. Account No.");
            Cust.TESTFIELD("Customer Posting Group");
            CustPostingGroup.GET(Cust."Customer Posting Group");
            CustPostingGroup.TESTFIELD("Cta. Dotacion Provision insolv");
            GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
            GLEntry."Bal. Account No." := CustPostingGroup."Cta. Dotacion Provision insolv";
        END;
        //-#144

        //DSLoc1.03 To store NCF in the Journal Entries  ++
        GLEntry."No. Comprobante Fiscal" := GenJournalLine."No. Comprobante Fiscal";
        GLEntry."Cod. Clasificacion Gasto" := GenJournalLine."Cod. Clasificacion Gasto";
        GLEntry."Cod. Colegio" := GenJournalLine."Cod. Colegio";
        GLEntry."Cod. Vendedor" := GenJournalLine."Salespers./Purch. Code";

        //002
        GLEntry."RUC/Cedula" := GenJournalLine."RUC/Cedula";
        GLEntry."Tipo de Comprobante" := GenJournalLine."Tipo de Comprobante";
        GLEntry."Sustento del Comprobante" := GenJournalLine."Sustento del Comprobante";
        GLEntry."No. Autorizacion Comprobante" := GenJournalLine."No. Autorizacion Comprobante";
        GLEntry.Establecimiento := GenJournalLine.Establecimiento;
        GLEntry."Punto de Emision" := GenJournalLine."Punto de Emision";
        GLEntry."Fecha Caducidad" := GenJournalLine."Fecha Caducidad";
        GLEntry."Cod. Retencion" := GenJournalLine."Cod. Retencion";
        GLEntry."Caja Chica" := GenJournalLine."Caja Chica";
        GLEntry.Beneficiario := GenJournalLine.Beneficiario;
        GLEntry."Excluir Informe ATS" := GenJournalLine."Excluir Informe ATS";
        //002
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostCustOnAfterInitCustLedgEntry', '', false, false)]
    local procedure OnPostCustOnAfterInitCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        //002
        IF GenJournalLine."Document Type" <> GenJournalLine."Document Type"::Payment THEN
            CustLedgEntry."Cheque Posfechado" := GenJournalLine."Cheque Posfechado";

        CustLedgEntry."Cheque Protestado" := GenJournalLine."Cheque Protestado";
        CustLedgEntry.Agencia := GenJournalLine.Agencia;
        CustLedgEntry."Forma de Pago" := GenJournalLine."Forma de Pago";
        //002

        CustLedgEntry."ID Retencion Venta" := GenJournalLine."ID Retencion Venta";//003

        //+#34822
        CustLedgEntry."Tipo Retención" := GenJournalLine."Tipo Retención";
        //-#34822

        //+#43533
        IF GenJournalLine."Applies-to Doc. No." <> '' THEN
            CASE GenJournalLine."Applies-to Doc. Type" OF
                GenJournalLine."Applies-to Doc. Type"::Invoice:
                    BEGIN
                        SalesInvoiceHeader.GET(GenJournalLine."Applies-to Doc. No.");
                        CustLedgEntry."No. Comprobante Liq. retencion" := SalesInvoiceHeader."No. Comprobante Fiscal";
                    END;
                GenJournalLine."Applies-to Doc. Type"::"Credit Memo":
                    BEGIN
                        SalesCrMemoHeader.GET(GenJournalLine."Applies-to Doc. No.");
                        CustLedgEntry."No. Comprobante Liq. retencion" := SalesCrMemoHeader."No. Comprobante Fiscal";
                    END;
            END;
        //-#43533

        //DSLoc1.01 To store the NCF
        CustLedgEntry."No. Comprobante Fiscal" := GenJournalLine."No. Comprobante Fiscal";

        //002
        CustLedgEntry."Collector Code" := GenJournalLine."Collector Code";
        //002

        CustLedgEntry."No. Comprobante Fiscal Rel." := GenJournalLine."No. Comprobante Fiscal Rel.";  //#30531
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure OnBeforeCustLedgEntryInsert(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."No. Comprobante Fiscal" := GenJournalLine."No. Comprobante Fiscal";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterCustLedgEntryInsert', '', false, false)]
    local procedure OnAfterCustLedgEntryInsert(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CrearDetalleRetencion(GenJournalLine, CustLedgerEntry."Entry No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostVendOnAfterInitVendLedgEntry', '', false, false)]
    local procedure OnPostVendOnAfterInitVendLedgEntry(var VendLedgEntry: Record "Vendor Ledger Entry"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        //DSLoc1.01 To store the NCF
        VendLedgEntry."No. Comprobante Fiscal" := GenJnlLine."No. Comprobante Fiscal";

        //002
        //Aqui002
        VendLedgEntry."RUC/Cedula" := GenJnlLine."RUC/Cedula";
        VendLedgEntry."Tipo de Comprobante" := GenJnlLine."Tipo de Comprobante";
        VendLedgEntry."Sustento del Comprobante" := GenJnlLine."Sustento del Comprobante";
        VendLedgEntry."No. Autorizacion Comprobante" := GenJnlLine."No. Autorizacion Comprobante";
        VendLedgEntry.Establecimiento := GenJnlLine.Establecimiento;
        VendLedgEntry."Punto de Emision" := GenJnlLine."Punto de Emision";
        VendLedgEntry."Fecha Caducidad" := GenJnlLine."Fecha Caducidad";
        VendLedgEntry."Cod. Retencion" := GenJnlLine."Cod. Retencion";
        VendLedgEntry."Caja Chica" := GenJnlLine."Caja Chica";
        VendLedgEntry."Excluir Informe ATS" := GenJnlLine."Excluir Informe ATS"; //ATS
        //002
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', false, false)]
    local procedure OnBeforeVendLedgEntryInsert(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."No. Comprobante Fiscal" := GenJournalLine."No. Comprobante Fiscal";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeBankAccLedgEntryInsert', '', false, false)]
    local procedure OnPostBankAccOnBeforeBankAccLedgEntryInsert(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        BankAccountLedgerEntry.Agencia := GenJournalLine.Agencia;//002
        BankAccountLedgerEntry."Forma de Pago" := GenJournalLine."Forma de Pago";//002
        BankAccountLedgerEntry.Beneficiario := GenJournalLine.Beneficiario; //002
    end;

    //No se pudo eliminar el metodo SetGLAccountNoInVATEntries llamado desde FinishPosting //Pendiente

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInitGLEntry', '', false, false)]
    local procedure OnBeforeInitGLEntry(var GLAccNo: Code[20]; var GenJournalLine: Record "Gen. Journal Line")
    var
        CustNo: Code[20];
        Cust: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
    begin
        //+#144
        IF GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::"Provisión Insolvencias",
           GenJournalLine."Account Type"::"Cancelar Prov. Insol."] THEN BEGIN
            CustNo := GenJournalLine."Account No.";
            Cust.GET(GenJournalLine."Account No.");
            Cust.TESTFIELD("Customer Posting Group");
            CustPostingGroup.GET(Cust."Customer Posting Group");
            CustPostingGroup.TESTFIELD("Cta. Dotacion Provision insolv");
            GLAccNo := CustPostingGroup."Cta. Dotacion Provision insolv";
        END;
        //-#144
    end;

    [EventSubscriber(ObjectType::Table, DataBase::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        //+#144
        IF GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::"Provisión Insolvencias",
           GenJournalLine."Account Type"::"Cancelar Prov. Insol."] THEN BEGIN
            GLEntry."Source Type" := GLEntry."Source Type"::Customer;
            GLEntry."Source No." := GenJournalLine."Account No.";
        END;

        IF GenJournalLine."Bal. Account Type" IN [GenJournalLine."Bal. Account Type"::"Allocation Account"] THEN BEGIN
            GLEntry."Source Type" := GenJournalLine."Account Type";
            GLEntry."Source No." := GenJournalLine."Account No.";
        END;
        //-#144

        //DSLoc1.01 To store the NCF
        GLEntry."No. Comprobante Fiscal" := GenJournalLine."No. Comprobante Fiscal";
        GLEntry."Cod. Clasificacion Gasto" := GenJournalLine."Cod. Clasificacion Gasto";

        //002
        //AQui003
        GLEntry."RUC/Cedula" := GenJournalLine."RUC/Cedula";
        GLEntry."Tipo de Comprobante" := GenJournalLine."Tipo de Comprobante";
        GLEntry."Sustento del Comprobante" := GenJournalLine."Sustento del Comprobante";
        GLEntry."No. Autorizacion Comprobante" := GenJournalLine."No. Autorizacion Comprobante";
        GLEntry.Establecimiento := GenJournalLine.Establecimiento;
        GLEntry."Punto de Emision" := GenJournalLine."Punto de Emision";
        GLEntry."Fecha Caducidad" := GenJournalLine."Fecha Caducidad";
        GLEntry."Cod. Retencion" := GenJournalLine."Cod. Retencion";
        GLEntry."Caja Chica" := GenJournalLine."Caja Chica";
        GLEntry."Excluir Informe ATS" := GenJournalLine."Excluir Informe ATS";
        //002
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertTempVATEntry', '', false, false)]
    local procedure OnBeforeInsertTempVATEntry(var TempVATEntry: Record "VAT Entry" temporary; VATEntry: Record "VAT Entry")
    begin
        TempVATEntry."G/L Acc. No." := VATEntry."G/L Acc. No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCalcCurrencyApplnRounding', '', false, false)]
    local procedure OnBeforeCalcCurrencyApplnRounding(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; var OldCVLedgEntryBuf2: Record "CV Ledger Entry Buffer"; var IsHandled: Boolean)
    begin
        IF ((NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Payment) AND
          (NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Refund)) OR
         (NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf2."Currency Code")
      THEN
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertDtldCustLedgEntry', '', false, false)]
    local procedure OnAfterInsertDtldCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        //DSLoc1.04 jpg Nota credito pronto pago
        //IF INSERT(TRUE) THEN si no marca error al insertar entra a este metodo
        IF DtldCustLedgEntry."Entry Type" = DtldCustLedgEntry."Entry Type"::"Payment Discount" THEN
            NotaCredtoDPP(DtldCustLedgEntry);
        //DSLoc1.04
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertPostUnrealVATEntry', '', false, false)]
    local procedure OnBeforeInsertPostUnrealVATEntry(var VATEntry: Record "VAT Entry"; var VATEntry2: Record "VAT Entry")
    begin
        VATEntry."G/L Acc. No." := VATEntry2."G/L Acc. No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostUnrealVATEntryOnBeforeInsertLinkSelf', '', false, false)] //Pendiente
    local procedure OnPostUnrealVATEntryOnBeforeInsertLinkSelf(GLEntryNo: Integer; var NextVATEntryNo: Integer)
    begin
        GLEntryVATEntryLink.InsertLink(GLEntryNo + 1, NextVATEntryNo);
    end;

    //PostUnapply cambiar GLEntryVATEntryLink.InsertLink(GLEntryNoFromVAT,VATEntry2."Entry No."); //Pendiente

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnInsertTempVATEntryOnBeforeInsert', '', false, false)]
    local procedure OnInsertTempVATEntryOnBeforeInsert(var VATEntry: Record "VAT Entry"; SourceVATEntry: Record "VAT Entry")
    begin
        VATEntry."Document Date" := SourceVATEntry."Document Date";
        VATEntry."G/L Acc. No." := SourceVATEntry."G/L Acc. No.";
    end;

    /*LOCAL PROCEDURE SetGLAccountNoInVATEntries(); //Pendiente Modificar este proceso
    VAR
      GLEntryVATEntryLink : Record "G/L Entry - VAT Entry Link";
      VATEntryEdit : Codeunit "VAT Entry - Edit";
    BEGIN
      IF TempGLEntryVATEntryLink.FINDSET THEN
        REPEAT
          GLEntryVATEntryLink.InsertLinkSelf(TempGLEntryVATEntryLink."G/L Entry No.",TempGLEntryVATEntryLink."VAT Entry No.");
          IF TempGLEntryVATEntryLink."G/L Entry No." <> 0 THEN
            IF TempGLEntryBuf.GET(TempGLEntryVATEntryLink."G/L Entry No.") THEN
              VATEntryEdit.SetGLAccountNo(TempGLEntryVATEntryLink."VAT Entry No.",TempGLEntryBuf."G/L Account No.");
        UNTIL TempGLEntryVATEntryLink.NEXT = 0;

      TempGLEntryVATEntryLink.DELETEALL;
    END;*/

    /*LOCAL PROCEDURE GetApplnRoundPrecision(NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer"): Decimal; //Pendiente Modificar este proceso
    VAR
        ApplnCurrency: Record Currency;
        CurrencyCode: Code[10];
    BEGIN
        IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
            CurrencyCode := NewCVLedgEntryBuf."Currency Code"
        ELSE
            CurrencyCode := OldCVLedgEntryBuf."Currency Code";
        IF CurrencyCode = '' THEN
            EXIT(0);
        ApplnCurrency.GET(CurrencyCode);
        IF ApplnCurrency."Appln. Rounding Precision" <> 0 THEN
            EXIT(ApplnCurrency."Appln. Rounding Precision");
        EXIT(GLSetup."Appln. Rounding Precision");
    END;*/

    LOCAL PROCEDURE NotaCredtoDPP(DtldCustEntry_: Record "Detailed Cust. Ledg. Entry");
    VAR
        DtldCustEntry: Record "Detailed Cust. Ledg. Entry";
        rCustomer: Record Customer;
        rCustomerPostingGr: Record "Customer Posting Group";
        Err0016: Label '%1 can not be after %2 of the NCF serial no., corresponding values are %3 and %4'; //%1 no puede ser posterior a %2 del numerador de NCF, los valores correspondientes son %3 y %4
        NoSeriesMgt: Codeunit "No. Series";
        LinSerie: Record 309;
        CustEntry: Record "Cust. Ledger Entry";
        DetailedCustEntry: Record "Detailed Cust. Ledg. Entry";
    BEGIN
        DtldCustEntry.RESET;
        DtldCustEntry.SETRANGE("Entry No.", DtldCustEntry_."Entry No.");
        IF DtldCustEntry.FINDFIRST THEN BEGIN

            IF rCustomer.GET(DtldCustEntry."Customer No.") THEN
                IF rCustomerPostingGr.GET(rCustomer."Customer Posting Group") THEN
                    IF rCustomerPostingGr."Permite emitir NCF" THEN BEGIN

                        CustEntry.RESET;
                        CustEntry.SETRANGE("Closed by Entry No.", DtldCustEntry."Cust. Ledger Entry No.");
                        CustEntry.SETFILTER("Pmt. Disc. Given (LCY)", '>0');
                        IF CustEntry.FINDSET(TRUE) THEN
                            REPEAT

                                rCustomer.TESTFIELD("VAT Registration No.");
                                CustEntry."No. Comprobante Fiscal DPP" := NoSeriesMgt.GetNextNo(rCustomerPostingGr."No. Serie NCF Abonos Venta", DtldCustEntry."Posting Date", TRUE);

                                LinSerie.RESET;
                                LinSerie.SETRANGE("Series Code", rCustomerPostingGr."No. Serie NCF Abonos Venta");
                                LinSerie.SETFILTER("Starting Date", '>=%1', DMY2DATE(1, 5, 2018));
                                LinSerie.SETRANGE(Open, TRUE);
                                IF LinSerie.FINDFIRST THEN
                                    IF (DtldCustEntry."Posting Date" > LinSerie."Expiration date") AND (LinSerie."Expiration date" <> 0D) THEN
                                        ERROR(STRSUBSTNO(Err0016, DtldCustEntry.FIELDCAPTION("Posting Date"), LinSerie.FIELDCAPTION("Expiration date"), DtldCustEntry."Posting Date",
                                        LinSerie."Expiration date"));

                                CustEntry."Fecha vencimiento NCF DPP" := LinSerie."Expiration date";
                                CustEntry.MODIFY;

                            UNTIL CustEntry.NEXT = 0;

                    END;
        END;
    END;

    PROCEDURE CrearDetalleRetencion(GenJnlLine: Record "Gen. Journal Line"; CustLedgEntryNo: Integer);
    VAR
        DetRetencion: Record "Histórico Retenciones Clientes";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Customer: Record Customer;
    BEGIN

        //+#34822

        IF (GenJnlLine."Tipo Retención" = GenJnlLine."Tipo Retención"::" ") THEN
            EXIT;

        DetRetencion.INIT;
        DetRetencion."Cód. Cliente" := GenJnlLine."Account No.";
        Customer.GET(GenJnlLine."Account No.");
        DetRetencion."Nombre Cliente" := Customer.Name;
        DetRetencion."Tipo Retención" := GenJnlLine."Tipo Retención";
        DetRetencion."Tipo Documento" := GenJnlLine."Applies-to Doc. Type".AsInteger();
        DetRetencion."No. documento" := GenJnlLine."Applies-to Doc. No.";
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN
            CASE GenJnlLine."Applies-to Doc. Type" OF
                GenJnlLine."Applies-to Doc. Type"::Invoice:
                    BEGIN
                        SalesInvoiceHeader.GET(GenJnlLine."Applies-to Doc. No.");
                        DetRetencion."Establecimiento Factura" := SalesInvoiceHeader."Establecimiento Factura";
                        DetRetencion."Punto de Emision Factura" := SalesInvoiceHeader."Punto de Emision Factura";
                        DetRetencion."No. Comprobante Fiscal" := SalesInvoiceHeader."No. Comprobante Fiscal";
                        DetRetencion."No. Autorizacion Comprobante" := SalesInvoiceHeader."No. Autorizacion Comprobante";
                    END;
                GenJnlLine."Applies-to Doc. Type"::"Credit Memo":
                    BEGIN
                        SalesCrMemoHeader.GET(GenJnlLine."Applies-to Doc. No.");
                        DetRetencion."Establecimiento Factura" := SalesCrMemoHeader."Establecimiento Factura";
                        DetRetencion."Punto de Emision Factura" := SalesCrMemoHeader."Punto de Emision Factura";
                        DetRetencion."No. Comprobante Fiscal" := SalesCrMemoHeader."No. Comprobante Fiscal";
                        DetRetencion."No. Autorizacion Comprobante" := SalesCrMemoHeader."No. Autorizacion Comprobante";
                    END;
            END;
        DetRetencion."Fecha Registro" := GenJnlLine."Posting Date";
        DetRetencion."Importe Retenido" := -GenJnlLine."Amount (LCY)";
        DetRetencion."No. Movimiento Cliente" := CustLedgEntryNo;
        DetRetencion.INSERT(TRUE);

        //-#34822
    END;

    var
        //PurchaseAlreadyExistsErr@1003 traducción Francés      
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";

    /*

      Proyecto: Microsoft Dynamics Nav
      ---------------------------------
      AMS     : Agust n M ndez
      GRN     : Guillermo Rom n
      ------------------------------------------------------------------------
      No.         Firma       Fecha            Descripcion
      ------------------------------------------------------------------------
      DSLoc1.03   GRN         01/05/2018       Funcionalidad localizado RD
      DSLoc1.04   jpg         15/07/2019       Nota credito pronto pago.
      //DSLoc1.02

      DsLoc1.01   GRN     09/01/2009         Para adicionar funcionalidad de Retenciones y NCF
      DSLoc1.02   GRN     24/06/2010         Se adiciono el NCF a los Mov. Cte. y Mov. Prov.
      001         AMS     01/01/2011         Liquida Pedidos TPV
      002         AMS     06/07/2012         Agregar campos a tablas de movimientos
      003         AMS     28/01/2013         ID de Retencion de ventas
      004         AMS     06/02/2013         Cod. Vendedor Requerido desde seccion de cheques
                                             posfechados.

      #30531      FAA     09/09/2015         Se lleva el dato del campo "No. comprobante fiscal Rel:"

      #34822      CAT     04/12/2015         Retenciones de ventas (Renta e IVA)

      #43533      CAT     28/01/2016         En las retenciones de cliente, traemos el numero de comprobante fiscal del documento liquidado
    */
}