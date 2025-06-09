codeunit 76019 "Ventas-Registrar DsPOS"
{
    Permissions = TableData "Sales Line" = imd,
                  TableData "Purchase Header" = m,
                  TableData "Purchase Line" = m,
                  TableData "Invoice Posting Buffer" = imd,
                  TableData "Sales Shipment Header" = imd,
                  TableData "Sales Shipment Line" = imd,
                  TableData "Sales Invoice Header" = imd,
                  TableData "Sales Invoice Line" = imd,
                  TableData "Sales Cr.Memo Header" = imd,
                  TableData "Sales Cr.Memo Line" = imd,
                  TableData "Purch. Rcpt. Header" = imd,
                  TableData "Purch. Rcpt. Line" = imd,
                  TableData "Drop Shpt. Post. Buffer" = imd,
                  TableData "General Posting Setup" = imd,
                  TableData "Posted Assemble-to-Order Link" = i,
                  TableData "Item Entry Relation" = ri,
                  TableData "Value Entry Relation" = rid,
                  TableData "Return Receipt Header" = imd,
                  TableData "Return Receipt Line" = imd;
    TableNo = "Sales Header";

    trigger OnRun()
    var
        ItemEntryRelation: Record "Item Entry Relation";
        TempInvoicingSpecification: Record "Tracking Specification" temporary;
        DummyTrackingSpecification: Record "Tracking Specification";
        ICHandledInboxTransaction: Record "Handled IC Inbox Trans.";
        Cust: Record Customer;
        ICPartner: Record "IC Partner";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchCommentLine: Record "Purch. Comment Line";
        TempAsmHeader: Record "Assembly Header" temporary;
        TempItemLedgEntryNotInvoiced: Record "Item Ledger Entry" temporary;
        TempPostedATOLink: Record "Posted Assemble-to-Order Link" temporary;
        CustLedgEntry: Record "Cust. Ledger Entry";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
        ICInOutBoxMgt: Codeunit ICInboxOutboxMgt;

        CostBaseAmount: Decimal;
        TrackingSpecificationExists: Boolean;
        HasATOShippedNotInvoiced: Boolean;
        EndLoop: Boolean;
        GLEntryNo: Integer;
        BiggestLineNo: Integer;
        TransactionLogEntryNo: Integer;
    begin
        //fes mig
        /*
        IF PostingDateExists AND (ReplacePostingDate OR ("Posting Date" = 0D)) THEN BEGIN
          "Posting Date" := PostingDate;
          VALIDATE("Currency Code");
        END;
        
        IF PostingDateExists AND (ReplaceDocumentDate OR ("Document Date" = 0D)) THEN
          VALIDATE("Document Date",PostingDate);
        
        CLEARALL;
        SalesHeader := Rec;
        ServiceItemTmp2.DELETEALL;
        ServiceItemCmpTmp2.DELETEALL;
        WITH SalesHeader DO BEGIN
          TESTFIELD("On Hold",'');
          TESTFIELD("Document Type");
          TESTFIELD("Sell-to Customer No.");
          TESTFIELD("Bill-to Customer No.");
          TESTFIELD("Posting Date");
          TESTFIELD("Document Date");
          GLSetup.GET;
          IF GLSetup."PAC Environment" <> GLSetup."PAC Environment"::Disabled THEN
            TESTFIELD("Payment Method Code");
        
          IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
            FIELDERROR("Posting Date",Text045);
        
          IF "Tax Area Code" = '' THEN
            SalesTaxCountry := SalesTaxCountry::NoTax
          ELSE BEGIN
            TaxArea.GET("Tax Area Code");
            SalesTaxCountry := TaxArea."Country/Region";
            UseExternalTaxEngine := TaxArea."Use External Tax Engine";
          END;
        
          CASE "Document Type" OF
            "Document Type"::Order:
              Receive := FALSE;
            "Document Type"::Invoice:
              BEGIN
                Ship := TRUE;
                Invoice := TRUE;
                Receive := FALSE;
              END;
            "Document Type"::"Return Order":
              Ship := FALSE;
            "Document Type"::"Credit Memo":
              BEGIN
                Ship := FALSE;
                Invoice := TRUE;
                Receive := TRUE;
              END;
          END;
        
          IF NOT (Ship OR Invoice OR Receive) THEN
            ERROR(
              Text020,
              FIELDCAPTION(Ship),FIELDCAPTION(Invoice),FIELDCAPTION(Receive));
        
          WhseReference := "Posting from Whse. Ref.";
          "Posting from Whse. Ref." := 0;
        
          IF Invoice THEN
            CreatePrepaymentLines(SalesHeader,TempPrepaymentSalesLine,TRUE);
        
          CheckDim;
        
          CopyAprvlToTempApprvl;
        
          SalesSetup.GET;
          CheckCustBlockage("Sell-to Customer No.",TRUE);
          IF "Bill-to Customer No." <> "Sell-to Customer No." THEN
            CheckCustBlockage("Bill-to Customer No.",FALSE);
        
          IF Invoice THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            SalesLine.SETFILTER(Quantity,'<>0');
            IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
              SalesLine.SETFILTER("Qty. to Invoice",'<>0');
            Invoice := NOT SalesLine.ISEMPTY;
            IF Invoice AND (NOT Ship) AND ("Document Type" = "Document Type"::Order) THEN BEGIN
              SalesLine.FINDSET;
              Invoice := FALSE;
              REPEAT
                Invoice := SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced" <> 0;
              UNTIL Invoice OR (SalesLine.NEXT = 0);
            END ELSE
              IF Invoice AND (NOT Receive) AND ("Document Type" = "Document Type"::"Return Order") THEN BEGIN
                SalesLine.FINDSET;
                Invoice := FALSE;
                REPEAT
                  Invoice := SalesLine."Return Qty. Received" - SalesLine."Quantity Invoiced" <> 0;
                UNTIL Invoice OR (SalesLine.NEXT = 0);
              END;
          END;
          IF Invoice THEN
            CopyAndCheckItemCharge(SalesHeader);
        
          IF Invoice AND NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) THEN
            TESTFIELD("Due Date");
        
          IF Ship THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            SalesLine.SETFILTER(Quantity,'<>0');
            IF "Document Type" = "Document Type"::Order THEN
              SalesLine.SETFILTER("Qty. to Ship",'<>0');
            SalesLine.SETRANGE("Shipment No.",'');
        
            SalesLine.SETFILTER("Qty. to Assemble to Order",'<>0');
            IF SalesLine.FINDSET THEN
              REPEAT
                InitPostATO(SalesLine);
              UNTIL SalesLine.NEXT = 0;
            SalesLine.SETRANGE("Qty. to Assemble to Order");
        
            Ship := SalesLine.FINDFIRST;
            WhseShip := TempWhseShptHeader.FINDFIRST;
            WhseReceive := TempWhseRcptHeader.FINDFIRST;
            InvtPickPutaway := WhseReference <> 0;
            IF Ship THEN
              CheckTrackingSpecification(SalesLine);
            IF Ship AND NOT (WhseShip OR WhseReceive OR InvtPickPutaway) THEN
              CheckWarehouse(SalesLine);
          END;
        
          IF Receive THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            SalesLine.SETFILTER(Quantity,'<>0');
            SalesLine.SETFILTER("Return Qty. to Receive",'<>0');
            SalesLine.SETRANGE("Return Receipt No.",'');
            Receive := SalesLine.FINDFIRST;
            WhseShip := TempWhseShptHeader.FINDFIRST;
            WhseReceive := TempWhseRcptHeader.FINDFIRST;
            InvtPickPutaway := WhseReference <> 0;
            IF Receive THEN
              CheckTrackingSpecification(SalesLine);
            IF Receive AND NOT (WhseReceive OR WhseShip OR InvtPickPutaway) THEN
              CheckWarehouse(SalesLine);
          END;
        
          IF NOT (Ship OR Invoice OR Receive) THEN
            IF NOT OnlyAssgntPosting THEN
              ERROR(Text001);
        
          IF "Shipping Advice" = "Shipping Advice"::Complete THEN
            IF NOT GetShippingAdvice THEN
              ERROR(Text023);
        
          InitProgressWindow(SalesHeader);
        
          GetGLSetup;
          GetCurrency;
        
        {
          IF Ship AND ("Shipping No." = '') THEN
            IF ("Document Type" = "Document Type"::Order) OR
               (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice")
            THEN BEGIN
              TESTFIELD("Shipping No. Series");
              "Shipping No." := NoSeriesMgt.GetNextNo("Shipping No. Series","Posting Date",TRUE);
              ModifyHeader := TRUE;
            END;
        
        
          IF Receive AND ("Return Receipt No." = '') THEN
            IF ("Document Type" = "Document Type"::"Return Order") OR
               (("Document Type" = "Document Type"::"Credit Memo") AND SalesSetup."Return Receipt on Credit Memo")
            THEN BEGIN
              TESTFIELD("Return Receipt No. Series");
              "Return Receipt No." := NoSeriesMgt.GetNextNo("Return Receipt No. Series","Posting Date",TRUE);
              ModifyHeader := TRUE;
            END;
        }
        
          IF Invoice AND ("Posting No." = '') THEN BEGIN
            IF ("No. Series" <> '') OR
               ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
            THEN
              TESTFIELD("Posting No. Series");
            IF ("No. Series" <> "Posting No. Series") OR
               ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
            THEN BEGIN
              "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",TRUE);
              ModifyHeader := TRUE;
            END;
          END;
        
        
          IF NOT ItemChargeAssgntOnly THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            SalesLine.SETFILTER("Purch. Order Line No.",'<>0');
            IF NOT SalesLine.ISEMPTY THEN BEGIN
              DropShipOrder := TRUE;
              IF Ship THEN BEGIN
                SalesLine.FINDSET;
                REPEAT
                  IF PurchOrderHeader."No." <> SalesLine."Purchase Order No." THEN BEGIN
                    PurchOrderHeader.GET(
                      PurchOrderHeader."Document Type"::Order,
                      SalesLine."Purchase Order No.");
                    PurchOrderHeader.TESTFIELD("Pay-to Vendor No.");
                    PurchOrderHeader.Receive := TRUE;
                    CODEUNIT.RUN(CODEUNIT::"Release Purchase Document",PurchOrderHeader);
                    IF PurchOrderHeader."Receiving No." = '' THEN BEGIN
                      PurchOrderHeader.TESTFIELD("Receiving No. Series");
                      PurchOrderHeader."Receiving No." :=
                        NoSeriesMgt.GetNextNo(PurchOrderHeader."Receiving No. Series","Posting Date",TRUE);
                      PurchOrderHeader.MODIFY;
                      ModifyHeader := TRUE;
                    END;
                  END;
                UNTIL SalesLine.NEXT = 0;
              END;
            END;
          END;
          IF ModifyHeader THEN BEGIN
            MODIFY;
            COMMIT;
          END;
        
          IF SalesSetup."Calc. Inv. Discount" AND
             (Status <> Status::Open) AND
             NOT ItemChargeAssgntOnly
          THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            SalesLine.FINDFIRST;
            TempInvoice := Invoice;
            TempShpt := Ship;
            TempReturn := Receive;
            SalesCalcDisc.RUN(SalesLine);
            GET("Document Type","No.");
            Invoice := TempInvoice;
            Ship := TempShpt;
            Receive := TempReturn;
            COMMIT;
          END;
        
          IF (Status = Status::Open) OR (Status = Status::"Pending Prepayment") THEN BEGIN
            TempInvoice := Invoice;
            TempShpt := Ship;
            TempReturn := Receive;
            GetOpenLinkedATOs(TempAsmHeader);
            CODEUNIT.RUN(CODEUNIT::"Release Sales Document",SalesHeader);
            TESTFIELD(Status,Status::Released);
            Status := Status::Open;
            Invoice := TempInvoice;
            Ship := TempShpt;
            Receive := TempReturn;
            ReopenAsmOrders(TempAsmHeader);
            MODIFY;
            COMMIT;
            Status := Status::Released;
          END;
        
          TransactionLogEntryNo := AuthorizeCreditCard("Authorization Required");
        
          IF Ship OR Receive THEN
            ArchiveUnpostedOrder; // has a COMMIT;
        
          IF ("Sell-to IC Partner Code" <> '') AND ICPartner.GET("Sell-to IC Partner Code") THEN
            ICPartner.TESTFIELD(Blocked,FALSE);
          IF ("Bill-to IC Partner Code" <> '') AND ICPartner.GET("Bill-to IC Partner Code") THEN
            ICPartner.TESTFIELD(Blocked,FALSE);
          IF "Send IC Document" AND ("IC Status" = "IC Status"::New) AND ("IC Direction" = "IC Direction"::Outgoing) AND
             ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
          THEN BEGIN
            ICInOutBoxMgt.SendSalesDoc(Rec,TRUE);
            "IC Status" := "IC Status"::Pending;
            ModifyHeader := TRUE;
          END;
          IF "IC Direction" = "IC Direction"::Incoming THEN BEGIN
            ICHandledInboxTransaction.SETRANGE("Document No.","External Document No.");
            Cust.GET("Sell-to Customer No.");
            ICHandledInboxTransaction.SETRANGE("IC Partner Code",Cust."IC Partner Code");
            ICHandledInboxTransaction.LOCKTABLE;
            IF ICHandledInboxTransaction.FINDFIRST THEN BEGIN
              ICHandledInboxTransaction.Status := ICHandledInboxTransaction.Status::Posted;
              ICHandledInboxTransaction.MODIFY;
            END;
          END;
        
          LockTables;
        
          SourceCodeSetup.GET;
          SrcCode := SourceCodeSetup.Sales;
        
          // Insert shipment header
          {
          IF Ship THEN BEGIN
            IF ("Document Type" = "Document Type"::Order) OR
               (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice")
            THEN BEGIN
              IF DropShipOrder THEN BEGIN
                PurchRcptHeader.LOCKTABLE;
                PurchRcptLine.LOCKTABLE;
                SalesShptHeader.LOCKTABLE;
                SalesShptLine.LOCKTABLE;
              END;
              SalesShptHeader.INIT;
              SalesShptHeader.TRANSFERFIELDS(SalesHeader);
        
              SalesShptHeader."No." := "Shipping No.";
              IF "Document Type" = "Document Type"::Order THEN BEGIN
                SalesShptHeader."Order No. Series" := "No. Series";
                SalesShptHeader."Order No." := "No.";
                IF SalesSetup."Ext. Doc. No. Mandatory" THEN
                  TESTFIELD("External Document No.");
              END;
              SalesShptHeader."Source Code" := SrcCode;
              SalesShptHeader."User ID" := USERID;
              SalesShptHeader."No. Printed" := 0;
        
              SalesShptHeader.INSERT;
        
              ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Sales Shipment Header",SalesShptHeader."No.");
        
              IF SalesSetup."Copy Comments Order to Shpt." THEN BEGIN
                CopyCommentLines(
                  "Document Type",SalesCommentLine."Document Type"::Shipment,
                  "No.",SalesShptHeader."No.");
                SalesShptHeader.COPYLINKS(Rec);
              END;
              IF WhseShip THEN BEGIN
                WhseShptHeader.GET(TempWhseShptHeader."No.");
                WhsePostShpt.CreatePostedShptHeader(
                  PostedWhseShptHeader,WhseShptHeader,"Shipping No.","Posting Date");
              END;
              IF WhseReceive THEN BEGIN
                WhseRcptHeader.GET(TempWhseRcptHeader."No.");
                WhsePostRcpt.CreatePostedRcptHeader(
                  PostedWhseRcptHeader,WhseRcptHeader,"Shipping No.","Posting Date");
              END;
            END;
        
            ServItemMgt.CopyReservationEntry(SalesHeader);
        
            IF ("Document Type" = "Document Type"::Invoice) AND
               (NOT SalesSetup."Shipment on Invoice")
            THEN
              ServItemMgt.CreateServItemOnSalesInvoice(SalesHeader);
          END;
          }
        
          ServItemMgt.DeleteServItemOnSaleCreditMemo(SalesHeader);
        
          {
          // Insert return receipt header
          IF Receive THEN
            IF ("Document Type" = "Document Type"::"Return Order") OR
               (("Document Type" = "Document Type"::"Credit Memo") AND SalesSetup."Return Receipt on Credit Memo")
            THEN BEGIN
              ReturnRcptHeader.INIT;
              ReturnRcptHeader.TRANSFERFIELDS(SalesHeader);
              ReturnRcptHeader."No." := "Return Receipt No.";
              IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                ReturnRcptHeader."Return Order No. Series" := "No. Series";
                ReturnRcptHeader."Return Order No." := "No.";
                IF SalesSetup."Ext. Doc. No. Mandatory" THEN
                  TESTFIELD("External Document No.");
              END;
              ReturnRcptHeader."No. Series" := "Return Receipt No. Series";
              ReturnRcptHeader."Source Code" := SrcCode;
              ReturnRcptHeader."User ID" := USERID;
              ReturnRcptHeader."No. Printed" := 0;
              ReturnRcptHeader.INSERT(TRUE);
        
              ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Return Receipt Header",ReturnRcptHeader."No.");
        
              IF SalesSetup."Copy Cmts Ret.Ord. to Ret.Rcpt" THEN BEGIN
                CopyCommentLines(
                  "Document Type",SalesCommentLine."Document Type"::"Posted Return Receipt",
                  "No.",ReturnRcptHeader."No.");
                ReturnRcptHeader.COPYLINKS(Rec);
              END;
              IF WhseReceive THEN BEGIN
                WhseRcptHeader.GET(TempWhseRcptHeader."No.");
                WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Return Receipt No.","Posting Date");
              END;
              IF WhseShip THEN BEGIN
                WhseShptHeader.GET(TempWhseShptHeader."No.");
                WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Return Receipt No.","Posting Date");
              END;
            END;
          }
        
          // Insert invoice header or credit memo header
          IF Invoice THEN
            IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
              SalesInvHeader.INIT;
              SalesInvHeader.TRANSFERFIELDS(SalesHeader);
        
              IF "Document Type" = "Document Type"::Order THEN BEGIN
                SalesInvHeader."No." := "Posting No.";
                IF SalesSetup."Ext. Doc. No. Mandatory" THEN
                  TESTFIELD("External Document No.");
                SalesInvHeader."Pre-Assigned No. Series" := '';
                SalesInvHeader."Order No. Series" := "No. Series";
                SalesInvHeader."Order No." := "No.";
                Window.UPDATE(1,STRSUBSTNO(Text007,"Document Type","No.",SalesInvHeader."No."));
              END ELSE BEGIN
                SalesInvHeader."Pre-Assigned No. Series" := "No. Series";
                SalesInvHeader."Pre-Assigned No." := "No.";
                IF "Posting No." <> '' THEN BEGIN
                  SalesInvHeader."No." := "Posting No.";
                  Window.UPDATE(1,STRSUBSTNO(Text007,"Document Type","No.",SalesInvHeader."No."));
                END;
              END;
              SalesInvHeader."Source Code" := SrcCode;
              SalesInvHeader."User ID" := USERID;
              SalesInvHeader."No. Printed" := 0;
              SalesInvHeader.INSERT;
        
              UpdateWonOpportunities(Rec);
        
              ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Sales Invoice Header",SalesInvHeader."No.");
        
              IF SalesSetup."Copy Comments Order to Invoice" THEN BEGIN
                CopyCommentLines(
                  "Document Type",SalesCommentLine."Document Type"::"Posted Invoice",
                  "No.",SalesInvHeader."No.");
                SalesInvHeader.COPYLINKS(Rec);
              END;
              IF SalesTaxCountry <> SalesTaxCountry::NoTax THEN
                TaxAmountDifference.CopyTaxDifferenceRecords(
                  TaxAmountDifference."Document Product Area"::Sales,"Document Type","No.",
                  TaxAmountDifference."Document Product Area"::"Posted Sale",
                  TaxAmountDifference."Document Type"::Invoice,SalesInvHeader."No.");
              GenJnlLineDocType := GenJnlLine."Document Type"::Invoice;
              GenJnlLineDocNo := SalesInvHeader."No.";
              GenJnlLineExtDocNo := SalesInvHeader."External Document No.";
            END ELSE BEGIN // Credit Memo
              SalesCrMemoHeader.INIT;
              SalesCrMemoHeader.TRANSFERFIELDS(SalesHeader);
              IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                SalesCrMemoHeader."No." := "Posting No.";
                IF SalesSetup."Ext. Doc. No. Mandatory" THEN
                  TESTFIELD("External Document No.");
                SalesCrMemoHeader."Pre-Assigned No. Series" := '';
                SalesCrMemoHeader."Return Order No. Series" := "No. Series";
                SalesCrMemoHeader."Return Order No." := "No.";
                Window.UPDATE(1,STRSUBSTNO(Text008,"Document Type","No.",SalesCrMemoHeader."No."));
              END ELSE BEGIN
                SalesCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
                SalesCrMemoHeader."Pre-Assigned No." := "No.";
                IF "Posting No." <> '' THEN BEGIN
                  SalesCrMemoHeader."No." := "Posting No.";
                  Window.UPDATE(1,STRSUBSTNO(Text008,"Document Type","No.",SalesCrMemoHeader."No."));
                END;
              END;
              SalesCrMemoHeader."Source Code" := SrcCode;
              SalesCrMemoHeader."User ID" := USERID;
              SalesCrMemoHeader."No. Printed" := 0;
              SalesCrMemoHeader.INSERT;
        
              ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Sales Cr.Memo Header",SalesCrMemoHeader."No.");
        
              IF SalesSetup."Copy Cmts Ret.Ord. to Cr. Memo" THEN BEGIN
                CopyCommentLines(
                  "Document Type",SalesCommentLine."Document Type"::"Posted Credit Memo",
                  "No.",SalesCrMemoHeader."No.");
                SalesCrMemoHeader.COPYLINKS(Rec);
              END;
              IF SalesTaxCountry <> SalesTaxCountry::NoTax THEN
                TaxAmountDifference.CopyTaxDifferenceRecords(
                  TaxAmountDifference."Document Product Area"::Sales,"Document Type","No.",
                  TaxAmountDifference."Document Product Area"::"Posted Sale",
                  TaxAmountDifference."Document Type"::"Credit Memo",SalesCrMemoHeader."No.");
              GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo";
              GenJnlLineDocNo := SalesCrMemoHeader."No.";
              GenJnlLineExtDocNo := SalesCrMemoHeader."External Document No.";
            END;
        
          UpdateIncomingDocument("Incoming Document Entry No.","Posting Date",GenJnlLineDocNo);
        
          // Lines
          InvPostingBuffer[1].DELETEALL;
          DropShipPostBuffer.DELETEALL;
          EverythingInvoiced := TRUE;
        
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          LineCount := 0;
          RoundingLineInserted := FALSE;
          MergeSaleslines(SalesHeader,SalesLine,TempPrepaymentSalesLine,CombinedSalesLineTemp);
          AdjustFinalInvWith100PctPrepmt(CombinedSalesLineTemp);
        
          TaxOption := 0;
          IF Invoice THEN BEGIN
            SalesLine.SETFILTER("Qty. to Invoice",'<>0');
            IF SalesLine.FIND('-') THEN
              REPEAT
                IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Sales Tax" THEN BEGIN
                  IF SalesLine."Tax Area Code" <> '' THEN BEGIN
                    IF SalesTaxCountry = SalesTaxCountry::NoTax THEN
                      ERROR(Text27002,
                        TABLECAPTION,FIELDCAPTION("Tax Area Code"),
                        SalesLine.TABLECAPTION,SalesLine.FIELDCAPTION("Tax Area Code"));
        
                    TaxArea.GET(SalesLine."Tax Area Code");
                    IF TaxArea."Country/Region" <> SalesTaxCountry THEN
                      ERROR(Text27003,
                        TABLECAPTION,FIELDCAPTION("Tax Area Code"),TaxArea.FIELDCAPTION("Country/Region"),SalesTaxCountry,
                        SalesLine.TABLECAPTION,SalesLine.FIELDCAPTION("Tax Area Code"));
                    IF TaxArea."Use External Tax Engine" <> UseExternalTaxEngine THEN
                      ERROR(Text27003,
                        TABLECAPTION,FIELDCAPTION("Tax Area Code"),TaxArea.FIELDCAPTION("Use External Tax Engine"),
                        UseExternalTaxEngine,SalesLine.TABLECAPTION,SalesLine.FIELDCAPTION("Tax Area Code"));
                  END;
                  IF TaxOption = 0 THEN BEGIN
                    TaxOption := TaxOption::SalesTax;
                    IF SalesLine."Tax Area Code" <> '' THEN
                      AddSalesTaxLineToSalesTaxCalc(SalesLine,TRUE);
                  END ELSE
                    IF TaxOption = TaxOption::VAT THEN
                      ERROR(Text27001,
                        SalesLine.TABLECAPTION,SalesLine.FIELDCAPTION("VAT Calculation Type"),TaxOption)
                    ELSE
                      IF SalesLine."Tax Area Code" <> '' THEN
                        AddSalesTaxLineToSalesTaxCalc(SalesLine,FALSE);
                END ELSE BEGIN
                  IF TaxOption = 0 THEN
                    TaxOption := TaxOption::VAT
                  ELSE
                    IF TaxOption = TaxOption::SalesTax THEN
                      ERROR(Text27001,SalesLine.TABLECAPTION,SalesLine.FIELDCAPTION("VAT Calculation Type"),TaxOption);
                END;
              UNTIL SalesLine.NEXT = 0;
            SalesLine.SETRANGE("Qty. to Invoice");
          END;
        
          IF TaxOption = TaxOption::SalesTax THEN BEGIN
            IF SalesTaxCountry <> SalesTaxCountry::NoTax THEN BEGIN
              IF UseExternalTaxEngine THEN
                SalesTaxCalculate.CallExternalTaxEngineForSales(SalesHeader,FALSE)
              ELSE
                SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
              SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxAmtLine);
              SalesTaxCalculate.DistTaxOverSalesLines(TempSalesLineForSalesTax);
            END;
          END ELSE BEGIN
            TempVATAmountLineRemainder.DELETEALL;
            SalesLine.CalcVATAmountLines(1,SalesHeader,CombinedSalesLineTemp,TempVATAmountLine);
          END;
        
          SortLines(SalesLine);
          SalesLinesProcessed := FALSE;
          IF SalesLine.FINDSET THEN
            REPEAT
              SalesLine.TESTFIELD(Description);
              IF SalesLine.Type = SalesLine.Type::Item THEN
                DummyTrackingSpecification.CheckItemTrackingQuantity(
                  DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",
                  SalesLine."Qty. to Ship (Base)",SalesLine."Qty. to Invoice (Base)",Ship,Invoice);
              ItemJnlRollRndg := FALSE;
              LineCount := LineCount + 1;
              Window.UPDATE(2,LineCount);
              IF SalesLine."Prepmt. Line Amount" > SalesLine."Prepmt. Amt. Inv." THEN
                SalesLine.FIELDERROR("Prepmt. Line Amount",Text27000);
              IF SalesLine.Type = SalesLine.Type::"Charge (Item)" THEN BEGIN
                SalesLine.TESTFIELD(Amount);
                SalesLine.TESTFIELD("Job No.",'');
                SalesLine.TESTFIELD("Job Contract Entry No.",0);
              END;
              IF SalesLine.Type = SalesLine.Type::Item THEN
                CostBaseAmount := SalesLine."Line Amount";
              IF SalesLine."Qty. per Unit of Measure" = 0 THEN
                SalesLine."Qty. per Unit of Measure" := 1;
              CASE "Document Type" OF
                "Document Type"::Order:
                  SalesLine.TESTFIELD("Return Qty. to Receive",0);
                "Document Type"::Invoice:
                  BEGIN
                    IF SalesLine."Shipment No." = '' THEN
                      SalesLine.TESTFIELD("Qty. to Ship",SalesLine.Quantity);
                    SalesLine.TESTFIELD("Return Qty. to Receive",0);
                    SalesLine.TESTFIELD("Qty. to Invoice",SalesLine.Quantity);
                  END;
                "Document Type"::"Return Order":
                  SalesLine.TESTFIELD("Qty. to Ship",0);
                "Document Type"::"Credit Memo":
                  BEGIN
                    IF SalesLine."Return Receipt No." = '' THEN
                      SalesLine.TESTFIELD("Return Qty. to Receive",SalesLine.Quantity);
                    SalesLine.TESTFIELD("Qty. to Ship",0);
                    SalesLine.TESTFIELD("Qty. to Invoice",SalesLine.Quantity);
                  END;
              END;
        
              TempPostedATOLink.RESET;
              TempPostedATOLink.DELETEALL;
              IF Ship THEN
                PostATO(SalesLine,TempPostedATOLink);
        
              IF NOT (Ship OR RoundingLineInserted) THEN BEGIN
                SalesLine."Qty. to Ship" := 0;
                SalesLine."Qty. to Ship (Base)" := 0;
              END;
              IF NOT (Receive OR RoundingLineInserted) THEN BEGIN
                SalesLine."Return Qty. to Receive" := 0;
                SalesLine."Return Qty. to Receive (Base)" := 0;
              END;
        
              JobContractLine := FALSE;
              IF (SalesLine.Type = SalesLine.Type::Item) OR
                 (SalesLine.Type = SalesLine.Type::"G/L Account") OR
                 (SalesLine.Type = SalesLine.Type::" ")
              THEN
                IF SalesLine."Job Contract Entry No." > 0 THEN
                  PostJobContractLine(SalesLine);
              IF SalesLine.Type = SalesLine.Type::Resource THEN
                JobTaskSalesLine := SalesLine;
        
              IF SalesLine.Type = SalesLine.Type::"Fixed Asset" THEN BEGIN
                SalesLine.TESTFIELD("Job No.",'');
                SalesLine.TESTFIELD("Depreciation Book Code");
                DeprBook.GET(SalesLine."Depreciation Book Code");
                DeprBook.TESTFIELD("G/L Integration - Disposal",TRUE);
                FA.GET(SalesLine."No.");
                FA.TESTFIELD("Budgeted Asset",FALSE);
              END ELSE BEGIN
                SalesLine.TESTFIELD("Depreciation Book Code",'');
                SalesLine.TESTFIELD("Depr. until FA Posting Date",FALSE);
                SalesLine.TESTFIELD("FA Posting Date",0D);
                SalesLine.TESTFIELD("Duplicate in Depreciation Book",'');
                SalesLine.TESTFIELD("Use Duplication List",FALSE);
              END;
        
              IF ("Document Type" = "Document Type"::Invoice) AND (SalesLine."Shipment No." <> '') THEN BEGIN
                SalesLine."Quantity Shipped" := SalesLine.Quantity;
                SalesLine."Qty. Shipped (Base)" := SalesLine."Quantity (Base)";
                SalesLine."Qty. to Ship" := 0;
                SalesLine."Qty. to Ship (Base)" := 0;
              END;
        
              IF ("Document Type" = "Document Type"::"Credit Memo") AND (SalesLine."Return Receipt No." <> '') THEN BEGIN
                SalesLine."Return Qty. Received" := SalesLine.Quantity;
                SalesLine."Return Qty. Received (Base)" := SalesLine."Quantity (Base)";
                SalesLine."Return Qty. to Receive" := 0;
                SalesLine."Return Qty. to Receive (Base)" := 0;
              END;
        
              IF Invoice THEN BEGIN
                IF ABS(SalesLine."Qty. to Invoice") > ABS(SalesLine.MaxQtyToInvoice) THEN
                  SalesLine.InitQtyToInvoice;
              END ELSE BEGIN
                SalesLine."Qty. to Invoice" := 0;
                SalesLine."Qty. to Invoice (Base)" := 0;
              END;
        
              IF (SalesLine.Type = SalesLine.Type::Item) AND (SalesLine."No." <> '') THEN BEGIN
                GetItem(SalesLine);
                IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT SalesLine.IsShipment THEN
                  SalesLine.GetUnitCost;
              END;
        
              IF SalesLine."Qty. to Invoice" + SalesLine."Quantity Invoiced" <> SalesLine.Quantity THEN
                EverythingInvoiced := FALSE;
        
              IF NOT GLSetup."VAT in Use" THEN
                IF (SalesLine.Type >= SalesLine.Type::"G/L Account") AND
                   ((SalesLine."Qty. to Invoice" <> 0) OR (SalesLine."Qty. to Ship" <> 0))
                THEN
                  IF (SalesLine.Type IN [SalesLine.Type::"G/L Account",SalesLine.Type::"Fixed Asset"]) THEN
                    IF (((SalesSetup."Discount Posting" = SalesSetup."Discount Posting"::"Invoice Discounts") AND
                         (SalesLine."Inv. Discount Amount" <> 0)) OR
                        ((SalesSetup."Discount Posting" = SalesSetup."Discount Posting"::"Line Discounts") AND
                         (SalesLine."Line Discount Amount" <> 0)) OR
                        ((SalesSetup."Discount Posting" = SalesSetup."Discount Posting"::"All Discounts") AND
                         ((SalesLine."Inv. Discount Amount" <> 0) OR (SalesLine."Line Discount Amount" <> 0))))
                    THEN BEGIN
                      IF NOT GenPostingSetup.GET(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group") THEN
                        IF SalesLine."Gen. Prod. Posting Group" = '' THEN
                          ERROR(
                            'You must enter a value in %1 for %2 %3 if you want to post discounts for that line.',
                            SalesLine.FIELDNAME("Gen. Prod. Posting Group"),SalesLine.FIELDNAME("Line No."),SalesLine."Line No.")
                        ELSE
                          GenPostingSetup.GET(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");
                    END ELSE
                      CLEAR(GenPostingSetup)
                  ELSE
                    GenPostingSetup.GET(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");
              IF SalesLine.Quantity = 0 THEN
                SalesLine.TESTFIELD(Amount,0)
              ELSE BEGIN
                SalesLine.TESTFIELD("No.");
                SalesLine.TESTFIELD(Type);
                IF GLSetup."VAT in Use" THEN BEGIN
                  SalesLine.TESTFIELD("Gen. Bus. Posting Group");
                  SalesLine.TESTFIELD("Gen. Prod. Posting Group");
                END;
                DivideAmount(1,SalesLine."Qty. to Invoice");
              END;
              IF (SalesLine."Prepayment Line") AND (SalesHeader."Prepmt. Include Tax") THEN BEGIN
                SalesLine.Amount := SalesLine.Amount + (SalesLine."VAT Base Amount" * SalesLine."VAT %" / 100);
                SalesLine."Amount Including VAT" := SalesLine.Amount;
              END;
        
              IF SalesLine."Drop Shipment" THEN BEGIN
                IF SalesLine.Type <> SalesLine.Type::Item THEN
                  SalesLine.TESTFIELD("Drop Shipment",FALSE);
                IF (SalesLine."Qty. to Ship" <> 0) AND (SalesLine."Purch. Order Line No." = 0) THEN
                  ERROR(
                    Text009 +
                    Text010,
                    SalesLine."Line No.");
              END;
        
              CheckItemReservDisruption;
              RoundAmount(SalesLine."Qty. to Invoice");
        
              IF NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) THEN BEGIN
                ReverseAmount(SalesLine);
                ReverseAmount(SalesLineACY);
                IF TaxOption = TaxOption::SalesTax THEN
                  IF TempSalesLineForSalesTax.GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") THEN BEGIN
                    ReverseAmount(TempSalesLineForSalesTax);
                    TempSalesLineForSalesTax.MODIFY;
                  END;
              END;
        
              RemQtyToBeInvoiced := SalesLine."Qty. to Invoice";
              RemQtyToBeInvoicedBase := SalesLine."Qty. to Invoice (Base)";
        
              // Item Tracking:
              IF NOT SalesLine."Prepayment Line" THEN BEGIN
                IF Invoice THEN
                  IF SalesLine."Qty. to Invoice" = 0 THEN
                    TrackingSpecificationExists := FALSE
                  ELSE
                    TrackingSpecificationExists :=
                      ReserveSalesLine.RetrieveInvoiceSpecification(SalesLine,TempInvoicingSpecification);
                EndLoop := FALSE;
        
                IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
                  IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Return Qty. to Receive") THEN BEGIN
                    ReturnRcptLine.RESET;
                    CASE "Document Type" OF
                      "Document Type"::"Return Order":
                        BEGIN
                          ReturnRcptLine.SETCURRENTKEY("Return Order No.","Return Order Line No.");
                          ReturnRcptLine.SETRANGE("Return Order No.",SalesLine."Document No.");
                          ReturnRcptLine.SETRANGE("Return Order Line No.",SalesLine."Line No.");
                        END;
                      "Document Type"::"Credit Memo":
                        BEGIN
                          ReturnRcptLine.SETRANGE("Document No.",SalesLine."Return Receipt No.");
                          ReturnRcptLine.SETRANGE("Line No.",SalesLine."Return Receipt Line No.");
                        END;
                    END;
                    ReturnRcptLine.SETFILTER("Return Qty. Rcd. Not Invd.",'<>0');
                    IF ReturnRcptLine.FIND('-') THEN BEGIN
                      ItemJnlRollRndg := TRUE;
                      REPEAT
                        IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
                          ItemEntryRelation.GET(TempInvoicingSpecification."Item Ledger Entry No.");
                          ReturnRcptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
                        END ELSE
                          ItemEntryRelation."Item Entry No." := ReturnRcptLine."Item Rcpt. Entry No.";
                        ReturnRcptLine.TESTFIELD("Sell-to Customer No.",SalesLine."Sell-to Customer No.");
                        ReturnRcptLine.TESTFIELD(Type,SalesLine.Type);
                        ReturnRcptLine.TESTFIELD("No.",SalesLine."No.");
                        ReturnRcptLine.TESTFIELD("Gen. Bus. Posting Group",SalesLine."Gen. Bus. Posting Group");
                        ReturnRcptLine.TESTFIELD("Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group");
                        ReturnRcptLine.TESTFIELD("Job No.",SalesLine."Job No.");
                        ReturnRcptLine.TESTFIELD("Unit of Measure Code",SalesLine."Unit of Measure Code");
                        ReturnRcptLine.TESTFIELD("Variant Code",SalesLine."Variant Code");
                        IF SalesLine."Qty. to Invoice" * ReturnRcptLine.Quantity < 0 THEN
                          SalesLine.FIELDERROR("Qty. to Invoice",Text024);
                        IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
                          QtyToBeInvoiced := TempInvoicingSpecification."Qty. to Invoice";
                          QtyToBeInvoicedBase := TempInvoicingSpecification."Qty. to Invoice (Base)";
                        END ELSE BEGIN
                          QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Return Qty. to Receive";
                          QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Return Qty. to Receive (Base)";
                        END;
                        IF ABS(QtyToBeInvoiced) >
                           ABS(ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced")
                        THEN BEGIN
                          QtyToBeInvoiced := ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
                          QtyToBeInvoicedBase := ReturnRcptLine."Quantity (Base)" - ReturnRcptLine."Qty. Invoiced (Base)";
                        END;
        
                        IF TrackingSpecificationExists THEN
                          ItemTrackingMgt.AdjustQuantityRounding(
                            RemQtyToBeInvoiced,QtyToBeInvoiced,
                            RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);
        
                        RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                        RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                        ReturnRcptLine."Quantity Invoiced" :=
                          ReturnRcptLine."Quantity Invoiced" + QtyToBeInvoiced;
                        ReturnRcptLine."Qty. Invoiced (Base)" :=
                          ReturnRcptLine."Qty. Invoiced (Base)" + QtyToBeInvoicedBase;
                        ReturnRcptLine."Return Qty. Rcd. Not Invd." :=
                          ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
                        ReturnRcptLine.MODIFY;
                        IF SalesLine.Type = SalesLine.Type::Item THEN
                          PostItemJnlLine(
                            SalesLine,
                            0,0,
                            QtyToBeInvoiced,
                            QtyToBeInvoicedBase,
                            // ReturnRcptLine."Item Rcpt. Entry No."
                            ItemEntryRelation."Item Entry No.",'',TempInvoicingSpecification,FALSE);
                        IF TrackingSpecificationExists THEN
                          EndLoop := (TempInvoicingSpecification.NEXT = 0)
                        ELSE
                          EndLoop :=
                            (ReturnRcptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Return Qty. to Receive"));
                      UNTIL EndLoop;
                    END ELSE
                      ERROR(
                        Text025,
                        SalesLine."Return Receipt Line No.",SalesLine."Return Receipt No.");
                  END;
        
                  IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Return Qty. to Receive") THEN BEGIN
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN
                      ERROR(
                        Text038,
                        ReturnRcptLine."Document No.");
                    ERROR(Text037);
                  END;
                END ELSE BEGIN
                  IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Qty. to Ship") THEN BEGIN
                    SalesShptLine.RESET;
                    CASE "Document Type" OF
                      "Document Type"::Order:
                        BEGIN
                          SalesShptLine.SETCURRENTKEY("Order No.","Order Line No.");
                          SalesShptLine.SETRANGE("Order No.",SalesLine."Document No.");
                          SalesShptLine.SETRANGE("Order Line No.",SalesLine."Line No.");
                        END;
                      "Document Type"::Invoice:
                        BEGIN
                          SalesShptLine.SETRANGE("Document No.",SalesLine."Shipment No.");
                          SalesShptLine.SETRANGE("Line No.",SalesLine."Shipment Line No.");
                        END;
                    END;
        
                    IF NOT TrackingSpecificationExists THEN
                      HasATOShippedNotInvoiced := GetATOItemLedgEntriesNotInvoiced(SalesLine,TempItemLedgEntryNotInvoiced);
        
                    SalesShptLine.SETFILTER("Qty. Shipped Not Invoiced",'<>0');
                    IF SalesShptLine.FINDFIRST THEN BEGIN
                      ItemJnlRollRndg := TRUE;
                      REPEAT
                        SetItemEntryRelation(
                          ItemEntryRelation,SalesShptLine,
                          TempInvoicingSpecification,TempItemLedgEntryNotInvoiced,
                          TrackingSpecificationExists,HasATOShippedNotInvoiced);
        
                        SalesShptLine.TESTFIELD("Sell-to Customer No.",SalesLine."Sell-to Customer No.");
                        SalesShptLine.TESTFIELD(Type,SalesLine.Type);
                        SalesShptLine.TESTFIELD("No.",SalesLine."No.");
                        SalesShptLine.TESTFIELD("Gen. Bus. Posting Group",SalesLine."Gen. Bus. Posting Group");
                        SalesShptLine.TESTFIELD("Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group");
                        SalesShptLine.TESTFIELD("Job No.",SalesLine."Job No.");
                        SalesShptLine.TESTFIELD("Unit of Measure Code",SalesLine."Unit of Measure Code");
                        SalesShptLine.TESTFIELD("Variant Code",SalesLine."Variant Code");
                        IF -SalesLine."Qty. to Invoice" * SalesShptLine.Quantity < 0 THEN
                          SalesLine.FIELDERROR("Qty. to Invoice",Text011);
        
                        UpdateQtyToBeInvoiced(
                          QtyToBeInvoiced,QtyToBeInvoicedBase,
                          TrackingSpecificationExists,HasATOShippedNotInvoiced,
                          SalesLine,SalesShptLine,
                          TempInvoicingSpecification,TempItemLedgEntryNotInvoiced);
        
                        IF TrackingSpecificationExists OR HasATOShippedNotInvoiced THEN
                          ItemTrackingMgt.AdjustQuantityRounding(
                            RemQtyToBeInvoiced,QtyToBeInvoiced,
                            RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);
        
                        RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                        RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                        SalesShptLine."Quantity Invoiced" :=
                          SalesShptLine."Quantity Invoiced" - QtyToBeInvoiced;
                        SalesShptLine."Qty. Invoiced (Base)" :=
                          SalesShptLine."Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
                        SalesShptLine."Qty. Shipped Not Invoiced" :=
                          SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced";
                        SalesShptLine.MODIFY;
                        IF SalesLine.Type = SalesLine.Type::Item THEN
                          PostItemJnlLine(
                            SalesLine,
                            0,0,
                            QtyToBeInvoiced,
                            QtyToBeInvoicedBase,
                            // SalesShptLine."Item Shpt. Entry No."
                            ItemEntryRelation."Item Entry No.",'',TempInvoicingSpecification,FALSE);
                      UNTIL IsEndLoopForShippedNotInvoiced(
                              RemQtyToBeInvoiced,TrackingSpecificationExists,HasATOShippedNotInvoiced,
                              SalesShptLine,TempInvoicingSpecification,TempItemLedgEntryNotInvoiced,SalesLine);
                    END ELSE
                      ERROR(
                        Text026,
                        SalesLine."Shipment Line No.",SalesLine."Shipment No.");
                  END;
        
                  IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Qty. to Ship") THEN BEGIN
                    IF "Document Type" = "Document Type"::Invoice THEN
                      ERROR(
                        Text027,
                        SalesShptLine."Document No.");
                    ERROR(Text013);
                  END;
                END;
        
                IF TrackingSpecificationExists THEN
                  SaveInvoiceSpecification(TempInvoicingSpecification);
              END;
        
              CASE SalesLine.Type OF
                SalesLine.Type::"G/L Account":
                  IF (SalesLine."No." <> '') AND NOT SalesLine."System-Created Entry" THEN BEGIN
                    GLAcc.GET(SalesLine."No.");
                    GLAcc.TESTFIELD("Direct Posting",TRUE);
                    IF (SalesLine."IC Partner Code" <> '') AND Invoice THEN
                      InsertICGenJnlLine(TempSalesLine);
                  END;
                SalesLine.Type::Item:
                  BEGIN
                    IF (SalesLine."Qty. to Ship" <> 0) AND (SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
                      DropShipPostBuffer."Order No." := SalesLine."Purchase Order No.";
                      DropShipPostBuffer."Order Line No." := SalesLine."Purch. Order Line No.";
                      DropShipPostBuffer.Quantity := -SalesLine."Qty. to Ship";
                      DropShipPostBuffer."Quantity (Base)" := -SalesLine."Qty. to Ship (Base)";
                      DropShipPostBuffer."Item Shpt. Entry No." :=
                        PostAssocItemJnlLine(DropShipPostBuffer.Quantity,DropShipPostBuffer."Quantity (Base)");
                      DropShipPostBuffer.INSERT;
                      SalesLine."Appl.-to Item Entry" := DropShipPostBuffer."Item Shpt. Entry No.";
                    END;
        
                    CLEAR(TempPostedATOLink);
                    TempPostedATOLink.SETRANGE("Order No.",SalesLine."Document No.");
                    TempPostedATOLink.SETRANGE("Order Line No.",SalesLine."Line No.");
                    IF TempPostedATOLink.FINDFIRST THEN
                      PostATOAssocItemJnlLine(SalesLine,TempPostedATOLink,RemQtyToBeInvoiced,RemQtyToBeInvoicedBase);
        
                    IF RemQtyToBeInvoiced <> 0 THEN
                      ItemLedgShptEntryNo :=
                        PostItemJnlLine(
                          SalesLine,
                          RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
                          RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
                          0,'',DummyTrackingSpecification,FALSE);
        
                    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
                      IF ABS(SalesLine."Return Qty. to Receive") > ABS(RemQtyToBeInvoiced) THEN
                        ItemLedgShptEntryNo :=
                          PostItemJnlLine(
                            SalesLine,
                            SalesLine."Return Qty. to Receive" - RemQtyToBeInvoiced,
                            SalesLine."Return Qty. to Receive (Base)" - RemQtyToBeInvoicedBase,
                            0,0,0,'',DummyTrackingSpecification,FALSE);
                    END ELSE BEGIN
                      IF ABS(SalesLine."Qty. to Ship") > ABS(RemQtyToBeInvoiced) + ABS(TempPostedATOLink."Assembled Quantity") THEN
                        ItemLedgShptEntryNo :=
                          PostItemJnlLine(
                            SalesLine,
                            SalesLine."Qty. to Ship" - TempPostedATOLink."Assembled Quantity" - RemQtyToBeInvoiced,
                            SalesLine."Qty. to Ship (Base)" - TempPostedATOLink."Assembled Quantity (Base)" - RemQtyToBeInvoicedBase,
                            0,0,0,'',DummyTrackingSpecification,FALSE);
                    END;
                  END;
                SalesLine.Type::Resource:
                  IF SalesLine."Qty. to Invoice" <> 0 THEN BEGIN
                    ResJnlLine.INIT;
                    ResJnlLine."Posting Date" := "Posting Date";
                    ResJnlLine."Document Date" := "Document Date";
                    ResJnlLine."Reason Code" := "Reason Code";
                    ResJnlLine."Resource No." := SalesLine."No.";
                    ResJnlLine.Description := SalesLine.Description;
                    ResJnlLine."Source Type" := ResJnlLine."Source Type"::Customer;
                    ResJnlLine."Source No." := SalesLine."Sell-to Customer No.";
                    ResJnlLine."Work Type Code" := SalesLine."Work Type Code";
                    ResJnlLine."Job No." := SalesLine."Job No.";
                    ResJnlLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                    ResJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
                    ResJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
                    ResJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";
                    ResJnlLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
                    ResJnlLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
                    ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Sale;
                    ResJnlLine."Document No." := GenJnlLineDocNo;
                    ResJnlLine."External Document No." := GenJnlLineExtDocNo;
                    ResJnlLine.Quantity := -SalesLine."Qty. to Invoice";
                    ResJnlLine."Unit Cost" := SalesLine."Unit Cost (LCY)";
                    ResJnlLine."Total Cost" := SalesLine."Unit Cost (LCY)" * ResJnlLine.Quantity;
                    ResJnlLine."Unit Price" := -SalesLine.Amount / SalesLine.Quantity;
                    ResJnlLine."Total Price" := -SalesLine.Amount;
                    ResJnlLine."Source Code" := SrcCode;
                    ResJnlLine."Posting No. Series" := "Posting No. Series";
                    ResJnlLine."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
                    ResJnlPostLine.RunWithCheck(ResJnlLine);
                    IF JobTaskSalesLine."Job Contract Entry No." > 0 THEN
                      PostJobContractLine(JobTaskSalesLine);
                  END;
                SalesLine.Type::"Charge (Item)":
                  IF Invoice OR ItemChargeAssgntOnly THEN BEGIN
                    ItemJnlRollRndg := TRUE;
                    ClearItemChargeAssgntFilter;
                    TempItemChargeAssgntSales.SETCURRENTKEY("Applies-to Doc. Type");
                    TempItemChargeAssgntSales.SETRANGE("Document Line No.",SalesLine."Line No.");
                    IF TempItemChargeAssgntSales.FINDSET THEN
                      REPEAT
                        IF ItemChargeAssgntOnly AND (GenJnlLineDocNo = '') THEN
                          GenJnlLineDocNo := TempItemChargeAssgntSales."Applies-to Doc. No.";
                        CASE TempItemChargeAssgntSales."Applies-to Doc. Type" OF
                          TempItemChargeAssgntSales."Applies-to Doc. Type"::Shipment:
                            BEGIN
                              PostItemChargePerShpt(SalesLine);
                              TempItemChargeAssgntSales.MARK(TRUE);
                            END;
                          TempItemChargeAssgntSales."Applies-to Doc. Type"::"Return Receipt":
                            BEGIN
                              PostItemChargePerRetRcpt(SalesLine);
                              TempItemChargeAssgntSales.MARK(TRUE);
                            END;
                          TempItemChargeAssgntSales."Applies-to Doc. Type"::Order,
                          TempItemChargeAssgntSales."Applies-to Doc. Type"::Invoice,
                          TempItemChargeAssgntSales."Applies-to Doc. Type"::"Return Order",
                          TempItemChargeAssgntSales."Applies-to Doc. Type"::"Credit Memo":
                            CheckItemCharge(TempItemChargeAssgntSales);
                        END;
                      UNTIL TempItemChargeAssgntSales.NEXT = 0;
                  END;
              END;
        
              IF (SalesLine.Type >= SalesLine.Type::"G/L Account") AND (SalesLine."Qty. to Invoice" <> 0) THEN BEGIN
                AdjustPrepmtAmountLCY(SalesLine);
                // Copy sales to buffer
                FillInvPostingBuffer(SalesLine,SalesLineACY);
                InsertPrepmtAdjInvPostingBuf(SalesLine);
              END;
        
              IF NOT ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) THEN
                SalesLine.TESTFIELD("Job No.",'');
        
              IF (SalesShptHeader."No." <> '') AND (SalesLine."Shipment No." = '') AND
                 NOT RoundingLineInserted AND NOT TempSalesLine."Prepayment Line"
              THEN BEGIN
                // Insert shipment line
                SalesShptLine.INIT;
                SalesShptLine.TRANSFERFIELDS(TempSalesLine);
                SalesShptLine."Posting Date" := "Posting Date";
                SalesShptLine."Document No." := SalesShptHeader."No.";
                SalesShptLine.Quantity := TempSalesLine."Qty. to Ship";
                SalesShptLine."Quantity (Base)" := TempSalesLine."Qty. to Ship (Base)";
                IF ABS(TempSalesLine."Qty. to Invoice") > ABS(TempSalesLine."Qty. to Ship") THEN BEGIN
                  SalesShptLine."Quantity Invoiced" := TempSalesLine."Qty. to Ship";
                  SalesShptLine."Qty. Invoiced (Base)" := TempSalesLine."Qty. to Ship (Base)";
                END ELSE BEGIN
                  SalesShptLine."Quantity Invoiced" := TempSalesLine."Qty. to Invoice";
                  SalesShptLine."Qty. Invoiced (Base)" := TempSalesLine."Qty. to Invoice (Base)";
                END;
                SalesShptLine."Qty. Shipped Not Invoiced" :=
                  SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced";
                IF "Document Type" = "Document Type"::Order THEN BEGIN
                  SalesShptLine."Order No." := TempSalesLine."Document No.";
                  SalesShptLine."Order Line No." := TempSalesLine."Line No.";
                END;
        
                IF (SalesLine.Type = SalesLine.Type::Item) AND (TempSalesLine."Qty. to Ship" <> 0) THEN BEGIN
                  IF WhseShip THEN BEGIN
                    WhseShptLine.SETCURRENTKEY(
                      "No.","Source Type","Source Subtype","Source No.","Source Line No.");
                    WhseShptLine.SETRANGE("No.",WhseShptHeader."No.");
                    WhseShptLine.SETRANGE("Source Type",DATABASE::"Sales Line");
                    WhseShptLine.SETRANGE("Source Subtype",SalesLine."Document Type");
                    WhseShptLine.SETRANGE("Source No.",SalesLine."Document No.");
                    WhseShptLine.SETRANGE("Source Line No.",SalesLine."Line No.");
                    WhseShptLine.FINDFIRST;
        
                    PostWhseShptLines(WhseShptLine,SalesShptLine,SalesLine);
                  END;
                  IF WhseReceive THEN BEGIN
                    WhseRcptLine.SETCURRENTKEY(
                      "No.","Source Type","Source Subtype","Source No.","Source Line No.");
                    WhseRcptLine.SETRANGE("No.",WhseRcptHeader."No.");
                    WhseRcptLine.SETRANGE("Source Type",DATABASE::"Sales Line");
                    WhseRcptLine.SETRANGE("Source Subtype",SalesLine."Document Type");
                    WhseRcptLine.SETRANGE("Source No.",SalesLine."Document No.");
                    WhseRcptLine.SETRANGE("Source Line No.",SalesLine."Line No.");
                    WhseRcptLine.FINDFIRST;
                    WhseRcptLine.TESTFIELD("Qty. to Receive",-SalesShptLine.Quantity);
                    SaveTempWhseSplitSpec(SalesLine);
                    WhsePostRcpt.CreatePostedRcptLine(
                      WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
                  END;
        
                  SalesShptLine."Item Shpt. Entry No." :=
                    InsertShptEntryRelation(SalesShptLine); // ItemLedgShptEntryNo
                  SalesShptLine."Item Charge Base Amount" :=
                    ROUND(CostBaseAmount / SalesLine.Quantity * SalesShptLine.Quantity);
                END;
                SalesShptLine."Authorized for Credit Card" := IsAuthorized(TransactionLogEntryNo);
                SalesShptLine.INSERT;
        
                ServItemMgt.CreateServItemOnSalesLineShpt(Rec,TempSalesLine,SalesShptLine);
        
                IF SalesLine."BOM Item No." <> '' THEN BEGIN
                  ServItemMgt.ReturnServItemComp(ServiceItemTmp1,ServiceItemCmpTmp1);
                  IF ServiceItemTmp1.FIND('-') THEN
                    REPEAT
                      ServiceItemTmp2 := ServiceItemTmp1;
                      IF ServiceItemTmp2.INSERT THEN;
                    UNTIL ServiceItemTmp1.NEXT = 0;
                  IF ServiceItemCmpTmp1.FIND('-') THEN
                    REPEAT
                      ServiceItemCmpTmp2 := ServiceItemCmpTmp1;
                      IF ServiceItemCmpTmp2.INSERT THEN;
                    UNTIL ServiceItemCmpTmp1.NEXT = 0;
                END;
              END;
        
              IF (ReturnRcptHeader."No." <> '') AND (SalesLine."Return Receipt No." = '') AND
                 NOT RoundingLineInserted
              THEN BEGIN
                // Insert return receipt line
                ReturnRcptLine.INIT;
                ReturnRcptLine.TRANSFERFIELDS(TempSalesLine);
                ReturnRcptLine."Document No." := ReturnRcptHeader."No.";
                ReturnRcptLine."Posting Date" := ReturnRcptHeader."Posting Date";
                ReturnRcptLine.Quantity := TempSalesLine."Return Qty. to Receive";
                ReturnRcptLine."Quantity (Base)" := TempSalesLine."Return Qty. to Receive (Base)";
                IF ABS(TempSalesLine."Qty. to Invoice") > ABS(TempSalesLine."Return Qty. to Receive") THEN BEGIN
                  ReturnRcptLine."Quantity Invoiced" := TempSalesLine."Return Qty. to Receive";
                  ReturnRcptLine."Qty. Invoiced (Base)" := TempSalesLine."Return Qty. to Receive (Base)";
                END ELSE BEGIN
                  ReturnRcptLine."Quantity Invoiced" := TempSalesLine."Qty. to Invoice";
                  ReturnRcptLine."Qty. Invoiced (Base)" := TempSalesLine."Qty. to Invoice (Base)";
                END;
                ReturnRcptLine."Return Qty. Rcd. Not Invd." :=
                  ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
                IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                  ReturnRcptLine."Return Order No." := TempSalesLine."Document No.";
                  ReturnRcptLine."Return Order Line No." := TempSalesLine."Line No.";
                END;
                IF (SalesLine.Type = SalesLine.Type::Item) AND (TempSalesLine."Return Qty. to Receive" <> 0) THEN BEGIN
                  IF WhseReceive THEN BEGIN
                    WhseRcptLine.SETCURRENTKEY(
                      "No.","Source Type","Source Subtype","Source No.","Source Line No.");
                    WhseRcptLine.SETRANGE("No.",WhseRcptHeader."No.");
                    WhseRcptLine.SETRANGE("Source Type",DATABASE::"Sales Line");
                    WhseRcptLine.SETRANGE("Source Subtype",SalesLine."Document Type");
                    WhseRcptLine.SETRANGE("Source No.",SalesLine."Document No.");
                    WhseRcptLine.SETRANGE("Source Line No.",SalesLine."Line No.");
                    WhseRcptLine.FINDFIRST;
                    WhseRcptLine.TESTFIELD("Qty. to Receive",ReturnRcptLine.Quantity);
                    SaveTempWhseSplitSpec(SalesLine);
                    WhsePostRcpt.CreatePostedRcptLine(
                      WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
                  END;
                  IF WhseShip THEN BEGIN
                    WhseShptLine.SETCURRENTKEY(
                      "No.","Source Type","Source Subtype","Source No.","Source Line No.");
                    WhseShptLine.SETRANGE("No.",WhseShptHeader."No.");
                    WhseShptLine.SETRANGE("Source Type",DATABASE::"Sales Line");
                    WhseShptLine.SETRANGE("Source Subtype",SalesLine."Document Type");
                    WhseShptLine.SETRANGE("Source No.",SalesLine."Document No.");
                    WhseShptLine.SETRANGE("Source Line No.",SalesLine."Line No.");
                    WhseShptLine.FINDFIRST;
                    WhseShptLine.TESTFIELD("Qty. to Ship",-ReturnRcptLine.Quantity);
                    SaveTempWhseSplitSpec(SalesLine);
                    WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
                    WhsePostShpt.CreatePostedShptLine(
                      WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
                  END;
        
                  ReturnRcptLine."Item Rcpt. Entry No." :=
                    InsertReturnEntryRelation(ReturnRcptLine); // ItemLedgShptEntryNo;
                  ReturnRcptLine."Item Charge Base Amount" :=
                    ROUND(CostBaseAmount / SalesLine.Quantity * ReturnRcptLine.Quantity);
                END;
                ReturnRcptLine.INSERT;
              END;
        
              IF Invoice THEN BEGIN
                // Insert invoice line or credit memo line
                IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
                  SalesInvLine.INIT;
                  SalesInvLine.TRANSFERFIELDS(TempSalesLine);
                  SalesInvLine."Posting Date" := "Posting Date";
                  SalesInvLine."Document No." := SalesInvHeader."No.";
                  SalesInvLine.Quantity := TempSalesLine."Qty. to Invoice";
                  SalesInvLine."Quantity (Base)" := TempSalesLine."Qty. to Invoice (Base)";
                  SalesInvLine.INSERT;
                  ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,SalesInvLine.RowID1);
                END ELSE BEGIN // Credit Memo
                  SalesCrMemoLine.INIT;
                  SalesCrMemoLine.TRANSFERFIELDS(TempSalesLine);
                  SalesCrMemoLine."Posting Date" := "Posting Date";
                  SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
                  SalesCrMemoLine.Quantity := TempSalesLine."Qty. to Invoice";
                  SalesCrMemoLine."Quantity (Base)" := TempSalesLine."Qty. to Invoice (Base)";
                  SalesCrMemoLine.INSERT;
                  ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,SalesCrMemoLine.RowID1);
                END;
              END;
        
              IF RoundingLineInserted THEN
                LastLineRetrieved := TRUE
              ELSE BEGIN
                BiggestLineNo := MAX(BiggestLineNo,SalesLine."Line No.");
                LastLineRetrieved := GetNextSalesline(SalesLine);
                IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
                  InvoiceRounding(FALSE,BiggestLineNo);
              END;
            UNTIL LastLineRetrieved;
        
          IF NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) THEN BEGIN
            ReverseAmount(TotalSalesLine);
            ReverseAmount(TotalSalesLineLCY);
            TotalSalesLineLCY."Unit Cost (LCY)" := -TotalSalesLineLCY."Unit Cost (LCY)";
          END;
        
          // Post drop shipment of purchase order
          PurchSetup.GET;
          IF DropShipPostBuffer.FIND('-') THEN
            REPEAT
              PurchOrderHeader.GET(
                PurchOrderHeader."Document Type"::Order,
                DropShipPostBuffer."Order No.");
              PurchRcptHeader.INIT;
              PurchRcptHeader.TRANSFERFIELDS(PurchOrderHeader);
              PurchRcptHeader."No." := PurchOrderHeader."Receiving No.";
              PurchRcptHeader."Order No." := PurchOrderHeader."No.";
              PurchRcptHeader."Posting Date" := "Posting Date";
              PurchRcptHeader."Document Date" := "Document Date";
              PurchRcptHeader."No. Printed" := 0;
              PurchRcptHeader.INSERT;
        
              ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Purch. Rcpt. Header",PurchRcptHeader."No.");
        
              IF PurchSetup."Copy Comments Order to Receipt" THEN BEGIN
                CopyPurchCommentLines(
                  PurchOrderHeader."Document Type",PurchCommentLine."Document Type"::Receipt,
                  PurchOrderHeader."No.",PurchRcptHeader."No.");
                PurchRcptHeader.COPYLINKS(Rec);
              END;
              DropShipPostBuffer.SETRANGE("Order No.",DropShipPostBuffer."Order No.");
              REPEAT
                PurchOrderLine.GET(
                  PurchOrderLine."Document Type"::Order,
                  DropShipPostBuffer."Order No.",DropShipPostBuffer."Order Line No.");
                PurchRcptLine.INIT;
                PurchRcptLine.TRANSFERFIELDS(PurchOrderLine);
                PurchRcptLine."Posting Date" := PurchRcptHeader."Posting Date";
                PurchRcptLine."Document No." := PurchRcptHeader."No.";
                PurchRcptLine.Quantity := DropShipPostBuffer.Quantity;
                PurchRcptLine."Quantity (Base)" := DropShipPostBuffer."Quantity (Base)";
                PurchRcptLine."Quantity Invoiced" := 0;
                PurchRcptLine."Qty. Invoiced (Base)" := 0;
                PurchRcptLine."Order No." := PurchOrderLine."Document No.";
                PurchRcptLine."Order Line No." := PurchOrderLine."Line No.";
                PurchRcptLine."Qty. Rcd. Not Invoiced" :=
                  PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
        
                IF PurchRcptLine.Quantity <> 0 THEN BEGIN
                  PurchRcptLine."Item Rcpt. Entry No." := DropShipPostBuffer."Item Shpt. Entry No.";
                  PurchRcptLine."Item Charge Base Amount" := PurchOrderLine."Line Amount"
                END;
                PurchRcptLine.INSERT;
                PurchOrderLine."Qty. to Receive" := DropShipPostBuffer.Quantity;
                PurchOrderLine."Qty. to Receive (Base)" := DropShipPostBuffer."Quantity (Base)";
                PurchPost.UpdateBlanketOrderLine(PurchOrderLine,TRUE,FALSE,FALSE);
              UNTIL DropShipPostBuffer.NEXT = 0;
              DropShipPostBuffer.SETRANGE("Order No.");
            UNTIL DropShipPostBuffer.NEXT = 0;
        
          InvtSetup.GET;
          IF InvtSetup."Automatic Cost Adjustment" <>
             InvtSetup."Automatic Cost Adjustment"::Never
          THEN BEGIN
            InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
            InvtAdjmt.SetJobUpdateProperties(TRUE);
            InvtAdjmt.MakeMultiLevelAdjmt;
          END;
        
          IF Invoice THEN BEGIN
            // Post sales and VAT to G/L entries from posting buffer
            LineCount := 0;
            IF InvPostingBuffer[1].FIND('+') THEN
              REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(3,LineCount);
        
                GenJnlLine.INIT;
                GenJnlLine."Posting Date" := "Posting Date";
                GenJnlLine."Document Date" := "Document Date";
                GenJnlLine.Description := "Posting Description";
                GenJnlLine."Reason Code" := "Reason Code";
                GenJnlLine."Document Type" := GenJnlLineDocType;
                GenJnlLine."Document No." := GenJnlLineDocNo;
                GenJnlLine."External Document No." := GenJnlLineExtDocNo;
                GenJnlLine."Account No." := InvPostingBuffer[1]."G/L Account";
                GenJnlLine."System-Created Entry" := InvPostingBuffer[1]."System-Created Entry";
                GenJnlLine.Amount := InvPostingBuffer[1].Amount;
                GenJnlLine."Source Currency Code" := "Currency Code";
                GenJnlLine."Source Currency Amount" := InvPostingBuffer[1]."Amount (ACY)";
                GenJnlLine.Correction := Correction;
                IF InvPostingBuffer[1].Type <> InvPostingBuffer[1].Type::"Prepmt. Exch. Rate Difference" THEN
                  GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Sale;
                GenJnlLine."Gen. Bus. Posting Group" := InvPostingBuffer[1]."Gen. Bus. Posting Group";
                GenJnlLine."Gen. Prod. Posting Group" := InvPostingBuffer[1]."Gen. Prod. Posting Group";
                GenJnlLine."VAT Bus. Posting Group" := InvPostingBuffer[1]."VAT Bus. Posting Group";
                GenJnlLine."VAT Prod. Posting Group" := InvPostingBuffer[1]."VAT Prod. Posting Group";
                GenJnlLine."Tax Area Code" := InvPostingBuffer[1]."Tax Area Code";
                GenJnlLine."Tax Liable" := InvPostingBuffer[1]."Tax Liable";
                GenJnlLine."Tax Group Code" := InvPostingBuffer[1]."Tax Group Code";
                GenJnlLine."Use Tax" := InvPostingBuffer[1]."Use Tax";
                GenJnlLine.Quantity := InvPostingBuffer[1].Quantity;
                GenJnlLine."VAT Calculation Type" := InvPostingBuffer[1]."VAT Calculation Type";
                GenJnlLine."VAT Base Amount" := InvPostingBuffer[1]."VAT Base Amount";
                GenJnlLine."VAT Base Discount %" := "VAT Base Discount %";
                GenJnlLine."Source Curr. VAT Base Amount" := InvPostingBuffer[1]."VAT Base Amount (ACY)";
                GenJnlLine."VAT Amount" := InvPostingBuffer[1]."VAT Amount";
                GenJnlLine."Source Curr. VAT Amount" := InvPostingBuffer[1]."VAT Amount (ACY)";
                GenJnlLine."VAT Difference" := InvPostingBuffer[1]."VAT Difference";
                GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
                GenJnlLine."Job No." := InvPostingBuffer[1]."Job No.";
                GenJnlLine."Shortcut Dimension 1 Code" := InvPostingBuffer[1]."Global Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := InvPostingBuffer[1]."Global Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := InvPostingBuffer[1]."Dimension Set ID";
                GenJnlLine."Source Code" := SrcCode;
                GenJnlLine."EU 3-Party Trade" := "EU 3-Party Trade";
                GenJnlLine."Sell-to/Buy-from No." := "Sell-to Customer No.";
                GenJnlLine."Bill-to/Pay-to No." := "Bill-to Customer No.";
                GenJnlLine."Country/Region Code" := "VAT Country/Region Code";
                GenJnlLine."VAT Registration No." := "VAT Registration No.";
                GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
                GenJnlLine."Source No." := "Bill-to Customer No.";
                GenJnlLine."Posting No. Series" := "Posting No. Series";
                GenJnlLine."Ship-to/Order Address Code" := "Ship-to Code";
        
                // Localizado para Cada Pais DsPOS
                CASE cduPOS.Pais() OF
                  1:cfDominicana.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader); // Dominicana
                  2:cfBolivia.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader); // Bolivia
                  3:cfParaguay.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader); // Paraguay
                  4:cfEcuador.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader); // Ecuador
                  5:cfGuatemala.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader); // Guatemala
                  6:cfSalvador.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader); // Salvador
                END;
                // Fin Localizado
        
                IF InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"Fixed Asset" THEN BEGIN
                  GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Fixed Asset";
                  GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::Disposal;
                  GenJnlLine."FA Posting Date" := InvPostingBuffer[1]."FA Posting Date";
                  GenJnlLine."Depreciation Book Code" := InvPostingBuffer[1]."Depreciation Book Code";
                  GenJnlLine."Depr. until FA Posting Date" := InvPostingBuffer[1]."Depr. until FA Posting Date";
                  GenJnlLine."Duplicate in Depreciation Book" := InvPostingBuffer[1]."Duplicate in Depreciation Book";
                  GenJnlLine."Use Duplication List" := InvPostingBuffer[1]."Use Duplication List";
                END;
        
                GenJnlLine."IC Partner Code" := "Sell-to IC Partner Code";
                GLEntryNo := RunGenJnlPostLine(GenJnlLine);
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.VALIDATE("FA Posting Type",GenJnlLine."FA Posting Type"::" ");
        
        
                IF (InvPostingBuffer[1]."Job No." <> '') AND (InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"G/L Account") THEN
                  JobPostLine.SetGLEntryNoOnJobLedgerEntry(InvPostingBuffer[1],"Posting Date",GenJnlLineDocNo,GLEntryNo);
        
              UNTIL InvPostingBuffer[1].NEXT(-1) = 0;
        
            InvPostingBuffer[1].DELETEALL;
        
            IF TaxOption = TaxOption::SalesTax THEN BEGIN
              IF "Tax Area Code" <> '' THEN BEGIN
                PostSalesTaxToGL;
                IF Invoice THEN
                  TaxAmountDifference.ClearDocDifference(TaxAmountDifference."Document Product Area"::Sales,"Document Type","No.");
              END;
            END;
            IF (TotalSalesLineLCY."VAT %" = 0) AND ("Tax Area Code" = '') THEN
              TotalSalesLineLCY."Amount Including VAT" := TotalSalesLineLCY.Amount;
            // Post customer entry
            Window.UPDATE(4,1);
            PostCustomerEntry(
              SalesHeader,TotalSalesLine,TotalSalesLineLCY,
              GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
        
            UpdateSalesHeader(CustLedgEntry);
        
            // Balancing account
            IF "Bal. Account No." <> '' THEN BEGIN
              Window.UPDATE(5,1);
              IF NOT IsOnlinePayment(SalesHeader) THEN
                PostBalanceEntry(
                  0,SalesHeader,TotalSalesLine,TotalSalesLineLCY,
                  GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
            END;
        
          END;
        
          IF ICGenJnlLineNo > 0 THEN
            PostICGenJnl;
        
          IF Ship THEN BEGIN
            "Last Shipping No." := "Shipping No.";
            "Shipping No." := '';
          END;
          IF Invoice THEN BEGIN
            "Last Posting No." := "Posting No.";
            "Posting No." := '';
            "STE Transaction ID" := '';
          END;
          IF Receive THEN BEGIN
            "Last Return Receipt No." := "Return Receipt No.";
            "Return Receipt No." := '';
          END;
        
          IF ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) AND
             (NOT EverythingInvoiced)
          THEN BEGIN
            MODIFY;
            // Insert T336 records
            InsertTrackingSpecification;
        
            IF SalesLine.FINDSET THEN
              REPEAT
                IF SalesLine.Quantity <> 0 THEN BEGIN
                  IF Ship THEN BEGIN
                    SalesLine."Quantity Shipped" :=
                      SalesLine."Quantity Shipped" +
                      SalesLine."Qty. to Ship";
                    SalesLine."Qty. Shipped (Base)" :=
                      SalesLine."Qty. Shipped (Base)" +
                      SalesLine."Qty. to Ship (Base)";
                  END;
                  IF Receive THEN BEGIN
                    SalesLine."Return Qty. Received" :=
                      SalesLine."Return Qty. Received" + SalesLine."Return Qty. to Receive";
                    SalesLine."Return Qty. Received (Base)" :=
                      SalesLine."Return Qty. Received (Base)" +
                      SalesLine."Return Qty. to Receive (Base)";
                  END;
                  IF Invoice THEN BEGIN
                    IF "Document Type" = "Document Type"::Order THEN BEGIN
                      IF ABS(SalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice") >
                         ABS(SalesLine."Quantity Shipped")
                      THEN BEGIN
                        SalesLine.VALIDATE("Qty. to Invoice",
                          SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced");
                        SalesLine."Qty. to Invoice (Base)" :=
                          SalesLine."Qty. Shipped (Base)" - SalesLine."Qty. Invoiced (Base)";
                      END;
                    END ELSE
                      IF ABS(SalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice") >
                         ABS(SalesLine."Return Qty. Received")
                      THEN BEGIN
                        SalesLine.VALIDATE("Qty. to Invoice",
                          SalesLine."Return Qty. Received" - SalesLine."Quantity Invoiced");
                        SalesLine."Qty. to Invoice (Base)" :=
                          SalesLine."Return Qty. Received (Base)" - SalesLine."Qty. Invoiced (Base)";
                      END;
        
                    SalesLine."Quantity Invoiced" := SalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice";
                    SalesLine."Qty. Invoiced (Base)" := SalesLine."Qty. Invoiced (Base)" + SalesLine."Qty. to Invoice (Base)";
                    IF SalesLine."Qty. to Invoice" <> 0 THEN BEGIN
                      SalesLine."Prepmt Amt Deducted" :=
                        SalesLine."Prepmt Amt Deducted" + SalesLine."Prepmt Amt to Deduct";
                      SalesLine."Prepmt VAT Diff. Deducted" :=
                        SalesLine."Prepmt VAT Diff. Deducted" + SalesLine."Prepmt VAT Diff. to Deduct";
                      DecrementPrepmtAmtInvLCY(
                        SalesLine,SalesLine."Prepmt. Amount Inv. (LCY)",SalesLine."Prepmt. VAT Amount Inv. (LCY)");
                      SalesLine."Prepmt Amt to Deduct" :=
                        SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted";
                      SalesLine."Prepmt VAT Diff. to Deduct" := 0;
                    END;
                  END;
        
                  UpdateBlanketOrderLine(SalesLine,Ship,Receive,Invoice);
                  SalesLine.InitOutstanding;
                  CheckATOLink(SalesLine);
                  IF WhseHandlingRequired OR (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank)
                  THEN BEGIN
                    IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                      SalesLine."Return Qty. to Receive" := 0;
                      SalesLine."Return Qty. to Receive (Base)" := 0;
                    END ELSE BEGIN
                      SalesLine."Qty. to Ship" := 0;
                      SalesLine."Qty. to Ship (Base)" := 0;
                    END;
                    SalesLine.InitQtyToInvoice;
                  END ELSE BEGIN
                    IF "Document Type" = "Document Type"::"Return Order" THEN
                      SalesLine.InitQtyToReceive
                    ELSE
                      SalesLine.InitQtyToShip2;
                  END;
        
                  IF (SalesLine."Purch. Order Line No." <> 0) AND
                     (SalesLine.Quantity = SalesLine."Quantity Invoiced")
                  THEN
                    UpdateAssocLines(SalesLine);
                  SalesLine.SetDefaultQuantity;
                  SalesLine.MODIFY;
                END;
              UNTIL SalesLine.NEXT = 0;
        
            UpdateAssocOrder;
        
            IF WhseReceive THEN BEGIN
              WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
              TempWhseRcptHeader.DELETE;
            END;
            IF WhseShip THEN BEGIN
              WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
              TempWhseShptHeader.DELETE;
            END;
        
            WhseSalesRelease.Release(SalesHeader);
            UpdateItemChargeAssgnt;
          END ELSE BEGIN
            CASE "Document Type" OF
              "Document Type"::Invoice:
                BEGIN
                  SalesLine.SETFILTER("Shipment No.",'<>%1','');
                  IF SalesLine.FINDSET THEN
                    REPEAT
                      IF SalesLine.Type <> SalesLine.Type::" " THEN BEGIN
                        SalesShptLine.GET(SalesLine."Shipment No.",SalesLine."Shipment Line No.");
                        TempSalesLine.GET(
                          TempSalesLine."Document Type"::Order,
                          SalesShptLine."Order No.",SalesShptLine."Order Line No.");
                        IF SalesLine.Type = SalesLine.Type::"Charge (Item)" THEN
                          UpdateSalesOrderChargeAssgnt(SalesLine,TempSalesLine);
                        TempSalesLine."Quantity Invoiced" :=
                          TempSalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice";
                        TempSalesLine."Qty. Invoiced (Base)" :=
                          TempSalesLine."Qty. Invoiced (Base)" + SalesLine."Qty. to Invoice (Base)";
                        IF ABS(TempSalesLine."Quantity Invoiced") > ABS(TempSalesLine."Quantity Shipped") THEN
                          ERROR(
                            Text014,
                            TempSalesLine."Document No.");
                        TempSalesLine.InitQtyToInvoice;
                        IF TempSalesLine."Prepayment %" <> 0 THEN BEGIN
                          TempSalesLine."Prepmt Amt Deducted" := TempSalesLine."Prepmt Amt Deducted" + SalesLine."Prepmt Amt to Deduct";
                          TempSalesLine."Prepmt VAT Diff. Deducted" :=
                            TempSalesLine."Prepmt VAT Diff. Deducted" + SalesLine."Prepmt VAT Diff. to Deduct";
                          DecrementPrepmtAmtInvLCY(
                            SalesLine,TempSalesLine."Prepmt. Amount Inv. (LCY)",TempSalesLine."Prepmt. VAT Amount Inv. (LCY)");
                          TempSalesLine."Prepmt Amt to Deduct" :=
                            TempSalesLine."Prepmt. Amt. Inv." - TempSalesLine."Prepmt Amt Deducted";
                          TempSalesLine."Prepmt VAT Diff. to Deduct" := 0;
                        END;
                        TempSalesLine.InitOutstanding;
                        IF (TempSalesLine."Purch. Order Line No." <> 0) AND
                           (TempSalesLine.Quantity = TempSalesLine."Quantity Invoiced")
                        THEN
                          UpdateAssocLines(TempSalesLine);
                        TempSalesLine.MODIFY;
                      END;
                    UNTIL SalesLine.NEXT = 0;
                  InsertTrackingSpecification;
        
                  SalesLine.SETRANGE("Shipment No.");
                END;
              "Document Type"::"Credit Memo":
                BEGIN
                  SalesLine.SETFILTER("Return Receipt No.",'<>%1','');
                  IF SalesLine.FINDSET THEN
                    REPEAT
                      IF SalesLine.Type <> SalesLine.Type::" " THEN BEGIN
                        ReturnRcptLine.GET(SalesLine."Return Receipt No.",SalesLine."Return Receipt Line No.");
                        TempSalesLine.GET(
                          TempSalesLine."Document Type"::"Return Order",
                          ReturnRcptLine."Return Order No.",ReturnRcptLine."Return Order Line No.");
                        IF SalesLine.Type = SalesLine.Type::"Charge (Item)" THEN
                          UpdateSalesOrderChargeAssgnt(SalesLine,TempSalesLine);
                        TempSalesLine."Quantity Invoiced" :=
                          TempSalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice";
                        TempSalesLine."Qty. Invoiced (Base)" :=
                          TempSalesLine."Qty. Invoiced (Base)" + SalesLine."Qty. to Invoice (Base)";
                        IF ABS(TempSalesLine."Quantity Invoiced") > ABS(TempSalesLine."Return Qty. Received") THEN
                          ERROR(
                            Text036,
                            TempSalesLine."Document No.");
                        TempSalesLine.InitQtyToInvoice;
                        TempSalesLine.InitOutstanding;
                        TempSalesLine.MODIFY;
                      END;
                    UNTIL SalesLine.NEXT = 0;
                  InsertTrackingSpecification;
        
                  SalesLine.SETRANGE("Return Receipt No.");
                END;
              ELSE BEGIN
                UpdateAssocOrder;
                IF DropShipOrder THEN
                  InsertTrackingSpecification;
                IF SalesLine.FINDSET THEN
                  REPEAT
                    IF SalesLine."Purch. Order Line No." <> 0 THEN
                      UpdateAssocLines(SalesLine);
                    IF SalesLine."Prepayment %" <> 0 THEN
                      DecrementPrepmtAmtInvLCY(
                        SalesLine,SalesLine."Prepmt. Amount Inv. (LCY)",SalesLine."Prepmt. VAT Amount Inv. (LCY)");
                  UNTIL SalesLine.NEXT = 0;
              END;
            END;
        
            SalesLine.SETFILTER("Qty. to Assemble to Order",'<>0');
            IF SalesLine.FINDSET THEN
              REPEAT
                FinalizePostATO(SalesLine);
              UNTIL SalesLine.NEXT = 0;
            SalesLine.SETRANGE("Qty. to Assemble to Order");
        
            SalesLine.SETFILTER("Blanket Order Line No.",'<>0');
            IF SalesLine.FINDSET THEN
              REPEAT
                UpdateBlanketOrderLine(SalesLine,Ship,Receive,Invoice);
              UNTIL SalesLine.NEXT = 0;
            SalesLine.SETRANGE("Blanket Order Line No.");
        
            IF WhseReceive THEN BEGIN
              WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
              TempWhseRcptHeader.DELETE;
            END;
            IF WhseShip THEN BEGIN
              WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
              TempWhseShptHeader.DELETE;
            END;
        
            ApprovalMgt.DeleteApprovalEntry(DATABASE::"Sales Header","Document Type","No.");
        
            IF HASLINKS THEN
              DELETELINKS;
            DELETE;
            ReserveSalesLine.DeleteInvoiceSpecFromHeader(SalesHeader);
            DeleteATOLinks(SalesHeader);
            IF SalesLine.FINDFIRST THEN
              REPEAT
                IF SalesLine.HASLINKS THEN
                  SalesLine.DELETELINKS;
              UNTIL SalesLine.NEXT = 0;
            SalesLine.DELETEALL;
            DeleteItemChargeAssgnt;
            SalesCommentLine.SETRANGE("Document Type","Document Type");
            SalesCommentLine.SETRANGE("No.","No.");
            IF NOT SalesCommentLine.ISEMPTY THEN
              SalesCommentLine.DELETEALL;
            WhseRqst.SETCURRENTKEY("Source Type","Source Subtype","Source No.");
            WhseRqst.SETRANGE("Source Type",DATABASE::"Sales Line");
            WhseRqst.SETRANGE("Source Subtype","Document Type");
            WhseRqst.SETRANGE("Source No.","No.");
            IF NOT WhseRqst.ISEMPTY THEN
              WhseRqst.DELETEALL;
          END;
        
          InsertValueEntryRelation;
          IF NOT InvtPickPutaway THEN
            COMMIT;
          CLEAR(WhsePostRcpt);
          CLEAR(WhsePostShpt);
          CLEAR(GenJnlPostLine);
          CLEAR(ResJnlPostLine);
          CLEAR(JobPostLine);
          CLEAR(ItemJnlPostLine);
          CLEAR(WhseJnlPostLine);
          CLEAR(InvtAdjmt);
          Window.CLOSE;
          IF Invoice AND ("Bill-to IC Partner Code" <> '') THEN
            IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
              ICInOutBoxMgt.CreateOutboxSalesInvTrans(SalesInvHeader)
            ELSE
              ICInOutBoxMgt.CreateOutboxSalesCrMemoTrans(SalesCrMemoHeader);
        END;
        
        IF Invoice AND (TaxOption = TaxOption::SalesTax) AND UseExternalTaxEngine THEN BEGIN
          IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
            SalesTaxCalculate.FinalizeExternalTaxCalcForDoc(DATABASE::"Sales Invoice Header",SalesInvHeader."No.")
          ELSE
            SalesTaxCalculate.FinalizeExternalTaxCalcForDoc(DATABASE::"Sales Cr.Memo Header",SalesCrMemoHeader."No.");
        END;
        
        TransactionLogEntryNo := CaptureOrRefundCreditCardPmnt(CustLedgEntry);
        
        Rec := SalesHeader;
        SynchBOMSerialNo(ServiceItemTmp2,ServiceItemCmpTmp2);
        IF NOT InvtPickPutaway THEN BEGIN
          COMMIT;
          UpdateAnalysisView.UpdateAll(0,TRUE);
          UpdateItemAnalysisView.UpdateAll(0,TRUE);
        END;
        
        // Balancing account - online payment
        IF ("Bal. Account No." <> '') AND IsOnlinePayment(SalesHeader) AND Invoice THEN
          PostBalanceEntry(
            TransactionLogEntryNo,SalesHeader,TotalSalesLine,TotalSalesLineLCY,
            GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
        */
        //fes mig

    end;

    var
        Text001: Label 'There is nothing to post.';
        Text002: Label 'Posting lines              #2######\';
        Text003: Label 'Posting sales and tax      #3######\';
        Text004: Label 'Posting to customers       #4######\';
        Text005: Label 'Posting to bal. account    #5######';
        Text006: Label 'Posting lines              #2######';
        Text007: Label '%1 %2 -> Invoice %3';
        Text008: Label '%1 %2 -> Credit Memo %3';
        Text009: Label 'You cannot ship sales order line %1. ';
        Text010: Label 'The line is marked as a drop shipment and is not yet associated with a purchase order.';
        Text011: Label 'must have the same sign as the shipment';
        Text013: Label 'The shipment lines have been deleted.';
        Text014: Label 'You cannot invoice more than you have shipped for order %1.';
        Text016: Label 'Tax Amount';
        Text017: Label '%1% Tax';
        Text018: Label 'in the associated blanket order must not be greater than %1';
        Text019: Label 'in the associated blanket order must not be reduced.';
        Text020: Label 'Please enter "Yes" in %1 and/or %2 and/or %3.';
        Text021: Label 'Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6.';
        Text023: Label 'This order must be a complete Shipment.';
        Text024: Label 'must have the same sign as the return receipt';
        Text025: Label 'Line %1 of the return receipt %2, which you are attempting to invoice, has already been invoiced.';
        Text026: Label 'Line %1 of the shipment %2, which you are attempting to invoice, has already been invoiced.';
        Text027: Label 'The quantity you are attempting to invoice is greater than the quantity in shipment %1.';
        Text028: Label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text029: Label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text030: Label 'The dimensions used in %1 %2 are invalid. %3';
        Text031: Label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        Text032: Label 'You cannot assign more than %1 units in %2 = %3, %4 = %5,%6 = %7.';
        Text033: Label 'You must assign all item charges, if you invoice everything.';
        Item: Record Item;
        CurrExchRate: Record "Currency Exchange Rate";
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        InvtSetup: Record "Inventory Setup";
        GLEntry: Record "G/L Entry";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line";
        SalesLineACY: Record "Sales Line";
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        TempPrepaymentSalesLine: Record "Sales Line" temporary;
        CombinedSalesLineTemp: Record "Sales Line" temporary;
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ReturnRcptHeader: Record "Return Receipt Header";
        ReturnRcptLine: Record "Return Receipt Line";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary;
        GenJnlLine: Record "Gen. Journal Line";
        ItemJnlLine: Record "Item Journal Line";
        ResJnlLine: Record "Res. Journal Line";
        CustPostingGr: Record "Customer Posting Group";
        SourceCodeSetup: Record "Source Code Setup";
        SourceCode: Record "Source Code";
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentLine2: Record "Sales Comment Line";
        GenPostingSetup: Record "General Posting Setup";
        Currency: Record Currency;
        InvPostingBuffer: array[2] of Record "Invoice Posting Buffer" temporary;
        DropShipPostBuffer: Record "Drop Shpt. Post. Buffer" temporary;
        GLAcc: Record "G/L Account";
        ApprovalEntry: Record "Approval Entry";
        TempApprovalEntry: Record "Approval Entry" temporary;
        FA: Record "Fixed Asset";
        DeprBook: Record "Depreciation Book";
        WhseRqst: Record "Warehouse Request";
        WhseRcptHeader: Record "Warehouse Receipt Header";
        TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary;
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhseShptHeader: Record "Warehouse Shipment Header";
        TempWhseShptHeader: Record "Warehouse Shipment Header" temporary;
        WhseShptLine: Record "Warehouse Shipment Line";
        PostedWhseRcptHeader: Record "Posted Whse. Receipt Header";
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Location: Record Location;
        TempHandlingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecificationInv: Record "Tracking Specification" temporary;
        TempWhseSplitSpecification: Record "Tracking Specification" temporary;
        TempValueEntryRelation: Record "Value Entry Relation" temporary;
        //TaxAmountDifference: Record "Sales Tax Amount Difference";
        JobTaskSalesLine: Record "Sales Line";
        TempICGenJnlLine: Record "Gen. Journal Line" temporary;
        TempPrepmtDeductLCYSalesLine: Record "Sales Line" temporary;
        ServiceItemTmp1: Record "Service Item" temporary;
        ServiceItemTmp2: Record "Service Item" temporary;
        ServiceItemCmpTmp1: Record "Service Item Component" temporary;
        ServiceItemCmpTmp2: Record "Service Item Component" temporary;
        TempSKU: Record "Stockkeeping Unit" temporary;
        /*  NoSeriesMgt: Codeunit NoSeriesManagement; */
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        InvtAdjmt: Codeunit "Inventory Adjustment";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        /*  SalesCalcDisc: Codeunit "Sales-Calc. Discount"; */
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        WhseSalesRelease: Codeunit "Whse.-Sales Release";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        WMSMgmt: Codeunit "WMS Management";
        WhseJnlPostLine: Codeunit "Whse. Jnl.-Register Line";
        WhsePostRcpt: Codeunit "Whse.-Post Receipt";
        WhsePostShpt: Codeunit "Whse.-Post Shipment";
        PurchPost: Codeunit "Purch.-Post";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        JobPostLine: Codeunit "Job Post-Line";
        ServItemMgt: Codeunit ServItemManagement;
        AsmPost: Codeunit "Assembly-Post";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        Window: Dialog;
        PostingDate: Date;
        UseDate: Date;
        GenJnlLineDocNo: Code[20];
        GenJnlLineExtDocNo: Code[35];
        SrcCode: Code[10];
        GenJnlLineDocType: Integer;
        ItemLedgShptEntryNo: Integer;
        LineCount: Integer;
        FALineNo: Integer;
        RoundingLineNo: Integer;
        WhseReference: Integer;
        RemQtyToBeInvoiced: Decimal;
        RemQtyToBeInvoicedBase: Decimal;
        QtyToBeInvoiced: Decimal;
        QtyToBeInvoicedBase: Decimal;
        RemAmt: Decimal;
        RemDiscAmt: Decimal;
        EverythingInvoiced: Boolean;
        LastLineRetrieved: Boolean;
        RoundingLineInserted: Boolean;
        ModifyHeader: Boolean;
        DropShipOrder: Boolean;
        PostingDateExists: Boolean;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        TempInvoice: Boolean;
        TempShpt: Boolean;
        TempReturn: Boolean;
        Text034: Label 'You cannot assign item charges to the %1 %2 = %3,%4 = %5, %6 = %7, because it has been invoiced.';
        Text036: Label 'You cannot invoice more than you have received for return order %1.';
        Text037: Label 'The return receipt lines have been deleted.';
        Text038: Label 'The quantity you are attempting to invoice is greater than the quantity in return receipt %1.';
        ItemChargeAssgntOnly: Boolean;
        ItemJnlRollRndg: Boolean;
        Text040: Label 'Related item ledger entries cannot be found.';
        Text043: Label 'Item Tracking is signed wrongly.';
        Text044: Label 'Item Tracking does not match.';
        WhseShip: Boolean;
        WhseReceive: Boolean;
        InvtPickPutaway: Boolean;
        Text045: Label 'is not within your range of allowed posting dates.';
        Text046: Label 'The %1 does not match the quantity defined in item tracking.';
        Text047: Label 'cannot be more than %1.';
        Text048: Label 'must be at least %1.';
        Text27000: Label 'must be more completely preinvoiced before you can invoice', Comment = 'starts with "Prepmt. Line Amount"; ends with "Sales Line"';
        JobContractLine: Boolean;
        GLSetupRead: Boolean;
        ICGenJnlLineNo: Integer;
        ItemTrkgAlreadyOverruled: Boolean;
        Text050: Label 'The total %1 cannot be more than %2.';
        Text051: Label 'The total %1 must be at least %2.';
        TotalChargeAmt: Decimal;
        TotalChargeAmtLCY: Decimal;
        TotalChargeAmt2: Decimal;
        TotalChargeAmtLCY2: Decimal;
        Text052: Label 'You must assign item charge %1 if you want to invoice it.';
        Text053: Label 'You can not invoice item charge %1 because there is no item ledger entry to assign it to.';
        SalesLinesProcessed: Boolean;
        Text055: Label '#1#################################\\Checking Assembly #2###########';
        Text056: Label '#1#################################\\Posting Assembly #2###########';
        Text057: Label '#1#################################\\Finalizing Assembly #2###########';
        Text059: Label '%1 %2 %3 %4', Comment = '%1 = SalesLine."Document Type". %2 = SalesLine."Document No.". %3 = SalesLine.FIELDCAPTION("Line No."). %4 = SalesLine."Line No.". This is used in a progress window.';
        Text060: Label '%1 %2', Comment = '%1 = "Document Type". %2 = AsmHeader."No.". Used in a progress window.';
        TaxArea: Record "Tax Area";
        // TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TempSalesLineForSalesTax: Record "Sales Line" temporary;
        TempSalesLineForSpread: Record "Sales Line" temporary;
        SalesTaxCountry: Option US,CA,,,,,,,,,,,,NoTax;
        TaxOption: Option ,VAT,SalesTax;
        Text27001: Label 'Every %1 must have %2 = %3 if any %1 has %2 = %3.';
        Text27002: Label 'If the %1 has a blank %2, then every %3 must also have blank %4.';
        Text27003: Label 'If the %1 has a %2 whose %3 is %4, then any %5 with a %6 must have one whose %3 is %4. ';
        UseExternalTaxEngine: Boolean;
        Text061Err: Label 'The order line that the item charge was originally assigned to has been fully posted. You must reassign the item charge to the posted receipt or shipment.';
        Text062Qst: Label 'One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?', Comment = 'One or more reservation entries exist for the item with No. = 1000, Location Code = SILVER, Variant Code = NEW which may be disrupted if you post this negative adjustment. Do you want to continue?';



    procedure SetPostingDate(NewReplacePostingDate: Boolean; NewReplaceDocumentDate: Boolean; NewPostingDate: Date)
    begin
        PostingDateExists := true;
        ReplacePostingDate := NewReplacePostingDate;
        ReplaceDocumentDate := NewReplaceDocumentDate;
        PostingDate := NewPostingDate;
    end;

    local procedure PostItemJnlLine(SalesLine: Record "Sales Line"; QtyToBeShipped: Decimal; QtyToBeShippedBase: Decimal; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; ItemLedgShptEntryNo: Integer; ItemChargeNo: Code[20]; TrackingSpecification: Record "Tracking Specification"; IsATO: Boolean): Integer
    var
        ItemChargeSalesLine: Record "Sales Line";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;
        OriginalItemJnlLine: Record "Item Journal Line";
        TempWhseTrackingSpecification: Record "Tracking Specification" temporary;
        PostWhseJnlLine: Boolean;
        CheckApplFromItemEntry: Boolean;
    begin
        if not ItemJnlRollRndg then begin
            RemAmt := 0;
            RemDiscAmt := 0;
        end;

        ItemJnlLine.Init;
        ItemJnlLine."Posting Date" := SalesHeader."Posting Date";
        ItemJnlLine."Document Date" := SalesHeader."Document Date";
        ItemJnlLine."Source Posting Group" := SalesHeader."Customer Posting Group";
        ItemJnlLine."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
        ItemJnlLine."Country/Region Code" := GetCountryCode(SalesLine, SalesHeader);
        ItemJnlLine."Reason Code" := SalesHeader."Reason Code";
        ItemJnlLine."Item No." := SalesLine."No.";
        ItemJnlLine.Description := SalesLine.Description;
        ItemJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";
        ItemJnlLine."Location Code" := SalesLine."Location Code";
        ItemJnlLine."Bin Code" := SalesLine."Bin Code";
        ItemJnlLine."Variant Code" := SalesLine."Variant Code";
        ItemJnlLine."Inventory Posting Group" := SalesLine."Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
        if IsATO then
            ItemJnlLine."Applies-to Entry" := 0
        else
            ItemJnlLine."Applies-to Entry" := SalesLine."Appl.-to Item Entry";
        ItemJnlLine."Transaction Type" := SalesLine."Transaction Type";
        ItemJnlLine."Transport Method" := SalesLine."Transport Method";
        ItemJnlLine."Entry/Exit Point" := SalesLine."Exit Point";
        ItemJnlLine.Area := SalesLine.Area;
        ItemJnlLine."Transaction Specification" := SalesLine."Transaction Specification";
        ItemJnlLine."Drop Shipment" := SalesLine."Drop Shipment";
        ItemJnlLine."Assemble to Order" := IsATO;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Sale;
        ItemJnlLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
        ItemJnlLine."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
        ItemJnlLine."Derived from Blanket Order" := SalesLine."Blanket Order No." <> '';
        ItemJnlLine."Item Reference No." := SalesLine."Item Reference No.";
        ItemJnlLine."Originally Ordered No." := SalesLine."Originally Ordered No.";
        ItemJnlLine."Originally Ordered Var. Code" := SalesLine."Originally Ordered Var. Code";
        ItemJnlLine."Out-of-Stock Substitution" := SalesLine."Out-of-Stock Substitution";
        ItemJnlLine."Item Category Code" := SalesLine."Item Category Code";
        ItemJnlLine.Nonstock := SalesLine.Nonstock;
        ItemJnlLine."Purchasing Code" := SalesLine."Purchasing Code";
        ItemJnlLine."Return Reason Code" := SalesLine."Return Reason Code";

        ItemJnlLine."Planned Delivery Date" := SalesLine."Planned Delivery Date";
        ItemJnlLine."Order Date" := SalesHeader."Order Date";

        ItemJnlLine."Serial No." := TrackingSpecification."Serial No.";
        ItemJnlLine."Lot No." := TrackingSpecification."Lot No.";

        if QtyToBeShipped = 0 then begin
            if SalesLine."Document Type" in [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] then
                ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Credit Memo"
            else
                ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Invoice";
            ItemJnlLine."Document No." := GenJnlLineDocNo;
            ItemJnlLine."External Document No." := GenJnlLineExtDocNo;
            ItemJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
            if QtyToBeInvoiced <> 0 then
                ItemJnlLine."Invoice No." := GenJnlLineDocNo;
        end else begin
            if SalesLine."Document Type" in [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] then begin
                ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Return Receipt";
                ItemJnlLine."Document No." := ReturnRcptHeader."No.";
                ItemJnlLine."External Document No." := ReturnRcptHeader."External Document No.";
                ItemJnlLine."Posting No. Series" := ReturnRcptHeader."No. Series";
            end else begin
                ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Shipment";
                ItemJnlLine."Document No." := SalesShptHeader."No.";
                ItemJnlLine."External Document No." := SalesShptHeader."External Document No.";
                ItemJnlLine."Posting No. Series" := SalesShptHeader."No. Series";
            end;
            if QtyToBeInvoiced <> 0 then begin
                ItemJnlLine."Invoice No." := GenJnlLineDocNo;
                ItemJnlLine."External Document No." := GenJnlLineExtDocNo;
                if ItemJnlLine."Document No." = '' then begin
                    if SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo" then
                        ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Credit Memo"
                    else
                        ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Invoice";
                    ItemJnlLine."Document No." := GenJnlLineDocNo;
                end;
                ItemJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
            end;
        end;

        ItemJnlLine."Document Line No." := SalesLine."Line No.";
        ItemJnlLine.Quantity := -QtyToBeShipped;
        ItemJnlLine."Quantity (Base)" := -QtyToBeShippedBase;
        ItemJnlLine."Invoiced Quantity" := -QtyToBeInvoiced;
        ItemJnlLine."Invoiced Qty. (Base)" := -QtyToBeInvoicedBase;
        ItemJnlLine."Unit Cost" := SalesLine."Unit Cost (LCY)";
        ItemJnlLine."Source Currency Code" := SalesHeader."Currency Code";
        ItemJnlLine."Unit Cost (ACY)" := SalesLine."Unit Cost";
        ItemJnlLine."Value Entry Type" := ItemJnlLine."Value Entry Type"::"Direct Cost";

        if ItemChargeNo <> '' then begin
            ItemJnlLine."Item Charge No." := ItemChargeNo;
            SalesLine."Qty. to Invoice" := QtyToBeInvoiced;
        end else
            ItemJnlLine."Applies-from Entry" := SalesLine."Appl.-from Item Entry";

        if QtyToBeInvoiced <> 0 then begin
            ItemJnlLine.Amount := -(SalesLine.Amount * (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemAmt);
            if SalesHeader."Prices Including VAT" then
                ItemJnlLine."Discount Amount" :=
                  -((SalesLine."Line Discount Amount" + SalesLine."Inv. Discount Amount") / (1 + SalesLine."VAT %" / 100) *
                    (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemDiscAmt)
            else
                ItemJnlLine."Discount Amount" :=
                  -((SalesLine."Line Discount Amount" + SalesLine."Inv. Discount Amount") * (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemDiscAmt);
            RemAmt := ItemJnlLine.Amount - Round(ItemJnlLine.Amount);
            RemDiscAmt := ItemJnlLine."Discount Amount" - Round(ItemJnlLine."Discount Amount");
            ItemJnlLine.Amount := Round(ItemJnlLine.Amount);
            ItemJnlLine."Discount Amount" := Round(ItemJnlLine."Discount Amount");
        end else begin
            if SalesHeader."Prices Including VAT" then
                ItemJnlLine.Amount :=
                  -((QtyToBeShipped * SalesLine."Unit Price" * (1 - SalesLine."Line Discount %" / 100) / (1 + SalesLine."VAT %" / 100)) - RemAmt)
            else
                ItemJnlLine.Amount :=
                  -((QtyToBeShipped * SalesLine."Unit Price" * (1 - SalesLine."Line Discount %" / 100)) - RemAmt);
            RemAmt := ItemJnlLine.Amount - Round(ItemJnlLine.Amount);
            if SalesHeader."Currency Code" <> '' then
                ItemJnlLine.Amount :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      SalesHeader."Posting Date", SalesHeader."Currency Code",
                      ItemJnlLine.Amount, SalesHeader."Currency Factor"))
            else
                ItemJnlLine.Amount := Round(ItemJnlLine.Amount);
        end;

        ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Customer;
        ItemJnlLine."Source No." := SalesLine."Sell-to Customer No.";
        ItemJnlLine."Invoice-to Source No." := SalesLine."Bill-to Customer No.";
        ItemJnlLine."Source Code" := SrcCode;
        ItemJnlLine."Item Shpt. Entry No." := ItemLedgShptEntryNo;

        if not JobContractLine then begin
            if SalesSetup."Exact Cost Reversing Mandatory" and (SalesLine.Type = SalesLine.Type::Item) then
                if SalesLine."Document Type" in [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] then
                    CheckApplFromItemEntry := SalesLine.Quantity > 0
                else
                    CheckApplFromItemEntry := SalesLine.Quantity < 0;

            if (SalesLine."Location Code" <> '') and (SalesLine.Type = SalesLine.Type::Item) and (ItemJnlLine.Quantity <> 0) then
                if ShouldPostWhseJnlLine(SalesLine) then begin
                    CreateWhseJnlLine(ItemJnlLine, SalesLine, TempWhseJnlLine);
                    PostWhseJnlLine := true;
                end;

            if QtyToBeShippedBase <> 0 then begin
                if SalesLine."Document Type" in [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] then
                    ReserveSalesLine.TransferSalesLineToItemJnlLine(SalesLine, ItemJnlLine, QtyToBeShippedBase, CheckApplFromItemEntry, false)
                else
                    TransferReservToItemJnlLine(
                      SalesLine, ItemJnlLine, -QtyToBeShippedBase, TempTrackingSpecification, CheckApplFromItemEntry);

                if CheckApplFromItemEntry then
                    SalesLine.TestField(SalesLine."Appl.-from Item Entry");
            end;

            OriginalItemJnlLine := ItemJnlLine;
            ItemJnlPostLine.RunWithCheck(ItemJnlLine);
            if ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification) then
                if TempHandlingSpecification.FindSet then
                    repeat
                        TempTrackingSpecification := TempHandlingSpecification;
                        TempTrackingSpecification."Source Type" := DATABASE::"Sales Line";
                        //TempTrackingSpecification."Source Subtype" := "Document Type";
                        TempTrackingSpecification."Source ID" := SalesLine."Document No.";
                        TempTrackingSpecification."Source Batch Name" := '';
                        TempTrackingSpecification."Source Prod. Order Line" := 0;
                        TempTrackingSpecification."Source Ref. No." := SalesLine."Line No.";
                        if TempTrackingSpecification.Insert then;
                        if QtyToBeInvoiced <> 0 then begin
                            TempTrackingSpecificationInv := TempTrackingSpecification;
                            if TempTrackingSpecificationInv.Insert then;
                        end;
                        if PostWhseJnlLine then begin
                            TempWhseTrackingSpecification := TempTrackingSpecification;
                            if TempWhseTrackingSpecification.Insert then;
                        end;
                    until TempHandlingSpecification.Next = 0;
            if PostWhseJnlLine then begin
                ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine, TempWhseJnlLine2, TempWhseTrackingSpecification, false);
                if TempWhseJnlLine2.FindSet then
                    repeat
                        WhseJnlPostLine.Run(TempWhseJnlLine2);
                    until TempWhseJnlLine2.Next = 0;
                TempWhseTrackingSpecification.DeleteAll;
            end;

            if (SalesLine.Type = SalesLine.Type::Item) and SalesHeader.Invoice then begin
                ClearItemChargeAssgntFilter;
                TempItemChargeAssgntSales.SetCurrentKey(
                  "Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
                TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type", SalesLine."Document Type");
                TempItemChargeAssgntSales.SetRange("Applies-to Doc. No.", SalesLine."Document No.");
                TempItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.", SalesLine."Line No.");
                if TempItemChargeAssgntSales.FindSet then
                    repeat
                        SalesLine.TestField(SalesLine."Allow Item Charge Assignment");
                        GetItemChargeLine(ItemChargeSalesLine);
                        ItemChargeSalesLine.CalcFields("Qty. Assigned");
                        if (ItemChargeSalesLine."Qty. to Invoice" <> 0) or
                            (Abs(ItemChargeSalesLine."Qty. Assigned") < Abs(ItemChargeSalesLine."Quantity Invoiced"))
                        then begin
                            OriginalItemJnlLine."Item Shpt. Entry No." := ItemJnlLine."Item Shpt. Entry No.";
                            PostItemChargePerOrder(OriginalItemJnlLine, ItemChargeSalesLine);
                            TempItemChargeAssgntSales.Mark(true);
                        end;
                    until TempItemChargeAssgntSales.Next = 0;
            end;
        end;

        exit(ItemJnlLine."Item Shpt. Entry No.");
    end;

    local procedure ShouldPostWhseJnlLine(SalesLine: Record "Sales Line"): Boolean
    begin
        // Removed 'with' statement for cloud compatibility
        GetLocation(SalesLine."Location Code");
        if ((SalesLine."Document Type" in [SalesLine."Document Type"::Invoice, SalesLine."Document Type"::"Credit Memo"]) and
            Location."Directed Put-away and Pick") or
           (Location."Bin Mandatory" and not (WhseShip or WhseReceive or InvtPickPutaway or SalesLine."Drop Shipment"))
        then
            exit(true);
    end;


    local procedure PostItemChargePerOrder(ItemJnlLine2: Record "Item Journal Line"; ItemChargeSalesLine: Record "Sales Line")
    var
        NonDistrItemJnlLine: Record "Item Journal Line";
        QtyToInvoice: Decimal;
        Factor: Decimal;
        OriginalAmt: Decimal;
        OriginalDiscountAmt: Decimal;
        OriginalQty: Decimal;
        SignFactor: Integer;
    begin
        SalesLine.TestField("Job No.", '');
        SalesLine.TestField("Allow Item Charge Assignment", true);
        ItemJnlLine2."Document No." := GenJnlLineDocNo;
        ItemJnlLine2."External Document No." := GenJnlLineExtDocNo;
        ItemJnlLine2."Item Charge No." := TempItemChargeAssgntSales."Item Charge No.";
        ItemJnlLine2.Description := ItemChargeSalesLine.Description;
        ItemJnlLine2."Unit of Measure Code" := '';
        ItemJnlLine2."Qty. per Unit of Measure" := 1;
        ItemJnlLine2."Applies-from Entry" := 0;
        if TempItemChargeAssgntSales."Document Type" in [TempItemChargeAssgntSales."Document Type"::"Return Order", TempItemChargeAssgntSales."Document Type"::"Credit Memo"] then
            QtyToInvoice :=
              CalcQtyToInvoice(SalesLine."Return Qty. to Receive (Base)", SalesLine."Qty. to Invoice (Base)")
        else
            QtyToInvoice :=
              CalcQtyToInvoice(SalesLine."Qty. to Ship (Base)", SalesLine."Qty. to Invoice (Base)");
        if ItemJnlLine2."Invoiced Quantity" = 0 then begin
            ItemJnlLine2."Invoiced Quantity" := ItemJnlLine2.Quantity;
            ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
        end;
        ItemJnlLine2."Document Line No." := ItemChargeSalesLine."Line No.";

        ItemJnlLine2.Amount := TempItemChargeAssgntSales."Amount to Assign" * ItemJnlLine2."Invoiced Qty. (Base)" / QtyToInvoice;
        if TempItemChargeAssgntSales."Document Type" in [TempItemChargeAssgntSales."Document Type"::"Return Order", TempItemChargeAssgntSales."Document Type"::"Credit Memo"] then
            ItemJnlLine2.Amount := -ItemJnlLine2.Amount;
        ItemJnlLine2."Unit Cost (ACY)" :=
          Round(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
            Currency."Unit-Amount Rounding Precision");

        TotalChargeAmt2 := TotalChargeAmt2 + ItemJnlLine2.Amount;
        if SalesHeader."Currency Code" <> '' then begin
            ItemJnlLine2.Amount :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate, SalesHeader."Currency Code", TotalChargeAmt2 + TotalSalesLine.Amount, SalesHeader."Currency Factor") -
              TotalChargeAmtLCY2 - TotalSalesLineLCY.Amount;
        end else
            ItemJnlLine2.Amount := TotalChargeAmt2 - TotalChargeAmtLCY2;

        ItemJnlLine2.Amount := Round(ItemJnlLine2.Amount);
        TotalChargeAmtLCY2 := TotalChargeAmtLCY2 + ItemJnlLine2.Amount;
        ItemJnlLine2."Unit Cost" := Round(
            ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)", GLSetup."Unit-Amount Rounding Precision");
        ItemJnlLine2."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";

        if SalesHeader."Currency Code" <> '' then
            ItemJnlLine2."Discount Amount" := Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, SalesHeader."Currency Code",
                  ItemChargeSalesLine."Inv. Discount Amount" * ItemJnlLine2."Invoiced Qty. (Base)" /
                  ItemChargeSalesLine."Quantity (Base)" * TempItemChargeAssgntSales."Qty. to Assign" / QtyToInvoice,
                  SalesHeader."Currency Factor"), GLSetup."Amount Rounding Precision")
        else
            ItemJnlLine2."Discount Amount" := Round(
                ItemChargeSalesLine."Inv. Discount Amount" * ItemJnlLine2."Invoiced Qty. (Base)" /
                ItemChargeSalesLine."Quantity (Base)" * TempItemChargeAssgntSales."Qty. to Assign" / QtyToInvoice,
                GLSetup."Amount Rounding Precision");

        if TempItemChargeAssgntSales."Document Type" in [TempItemChargeAssgntSales."Document Type"::"Return Order", TempItemChargeAssgntSales."Document Type"::"Credit Memo"] then
            ItemJnlLine2."Discount Amount" := -ItemJnlLine2."Discount Amount";
        ItemJnlLine2."Shortcut Dimension 1 Code" := ItemChargeSalesLine."Shortcut Dimension 1 Code";
        ItemJnlLine2."Shortcut Dimension 2 Code" := ItemChargeSalesLine."Shortcut Dimension 2 Code";
        ItemJnlLine2."Dimension Set ID" := ItemChargeSalesLine."Dimension Set ID";
        ItemJnlLine2."Gen. Prod. Posting Group" := ItemChargeSalesLine."Gen. Prod. Posting Group";

        TempTrackingSpecificationInv.Reset;
        TempTrackingSpecificationInv.SetRange("Source Type", DATABASE::"Sales Line");
        TempTrackingSpecificationInv.SetRange("Source ID", TempItemChargeAssgntSales."Applies-to Doc. No.");
        TempTrackingSpecificationInv.SetRange("Source Ref. No.", TempItemChargeAssgntSales."Applies-to Doc. Line No.");
        if TempTrackingSpecificationInv.IsEmpty then
            ItemJnlPostLine.RunWithCheck(ItemJnlLine2)
        else begin
            TempTrackingSpecificationInv.FindSet;
            NonDistrItemJnlLine := ItemJnlLine2;
            OriginalAmt := NonDistrItemJnlLine.Amount;
            OriginalDiscountAmt := NonDistrItemJnlLine."Discount Amount";
            OriginalQty := NonDistrItemJnlLine."Quantity (Base)";
            if (TempTrackingSpecificationInv."Quantity (Base)" / OriginalQty) > 0 then
                SignFactor := 1
            else
                SignFactor := -1;
            repeat
                Factor := TempTrackingSpecificationInv."Quantity (Base)" / OriginalQty * SignFactor;
                if Abs(TempTrackingSpecificationInv."Quantity (Base)") < Abs(NonDistrItemJnlLine."Quantity (Base)") then begin
                    ItemJnlLine2."Quantity (Base)" := -TempTrackingSpecificationInv."Quantity (Base)";
                    ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
                    ItemJnlLine2.Amount :=
                      Round(OriginalAmt * Factor, GLSetup."Amount Rounding Precision");
                    ItemJnlLine2."Unit Cost" :=
                      Round(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                        GLSetup."Unit-Amount Rounding Precision") * SignFactor;
                    ItemJnlLine2."Discount Amount" :=
                      Round(OriginalDiscountAmt * Factor, GLSetup."Amount Rounding Precision");
                    ItemJnlLine2."Item Shpt. Entry No." := TempTrackingSpecificationInv."Item Ledger Entry No.";
                    ItemJnlLine2."Applies-to Entry" := TempTrackingSpecificationInv."Item Ledger Entry No.";
                    ItemJnlLine2."Lot No." := TempTrackingSpecificationInv."Lot No.";
                    ItemJnlLine2."Serial No." := TempTrackingSpecificationInv."Serial No.";
                    ItemJnlPostLine.RunWithCheck(ItemJnlLine2);
                    ItemJnlLine2."Location Code" := NonDistrItemJnlLine."Location Code";
                    NonDistrItemJnlLine."Quantity (Base)" -= ItemJnlLine2."Quantity (Base)";
                    NonDistrItemJnlLine.Amount -= ItemJnlLine2.Amount;
                    NonDistrItemJnlLine."Discount Amount" -= ItemJnlLine2."Discount Amount";
                end else begin // the last time
                    NonDistrItemJnlLine."Quantity (Base)" := -TempTrackingSpecificationInv."Quantity (Base)";
                    NonDistrItemJnlLine."Invoiced Qty. (Base)" := -TempTrackingSpecificationInv."Quantity (Base)";
                    NonDistrItemJnlLine."Unit Cost" :=
                      Round(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                        GLSetup."Unit-Amount Rounding Precision");
                    NonDistrItemJnlLine."Item Shpt. Entry No." := TempTrackingSpecificationInv."Item Ledger Entry No.";
                    NonDistrItemJnlLine."Applies-to Entry" := TempTrackingSpecificationInv."Item Ledger Entry No.";
                    NonDistrItemJnlLine."Lot No." := TempTrackingSpecificationInv."Lot No.";
                    NonDistrItemJnlLine."Serial No." := TempTrackingSpecificationInv."Serial No.";
                    ItemJnlPostLine.RunWithCheck(NonDistrItemJnlLine);
                    NonDistrItemJnlLine."Location Code" := ItemJnlLine2."Location Code";
                end;
            until TempTrackingSpecificationInv.Next = 0;
        end;
    end;

    local procedure PostItemChargePerShpt(var SalesLine: Record "Sales Line")
    var
        SalesShptLine: Record "Sales Shipment Line";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        Factor: Decimal;
        NonDistrQuantity: Decimal;
        NonDistrQtyToAssign: Decimal;
        NonDistrAmountToAssign: Decimal;
        QtyToAssign: Decimal;
        AmountToAssign: Decimal;
        DistributeCharge: Boolean;
    begin
        if not SalesShptLine.Get(
             TempItemChargeAssgntSales."Applies-to Doc. No.", TempItemChargeAssgntSales."Applies-to Doc. Line No.")
        then
            Error(Text013);
        SalesShptLine.TestField("Job No.", '');

        if SalesShptLine."Item Shpt. Entry No." <> 0 then
            DistributeCharge :=
              CostCalcMgt.SplitItemLedgerEntriesExist(
                TempItemLedgEntry, -SalesShptLine."Quantity (Base)", SalesShptLine."Item Shpt. Entry No.")
        else begin
            DistributeCharge := true;
            if not ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
                 DATABASE::"Sales Shipment Line", 0, SalesShptLine."Document No.",
                 '', 0, SalesShptLine."Line No.", -SalesShptLine."Quantity (Base)")
            then
                Error(Text040);
        end;

        if DistributeCharge then begin
            TempItemLedgEntry.FindSet;
            NonDistrQuantity := SalesShptLine."Quantity (Base)";
            NonDistrQtyToAssign := TempItemChargeAssgntSales."Qty. to Assign";
            NonDistrAmountToAssign := TempItemChargeAssgntSales."Amount to Assign";
            repeat
                Factor := Abs(TempItemLedgEntry.Quantity) / NonDistrQuantity;
                QtyToAssign := NonDistrQtyToAssign * Factor;
                AmountToAssign := Round(NonDistrAmountToAssign * Factor, GLSetup."Amount Rounding Precision");
                if Factor < 1 then begin
                    PostItemCharge(SalesLine,
                      TempItemLedgEntry."Entry No.", Abs(TempItemLedgEntry.Quantity),
                      AmountToAssign, QtyToAssign);
                    NonDistrQuantity := NonDistrQuantity - Abs(TempItemLedgEntry.Quantity);
                    NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
                    NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
                end else // the last time
                    PostItemCharge(SalesLine,
                      TempItemLedgEntry."Entry No.", Abs(TempItemLedgEntry.Quantity),
                      NonDistrAmountToAssign, NonDistrQtyToAssign);
            until TempItemLedgEntry.Next = 0;
        end else
            PostItemCharge(SalesLine,
              SalesShptLine."Item Shpt. Entry No.", SalesShptLine."Quantity (Base)",
              TempItemChargeAssgntSales."Amount to Assign",
              TempItemChargeAssgntSales."Qty. to Assign");
    end;

    local procedure PostItemChargePerRetRcpt(var SalesLine: Record "Sales Line")
    var
        ReturnRcptLine: Record "Return Receipt Line";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        Factor: Decimal;
        NonDistrQuantity: Decimal;
        NonDistrQtyToAssign: Decimal;
        NonDistrAmountToAssign: Decimal;
        QtyToAssign: Decimal;
        AmountToAssign: Decimal;
        DistributeCharge: Boolean;
    begin
        if not ReturnRcptLine.Get(
             TempItemChargeAssgntSales."Applies-to Doc. No.", TempItemChargeAssgntSales."Applies-to Doc. Line No.")
        then
            Error(Text013);
        ReturnRcptLine.TestField("Job No.", '');

        if ReturnRcptLine."Item Rcpt. Entry No." <> 0 then
            DistributeCharge :=
              CostCalcMgt.SplitItemLedgerEntriesExist(
                TempItemLedgEntry, ReturnRcptLine."Quantity (Base)", ReturnRcptLine."Item Rcpt. Entry No.")
        else begin
            DistributeCharge := true;
            if not ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
                 DATABASE::"Return Receipt Line", 0, ReturnRcptLine."Document No.",
                 '', 0, ReturnRcptLine."Line No.", ReturnRcptLine."Quantity (Base)")
            then
                Error(Text040);
        end;

        if DistributeCharge then begin
            TempItemLedgEntry.FindSet;
            NonDistrQuantity := ReturnRcptLine."Quantity (Base)";
            NonDistrQtyToAssign := TempItemChargeAssgntSales."Qty. to Assign";
            NonDistrAmountToAssign := TempItemChargeAssgntSales."Amount to Assign";
            repeat
                Factor := Abs(TempItemLedgEntry.Quantity) / NonDistrQuantity;
                QtyToAssign := NonDistrQtyToAssign * Factor;
                AmountToAssign := Round(NonDistrAmountToAssign * Factor, GLSetup."Amount Rounding Precision");
                if Factor < 1 then begin
                    PostItemCharge(SalesLine,
                      TempItemLedgEntry."Entry No.", Abs(TempItemLedgEntry.Quantity),
                      AmountToAssign, QtyToAssign);
                    NonDistrQuantity := NonDistrQuantity - Abs(TempItemLedgEntry.Quantity);
                    NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
                    NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
                end else // the last time
                    PostItemCharge(SalesLine,
                      TempItemLedgEntry."Entry No.", Abs(TempItemLedgEntry.Quantity),
                      NonDistrAmountToAssign, NonDistrQtyToAssign);
            until TempItemLedgEntry.Next = 0;
        end else
            PostItemCharge(SalesLine,
              ReturnRcptLine."Item Rcpt. Entry No.", ReturnRcptLine."Quantity (Base)",
              TempItemChargeAssgntSales."Amount to Assign",
              TempItemChargeAssgntSales."Qty. to Assign")
    end;

    local procedure PostAssocItemJnlLine(QtyToBeShipped: Decimal; QtyToBeShippedBase: Decimal): Integer
    var
        TempHandlingSpecification2: Record "Tracking Specification" temporary;
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        PurchOrderHeader.Get(
          PurchOrderHeader."Document Type"::Order,
          SalesLine."Purchase Order No.");
        PurchOrderLine.Get(
          PurchOrderLine."Document Type"::Order,
          SalesLine."Purchase Order No.", SalesLine."Purch. Order Line No.");

        ItemJnlLine.Init;
        ItemJnlLine."Source Posting Group" := PurchOrderHeader."Vendor Posting Group";
        ItemJnlLine."Salespers./Purch. Code" := PurchOrderHeader."Purchaser Code";
        ItemJnlLine."Country/Region Code" := PurchOrderHeader."VAT Country/Region Code";
        ItemJnlLine."Reason Code" := PurchOrderHeader."Reason Code";
        ItemJnlLine."Posting No. Series" := PurchOrderHeader."Posting No. Series";
        ItemJnlLine."Item No." := PurchOrderLine."No.";
        ItemJnlLine.Description := PurchOrderLine.Description;
        ItemJnlLine."Shortcut Dimension 1 Code" := PurchOrderLine."Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := PurchOrderLine."Shortcut Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := PurchOrderLine."Dimension Set ID";
        ItemJnlLine."Location Code" := PurchOrderLine."Location Code";
        ItemJnlLine."Inventory Posting Group" := PurchOrderLine."Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := PurchOrderLine."Gen. Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := PurchOrderLine."Gen. Prod. Posting Group";
        ItemJnlLine."Applies-to Entry" := PurchOrderLine."Appl.-to Item Entry";
        ItemJnlLine."Transaction Type" := PurchOrderLine."Transaction Type";
        ItemJnlLine."Transport Method" := PurchOrderLine."Transport Method";
        ItemJnlLine."Entry/Exit Point" := PurchOrderLine."Entry Point";
        ItemJnlLine.Area := PurchOrderLine.Area;
        ItemJnlLine."Transaction Specification" := PurchOrderLine."Transaction Specification";
        ItemJnlLine."Drop Shipment" := PurchOrderLine."Drop Shipment";
        ItemJnlLine."Posting Date" := SalesHeader."Posting Date";
        ItemJnlLine."Document Date" := SalesHeader."Document Date";
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Purchase;
        ItemJnlLine."Document No." := PurchOrderHeader."Receiving No.";
        ItemJnlLine."External Document No." := PurchOrderHeader."No.";
        ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Purchase Receipt";
        ItemJnlLine."Document Line No." := PurchOrderLine."Line No.";
        ItemJnlLine.Quantity := QtyToBeShipped;
        ItemJnlLine."Quantity (Base)" := QtyToBeShippedBase;
        ItemJnlLine."Invoiced Quantity" := 0;
        ItemJnlLine."Invoiced Qty. (Base)" := 0;
        ItemJnlLine."Unit Cost" := PurchOrderLine."Unit Cost (LCY)";
        ItemJnlLine."Source Currency Code" := SalesHeader."Currency Code";
        ItemJnlLine."Unit Cost (ACY)" := PurchOrderLine."Unit Cost";
        ItemJnlLine.Amount := PurchOrderLine."Line Amount";
        ItemJnlLine."Discount Amount" := PurchOrderLine."Line Discount Amount";
        ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Vendor;
        ItemJnlLine."Source No." := PurchOrderLine."Buy-from Vendor No.";
        ItemJnlLine."Invoice-to Source No." := PurchOrderLine."Pay-to Vendor No.";
        ItemJnlLine."Source Code" := SrcCode;
        ItemJnlLine."Variant Code" := PurchOrderLine."Variant Code";
        ItemJnlLine."Item Category Code" := PurchOrderLine."Item Category Code";
        ItemJnlLine."Bin Code" := PurchOrderLine."Bin Code";
        ItemJnlLine."Purchasing Code" := PurchOrderLine."Purchasing Code";
        if PurchOrderLine."Prod. Order No." <> '' then begin
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Production;
            ItemJnlLine."Order No." := PurchOrderLine."Prod. Order No.";
            ItemJnlLine."Order Line No." := PurchOrderLine."Prod. Order Line No.";
        end;
        ItemJnlLine."Unit of Measure Code" := PurchOrderLine."Unit of Measure Code";
        ItemJnlLine."Qty. per Unit of Measure" := PurchOrderLine."Qty. per Unit of Measure";
        ItemJnlLine."Applies-to Entry" := 0;

        if PurchOrderLine."Job No." = '' then begin
            TransferReservFromPurchLine(PurchOrderLine, ItemJnlLine, QtyToBeShippedBase);
            ItemJnlPostLine.RunWithCheck(ItemJnlLine);

            // Handle Item Tracking
            if ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) then begin
                if TempHandlingSpecification2.FindSet then
                    repeat
                        TempTrackingSpecification := TempHandlingSpecification2;
                        TempTrackingSpecification."Source Type" := DATABASE::"Purchase Line";
                        TempTrackingSpecification."Source Subtype" := PurchOrderLine."Document Type".AsInteger();
                        TempTrackingSpecification."Source ID" := PurchOrderLine."Document No.";
                        TempTrackingSpecification."Source Batch Name" := '';
                        TempTrackingSpecification."Source Prod. Order Line" := 0;
                        TempTrackingSpecification."Source Ref. No." := PurchOrderLine."Line No.";
                        if TempTrackingSpecification.Insert then;
                        ItemEntryRelation.Init;
                        ItemEntryRelation."Item Entry No." := TempHandlingSpecification2."Entry No.";
                        ItemEntryRelation."Serial No." := TempHandlingSpecification2."Serial No.";
                        ItemEntryRelation."Lot No." := TempHandlingSpecification2."Lot No.";
                        ItemEntryRelation."Source Type" := DATABASE::"Purch. Rcpt. Line";
                        ItemEntryRelation."Source ID" := PurchOrderHeader."Receiving No.";
                        ItemEntryRelation."Source Ref. No." := PurchOrderLine."Line No.";
                        ItemEntryRelation."Order No." := PurchOrderLine."Document No.";
                        ItemEntryRelation."Order Line No." := PurchOrderLine."Line No.";
                        ItemEntryRelation.Insert;
                    until TempHandlingSpecification2.Next = 0;
                exit(0);
            end;
        end;

        exit(ItemJnlLine."Item Shpt. Entry No.");
    end;

    local procedure UpdateAssocOrder()
    var
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
        DropShipPostBuffer.Reset;
        if DropShipPostBuffer.IsEmpty then
            exit;
        Clear(PurchOrderHeader);
        DropShipPostBuffer.FindSet;
        repeat
            if PurchOrderHeader."No." <> DropShipPostBuffer."Order No." then begin
                PurchOrderHeader.Get(
                  PurchOrderHeader."Document Type"::Order,
                  DropShipPostBuffer."Order No.");
                PurchOrderHeader."Last Receiving No." := PurchOrderHeader."Receiving No.";
                PurchOrderHeader."Receiving No." := '';
                PurchOrderHeader.Modify;
                ReservePurchLine.UpdateItemTrackingAfterPosting(PurchOrderHeader);
            end;
            PurchOrderLine.Get(
              PurchOrderLine."Document Type"::Order,
              DropShipPostBuffer."Order No.", DropShipPostBuffer."Order Line No.");
            PurchOrderLine."Quantity Received" := PurchOrderLine."Quantity Received" + DropShipPostBuffer.Quantity;
            PurchOrderLine."Qty. Received (Base)" := PurchOrderLine."Qty. Received (Base)" + DropShipPostBuffer."Quantity (Base)";
            PurchOrderLine.InitOutstanding;
            PurchOrderLine.InitQtyToReceive;
            PurchOrderLine.Modify;
        until DropShipPostBuffer.Next = 0;
        DropShipPostBuffer.DeleteAll;
    end;

    local procedure UpdateAssocLines(var SalesOrderLine: Record "Sales Line")
    begin
        PurchOrderLine.Get(
          PurchOrderLine."Document Type"::Order,
          SalesOrderLine."Purchase Order No.", SalesOrderLine."Purch. Order Line No.");
        PurchOrderLine."Sales Order No." := '';
        PurchOrderLine."Sales Order Line No." := 0;
        PurchOrderLine.Modify;
        SalesOrderLine."Purchase Order No." := '';
        SalesOrderLine."Purch. Order Line No." := 0;
    end;

    local procedure FillInvPostingBuffer(SalesLine: Record "Sales Line"; SalesLineACY: Record "Sales Line")
    var
        TotalVAT: Decimal;
        TotalVATACY: Decimal;
        TotalAmount: Decimal;
        TotalAmountACY: Decimal;
        SalesPostInvoice: Codeunit "Sales Post Invoice";
    begin
        // if GLSetup."VAT in Use" then
        //     if (SalesLine."Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") or
        //        (SalesLine."Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
        //     then
        //         GenPostingSetup.Get(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group");
        //InvPostingBuffer[1].PrepareSales(SalesLine);
        //Solo se comenta la siguiente línea por que marca error y este metodo no se llama 
        /*SalesPostInvoice.PrepareInvoicePostingBuffer(SalesLine,InvPostingBuffer[1]);*/

        TotalVAT := SalesLine."Amount Including VAT" - SalesLine.Amount;
        TotalVATACY := SalesLineACY."Amount Including VAT" - SalesLineACY.Amount;
        TotalAmount := SalesLine.Amount;
        TotalAmountACY := SalesLineACY.Amount;

        if SalesSetup."Discount Posting" in
           [SalesSetup."Discount Posting"::"Invoice Discounts", SalesSetup."Discount Posting"::"All Discounts"]
        then begin
            if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Reverse Charge VAT" then
                InvPostingBuffer[1].CalcDiscountNoVAT(
                  -SalesLine."Inv. Discount Amount",
                  -SalesLineACY."Inv. Discount Amount")
            else
                InvPostingBuffer[1].CalcDiscount(
                  SalesHeader."Prices Including VAT",
                  -SalesLine."Inv. Discount Amount",
                  -SalesLineACY."Inv. Discount Amount");
            if (InvPostingBuffer[1].Amount <> 0) or
               (InvPostingBuffer[1]."Amount (ACY)" <> 0)
            then begin
                GenPostingSetup.TestField("Sales Inv. Disc. Account");
                InvPostingBuffer[1].SetAccount(
                  GenPostingSetup."Sales Inv. Disc. Account",
                  TotalVAT,
                  TotalVATACY,
                  TotalAmount,
                  TotalAmountACY);
                //fes mig IF TaxOption = TaxOption::SalesTax THEN
                //fes mig   InvPostingBuffer[1].Update;
                UpdInvPostingBuffer(true);
            end;
        end;

        if SalesSetup."Discount Posting" in
           [SalesSetup."Discount Posting"::"Line Discounts", SalesSetup."Discount Posting"::"All Discounts"]
        then begin
            if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Reverse Charge VAT" then
                InvPostingBuffer[1].CalcDiscountNoVAT(
                  -SalesLine."Line Discount Amount",
                  -SalesLineACY."Line Discount Amount")
            else
                InvPostingBuffer[1].CalcDiscount(
                  SalesHeader."Prices Including VAT",
                  -SalesLine."Line Discount Amount",
                  -SalesLineACY."Line Discount Amount");
            if (InvPostingBuffer[1].Amount <> 0) or
               (InvPostingBuffer[1]."Amount (ACY)" <> 0)
            then begin
                GenPostingSetup.TestField("Sales Line Disc. Account");
                InvPostingBuffer[1].SetAccount(
                  GenPostingSetup."Sales Line Disc. Account",
                  TotalVAT,
                  TotalVATACY,
                  TotalAmount,
                  TotalAmountACY);
                //fes mig IF TaxOption = TaxOption::SalesTax THEN
                //fes mig   InvPostingBuffer[1].Update;
                UpdInvPostingBuffer(true);
            end;
        end;

        //fes mig
        /*
        InvPostingBuffer[1].SetAmounts(
          TotalVAT,
          TotalVATACY,
          TotalAmount,
          TotalAmountACY,
          SalesLine."VAT Difference");
        */
        //fes mig

        if (SalesLine.Type = SalesLine.Type::"G/L Account") or (SalesLine.Type = SalesLine.Type::"Fixed Asset") then
            InvPostingBuffer[1].SetAccount(
              SalesLine."No.",
              TotalVAT,
              TotalVATACY,
              TotalAmount,
              TotalAmountACY)
        else
            if SalesLine."Document Type" in [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] then begin
                GenPostingSetup.TestField("Sales Credit Memo Account");
                InvPostingBuffer[1].SetAccount(
                  GenPostingSetup."Sales Credit Memo Account",
                  TotalVAT,
                  TotalVATACY,
                  TotalAmount,
                  TotalAmountACY);
            end else begin
                GenPostingSetup.TestField("Sales Account");
                InvPostingBuffer[1].SetAccount(
                  GenPostingSetup."Sales Account",
                  TotalVAT,
                  TotalVATACY,
                  TotalAmount,
                  TotalAmountACY);
            end;
        //fes mig IF TaxOption = TaxOption::SalesTax THEN
        //fes mig   InvPostingBuffer[1].Update;
        UpdInvPostingBuffer(false);

    end;

    local procedure UpdInvPostingBuffer(ForceGLAccountType: Boolean)
    var
        RestoreFAType: Boolean;
    begin
        InvPostingBuffer[1]."Dimension Set ID" := SalesLine."Dimension Set ID";

        DimMgt.UpdateGlobalDimFromDimSetID(InvPostingBuffer[1]."Dimension Set ID",
          InvPostingBuffer[1]."Global Dimension 1 Code", InvPostingBuffer[1]."Global Dimension 2 Code");

        if InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"Fixed Asset" then begin
            FALineNo := FALineNo + 1;
            InvPostingBuffer[1]."Fixed Asset Line No." := FALineNo;
            if ForceGLAccountType then begin
                RestoreFAType := true;
                InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"G/L Account";
            end;
        end;

        if SalesLine."Line Discount %" = 100 then begin
            InvPostingBuffer[1]."VAT Base Amount" := 0;
            InvPostingBuffer[1]."VAT Base Amount (ACY)" := 0;
            InvPostingBuffer[1]."VAT Amount" := 0;
            InvPostingBuffer[1]."VAT Amount (ACY)" := 0;
        end;
        InvPostingBuffer[2] := InvPostingBuffer[1];
        if InvPostingBuffer[2].Find then begin
            InvPostingBuffer[2].Amount := InvPostingBuffer[2].Amount + InvPostingBuffer[1].Amount;
            InvPostingBuffer[2]."VAT Amount" :=
              InvPostingBuffer[2]."VAT Amount" + InvPostingBuffer[1]."VAT Amount";
            InvPostingBuffer[2]."VAT Base Amount" :=
              InvPostingBuffer[2]."VAT Base Amount" + InvPostingBuffer[1]."VAT Base Amount";
            InvPostingBuffer[2]."Amount (ACY)" :=
              InvPostingBuffer[2]."Amount (ACY)" + InvPostingBuffer[1]."Amount (ACY)";
            InvPostingBuffer[2]."VAT Amount (ACY)" :=
              InvPostingBuffer[2]."VAT Amount (ACY)" + InvPostingBuffer[1]."VAT Amount (ACY)";
            InvPostingBuffer[2]."VAT Difference" :=
              InvPostingBuffer[2]."VAT Difference" + InvPostingBuffer[1]."VAT Difference";
            InvPostingBuffer[2]."VAT Base Amount (ACY)" :=
              InvPostingBuffer[2]."VAT Base Amount (ACY)" +
              InvPostingBuffer[1]."VAT Base Amount (ACY)";
            InvPostingBuffer[2].Quantity :=
              InvPostingBuffer[2].Quantity + InvPostingBuffer[1].Quantity;
            if not InvPostingBuffer[1]."System-Created Entry" then
                InvPostingBuffer[2]."System-Created Entry" := false;
            InvPostingBuffer[2].Modify;
        end else
            InvPostingBuffer[1].Insert;

        if RestoreFAType then
            InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"Fixed Asset";
    end;

    local procedure InsertPrepmtAdjInvPostingBuf(PrepmtSalesLine: Record "Sales Line")
    var
        SalesPostPrepayments: Codeunit "Sales-Post Prepayments";
        AdjAmount: Decimal;
    begin
        if PrepmtSalesLine."Prepayment Line" then
            if PrepmtSalesLine."Prepmt. Amount Inv. (LCY)" <> 0 then begin
                AdjAmount := -PrepmtSalesLine."Prepmt. Amount Inv. (LCY)";
                FillPrepmtAdjInvPostingBuffer(PrepmtSalesLine."No.", AdjAmount);
                FillPrepmtAdjInvPostingBuffer(
                  SalesPostPrepayments.GetCorrBalAccNo(SalesHeader, AdjAmount > 0),
                  -AdjAmount);
            end else
                if (PrepmtSalesLine."Prepayment %" = 100) and (PrepmtSalesLine."Prepmt. VAT Amount Inv. (LCY)" <> 0) then
                    FillPrepmtAdjInvPostingBuffer(
                      SalesPostPrepayments.GetInvRoundingAccNo(SalesHeader."Customer Posting Group"),
                      PrepmtSalesLine."Prepmt. VAT Amount Inv. (LCY)");
    end;

    local procedure FillPrepmtAdjInvPostingBuffer(GLAccountNo: Code[20]; AdjAmount: Decimal)
    var
        PrepmtAdjInvPostBuffer: Record "Invoice Posting Buffer";
    begin
        PrepmtAdjInvPostBuffer.Init;
        PrepmtAdjInvPostBuffer.Type := PrepmtAdjInvPostBuffer.Type::"Prepmt. Exch. Rate Difference";
        PrepmtAdjInvPostBuffer."G/L Account" := GLAccountNo;
        PrepmtAdjInvPostBuffer.Amount := AdjAmount;
        PrepmtAdjInvPostBuffer."Amount (ACY)" := AdjAmount;
        PrepmtAdjInvPostBuffer."Dimension Set ID" := InvPostingBuffer[1]."Dimension Set ID";
        PrepmtAdjInvPostBuffer."Global Dimension 1 Code" := InvPostingBuffer[1]."Global Dimension 1 Code";
        PrepmtAdjInvPostBuffer."Global Dimension 2 Code" := InvPostingBuffer[1]."Global Dimension 2 Code";
        PrepmtAdjInvPostBuffer."System-Created Entry" := true;
        InvPostingBuffer[1] := PrepmtAdjInvPostBuffer;

        InvPostingBuffer[2] := InvPostingBuffer[1];
        if InvPostingBuffer[2].Find then begin
            InvPostingBuffer[2].Amount := InvPostingBuffer[2].Amount + InvPostingBuffer[1].Amount;
            InvPostingBuffer[2]."Amount (ACY)" :=
              InvPostingBuffer[2]."Amount (ACY)" + InvPostingBuffer[1]."Amount (ACY)";
            InvPostingBuffer[2].Modify;
        end else
            InvPostingBuffer[1].Insert;
    end;

    local procedure GetCurrency()
    begin
        if SalesHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            Currency.Get(SalesHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;

    local procedure DivideAmount(QtyType: Option General,Invoicing,Shipping; SalesLineQty: Decimal)
    begin
        if RoundingLineInserted and (RoundingLineNo = SalesLine."Line No.") then
            exit;
        if (SalesLineQty = 0) or (SalesLine."Unit Price" = 0) then begin
            SalesLine."Line Amount" := 0;
            SalesLine."Line Discount Amount" := 0;
            SalesLine."Inv. Discount Amount" := 0;
            SalesLine."VAT Base Amount" := 0;
            SalesLine.Amount := 0;
            SalesLine."Amount Including VAT" := 0;
        end else
            if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Sales Tax" then begin
                if (QtyType = QtyType::Invoicing) and
                    TempSalesLineForSalesTax.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.")
                then begin
                    SalesLine."Line Amount" := TempSalesLineForSalesTax."Line Amount";
                    SalesLine."Line Discount Amount" := TempSalesLineForSalesTax."Line Discount Amount";
                    SalesLine.Amount := TempSalesLineForSalesTax.Amount;
                    SalesLine."Amount Including VAT" := TempSalesLineForSalesTax."Amount Including VAT";
                    SalesLine."Inv. Discount Amount" := TempSalesLineForSalesTax."Inv. Discount Amount";
                    SalesLine."VAT Base Amount" := TempSalesLineForSalesTax."VAT Base Amount";
                end else begin
                    SalesLine."Line Amount" := Round(SalesLineQty * SalesLine."Unit Price", Currency."Amount Rounding Precision");
                    if SalesLineQty <> SalesLine.Quantity then
                        SalesLine."Line Discount Amount" :=
                          Round(SalesLine."Line Amount" * SalesLine."Line Discount %" / 100, Currency."Amount Rounding Precision");
                    SalesLine."Line Amount" := SalesLine."Line Amount" - SalesLine."Line Discount Amount";
                    if SalesLine."Allow Invoice Disc." then
                        if QtyType = QtyType::Invoicing then
                            SalesLine."Inv. Discount Amount" := SalesLine."Inv. Disc. Amount to Invoice"
                        else begin
                            TempSalesLineForSpread."Inv. Discount Amount" :=
                              TempSalesLineForSpread."Inv. Discount Amount" +
                              SalesLine."Inv. Discount Amount" * SalesLineQty / SalesLine.Quantity;
                            SalesLine."Inv. Discount Amount" :=
                              Round(TempSalesLineForSpread."Inv. Discount Amount", Currency."Amount Rounding Precision");
                            TempSalesLineForSpread."Inv. Discount Amount" :=
                              TempSalesLineForSpread."Inv. Discount Amount" - SalesLine."Inv. Discount Amount";
                        end;
                    SalesLine.Amount := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
                    SalesLine."VAT Base Amount" := SalesLine.Amount;
                    SalesLine."Amount Including VAT" := SalesLine.Amount;
                end;
            end else begin
                TempVATAmountLine.Get(SalesLine."VAT Identifier", SalesLine."VAT Calculation Type", SalesLine."Tax Group Code", false, SalesLine."Line Amount" >= 0);
                if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Sales Tax" then
                    SalesLine."VAT %" := TempVATAmountLine."VAT %";
                TempVATAmountLineRemainder := TempVATAmountLine;
                if not TempVATAmountLineRemainder.Find then begin
                    TempVATAmountLineRemainder.Init;
                    TempVATAmountLineRemainder.Insert;
                end;
                SalesLine."Line Amount" := SalesLine.GetLineAmountToHandle(SalesLineQty) + GetPrepmtDiffToLineAmount(SalesLine);
                if SalesLineQty <> SalesLine.Quantity then
                    SalesLine."Line Discount Amount" :=
                      Round(SalesLine."Line Discount Amount" * SalesLineQty / SalesLine.Quantity, Currency."Amount Rounding Precision");

                if SalesLine."Allow Invoice Disc." and (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) then
                    if QtyType = QtyType::Invoicing then
                        SalesLine."Inv. Discount Amount" := SalesLine."Inv. Disc. Amount to Invoice"
                    else begin
                        TempVATAmountLineRemainder."Invoice Discount Amount" :=
                          TempVATAmountLineRemainder."Invoice Discount Amount" +
                          TempVATAmountLine."Invoice Discount Amount" * SalesLine."Line Amount" /
                          TempVATAmountLine."Inv. Disc. Base Amount";
                        SalesLine."Inv. Discount Amount" :=
                          Round(
                            TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."Invoice Discount Amount" :=
                          TempVATAmountLineRemainder."Invoice Discount Amount" - SalesLine."Inv. Discount Amount";
                    end;

                if SalesHeader."Prices Including VAT" then begin
                    if (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" = 0) or
                        (SalesLine."Line Amount" = 0)
                    then begin
                        TempVATAmountLineRemainder."VAT Amount" := 0;
                        TempVATAmountLineRemainder."Amount Including VAT" := 0;
                    end else begin
                        TempVATAmountLineRemainder."VAT Amount" :=
                          TempVATAmountLineRemainder."VAT Amount" +
                          TempVATAmountLine."VAT Amount" *
                          (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") /
                          (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                        TempVATAmountLineRemainder."Amount Including VAT" :=
                          TempVATAmountLineRemainder."Amount Including VAT" +
                          TempVATAmountLine."Amount Including VAT" *
                          (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") /
                          (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                    end;
                    if SalesLine."Line Discount %" <> 100 then
                        SalesLine."Amount Including VAT" :=
                          Round(TempVATAmountLineRemainder."Amount Including VAT", Currency."Amount Rounding Precision")
                    else
                        SalesLine."Amount Including VAT" := 0;
                    SalesLine.Amount :=
                      Round(SalesLine."Amount Including VAT", Currency."Amount Rounding Precision") -
                      Round(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision");
                    SalesLine."VAT Base Amount" :=
                      Round(
                        SalesLine.Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."Amount Including VAT" :=
                      TempVATAmountLineRemainder."Amount Including VAT" - SalesLine."Amount Including VAT";
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" - SalesLine."Amount Including VAT" + SalesLine.Amount;
                end else begin
                    if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT" then begin
                        if SalesLine."Line Discount %" <> 100 then
                            SalesLine."Amount Including VAT" := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount"
                        else
                            SalesLine."Amount Including VAT" := 0;
                        SalesLine.Amount := 0;
                        SalesLine."VAT Base Amount" := 0;
                    end else begin
                        SalesLine.Amount := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
                        SalesLine."VAT Base Amount" :=
                          Round(
                            SalesLine.Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                        if TempVATAmountLine."VAT Base" = 0 then
                            TempVATAmountLineRemainder."VAT Amount" := 0
                        else
                            TempVATAmountLineRemainder."VAT Amount" :=
                              TempVATAmountLineRemainder."VAT Amount" +
                              TempVATAmountLine."VAT Amount" *
                              (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") /
                              (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                        if SalesLine."Line Discount %" <> 100 then
                            SalesLine."Amount Including VAT" :=
                              SalesLine.Amount + Round(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision")
                        else
                            SalesLine."Amount Including VAT" := 0;
                        TempVATAmountLineRemainder."VAT Amount" :=
                          TempVATAmountLineRemainder."VAT Amount" - SalesLine."Amount Including VAT" + SalesLine.Amount;
                    end;
                end;

                TempVATAmountLineRemainder.Modify;
            end;
    end;

    local procedure RoundAmount(SalesLineQty: Decimal)
    var
        NoVAT: Boolean;
    begin
        //with SalesLine do begin
        IncrAmount(TotalSalesLine);
        Increment(TotalSalesLine."Net Weight", Round(SalesLineQty * SalesLine."Net Weight", 0.00001));
        Increment(TotalSalesLine."Gross Weight", Round(SalesLineQty * SalesLine."Gross Weight", 0.00001));
        Increment(TotalSalesLine."Unit Volume", Round(SalesLineQty * SalesLine."Unit Volume", 0.00001));
        Increment(TotalSalesLine.Quantity, SalesLineQty);
        if SalesLine."Units per Parcel" > 0 then
            Increment(
              TotalSalesLine."Units per Parcel",
              Round(SalesLineQty / SalesLine."Units per Parcel", 1, '>'));

        TempSalesLine := SalesLine;
        SalesLineACY := SalesLine;

        if SalesHeader."Currency Code" <> '' then begin
            if SalesHeader."Posting Date" = 0D then
                UseDate := WorkDate
            else
                UseDate := SalesHeader."Posting Date";

            NoVAT := SalesLine.Amount = SalesLine."Amount Including VAT";
            SalesLine."Amount Including VAT" :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, SalesHeader."Currency Code",
                  TotalSalesLine."Amount Including VAT", SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."Amount Including VAT";
            if NoVAT then
                SalesLine.Amount := SalesLine."Amount Including VAT"
            else
                SalesLine.Amount :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine.Amount, SalesHeader."Currency Factor")) -
                  TotalSalesLineLCY.Amount;
            SalesLine."Line Amount" :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, SalesHeader."Currency Code",
                  TotalSalesLine."Line Amount", SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."Line Amount";
            SalesLine."Line Discount Amount" :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, SalesHeader."Currency Code",
                  TotalSalesLine."Line Discount Amount", SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."Line Discount Amount";
            SalesLine."Inv. Discount Amount" :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, SalesHeader."Currency Code",
                  TotalSalesLine."Inv. Discount Amount", SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."Inv. Discount Amount";
            SalesLine."VAT Difference" :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, SalesHeader."Currency Code",
                  TotalSalesLine."VAT Difference", SalesHeader."Currency Factor")) -
              TotalSalesLineLCY."VAT Difference";
        end;

        IncrAmount(TotalSalesLineLCY);
        if SalesLine."VAT %" <> 0 then
            TotalSalesLineLCY."VAT %" := SalesLine."VAT %";
        Increment(TotalSalesLineLCY."Unit Cost (LCY)", Round(SalesLineQty * SalesLine."Unit Cost (LCY)"));
    end;

    local procedure ReverseAmount(var SalesLine: Record "Sales Line")
    begin
        SalesLine."Qty. to Ship" := -SalesLine."Qty. to Ship";
        SalesLine."Qty. to Ship (Base)" := -SalesLine."Qty. to Ship (Base)";
        SalesLine."Return Qty. to Receive" := -SalesLine."Return Qty. to Receive";
        SalesLine."Return Qty. to Receive (Base)" := -SalesLine."Return Qty. to Receive (Base)";
        SalesLine."Qty. to Invoice" := -SalesLine."Qty. to Invoice";
        SalesLine."Qty. to Invoice (Base)" := -SalesLine."Qty. to Invoice (Base)";
        SalesLine."Line Amount" := -SalesLine."Line Amount";
        SalesLine.Amount := -SalesLine.Amount;
        SalesLine."VAT Base Amount" := -SalesLine."VAT Base Amount";
        SalesLine."VAT Difference" := -SalesLine."VAT Difference";
        SalesLine."Amount Including VAT" := -SalesLine."Amount Including VAT";
        SalesLine."Line Discount Amount" := -SalesLine."Line Discount Amount";
        SalesLine."Inv. Discount Amount" := -SalesLine."Inv. Discount Amount";
    end;

    local procedure InvoiceRounding(UseTempData: Boolean; BiggestLineNo: Integer)
    var
        InvoiceRoundingAmount: Decimal;
    begin
        Currency.TestField("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -Round(
            TotalSalesLine."Amount Including VAT" -
            Round(
              TotalSalesLine."Amount Including VAT",
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");
        if InvoiceRoundingAmount <> 0 then begin
            CustPostingGr.Get(SalesHeader."Customer Posting Group");
            CustPostingGr.TestField("Invoice Rounding Account");

            SalesLine.Init;
            BiggestLineNo := BiggestLineNo + 10000;
            SalesLine."System-Created Entry" := true;
            if UseTempData then begin
                SalesLine."Line No." := 0;
                SalesLine.Type := SalesLine.Type::"G/L Account";
            end else begin
                SalesLine."Line No." := BiggestLineNo;
                SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
            end;
            SalesLine.Validate("No.", CustPostingGr."Invoice Rounding Account");
            SalesLine."Tax Area Code" := '';
            SalesLine."Tax Liable" := false;
            SalesLine.Validate(Quantity, 1);
            if SalesLine."Document Type" in [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] then
                SalesLine.Validate("Return Qty. to Receive", SalesLine.Quantity)
            else
                SalesLine.Validate("Qty. to Ship", SalesLine.Quantity);
            if SalesHeader."Prices Including VAT" then
                SalesLine.Validate("Unit Price", InvoiceRoundingAmount)
            else
                SalesLine.Validate(
                  "Unit Price",
                  Round(
                    InvoiceRoundingAmount /
                    (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * SalesLine."VAT %" / 100),
                    Currency."Amount Rounding Precision"));
            SalesLine.Validate("Amount Including VAT", InvoiceRoundingAmount);
            SalesLine."Line No." := BiggestLineNo;
            if not UseTempData then
                ;
            LastLineRetrieved := false;
            RoundingLineInserted := true;
            RoundingLineNo := SalesLine."Line No.";
        end;
    end;

    local procedure IncrAmount(var TotalSalesLine: Record "Sales Line")
    begin
        if SalesHeader."Prices Including VAT" or
            (SalesLine."VAT Calculation Type" <> SalesLine."VAT Calculation Type"::"Full VAT")
        then
            Increment(TotalSalesLine."Line Amount", SalesLine."Line Amount");
        Increment(TotalSalesLine.Amount, SalesLine.Amount);
        Increment(TotalSalesLine."VAT Base Amount", SalesLine."VAT Base Amount");
        Increment(TotalSalesLine."VAT Difference", SalesLine."VAT Difference");
        Increment(TotalSalesLine."Amount Including VAT", SalesLine."Amount Including VAT");
        Increment(TotalSalesLine."Line Discount Amount", SalesLine."Line Discount Amount");
        Increment(TotalSalesLine."Inv. Discount Amount", SalesLine."Inv. Discount Amount");
        Increment(TotalSalesLine."Inv. Disc. Amount to Invoice", SalesLine."Inv. Disc. Amount to Invoice");
        Increment(TotalSalesLine."Prepmt. Line Amount", SalesLine."Prepmt. Line Amount");
        Increment(TotalSalesLine."Prepmt. Amt. Inv.", SalesLine."Prepmt. Amt. Inv.");
        Increment(TotalSalesLine."Prepmt Amt to Deduct", SalesLine."Prepmt Amt to Deduct");
        Increment(TotalSalesLine."Prepmt Amt Deducted", SalesLine."Prepmt Amt Deducted");
        Increment(TotalSalesLine."Prepayment VAT Difference", SalesLine."Prepayment VAT Difference");
        Increment(TotalSalesLine."Prepmt VAT Diff. to Deduct", SalesLine."Prepmt VAT Diff. to Deduct");
        Increment(TotalSalesLine."Prepmt VAT Diff. Deducted", SalesLine."Prepmt VAT Diff. Deducted");
    end;

    local procedure Increment(var Number: Decimal; Number2: Decimal)
    begin
        Number := Number + Number2;
    end;


    procedure GetSalesLines(var NewSalesHeader: Record "Sales Header"; var NewSalesLine: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping)
    var
        OldSalesLine: Record "Sales Line";
        MergedSalesLines: Record "Sales Line" temporary;
        TotalAdjCostLCY: Decimal;
    begin
        SalesHeader := NewSalesHeader;
        if QtyType = QtyType::Invoicing then begin
            CreatePrepaymentLines(SalesHeader, TempPrepaymentSalesLine, false);
            MergeSaleslines(SalesHeader, OldSalesLine, TempPrepaymentSalesLine, MergedSalesLines);
            SumSalesLines2(NewSalesLine, MergedSalesLines, QtyType, true, false, TotalAdjCostLCY);
        end else
            SumSalesLines2(NewSalesLine, OldSalesLine, QtyType, true, false, TotalAdjCostLCY);
    end;


    procedure GetSalesLinesTemp(var NewSalesHeader: Record "Sales Header"; var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping)
    var
        TotalAdjCostLCY: Decimal;
    begin
        SalesHeader := NewSalesHeader;
        OldSalesLine.SetSalesHeader(NewSalesHeader);
        SumSalesLines2(NewSalesLine, OldSalesLine, QtyType, true, false, TotalAdjCostLCY);
    end;


    procedure SumSalesLines(var NewSalesHeader: Record "Sales Header"; QtyType: Option General,Invoicing,Shipping; var NewTotalSalesLine: Record "Sales Line"; var NewTotalSalesLineLCY: Record "Sales Line"; var VATAmount: Decimal; var VATAmountText: Text[30]; var ProfitLCY: Decimal; var ProfitPct: Decimal; var TotalAdjCostLCY: Decimal)
    var
        OldSalesLine: Record "Sales Line";
    begin
        SumSalesLinesTemp(
          NewSalesHeader, OldSalesLine, QtyType, NewTotalSalesLine, NewTotalSalesLineLCY,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);
    end;


    procedure SumSalesLinesTemp(var NewSalesHeader: Record "Sales Header"; var OldSalesLine: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping; var NewTotalSalesLine: Record "Sales Line"; var NewTotalSalesLineLCY: Record "Sales Line"; var VATAmount: Decimal; var VATAmountText: Text[30]; var ProfitLCY: Decimal; var ProfitPct: Decimal; var TotalAdjCostLCY: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesHeader := NewSalesHeader;
        SumSalesLines2(SalesLine, OldSalesLine, QtyType, false, true, TotalAdjCostLCY);
        ProfitLCY := TotalSalesLineLCY.Amount - TotalSalesLineLCY."Unit Cost (LCY)";
        if TotalSalesLineLCY.Amount = 0 then
            ProfitPct := 0
        else
            ProfitPct := Round(ProfitLCY / TotalSalesLineLCY.Amount * 100, 0.1);
        VATAmount := TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount;
        if TotalSalesLine."VAT %" = 0 then
            VATAmountText := Text016
        else
            VATAmountText := StrSubstNo(Text017, TotalSalesLine."VAT %");
        NewTotalSalesLine := TotalSalesLine;
        NewTotalSalesLineLCY := TotalSalesLineLCY;
    end;

    local procedure SumSalesLines2(var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping; InsertSalesLine: Boolean; CalcAdCostLCY: Boolean; var TotalAdjCostLCY: Decimal)
    var
        SalesLineQty: Decimal;
        AdjCostLCY: Decimal;
        BiggestLineNo: Integer;
    begin
        TotalAdjCostLCY := 0;
        TempVATAmountLineRemainder.DeleteAll;
        OldSalesLine.CalcVATAmountLines(QtyType, SalesHeader, OldSalesLine, TempVATAmountLine);

        GetGLSetup;
        SalesSetup.Get;
        GetCurrency;
        OldSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        OldSalesLine.SetRange("Document No.", SalesHeader."No.");
        RoundingLineInserted := false;
        if OldSalesLine.FindSet then
            repeat
                if not RoundingLineInserted then
                    SalesLine := OldSalesLine;
                case QtyType of
                    QtyType::General:
                        SalesLineQty := SalesLine.Quantity;
                    QtyType::Invoicing:
                        SalesLineQty := SalesLine."Qty. to Invoice";
                    QtyType::Shipping:
                        begin
                            if SalesHeader."Document Type" in [SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo"] then
                                SalesLineQty := SalesLine."Return Qty. to Receive"
                            else
                                SalesLineQty := SalesLine."Qty. to Ship";
                        end;
                end;
                DivideAmount(QtyType, SalesLineQty);
                SalesLine.Quantity := SalesLineQty;
                if SalesLineQty <> 0 then begin
                    if (SalesLine.Amount <> 0) and not RoundingLineInserted then
                        if TotalSalesLine.Amount = 0 then
                            TotalSalesLine."VAT %" := SalesLine."VAT %"
                        else
                            if TotalSalesLine."VAT %" <> SalesLine."VAT %" then
                                TotalSalesLine."VAT %" := 0;
                    RoundAmount(SalesLineQty);

                    if (QtyType in [QtyType::General, QtyType::Invoicing]) and
                        not InsertSalesLine and CalcAdCostLCY
                    then begin
                        AdjCostLCY := CostCalcMgt.CalcSalesLineCostLCY(SalesLine, QtyType);
                        TotalAdjCostLCY := TotalAdjCostLCY + GetSalesLineAdjCostLCY(SalesLine, QtyType, AdjCostLCY);
                    end;

                    SalesLine := TempSalesLine;
                end;
                if InsertSalesLine then begin
                    NewSalesLine := SalesLine;
                    NewSalesLine.Insert;
                end;
                if RoundingLineInserted then
                    LastLineRetrieved := true
                else begin
                    BiggestLineNo := MAX(BiggestLineNo, OldSalesLine."Line No.");
                    LastLineRetrieved := OldSalesLine.Next = 0;
                    if LastLineRetrieved and SalesSetup."Invoice Rounding" then
                        InvoiceRounding(true, BiggestLineNo);
                end;
            until LastLineRetrieved;
    end;

    local procedure GetSalesLineAdjCostLCY(SalesLine2: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping; AdjCostLCY: Decimal): Decimal
    begin
        if SalesLine2."Document Type" in [SalesLine2."Document Type"::Order, SalesLine2."Document Type"::Invoice] then
            AdjCostLCY := -AdjCostLCY;

        case true of
            SalesLine2."Shipment No." <> '', SalesLine2."Return Receipt No." <> '':
                exit(AdjCostLCY);
            QtyType = QtyType::General:
                exit(Round(SalesLine2."Outstanding Quantity" * SalesLine2."Unit Cost (LCY)") + AdjCostLCY);
            SalesLine2."Document Type" in [SalesLine2."Document Type"::Order, SalesLine2."Document Type"::Invoice]:
                begin
                    if SalesLine2."Qty. to Invoice" > SalesLine2."Qty. to Ship" then
                        exit(Round(SalesLine2."Qty. to Ship" * SalesLine2."Unit Cost (LCY)") + AdjCostLCY);
                    exit(Round(SalesLine2."Qty. to Invoice" * SalesLine2."Unit Cost (LCY)"));
                end;
            SalesLine2."Document Type" in [SalesLine2."Document Type"::"Return Order", SalesLine2."Document Type"::"Credit Memo"]:
                begin
                    if SalesLine2."Qty. to Invoice" > SalesLine2."Return Qty. to Receive" then
                        exit(Round(SalesLine2."Return Qty. to Receive" * SalesLine2."Unit Cost (LCY)") + AdjCostLCY);
                    exit(Round(SalesLine2."Qty. to Invoice" * SalesLine2."Unit Cost (LCY)"));
                end;
        end;
    end;


    procedure TestDeleteHeader(SalesHeader: Record "Sales Header"; var SalesShptHeader: Record "Sales Shipment Header"; var SalesInvHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnRcptHeader: Record "Return Receipt Header"; var SalesInvHeaderPrePmt: Record "Sales Invoice Header"; var SalesCrMemoHeaderPrePmt: Record "Sales Cr.Memo Header")
    begin
        Clear(SalesShptHeader);
        Clear(SalesInvHeader);
        Clear(SalesCrMemoHeader);
        Clear(ReturnRcptHeader);
        SalesSetup.Get;

        SourceCodeSetup.Get;
        SourceCodeSetup.TestField("Deleted Document");
        SourceCode.Get(SourceCodeSetup."Deleted Document");

        if (SalesHeader."Shipping No. Series" <> '') and (SalesHeader."Shipping No." <> '') then begin
            SalesShptHeader.TransferFields(SalesHeader);
            SalesShptHeader."No." := SalesHeader."Shipping No.";
            SalesShptHeader."Posting Date" := Today;
            SalesShptHeader."User ID" := UserId;
            SalesShptHeader."Source Code" := SourceCode.Code;
        end;

        if (SalesHeader."Return Receipt No. Series" <> '') and (SalesHeader."Return Receipt No." <> '') then begin
            ReturnRcptHeader.TransferFields(SalesHeader);
            ReturnRcptHeader."No." := SalesHeader."Return Receipt No.";
            ReturnRcptHeader."Posting Date" := Today;
            ReturnRcptHeader."User ID" := UserId;
            ReturnRcptHeader."Source Code" := SourceCode.Code;
        end;

        if (SalesHeader."Posting No. Series" <> '') and
            ((SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) and
            (SalesHeader."Posting No." <> '') or
            (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) and
            (SalesHeader."No. Series" = SalesHeader."Posting No. Series"))
        then begin
            SalesInvHeader.TransferFields(SalesHeader);
            if SalesHeader."Posting No." <> '' then
                SalesInvHeader."No." := SalesHeader."Posting No.";
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
                SalesInvHeader."Pre-Assigned No. Series" := SalesHeader."No. Series";
                SalesInvHeader."Pre-Assigned No." := SalesHeader."No.";
            end else begin
                SalesInvHeader."Pre-Assigned No. Series" := '';
                SalesInvHeader."Pre-Assigned No." := '';
                SalesInvHeader."Order No. Series" := SalesHeader."No. Series";
                SalesInvHeader."Order No." := SalesHeader."No.";
            end;
            SalesInvHeader."Posting Date" := Today;
            SalesInvHeader."User ID" := UserId;
            SalesInvHeader."Source Code" := SourceCode.Code;
        end;

        if (SalesHeader."Posting No. Series" <> '') and
            ((SalesHeader."Document Type" in [SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo"]) and
            (SalesHeader."Posting No." <> '') or
            (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") and
            (SalesHeader."No. Series" = SalesHeader."Posting No. Series"))
        then begin
            SalesCrMemoHeader.TransferFields(SalesHeader);
            if SalesHeader."Posting No." <> '' then
                SalesCrMemoHeader."No." := SalesHeader."Posting No.";
            SalesCrMemoHeader."Pre-Assigned No. Series" := SalesHeader."No. Series";
            SalesCrMemoHeader."Pre-Assigned No." := SalesHeader."No.";
            SalesCrMemoHeader."Posting Date" := Today;
            SalesCrMemoHeader."User ID" := UserId;
            SalesCrMemoHeader."Source Code" := SourceCode.Code;
        end;
        if (SalesHeader."Prepayment No. Series" <> '') and (SalesHeader."Prepayment No." <> '') then begin
            SalesHeader.TestField("Document Type", SalesHeader."Document Type"::Order);
            SalesInvHeaderPrePmt.TransferFields(SalesHeader);
            SalesInvHeaderPrePmt."No." := SalesHeader."Prepayment No.";
            SalesInvHeaderPrePmt."Order No. Series" := SalesHeader."No. Series";
            SalesInvHeaderPrePmt."Prepayment Order No." := SalesHeader."No.";
            SalesInvHeaderPrePmt."Posting Date" := Today;
            SalesInvHeaderPrePmt."Pre-Assigned No. Series" := '';
            SalesInvHeaderPrePmt."Pre-Assigned No." := '';
            SalesInvHeaderPrePmt."User ID" := UserId;
            SalesInvHeaderPrePmt."Source Code" := SourceCode.Code;
            SalesInvHeaderPrePmt."Prepayment Invoice" := true;
        end;

        if (SalesHeader."Prepmt. Cr. Memo No. Series" <> '') and (SalesHeader."Prepmt. Cr. Memo No." <> '') then begin
            SalesHeader.TestField("Document Type", SalesHeader."Document Type"::Order);
            SalesCrMemoHeaderPrePmt.TransferFields(SalesHeader);
            SalesCrMemoHeaderPrePmt."No." := SalesHeader."Prepmt. Cr. Memo No.";
            SalesCrMemoHeaderPrePmt."Prepayment Order No." := SalesHeader."No.";
            SalesCrMemoHeaderPrePmt."Posting Date" := Today;
            SalesCrMemoHeaderPrePmt."Pre-Assigned No. Series" := '';
            SalesCrMemoHeaderPrePmt."Pre-Assigned No." := '';
            SalesCrMemoHeaderPrePmt."User ID" := UserId;
            SalesCrMemoHeaderPrePmt."Source Code" := SourceCode.Code;
            SalesCrMemoHeaderPrePmt."Prepayment Credit Memo" := true;
        end;
    end;


    procedure DeleteHeader(SalesHeader: Record "Sales Header"; var SalesShptHeader: Record "Sales Shipment Header"; var SalesInvHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnRcptHeader: Record "Return Receipt Header"; var SalesInvHeaderPrePmt: Record "Sales Invoice Header"; var SalesCrMemoHeaderPrePmt: Record "Sales Cr.Memo Header")
    begin
        TestDeleteHeader(
          SalesHeader, SalesShptHeader, SalesInvHeader, SalesCrMemoHeader,
          ReturnRcptHeader, SalesInvHeaderPrePmt, SalesCrMemoHeaderPrePmt);
        if SalesShptHeader."No." <> '' then begin
            SalesShptHeader.Insert;
            SalesShptLine.Init;
            SalesShptLine."Document No." := SalesShptHeader."No.";
            SalesShptLine."Line No." := 10000;
            SalesShptLine.Description := SourceCode.Description;
            SalesShptLine.Insert;
        end;

        if ReturnRcptHeader."No." <> '' then begin
            ReturnRcptHeader.Insert;
            ReturnRcptLine.Init;
            ReturnRcptLine."Document No." := ReturnRcptHeader."No.";
            ReturnRcptLine."Line No." := 10000;
            ReturnRcptLine.Description := SourceCode.Description;
            ReturnRcptLine.Insert;
        end;

        if SalesInvHeader."No." <> '' then begin
            SalesInvHeader.Insert;
            SalesInvLine.Init;
            SalesInvLine."Document No." := SalesInvHeader."No.";
            SalesInvLine."Line No." := 10000;
            SalesInvLine.Description := SourceCode.Description;
            SalesInvLine.Insert;
        end;

        if SalesCrMemoHeader."No." <> '' then begin
            SalesCrMemoHeader.Insert;
            SalesCrMemoLine.Init;
            SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
            SalesCrMemoLine."Line No." := 10000;
            SalesCrMemoLine.Description := SourceCode.Description;
            SalesCrMemoLine.Insert;
        end;

        if SalesInvHeaderPrePmt."No." <> '' then begin
            SalesInvHeaderPrePmt.Insert;
            SalesInvLine."Document No." := SalesInvHeaderPrePmt."No.";
            SalesInvLine."Line No." := 10000;
            SalesInvLine.Description := SourceCode.Description;
            SalesInvLine.Insert;
        end;

        if SalesCrMemoHeaderPrePmt."No." <> '' then begin
            SalesCrMemoHeaderPrePmt.Insert;
            SalesCrMemoLine.Init;
            SalesCrMemoLine."Document No." := SalesCrMemoHeaderPrePmt."No.";
            SalesCrMemoLine."Line No." := 10000;
            SalesCrMemoLine.Description := SourceCode.Description;
            SalesCrMemoLine.Insert;
        end;
    end;


    procedure UpdateBlanketOrderLine(SalesLine: Record "Sales Line"; Ship: Boolean; Receive: Boolean; Invoice: Boolean)
    var
        BlanketOrderSalesLine: Record "Sales Line";
        ModifyLine: Boolean;
        Sign: Decimal;
    begin
        if SalesLine."Document Type" in [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] then
            exit;
        if (SalesLine."Blanket Order No." <> '') and (SalesLine."Blanket Order Line No." <> 0) and
           ((Ship and (SalesLine."Qty. to Ship" <> 0)) or
            (Receive and (SalesLine."Return Qty. to Receive" <> 0)) or
            (Invoice and (SalesLine."Qty. to Invoice" <> 0)))
        then
            if BlanketOrderSalesLine.Get(
                 BlanketOrderSalesLine."Document Type"::"Blanket Order", SalesLine."Blanket Order No.",
                 SalesLine."Blanket Order Line No.")
            then begin
                BlanketOrderSalesLine.TestField(Type, SalesLine.Type);
                BlanketOrderSalesLine.TestField("No.", SalesLine."No.");
                BlanketOrderSalesLine.TestField("Sell-to Customer No.", SalesLine."Sell-to Customer No.");

                ModifyLine := false;
                case SalesLine."Document Type" of
                    SalesLine."Document Type"::Order,
                  SalesLine."Document Type"::Invoice:
                        Sign := 1;
                    SalesLine."Document Type"::"Return Order",
                  SalesLine."Document Type"::"Credit Memo":
                        Sign := -1;
                end;
                if Ship and (SalesLine."Shipment No." = '') then begin
                    if BlanketOrderSalesLine."Qty. per Unit of Measure" =
                       SalesLine."Qty. per Unit of Measure"
                    then
                        BlanketOrderSalesLine."Quantity Shipped" :=
                          BlanketOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Qty. to Ship"
                    else
                        BlanketOrderSalesLine."Quantity Shipped" :=
                          BlanketOrderSalesLine."Quantity Shipped" +
                          Sign *
                          Round(
                            (SalesLine."Qty. per Unit of Measure" /
                             BlanketOrderSalesLine."Qty. per Unit of Measure") *
                            SalesLine."Qty. to Ship", 0.00001);
                    BlanketOrderSalesLine."Qty. Shipped (Base)" :=
                      BlanketOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Qty. to Ship (Base)";
                    ModifyLine := true;
                end;
                if Receive and (SalesLine."Return Receipt No." = '') then begin
                    if BlanketOrderSalesLine."Qty. per Unit of Measure" =
                       SalesLine."Qty. per Unit of Measure"
                    then
                        BlanketOrderSalesLine."Quantity Shipped" :=
                          BlanketOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Return Qty. to Receive"
                    else
                        BlanketOrderSalesLine."Quantity Shipped" :=
                          BlanketOrderSalesLine."Quantity Shipped" +
                          Sign *
                          Round(
                            (SalesLine."Qty. per Unit of Measure" /
                             BlanketOrderSalesLine."Qty. per Unit of Measure") *
                            SalesLine."Return Qty. to Receive", 0.00001);
                    BlanketOrderSalesLine."Qty. Shipped (Base)" :=
                      BlanketOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Return Qty. to Receive (Base)";
                    ModifyLine := true;
                end;
                if Invoice then begin
                    if BlanketOrderSalesLine."Qty. per Unit of Measure" =
                       SalesLine."Qty. per Unit of Measure"
                    then
                        BlanketOrderSalesLine."Quantity Invoiced" :=
                          BlanketOrderSalesLine."Quantity Invoiced" + Sign * SalesLine."Qty. to Invoice"
                    else
                        BlanketOrderSalesLine."Quantity Invoiced" :=
                          BlanketOrderSalesLine."Quantity Invoiced" +
                          Sign *
                          Round(
                            (SalesLine."Qty. per Unit of Measure" /
                             BlanketOrderSalesLine."Qty. per Unit of Measure") *
                            SalesLine."Qty. to Invoice", 0.00001);
                    BlanketOrderSalesLine."Qty. Invoiced (Base)" :=
                      BlanketOrderSalesLine."Qty. Invoiced (Base)" + Sign * SalesLine."Qty. to Invoice (Base)";
                    ModifyLine := true;
                end;

                if ModifyLine then begin
                    BlanketOrderSalesLine.InitOutstanding;
                    if (BlanketOrderSalesLine.Quantity * BlanketOrderSalesLine."Quantity Shipped" < 0) or
                       (Abs(BlanketOrderSalesLine.Quantity) < Abs(BlanketOrderSalesLine."Quantity Shipped"))
                    then
                        BlanketOrderSalesLine.FieldError(
                          "Quantity Shipped", StrSubstNo(
                            Text018,
                            BlanketOrderSalesLine.FieldCaption(Quantity)));

                    if (BlanketOrderSalesLine."Quantity (Base)" *
                        BlanketOrderSalesLine."Qty. Shipped (Base)" < 0) or
                       (Abs(BlanketOrderSalesLine."Quantity (Base)") <
                        Abs(BlanketOrderSalesLine."Qty. Shipped (Base)"))
                    then
                        BlanketOrderSalesLine.FieldError(
                          "Qty. Shipped (Base)",
                          StrSubstNo(
                            Text018,
                            BlanketOrderSalesLine.FieldCaption("Quantity (Base)")));

                    BlanketOrderSalesLine.CalcFields("Reserved Qty. (Base)");
                    if Abs(BlanketOrderSalesLine."Outstanding Qty. (Base)") <
                       Abs(BlanketOrderSalesLine."Reserved Qty. (Base)")
                    then
                        BlanketOrderSalesLine.FieldError(
                          "Reserved Qty. (Base)",
                          Text019);

                    BlanketOrderSalesLine."Qty. to Invoice" :=
                      BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Invoiced";
                    BlanketOrderSalesLine."Qty. to Ship" :=
                      BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Shipped";
                    BlanketOrderSalesLine."Qty. to Invoice (Base)" :=
                      BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Invoiced (Base)";
                    BlanketOrderSalesLine."Qty. to Ship (Base)" :=
                      BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Shipped (Base)";

                    BlanketOrderSalesLine.Modify;
                end;
            end;
    end;

    local procedure CopyCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    begin
        SalesCommentLine.SetRange("Document Type", FromDocumentType);
        SalesCommentLine.SetRange("No.", FromNumber);
        if SalesCommentLine.FindSet then
            repeat
                SalesCommentLine2 := SalesCommentLine;
                SalesCommentLine2."Document Type" := "Sales Comment Document Type".FromInteger(ToDocumentType);
                SalesCommentLine2."No." := ToNumber;
                SalesCommentLine2.Insert;
            until SalesCommentLine.Next = 0;
    end;

    local procedure RunGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"): Integer
    begin
        exit(GenJnlPostLine.RunWithCheck(GenJnlLine));
    end;

    local procedure CheckDim()
    var
        SalesLine2: Record "Sales Line";
    begin
        SalesLine2."Line No." := 0;
        CheckDimValuePosting(SalesLine2);
        CheckDimComb(SalesLine2);

        SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine2.SetRange("Document No.", SalesHeader."No.");
        SalesLine2.SetFilter(Type, '<>%1', SalesLine2.Type::" ");
        if SalesLine2.FindSet then
            repeat
                if (SalesHeader.Invoice and (SalesLine2."Qty. to Invoice" <> 0)) or
                   (SalesHeader.Ship and (SalesLine2."Qty. to Ship" <> 0)) or
                   (SalesHeader.Receive and (SalesLine2."Return Qty. to Receive" <> 0))
                then begin
                    CheckDimComb(SalesLine2);
                    CheckDimValuePosting(SalesLine2);
                end
            until SalesLine2.Next = 0;
    end;

    local procedure CheckDimComb(SalesLine: Record "Sales Line")
    begin
        if SalesLine."Line No." = 0 then
            if not DimMgt.CheckDimIDComb(SalesHeader."Dimension Set ID") then
                Error(
                  Text028,
                  SalesHeader."Document Type", SalesHeader."No.", DimMgt.GetDimCombErr);

        if SalesLine."Line No." <> 0 then
            if not DimMgt.CheckDimIDComb(SalesLine."Dimension Set ID") then
                Error(
                  Text029,
                  SalesHeader."Document Type", SalesHeader."No.", SalesLine."Line No.", DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(var SalesLine2: Record "Sales Line")
    var
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        if SalesLine2."Line No." = 0 then begin
            TableIDArr[1] := DATABASE::Customer;
            NumberArr[1] := SalesHeader."Bill-to Customer No.";
            TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
            NumberArr[2] := SalesHeader."Salesperson Code";
            TableIDArr[3] := DATABASE::Campaign;
            NumberArr[3] := SalesHeader."Campaign No.";
            TableIDArr[4] := DATABASE::"Responsibility Center";
            NumberArr[4] := SalesHeader."Responsibility Center";
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, SalesHeader."Dimension Set ID") then
                Error(
                  Text030,
                  SalesHeader."Document Type", SalesHeader."No.", DimMgt.GetDimValuePostingErr);
        end else begin
            /*    TableIDArr[1] := DimMgt.TypeToTableID3(SalesLine2.Type); */
            NumberArr[1] := SalesLine2."No.";
            TableIDArr[2] := DATABASE::Job;
            NumberArr[2] := SalesLine2."Job No.";
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, SalesLine2."Dimension Set ID") then
                Error(
                  Text031,
                  SalesHeader."Document Type", SalesHeader."No.", SalesLine2."Line No.", DimMgt.GetDimValuePostingErr);
        end;
    end;


    procedure CopyAprvlToTempApprvl()
    begin
        TempApprovalEntry.Reset;
        TempApprovalEntry.DeleteAll;
        ApprovalEntry.SetRange("Table ID", DATABASE::"Sales Header");
        ApprovalEntry.SetRange("Document Type", SalesHeader."Document Type");
        ApprovalEntry.SetRange("Document No.", SalesHeader."No.");
        if ApprovalEntry.FindSet then
            repeat
                TempApprovalEntry.Init;
                TempApprovalEntry := ApprovalEntry;
                TempApprovalEntry.Insert;
            until ApprovalEntry.Next = 0;
    end;

    local procedure DeleteItemChargeAssgnt()
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
    begin
        ItemChargeAssgntSales.SetRange("Document Type", SalesLine."Document Type");
        ItemChargeAssgntSales.SetRange("Document No.", SalesLine."Document No.");
        if not ItemChargeAssgntSales.IsEmpty then
            ItemChargeAssgntSales.DeleteAll;
    end;

    local procedure UpdateItemChargeAssgnt()
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
    begin
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntSales.MarkedOnly(true);
        if TempItemChargeAssgntSales.FindSet then
            repeat
                ItemChargeAssgntSales.Get(TempItemChargeAssgntSales."Document Type", TempItemChargeAssgntSales."Document No.", TempItemChargeAssgntSales."Document Line No.", TempItemChargeAssgntSales."Line No.");
                ItemChargeAssgntSales."Qty. Assigned" :=
                  ItemChargeAssgntSales."Qty. Assigned" + TempItemChargeAssgntSales."Qty. to Assign";
                ItemChargeAssgntSales."Qty. to Assign" := 0;
                ItemChargeAssgntSales."Amount to Assign" := 0;
                ItemChargeAssgntSales.Modify;
            until TempItemChargeAssgntSales.Next = 0;
    end;

    local procedure UpdateSalesOrderChargeAssgnt(SalesOrderInvLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line")
    var
        SalesOrderLine2: Record "Sales Line";
        SalesOrderInvLine2: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
    begin
        //with SalesOrderInvLine. do begin
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntSales.SetRange("Document Type", SalesOrderInvLine."Document Type");
        TempItemChargeAssgntSales.SetRange("Document No.", SalesOrderInvLine."Document No.");
        TempItemChargeAssgntSales.SetRange("Document Line No.", SalesOrderInvLine."Line No.");
        TempItemChargeAssgntSales.MarkedOnly(true);
        if TempItemChargeAssgntSales.FindSet then
            repeat
                if TempItemChargeAssgntSales."Applies-to Doc. Type" = SalesOrderInvLine."Document Type" then begin
                    SalesOrderInvLine2.Get(
                      TempItemChargeAssgntSales."Applies-to Doc. Type",
                      TempItemChargeAssgntSales."Applies-to Doc. No.",
                      TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                    if ((SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::Order) and
                        (SalesOrderInvLine2."Shipment No." = SalesOrderInvLine."Shipment No.")) or
                        ((SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::"Return Order") and
                        (SalesOrderInvLine2."Return Receipt No." = SalesOrderInvLine."Return Receipt No."))
                    then begin
                        if SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::Order then begin
                            if not
                                SalesShptLine.Get(SalesOrderInvLine2."Shipment No.", SalesOrderInvLine2."Shipment Line No.")
                            then
                                Error(Text013);
                            SalesOrderLine2.Get(
                              SalesOrderLine2."Document Type"::Order,
                              SalesShptLine."Order No.", SalesShptLine."Order Line No.");
                        end else begin
                            if not
                                ReturnRcptLine.Get(SalesOrderInvLine2."Return Receipt No.", SalesOrderInvLine2."Return Receipt Line No.")
                            then
                                Error(Text037);
                            SalesOrderLine2.Get(
                              SalesOrderLine2."Document Type"::"Return Order",
                              ReturnRcptLine."Return Order No.", ReturnRcptLine."Return Order Line No.");
                        end;
                        UpdateSalesChargeAssgntLines(
                          SalesOrderLine,
                          SalesOrderLine2."Document Type".AsInteger(),
                          SalesOrderLine2."Document No.",
                          SalesOrderLine2."Line No.",
                          TempItemChargeAssgntSales."Qty. to Assign");
                    end;
                end else
                    UpdateSalesChargeAssgntLines(
                      SalesOrderLine,
                      TempItemChargeAssgntSales."Applies-to Doc. Type".AsInteger(),
                      TempItemChargeAssgntSales."Applies-to Doc. No.",
                      TempItemChargeAssgntSales."Applies-to Doc. Line No.",
                      TempItemChargeAssgntSales."Qty. to Assign");
            until TempItemChargeAssgntSales.Next = 0;
    end;

    local procedure UpdateSalesChargeAssgntLines(SalesOrderLine: Record "Sales Line"; ApplToDocType: Option; ApplToDocNo: Code[20]; ApplToDocLineNo: Integer; QtyToAssign: Decimal)
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales2: Record "Item Charge Assignment (Sales)";
        LastLineNo: Integer;
        TotalToAssign: Decimal;
    begin
        ItemChargeAssgntSales.SetRange("Document Type", SalesOrderLine."Document Type");
        ItemChargeAssgntSales.SetRange("Document No.", SalesOrderLine."Document No.");
        ItemChargeAssgntSales.SetRange("Document Line No.", SalesOrderLine."Line No.");
        ItemChargeAssgntSales.SetRange("Applies-to Doc. Type", ApplToDocType);
        ItemChargeAssgntSales.SetRange("Applies-to Doc. No.", ApplToDocNo);
        ItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.", ApplToDocLineNo);
        if ItemChargeAssgntSales.FindFirst then begin
            ItemChargeAssgntSales."Qty. Assigned" := ItemChargeAssgntSales."Qty. Assigned" + QtyToAssign;
            ItemChargeAssgntSales."Qty. to Assign" := 0;
            ItemChargeAssgntSales."Amount to Assign" := 0;
            ItemChargeAssgntSales.Modify;
        end else begin
            ItemChargeAssgntSales.SetRange("Applies-to Doc. Type");
            ItemChargeAssgntSales.SetRange("Applies-to Doc. No.");
            ItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.");
            ItemChargeAssgntSales.CalcSums("Qty. to Assign");

            // calculate total qty. to assign of the invoice charge line
            TempItemChargeAssgntSales2.SetRange("Document Type", TempItemChargeAssgntSales."Document Type");
            TempItemChargeAssgntSales2.SetRange("Document No.", TempItemChargeAssgntSales."Document No.");
            TempItemChargeAssgntSales2.SetRange("Document Line No.", TempItemChargeAssgntSales."Document Line No.");
            TempItemChargeAssgntSales2.CalcSums("Qty. to Assign");

            TotalToAssign := ItemChargeAssgntSales."Qty. to Assign" +
              TempItemChargeAssgntSales2."Qty. to Assign";

            if ItemChargeAssgntSales.FindLast then
                LastLineNo := ItemChargeAssgntSales."Line No.";

            if SalesOrderLine.Quantity < TotalToAssign then
                repeat
                    TotalToAssign := TotalToAssign - ItemChargeAssgntSales."Qty. to Assign";
                    ItemChargeAssgntSales."Qty. to Assign" := 0;
                    ItemChargeAssgntSales."Amount to Assign" := 0;
                    ItemChargeAssgntSales.Modify;
                until (ItemChargeAssgntSales.Next(-1) = 0) or
                      (TotalToAssign = SalesOrderLine.Quantity);

            InsertAssocOrderCharge(
              SalesOrderLine,
              ApplToDocType,
              ApplToDocNo,
              ApplToDocLineNo,
              LastLineNo,
              TempItemChargeAssgntSales."Applies-to Doc. Line Amount");
        end;
    end;

    local procedure InsertAssocOrderCharge(SalesOrderLine: Record "Sales Line"; ApplToDocType: Option; ApplToDocNo: Code[20]; ApplToDocLineNo: Integer; LastLineNo: Integer; ApplToDocLineAmt: Decimal)
    var
        NewItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
    begin
        NewItemChargeAssgntSales.Init;
        NewItemChargeAssgntSales."Document Type" := SalesOrderLine."Document Type";
        NewItemChargeAssgntSales."Document No." := SalesOrderLine."Document No.";
        NewItemChargeAssgntSales."Document Line No." := SalesOrderLine."Line No.";
        NewItemChargeAssgntSales."Line No." := LastLineNo + 10000;
        NewItemChargeAssgntSales."Item Charge No." := TempItemChargeAssgntSales."Item Charge No.";
        NewItemChargeAssgntSales."Item No." := TempItemChargeAssgntSales."Item No.";
        NewItemChargeAssgntSales."Qty. Assigned" := TempItemChargeAssgntSales."Qty. to Assign";
        NewItemChargeAssgntSales."Qty. to Assign" := 0;
        NewItemChargeAssgntSales."Amount to Assign" := 0;
        NewItemChargeAssgntSales.Description := TempItemChargeAssgntSales.Description;
        NewItemChargeAssgntSales."Unit Cost" := TempItemChargeAssgntSales."Unit Cost";
        NewItemChargeAssgntSales."Applies-to Doc. Type" := "Sales Applies-to Document Type".FromInteger(ApplToDocType);
        NewItemChargeAssgntSales."Applies-to Doc. No." := ApplToDocNo;
        NewItemChargeAssgntSales."Applies-to Doc. Line No." := ApplToDocLineNo;
        NewItemChargeAssgntSales."Applies-to Doc. Line Amount" := ApplToDocLineAmt;
        NewItemChargeAssgntSales.Insert;
    end;

    local procedure CopyAndCheckItemCharge(SalesHeader: Record "Sales Header")
    var
        SalesLine2: Record "Sales Line";
        SalesLine3: Record "Sales Line";
        InvoiceEverything: Boolean;
        AssignError: Boolean;
        QtyNeeded: Decimal;
    begin
        TempItemChargeAssgntSales.Reset;
        TempItemChargeAssgntSales.DeleteAll;

        // Check for max qty posting
        SalesLine2.Reset;
        SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine2.SetRange("Document No.", SalesHeader."No.");
        SalesLine2.SetRange(Type, SalesLine2.Type::"Charge (Item)");
        if SalesLine2.IsEmpty then
            exit;

        SalesLine2.FindSet;
        repeat
            ItemChargeAssgntSales.Reset;
            ItemChargeAssgntSales.SetRange("Document Type", SalesLine2."Document Type");
            ItemChargeAssgntSales.SetRange("Document No.", SalesLine2."Document No.");
            ItemChargeAssgntSales.SetRange("Document Line No.", SalesLine2."Line No.");
            ItemChargeAssgntSales.SetFilter("Qty. to Assign", '<>0');
            if ItemChargeAssgntSales.FindSet then
                repeat
                    TempItemChargeAssgntSales.Init;
                    TempItemChargeAssgntSales := ItemChargeAssgntSales;
                    TempItemChargeAssgntSales.Insert;
                until ItemChargeAssgntSales.Next = 0;

            if SalesLine2."Qty. to Invoice" <> 0 then begin
                SalesLine.TestField("Job No.", '');
                SalesLine2.TestField("Job Contract Entry No.", 0);
                if (SalesLine2."Qty. to Ship" + SalesLine2."Return Qty. to Receive" <> 0) and
                   ((SalesHeader.Ship or SalesHeader.Receive) or
                    (Abs(SalesLine2."Qty. to Invoice") >
                     Abs(SalesLine2."Qty. Shipped Not Invoiced" + SalesLine2."Qty. to Ship") +
                     Abs(SalesLine2."Ret. Qty. Rcd. Not Invd.(Base)" + SalesLine2."Return Qty. to Receive")))
                then
                    SalesLine2.TestField("Line Amount");

                if not SalesHeader.Ship then
                    SalesLine2."Qty. to Ship" := 0;
                if not SalesHeader.Receive then
                    SalesLine2."Return Qty. to Receive" := 0;
                if Abs(SalesLine2."Qty. to Invoice") >
                   Abs(SalesLine2."Quantity Shipped" + SalesLine2."Qty. to Ship" +
                     SalesLine2."Return Qty. Received" + SalesLine2."Return Qty. to Receive" -
                     SalesLine2."Quantity Invoiced")
                then
                    SalesLine2."Qty. to Invoice" :=
                      SalesLine2."Quantity Shipped" + SalesLine2."Qty. to Ship" +
                      SalesLine2."Return Qty. Received" + SalesLine2."Return Qty. to Receive" -
                      SalesLine2."Quantity Invoiced";

                SalesLine2.CalcFields("Qty. to Assign", "Qty. Assigned");
                if Abs(SalesLine2."Qty. to Assign" + SalesLine2."Qty. Assigned") >
                   Abs(SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced")
                then
                    Error(Text032,
                      SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced" -
                      SalesLine2."Qty. Assigned", SalesLine2.FieldCaption("Document Type"),
                      SalesLine2."Document Type", SalesLine2.FieldCaption("Document No."),
                      SalesLine2."Document No.", SalesLine2.FieldCaption("Line No."),
                      SalesLine2."Line No.");
                if SalesLine2.Quantity =
                   SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced"
                then begin
                    if SalesLine2."Qty. to Assign" <> 0 then begin
                        if SalesLine2.Quantity = SalesLine2."Quantity Invoiced" then begin
                            TempItemChargeAssgntSales.SetRange("Document Line No.", SalesLine2."Line No.");
                            TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type", SalesLine2."Document Type");
                            if TempItemChargeAssgntSales.FindSet then
                                repeat
                                    SalesLine3.Get(
                                      TempItemChargeAssgntSales."Applies-to Doc. Type",
                                      TempItemChargeAssgntSales."Applies-to Doc. No.",
                                      TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                                    if SalesLine3.Quantity = SalesLine3."Quantity Invoiced" then
                                        Error(Text034, SalesLine3.TableCaption,
                                          SalesLine3.FieldCaption("Document Type"), SalesLine3."Document Type",
                                          SalesLine3.FieldCaption("Document No."), SalesLine3."Document No.",
                                          SalesLine3.FieldCaption("Line No."), SalesLine3."Line No.");
                                until TempItemChargeAssgntSales.Next = 0;
                        end;
                    end;
                    if SalesLine2.Quantity <> SalesLine2."Qty. to Assign" + SalesLine2."Qty. Assigned" then
                        AssignError := true;
                end;

                if (SalesLine2."Qty. to Assign" + SalesLine2."Qty. Assigned") <
                   (SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced")
                then
                    Error(Text052, SalesLine2."No.");

                // check if all ILEs exist
                QtyNeeded := SalesLine2."Qty. to Assign";
                TempItemChargeAssgntSales.SetRange("Document Line No.", SalesLine2."Line No.");
                if TempItemChargeAssgntSales.FindSet then
                    repeat
                        if (TempItemChargeAssgntSales."Applies-to Doc. Type" <> SalesLine2."Document Type") or
                           (TempItemChargeAssgntSales."Applies-to Doc. No." <> SalesLine2."Document No.")
                        then
                            QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign"
                        else begin
                            SalesLine3.Get(
                              TempItemChargeAssgntSales."Applies-to Doc. Type",
                              TempItemChargeAssgntSales."Applies-to Doc. No.",
                              TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                            if ItemLedgerEntryExist(SalesLine3) then
                                QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign";
                        end;
                    until TempItemChargeAssgntSales.Next = 0;

                if QtyNeeded > 0 then
                    Error(Text053, SalesLine2."No.");
            end;
        until SalesLine2.Next = 0;

        // Check saleslines
        if AssignError then
            if SalesHeader."Document Type" in
               [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"]
            then
                InvoiceEverything := true
            else begin
                SalesLine2.Reset;
                SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine2.SetRange("Document No.", SalesHeader."No.");
                SalesLine2.SetFilter(Type, '%1|%2', SalesLine2.Type::Item, SalesLine2.Type::"Charge (Item)");
                if SalesLine2.FindSet then
                    repeat
                        if SalesHeader.Ship or SalesHeader.Receive then
                            InvoiceEverything :=
                              SalesLine2.Quantity = SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced"
                        else
                            InvoiceEverything :=
                              (SalesLine2.Quantity = SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced") and
                              (SalesLine2."Qty. to Invoice" =
                               SalesLine2."Qty. Shipped Not Invoiced" + SalesLine2."Ret. Qty. Rcd. Not Invd.(Base)");
                    until (SalesLine2.Next = 0) or (not InvoiceEverything);
            end;

        if InvoiceEverything and AssignError then
            Error(Text033);
    end;

    local procedure ClearItemChargeAssgntFilter()
    begin
        TempItemChargeAssgntSales.SetRange("Document Line No.");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. No.");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.");
        TempItemChargeAssgntSales.MarkedOnly(false);
    end;

    local procedure GetItemChargeLine(var ItemChargeSalesLine: Record "Sales Line")
    var
        SalesShptLine: Record "Sales Shipment Line";
        ReturnReceiptLine: Record "Return Receipt Line";
        QtyShippedNotInvd: Decimal;
        QtyReceivedNotInvd: Decimal;
    begin
        if (ItemChargeSalesLine."Document Type" <> TempItemChargeAssgntSales."Document Type") or
            (ItemChargeSalesLine."Document No." <> TempItemChargeAssgntSales."Document No.") or
            (ItemChargeSalesLine."Line No." <> TempItemChargeAssgntSales."Document Line No.")
        then begin
            ItemChargeSalesLine.Get(TempItemChargeAssgntSales."Document Type", TempItemChargeAssgntSales."Document No.", TempItemChargeAssgntSales."Document Line No.");
            if not SalesHeader.Ship then
                ItemChargeSalesLine."Qty. to Ship" := 0;
            if not SalesHeader.Receive then
                ItemChargeSalesLine."Return Qty. to Receive" := 0;
            if ItemChargeSalesLine."Shipment No." <> '' then begin
                SalesShptLine.Get(ItemChargeSalesLine."Shipment No.", ItemChargeSalesLine."Shipment Line No.");
                QtyShippedNotInvd := TempItemChargeAssgntSales."Qty. to Assign" - TempItemChargeAssgntSales."Qty. Assigned";
            end else
                QtyShippedNotInvd := ItemChargeSalesLine."Quantity Shipped";
            if ItemChargeSalesLine."Return Receipt No." <> '' then begin
                ReturnReceiptLine.Get(ItemChargeSalesLine."Return Receipt No.", ItemChargeSalesLine."Return Receipt Line No.");
                QtyReceivedNotInvd := TempItemChargeAssgntSales."Qty. to Assign" - TempItemChargeAssgntSales."Qty. Assigned";
            end else
                QtyReceivedNotInvd := ItemChargeSalesLine."Return Qty. Received";
            if Abs(ItemChargeSalesLine."Qty. to Invoice") >
                Abs(QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
                  QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
                  ItemChargeSalesLine."Quantity Invoiced")
            then
                ItemChargeSalesLine."Qty. to Invoice" :=
                  QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
                  QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
                  ItemChargeSalesLine."Quantity Invoiced";
        end;
    end;

    local procedure OnlyAssgntPosting(): Boolean
    var
        SalesLine: Record "Sales Line";
        QtyLeftToAssign: Boolean;
    begin
        ItemChargeAssgntOnly := false;
        QtyLeftToAssign := false;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::"Charge (Item)");
        if SalesLine.FindSet then
            repeat
                SalesLine.CalcFields("Qty. Assigned");
                if SalesLine."Quantity Invoiced" > SalesLine."Qty. Assigned" then
                    QtyLeftToAssign := true;
            until SalesLine.Next = 0;

        if QtyLeftToAssign then
            CopyAndCheckItemCharge(SalesHeader);
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntSales.SetCurrentKey("Applies-to Doc. Type");
        TempItemChargeAssgntSales.SetFilter("Applies-to Doc. Type", '<>%1', SalesHeader."Document Type");
        SalesLine.SetRange(Type);
        SalesLine.SetRange("Quantity Invoiced");
        SalesLine.SetFilter("Qty. to Assign", '<>0');
        if SalesLine.FindSet then
            repeat
                TempItemChargeAssgntSales.SetRange("Document Line No.", SalesLine."Line No.");
                ItemChargeAssgntOnly := not TempItemChargeAssgntSales.IsEmpty;
            until (SalesLine.Next = 0) or ItemChargeAssgntOnly
        else
            ItemChargeAssgntOnly := false;
        exit(ItemChargeAssgntOnly);
    end;


    procedure CalcQtyToInvoice(QtyToHandle: Decimal; QtyToInvoice: Decimal): Decimal
    begin
        if Abs(QtyToHandle) > Abs(QtyToInvoice) then
            exit(-QtyToHandle);

        exit(-QtyToInvoice);
    end;


    procedure GetShippingAdvice(): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Drop Shipment", false);
        SalesLine.SetFilter("Qty. to Ship", '<>%1', 0);
        if SalesLine.FindSet then
            repeat
                if SalesLine.IsShipment then begin
                    if SalesLine."Document Type" in
                       [SalesLine."Document Type"::"Credit Memo",
                        SalesLine."Document Type"::"Return Order"]
                    then begin
                        if SalesLine."Quantity (Base)" <>
                           SalesLine."Return Qty. to Receive (Base)" + SalesLine."Return Qty. Received (Base)"
                        then
                            exit(false)
                    end else
                        if SalesLine."Quantity (Base)" <>
                           SalesLine."Qty. to Ship (Base)" + SalesLine."Qty. Shipped (Base)"
                        then
                            exit(false);
                end;
            until SalesLine.Next = 0;
        exit(true);
    end;

    local procedure CheckWarehouse(var SalesLine: Record "Sales Line")
    var
        SalesLine2: Record "Sales Line";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        ShowError: Boolean;
    begin
        SalesLine2.Copy(SalesLine);
        SalesLine2.SetRange(Type, SalesLine2.Type::Item);
        SalesLine2.SetRange("Drop Shipment", false);
        if SalesLine2.FindSet then
            repeat
                GetLocation(SalesLine2."Location Code");
                case SalesLine2."Document Type" of
                    SalesLine2."Document Type"::Order:
                        if ((Location."Require Receive" or Location."Require Put-away") and
                            (SalesLine2.Quantity < 0)) or
                           ((Location."Require Shipment" or Location."Require Pick") and
                            (SalesLine2.Quantity >= 0))
                        then begin
                            if Location."Directed Put-away and Pick" then
                                ShowError := true
                            else
                                if WhseValidateSourceLine.WhseLinesExist(
                                     DATABASE::"Sales Line",
                                     SalesLine2."Document Type".AsInteger(),
                                     SalesLine2."Document No.",
                                     SalesLine2."Line No.",
                                     0,
                                     SalesLine2.Quantity)
                                then
                                    ShowError := true;
                        end;
                    SalesLine2."Document Type"::"Return Order":
                        if ((Location."Require Receive" or Location."Require Put-away") and
                            (SalesLine2.Quantity >= 0)) or
                           ((Location."Require Shipment" or Location."Require Pick") and
                            (SalesLine2.Quantity < 0))
                        then begin
                            if Location."Directed Put-away and Pick" then
                                ShowError := true
                            else
                                if WhseValidateSourceLine.WhseLinesExist(
                                     DATABASE::"Sales Line",
                                     SalesLine2."Document Type".AsInteger(),
                                     SalesLine2."Document No.",
                                     SalesLine2."Line No.",
                                     0,
                                     SalesLine2.Quantity)
                                then
                                    ShowError := true;
                        end;
                    SalesLine2."Document Type"::Invoice, SalesLine2."Document Type"::"Credit Memo":
                        if Location."Directed Put-away and Pick" then
                            Location.TestField("Adjustment Bin Code");
                end;
                if ShowError then
                    Error(
                      Text021,
                      SalesLine2.FieldCaption("Document Type"),
                      SalesLine2."Document Type",
                      SalesLine2.FieldCaption("Document No."),
                      SalesLine2."Document No.",
                      SalesLine2.FieldCaption("Line No."),
                      SalesLine2."Line No.");
            until SalesLine2.Next = 0;
    end;

    local procedure CreateWhseJnlLine(ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; var TempWhseJnlLine: Record "Warehouse Journal Line" temporary)
    var
        WhseMgt: Codeunit "Whse. Management";
    begin
        WMSMgmt.CheckAdjmtBin(Location, ItemJnlLine.Quantity, true);
        WMSMgmt.CreateWhseJnlLine(ItemJnlLine, 0, TempWhseJnlLine, false);
        TempWhseJnlLine."Source Type" := DATABASE::"Sales Line";
        TempWhseJnlLine."Source Subtype" := SalesLine."Document Type".AsInteger();
        TempWhseJnlLine."Source Code" := SrcCode;
        TempWhseJnlLine."Source Document" := "Warehouse Journal Source Document".FromInteger(WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type", TempWhseJnlLine."Source Subtype"));
        TempWhseJnlLine."Source No." := SalesLine."Document No.";
        TempWhseJnlLine."Source Line No." := SalesLine."Line No.";
        case SalesLine."Document Type" of
            SalesLine."Document Type"::Order:
                TempWhseJnlLine."Reference Document" :=
                  TempWhseJnlLine."Reference Document"::"Posted Shipment";
            SalesLine."Document Type"::Invoice:
                TempWhseJnlLine."Reference Document" :=
                  TempWhseJnlLine."Reference Document"::"Posted S. Inv.";
            SalesLine."Document Type"::"Credit Memo":
                TempWhseJnlLine."Reference Document" :=
                  TempWhseJnlLine."Reference Document"::"Posted S. Cr. Memo";
            SalesLine."Document Type"::"Return Order":
                TempWhseJnlLine."Reference Document" :=
                  TempWhseJnlLine."Reference Document"::"Posted Rtrn. Shipment";
        end;
        TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
    end;

    local procedure WhseHandlingRequired(): Boolean
    var
        WhseSetup: Record "Warehouse Setup";
    begin
        if (SalesLine.Type = SalesLine.Type::Item) and
           (not SalesLine."Drop Shipment")
        then begin
            if SalesLine."Location Code" = '' then begin
                WhseSetup.Get;
                if SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" then
                    exit(WhseSetup."Require Receive");

                exit(WhseSetup."Require Shipment");
            end;

            GetLocation(SalesLine."Location Code");
            if SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" then
                exit(Location."Require Receive");

            exit(Location."Require Shipment");

        end;
        exit(false);
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.GetLocationSetup(LocationCode, Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    local procedure InsertShptEntryRelation(var SalesShptLine: Record "Sales Shipment Line"): Integer
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        TempTrackingSpecificationInv.Reset;
        if TempTrackingSpecificationInv.FindSet then begin
            repeat
                TempHandlingSpecification := TempTrackingSpecificationInv;
                if TempHandlingSpecification.Insert then;
            until TempTrackingSpecificationInv.Next = 0;
            TempTrackingSpecificationInv.DeleteAll;
        end;

        TempHandlingSpecification.Reset;
        if TempHandlingSpecification.FindSet then begin
            repeat
                ItemEntryRelation.Init;
                ItemEntryRelation."Item Entry No." := TempHandlingSpecification."Entry No.";
                ItemEntryRelation."Serial No." := TempHandlingSpecification."Serial No.";
                ItemEntryRelation."Lot No." := TempHandlingSpecification."Lot No.";
                ItemEntryRelation.TransferFieldsSalesShptLine(SalesShptLine);
                ItemEntryRelation.Insert;
            until TempHandlingSpecification.Next = 0;
            TempHandlingSpecification.DeleteAll;
            exit(0);
        end;
        exit(ItemLedgShptEntryNo);
    end;

    local procedure InsertReturnEntryRelation(var ReturnRcptLine: Record "Return Receipt Line"): Integer
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        TempTrackingSpecificationInv.Reset;
        if TempTrackingSpecificationInv.FindSet then begin
            repeat
                TempHandlingSpecification := TempTrackingSpecificationInv;
                if TempHandlingSpecification.Insert then;
            until TempTrackingSpecificationInv.Next = 0;
            TempTrackingSpecificationInv.DeleteAll;
        end;

        TempHandlingSpecification.Reset;
        if TempHandlingSpecification.FindSet then begin
            repeat
                ItemEntryRelation.Init;
                ItemEntryRelation."Item Entry No." := TempHandlingSpecification."Entry No.";
                ItemEntryRelation."Serial No." := TempHandlingSpecification."Serial No.";
                ItemEntryRelation."Lot No." := TempHandlingSpecification."Lot No.";
                ItemEntryRelation.TransferFieldsReturnRcptLine(ReturnRcptLine);
                ItemEntryRelation.Insert;
            until TempHandlingSpecification.Next = 0;
            TempHandlingSpecification.DeleteAll;
            exit(0);
        end;
        exit(ItemLedgShptEntryNo);
    end;

    local procedure GetTrackingQuantities(SalesLine: Record "Sales Line"; FunctionType: Option CheckTrackingExists,GetQty; var TrackingQtyToHandle: Decimal; var TrackingQtyHandled: Decimal): Boolean
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
    begin
        TrackingSpecification.SetCurrentKey("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
          "Source Prod. Order Line", "Source Ref. No.");
        TrackingSpecification.SetRange("Source Type", DATABASE::"Sales Line");
        TrackingSpecification.SetRange("Source Subtype", SalesLine."Document Type");
        TrackingSpecification.SetRange("Source ID", SalesLine."Document No.");
        TrackingSpecification.SetRange("Source Batch Name", '');
        TrackingSpecification.SetRange("Source Prod. Order Line", 0);
        TrackingSpecification.SetRange("Source Ref. No.", SalesLine."Line No.");

        ReservEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line");
        ReservEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservEntry.SetRange("Source Subtype", SalesLine."Document Type");
        ReservEntry.SetRange("Source Batch Name", '');
        ReservEntry.SetRange("Source Prod. Order Line", 0);

        case FunctionType of
            FunctionType::CheckTrackingExists:
                begin
                    TrackingSpecification.SetRange(Correction, false);
                    if not TrackingSpecification.IsEmpty then
                        exit(true);
                    ReservEntry.SetFilter("Serial No.", '<>%1', '');
                    if not ReservEntry.IsEmpty then
                        exit(true);
                    ReservEntry.SetRange("Serial No.");
                    ReservEntry.SetFilter("Lot No.", '<>%1', '');
                    if not ReservEntry.IsEmpty then
                        exit(true);
                end;
            FunctionType::GetQty:
                begin
                    TrackingSpecification.CalcSums("Quantity Handled (Base)");
                    TrackingQtyHandled := TrackingSpecification."Quantity Handled (Base)";
                    if ReservEntry.FindSet then
                        repeat
                            if (ReservEntry."Lot No." <> '') or (ReservEntry."Serial No." <> '') then
                                TrackingQtyToHandle := TrackingQtyToHandle + ReservEntry."Qty. to Handle (Base)";
                        until ReservEntry.Next = 0;
                end;
        end;
    end;

    local procedure SaveInvoiceSpecification(var TempInvoicingSpecification: Record "Tracking Specification" temporary)
    begin
        TempInvoicingSpecification.Reset;
        if TempInvoicingSpecification.FindSet then begin
            repeat
                TempInvoicingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
                TempTrackingSpecification := TempInvoicingSpecification;
                TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."Buffer Status"::MODIFY;
                if not TempTrackingSpecification.Insert then begin
                    TempTrackingSpecification.Get(TempInvoicingSpecification."Entry No.");
                    TempTrackingSpecification."Qty. to Invoice (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
                    if TempInvoicingSpecification."Qty. to Invoice (Base)" = TempInvoicingSpecification."Quantity Invoiced (Base)" then
                        TempTrackingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Quantity Invoiced (Base)"
                    else
                        TempTrackingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
                    TempTrackingSpecification."Qty. to Invoice" += TempInvoicingSpecification."Qty. to Invoice";
                    TempTrackingSpecification.Modify;
                end;
            until TempInvoicingSpecification.Next = 0;
            TempInvoicingSpecification.DeleteAll;
        end;
    end;

    local procedure InsertTrackingSpecification()
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TempTrackingSpecification.Reset;
        if TempTrackingSpecification.FindSet then begin
            repeat
                TrackingSpecification := TempTrackingSpecification;
                TrackingSpecification."Buffer Status" := 0;
                TrackingSpecification.Correction := false;
                TrackingSpecification.InitQtyToShip;
                TrackingSpecification."Quantity actual Handled (Base)" := 0;
                if TempTrackingSpecification."Buffer Status" = TempTrackingSpecification."Buffer Status"::MODIFY then
                    TrackingSpecification.Modify
                else
                    TrackingSpecification.Insert;
            until TempTrackingSpecification.Next = 0;
            TempTrackingSpecification.DeleteAll;
        end;

        ReserveSalesLine.UpdateItemTrackingAfterPosting(SalesHeader);
    end;

    local procedure InsertValueEntryRelation()
    var
        ValueEntryRelation: Record "Value Entry Relation";
    begin
        TempValueEntryRelation.Reset;
        if TempValueEntryRelation.FindSet then begin
            repeat
                ValueEntryRelation := TempValueEntryRelation;
                ValueEntryRelation.Insert;
            until TempValueEntryRelation.Next = 0;
            TempValueEntryRelation.DeleteAll;
        end;
    end;


    procedure PostItemCharge(var SalesLine: Record "Sales Line"; ItemEntryNo: Integer; QuantityBase: Decimal; AmountToAssign: Decimal; QtyToAssign: Decimal)
    var
        DummyTrackingSpecification: Record "Tracking Specification";
        SalesLineToPost: Record "Sales Line";
    begin
        SalesLineToPost := SalesLine;
        SalesLineToPost."No." := TempItemChargeAssgntSales."Item No.";
        SalesLineToPost."Appl.-to Item Entry" := ItemEntryNo;
        if not (TempItemChargeAssgntSales."Document Type" in [TempItemChargeAssgntSales."Document Type"::"Return Order", TempItemChargeAssgntSales."Document Type"::"Credit Memo"]) then
            SalesLineToPost.Amount := -AmountToAssign
        else
            SalesLineToPost.Amount := AmountToAssign;

        if SalesLineToPost."Currency Code" <> '' then
            SalesLineToPost."Unit Cost" := Round(
                -SalesLineToPost.Amount / QuantityBase, Currency."Unit-Amount Rounding Precision")
        else
            SalesLineToPost."Unit Cost" := Round(
                -SalesLineToPost.Amount / QuantityBase, GLSetup."Unit-Amount Rounding Precision");
        TotalChargeAmt := TotalChargeAmt + SalesLineToPost.Amount;

        if SalesHeader."Currency Code" <> '' then
            SalesLineToPost.Amount :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate, SalesHeader."Currency Code", TotalChargeAmt, SalesHeader."Currency Factor");
        SalesLineToPost."Inv. Discount Amount" := Round(
            SalesLine."Inv. Discount Amount" / SalesLine.Quantity * QtyToAssign,
            GLSetup."Amount Rounding Precision");
        SalesLineToPost."Line Discount Amount" := Round(
            SalesLine."Line Discount Amount" / SalesLine.Quantity * QtyToAssign,
            GLSetup."Amount Rounding Precision");
        SalesLineToPost."Line Amount" := Round(
            SalesLine."Line Amount" / SalesLine.Quantity * QtyToAssign,
            GLSetup."Amount Rounding Precision");
        SalesLine."Inv. Discount Amount" := SalesLine."Inv. Discount Amount" - SalesLineToPost."Inv. Discount Amount";
        SalesLine."Line Discount Amount" := SalesLine."Line Discount Amount" - SalesLineToPost."Line Discount Amount";
        SalesLine."Line Amount" := SalesLine."Line Amount" - SalesLineToPost."Line Amount";
        SalesLine.Quantity := SalesLine.Quantity - QtyToAssign;
        SalesLineToPost.Amount := Round(SalesLineToPost.Amount, GLSetup."Amount Rounding Precision") - TotalChargeAmtLCY;
        if SalesHeader."Currency Code" <> '' then
            TotalChargeAmtLCY := TotalChargeAmtLCY + SalesLineToPost.Amount;
        SalesLineToPost."Unit Cost (LCY)" := Round(
            SalesLineToPost.Amount / QuantityBase, GLSetup."Unit-Amount Rounding Precision");
        SalesLineToPost."Line No." := TempItemChargeAssgntSales."Document Line No.";
        PostItemJnlLine(
          SalesLineToPost,
          0, 0, -QuantityBase, -QuantityBase,
          SalesLineToPost."Appl.-to Item Entry",
          TempItemChargeAssgntSales."Item Charge No.", DummyTrackingSpecification, false);
    end;

    local procedure SaveTempWhseSplitSpec(var SalesLine3: Record "Sales Line")
    begin
        TempWhseSplitSpecification.Reset;
        TempWhseSplitSpecification.DeleteAll;
        if TempHandlingSpecification.FindSet then
            repeat
                TempWhseSplitSpecification := TempHandlingSpecification;
                TempWhseSplitSpecification."Source Type" := DATABASE::"Sales Line";
                TempWhseSplitSpecification."Source Subtype" := SalesLine3."Document Type".AsInteger();
                TempWhseSplitSpecification."Source ID" := SalesLine3."Document No.";
                TempWhseSplitSpecification."Source Ref. No." := SalesLine3."Line No.";
                TempWhseSplitSpecification.Insert;
            until TempHandlingSpecification.Next = 0;
    end;


    procedure TransferReservToItemJnlLine(var SalesOrderLine: Record "Sales Line"; var ItemJnlLine: Record "Item Journal Line"; QtyToBeShippedBase: Decimal; var TempTrackingSpecification2: Record "Tracking Specification" temporary; var CheckApplFromItemEntry: Boolean)
    begin
        // Handle Item Tracking and reservations, also on drop shipment
        if QtyToBeShippedBase = 0 then
            exit;

        Clear(ReserveSalesLine);
        if not SalesOrderLine."Drop Shipment" then
            ReserveSalesLine.TransferSalesLineToItemJnlLine(
              SalesOrderLine, ItemJnlLine, QtyToBeShippedBase, CheckApplFromItemEntry, true)
        else begin
            TempTrackingSpecification2.Reset;
            TempTrackingSpecification2.SetRange("Source Type", DATABASE::"Purchase Line");
            TempTrackingSpecification2.SetRange("Source Subtype", 1);
            TempTrackingSpecification2.SetRange("Source ID", SalesOrderLine."Purchase Order No.");
            TempTrackingSpecification2.SetRange("Source Batch Name", '');
            TempTrackingSpecification2.SetRange("Source Prod. Order Line", 0);
            TempTrackingSpecification2.SetRange("Source Ref. No.", SalesOrderLine."Purch. Order Line No.");
            if TempTrackingSpecification2.IsEmpty then
                ReserveSalesLine.TransferSalesLineToItemJnlLine(
                  SalesOrderLine, ItemJnlLine, QtyToBeShippedBase, CheckApplFromItemEntry, false)
            else begin
                ReserveSalesLine.SetApplySpecificItemTracking(true);
                ReserveSalesLine.SetOverruleItemTracking(true);
                ReserveSalesLine.SetItemTrkgAlreadyOverruled(ItemTrkgAlreadyOverruled);
                TempTrackingSpecification2.FindSet;
                if TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 then
                    Error(Text043);
                repeat
                    ItemJnlLine."Serial No." := TempTrackingSpecification2."Serial No.";
                    ItemJnlLine."Lot No." := TempTrackingSpecification2."Lot No.";
                    ItemJnlLine."Applies-to Entry" := TempTrackingSpecification2."Item Ledger Entry No.";
                    ReserveSalesLine.TransferSalesLineToItemJnlLine(SalesOrderLine, ItemJnlLine,
                      TempTrackingSpecification2."Quantity (Base)", CheckApplFromItemEntry, false);
                until TempTrackingSpecification2.Next = 0;
                ItemJnlLine."Serial No." := '';
                ItemJnlLine."Lot No." := '';
                ItemJnlLine."Applies-to Entry" := 0;
            end;
        end;
    end;


    procedure TransferReservFromPurchLine(var PurchOrderLine: Record "Purchase Line"; var ItemJnlLine: Record "Item Journal Line"; QtyToBeShippedBase: Decimal)
    var
        ReservEntry: Record "Reservation Entry";
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        RemainingQuantity: Decimal;
        CheckApplToItemEntry: Boolean;
    begin
        // Handle Item Tracking on Drop Shipment
        ItemTrkgAlreadyOverruled := false;
        if QtyToBeShippedBase = 0 then
            exit;

        ReservEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line");
        ReservEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservEntry.SetRange("Source Subtype", SalesLine."Document Type");
        ReservEntry.SetRange("Source Batch Name", '');
        ReservEntry.SetRange("Source Prod. Order Line", 0);
        ReservEntry.SetFilter("Qty. to Handle (Base)", '<>0');
        if not ReservEntry.IsEmpty then
            ItemTrackingMgt.SumUpItemTracking(ReservEntry, TempTrackingSpecification2, false, true);
        TempTrackingSpecification2.SetFilter("Qty. to Handle (Base)", '<>0');
        if TempTrackingSpecification2.IsEmpty then
            ReservePurchLine.TransferPurchLineToItemJnlLine(
              PurchOrderLine, ItemJnlLine, QtyToBeShippedBase, CheckApplToItemEntry)
        else begin
            ReservePurchLine.SetOverruleItemTracking(true);
            ItemTrkgAlreadyOverruled := true;
            TempTrackingSpecification2.FindSet;
            if -TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 then
                Error(Text043);
            repeat
                ItemJnlLine."Serial No." := TempTrackingSpecification2."Serial No.";
                ItemJnlLine."Lot No." := TempTrackingSpecification2."Lot No.";
                RemainingQuantity :=
                  ReservePurchLine.TransferPurchLineToItemJnlLine(
                    PurchOrderLine, ItemJnlLine,
                    -TempTrackingSpecification2."Qty. to Handle (Base)", CheckApplToItemEntry);
                if RemainingQuantity <> 0 then
                    Error(Text044);
            until TempTrackingSpecification2.Next = 0;
            ItemJnlLine."Serial No." := '';
            ItemJnlLine."Lot No." := '';
            ItemJnlLine."Applies-to Entry" := 0;
        end;
    end;


    procedure SetWhseRcptHeader(var WhseRcptHeader2: Record "Warehouse Receipt Header")
    begin
        WhseRcptHeader := WhseRcptHeader2;
        TempWhseRcptHeader := WhseRcptHeader;
        TempWhseRcptHeader.Insert;
    end;


    procedure SetWhseShptHeader(var WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        WhseShptHeader := WhseShptHeader2;
        TempWhseShptHeader := WhseShptHeader;
        TempWhseShptHeader.Insert;
    end;

    local procedure CopyPurchCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        PurchCommentLine: Record "Purch. Comment Line";
        PurchCommentLine2: Record "Purch. Comment Line";
    begin
        PurchCommentLine.SetRange("Document Type", FromDocumentType);
        PurchCommentLine.SetRange("No.", FromNumber);
        if PurchCommentLine.FindSet then
            repeat
                PurchCommentLine2 := PurchCommentLine;
                PurchCommentLine2."Document Type" := "Purchase Comment Document Type".FromInteger(ToDocumentType);
                PurchCommentLine2."No." := ToNumber;
                PurchCommentLine2.Insert;
            until PurchCommentLine.Next = 0;
    end;

    local procedure GetItem(SalesLine: Record "Sales Line")
    begin
        SalesLine.TestField(Type, SalesLine.Type::Item);
        SalesLine.TestField("No.");
        if SalesLine."No." <> Item."No." then
            Item.Get(SalesLine."No.");
    end;

    local procedure GetNextSalesline(var SalesLine: Record "Sales Line"): Boolean
    begin
        if not SalesLinesProcessed then
            if SalesLine.Next = 1 then
                exit(false);
        SalesLinesProcessed := true;
        if TempPrepaymentSalesLine.Find('-') then begin
            SalesLine := TempPrepaymentSalesLine;
            TempPrepaymentSalesLine.Delete;
            exit(false);
        end;
        exit(true);
    end;


    procedure CreatePrepaymentLines(SalesHeader: Record "Sales Header"; var TempPrepmtSalesLine: Record "Sales Line"; CompleteFunctionality: Boolean)
    var
        GLAcc: Record "G/L Account";
        SalesLine: Record "Sales Line";
        TempExtTextLine: Record "Extended Text Line" temporary;
        TransferExtText: Codeunit "Transfer Extended Text";
        NextLineNo: Integer;
        Fraction: Decimal;
        VATDifference: Decimal;
        TempLineFound: Boolean;
        PrePmtTestRun: Boolean;
        PrepmtAmtToDeduct: Decimal;
    begin
        GetGLSetup;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if not SalesLine.Find('+') then
            exit;
        NextLineNo := SalesLine."Line No." + 10000;
        SalesLine.SetFilter(Quantity, '>0');
        SalesLine.SetFilter("Qty. to Invoice", '>0');
        TempPrepmtSalesLine.SetHasBeenShown;
        if SalesLine.Find('-') then
            repeat
                if CompleteFunctionality then begin
                    if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then begin
                        if not SalesHeader.Ship and (SalesLine."Qty. to Invoice" = SalesLine.Quantity - SalesLine."Quantity Invoiced") then
                            if SalesLine."Qty. Shipped Not Invoiced" < SalesLine."Qty. to Invoice" then
                                SalesLine.Validate("Qty. to Invoice", SalesLine."Qty. Shipped Not Invoiced");
                        Fraction := (SalesLine."Qty. to Invoice" + SalesLine."Quantity Invoiced") / SalesLine.Quantity;

                        if SalesLine."Prepayment %" <> 100 then
                            case true of
                                (SalesLine."Prepmt Amt to Deduct" <> 0) and
                              (SalesLine."Prepmt Amt to Deduct" > Round(Fraction * SalesLine."Line Amount", Currency."Amount Rounding Precision")):
                                    SalesLine.FieldError(
                                      SalesLine."Prepmt Amt to Deduct",
                                      StrSubstNo(Text047,
                                        Round(Fraction * SalesLine."Line Amount", Currency."Amount Rounding Precision")));
                                (SalesLine."Prepmt. Amt. Inv." <> 0) and
                              (Round((1 - Fraction) * SalesLine."Line Amount", Currency."Amount Rounding Precision") <
                                Round(
                                  Round(
                                    Round(SalesLine."Unit Price" * (SalesLine.Quantity - SalesLine."Quantity Invoiced" - SalesLine."Qty. to Invoice"), Currency."Amount Rounding Precision") *
                                    (1 - (SalesLine."Line Discount %" / 100)), Currency."Amount Rounding Precision") *
                                  SalesLine."Prepayment %" / 100, Currency."Amount Rounding Precision")):
                                    SalesLine.FieldError(
                                      SalesLine."Prepmt Amt to Deduct",
                                      StrSubstNo(Text048,
                                        Round(
                                          SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted" - (1 - Fraction) * SalesLine."Line Amount",
                                          Currency."Amount Rounding Precision")));
                            end;
                    end else
                        if not PrePmtTestRun then begin
                            TestGetShipmentPPmtAmtToDeduct(SalesHeader);
                            PrePmtTestRun := true;
                        end;
                end;
                if SalesLine."Prepmt Amt to Deduct" <> 0 then begin
                    if (SalesLine."Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") or
                        (SalesLine."Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                    then begin
                        GenPostingSetup.Get(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group");
                        GenPostingSetup.TestField("Sales Prepayments Account");
                    end;
                    GLAcc.Get(GenPostingSetup."Sales Prepayments Account");
                    TempLineFound := false;
                    if SalesHeader."Compress Prepayment" then begin
                        TempPrepmtSalesLine.SetRange("No.", GLAcc."No.");
                        TempPrepmtSalesLine.SetRange("Dimension Set ID", SalesLine."Dimension Set ID");
                        TempLineFound := TempPrepmtSalesLine.FindFirst;
                    end;
                    if TempLineFound then begin
                        PrepmtAmtToDeduct :=
                          TempPrepmtSalesLine."Prepmt Amt to Deduct" +
                          InsertedPrepmtVATBaseToDeduct(SalesLine, TempPrepmtSalesLine."Line No.", TempPrepmtSalesLine."Unit Price");
                        VATDifference := TempPrepmtSalesLine."VAT Difference";
                        // if SalesHeader."Prepmt. Include Tax" then
                        //     TempPrepmtSalesLine.Validate(
                        //       "Unit Price",
                        //       TempPrepmtSalesLine."Unit Price" + SalesLine."Prepmt Amt to Deduct" * (1 + SalesLine."VAT %" / 100))
                        // else
                        //     TempPrepmtSalesLine.Validate(
                        //       "Unit Price", TempPrepmtSalesLine."Unit Price" + SalesLine."Prepmt Amt to Deduct");
                        // TempPrepmtSalesLine.Validate("VAT Difference", VATDifference - SalesLine."Prepmt VAT Diff. to Deduct");
                        // if SalesHeader."Prepmt. Include Tax" then
                        //     TempPrepmtSalesLine."Prepmt Amt to Deduct" += SalesLine.CalcAmountIncludingTax(SalesLine."Prepmt Amt to Deduct")
                        // else
                        //     TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                        if SalesLine."Prepayment %" < TempPrepmtSalesLine."Prepayment %" then
                            TempPrepmtSalesLine."Prepayment %" := SalesLine."Prepayment %";
                        TempPrepmtSalesLine.Modify;
                    end else begin
                        TempPrepmtSalesLine.Init;
                        TempPrepmtSalesLine."Document Type" := SalesHeader."Document Type";
                        TempPrepmtSalesLine."Document No." := SalesHeader."No.";
                        TempPrepmtSalesLine."Line No." := 0;
                        TempPrepmtSalesLine."System-Created Entry" := true;
                        if CompleteFunctionality then
                            TempPrepmtSalesLine.Validate(Type, TempPrepmtSalesLine.Type::"G/L Account")
                        else
                            TempPrepmtSalesLine.Type := TempPrepmtSalesLine.Type::"G/L Account";
                        TempPrepmtSalesLine.Validate("No.", GenPostingSetup."Sales Prepayments Account");
                        TempPrepmtSalesLine.Validate(Quantity, -1);
                        TempPrepmtSalesLine."Qty. to Ship" := TempPrepmtSalesLine.Quantity;
                        TempPrepmtSalesLine."Qty. to Invoice" := TempPrepmtSalesLine.Quantity;
                        PrepmtAmtToDeduct := InsertedPrepmtVATBaseToDeduct(SalesLine, NextLineNo, 0);
                        // if SalesHeader."Prepmt. Include Tax" then
                        //     TempPrepmtSalesLine.Validate("Unit Price", SalesLine."Prepmt Amt to Deduct" * (1 + SalesLine."VAT %" / 100))
                        // else
                        //     TempPrepmtSalesLine.Validate("Unit Price", SalesLine."Prepmt Amt to Deduct");
                        // TempPrepmtSalesLine.Validate("VAT Difference", -SalesLine."Prepmt VAT Diff. to Deduct");
                        // if SalesHeader."Prepmt. Include Tax" then
                        //     TempPrepmtSalesLine."Prepmt Amt to Deduct" := SalesLine.CalcAmountIncludingTax(SalesLine."Prepmt Amt to Deduct")
                        // else
                        //     TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                        TempPrepmtSalesLine."Prepayment %" := SalesLine."Prepayment %";
                        TempPrepmtSalesLine."Prepayment Line" := true;
                        TempPrepmtSalesLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
                        TempPrepmtSalesLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
                        TempPrepmtSalesLine."Dimension Set ID" := SalesLine."Dimension Set ID";
                        TempPrepmtSalesLine."Line No." := NextLineNo;
                        NextLineNo := NextLineNo + 10000;
                        TempPrepmtSalesLine.Insert;

                        TransferExtText.PrepmtGetAnyExtText(
                          TempPrepmtSalesLine."No.", DATABASE::"Sales Invoice Line",
                          SalesHeader."Document Date", SalesHeader."Language Code", TempExtTextLine);
                        if TempExtTextLine.Find('-') then
                            repeat
                                TempPrepmtSalesLine.Init;
                                TempPrepmtSalesLine.Description := TempExtTextLine.Text;
                                TempPrepmtSalesLine."System-Created Entry" := true;
                                TempPrepmtSalesLine."Prepayment Line" := true;
                                TempPrepmtSalesLine."Line No." := NextLineNo;
                                NextLineNo := NextLineNo + 10000;
                                TempPrepmtSalesLine.Insert;
                            until TempExtTextLine.Next = 0;
                    end;
                end;
            until SalesLine.Next = 0;
        DividePrepmtAmountLCY(TempPrepmtSalesLine, SalesHeader);
    end;

    local procedure InsertedPrepmtVATBaseToDeduct(SalesLine: Record "Sales Line"; PrepmtLineNo: Integer; TotalPrepmtAmtToDeduct: Decimal): Decimal
    var
        PrepmtVATBaseToDeduct: Decimal;
    begin
        if SalesHeader."Prices Including VAT" then
            PrepmtVATBaseToDeduct :=
              Round(
                (TotalPrepmtAmtToDeduct + SalesLine."Prepmt Amt to Deduct") / (1 + SalesLine."Prepayment VAT %" / 100),
                Currency."Amount Rounding Precision") -
              Round(
                TotalPrepmtAmtToDeduct / (1 + SalesLine."Prepayment VAT %" / 100),
                Currency."Amount Rounding Precision")
        else
            PrepmtVATBaseToDeduct := SalesLine."Prepmt Amt to Deduct";

        TempPrepmtDeductLCYSalesLine := SalesLine;
        if TempPrepmtDeductLCYSalesLine."Document Type" = TempPrepmtDeductLCYSalesLine."Document Type"::Order then
            TempPrepmtDeductLCYSalesLine."Qty. to Invoice" := GetQtyToInvoice(SalesLine)
        else
            GetLineDataFromOrder(TempPrepmtDeductLCYSalesLine);
        TempPrepmtDeductLCYSalesLine.CalcPrepaymentToDeduct;
        // if SalesHeader."Prepmt. Include Tax" then
        //     TempPrepmtDeductLCYSalesLine."Prepmt Amt to Deduct" := TempPrepmtDeductLCYSalesLine.CalcAmountIncludingTax(SalesLine."Prepmt Amt to Deduct");
        TempPrepmtDeductLCYSalesLine."Line Amount" := TempPrepmtDeductLCYSalesLine.GetLineAmountToHandle(SalesLine."Qty. to Invoice");
        TempPrepmtDeductLCYSalesLine."Attached to Line No." := PrepmtLineNo;
        TempPrepmtDeductLCYSalesLine."VAT Base Amount" := PrepmtVATBaseToDeduct;
        TempPrepmtDeductLCYSalesLine.Insert;
        exit(PrepmtVATBaseToDeduct);
    end;

    local procedure DividePrepmtAmountLCY(var PrepmtSalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        ActualCurrencyFactor: Decimal;
    begin
        PrepmtSalesLine.Reset;
        PrepmtSalesLine.SetFilter(PrepmtSalesLine.Type, '<>%1', PrepmtSalesLine.Type::" ");
        if PrepmtSalesLine.FindSet then
            repeat
                if SalesHeader."Currency Code" <> '' then
                    ActualCurrencyFactor :=
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          SalesHeader."Posting Date",
                          SalesHeader."Currency Code",
                          PrepmtSalesLine."Prepmt Amt to Deduct",
                          SalesHeader."Currency Factor")) /
                      PrepmtSalesLine."Prepmt Amt to Deduct"
                else
                    ActualCurrencyFactor := 1;

                UpdatePrepmtAmountInvBuf(PrepmtSalesLine."Line No.", ActualCurrencyFactor);
            until PrepmtSalesLine.Next = 0;
    end;

    local procedure UpdatePrepmtAmountInvBuf(PrepmtSalesLineNo: Integer; CurrencyFactor: Decimal)
    var
        PrepmtAmtRemainder: Decimal;
    begin
        TempPrepmtDeductLCYSalesLine.Reset;
        TempPrepmtDeductLCYSalesLine.SetRange("Attached to Line No.", PrepmtSalesLineNo);
        // if TempPrepmtDeductLCYSalesLine.FindSet(true) then
        //     repeat
        //         if not SalesHeader."Prepmt. Include Tax" then
        //             TempPrepmtDeductLCYSalesLine."Prepmt. Amount Inv. (LCY)" :=
        //               CalcRoundedAmount(CurrencyFactor * TempPrepmtDeductLCYSalesLine."VAT Base Amount", PrepmtAmtRemainder);
        //         TempPrepmtDeductLCYSalesLine.Modify;
        //     until TempPrepmtDeductLCYSalesLine.Next = 0;
    end;

    local procedure AdjustPrepmtAmountLCY(var PrepmtSalesLine: Record "Sales Line")
    var
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Line";
        DeductionFactor: Decimal;
        PrepmtVATPart: Decimal;
        PrepmtVATAmtRemainder: Decimal;
        TotalRoundingAmount: array[2] of Decimal;
        TotalPrepmtAmount: array[2] of Decimal;
        FinalInvoice: Boolean;
    begin
        if PrepmtSalesLine."Prepayment Line" then begin
            PrepmtVATPart :=
              (PrepmtSalesLine."Amount Including VAT" - PrepmtSalesLine.Amount) / PrepmtSalesLine."Unit Price";

            TempPrepmtDeductLCYSalesLine.Reset;
            TempPrepmtDeductLCYSalesLine.SetRange("Attached to Line No.", PrepmtSalesLine."Line No.");
            if TempPrepmtDeductLCYSalesLine.FindSet(true) then begin
                FinalInvoice := TempPrepmtDeductLCYSalesLine.IsFinalInvoice;
                repeat
                    SalesLine := TempPrepmtDeductLCYSalesLine;
                    SalesLine.Find;
                    if TempPrepmtDeductLCYSalesLine."Document Type" = TempPrepmtDeductLCYSalesLine."Document Type"::Invoice then begin
                        SalesInvoiceLine := SalesLine;
                        GetSalesOrderLine(SalesLine, SalesInvoiceLine);
                        SalesLine."Qty. to Invoice" := SalesInvoiceLine."Qty. to Invoice";
                    end;
                    // if not SalesHeader."Prepmt. Include Tax" then
                    //     SalesLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(SalesLine);
                    DeductionFactor :=
                      SalesLine."Prepmt Amt to Deduct" /
                      (SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted");

                    TempPrepmtDeductLCYSalesLine."Prepmt. VAT Amount Inv. (LCY)" :=
                      CalcRoundedAmount(SalesLine."Prepmt Amt to Deduct" * PrepmtVATPart, PrepmtVATAmtRemainder);
                    if (TempPrepmtDeductLCYSalesLine."Prepayment %" <> 100) or TempPrepmtDeductLCYSalesLine.IsFinalInvoice then
                        CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYSalesLine, SalesLine, DeductionFactor, TotalRoundingAmount);
                    TempPrepmtDeductLCYSalesLine.Modify;

                    // if SalesHeader."Prepmt. Include Tax" and not TempPrepmtDeductLCYSalesLine.IsFinalInvoice then
                    //     TotalPrepmtAmount[1] += TempPrepmtDeductLCYSalesLine."Prepmt Amt to Deduct"
                    // else
                    TotalPrepmtAmount[1] += TempPrepmtDeductLCYSalesLine."Prepmt. Amount Inv. (LCY)";
                    TotalPrepmtAmount[2] += TempPrepmtDeductLCYSalesLine."Prepmt. VAT Amount Inv. (LCY)";
                    FinalInvoice := FinalInvoice and TempPrepmtDeductLCYSalesLine.IsFinalInvoice;
                until TempPrepmtDeductLCYSalesLine.Next = 0;
            end;

            UpdatePrepmtSalesLineWithRounding(PrepmtSalesLine, TotalRoundingAmount, TotalPrepmtAmount, FinalInvoice);
        end;
    end;


    procedure CalcPrepmtAmtToDeduct(SalesLine: Record "Sales Line"): Decimal
    begin
        SalesLine."Qty. to Invoice" := GetQtyToInvoice(SalesLine);
        SalesLine.CalcPrepaymentToDeduct;
        exit(SalesLine."Prepmt Amt to Deduct");
    end;

    local procedure GetQtyToInvoice(SalesLine: Record "Sales Line"): Decimal
    var
        AllowedQtyToInvoice: Decimal;
    begin
        AllowedQtyToInvoice := SalesLine."Qty. Shipped Not Invoiced";
        if SalesHeader.Ship then
            AllowedQtyToInvoice := AllowedQtyToInvoice + SalesLine."Qty. to Ship";
        if SalesLine."Qty. to Invoice" > AllowedQtyToInvoice then
            exit(AllowedQtyToInvoice);
        exit(SalesLine."Qty. to Invoice");
    end;

    local procedure GetLineDataFromOrder(var SalesLine: Record "Sales Line")
    var
        SalesShptLine: Record "Sales Shipment Line";
        SalesOrderLine: Record "Sales Line";
    begin
        SalesShptLine.Get(SalesLine."Shipment No.", SalesLine."Shipment Line No.");
        SalesOrderLine.Get(SalesLine."Document Type"::Order, SalesShptLine."Order No.", SalesShptLine."Order Line No.");

        SalesLine.Quantity := SalesOrderLine.Quantity;
        SalesLine."Qty. Shipped Not Invoiced" := SalesOrderLine."Qty. Shipped Not Invoiced";
        SalesLine."Quantity Invoiced" := SalesOrderLine."Quantity Invoiced";
        SalesLine."Prepmt Amt Deducted" := SalesOrderLine."Prepmt Amt Deducted";
        SalesLine."Prepmt. Amt. Inv." := SalesOrderLine."Prepmt. Amt. Inv.";
        SalesLine."Line Discount Amount" := SalesOrderLine."Line Discount Amount";
    end;

    local procedure CalcPrepmtRoundingAmounts(var PrepmtSalesLineBuf: Record "Sales Line"; SalesLine: Record "Sales Line"; DeductionFactor: Decimal; var TotalRoundingAmount: array[2] of Decimal)
    var
        RoundingAmount: array[2] of Decimal;
    begin
        RoundingAmount[1] :=
          PrepmtSalesLineBuf."Prepmt. Amount Inv. (LCY)" - Round(DeductionFactor * SalesLine."Prepmt. Amount Inv. (LCY)");
        PrepmtSalesLineBuf."Prepmt. Amount Inv. (LCY)" := PrepmtSalesLineBuf."Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
        TotalRoundingAmount[1] += RoundingAmount[1];

        RoundingAmount[2] :=
          PrepmtSalesLineBuf."Prepmt. VAT Amount Inv. (LCY)" - Round(DeductionFactor * SalesLine."Prepmt. VAT Amount Inv. (LCY)");
        PrepmtSalesLineBuf."Prepmt. VAT Amount Inv. (LCY)" := PrepmtSalesLineBuf."Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
        TotalRoundingAmount[2] += RoundingAmount[2];
    end;

    local procedure UpdatePrepmtSalesLineWithRounding(var PrepmtSalesLine: Record "Sales Line"; TotalRoundingAmount: array[2] of Decimal; TotalPrepmtAmount: array[2] of Decimal; FinalInvoice: Boolean)
    var
        NewAmountIncludingVAT: Decimal;
        Prepmt100PctVATRoundingAmt: Decimal;
    begin
        if Abs(TotalRoundingAmount[1]) <= GLSetup."Amount Rounding Precision" then begin
            if PrepmtSalesLine."Prepayment %" = 100 then
                Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
            TotalRoundingAmount[1] := 0;
        end;
        PrepmtSalesLine."Prepmt. Amount Inv. (LCY)" := TotalRoundingAmount[1];
        PrepmtSalesLine.Amount := TotalPrepmtAmount[1] + TotalRoundingAmount[1];

        if (Abs(TotalRoundingAmount[2]) <= GLSetup."Amount Rounding Precision") or
            (FinalInvoice and (TotalRoundingAmount[1] = 0))
        then begin
            if (PrepmtSalesLine."Prepayment %" = 100) and (PrepmtSalesLine."Prepmt. Amount Inv. (LCY)" = 0) then
                Prepmt100PctVATRoundingAmt += TotalRoundingAmount[2];
            TotalRoundingAmount[2] := 0;
        end;
        PrepmtSalesLine."Prepmt. VAT Amount Inv. (LCY)" := TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt;
        NewAmountIncludingVAT := PrepmtSalesLine.Amount + TotalPrepmtAmount[2] + TotalRoundingAmount[2];
        Increment(
          TotalSalesLineLCY."Amount Including VAT",
          PrepmtSalesLine."Amount Including VAT" - NewAmountIncludingVAT - Prepmt100PctVATRoundingAmt);
        if PrepmtSalesLine."Currency Code" = '' then
            TotalSalesLine."Amount Including VAT" := TotalSalesLineLCY."Amount Including VAT";
        PrepmtSalesLine."Amount Including VAT" := NewAmountIncludingVAT;
    end;

    local procedure CalcRoundedAmount(Amount: Decimal; var Remainder: Decimal): Decimal
    var
        AmountRnded: Decimal;
    begin
        Amount := Amount + Remainder;
        AmountRnded := Round(Amount, GLSetup."Amount Rounding Precision");
        Remainder := Amount - AmountRnded;
        exit(AmountRnded);
    end;

    local procedure GetSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesLine: Record "Sales Line")
    begin
        SalesShptLine.Get(SalesLine."Shipment No.", SalesLine."Shipment Line No.");
        SalesOrderLine.Get(
          SalesOrderLine."Document Type"::Order,
          SalesShptLine."Order No.", SalesShptLine."Order Line No.");
        SalesOrderLine."Prepmt Amt to Deduct" := SalesLine."Prepmt Amt to Deduct";
    end;

    local procedure DecrementPrepmtAmtInvLCY(SalesLine: Record "Sales Line"; var PrepmtAmountInvLCY: Decimal; var PrepmtVATAmountInvLCY: Decimal)
    begin
        TempPrepmtDeductLCYSalesLine := SalesLine;
        if TempPrepmtDeductLCYSalesLine.Find then begin
            // if SalesHeader."Prepmt. Include Tax" then
            //     PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt Amt to Deduct"
            // else
            PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. Amount Inv. (LCY)";
            PrepmtVATAmountInvLCY := PrepmtVATAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. VAT Amount Inv. (LCY)";
        end;
    end;

    local procedure AdjustFinalInvWith100PctPrepmt(var TempSalesLine: Record "Sales Line" temporary)
    var
        DiffToLineDiscAmt: Decimal;
    begin
        TempPrepmtDeductLCYSalesLine.Reset;
        TempPrepmtDeductLCYSalesLine.SetRange("Prepayment %", 100);
        if TempPrepmtDeductLCYSalesLine.FindSet(true) then
            repeat
                if TempPrepmtDeductLCYSalesLine.IsFinalInvoice then begin
                    DiffToLineDiscAmt := TempPrepmtDeductLCYSalesLine."Prepmt Amt to Deduct" - TempPrepmtDeductLCYSalesLine."Line Amount";
                    if TempPrepmtDeductLCYSalesLine."Document Type" = TempPrepmtDeductLCYSalesLine."Document Type"::Order then
                        DiffToLineDiscAmt := DiffToLineDiscAmt * TempPrepmtDeductLCYSalesLine.Quantity / TempPrepmtDeductLCYSalesLine."Qty. to Invoice";
                    if DiffToLineDiscAmt <> 0 then begin
                        TempSalesLine.Get(TempPrepmtDeductLCYSalesLine."Document Type", TempPrepmtDeductLCYSalesLine."Document No.", TempPrepmtDeductLCYSalesLine."Line No.");
                        TempSalesLine."Line Discount Amount" -= DiffToLineDiscAmt;
                        TempSalesLine.Modify;

                        TempPrepmtDeductLCYSalesLine."Line Discount Amount" := TempSalesLine."Line Discount Amount";
                        TempPrepmtDeductLCYSalesLine.Modify;
                    end;
                end;
            until TempPrepmtDeductLCYSalesLine.Next = 0;
        TempPrepmtDeductLCYSalesLine.Reset;
    end;

    local procedure GetPrepmtDiffToLineAmount(SalesLine: Record "Sales Line"): Decimal
    begin
        if SalesLine."Prepayment %" = 100 then
            if TempPrepmtDeductLCYSalesLine.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") then
                exit(TempPrepmtDeductLCYSalesLine."Prepmt Amt to Deduct" - TempPrepmtDeductLCYSalesLine."Line Amount");
        exit(0);
    end;


    procedure MergeSaleslines(SalesHeader: Record "Sales Header"; var Salesline: Record "Sales Line"; var Salesline2: Record "Sales Line"; var MergedSalesline: Record "Sales Line")
    begin
        Salesline.SetRange("Document Type", SalesHeader."Document Type");
        Salesline.SetRange("Document No.", SalesHeader."No.");
        if Salesline.Find('-') then
            repeat
                MergedSalesline := Salesline;
                MergedSalesline.Insert;
            until Salesline.Next = 0;

        Salesline2.SetRange("Document Type", SalesHeader."Document Type");
        Salesline2.SetRange("Document No.", SalesHeader."No.");
        if Salesline2.Find('-') then
            repeat
                MergedSalesline := Salesline2;
                MergedSalesline.Insert;
            until Salesline2.Next = 0;
    end;


    procedure PostJobContractLine(SalesLine: Record "Sales Line"): Integer
    begin
        if SalesLine."Job Contract Entry No." = 0 then
            exit;
        if (SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice) and
           (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo")
        then
            SalesLine.TestField("Job Contract Entry No.", 0);

        SalesLine.TestField("Job No.");
        SalesLine.TestField("Job Task No.");

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            SalesLine."Document No." := SalesInvHeader."No.";
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            SalesLine."Document No." := SalesCrMemoHeader."No.";
        JobContractLine := true;
        //fes mig EXIT(JobPostLine.PostInvoiceContractLine(SalesHeader,SalesLine));
    end;

    local procedure InsertICGenJnlLine(SalesLine: Record "Sales Line")
    var
        ICGLAccount: Record "IC G/L Account";
        Vend: Record Vendor;
        ICPartner: Record "IC Partner";
    begin
        SalesHeader.TestField("Sell-to IC Partner Code", '');
        SalesHeader.TestField("Bill-to IC Partner Code", '');
        SalesLine.TestField("IC Partner Ref. Type", SalesLine."IC Partner Ref. Type"::"G/L Account");
        ICGLAccount.Get(SalesLine."IC Partner Reference");
        ICGenJnlLineNo := ICGenJnlLineNo + 1;
        TempICGenJnlLine.Init;
        TempICGenJnlLine."Line No." := ICGenJnlLineNo;
        TempICGenJnlLine.Validate("Posting Date", SalesHeader."Posting Date");
        TempICGenJnlLine."Document Date" := SalesHeader."Document Date";
        TempICGenJnlLine.Description := SalesHeader."Posting Description";
        TempICGenJnlLine."Reason Code" := SalesHeader."Reason Code";
        TempICGenJnlLine."Document Type" := "Gen. Journal Document Type".FromInteger(GenJnlLineDocType);
        TempICGenJnlLine."Document No." := GenJnlLineDocNo;
        TempICGenJnlLine."External Document No." := GenJnlLineExtDocNo;
        TempICGenJnlLine.Validate("Account Type", TempICGenJnlLine."Account Type"::"IC Partner");
        TempICGenJnlLine.Validate("Account No.", SalesLine."IC Partner Code");
        TempICGenJnlLine."Source Currency Code" := SalesHeader."Currency Code";
        TempICGenJnlLine."Source Currency Amount" := TempICGenJnlLine.Amount;
        TempICGenJnlLine.Correction := SalesHeader.Correction;
        TempICGenJnlLine."Source Code" := SrcCode;
        TempICGenJnlLine."Country/Region Code" := SalesHeader."VAT Country/Region Code";
        TempICGenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        TempICGenJnlLine."Source No." := SalesHeader."Bill-to Customer No.";
        TempICGenJnlLine."Source Line No." := SalesLine."Line No.";
        TempICGenJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
        TempICGenJnlLine.Validate("Bal. Account Type", TempICGenJnlLine."Bal. Account Type"::"G/L Account");
        TempICGenJnlLine.Validate("Bal. Account No.", SalesLine."No.");
        TempICGenJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
        TempICGenJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
        TempICGenJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";
        Vend.SetRange("IC Partner Code", SalesLine."IC Partner Code");
        if Vend.FindFirst then begin
            TempICGenJnlLine.Validate("Bal. Gen. Bus. Posting Group", Vend."Gen. Bus. Posting Group");
            TempICGenJnlLine.Validate("Bal. VAT Bus. Posting Group", Vend."VAT Bus. Posting Group");
        end;
        TempICGenJnlLine.Validate("Bal. VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");
        TempICGenJnlLine."IC Partner Code" := SalesLine."IC Partner Code";
        /*    TempICGenJnlLine."IC Partner G/L Acc. No." := SalesLine."IC Partner Reference"; */
        TempICGenJnlLine."IC Direction" := TempICGenJnlLine."IC Direction"::Outgoing;
        ICPartner.Get(SalesLine."IC Partner Code");
        if ICPartner."Cost Distribution in LCY" and (SalesLine."Currency Code" <> '') then begin
            TempICGenJnlLine."Currency Code" := '';
            TempICGenJnlLine."Currency Factor" := 0;
            Currency.Get(SalesLine."Currency Code");
            if SalesHeader."Document Type" in
               [SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo"]
            then
                TempICGenJnlLine.Amount :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      SalesHeader."Posting Date", SalesLine."Currency Code",
                      SalesLine.Amount, SalesHeader."Currency Factor"))
            else
                TempICGenJnlLine.Amount :=
                  -Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      SalesHeader."Posting Date", SalesLine."Currency Code",
                      SalesLine.Amount, SalesHeader."Currency Factor"));
        end else begin
            Currency.InitRoundingPrecision;
            TempICGenJnlLine."Currency Code" := SalesHeader."Currency Code";
            TempICGenJnlLine."Currency Factor" := SalesHeader."Currency Factor";
            if SalesHeader."Document Type" in [SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo"] then
                TempICGenJnlLine.Amount := SalesLine.Amount
            else
                TempICGenJnlLine.Amount := -SalesLine.Amount;
        end;
        TempICGenJnlLine."Bal. VAT Calculation Type" := SalesLine."VAT Calculation Type";
        TempICGenJnlLine."Bal. Tax Area Code" := SalesLine."Tax Area Code";
        TempICGenJnlLine."Bal. Tax Liable" := SalesLine."Tax Liable";
        TempICGenJnlLine."Bal. Tax Group Code" := SalesLine."Tax Group Code";

        TempICGenJnlLine.Validate("Bal. VAT %");

        if TempICGenJnlLine."Bal. VAT %" <> 0 then
            TempICGenJnlLine.Amount := Round(TempICGenJnlLine.Amount * (1 + TempICGenJnlLine."Bal. VAT %" / 100),
                Currency."Amount Rounding Precision");
        TempICGenJnlLine.Validate(Amount);
        TempICGenJnlLine.Insert;
    end;

    local procedure PostICGenJnl()
    var
        ICInOutBoxMgt: Codeunit ICInboxOutboxMgt;
        ICTransactionNo: Integer;
    begin
        TempICGenJnlLine.Reset;
        TempICGenJnlLine.SetFilter(Amount, '<>%1', 0);
        if TempICGenJnlLine.Find('-') then
            repeat
                ICTransactionNo := ICInOutBoxMgt.CreateOutboxJnlTransaction(TempICGenJnlLine, false);
                ICInOutBoxMgt.CreateOutboxJnlLine(ICTransactionNo, 1, TempICGenJnlLine);
                if TempICGenJnlLine.Amount <> 0 then
                    GenJnlPostLine.RunWithCheck(TempICGenJnlLine);
            until TempICGenJnlLine.Next = 0;
    end;

    local procedure AddSalesTaxLineToSalesTaxCalc(SalesLine: Record "Sales Line"; FirstLine: Boolean)
    var
        MaxInvQty: Decimal;
        MaxInvQtyBase: Decimal;
    begin
        if FirstLine then begin
            TempSalesLineForSalesTax.DeleteAll;
            // TempSalesTaxAmtLine.DeleteAll;
            // SalesTaxCalculate.StartSalesTaxCalculation;
        end;
        TempSalesLineForSalesTax := SalesLine;

        if TempSalesLineForSalesTax."Qty. per Unit of Measure" = 0 then
            TempSalesLineForSalesTax."Qty. per Unit of Measure" := 1;
        if (TempSalesLineForSalesTax."Document Type" = TempSalesLineForSalesTax."Document Type"::Invoice) and (TempSalesLineForSalesTax."Shipment No." <> '') then begin
            TempSalesLineForSalesTax."Quantity Shipped" := TempSalesLineForSalesTax.Quantity;
            TempSalesLineForSalesTax."Qty. Shipped (Base)" := TempSalesLineForSalesTax."Quantity (Base)";
            TempSalesLineForSalesTax."Qty. to Ship" := 0;
            TempSalesLineForSalesTax."Qty. to Ship (Base)" := 0;
        end;
        if (TempSalesLineForSalesTax."Document Type" = TempSalesLineForSalesTax."Document Type"::"Credit Memo") and (TempSalesLineForSalesTax."Return Receipt No." <> '') then begin
            TempSalesLineForSalesTax."Return Qty. Received" := TempSalesLineForSalesTax.Quantity;
            TempSalesLineForSalesTax."Return Qty. Received (Base)" := TempSalesLineForSalesTax."Quantity (Base)";
            TempSalesLineForSalesTax."Return Qty. to Receive" := 0;
            TempSalesLineForSalesTax."Return Qty. to Receive (Base)" := 0;
        end;
        if TempSalesLineForSalesTax."Document Type" in [TempSalesLineForSalesTax."Document Type"::"Return Order", TempSalesLineForSalesTax."Document Type"::"Credit Memo"] then begin
            MaxInvQty := (TempSalesLineForSalesTax."Return Qty. Received" - TempSalesLineForSalesTax."Quantity Invoiced");
            MaxInvQtyBase := (TempSalesLineForSalesTax."Return Qty. Received (Base)" - TempSalesLineForSalesTax."Qty. Invoiced (Base)");
            if SalesHeader.Receive then begin
                MaxInvQty := MaxInvQty + TempSalesLineForSalesTax."Return Qty. to Receive";
                MaxInvQtyBase := MaxInvQtyBase + TempSalesLineForSalesTax."Return Qty. to Receive (Base)";
            end;
        end else begin
            MaxInvQty := (TempSalesLineForSalesTax."Quantity Shipped" - TempSalesLineForSalesTax."Quantity Invoiced");
            MaxInvQtyBase := (TempSalesLineForSalesTax."Qty. Shipped (Base)" - TempSalesLineForSalesTax."Qty. Invoiced (Base)");
            if SalesHeader.Ship then begin
                MaxInvQty := MaxInvQty + TempSalesLineForSalesTax."Qty. to Ship";
                MaxInvQtyBase := MaxInvQtyBase + TempSalesLineForSalesTax."Qty. to Ship (Base)";
            end;
        end;
        if Abs(TempSalesLineForSalesTax."Qty. to Invoice") > Abs(MaxInvQty) then begin
            TempSalesLineForSalesTax."Qty. to Invoice" := MaxInvQty;
            TempSalesLineForSalesTax."Qty. to Invoice (Base)" := MaxInvQtyBase;
        end;
        if TempSalesLineForSalesTax.Quantity = 0 then
            TempSalesLineForSalesTax."Inv. Disc. Amount to Invoice" := 0
        else
            TempSalesLineForSalesTax."Inv. Disc. Amount to Invoice" :=
              Round(
                TempSalesLineForSalesTax."Inv. Discount Amount" * TempSalesLineForSalesTax."Qty. to Invoice" / TempSalesLineForSalesTax.Quantity,
                Currency."Amount Rounding Precision");
        TempSalesLineForSalesTax."Quantity (Base)" := TempSalesLineForSalesTax."Qty. to Invoice (Base)";
        TempSalesLineForSalesTax."Line Amount" := Round(TempSalesLineForSalesTax."Qty. to Invoice" * TempSalesLineForSalesTax."Unit Price", Currency."Amount Rounding Precision");
        if TempSalesLineForSalesTax.Quantity <> TempSalesLineForSalesTax."Qty. to Invoice" then
            TempSalesLineForSalesTax."Line Discount Amount" :=
              Round(TempSalesLineForSalesTax."Line Amount" * TempSalesLineForSalesTax."Line Discount %" / 100, Currency."Amount Rounding Precision");
        TempSalesLineForSalesTax.Quantity := TempSalesLineForSalesTax."Qty. to Invoice";
        TempSalesLineForSalesTax."Line Amount" := TempSalesLineForSalesTax."Line Amount" - TempSalesLineForSalesTax."Line Discount Amount";
        TempSalesLineForSalesTax."Inv. Discount Amount" := TempSalesLineForSalesTax."Inv. Disc. Amount to Invoice";
        TempSalesLineForSalesTax.Amount := TempSalesLineForSalesTax."Line Amount" - TempSalesLineForSalesTax."Inv. Discount Amount";
        TempSalesLineForSalesTax."VAT Base Amount" := TempSalesLineForSalesTax.Amount;
        TempSalesLineForSalesTax.Insert;

        //if not UseExternalTaxEngine then
        //    SalesTaxCalculate.AddSalesLine(TempSalesLineForSalesTax);
    end;

    local procedure TestGetShipmentPPmtAmtToDeduct(var SalesHeader: Record "Sales Header")
    var
        SalesLine2: Record "Sales Line";
        TempSalesLine3: Record "Sales Line" temporary;
        TempTotalSalesLine: Record "Sales Line" temporary;
        TempSalesShptLine: Record "Sales Shipment Line" temporary;
        MaxAmtToDeduct: Decimal;
    begin
        SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine2.SetRange("Document No.", SalesHeader."No.");
        SalesLine2.SetFilter(Quantity, '>0');
        SalesLine2.SetFilter("Qty. to Invoice", '>0');
        SalesLine2.SetFilter("Shipment No.", '<>%1', '');
        SalesLine2.SetFilter("Prepmt Amt to Deduct", '<>0');
        if SalesLine2.IsEmpty then
            exit;
        SalesLine2.SetRange("Prepmt Amt to Deduct");

        if SalesLine2.FindSet then
            repeat
                if SalesShptLine.Get(SalesLine2."Shipment No.", SalesLine2."Shipment Line No.") then begin
                    TempSalesLine3 := SalesLine2;
                    TempSalesLine3.Insert;
                    TempSalesShptLine := SalesShptLine;
                    if TempSalesShptLine.Insert then;

                    if not TempTotalSalesLine.Get(SalesLine2."Document Type"::Order, SalesShptLine."Order No.", SalesShptLine."Order Line No.") then begin
                        TempTotalSalesLine.Init;
                        TempTotalSalesLine."Document Type" := SalesLine2."Document Type"::Order;
                        TempTotalSalesLine."Document No." := SalesShptLine."Order No.";
                        TempTotalSalesLine."Line No." := SalesShptLine."Order Line No.";
                        TempTotalSalesLine.Insert;
                    end;
                    TempTotalSalesLine."Qty. to Invoice" := TempTotalSalesLine."Qty. to Invoice" + SalesLine2."Qty. to Invoice";
                    TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + SalesLine2."Prepmt Amt to Deduct";
                    AdjustInvLineWith100PctPrepmt(SalesLine2, TempTotalSalesLine);
                    TempTotalSalesLine.Modify;
                end;
            until SalesLine2.Next = 0;

        if TempSalesLine3.FindSet then
            repeat
                if TempSalesShptLine.Get(TempSalesLine3."Shipment No.", TempSalesLine3."Shipment Line No.") then begin
                    if SalesLine2.Get(TempSalesLine3."Document Type"::Order, TempSalesShptLine."Order No.", TempSalesShptLine."Order Line No.") then
                        if TempTotalSalesLine.Get(
                             TempSalesLine3."Document Type"::Order, TempSalesShptLine."Order No.", TempSalesShptLine."Order Line No.")
                        then begin
                            MaxAmtToDeduct := SalesLine2."Prepmt. Amt. Inv." - SalesLine2."Prepmt Amt Deducted";

                            if TempTotalSalesLine."Prepmt Amt to Deduct" > MaxAmtToDeduct then
                                Error(StrSubstNo(Text050, SalesLine2.FieldCaption("Prepmt Amt to Deduct"), MaxAmtToDeduct));

                            if (TempTotalSalesLine."Qty. to Invoice" = SalesLine2.Quantity - SalesLine2."Quantity Invoiced") and
                               (TempTotalSalesLine."Prepmt Amt to Deduct" <> MaxAmtToDeduct)
                            then
                                Error(StrSubstNo(Text051, SalesLine2.FieldCaption("Prepmt Amt to Deduct"), MaxAmtToDeduct));
                        end;
                end;
            until TempSalesLine3.Next = 0;
    end;

    local procedure AdjustInvLineWith100PctPrepmt(var SalesInvoiceLine: Record "Sales Line"; var TempTotalSalesLine: Record "Sales Line" temporary)
    var
        SalesOrderLine: Record "Sales Line";
        DiffAmtToDeduct: Decimal;
    begin
        if SalesInvoiceLine."Prepayment %" = 100 then begin
            SalesOrderLine := TempTotalSalesLine;
            SalesOrderLine.Find;
            if TempTotalSalesLine."Qty. to Invoice" = SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced" then begin
                DiffAmtToDeduct :=
                  SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted" - TempTotalSalesLine."Prepmt Amt to Deduct";
                if DiffAmtToDeduct <> 0 then begin
                    SalesInvoiceLine."Prepmt Amt to Deduct" := SalesInvoiceLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
                    SalesInvoiceLine."Line Amount" := SalesInvoiceLine."Prepmt Amt to Deduct";
                    SalesInvoiceLine."Line Discount Amount" := SalesInvoiceLine."Line Discount Amount" - DiffAmtToDeduct;
                    SalesInvoiceLine.Modify;
                    TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
                end;
            end;
        end;
    end;


    procedure ArchiveUnpostedOrder()
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        if not SalesSetup."Archive Orders" then
            exit;
        if not (SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"]) then
            exit;
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Quantity, '<>0');
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            SalesLine.SetFilter("Qty. to Ship", '<>0')
        else
            SalesLine.SetFilter("Return Qty. to Receive", '<>0');
        if not SalesLine.IsEmpty then begin
            ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
            Commit;
        end;
    end;

    local procedure SynchBOMSerialNo(var ServItemTmp3: Record "Service Item" temporary; var ServItemTmpCmp3: Record "Service Item Component" temporary)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemLedgEntry2: Record "Item Ledger Entry";
        TempSalesShipMntLine: Record "Sales Shipment Line" temporary;
        ServItemTmpCmp4: Record "Service Item Component" temporary;
        ServItemCompLocal: Record "Service Item Component";
        TempItemLedgEntry2: Record "Item Ledger Entry" temporary;
        ChildCount: Integer;
        EndLoop: Boolean;
    begin
        if not ServItemTmpCmp3.Find('-') then
            exit;

        if not ServItemTmp3.Find('-') then
            exit;

        TempSalesShipMntLine.DeleteAll;
        repeat
            Clear(TempSalesShipMntLine);
            TempSalesShipMntLine."Document No." := ServItemTmp3."Sales/Serv. Shpt. Document No.";
            TempSalesShipMntLine."Line No." := ServItemTmp3."Sales/Serv. Shpt. Line No.";
            if TempSalesShipMntLine.Insert then;
        until ServItemTmp3.Next = 0;

        if not TempSalesShipMntLine.Find('-') then
            exit;

        ServItemTmp3.SetCurrentKey("Sales/Serv. Shpt. Document No.", "Sales/Serv. Shpt. Line No.");
        Clear(ItemLedgEntry);
        ItemLedgEntry.SetCurrentKey("Document No.", "Document Type", "Document Line No.");

        repeat
            ChildCount := 0;
            ServItemTmpCmp4.DeleteAll;
            ServItemTmp3.SetRange("Sales/Serv. Shpt. Document No.", TempSalesShipMntLine."Document No.");
            ServItemTmp3.SetRange("Sales/Serv. Shpt. Line No.", TempSalesShipMntLine."Line No.");
            if ServItemTmp3.Find('-') then
                repeat
                    ServItemTmpCmp3.SetRange(Active, true);
                    ServItemTmpCmp3.SetRange("Parent Service Item No.", ServItemTmp3."No.");
                    if ServItemTmpCmp3.Find('-') then
                        repeat
                            ChildCount += 1;
                            ServItemTmpCmp4 := ServItemTmpCmp3;
                            ServItemTmpCmp4.Insert;
                        until ServItemTmpCmp3.Next = 0;
                until ServItemTmp3.Next = 0;
            ItemLedgEntry.SetRange("Document No.", TempSalesShipMntLine."Document No.");
            ItemLedgEntry.SetRange("Document Type", ItemLedgEntry."Document Type"::"Sales Shipment");
            ItemLedgEntry.SetRange("Document Line No.", TempSalesShipMntLine."Line No.");
            if ItemLedgEntry.FindFirst and ServItemTmpCmp4.Find('-') then begin
                Clear(ItemLedgEntry2);
                ItemLedgEntry2.Get(ItemLedgEntry."Entry No.");
                EndLoop := false;
                repeat
                    if ItemLedgEntry2."Item No." = ServItemTmpCmp4."No." then
                        EndLoop := true
                    else
                        if ItemLedgEntry2.Next = 0 then
                            EndLoop := true;
                until EndLoop;
                ItemLedgEntry2.SetRange("Entry No.", ItemLedgEntry2."Entry No.", ItemLedgEntry2."Entry No." + ChildCount - 1);
                if ItemLedgEntry2.FindSet then
                    repeat
                        TempItemLedgEntry2 := ItemLedgEntry2;
                        TempItemLedgEntry2.Insert;
                    until ItemLedgEntry2.Next = 0;
                repeat
                    if ServItemCompLocal.Get(
                         ServItemTmpCmp4.Active,
                         ServItemTmpCmp4."Parent Service Item No.",
                         ServItemTmpCmp4."Line No.")
                    then begin
                        TempItemLedgEntry2.SetRange("Item No.", ServItemCompLocal."No.");
                        if TempItemLedgEntry2.FindFirst then begin
                            ServItemCompLocal."Serial No." := TempItemLedgEntry2."Serial No.";
                            ServItemCompLocal.Modify;
                            TempItemLedgEntry2.Delete;
                        end;
                    end;
                until ServItemTmpCmp4.Next = 0;
            end;
        until TempSalesShipMntLine.Next = 0;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;

    local procedure PostCustomerEntry(SalesHeader2: Record "Sales Header"; TotalSalesLine2: Record "Sales Line"; TotalSalesLineLCY2: Record "Sales Line"; DocType: Option; DocNo: Code[20]; ExtDocNo: Code[35]; SourceCode: Code[10])
    var
        GenJnlLine2: Record "Gen. Journal Line";

    begin

        GenJnlLine2.Init;
        GenJnlLine2."Posting Date" := SalesHeader2."Posting Date";
        GenJnlLine2."Document Date" := SalesHeader2."Document Date";
        GenJnlLine2.Description := SalesHeader2."Posting Description";
        GenJnlLine2."Shortcut Dimension 1 Code" := SalesHeader2."Shortcut Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := SalesHeader2."Shortcut Dimension 2 Code";
        GenJnlLine2."Dimension Set ID" := SalesHeader2."Dimension Set ID";
        GenJnlLine2."Reason Code" := SalesHeader2."Reason Code";
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::Customer;
        GenJnlLine2."Account No." := SalesHeader2."Bill-to Customer No.";
        GenJnlLine2."Document Type" := "Gen. Journal Document Type".FromInteger(DocType);
        GenJnlLine2."Document No." := DocNo;
        GenJnlLine2."External Document No." := ExtDocNo;
        GenJnlLine2."Currency Code" := SalesHeader2."Currency Code";
        GenJnlLine2.Amount := -TotalSalesLine2."Amount Including VAT";
        GenJnlLine2."Source Currency Code" := SalesHeader2."Currency Code";
        GenJnlLine2."Source Currency Amount" := -TotalSalesLine2."Amount Including VAT";
        GenJnlLine2."Amount (LCY)" := -TotalSalesLineLCY2."Amount Including VAT";
        if SalesHeader2."Currency Code" = '' then
            GenJnlLine2."Currency Factor" := 1
        else
            GenJnlLine2."Currency Factor" := SalesHeader2."Currency Factor";
        GenJnlLine2.Correction := SalesHeader2.Correction;
        GenJnlLine2."Sales/Purch. (LCY)" := -TotalSalesLineLCY2.Amount;
        GenJnlLine2."Profit (LCY)" := -(TotalSalesLineLCY2.Amount - TotalSalesLineLCY2."Unit Cost (LCY)");
        GenJnlLine2."Inv. Discount (LCY)" := -TotalSalesLineLCY2."Inv. Discount Amount";
        GenJnlLine2."Sell-to/Buy-from No." := SalesHeader2."Sell-to Customer No.";
        GenJnlLine2."Bill-to/Pay-to No." := SalesHeader2."Bill-to Customer No.";
        GenJnlLine2."Salespers./Purch. Code" := SalesHeader2."Salesperson Code";
        GenJnlLine2."System-Created Entry" := true;
        GenJnlLine2."On Hold" := SalesHeader2."On Hold";
        GenJnlLine2."Applies-to Doc. Type" := SalesHeader2."Applies-to Doc. Type";
        GenJnlLine2."Applies-to Doc. No." := SalesHeader2."Applies-to Doc. No.";
        GenJnlLine2."Applies-to ID" := SalesHeader2."Applies-to ID";
        GenJnlLine2."Allow Application" := SalesHeader2."Bal. Account No." = '';
        GenJnlLine2."Due Date" := SalesHeader2."Due Date";
        GenJnlLine2."Direct Debit Mandate ID" := SalesHeader2."Direct Debit Mandate ID";
        GenJnlLine2."Payment Terms Code" := SalesHeader2."Payment Terms Code";
        GenJnlLine2."Payment Method Code" := SalesHeader2."Payment Method Code";
        GenJnlLine2."Pmt. Discount Date" := SalesHeader2."Pmt. Discount Date";
        GenJnlLine2."Payment Discount %" := SalesHeader2."Payment Discount %";
        GenJnlLine2."Source Type" := GenJnlLine2."Source Type"::Customer;
        GenJnlLine2."Source No." := SalesHeader2."Bill-to Customer No.";
        GenJnlLine2."Source Code" := SourceCode;

        // Localizado para Cada Pais DsPOS

        // Fin Localizado

        GenJnlLine2."Posting No. Series" := SalesHeader2."Posting No. Series";
        GenJnlLine2."IC Partner Code" := SalesHeader2."Sell-to IC Partner Code";

        GenJnlPostLine.RunWithCheck(GenJnlLine2);
    end;

    local procedure UpdateSalesHeader(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        case GenJnlLineDocType of
            GenJnlLine."Document Type"::Invoice.asInteger():
                begin
                    FindCustLedgEntry(GenJnlLineDocType, GenJnlLineDocNo, CustLedgerEntry);
                    SalesInvHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
                    SalesInvHeader.Modify;
                end;
            GenJnlLine."Document Type"::"Credit Memo".asInteger():
                begin
                    FindCustLedgEntry(GenJnlLineDocType, GenJnlLineDocNo, CustLedgerEntry);
                    SalesCrMemoHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
                    SalesCrMemoHeader.Modify;
                end;
        end;
    end;

    local procedure CaptureOrRefundCreditCardPmnt(CustLedgEntry: Record "Cust. Ledger Entry"): Integer
    begin
        if not IsOnlinePayment(SalesHeader) then
            exit(0);

        if not SalesHeader.Invoice then
            exit(0);

        //fes mig IF "Document Type" = "Document Type"::"Credit Memo" THEN
        //fes mig    EXIT(DOPaymentMgt.RefundSalesDoc(SalesHeader,CustLedgEntry."Entry No."));

        //fes mig EXIT(DOPaymentMgt.CaptureSalesDoc(SalesHeader,CustLedgEntry."Entry No."));
    end;

    local procedure AuthorizeCreditCard(AuthorizationRequired: Boolean): Integer
    begin
        //fes mig
        /*
        WITH SalesHeader DO BEGIN
          IF ("Document Type" = "Document Type"::Order) AND Ship OR
             ("Document Type" = "Document Type"::Invoice) AND Invoice
          THEN
            IF DOPaymentMgt.IsValidPaymentMethod("Payment Method Code") THEN BEGIN
              IF DOPaymentMgt.IsAuthorizationRequired OR AuthorizationRequired THEN
                EXIT(DOPaymentMgt.AuthorizeSalesDoc(SalesHeader,0,TRUE));
              TESTFIELD("Credit Card No.");
            END;
        END;
        EXIT(0);
        */
        //fes mig

    end;

    local procedure "MAX"(number1: Integer; number2: Integer): Integer
    begin
        if number1 > number2 then
            exit(number1);
        exit(number2);
    end;

    local procedure PostBalanceEntry(TransactionLogEntryNo: Integer; SalesHeader2: Record "Sales Header"; TotalSalesLine2: Record "Sales Line"; TotalSalesLineLCY2: Record "Sales Line"; DocType: Option; DocNo: Code[20]; ExtDocNo: Code[35]; SourceCode: Code[10])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";

        CrCardDocumentType: Option Payment,Refund;
    begin
        //fes mig
        /*
        WITH SalesHeader2 DO BEGIN
          FindCustLedgEntry(DocType,DocNo,CustLedgEntry);
        
          GenJnlLine.INIT;
          GenJnlLine."Posting Date" := "Posting Date";
          GenJnlLine."Document Date" := "Document Date";
          GenJnlLine.Description := "Posting Description";
          GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
          GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
          GenJnlLine."Dimension Set ID" := "Dimension Set ID";
          GenJnlLine."Reason Code" := "Reason Code";
          GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
          GenJnlLine."Account No." := "Bill-to Customer No.";
          IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund
          ELSE
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
          GenJnlLine."Document No." := DocNo;
          GenJnlLine."External Document No." := ExtDocNo;
          IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
          GenJnlLine."Bal. Account No." := "Bal. Account No.";
          GenJnlLine."Currency Code" := "Currency Code";
          GenJnlLine.Amount :=
            TotalSalesLine2."Amount Including VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
          GenJnlLine."Source Currency Code" := "Currency Code";
          GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
          GenJnlLine.Correction := Correction;
          CustLedgEntry.CALCFIELDS(Amount);
          IF CustLedgEntry.Amount = 0 THEN
            GenJnlLine."Amount (LCY)" := TotalSalesLineLCY2."Amount Including VAT"
          ELSE
            GenJnlLine."Amount (LCY)" :=
              TotalSalesLineLCY2."Amount Including VAT" +
              ROUND(
                CustLedgEntry."Remaining Pmt. Disc. Possible" /
                CustLedgEntry."Adjusted Currency Factor");
          IF "Currency Code" = '' THEN
            GenJnlLine."Currency Factor" := 1
          ELSE
            GenJnlLine."Currency Factor" := "Currency Factor";
          GenJnlLine."Applies-to Doc. Type" := DocType;
          GenJnlLine."Applies-to Doc. No." := DocNo;
          GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
          GenJnlLine."Source No." := "Bill-to Customer No.";
          GenJnlLine."Source Code" := SourceCode;
          GenJnlLine."Posting No. Series" := "Posting No. Series";
          GenJnlLine."IC Partner Code" := "Sell-to IC Partner Code";
          GenJnlLine."Salespers./Purch. Code" := "Salesperson Code";
          GenJnlLine."Allow Zero-Amount Posting" := TRUE;
        
          // Localizado para Cada Pais DsPOS
          CASE cduPOS.Pais() OF
            1:cfDominicana.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader2); // Dominicana
            2:cfBolivia.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader2); // Bolivia
            3:cfParaguay.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader2); // Paraguay
            4:cfEcuador.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader2); // Ecuador
            5:cfGuatemala.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader2); // Guatemala
            6:cfSalvador.Ventas_Registrar_Localizado(GenJnlLine,SalesHeader2); // Salvador
          END;
          // Fin Localizado
        
          GenJnlPostLine.RunWithCheck(GenJnlLine);
        
          IF TransactionLogEntryNo <> 0 THEN BEGIN
            CASE "Document Type" OF
              GenJnlLine."Document Type"::Payment:
                CrCardDocumentType := CrCardDocumentType::Payment;
              "Document Type"::"Credit Memo":
                CrCardDocumentType := CrCardDocumentType::Refund;
            END;
            DOPaymentMgt.UpdateTransactEntryAfterPost(TransactionLogEntryNo,CustLedgEntry."Entry No.",CrCardDocumentType);
          END;
        END;
        */
        //fes mig

    end;

    local procedure FindCustLedgEntry(DocType: Option; DocNo: Code[20]; var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.SetRange("Document Type", DocType);
        CustLedgEntry.SetRange("Document No.", DocNo);
        CustLedgEntry.FindLast;
    end;


    procedure IsOnlinePayment(var SalesHeader: Record "Sales Header"): Boolean
    begin
        //fes mig
        /*
        IF DOPaymentMgt.IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN
          EXIT(TRUE);
        EXIT(FALSE);
        */
        //fes mig

    end;

    local procedure IsAuthorized(TransactionLogEntryNo: Integer): Boolean
    begin
        exit(TransactionLogEntryNo <> 0);
    end;

    local procedure ItemLedgerEntryExist(SalesLine2: Record "Sales Line"): Boolean
    var
        HasItemLedgerEntry: Boolean;
    begin
        if SalesHeader.Ship or SalesHeader.Receive then
            HasItemLedgerEntry :=
              ((SalesLine2."Qty. to Ship" + SalesLine2."Quantity Shipped") <> 0) or
              ((SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced") <> 0) or
              ((SalesLine2."Return Qty. to Receive" + SalesLine2."Return Qty. Received") <> 0)
        else
            HasItemLedgerEntry :=
              (SalesLine2."Quantity Shipped" <> 0) or
              (SalesLine2."Return Qty. Received" <> 0);

        exit(HasItemLedgerEntry);
    end;


    procedure CheckCustBlockage(CustCode: Code[20]; ExecuteDocCheck: Boolean)
    var
        Cust: Record Customer;
    begin
        Cust.Get(CustCode);
        if SalesHeader.Receive then
            Cust.CheckBlockedCustOnDocs(Cust, SalesHeader."Document Type", false, true)
        else begin
            if SalesHeader.Ship and CheckDocumentType(ExecuteDocCheck) then begin
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetFilter("Qty. to Ship", '<>0');
                SalesLine.SetRange("Shipment No.", '');
                if not SalesLine.IsEmpty then
                    Cust.CheckBlockedCustOnDocs(Cust, SalesHeader."Document Type", true, true);
            end else
                Cust.CheckBlockedCustOnDocs(Cust, SalesHeader."Document Type", false, true);
        end;
    end;


    procedure CheckDocumentType(ExecuteDocCheck: Boolean): Boolean
    begin
        if ExecuteDocCheck then begin
            if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) or
               ((SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) and
                SalesSetup."Shipment on Invoice")
            then
                exit(true);
        end;
        exit(true);
    end;

    local procedure UpdateWonOpportunities(var SalesHeader: Record "Sales Header")
    var
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            Opp.Reset;
            Opp.SetCurrentKey("Sales Document Type", "Sales Document No.");
            Opp.SetRange("Sales Document Type", Opp."Sales Document Type"::Order);
            Opp.SetRange("Sales Document No.", SalesHeader."No.");
            Opp.SetRange(Status, Opp.Status::Won);
            if Opp.FindFirst then begin
                Opp."Sales Document Type" := Opp."Sales Document Type"::"Posted Invoice";
                Opp."Sales Document No." := SalesInvHeader."No.";
                Opp.Modify;
                OpportunityEntry.Reset;
                OpportunityEntry.SetCurrentKey(Active, "Opportunity No.");
                OpportunityEntry.SetRange(Active, true);
                OpportunityEntry.SetRange("Opportunity No.", Opp."No.");
                if OpportunityEntry.FindFirst then begin
                    OpportunityEntry."Calcd. Current Value (LCY)" := OpportunityEntry.GetSalesDocValue(SalesHeader);
                    OpportunityEntry.Modify;
                end;
            end;
        end;
    end;


    procedure UpdateQtyToBeInvoiced(var QtyToBeInvoiced: Decimal; var QtyToBeInvoicedBase: Decimal; TrackingSpecificationExists: Boolean; HasATOShippedNotInvoiced: Boolean; SalesLine: Record "Sales Line"; SalesShptLine: Record "Sales Shipment Line"; InvoicingTrackingSpecification: Record "Tracking Specification"; ItemLedgEntryNotInvoiced: Record "Item Ledger Entry")
    begin
        if TrackingSpecificationExists then begin
            QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
            QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
        end else
            if HasATOShippedNotInvoiced then begin
                QtyToBeInvoicedBase := ItemLedgEntryNotInvoiced.Quantity - ItemLedgEntryNotInvoiced."Invoiced Quantity";
                if Abs(QtyToBeInvoicedBase) > Abs(RemQtyToBeInvoicedBase) then
                    QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
                QtyToBeInvoiced := Round(QtyToBeInvoicedBase / SalesShptLine."Qty. per Unit of Measure", 0.00001);
            end else begin
                QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Qty. to Ship";
                QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
            end;

        if Abs(QtyToBeInvoiced) > Abs(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced") then begin
            QtyToBeInvoiced := -(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced");
            QtyToBeInvoicedBase := -(SalesShptLine."Quantity (Base)" - SalesShptLine."Qty. Invoiced (Base)");
        end;
    end;


    procedure IsEndLoopForShippedNotInvoiced(RemQtyToBeInvoiced: Decimal; TrackingSpecificationExists: Boolean; var HasATOShippedNotInvoiced: Boolean; var SalesShptLine: Record "Sales Shipment Line"; var InvoicingTrackingSpecification: Record "Tracking Specification"; var ItemLedgEntryNotInvoiced: Record "Item Ledger Entry"; SalesLine: Record "Sales Line"): Boolean
    begin
        if TrackingSpecificationExists then
            exit(InvoicingTrackingSpecification.Next = 0);

        if HasATOShippedNotInvoiced then begin
            HasATOShippedNotInvoiced := ItemLedgEntryNotInvoiced.Next <> 0;
            if not HasATOShippedNotInvoiced then
                exit(not SalesShptLine.FindSet or (Abs(RemQtyToBeInvoiced) <= Abs(SalesLine."Qty. to Ship")));
            exit(Abs(RemQtyToBeInvoiced) <= Abs(SalesLine."Qty. to Ship"));
        end;

        exit((SalesShptLine.Next = 0) or (Abs(RemQtyToBeInvoiced) <= Abs(SalesLine."Qty. to Ship")));
    end;


    procedure SetItemEntryRelation(var ItemEntryRelation: Record "Item Entry Relation"; var SalesShptLine: Record "Sales Shipment Line"; var InvoicingTrackingSpecification: Record "Tracking Specification"; var ItemLedgEntryNotInvoiced: Record "Item Ledger Entry"; TrackingSpecificationExists: Boolean; HasATOShippedNotInvoiced: Boolean)
    begin
        if TrackingSpecificationExists then begin
            ItemEntryRelation.Get(InvoicingTrackingSpecification."Item Ledger Entry No.");
            SalesShptLine.Get(ItemEntryRelation."Source ID", ItemEntryRelation."Source Ref. No.");
        end else
            if HasATOShippedNotInvoiced then begin
                ItemEntryRelation."Item Entry No." := ItemLedgEntryNotInvoiced."Entry No.";
                SalesShptLine.Get(ItemLedgEntryNotInvoiced."Document No.", ItemLedgEntryNotInvoiced."Document Line No.");
            end else
                ItemEntryRelation."Item Entry No." := SalesShptLine."Item Shpt. Entry No.";
    end;

    local procedure PostATOAssocItemJnlLine(SalesLine: Record "Sales Line"; var PostedATOLink: Record "Posted Assemble-to-Order Link"; var RemQtyToBeInvoiced: Decimal; var RemQtyToBeInvoicedBase: Decimal)
    var
        DummyTrackingSpecification: Record "Tracking Specification";
    begin
        DummyTrackingSpecification.Init;
        if SalesLine."Document Type" = SalesLine."Document Type"::Order then begin
            PostedATOLink."Assembled Quantity" := -PostedATOLink."Assembled Quantity";
            PostedATOLink."Assembled Quantity (Base)" := -PostedATOLink."Assembled Quantity (Base)";
            if Abs(RemQtyToBeInvoiced) >= Abs(PostedATOLink."Assembled Quantity") then begin
                ItemLedgShptEntryNo :=
                  PostItemJnlLine(
                    SalesLine,
                    PostedATOLink."Assembled Quantity", PostedATOLink."Assembled Quantity (Base)",
                    PostedATOLink."Assembled Quantity", PostedATOLink."Assembled Quantity (Base)",
                    0, '', DummyTrackingSpecification, true);
                RemQtyToBeInvoiced -= PostedATOLink."Assembled Quantity";
                RemQtyToBeInvoicedBase -= PostedATOLink."Assembled Quantity (Base)";
            end else begin
                if RemQtyToBeInvoiced <> 0 then
                    ItemLedgShptEntryNo :=
                      PostItemJnlLine(
                        SalesLine,
                        RemQtyToBeInvoiced,
                        RemQtyToBeInvoicedBase,
                        RemQtyToBeInvoiced,
                        RemQtyToBeInvoicedBase,
                        0, '', DummyTrackingSpecification, true);

                ItemLedgShptEntryNo :=
                  PostItemJnlLine(
                    SalesLine,
                    PostedATOLink."Assembled Quantity" - RemQtyToBeInvoiced,
                    PostedATOLink."Assembled Quantity (Base)" - RemQtyToBeInvoicedBase,
                    0, 0,
                    0, '', DummyTrackingSpecification, true);

                RemQtyToBeInvoiced := 0;
                RemQtyToBeInvoicedBase := 0;
            end;
            //end;
        end;
    end;

    local procedure GetOpenLinkedATOs(var TempAsmHeader: Record "Assembly Header" temporary)
    var
        SalesLine2: Record "Sales Line";
        AsmHeader: Record "Assembly Header";
    begin
        SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine2.SetRange("Document No.", SalesHeader."No.");
        if SalesLine2.Find('-') then
            repeat
                if SalesLine2.AsmToOrderExists(AsmHeader) then
                    if AsmHeader.Status = AsmHeader.Status::Open then begin
                        TempAsmHeader.TransferFields(AsmHeader);
                        TempAsmHeader.Insert;
                    end;
            until SalesLine2.Next = 0;
    end;

    local procedure ReopenAsmOrders(var TempAsmHeader: Record "Assembly Header" temporary)
    var
        AsmHeader: Record "Assembly Header";
    begin
        if TempAsmHeader.Find('-') then
            repeat
                AsmHeader.Get(TempAsmHeader."Document Type", TempAsmHeader."No.");
                AsmHeader.Status := AsmHeader.Status::Open;
                AsmHeader.Modify;
            until TempAsmHeader.Next = 0;
    end;

    local procedure InitPostATO(var SalesLine: Record "Sales Line")
    var
        AsmHeader: Record "Assembly Header";
        Window: Dialog;
    begin
        if SalesLine.AsmToOrderExists(AsmHeader) then begin
            Window.Open(Text055);
            Window.Update(1,
              StrSubstNo(Text059,
                SalesLine."Document Type", SalesLine."Document No.", SalesLine.FieldCaption("Line No."), SalesLine."Line No."));
            Window.Update(2, StrSubstNo(Text060, AsmHeader."Document Type", AsmHeader."No."));

            SalesLine.CheckAsmToOrder(AsmHeader);
            if not HasQtyToAsm(SalesLine, AsmHeader) then
                exit;

            AsmPost.SetPostingDate(true, SalesHeader."Posting Date");
            AsmPost.InitPostATO(AsmHeader);

            Window.Close;
        end;
    end;

    local procedure PostATO(var SalesLine: Record "Sales Line"; var TempPostedATOLink: Record "Posted Assemble-to-Order Link" temporary)
    var
        AsmHeader: Record "Assembly Header";
        PostedATOLink: Record "Posted Assemble-to-Order Link";
        Window: Dialog;
    begin
        if SalesLine.AsmToOrderExists(AsmHeader) then begin
            Window.Open(Text056);
            Window.Update(1,
              StrSubstNo(Text059,
                SalesLine."Document Type", SalesLine."Document No.", SalesLine.FieldCaption("Line No."), SalesLine."Line No."));
            Window.Update(2, StrSubstNo(Text060, AsmHeader."Document Type", AsmHeader."No."));

            SalesLine.CheckAsmToOrder(AsmHeader);
            if not HasQtyToAsm(SalesLine, AsmHeader) then
                exit;
            if AsmHeader."Remaining Quantity (Base)" = 0 then
                exit;

            PostedATOLink.Init;
            PostedATOLink."Assembly Document Type" := PostedATOLink."Assembly Document Type"::Assembly;
            PostedATOLink."Assembly Document No." := AsmHeader."Posting No.";
            PostedATOLink."Document Type" := PostedATOLink."Document Type"::"Sales Shipment";
            PostedATOLink."Document No." := SalesHeader."Shipping No.";
            PostedATOLink."Document Line No." := SalesLine."Line No.";

            PostedATOLink."Assembly Order No." := AsmHeader."No.";
            PostedATOLink."Order No." := SalesLine."Document No.";
            PostedATOLink."Order Line No." := SalesLine."Line No.";

            PostedATOLink."Assembled Quantity" := AsmHeader."Quantity to Assemble";
            PostedATOLink."Assembled Quantity (Base)" := AsmHeader."Quantity to Assemble (Base)";
            PostedATOLink.Insert;

            TempPostedATOLink := PostedATOLink;
            TempPostedATOLink.Insert;

            AsmPost.PostATO(AsmHeader, ItemJnlPostLine, ResJnlPostLine, WhseJnlPostLine);

            Window.Close;
        end;
    end;

    local procedure FinalizePostATO(var SalesLine: Record "Sales Line")
    var
        ATOLink: Record "Assemble-to-Order Link";
        AsmHeader: Record "Assembly Header";
        Window: Dialog;
    begin
        if SalesLine.AsmToOrderExists(AsmHeader) then begin
            Window.Open(Text057);
            Window.Update(1,
              StrSubstNo(Text059,
                SalesLine."Document Type", SalesLine."Document No.", SalesLine.FieldCaption("Line No."), SalesLine."Line No."));
            Window.Update(2, StrSubstNo(Text060, AsmHeader."Document Type", AsmHeader."No."));

            SalesLine.CheckAsmToOrder(AsmHeader);
            AsmHeader.TestField("Remaining Quantity (Base)", 0);
            AsmPost.FinalizePostATO(AsmHeader);
            ATOLink.Get(AsmHeader."Document Type", AsmHeader."No.");
            ATOLink.Delete;

            Window.Close;
        end;
    end;

    local procedure CheckATOLink(SalesLine: Record "Sales Line")
    var
        AsmHeader: Record "Assembly Header";
    begin
        if SalesLine."Qty. to Asm. to Order (Base)" = 0 then
            exit;
        if SalesLine.AsmToOrderExists(AsmHeader) then
            SalesLine.CheckAsmToOrder(AsmHeader);
    end;

    local procedure DeleteATOLinks(SalesHeader: Record "Sales Header")
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin
        ATOLink.SetCurrentKey(Type, ATOLink."Document Type", ATOLink."Document No.");
        ATOLink.SetRange(Type, ATOLink.Type::Sale);
        ATOLink.SetRange("Document Type", SalesHeader."Document Type");
        ATOLink.SetRange("Document No.", SalesHeader."No.");
        if not ATOLink.IsEmpty then
            ATOLink.DeleteAll;
    end;

    local procedure HasQtyToAsm(SalesLine: Record "Sales Line"; AsmHeader: Record "Assembly Header"): Boolean
    begin
        if SalesLine."Qty. to Asm. to Order (Base)" = 0 then
            exit(false);
        if SalesLine."Qty. to Ship (Base)" = 0 then
            exit(false);
        if AsmHeader."Quantity to Assemble (Base)" = 0 then
            exit(false);
        exit(true);
    end;

    local procedure GetATOItemLedgEntriesNotInvoiced(SalesLine: Record "Sales Line"; var ItemLedgEntryNotInvoiced: Record "Item Ledger Entry"): Boolean
    var
        PostedATOLink: Record "Posted Assemble-to-Order Link";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntryNotInvoiced.Reset;
        ItemLedgEntryNotInvoiced.DeleteAll;
        if PostedATOLink.FindLinksFromSalesLine(SalesLine) then
            repeat
                ItemLedgEntry.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
                ItemLedgEntry.SetRange("Document Type", ItemLedgEntry."Document Type"::"Sales Shipment");
                ItemLedgEntry.SetRange("Document No.", PostedATOLink."Document No.");
                ItemLedgEntry.SetRange("Document Line No.", PostedATOLink."Document Line No.");
                ItemLedgEntry.SetRange("Assemble to Order", true);
                ItemLedgEntry.SetRange("Completely Invoiced", false);
                if ItemLedgEntry.FindSet then
                    repeat
                        if ItemLedgEntry.Quantity <> ItemLedgEntry."Invoiced Quantity" then begin
                            ItemLedgEntryNotInvoiced := ItemLedgEntry;
                            ItemLedgEntryNotInvoiced.Insert;
                        end;
                    until ItemLedgEntry.Next = 0;
            until PostedATOLink.Next = 0;

        exit(ItemLedgEntryNotInvoiced.FindSet);
    end;

    local procedure PostSalesTaxToGL()
    var
        TaxJurisdiction: Record "Tax Jurisdiction";
        TaxLineCount: Integer;
        RemSalesTaxAmt: Decimal;
        RemSalesTaxSrcAmt: Decimal;
    begin
        //fes mig
        /*
        TaxLineCount := 0;
        RemSalesTaxAmt := 0;
        RemSalesTaxSrcAmt := 0;
        IF SalesHeader."Currency Code" <> '' THEN
          TotalSalesLineLCY."Amount Including VAT" := TotalSalesLineLCY.Amount;
        IF TempSalesTaxAmtLine.FIND('-') THEN
          REPEAT
            TaxLineCount := TaxLineCount + 1;
            Window.UPDATE(3,STRSUBSTNO('%1 / %2',LineCount,TaxLineCount));
            IF ((TempSalesTaxAmtLine."Tax Base Amount" <> 0) AND
                (TempSalesTaxAmtLine."Tax Type" = TempSalesTaxAmtLine."Tax Type"::"Sales and Use Tax")) OR
               ((TempSalesTaxAmtLine.Quantity <> 0) AND
                (TempSalesTaxAmtLine."Tax Type" = TempSalesTaxAmtLine."Tax Type"::"Excise Tax"))
            THEN BEGIN
              GenJnlLine.INIT;
              GenJnlLine."Posting Date" := SalesHeader."Posting Date";
              GenJnlLine."Document Date" := SalesHeader."Document Date";
              GenJnlLine.Description := SalesHeader."Posting Description";
              GenJnlLine."Reason Code" := SalesHeader."Reason Code";
              GenJnlLine."Document Type" := GenJnlLineDocType;
              GenJnlLine."Document No." := GenJnlLineDocNo;
              GenJnlLine."External Document No." := GenJnlLineExtDocNo;
              GenJnlLine."System-Created Entry" := TRUE;
              GenJnlLine.Amount := 0;
              GenJnlLine."Source Currency Code" := SalesHeader."Currency Code";
              GenJnlLine."Source Currency Amount" := 0;
              GenJnlLine.Correction := SalesHeader.Correction;
              GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Sale;
              GenJnlLine."Tax Area Code" := TempSalesTaxAmtLine."Tax Area Code";
              GenJnlLine."Tax Type" := TempSalesTaxAmtLine."Tax Type";
              GenJnlLine."Tax Exemption No." := SalesHeader."Tax Exemption No.";
              GenJnlLine."Tax Group Code" := TempSalesTaxAmtLine."Tax Group Code";
              GenJnlLine."Tax Liable" := TempSalesTaxAmtLine."Tax Liable";
              GenJnlLine.Quantity := TempSalesTaxAmtLine.Quantity;
              GenJnlLine."VAT Calculation Type" := GenJnlLine."VAT Calculation Type"::"Sales Tax";
              GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
              GenJnlLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
              GenJnlLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
              GenJnlLine."Dimension Set ID" := SalesHeader."Dimension Set ID";
              GenJnlLine."Source Code" := SrcCode;
              GenJnlLine."EU 3-Party Trade" := SalesHeader."EU 3-Party Trade";
              GenJnlLine."Bill-to/Pay-to No." := SalesHeader."Sell-to Customer No.";
              GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
              GenJnlLine."Source No." := SalesHeader."Bill-to Customer No.";
              GenJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
              GenJnlLine."STE Transaction ID" := SalesHeader."STE Transaction ID";
              GenJnlLine."Source Curr. VAT Base Amount" :=
                CurrExchRate.ExchangeAmtLCYToFCY(
                  UseDate,SalesHeader."Currency Code",TempSalesTaxAmtLine."Tax Base Amount",SalesHeader."Currency Factor");
              GenJnlLine."VAT Base Amount (LCY)" :=
                ROUND(TempSalesTaxAmtLine."Tax Base Amount");
              GenJnlLine."VAT Base Amount" := GenJnlLine."VAT Base Amount (LCY)";
        
              IF TaxJurisdiction.Code <> TempSalesTaxAmtLine."Tax Jurisdiction Code" THEN BEGIN
                TaxJurisdiction.GET(TempSalesTaxAmtLine."Tax Jurisdiction Code");
                IF SalesTaxCountry = SalesTaxCountry::CA THEN BEGIN
                  RemSalesTaxAmt := 0;
                  RemSalesTaxSrcAmt := 0;
                END;
              END;
              IF TaxJurisdiction."Unrealized VAT Type" > 0 THEN BEGIN
                TaxJurisdiction.TESTFIELD("Unreal. Tax Acc. (Sales)");
                GenJnlLine."Account No." := TaxJurisdiction."Unreal. Tax Acc. (Sales)";
              END ELSE BEGIN
                TaxJurisdiction.TESTFIELD("Tax Account (Sales)");
                GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Sales)";
              END;
              GenJnlLine."Tax Jurisdiction Code" := TempSalesTaxAmtLine."Tax Jurisdiction Code";
              IF TempSalesTaxAmtLine."Tax Amount" <> 0 THEN BEGIN
                RemSalesTaxSrcAmt := RemSalesTaxSrcAmt +
                  TempSalesTaxAmtLine."Tax Base Amount FCY" * TempSalesTaxAmtLine."Tax %" / 100;
                GenJnlLine."Source Curr. VAT Amount" :=
                  SalesTaxCalculate.ArithmeticRound(RemSalesTaxSrcAmt,Currency."Amount Rounding Precision");
                RemSalesTaxSrcAmt := RemSalesTaxSrcAmt - GenJnlLine."Source Curr. VAT Amount";
                RemSalesTaxAmt := RemSalesTaxAmt + TempSalesTaxAmtLine."Tax Amount";
                GenJnlLine."VAT Amount (LCY)" :=
                  SalesTaxCalculate.ArithmeticRound(RemSalesTaxAmt,GLSetup."Amount Rounding Precision");
                RemSalesTaxAmt := RemSalesTaxAmt - GenJnlLine."VAT Amount (LCY)";
                GenJnlLine."VAT Amount" := GenJnlLine."VAT Amount (LCY)";
              END;
              GenJnlLine."VAT Difference" := TempSalesTaxAmtLine."Tax Difference";
        
              IF NOT
                 (SalesHeader."Document Type" IN
                  [SalesHeader."Document Type"::"Return Order",SalesHeader."Document Type"::"Credit Memo"])
              THEN BEGIN
                GenJnlLine."Source Curr. VAT Base Amount" := -GenJnlLine."Source Curr. VAT Base Amount";
                GenJnlLine."VAT Base Amount (LCY)" := -GenJnlLine."VAT Base Amount (LCY)";
                GenJnlLine."VAT Base Amount" := -GenJnlLine."VAT Base Amount";
                GenJnlLine."Source Curr. VAT Amount" := -GenJnlLine."Source Curr. VAT Amount";
                GenJnlLine."VAT Amount (LCY)" := -GenJnlLine."VAT Amount (LCY)";
                GenJnlLine."VAT Amount" := -GenJnlLine."VAT Amount";
                GenJnlLine.Quantity := -GenJnlLine.Quantity;
                GenJnlLine."VAT Difference" := -GenJnlLine."VAT Difference";
              END;
              IF SalesHeader."Currency Code" <> '' THEN
                TotalSalesLineLCY."Amount Including VAT" :=
                  TotalSalesLineLCY."Amount Including VAT" + GenJnlLine."VAT Amount (LCY)";
        
        
              GenJnlPostLine.RunWithCheck(GenJnlLine);
            END;
          UNTIL TempSalesTaxAmtLine.NEXT = 0;
        */
        //fes mig

    end;


    procedure SetWhseJnlRegisterCU(var WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line")
    begin
        WhseJnlPostLine := WhseJnlRegisterLine;
    end;

    local procedure PostWhseShptLines(var WhseShptLine2: Record "Warehouse Shipment Line"; SalesShptLine2: Record "Sales Shipment Line"; var SalesLine2: Record "Sales Line")
    var
        ATOWhseShptLine: Record "Warehouse Shipment Line";
        NonATOWhseShptLine: Record "Warehouse Shipment Line";
        ATOLineFound: Boolean;
        NonATOLineFound: Boolean;
        TotalSalesShptLineQty: Decimal;
    begin
        WhseShptLine2.GetATOAndNonATOLines(ATOWhseShptLine, NonATOWhseShptLine, ATOLineFound, NonATOLineFound);
        if ATOLineFound then
            TotalSalesShptLineQty += ATOWhseShptLine."Qty. to Ship";
        if NonATOLineFound then
            TotalSalesShptLineQty += NonATOWhseShptLine."Qty. to Ship";
        SalesShptLine2.TestField(Quantity, TotalSalesShptLineQty);

        SaveTempWhseSplitSpec(SalesLine2);

        WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
        if ATOLineFound and (ATOWhseShptLine."Qty. to Ship (Base)" > 0) then
            WhsePostShpt.CreatePostedShptLine(
              ATOWhseShptLine, PostedWhseShptHeader, PostedWhseShptLine, TempWhseSplitSpecification);
        if NonATOLineFound and (NonATOWhseShptLine."Qty. to Ship (Base)" > 0) then
            WhsePostShpt.CreatePostedShptLine(
              NonATOWhseShptLine, PostedWhseShptHeader, PostedWhseShptLine, TempWhseSplitSpecification);
    end;

    local procedure GetCountryCode(SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"): Code[10]
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if SalesLine."Shipment No." <> '' then begin
            SalesShipmentHeader.Get(SalesLine."Shipment No.");
            exit(
              GetCountryRegionCode(
                SalesLine."Sell-to Customer No.",
                SalesShipmentHeader."Ship-to Code",
                SalesShipmentHeader."Sell-to Country/Region Code"));
        end;
        exit(
          GetCountryRegionCode(
            SalesLine."Sell-to Customer No.",
            SalesHeader."Ship-to Code",
            SalesHeader."Sell-to Country/Region Code"));
    end;

    local procedure GetCountryRegionCode(CustNo: Code[20]; ShipToCode: Code[10]; SellToCountryRegionCode: Code[10]): Code[10]
    var
        ShipToAddress: Record "Ship-to Address";
    begin
        if ShipToCode <> '' then begin
            ShipToAddress.Get(CustNo, ShipToCode);
            exit(ShipToAddress."Country/Region Code");
        end;
        exit(SellToCountryRegionCode);
    end;

    local procedure UpdateIncomingDocument(IncomingDocNo: Integer; PostingDate: Date; GenJnlLineDocNo: Code[20])
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument.UpdateIncomingDocumentFromPosting(IncomingDocNo, PostingDate, GenJnlLineDocNo);
    end;

    local procedure CheckItemCharge(ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    var
        SalesLineForCharge: Record "Sales Line";
    begin
        case ItemChargeAssgntSales."Applies-to Doc. Type" of
            ItemChargeAssgntSales."Applies-to Doc. Type"::Order,
          ItemChargeAssgntSales."Applies-to Doc. Type"::Invoice:
                if SalesLineForCharge.Get(
                      ItemChargeAssgntSales."Applies-to Doc. Type",
                      ItemChargeAssgntSales."Applies-to Doc. No.",
                      ItemChargeAssgntSales."Applies-to Doc. Line No.")
                then
                    if (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Qty. Shipped (Base)") and
                        (SalesLineForCharge."Qty. Shipped Not Invd. (Base)" = 0)
                    then
                        Error(Text061Err);
            ItemChargeAssgntSales."Applies-to Doc. Type"::"Return Order",
          ItemChargeAssgntSales."Applies-to Doc. Type"::"Credit Memo":
                if SalesLineForCharge.Get(
                      ItemChargeAssgntSales."Applies-to Doc. Type",
                      ItemChargeAssgntSales."Applies-to Doc. No.",
                      ItemChargeAssgntSales."Applies-to Doc. Line No.")
                then
                    if (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Return Qty. Received (Base)") and
                        (SalesLineForCharge."Ret. Qty. Rcd. Not Invd.(Base)" = 0)
                    then
                        Error(Text061Err);
        end;
    end;

    local procedure CheckItemReservDisruption()
    var
        AvailableQty: Decimal;
    begin
        //fes mig
        /*
        WITH SalesLine DO BEGIN
          IF NOT ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) OR
             (Type <> Type::Item) OR
             NOT ("Qty. to Ship (Base)" > 0)
          THEN
            EXIT;
          IF ("Job Contract Entry No." <> 0) OR
             Nonstock OR
             "Special Order" OR
             "Drop Shipment" OR
             IsServiceItem OR
             FullQtyIsForAsmToOrder OR
             TempSKU.GET("Location Code","No.","Variant Code") // Warn against item
          THEN
            EXIT;
        
          Item.SETFILTER("Location Filter","Location Code");
          Item.SETFILTER("Variant Filter","Variant Code");
          Item.CALCFIELDS("Reserved Qty. on Inventory","Net Change");
          CALCFIELDS("Reserved Qty. (Base)");
          AvailableQty := Item."Net Change" - (Item."Reserved Qty. on Inventory" - "Reserved Qty. (Base)");
        
          IF (Item."Reserved Qty. on Inventory" > 0) AND
             (AvailableQty < "Qty. to Ship (Base)") AND
             (Item."Reserved Qty. on Inventory" > "Reserved Qty. (Base)")
          THEN BEGIN
            InsertTempSKU("Location Code","No.","Variant Code");
            IF NOT CONFIRM(
                 Text062Qst,FALSE,FIELDCAPTION("No."),Item."No.",FIELDCAPTION("Location Code"),
                 "Location Code",FIELDCAPTION("Variant Code"),"Variant Code")
            THEN
              ERROR('');
          END;
        END;
        */
        //fes mig

    end;

    local procedure InsertTempSKU(LocationCode: Code[10]; ItemNo: Code[20]; VariantCode: Code[10])
    begin
        TempSKU.Init;
        TempSKU."Location Code" := LocationCode;
        TempSKU."Item No." := ItemNo;
        TempSKU."Variant Code" := VariantCode;
        TempSKU.Insert;
    end;


    procedure InitProgressWindow(SalesHeader: Record "Sales Header")
    begin
        if SalesHeader.Invoice then
            Window.Open(
              '#1#################################\\' +
              Text002 +
              Text003 +
              Text004 +
              Text005)
        else
            Window.Open(
              '#1#################################\\' +
              Text006);

        Window.Update(1, StrSubstNo('%1 %2', SalesHeader."Document Type", SalesHeader."No."));
    end;
}

