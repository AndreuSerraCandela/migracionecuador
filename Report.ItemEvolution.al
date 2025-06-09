report 55015 "Item Evolution"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ItemEvolution.rdlc';
    Caption = 'Item Evolution';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            MaxIteration = 1;
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                if Item.GetFilter("No.") <> '' then
                    gItemInfo := Item."No." + ' ' + Item.Description;

                gDim1CodeName := GetDimCodeName(gDim1Code);
                gDim2CodeName := GetDimCodeName(gDim2Code);
                gDim3CodeName := GetDimCodeName(gDim3Code);
                gDim1ValueName := GetDimValueCodeName(gDim1Code, gDim1Value);
                gDim2ValueName := GetDimValueCodeName(gDim2Code, gDim2Value);
                gDim3ValueName := GetDimValueCodeName(gDim3Code, gDim3Value);
            end;
        }
        dataitem(Period; Date)
        {
            DataItemTableView = SORTING("Period Type", "Period Start") ORDER(Ascending) WHERE("Period Type" = CONST(Month));
            RequestFilterFields = "Period Start";
            column(HdrPeriodStartEnd; 'del ' + Format(Period.GetRangeMin("Period Start")) + ' al ' + Format(Period.GetRangeMax("Period Start")))
            {
            }
            column(HdrItemNoDescription; gItemInfo)
            {
            }
            column(HdrCompanyName; CompanyName)
            {
            }
            column(HdrDim1ValueCode; gDim1ValueName)
            {
            }
            column(HdrDim1Code; gDim1CodeName)
            {
            }
            column(HdrDim2Code; gDim2CodeName)
            {
            }
            column(HdrDim2ValueCode; gDim2ValueName)
            {
            }
            column(HdrDim3Code; gDim3CodeName)
            {
            }
            column(HdrDim3ValueCode; gDim3ValueName)
            {
            }
            column(NetTotal; gNetTotal)
            {
            }
            column(DiscountPercTotal; gDiscountTotal / gSalesTotal * 100)
            {
            }
            column(DiscountTotal; gDiscountTotal)
            {
            }
            column(GrossTotal; gGrossTotal)
            {
            }
            column(SalesTotal; gSalesTotal)
            {
            }
            column(BalanceTotal; gBalanceTotal)
            {
            }
            column(PurchasesTotal; gPurchasesTotal)
            {
            }
            column(CostTotal; gCostTotal)
            {
            }
            column(ReportTitle; ReportTitleLbl)
            {
            }
            column(HdrItemNoDescriptionCaption; HdrItemNoDescriptionCaptionLbl)
            {
            }
            column(HdrCompanyNameCaption; HdrCompanyNameCaptionLbl)
            {
            }
            column(PeriodYearNumberCaption; PeriodYearNumberCaptionLbl)
            {
            }
            column(ItemCostCaption; ItemCostCaptionLbl)
            {
            }
            column(PurchasesCaption; PurchasesCaptionLbl)
            {
            }
            column(SamplesCaption; SamplesCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(SalesCaption; SalesCaptionLbl)
            {
            }
            column(GrossCaption; GrossCaptionLbl)
            {
            }
            column(DiscountCaption; DiscountCaptionLbl)
            {
            }
            column(DiscountPercCaption; DiscountPercCaptionLbl)
            {
            }
            column(NetCaption; NetCaptionLbl)
            {
            }
            column(TotalGeneralCaption; TotalGeneralCaptionLbl)
            {
            }
            column(Period_Period_Type; "Period Type")
            {
            }
            column(Period_Period_Start; "Period Start")
            {
            }
            dataitem(ILE; "Item Ledger Entry")
            {
                DataItemTableView = SORTING("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date") ORDER(Ascending) WHERE("Entry Type" = FILTER(Purchase | Sale));

                trigger OnAfterGetRecord()
                begin
                    UpdateILELineTotals(ILE);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", Period."Period Start", CalcDate('+1M-1D', Period."Period Start"));
                    SetFilter("Item No.", Item.GetFilter("No."));
                end;
            }
            dataitem(PeriodLine; "Integer")
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(Cost; gCost)
                {
                }
                column(PeriodYearNumber; Format(Date2DMY(Period."Period Start", 3)) + ' ' + Format(Period."Period No."))
                {
                }
                column(Purchases; gPurchases)
                {
                }
                column(Samples; gSamples)
                {
                }
                column(Balance; gBalance)
                {
                }
                column(Net; gNet)
                {
                }
                column(Sales; gSales)
                {
                }
                column(Gross; gGross)
                {
                }
                column(Discount; gDiscount)
                {
                }
                column(DiscountPerc; gDiscountPerc)
                {
                }
                column(PeriodLine_Number; Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                gCost := 0;
                gPurchases := 0;
                gSamples := 0;
                gBalance := 0;
                gSales := 0;
                gGross := 0;
                gDiscount := 0;
                gDiscountPerc := 0;
                gNet := 0;
            end;

            trigger OnPreDataItem()
            begin
                if GetRangeMin("Period Start") = 0D then;
                if GetRangeMax("Period Start") = 0D then;

                gCostTotal := 0;
                gPurchasesTotal := 0;
                gBalanceTotal := 0;
                gSalesTotal := 0;
                gGrossTotal := 0;
                gDiscountTotal := 0;
                gNetTotal := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Dimension 1")
                {
                    Caption = 'Dimension 1';
                    field(gDim1Code; gDim1Code)
                    {
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            gDim1Code := LookUpDimCode();
                        end;
                    }
                    field(gDim1Value; gDim1Value)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            gDim1Value := LookUpDimValueCode(gDim1Code);
                        end;
                    }
                }
                group("Dimension 2")
                {

                    Caption = 'Dimension 2';
                    field(gDim2Code; gDim2Code)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            gDim2Code := LookUpDimCode();
                        end;
                    }
                    field(gDim2Value; gDim2Value)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            gDim2Value := LookUpDimValueCode(gDim2Code);
                        end;
                    }
                }
                group("Dimension 3")
                {
                    Caption = 'Dimension 3';
                    field(gDim3Code; gDim3Code)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            gDim3Code := LookUpDimCode();
                        end;
                    }
                    field(gDim3Value; gDim3Value)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            gDim3Value := LookUpDimValueCode(gDim3Code);
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        gPeriodStart: Date;
        gPeriodEnd: Date;
        gDim1Code: Code[20];
        gDim2Code: Code[20];
        gDim3Code: Code[20];
        gDim1Value: Code[20];
        gDim2Value: Code[20];
        gDim3Value: Code[20];
        gCost: Decimal;
        gPurchases: Decimal;
        gSales: Decimal;
        gDimMgmt: Codeunit DimensionManagement;
        gSamples: Decimal;
        gBalance: Decimal;
        gGross: Decimal;
        gDiscount: Decimal;
        gDiscountPerc: Decimal;
        gNet: Decimal;
        gCostTotal: Decimal;
        gPurchasesTotal: Decimal;
        gSalesTotal: Decimal;
        gBalanceTotal: Decimal;
        gGrossTotal: Decimal;
        gDiscountTotal: Decimal;
        gNetTotal: Decimal;
        gItemInfo: Text[100];
        gDim1CodeName: Text[100];
        gDim2CodeName: Text[100];
        gDim3CodeName: Text[100];
        gDim1ValueName: Text[100];
        gDim2ValueName: Text[100];
        gDim3ValueName: Text[100];
        ReportTitleLbl: Label 'EVOLUCION POR PRODUCTO';
        HdrItemNoDescriptionCaptionLbl: Label 'Producto';
        HdrCompanyNameCaptionLbl: Label 'Division';
        PeriodYearNumberCaptionLbl: Label 'Period';
        ItemCostCaptionLbl: Label 'Cost';
        PurchasesCaptionLbl: Label 'Purchases';
        SamplesCaptionLbl: Label 'Samples';
        BalanceCaptionLbl: Label 'Balance';
        SalesCaptionLbl: Label 'Sales';
        GrossCaptionLbl: Label 'Gross';
        DiscountCaptionLbl: Label 'Discount';
        DiscountPercCaptionLbl: Label 'Disc %';
        NetCaptionLbl: Label 'Net';
        TotalGeneralCaptionLbl: Label 'Total General';


    procedure LookUpDimCode() rCode: Code[20]
    var
        lDimension: Record Dimension;
    begin
        if PAGE.RunModal(0, lDimension) = ACTION::LookupOK then begin
            exit(lDimension.Code);
        end;
    end;


    procedure LookUpDimValueCode(pDimCode: Code[20]) rValueCode: Code[20]
    var
        lDimensionValue: Record "Dimension Value";
    begin
        lDimensionValue.SetRange("Dimension Code", pDimCode);
        if PAGE.RunModal(0, lDimensionValue) = ACTION::LookupOK then begin
            exit(lDimensionValue.Code);
        end;
    end;


    procedure LookUpItem() rItemNo: Code[20]
    var
        lItem: Record Item;
    begin
        if PAGE.RunModal(0, lItem) = ACTION::LookupOK then begin
            exit(lItem."No.");
        end;
    end;


    procedure UpdateILELineTotals(var pILE: Record "Item Ledger Entry")
    var
        lDefaultDim: Record "Default Dimension";
        lPurchases: Decimal;
        lSamples: Decimal;
        lBalance: Decimal;
        lSales: Decimal;
        lGross: Decimal;
        lNet: Decimal;
        lDiscount: Decimal;
        lDiscountPerc: Decimal;
        lValueEntry: Record "Value Entry";
    begin
        //Exclude entries that don't meet the dimension filtering criteria if any filter entered
        if gDim1Code <> '' then begin
            lDefaultDim.SetRange("Table ID", 27);
            lDefaultDim.SetRange("No.", pILE."Item No.");
            lDefaultDim.SetRange("Dimension Code", gDim1Code);
            lDefaultDim.SetRange("Dimension Value Code", gDim1Value);
            if not lDefaultDim.FindFirst then
                exit;
        end;

        if gDim2Code <> '' then begin
            lDefaultDim.SetRange("Table ID", 27);
            lDefaultDim.SetRange("No.", pILE."Item No.");
            lDefaultDim.SetRange("Dimension Code", gDim2Code);
            lDefaultDim.SetRange("Dimension Value Code", gDim2Value);
            if not lDefaultDim.FindFirst then
                exit;
        end;

        if gDim3Code <> '' then begin
            lDefaultDim.SetRange("Table ID", 27);
            lDefaultDim.SetRange("No.", pILE."Item No.");
            lDefaultDim.SetRange("Dimension Code", gDim3Code);
            lDefaultDim.SetRange("Dimension Value Code", gDim3Value);
            if not lDefaultDim.FindFirst then
                exit;
        end;

        lSamples := 0;
        lPurchases := 0;
        lBalance := 0;
        lSales := 0;
        lGross := 0;
        lNet := 0;
        lDiscount := 0;
        lDiscountPerc := 0;

        pILE.CalcFields("Cost Amount (Actual)", "Purchase Amount (Actual)", "Sales Amount (Actual)");
        gCost += pILE."Cost Amount (Actual)";
        lPurchases := pILE."Purchase Amount (Actual)";
        lSales := pILE."Sales Amount (Actual)";
        //lSamples := ???;
        lBalance := pILE."Remaining Quantity" * pILE."Precio Unitario Cons. Act.";

        if pILE."Entry Type" = pILE."Entry Type"::Sale then begin
            lValueEntry.Reset;
            lValueEntry.SetRange("Item Ledger Entry No.", pILE."Entry No.");
            lValueEntry.SetRange("Document Type", lValueEntry."Document Type"::"Sales Invoice");
            if lValueEntry.FindSet then
                repeat
                    lDiscount += lValueEntry."Discount Amount";
                until lValueEntry.Next = 0;
            if (lSales <> 0) and (lDiscount <> 0) then
                lDiscountPerc := (lDiscount / lSales * 100);
        end;
        lGross := (lPurchases + lSamples + lBalance + lSales);
        lNet := lGross - lDiscount;

        gPurchases += lPurchases;
        gSales += lSales;
        gSamples += lSamples;
        gBalance += lBalance;
        gDiscount += lDiscount;
        gDiscountPerc := lDiscountPerc;
        gGross += lGross;
        gNet += lNet;

        gPurchasesTotal += lPurchases;
        gSalesTotal += lSales;
        gBalanceTotal += lBalance;
        gDiscountTotal += lDiscount;

        gGrossTotal += lGross;
        gNetTotal += lNet;

    end;


    procedure GetDimCodeName(pDimCode: Code[20]) rText: Text[100]
    var
        lDimension: Record Dimension;
    begin
        if lDimension.Get(pDimCode) then
            exit(lDimension.Name);
    end;


    procedure GetDimValueCodeName(pDimCode: Code[20]; pDimValueCode: Code[20]) rText: Text[100]
    var
        lDimensionValue: Record "Dimension Value";
    begin
        if lDimensionValue.Get(pDimCode, pDimValueCode) then
            exit(lDimensionValue.Name);
    end;
}

