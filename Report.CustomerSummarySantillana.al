report 56112 "Customer-Summary (Santillana)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CustomerSummarySantillana.rdlc';
    Caption = 'Customer - Summary Aging Simp.';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group", "Statistics Group", "Payment Terms Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(STRSUBSTNO_Text001_FORMAT_StartDate__; StrSubstNo(Text001, Format(StartDate)))
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
            column(CustFilter; CustFilter)
            {
            }
            column(CustBalanceDueLCY_5_; CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4_; CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3_; CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2_; CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY120; CustBalanceDueLCY120)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY180; CustBalanceDueLCY180)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY270; CustBalanceDueLCY270)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCYMas270; CustBalanceDueLCYMas270)
            {
                AutoFormatType = 1;
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(CustBalanceDueLCY_5__Control25; CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4__Control26; CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3__Control27; CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2__Control28; CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY120_Control1000000005; CustBalanceDueLCY120)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY180_Control1000000009; CustBalanceDueLCY180)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY270_Control1000000013; CustBalanceDueLCY270)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCYMas270_Control1000000017; CustBalanceDueLCYMas270)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_5__Control31; CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4__Control32; CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3__Control33; CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2__Control34; CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY120_Control1000000006; CustBalanceDueLCY120)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY180_Control1000000010; CustBalanceDueLCY180)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY270_Control1000000014; CustBalanceDueLCY270)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCYMas270_Control1000000018; CustBalanceDueLCYMas270)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_5__Control37; CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4__Control38; CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3__Control39; CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2__Control40; CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY120_Control1000000007; CustBalanceDueLCY120)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY180_Control1000000011; CustBalanceDueLCY180)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY270_Control1000000015; CustBalanceDueLCY270)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCYMas270_Control1000000019; CustBalanceDueLCYMas270)
            {
                AutoFormatType = 1;
            }
            column(Customer___Summary_Aging_Simp_Caption; Customer___Summary_Aging_Simp_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(Customer__No__Caption; FieldCaption("No."))
            {
            }
            column(Customer_NameCaption; FieldCaption(Name))
            {
            }
            column(CustBalanceDueLCY_5__Control25Caption; CustBalanceDueLCY_5__Control25CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_4__Control26Caption; CustBalanceDueLCY_4__Control26CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_3__Control27Caption; CustBalanceDueLCY_3__Control27CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_2__Control28Caption; CustBalanceDueLCY_2__Control28CaptionLbl)
            {
            }
            column(V91_120Caption; V91_120CaptionLbl)
            {
            }
            column(V121_180Caption; V121_180CaptionLbl)
            {
            }
            column(V181_270Caption; V181_270CaptionLbl)
            {
            }
            column(Mas_270Caption; Mas_270CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_5_Caption; CustBalanceDueLCY_5_CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_5__Control31Caption; CustBalanceDueLCY_5__Control31CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PrintCust := false;
                for i := 1 to 5 do begin
                    DtldCustLedgEntry.SetCurrentKey("Customer No.", "Initial Entry Due Date", "Posting Date");
                    DtldCustLedgEntry.SetRange("Customer No.", "No.");
                    DtldCustLedgEntry.SetRange("Posting Date", 0D, StartDate);
                    DtldCustLedgEntry.SetRange("Initial Entry Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                    DtldCustLedgEntry.CalcSums("Amount (LCY)");
                    CustBalanceDueLCY[i] := DtldCustLedgEntry."Amount (LCY)";
                    if CustBalanceDueLCY[i] <> 0 then
                        PrintCust := true;
                end;

                //120
                DtldCustLedgEntry1.SetCurrentKey("Customer No.", "Initial Entry Due Date", "Posting Date");
                DtldCustLedgEntry1.SetRange("Customer No.", "No.");
                DtldCustLedgEntry1.SetRange("Posting Date", 0D, StartDate);
                DtldCustLedgEntry1.SetRange("Initial Entry Due Date", PeriodStartDate120, PeriodStartDate[2] - 1);
                DtldCustLedgEntry1.CalcSums("Amount (LCY)");
                CustBalanceDueLCY120 := DtldCustLedgEntry1."Amount (LCY)";

                //180
                DtldCustLedgEntry1.SetCurrentKey("Customer No.", "Initial Entry Due Date", "Posting Date");
                DtldCustLedgEntry1.SetRange("Customer No.", "No.");
                DtldCustLedgEntry1.SetRange("Posting Date", 0D, StartDate);
                DtldCustLedgEntry1.SetRange("Initial Entry Due Date", PeriodStartDate180, PeriodStartDate120 - 1);
                DtldCustLedgEntry1.CalcSums("Amount (LCY)");
                CustBalanceDueLCY180 := DtldCustLedgEntry1."Amount (LCY)";

                //270
                DtldCustLedgEntry1.SetCurrentKey("Customer No.", "Initial Entry Due Date", "Posting Date");
                DtldCustLedgEntry1.SetRange("Customer No.", "No.");
                DtldCustLedgEntry1.SetRange("Posting Date", 0D, StartDate);
                DtldCustLedgEntry1.SetRange("Initial Entry Due Date", PeriodStartDate270, PeriodStartDate180 - 1);
                DtldCustLedgEntry1.CalcSums("Amount (LCY)");
                CustBalanceDueLCY270 := DtldCustLedgEntry1."Amount (LCY)";

                //MAS 270
                DtldCustLedgEntry1.SetCurrentKey("Customer No.", "Initial Entry Due Date", "Posting Date");
                DtldCustLedgEntry1.SetRange("Customer No.", "No.");
                DtldCustLedgEntry1.SetRange("Posting Date", 0D, StartDate);
                DtldCustLedgEntry1.SetRange("Initial Entry Due Date", PeriodStartDate[1], PeriodStartDate270 - 1);
                DtldCustLedgEntry1.CalcSums("Amount (LCY)");
                CustBalanceDueLCYMas270 := DtldCustLedgEntry1."Amount (LCY)";


                if not PrintCust then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                //Comentado CurrReport.CreateTotals(CustBalanceDueLCY, CustBalanceDueLCY120, CustBalanceDueLCY180, CustBalanceDueLCY270, CustBalanceDueLCYMas270);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                    ApplicationArea = All;
                        Caption = 'Starting Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if StartDate = 0D then
                StartDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GetFilters;
        PeriodStartDate[5] := StartDate;
        PeriodStartDate[6] := 99991231D;
        for i := 4 downto 2 do
            PeriodStartDate[i] := CalcDate('<-30D>', PeriodStartDate[i + 1]);

        PeriodStartDate120 := CalcDate('<-30D>', PeriodStartDate[i]);
        PeriodStartDate180 := CalcDate('<-60D>', PeriodStartDate120);
        PeriodStartDate270 := CalcDate('<-90D>', PeriodStartDate180);
    end;

    var
        Text001: Label 'As of %1';
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        StartDate: Date;
        CustFilter: Text[250];
        PeriodStartDate: array[6] of Date;
        CustBalanceDueLCY: array[5] of Decimal;
        PrintCust: Boolean;
        i: Integer;
        CustBalanceDueLCY120: Decimal;
        CustBalanceDueLCY180: Decimal;
        CustBalanceDueLCY270: Decimal;
        CustBalanceDueLCYMas270: Decimal;
        PeriodStartDate120: Date;
        PeriodStartDate180: Date;
        PeriodStartDate270: Date;
        PeriodStartDateMas270: Date;
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        Customer___Summary_Aging_Simp_CaptionLbl: Label 'Customer - Summary Aging Simp.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in $';
        CustBalanceDueLCY_5__Control25CaptionLbl: Label 'Saldo';
        CustBalanceDueLCY_4__Control26CaptionLbl: Label '0-30 days';
        CustBalanceDueLCY_3__Control27CaptionLbl: Label '31-60 days';
        CustBalanceDueLCY_2__Control28CaptionLbl: Label '61-90 days';
        V91_120CaptionLbl: Label '91-120';
        V121_180CaptionLbl: Label '121-180';
        V181_270CaptionLbl: Label '181-270';
        Mas_270CaptionLbl: Label 'Mas 270';
        CustBalanceDueLCY_5_CaptionLbl: Label 'Continued';
        CustBalanceDueLCY_5__Control31CaptionLbl: Label 'Continued';
        TotalCaptionLbl: Label 'Total';
}

