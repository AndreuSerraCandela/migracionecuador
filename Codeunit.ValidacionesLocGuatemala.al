codeunit 76080 "Validaciones Loc. Guatemala"
{

    trigger OnRun()
    begin
    end;

    var
        SalesQuoteLine: Record "Sales Line";
        ConfigSantillana: Record "Config. Empresa";
        NoLin: Integer;


    procedure CreadesdePrePedido(SH: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
    begin
        //DSLoc1.01
        SalesHeader.Copy(SH);
        ConfigSantillana.Get();
        ConfigSantillana.TestField(Country);

        //fes mig
        /*
        ParamPais.GET(ConfigSantillana.Country);
        IF ParamPais."Control Lin. por Factura" THEN
           ParamPais.TESTFIELD("Cantidad Lin. por factura");
        
        
        // *** End ***
        
        Cust.GET("Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust,"Document Type"::Order,TRUE,FALSE);
        
        CALCFIELDS("Amount Including VAT");
        SalesOrderHeader := Rec;
        SalesQuoteHeader := Rec;
        
        IF GUIALLOWED AND NOT HideValidationDialog THEN
          CustCheckCreditLimit.SalesHeaderCheck(SalesOrderHeader);
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Order;
        
        SalesQuoteLine.SETRANGE("Document Type","Document Type");
        SalesQuoteLine.SETRANGE("Document No.","No.");
        SalesQuoteLine.SETRANGE(Type,SalesQuoteLine.Type::Item);
        SalesQuoteLine.SETFILTER("No.",'<>%1','');
        IF SalesQuoteLine.FINDSET THEN
          REPEAT
            ContLin += 1;
            IF (SalesQuoteLine."Outstanding Quantity" > 0) THEN BEGIN
              SalesLine := SalesQuoteLine;
              SalesLine.VALIDATE("Reserved Qty. (Base)",0);
              SalesLine."Line No." := 0;
              IF GUIALLOWED AND NOT HideValidationDialog THEN BEGIN
                IF SalesQuoteLine."Build Kit" THEN BEGIN
                  KitSalesQuoteLine.SETRANGE("Document Type","Document Type");
                  KitSalesQuoteLine.SETRANGE("Document No.","No.");
                  KitSalesQuoteLine.SETRANGE("Document Line No.",SalesQuoteLine."Line No.");
                  KitSalesQuoteLine.SETRANGE(Type,KitSalesQuoteLine.Type::Item);
                  KitSalesQuoteLine.SETFILTER("No.",'<>%1','');
                  IF KitSalesQuoteLine.FINDSET THEN
                    REPEAT
                      SalesLine."No." := KitSalesQuoteLine."No.";
                      SalesLine."Variant Code" := KitSalesQuoteLine."Variant Code";
                      SalesLine."Unit of Measure Code" := KitSalesQuoteLine."Unit of Measure Code";
                      SalesLine."Qty. per Unit of Measure" := KitSalesQuoteLine."Qty. per Unit of Measure";
                      SalesLine."Outstanding Quantity" := ROUND(SalesLine."Quantity (Base)" * KitSalesQuoteLine."Quantity per",0.00001);
                      SalesLine."Build Kit" := FALSE;
                      ItemCheckAvail.SalesLineCheck(SalesLine);
                    UNTIL KitSalesQuoteLine.NEXT = 0;
                END ELSE
                  ItemCheckAvail.SalesLineCheck(SalesLine);
              END;
            END;
          UNTIL SalesQuoteLine.NEXT = 0;
        
        {GRN
        Opp.RESET;
        Opp.SETCURRENTKEY("Sales Document Type","Sales Document No.");
        Opp.SETRANGE("Sales Document Type",Opp."Sales Document Type"::"pre order");
        Opp.SETRANGE("Sales Document No.","No.");
        Opp.SETRANGE(Status,Opp.Status::"In Progress");
        IF Opp.FINDFIRST THEN
          IF CONFIRM(Text000 + Text001 + Text002,TRUE) THEN BEGIN
            TempOpportunityEntry.DELETEALL;
            TempOpportunityEntry.INIT;
            TempOpportunityEntry.VALIDATE("Opportunity No.",Opp."No.");
            TempOpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
            TempOpportunityEntry."Contact No." := Opp."Contact No.";
            TempOpportunityEntry."Contact Company No." := Opp."Contact Company No.";
            TempOpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
            TempOpportunityEntry."Campaign No." := Opp."Campaign No.";
            TempOpportunityEntry."Action Taken" := TempOpportunityEntry."Action Taken"::Won;
            TempOpportunityEntry.INSERT;
            TempOpportunityEntry.SETRANGE("Action Taken",TempOpportunityEntry."Action Taken"::Won);
            PAGE.RUNMODAL(PAGE::"Close Opportunity",TempOpportunityEntry);
            Opp.RESET;
            Opp.SETCURRENTKEY("Sales Document Type","Sales Document No.");
            Opp.SETRANGE("Sales Document Type",Opp."Sales Document Type"::"pre order");
            Opp.SETRANGE("Sales Document No.","No.");
            Opp.SETRANGE(Status,Opp.Status::"In Progress");
            IF Opp.FINDFIRST THEN
              ERROR(Text003)
            ELSE BEGIN
              COMMIT;
              GET("Document Type","No.");
            END;
          END ELSE
            ERROR(Text004);
        }
        
        Result := ContLin/ParamPais."Cantidad Lin. por factura" MOD 1;
        IF Result <> 0 THEN
           FOR i := 1 TO ROUND(ContLin/ParamPais."Cantidad Lin. por factura",1,'<')+1 DO
             CrearCabecera
        ELSE
           FOR i := 1 TO ROUND(ContLin/ParamPais."Cantidad Lin. por factura",1,'<') DO
             CrearCabecera;
        {
        if contlin > ParamPais."Cantidad Lin. por factura" then
           crearcabecera
        else
           begin
            SalesOrderHeader."No. Printed" := 0;
            SalesOrderHeader.Status := SalesOrderHeader.Status::Open;
            SalesOrderHeader."No." := '';
            SalesOrderHeader."Quote No." :=  "No.";
            SalesOrderLine.LOCKTABLE;
            SalesOrderHeader.INSERT(TRUE);
           end;
        FromDocDim.SETRANGE("Table ID",DATABASE::"Sales Header");
        FromDocDim.SETRANGE("Document Type","Document Type");
        FromDocDim.SETRANGE("Document No.","No.");
        
        ToDocDim.SETRANGE("Table ID",DATABASE::"Sales Header");
        ToDocDim.SETRANGE("Document Type",SalesOrderHeader."Document Type");
        ToDocDim.SETRANGE("Document No.",SalesOrderHeader."No.");
        ToDocDim.DELETEALL;
        
        DocDim.MoveDocDimToDocDim(
          FromDocDim,
          DATABASE::"Sales Header",
          SalesOrderHeader."No.",
          SalesOrderHeader."Document Type",
          0);
        
        SalesOrderHeader."Order Date" := "Order Date";
        IF "Posting Date" <> 0D THEN
          SalesOrderHeader."Posting Date" := "Posting Date";
        SalesOrderHeader."Document Date" := "Document Date";
        SalesOrderHeader."Shipment Date" := "Shipment Date";
        SalesOrderHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        SalesOrderHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        SalesOrderHeader."Date Sent" := 0D;
        SalesOrderHeader."Time Sent" := 0T;
        
        SalesOrderHeader."Location Code" := "Location Code";
        SalesOrderHeader."Outbound Whse. Handling Time" := "Outbound Whse. Handling Time";
        SalesOrderHeader."Ship-to Name" := "Ship-to Name";
        SalesOrderHeader."Ship-to Name 2" := "Ship-to Name 2";
        SalesOrderHeader."Ship-to Address" := "Ship-to Address";
        SalesOrderHeader."Ship-to Address 2" := "Ship-to Address 2";
        SalesOrderHeader."Ship-to City" := "Ship-to City";
        SalesOrderHeader."Ship-to Post Code" := "Ship-to Post Code";
        SalesOrderHeader."Ship-to County" := "Ship-to County";
        SalesOrderHeader."Ship-to Country/Region Code" := "Ship-to Country/Region Code";
        SalesOrderHeader."Ship-to Contact" := "Ship-to Contact";
        
        SalesOrderHeader."Prepayment %" := Cust."Prepayment %";
        IF SalesOrderHeader."Posting Date" = 0D THEN
          SalesOrderHeader."Posting Date" := WORKDATE;
        
        SalesOrderHeader.MODIFY;
        
        SalesQuoteLine.RESET;
        SalesQuoteLine.SETRANGE("Document Type","Document Type");
        SalesQuoteLine.SETRANGE("Document No.","No.");
        
        FromDocDim.SETRANGE("Table ID",DATABASE::"Sales Line");
        ToDocDim.SETRANGE("Table ID",DATABASE::"Sales Line");
        
        IF SalesQuoteLine.FINDSET THEN
          REPEAT
            SalesOrderLine := SalesQuoteLine;
            SalesOrderLine."Document Type" := SalesOrderHeader."Document Type";
            SalesOrderLine."Document No." := SalesOrderHeader."No.";
            ReserveSalesLine.TransferSaleLineToSalesLine(
              SalesQuoteLine,SalesOrderLine,SalesQuoteLine."Outstanding Qty. (Base)");
            SalesOrderLine."Shortcut Dimension 1 Code" := SalesQuoteLine."Shortcut Dimension 1 Code";
            SalesOrderLine."Shortcut Dimension 2 Code" := SalesQuoteLine."Shortcut Dimension 2 Code";
        
            IF Cust."Prepayment %" <> 0 THEN
              SalesOrderLine."Prepayment %" := Cust."Prepayment %";
            PrepmtMgt.SetSalesPrepaymentPct(SalesOrderLine,SalesOrderHeader."Posting Date");
            SalesOrderLine.VALIDATE("Prepayment %");
        
            SalesOrderLine.INSERT;
        
            ReserveSalesLine.VerifyQuantity(SalesOrderLine,SalesQuoteLine);
        
            IF SalesQuoteLine."Build Kit" THEN BEGIN
              KitSalesQuoteLine.RESET;
              KitSalesQuoteLine.SETRANGE("Document Type","Document Type");
              KitSalesQuoteLine.SETRANGE("Document No.","No.");
              KitSalesQuoteLine.SETRANGE("Document Line No.",SalesQuoteLine."Line No.");
              IF KitSalesQuoteLine.FINDSET THEN
                REPEAT
                  KitSalesOrderLine := KitSalesQuoteLine;
                  KitSalesOrderLine."Document Type" := SalesOrderHeader."Document Type";
                  KitSalesOrderLine."Document No." := SalesOrderHeader."No.";
                  IF (KitSalesQuoteLine.Type = KitSalesQuoteLine.Type::Item) AND
                     (KitSalesQuoteLine."No." <> '')
                  THEN
                    ReserveKitSalesLine.TransfKitSalLineToKitSalesLine(
                      KitSalesQuoteLine,KitSalesOrderLine,KitSalesQuoteLine."Outstanding Qty. (Base)");
                  KitSalesOrderLine."Shortcut Dimension 1 Code" := KitSalesQuoteLine."Shortcut Dimension 1 Code";
                  KitSalesOrderLine."Shortcut Dimension 2 Code" := KitSalesQuoteLine."Shortcut Dimension 2 Code";
                  KitSalesOrderLine.INSERT;
        
                  IF KitSalesOrderLine.Reserve = KitSalesOrderLine.Reserve::Always THEN
                    KitSalesOrderLine.AutoReserve;
                UNTIL KitSalesQuoteLine.NEXT = 0;
            END;
        
            IF SalesOrderLine.Reserve = SalesOrderLine.Reserve::Always THEN BEGIN
              SalesOrderLine.AutoReserve(FALSE);
            END;
        
            FromDocDim.SETRANGE("Line No.",SalesQuoteLine."Line No.");
        
            ToDocDim.SETRANGE("Line No.",SalesOrderLine."Line No.");
            ToDocDim.DELETEALL;
            DocDim.MoveDocDimToDocDim(
              FromDocDim,
              DATABASE::"Sales Line",
              SalesOrderHeader."No.",
              SalesOrderHeader."Document Type",
              SalesOrderLine."Line No.");
          UNTIL SalesQuoteLine.NEXT = 0;
        
        SalesSetup.GET;
        IF SalesSetup."Archive Quotes and Orders" THEN
          ArchiveManagement.ArchSalesDocumentNoConfirm(Rec);
        
        IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date" :: "No Date" THEN BEGIN
          SalesOrderHeader."Posting Date" := 0D;
          SalesOrderHeader.MODIFY;
        END;
        
        SalesCommentLine.SETRANGE("Document Type","Document Type");
        SalesCommentLine.SETRANGE("No.","No.");
        IF NOT SalesCommentLine.ISEMPTY THEN BEGIN
          SalesCommentLine.LOCKTABLE;
          IF SalesCommentLine.FINDSET THEN
            REPEAT
              OldSalesCommentLine := SalesCommentLine;
              SalesCommentLine.DELETE;
              SalesCommentLine."Document Type" := SalesOrderHeader."Document Type";
              SalesCommentLine."No." := SalesOrderHeader."No.";
              SalesCommentLine.INSERT;
              SalesCommentLine := OldSalesCommentLine;
            UNTIL SalesCommentLine.NEXT = 0;
        END;
        SalesOrderHeader.COPYLINKS(Rec);
        
        ItemChargeAssgntSales.RESET;
        ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.","No.");
        WHILE ItemChargeAssgntSales.FINDFIRST DO BEGIN
          ItemChargeAssgntSales.DELETE;
          ItemChargeAssgntSales."Document Type" := SalesOrderHeader."Document Type";
          ItemChargeAssgntSales."Document No." := SalesOrderHeader."No.";
          IF NOT (ItemChargeAssgntSales."Applies-to Doc. Type" IN
                  [ItemChargeAssgntSales."Applies-to Doc. Type"::Shipment,
                   ItemChargeAssgntSales."Applies-to Doc. Type"::"Return Receipt"])
          THEN BEGIN
            ItemChargeAssgntSales."Applies-to Doc. Type" := SalesOrderHeader."Document Type";
            ItemChargeAssgntSales."Applies-to Doc. No." := SalesOrderHeader."No.";
          END;
          ItemChargeAssgntSales.INSERT;
        END;
        
        {GRN
        Opp.RESET;
        Opp.SETCURRENTKEY("Sales Document Type","Sales Document No.");
        Opp.SETRANGE("Sales Document Type",Opp."Sales Document Type"::"pre order");
        Opp.SETRANGE("Sales Document No.","No.");
        IF Opp.FINDFIRST THEN BEGIN
          IF Opp.Status = Opp.Status::Won THEN BEGIN
            Opp."Sales Document Type" := Opp."Sales Document Type"::Order;
            Opp."Sales Document No." := SalesOrderHeader."No.";
            Opp.MODIFY;
            OpportunityEntry.RESET;
            OpportunityEntry.SETCURRENTKEY(Active,"Opportunity No.");
            OpportunityEntry.SETRANGE(Active,TRUE);
            OpportunityEntry.SETRANGE("Opportunity No.",Opp."No.");
            IF OpportunityEntry.FINDFIRST THEN BEGIN
              OpportunityEntry."Calcd. Current Value (LCY)" := OpportunityEntry.GetSalesDocValue(SalesOrderHeader);
              OpportunityEntry.MODIFY;
            END;
          END ELSE IF Opp.Status = Opp.Status::Lost THEN BEGIN
            Opp."Sales Document Type" := Opp."Sales Document Type"::" ";
            Opp."Sales Document No." := '';
            Opp.MODIFY;
          END;
        END;
        }
        }
        
        */
        //fes mig

    end;
}

