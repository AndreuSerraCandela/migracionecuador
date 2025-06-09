report 56087 "Estadistica Venta"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EstadisticaVenta.rdlc';
    Caption = 'Sales Statistics';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group", "Currency Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter; Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(PeriodStartDate_2_; PeriodStartDate[2])
            {
            }
            column(PeriodStartDate_3_; PeriodStartDate[3])
            {
            }
            column(PeriodStartDate_4_; PeriodStartDate[4])
            {
            }
            column(PeriodStartDate_3__1; PeriodStartDate[3] - 1)
            {
            }
            column(PeriodStartDate_4__1; PeriodStartDate[4] - 1)
            {
            }
            column(PeriodStartDate_5__1; PeriodStartDate[5] - 1)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(CustSalesLCY_1_; CustSalesLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustSalesLCY_2_; CustSalesLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustSalesLCY_3_; CustSalesLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustSalesLCY_4_; CustSalesLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustSalesLCY_5_; CustSalesLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_1_; CustProfitLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_2_; CustProfitLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_3_; CustProfitLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_4_; CustProfitLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_5_; CustProfitLCY[5])
            {
                AutoFormatType = 1;
            }
            column(ProfitPct_1_; ProfitPct[1])
            {
                DecimalPlaces = 1 : 1;
            }
            column(ProfitPct_2_; ProfitPct[2])
            {
                DecimalPlaces = 1 : 1;
            }
            column(ProfitPct_3_; ProfitPct[3])
            {
                DecimalPlaces = 1 : 1;
            }
            column(ProfitPct_4_; ProfitPct[4])
            {
                DecimalPlaces = 1 : 1;
            }
            column(ProfitPct_5_; ProfitPct[5])
            {
                DecimalPlaces = 1 : 1;
            }
            column(CustInvDiscAmountLCY_1_; CustInvDiscAmountLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustInvDiscAmountLCY_2_; CustInvDiscAmountLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustInvDiscAmountLCY_3_; CustInvDiscAmountLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustInvDiscAmountLCY_4_; CustInvDiscAmountLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustInvDiscAmountLCY_5_; CustInvDiscAmountLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_1_; CustPaymentDiscLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_2_; CustPaymentDiscLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_3_; CustPaymentDiscLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_4_; CustPaymentDiscLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_5_; CustPaymentDiscLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_2_; CustPaymentDiscTolLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_3_; CustPaymentDiscTolLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_4_; CustPaymentDiscTolLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_5_; CustPaymentDiscTolLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_1_; CustPaymentDiscTolLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_2_; CustPaymentTolLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_3_; CustPaymentTolLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_4_; CustPaymentTolLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_5_; CustPaymentTolLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_1_; CustPaymentTolLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustSalesLCY_1__Control52; CustSalesLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustSalesLCY_2__Control53; CustSalesLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustSalesLCY_3__Control54; CustSalesLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustSalesLCY_4__Control55; CustSalesLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustSalesLCY_5__Control56; CustSalesLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_1__Control58; CustProfitLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_2__Control59; CustProfitLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_3__Control60; CustProfitLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_4__Control61; CustProfitLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustProfitLCY_5__Control62; CustProfitLCY[5])
            {
                AutoFormatType = 1;
            }
            column(ProfitPct_1__Control64; ProfitPct[1])
            {
                DecimalPlaces = 1 : 1;
            }
            column(ProfitPct_2__Control65; ProfitPct[2])
            {
                DecimalPlaces = 1 : 1;
            }
            column(ProfitPct_3__Control66; ProfitPct[3])
            {
                DecimalPlaces = 1 : 1;
            }
            column(ProfitPct_4__Control67; ProfitPct[4])
            {
                DecimalPlaces = 1 : 1;
            }
            column(ProfitPct_5__Control68; ProfitPct[5])
            {
                DecimalPlaces = 1 : 1;
            }
            column(CustInvDiscAmountLCY_1__Control70; CustInvDiscAmountLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustInvDiscAmountLCY_2__Control71; CustInvDiscAmountLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustInvDiscAmountLCY_3__Control72; CustInvDiscAmountLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustInvDiscAmountLCY_4__Control73; CustInvDiscAmountLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustInvDiscAmountLCY_5__Control74; CustInvDiscAmountLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_1__Control76; CustPaymentDiscLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_2__Control77; CustPaymentDiscLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_3__Control78; CustPaymentDiscLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_4__Control79; CustPaymentDiscLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscLCY_5__Control80; CustPaymentDiscLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_1__Control93; CustPaymentDiscTolLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_5__Control94; CustPaymentTolLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_4__Control95; CustPaymentTolLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_4__Control96; CustPaymentDiscTolLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_5__Control97; CustPaymentDiscTolLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_3__Control98; CustPaymentDiscTolLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_3__Control99; CustPaymentTolLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentDiscTolLCY_2__Control100; CustPaymentDiscTolLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_2__Control101; CustPaymentTolLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustPaymentTolLCY_1__Control102; CustPaymentTolLCY[1])
            {
                AutoFormatType = 1;
            }
            column(Sales_StatisticsCaption; Sales_StatisticsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption; FieldCaption("No."))
            {
            }
            column(Customer_NameCaption; FieldCaption(Name))
            {
            }
            column(beforeCaption; beforeCaptionLbl)
            {
            }
            column(after___Caption; after___CaptionLbl)
            {
            }
            column(CustSalesLCY_1_Caption; CustSalesLCY_1_CaptionLbl)
            {
            }
            column(CustProfitLCY_1_Caption; CustProfitLCY_1_CaptionLbl)
            {
            }
            column(ProfitPct_1_Caption; ProfitPct_1_CaptionLbl)
            {
            }
            column(CustInvDiscAmountLCY_1_Caption; CustInvDiscAmountLCY_1_CaptionLbl)
            {
            }
            column(CustPaymentDiscLCY_1_Caption; CustPaymentDiscLCY_1_CaptionLbl)
            {
            }
            column(CustPaymentDiscTolLCY_1_Caption; CustPaymentDiscTolLCY_1_CaptionLbl)
            {
            }
            column(CustPaymentTolLCY_1_Caption; CustPaymentTolLCY_1_CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(CustSalesLCY_1__Control52Caption; CustSalesLCY_1__Control52CaptionLbl)
            {
            }
            column(CustProfitLCY_1__Control58Caption; CustProfitLCY_1__Control58CaptionLbl)
            {
            }
            column(ProfitPct_1__Control64Caption; ProfitPct_1__Control64CaptionLbl)
            {
            }
            column(CustInvDiscAmountLCY_1__Control70Caption; CustInvDiscAmountLCY_1__Control70CaptionLbl)
            {
            }
            column(CustPaymentDiscLCY_1__Control76Caption; CustPaymentDiscLCY_1__Control76CaptionLbl)
            {
            }
            column(CustPaymentDiscTolLCY_1__Control93Caption; CustPaymentDiscTolLCY_1__Control93CaptionLbl)
            {
            }
            column(CustPaymentTolLCY_1__Control102Caption; CustPaymentTolLCY_1__Control102CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PrintCust := false;
                for i := 1 to 5 do begin
                    SetRange("Date Filter", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                    CalcFields(
                      "Sales (LCY)", "Profit (LCY)", "Inv. Discounts (LCY)", "Pmt. Discounts (LCY)",
                      "Pmt. Disc. Tolerance (LCY)", "Pmt. Tolerance (LCY)");
                    CustSalesLCY[i] := "Sales (LCY)";
                    CustProfitLCY[i] := "Profit (LCY)";
                    if CustSalesLCY[i] = 0 then
                        ProfitPct[i] := 0
                    else
                        ProfitPct[i] := CustProfitLCY[i] / CustSalesLCY[i] * 100;
                    CustInvDiscAmountLCY[i] := "Inv. Discounts (LCY)";
                    CustPaymentDiscLCY[i] := "Pmt. Discounts (LCY)";
                    CustPaymentDiscTolLCY[i] := "Pmt. Disc. Tolerance (LCY)";
                    CustPaymentTolLCY[i] := "Pmt. Tolerance (LCY)";
                    if (CustSalesLCY[i] <> 0) or (CustProfitLCY[i] <> 0) or
                      (CustInvDiscAmountLCY[i] <> 0) or (CustPaymentDiscLCY[i] <> 0) or
                        (CustPaymentDiscTolLCY[i] <> 0) or (CustPaymentTolLCY[i] <> 0)
                    then
                        PrintCust := true;
                end;
                if not PrintCust then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                //ComentadoCurrReport.CreateTotals(CustSalesLCY, CustProfitLCY, CustInvDiscAmountLCY, CustPaymentDiscLCY, CustPaymentDiscTolLCY, CustPaymentTolLCY);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha inicial"; PeriodStartDate[2])
                {
                ApplicationArea = All;
                }
                field(Periodo; PeriodLength)
                {
                ApplicationArea = All;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PeriodStartDate[2] = 0D then
                PeriodStartDate[2] := WorkDate;
            if Format(PeriodLength) = '' then
                Evaluate(PeriodLength, '<1M>');
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GetFilters;
        for i := 2 to 4 do
            PeriodStartDate[i + 1] := CalcDate(PeriodLength, PeriodStartDate[i]);
        PeriodStartDate[6] := 99991231D;
    end;

    var
        PeriodLength: DateFormula;
        CustFilter: Text[250];
        ProfitPct: array[5] of Decimal;
        PeriodStartDate: array[6] of Date;
        CustProfitLCY: array[5] of Decimal;
        CustInvDiscAmountLCY: array[5] of Decimal;
        CustPaymentDiscLCY: array[5] of Decimal;
        CustPaymentDiscTolLCY: array[5] of Decimal;
        CustPaymentTolLCY: array[5] of Decimal;
        CustSalesLCY: array[5] of Decimal;
        PrintCust: Boolean;
        i: Integer;
        Sales_StatisticsCaptionLbl: Label 'Sales Statistics';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        beforeCaptionLbl: Label '...before';
        after___CaptionLbl: Label 'after...';
        CustSalesLCY_1_CaptionLbl: Label 'Sales (LCY)';
        CustProfitLCY_1_CaptionLbl: Label 'Profit (LCY)';
        ProfitPct_1_CaptionLbl: Label 'Profit %';
        CustInvDiscAmountLCY_1_CaptionLbl: Label 'Inv. Discounts (LCY)';
        CustPaymentDiscLCY_1_CaptionLbl: Label 'Pmt. Discounts (LCY)';
        CustPaymentDiscTolLCY_1_CaptionLbl: Label 'Pmt. Disc Tol. (LCY)';
        CustPaymentTolLCY_1_CaptionLbl: Label 'Pmt. Tolerances (LCY)';
        TotalCaptionLbl: Label 'Total';
        CustSalesLCY_1__Control52CaptionLbl: Label 'Sales (LCY)';
        CustProfitLCY_1__Control58CaptionLbl: Label 'Profit (LCY)';
        ProfitPct_1__Control64CaptionLbl: Label 'Profit %';
        CustInvDiscAmountLCY_1__Control70CaptionLbl: Label 'Inv. Discounts (LCY)';
        CustPaymentDiscLCY_1__Control76CaptionLbl: Label 'Pmt. Discounts (LCY)';
        CustPaymentDiscTolLCY_1__Control93CaptionLbl: Label 'Pmt. Disc Tol. (LCY)';
        CustPaymentTolLCY_1__Control102CaptionLbl: Label 'Pmt. Tolerances (LCY)';
}

