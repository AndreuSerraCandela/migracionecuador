report 56117 "Antiguedad Cobros Formato Exce"
{
    // #3143 Se define un valor por defecto para la longitud del periodo. Se valida que tenga contenido.
    DefaultLayout = RDLC;
    RDLCLayout = './AntiguedadCobrosFormatoExce.rdlc';

    Caption = 'Aged Accounts Receivable (EXCEL)';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(STRSUBSTNO_Text006_FORMAT_EndingDate_0_4__; StrSubstNo(Text006, Format(EndingDate, 0, 4)))
            {
            }
            column(STRSUBSTNO_Text007_SELECTSTR_AgingBy___1_Text009__; StrSubstNo(Text007, SelectStr(AgingBy + 1, Text009)))
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(AgingBy; AgingBy)
            {
            }
            column(TABLECAPTION__________CustFilter; TableCaption + ': ' + CustFilter)
            {
            }
            column(EmptyString; '')
            {
            }
            column(EmptyString_Control56; '')
            {
            }
            column(STRSUBSTNO_Text004_SELECTSTR_AgingBy___1_Text009__; StrSubstNo(Text004, SelectStr(AgingBy + 1, Text009)))
            {
            }
            column(HeaderText_5_; HeaderText[5])
            {
            }
            column(HeaderText_4_; HeaderText[4])
            {
            }
            column(HeaderText_3_; HeaderText[3])
            {
            }
            column(HeaderText_2_; HeaderText[2])
            {
            }
            column(HeaderText_1_; HeaderText[1])
            {
            }
            column(GrandTotalCustLedgEntry_5___Remaining_Amt___LCY__; GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCustLedgEntry_4___Remaining_Amt___LCY__; GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCustLedgEntry_3___Remaining_Amt___LCY__; GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCustLedgEntry_2___Remaining_Amt___LCY__; GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCustLedgEntry_1___Remaining_Amt___LCY__; GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCustLedgEntry_1___Amount__LCY__; GrandTotalCustLedgEntry[1]."Amount (LCY)")
            {
                AutoFormatType = 1;
            }
            column(Pct_GrandTotalCustLedgEntry_1___Remaining_Amt___LCY___GrandTotalCustLedgEntry_1___Amount__LCY___; Pct(GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(Pct_GrandTotalCustLedgEntry_2___Remaining_Amt___LCY___GrandTotalCustLedgEntry_1___Amount__LCY___; Pct(GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(Pct_GrandTotalCustLedgEntry_3___Remaining_Amt___LCY___GrandTotalCustLedgEntry_1___Amount__LCY___; Pct(GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(Pct_GrandTotalCustLedgEntry_4___Remaining_Amt___LCY___GrandTotalCustLedgEntry_1___Amount__LCY___; Pct(GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(Pct_GrandTotalCustLedgEntry_5___Remaining_Amt___LCY___GrandTotalCustLedgEntry_1___Amount__LCY___; Pct(GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(Aged_Accounts_ReceivableCaption; Aged_Accounts_ReceivableCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_Amounts_in_LCYCaption; All_Amounts_in_LCYCaptionLbl)
            {
            }
            column(Aged_Overdue_AmountsCaption; Aged_Overdue_AmountsCaptionLbl)
            {
            }
            column(Original_Amount_Control58Caption; Original_Amount_Control58CaptionLbl)
            {
            }
            column(CustLedgEntryEndingDate__Remaining_Amt___LCY__Caption; CustLedgEntryEndingDate__Remaining_Amt___LCY__CaptionLbl)
            {
            }
            column(CustLedgEntryEndingDate__Due_Date_Caption; CustLedgEntryEndingDate__Due_Date_CaptionLbl)
            {
            }
            column(CustLedgEntryEndingDate__Document_No__Caption; CustLedgEntryEndingDate__Document_No__CaptionLbl)
            {
            }
            column(CustLedgEntryEndingDate__Posting_Date_Caption; CustLedgEntryEndingDate__Posting_Date_CaptionLbl)
            {
            }
            column(FORMAT_CustLedgEntryEndingDate__Document_Type__Caption; FORMAT_CustLedgEntryEndingDate__Document_Type__CaptionLbl)
            {
            }
            column(No__ClienteCaption; No__ClienteCaptionLbl)
            {
            }
            column(NombreCaption; NombreCaptionLbl)
            {
            }
            column(Total__LCY_Caption; Total__LCY_CaptionLbl)
            {
            }
            column(Customer_No_; "No.")
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD ("No.");
                DataItemTableView = SORTING ("Customer No.", "Posting Date", "Currency Code");

                trigger OnAfterGetRecord()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.SetCurrentKey("Closed by Entry No.");
                    CustLedgEntry.SetRange("Closed by Entry No.", "Entry No.");
                    CustLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                    if CustLedgEntry.Find('-') then
                        repeat
                            InsertTemp(CustLedgEntry);
                        until CustLedgEntry.Next = 0;

                    CustLedgEntry.Reset;
                    CustLedgEntry.SetRange("Entry No.", "Closed by Entry No.");
                    CustLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                    if CustLedgEntry.Find('-') then
                        repeat
                            InsertTemp(CustLedgEntry);
                        until CustLedgEntry.Next = 0;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", EndingDate + 1, 99991231D);
                end;
            }
            dataitem(OpenCustLedgEntry; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD ("No.");
                DataItemTableView = SORTING ("Customer No.", Open, Positive, "Due Date", "Currency Code") WHERE (Open = CONST (true));

                trigger OnAfterGetRecord()
                begin
                    InsertTemp(OpenCustLedgEntry);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", 0D, EndingDate);
                end;
            }
            dataitem(CurrencyLoop; "Integer")
            {
                DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));
                PrintOnlyIfDetail = true;
                dataitem(TempCustLedgEntryLoop; "Integer")
                {
                    DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));
                    column(CustLedgEntryEndingDate__Amount__LCY__; CustLedgEntryEndingDate."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCustLedgEntry_1___Remaining_Amt___LCY__; AgedCustLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCustLedgEntry_2___Remaining_Amt___LCY__; AgedCustLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCustLedgEntry_3___Remaining_Amt___LCY__; AgedCustLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCustLedgEntry_4___Remaining_Amt___LCY__; AgedCustLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCustLedgEntry_5___Remaining_Amt___LCY__; AgedCustLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(CustLedgEntryEndingDate__Remaining_Amt___LCY__; CustLedgEntryEndingDate."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(CustLedgEntryEndingDate__Due_Date_; CustLedgEntryEndingDate."Due Date")
                    {
                    }
                    column(CustLedgEntryEndingDate__Document_No__; CustLedgEntryEndingDate."Document No.")
                    {
                    }
                    column(FORMAT_CustLedgEntryEndingDate__Document_Type__; Format(CustLedgEntryEndingDate."Document Type"))
                    {
                    }
                    column(CustLedgEntryEndingDate__Posting_Date_; CustLedgEntryEndingDate."Posting Date")
                    {
                    }
                    column(Customer__No__; Customer."No.")
                    {
                    }
                    column(Customer_Name; Customer.Name)
                    {
                    }
                    column(AgedCustLedgEntry_5___Remaining_Amount_; AgedCustLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCustLedgEntry_4___Remaining_Amount_; AgedCustLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCustLedgEntry_3___Remaining_Amount_; AgedCustLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCustLedgEntry_2___Remaining_Amount_; AgedCustLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCustLedgEntry_1___Remaining_Amount_; AgedCustLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CustLedgEntryEndingDate_Amount; CustLedgEntryEndingDate.Amount)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CustLedgEntryEndingDate__Remaining_Amount_; CustLedgEntryEndingDate."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CustLedgEntryEndingDate__Due_Date__Control96; CustLedgEntryEndingDate."Due Date")
                    {
                    }
                    column(CustLedgEntryEndingDate__Document_No___Control97; CustLedgEntryEndingDate."Document No.")
                    {
                    }
                    column(FORMAT_CustLedgEntryEndingDate__Document_Type___Control98; Format(CustLedgEntryEndingDate."Document Type"))
                    {
                    }
                    column(CustLedgEntryEndingDate__Posting_Date__Control99; CustLedgEntryEndingDate."Posting Date")
                    {
                    }
                    column(Customer__No___Control1000000001; Customer."No.")
                    {
                    }
                    column(Customer_Name_Control1000000003; Customer.Name)
                    {
                    }
                    column(STRSUBSTNO_Text005_Customer_Name_; StrSubstNo(Text005, Customer.Name))
                    {
                    }
                    column(TotalCustLedgEntry_1___Amount__LCY__; TotalCustLedgEntry[1]."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_1___Remaining_Amt___LCY__; TotalCustLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_2___Remaining_Amt___LCY__; TotalCustLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_3___Remaining_Amt___LCY__; TotalCustLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_4___Remaining_Amt___LCY__; TotalCustLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_5___Remaining_Amt___LCY__; TotalCustLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(CurrencyCode; CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(STRSUBSTNO_Text005_Customer_Name__Control101; StrSubstNo(Text005, Customer.Name))
                    {
                    }
                    column(TotalCustLedgEntry_5___Remaining_Amount_; TotalCustLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_4___Remaining_Amount_; TotalCustLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_3___Remaining_Amount_; TotalCustLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_2___Remaining_Amount_; TotalCustLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_1___Remaining_Amount_; TotalCustLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_1__Amount; TotalCustLedgEntry[1].Amount)
                    {
                        AutoFormatType = 1;
                    }
                    column(Customer__No___Control9; Customer."No.")
                    {
                    }
                    column(Customer_Name_Control15; Customer.Name)
                    {
                    }
                    column(TotalCustLedgEntry_1___Amount__LCY___Control17; TotalCustLedgEntry[1]."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_1___Remaining_Amt___LCY___Control18; TotalCustLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_2___Remaining_Amt___LCY___Control19; TotalCustLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_3___Remaining_Amt___LCY___Control20; TotalCustLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_4___Remaining_Amt___LCY___Control22; TotalCustLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_5___Remaining_Amt___LCY___Control23; TotalCustLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(Customer_Contact; Customer.Contact)
                    {
                    }
                    column(Customer__Phone_No__; Customer."Phone No.")
                    {
                    }
                    column(TotalCustLedgEntry_1__Amount_Control24; TotalCustLedgEntry[1].Amount)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_1___Remaining_Amount__Control25; TotalCustLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_2___Remaining_Amount__Control26; TotalCustLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_3___Remaining_Amount__Control27; TotalCustLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_4___Remaining_Amount__Control28; TotalCustLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalCustLedgEntry_5___Remaining_Amount__Control29; TotalCustLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(Customer_Name_Control30; Customer.Name)
                    {
                    }
                    column(Customer__No___Control31; Customer."No.")
                    {
                    }
                    column(CurrencyCode_Control32; CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(Customer_Contact_Control1103350005; Customer.Contact)
                    {
                    }
                    column(Customer__Phone_No___Control1103350002; Customer."Phone No.")
                    {
                    }
                    column(TempCustLedgEntryLoop_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        CustLedgEntry: Record "Cust. Ledger Entry";
                        PeriodIndex: Integer;
                    begin
                        if Number = 1 then begin
                            if not TempCustLedgEntry.Find('-') then
                                CurrReport.Break;
                        end else
                            if TempCustLedgEntry.Next = 0 then
                                CurrReport.Break;

                        TempCustLedgEntry.SetRange("Date Filter", 0D, EndingDate);
                        TempCustLedgEntry.CalcFields(Amount, "Amount (LCY)");
                        if TempCustLedgEntry.Amount = 0 then
                            CurrReport.Skip;

                        CustLedgEntryEndingDate := TempCustLedgEntry;
                        CustLedgEntryEndingDate."Remaining Amount" := TempCustLedgEntry.Amount;
                        CustLedgEntryEndingDate."Remaining Amt. (LCY)" := TempCustLedgEntry."Amount (LCY)";

                        CustLedgEntry.SetCurrentKey("Closed by Entry No.");
                        CustLedgEntry.SetRange("Closed by Entry No.", TempCustLedgEntry."Entry No.");
                        CustLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                        if CustLedgEntry.Find('-') then
                            repeat
                                CustLedgEntry.CalcFields(Amount);
                                if CustLedgEntry.Amount <> 0 then begin
                                    CustLedgEntryEndingDate."Remaining Amount" += CustLedgEntry."Closed by Currency Amount";
                                    CustLedgEntryEndingDate."Remaining Amt. (LCY)" += CustLedgEntry."Closed by Amount (LCY)";
                                end;
                            until CustLedgEntry.Next = 0;
                        CustLedgEntry.Reset;
                        CustLedgEntry.SetRange("Entry No.", TempCustLedgEntry."Closed by Entry No.");
                        CustLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                        if CustLedgEntry.Find('-') then
                            repeat
                                CustLedgEntry.CalcFields(Amount);
                                if CustLedgEntry.Amount <> 0 then begin
                                    CustLedgEntryEndingDate."Remaining Amount" -= CustLedgEntry."Closed by Amount";
                                    CustLedgEntryEndingDate."Remaining Amt. (LCY)" -= CustLedgEntry."Closed by Amount (LCY)";
                                end;
                            until CustLedgEntry.Next = 0;

                        case AgingBy of
                            AgingBy::"Due Date":
                                PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Due Date");
                            AgingBy::"Posting Date":
                                PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Posting Date");
                            AgingBy::"Document Date":
                                PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Document Date");
                        end;
                        Clear(AgedCustLedgEntry);
                        AgedCustLedgEntry[PeriodIndex]."Remaining Amount" := CustLedgEntryEndingDate."Remaining Amount";
                        AgedCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalCustLedgEntry[PeriodIndex]."Remaining Amount" += CustLedgEntryEndingDate."Remaining Amount";
                        TotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalCustLedgEntry[1].Amount += CustLedgEntryEndingDate."Remaining Amount";
                        TotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                    end;

                    trigger OnPostDataItem()
                    begin
                        if not PrintAmountInLCY then
                            UpdateCurrencyTotals;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not PrintAmountInLCY then
                            TempCustLedgEntry.SetRange("Currency Code", TempCurrency.Code);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(TotalCustLedgEntry);

                    if Number = 1 then begin
                        if not TempCurrency.Find('-') then
                            CurrReport.Break;
                    end else
                        if TempCurrency.Next = 0 then
                            CurrReport.Break;

                    if TempCurrency.Code <> '' then
                        CurrencyCode := TempCurrency.Code
                    else
                        CurrencyCode := GLSetup."LCY Code";

                    NumberOfCurrencies := NumberOfCurrencies + 1;
                end;

                trigger OnPostDataItem()
                begin
/*                     if NewPagePercustomer and (NumberOfCurrencies > 0) then
                        CurrReport.NewPage; */
                end;

                trigger OnPreDataItem()
                begin
                    NumberOfCurrencies := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TempCurrency.Reset;
                TempCurrency.DeleteAll;
                TempCustLedgEntry.Reset;
                TempCustLedgEntry.DeleteAll;
            end;
        }
        dataitem(CurrencyTotals; "Integer")
        {
            DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));
            column(TempCurrency2_Code; TempCurrency2.Code)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_6___Remaining_Amount_; AgedCustLedgEntry[6]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_1___Remaining_Amount__Control120; AgedCustLedgEntry[1]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_2___Remaining_Amount__Control121; AgedCustLedgEntry[2]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_3___Remaining_Amount__Control122; AgedCustLedgEntry[3]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_4___Remaining_Amount__Control123; AgedCustLedgEntry[4]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_5___Remaining_Amount__Control124; AgedCustLedgEntry[5]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(CurrencyTotals_Number; Number)
            {
            }
            column(TempCurrency2_Code_Control118; TempCurrency2.Code)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_1___Remaining_Amount__Control109; AgedCustLedgEntry[1]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_5___Remaining_Amount__Control112; AgedCustLedgEntry[5]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_4___Remaining_Amount__Control113; AgedCustLedgEntry[4]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(Original_Amount; AgedCustLedgEntry[3]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(Original_Amount_Control115; AgedCustLedgEntry[2]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCustLedgEntry_6___Remaining_Amount__Control116; AgedCustLedgEntry[6]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(Currency_SpecificationCaption; Currency_SpecificationCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    if not TempCurrency2.Find('-') then
                        CurrReport.Break;
                end else
                    if TempCurrency2.Next = 0 then
                        CurrReport.Break;

                Clear(AgedCustLedgEntry);
                TempCurrencyAmount.SetRange("Currency Code", TempCurrency2.Code);
                if TempCurrencyAmount.Find('-') then
                    repeat
                        if TempCurrencyAmount.Date <> 99991231D then
                            AgedCustLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                              TempCurrencyAmount.Amount
                        else
                            AgedCustLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
                    until TempCurrencyAmount.Next = 0;
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
                group(Opciones)
                {
                    Caption = 'Opciones';
                    field(EndingDate; EndingDate)
                    {
                    ApplicationArea = All;
                        Caption = 'Vencido desde';
                    }
                    field(AgingBy; AgingBy)
                    {
                    ApplicationArea = All;
                        Caption = 'Vencido por';
                        OptionCaption = 'Fecha vencimiento,Fecha registro,Fecha emisión documento';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                    ApplicationArea = All;
                        Caption = 'Long. períodos antigüedad';
                    }
                    field(PrintAmountInLCY; PrintAmountInLCY)
                    {
                    ApplicationArea = All;
                        Caption = 'Imprimir importes en DL';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                    ApplicationArea = All;
                        Caption = 'Imprimir detalles';
                    }
                    field(HeadingType; HeadingType)
                    {
                    ApplicationArea = All;
                        Caption = 'Tipo cabecera';
                        OptionCaption = 'Date Interval,Number of Days';
                    }
                    field(NewPagePercustomer; NewPagePercustomer)
                    {
                    ApplicationArea = All;
                        Caption = 'Página nueva por cliente';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if EndingDate = 0D then
                EndingDate := WorkDate;


            if Format(PeriodLength) = '' then
                Evaluate(PeriodLength, '1M');
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GetFilters;

        GLSetup.Get;

        CalcDates;
        CreateHeadings;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustLedgEntryEndingDate: Record "Cust. Ledger Entry";
        TotalCustLedgEntry: array[5] of Record "Cust. Ledger Entry";
        GrandTotalCustLedgEntry: array[5] of Record "Cust. Ledger Entry";
        AgedCustLedgEntry: array[6] of Record "Cust. Ledger Entry";
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        CustFilter: Text[250];
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        PeriodLength: DateFormula;
        PrintDetails: Boolean;
        HeadingType: Option "Date Interval","Number of Days";
        NewPagePercustomer: Boolean;
        PeriodStartDate: array[5] of Date;
        PeriodEndDate: array[5] of Date;
        HeaderText: array[5] of Text[30];
        Text000: Label 'Not Due';
        Text001: Label 'Before';
        CurrencyCode: Code[10];
        Text002: Label 'days';
        Text003: Label 'More than';
        Text004: Label 'Aged by %1';
        Text005: Label 'Total for %1';
        Text006: Label 'Aged as of %1';
        Text007: Label 'Aged by %1';
        Text008: Label 'All Amounts in LCY';
        NumberOfCurrencies: Integer;
        Text009: Label 'Due Date,Posting Date,Document Date';
        Text010: Label 'The Date Formula %1 cannot be used. Try to restate it. E.g. 1M+CM instead of CM+1M.';
        Aged_Accounts_ReceivableCaptionLbl: Label 'Aged Accounts Receivable';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_Amounts_in_LCYCaptionLbl: Label 'All Amounts in LCY';
        Aged_Overdue_AmountsCaptionLbl: Label 'Aged Overdue Amounts';
        Original_Amount_Control58CaptionLbl: Label 'Balance';
        CustLedgEntryEndingDate__Remaining_Amt___LCY__CaptionLbl: Label 'Original Amount ';
        CustLedgEntryEndingDate__Due_Date_CaptionLbl: Label 'Due Date';
        CustLedgEntryEndingDate__Document_No__CaptionLbl: Label 'Document No.';
        CustLedgEntryEndingDate__Posting_Date_CaptionLbl: Label 'Posting Date';
        FORMAT_CustLedgEntryEndingDate__Document_Type__CaptionLbl: Label 'Document Type';
        No__ClienteCaptionLbl: Label 'No. Cliente';
        NombreCaptionLbl: Label 'Nombre';
        Total__LCY_CaptionLbl: Label 'Total (LCY)';
        Currency_SpecificationCaptionLbl: Label 'Currency Specification';

    local procedure CalcDates()
    var
        i: Integer;
        PeriodLength2: DateFormula;
        lText001: Label 'Es obligatorio introducir la longitud del periodo.';
    begin


        //#3143
        if Format(PeriodLength) = '' then
            Error(lText001);
        //#3143


        Evaluate(PeriodLength2, '-' + Format(PeriodLength));
        if AgingBy = AgingBy::"Due Date" then begin
            PeriodEndDate[1] := 99991231D;
            PeriodStartDate[1] := EndingDate + 1;
        end else begin
            PeriodEndDate[1] := EndingDate;
            PeriodStartDate[1] := CalcDate(PeriodLength2, EndingDate) + 1;
        end;
        for i := 2 to ArrayLen(PeriodEndDate) do begin
            PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
            PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i]) + 1;
        end;
        PeriodStartDate[i] := 0D;

        for i := 1 to ArrayLen(PeriodEndDate) do
            if PeriodEndDate[i] < PeriodStartDate[i] then
                Error(Text010, PeriodLength);
    end;

    local procedure CreateHeadings()
    var
        i: Integer;
    begin
        if AgingBy = AgingBy::"Due Date" then begin
            HeaderText[1] := Text000;
            i := 2;
        end else
            i := 1;
        while i < ArrayLen(PeriodEndDate) do begin
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
            else
                HeaderText[i] :=
                  StrSubstNo('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
            i := i + 1;
        end;
        if HeadingType = HeadingType::"Date Interval" then
            HeaderText[i] := StrSubstNo('%1 %2', Text001, PeriodStartDate[i - 1])
        else
            HeaderText[i] := StrSubstNo('%1 \%2 %3', Text003, EndingDate - PeriodStartDate[i - 1] + 1, Text002);
    end;

    local procedure InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        Currency: Record Currency;
    begin
        if TempCustLedgEntry.Get(CustLedgEntry."Entry No.") then
            exit;
        TempCustLedgEntry := CustLedgEntry;
        TempCustLedgEntry.Insert;
        if PrintAmountInLCY then begin
            Clear(TempCurrency);
            TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            if TempCurrency.Insert then;
            exit;
        end;
        if TempCurrency.Get(TempCustLedgEntry."Currency Code") then
            exit;
        if TempCustLedgEntry."Currency Code" <> '' then
            Currency.Get(TempCustLedgEntry."Currency Code")
        else begin
            Clear(Currency);
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        end;
        TempCurrency := Currency;
        TempCurrency.Insert;
    end;

    local procedure GetPeriodIndex(Date: Date): Integer
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(PeriodEndDate) do
            if Date in [PeriodStartDate[i] .. PeriodEndDate[i]] then
                exit(i);
    end;

    local procedure Pct(a: Decimal; b: Decimal): Text[30]
    begin
        if b <> 0 then
            exit(Format(Round(100 * a / b, 0.1), 0, '<Sign><Integer><Decimals,2>') + '%');
    end;

    local procedure UpdateCurrencyTotals()
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        if TempCurrency2.Insert then;
        for i := 1 to ArrayLen(TotalCustLedgEntry) do begin
            TempCurrencyAmount."Currency Code" := CurrencyCode;
            TempCurrencyAmount.Date := PeriodStartDate[i];
            if TempCurrencyAmount.Find then begin
                TempCurrencyAmount.Amount := TempCurrencyAmount.Amount + TotalCustLedgEntry[i]."Remaining Amount";
                TempCurrencyAmount.Modify;
            end else begin
                TempCurrencyAmount."Currency Code" := CurrencyCode;
                TempCurrencyAmount.Date := PeriodStartDate[i];
                TempCurrencyAmount.Amount := TotalCustLedgEntry[i]."Remaining Amount";
                TempCurrencyAmount.Insert;
            end;
        end;
        TempCurrencyAmount."Currency Code" := CurrencyCode;
        TempCurrencyAmount.Date := 99991231D;
        if TempCurrencyAmount.Find then begin
            TempCurrencyAmount.Amount := TempCurrencyAmount.Amount + TotalCustLedgEntry[1].Amount;
            TempCurrencyAmount.Modify;
        end else begin
            TempCurrencyAmount."Currency Code" := CurrencyCode;
            TempCurrencyAmount.Date := 99991231D;
            TempCurrencyAmount.Amount := TotalCustLedgEntry[1].Amount;
            TempCurrencyAmount.Insert;
        end;
    end;
}

