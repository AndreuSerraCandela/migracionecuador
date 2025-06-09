report 56125 "Agin Accounts Payable (CxP)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AginAccountsPayableCxP.rdlc';
    Caption = 'Aged Accounts Payable';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Vendor Posting Group", "Payment Terms Code", "Purchaser Code";
            column(Aged_Accounts_Payable_; 'Aged Accounts Payable')
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(TIME; Time)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(USERID; UserId)
            {
            }
            column(SubTitle; SubTitle)
            {
            }
            column(DateTitle; DateTitle)
            {
            }
            column(Document_Number_is______Vendor_Ledger_Entry__FIELDCAPTION__External_Document_No___; 'Document Number is ' + "Vendor Ledger Entry".FieldCaption("External Document No."))
            {
            }
            column(Vendor_TABLECAPTION__________FilterString; Vendor.TableCaption + ': ' + FilterString)
            {
            }
            column(ColumnHeadHead; ColumnHeadHead)
            {
            }
            column(ColumnHead_1_; ColumnHead[1])
            {
            }
            column(ColumnHead_2_; ColumnHead[2])
            {
            }
            column(ColumnHead_3_; ColumnHead[3])
            {
            }
            column(ColumnHead_4_; ColumnHead[4])
            {
            }
            column(PrintToExcel; PrintToExcel)
            {
            }
            column(PrintDetail; PrintDetail)
            {
            }
            column(PrintAmountsInLocal; PrintAmountsInLocal)
            {
            }
            column(ShowAllForOverdue; ShowAllForOverdue)
            {
            }
            column(UseExternalDocNo; UseExternalDocNo)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(ColumnHeadHead_Control21; ColumnHeadHead)
            {
            }
            column(ShortDateTitle; ShortDateTitle)
            {
            }
            column(ColumnHead_1__Control26; ColumnHead[1])
            {
            }
            column(ColumnHead_2__Control27; ColumnHead[2])
            {
            }
            column(ColumnHead_3__Control28; ColumnHead[3])
            {
            }
            column(ColumnHead_4__Control29; ColumnHead[4])
            {
            }
            column(Dim; DimDepto)
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(Vendor__Phone_No__; "Phone No.")
            {
            }
            column(Vendor_Contact; Contact)
            {
            }
            column(BlockedDescription; BlockedDescription)
            {
            }
            column(TotalBalanceDue__; -"TotalBalanceDue$")
            {
            }
            column(BalanceDue___1_; -"BalanceDue$"[1])
            {
            }
            column(BalanceDue___2_; -"BalanceDue$"[2])
            {
            }
            column(BalanceDue___3_; -"BalanceDue$"[3])
            {
            }
            column(BalanceDue___4_; -"BalanceDue$"[4])
            {
            }
            column(PercentString_1_; PercentString[1])
            {
            }
            column(PercentString_2_; PercentString[2])
            {
            }
            column(PercentString_3_; PercentString[3])
            {
            }
            column(PercentString_4_; PercentString[4])
            {
            }
            column(TotalBalanceDue___Control91; -"TotalBalanceDue$")
            {
            }
            column(BalanceDue___1__Control92; -"BalanceDue$"[1])
            {
            }
            column(BalanceDue___2__Control93; -"BalanceDue$"[2])
            {
            }
            column(BalanceDue___3__Control94; -"BalanceDue$"[3])
            {
            }
            column(PercentString_1__Control95; PercentString[1])
            {
            }
            column(PercentString_2__Control96; PercentString[2])
            {
            }
            column(PercentString_3__Control97; PercentString[3])
            {
            }
            column(BalanceDue___4__Control98; -"BalanceDue$"[4])
            {
            }
            column(PercentString_4__Control99; PercentString[4])
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Aged_byCaption; Aged_byCaptionLbl)
            {
            }
            column(Control11Caption; CaptionClassTranslate('101,1,' + Text021))
            {
            }
            column(Vendor__No__Caption; FieldCaption("No."))
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(AmountDueToPrint_Control74Caption; AmountDueToPrint_Control74CaptionLbl)
            {
            }
            column(Vendor__No__Caption_Control22; FieldCaption("No."))
            {
            }
            column(Vendor_NameCaption; FieldCaption(Name))
            {
            }
            column(DocNoCaption; DocNoCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(AmountDueToPrint_Control63Caption; AmountDueToPrint_Control63CaptionLbl)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry___Currency_Code_Caption; Vendor_Ledger_Entry___Currency_Code_CaptionLbl)
            {
            }
            column(Expense; ExpenseLbl)
            {
            }
            column(Phone_Caption; Phone_CaptionLbl)
            {
            }
            column(Contact_Caption; Contact_CaptionLbl)
            {
            }
            column(Control1020000Caption; CaptionClassTranslate(GetCurrencyCaptionCode("Currency Code")))
            {
            }
            column(Control47Caption; CaptionClassTranslate('101,0,' + Text022))
            {
            }
            column(Control48Caption; CaptionClassTranslate('101,0,' + Text022))
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date");

                trigger OnAfterGetRecord()
                begin
                    SetRange("Date Filter", 0D, PeriodEndingDate[1]);
                    CalcFields("Remaining Amount");

                    Clear(RazonGasto);
                    PIL.Reset;
                    PIL.SetRange("Document No.", "Document No.");
                    PIL.SetRange(Type, PIL.Type::"G/L Account");
                    if PIL.FindSet then
                        repeat
                            if (StrLen(RazonGasto) + StrLen(PIL.Description)) < 1024 then
                                RazonGasto += PIL.Description + ', ';
                        // IF PDD.GET(123,PIL."Document No.",PIL."Line No.",DimDepto) THEN
                        //   DimDeptoPRT := PDD."Dimension Value Code";
                        until PIL.Next = 0;

                    if "Remaining Amount" <> 0 then
                        InsertTemp("Vendor Ledger Entry");
                    CurrReport.Skip;    //  this fools the system into thinking that no details "printed"...yet
                end;

                trigger OnPreDataItem()
                begin
                    // Find ledger entries which are posted before the date of the aging.
                    SetRange("Posting Date", 0D, PeriodEndingDate[1]);

                    if (ShowOnlyOverDueBy <> '') and not (ShowAllForOverdue) then
                        SetRange("Due Date", 0D, CalculatedDate);
                end;
            }
            dataitem(Totals; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(AmountDueToPrint; -AmountDueToPrint)
                {
                }
                column(AmountDue_1_; -AmountDue[1])
                {
                }
                column(AmountDue_2_; -AmountDue[2])
                {
                }
                column(AmountDue_3_; -AmountDue[3])
                {
                }
                column(AmountDue_4_; -AmountDue[4])
                {
                }
                column(AgingDate; AgingDate)
                {
                }
                column(Vendor_Ledger_Entry__Description; "Vendor Ledger Entry".Description)
                {
                }
                column(Vendor_Ledger_Entry___Document_Type_; "Vendor Ledger Entry"."Document Type")
                {
                }
                column(DocNo; DocNo)
                {
                }
                column(AmountDueToPrint_Control63; -AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control64; -AmountDue[1])
                {
                }
                column(AmountDue_2__Control65; -AmountDue[2])
                {
                }
                column(AmountDue_3__Control66; -AmountDue[3])
                {
                }
                column(AmountDue_4__Control67; -AmountDue[4])
                {
                }
                column(Vendor_Ledger_Entry___Currency_Code_; "Vendor Ledger Entry"."Currency Code")
                {
                }
                column(RazonGasto; RazonGasto)
                {
                }
                column(AmountDueToPrint_Control68; -AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control69; -AmountDue[1])
                {
                }
                column(AmountDue_2__Control70; -AmountDue[2])
                {
                }
                column(AmountDue_3__Control71; -AmountDue[3])
                {
                }
                column(AmountDue_4__Control72; -AmountDue[4])
                {
                }
                column(AmountDueToPrint_Control74; -AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control75; -AmountDue[1])
                {
                }
                column(AmountDue_2__Control76; -AmountDue[2])
                {
                }
                column(AmountDue_3__Control77; -AmountDue[3])
                {
                }
                column(AmountDue_4__Control78; -AmountDue[4])
                {
                }
                column(PercentString_1__Control5; PercentString[1])
                {
                }
                column(PercentString_2__Control6; PercentString[2])
                {
                }
                column(PercentString_3__Control7; PercentString[3])
                {
                }
                column(PercentString_4__Control8; PercentString[4])
                {
                }
                column(Vendor__No___Control80; Vendor."No.")
                {
                }
                column(AmountDueToPrint_Control81; -AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control82; -AmountDue[1])
                {
                }
                column(AmountDue_2__Control83; -AmountDue[2])
                {
                }
                column(AmountDue_3__Control84; -AmountDue[3])
                {
                }
                column(AmountDue_4__Control85; -AmountDue[4])
                {
                }
                column(PercentString_1__Control87; PercentString[1])
                {
                }
                column(PercentString_2__Control88; PercentString[2])
                {
                }
                column(PercentString_3__Control89; PercentString[3])
                {
                }
                column(PercentString_4__Control90; PercentString[4])
                {
                }
                column(Balance_ForwardCaption; Balance_ForwardCaptionLbl)
                {
                }
                column(Balance_to_Carry_ForwardCaption; Balance_to_Carry_ForwardCaptionLbl)
                {
                }
                column(Total_Amount_DueCaption; Total_Amount_DueCaptionLbl)
                {
                }
                column(Total_Amount_DueCaption_Control86; Total_Amount_DueCaption_Control86Lbl)
                {
                }
                column(Control1020001Caption; CaptionClassTranslate(GetCurrencyCaptionCode(Vendor."Currency Code")))
                {
                }
                column(Totals_Number; Number)
                {
                }
                dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
                {
                    DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending);
                    column(Posted_Document_Dimension__Dimension_Value_Code_; DimSetEntry."Dimension Value Code")
                    {
                    }
                    column(Importe; Importe)
                    {
                    }
                    column(Posted_Document_Dimension_Table_ID; 123)
                    {
                    }
                    column(Posted_Document_Dimension_Document_No_; "Document No.")
                    {
                    }
                    column(Posted_Document_Dimension_Line_No_; "Line No.")
                    {
                    }
                    column(Posted_Document_Dimension_Dimension_Code; DimDepto)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //+MIGRACION 2013
                        //+#139
                        //CLEAR(PIL);
                        //IF PIL.GET("Document No.","Line No.") THEN
                        //  Importe += PIL."Amount Including VAT"
                        //-#139
                        DimSetEntry.SetRange("Dimension Set ID", "Purch. Inv. Line"."Dimension Set ID");
                        DimSetEntry.SetRange("Dimension Code", DimDepto);
                        if not DimSetEntry.FindFirst then
                            CurrReport.Skip;
                        Importe := "Amount Including VAT";
                        //-MIGRACION 2013
                    end;

                    trigger OnPreDataItem()
                    begin

                        //+MIGRACION 2013
                        //SETRANGE("Table ID",123);
                        //SETRANGE("Document No.","Vendor Ledger Entry"."Document No.");
                        //SETFILTER("Line No.",'<>%1',0);
                        //SETRANGE("Dimension Code",DimDepto);
                        "Purch. Inv. Line".SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                        //-MIGRACION 2013
                        Importe := 0; //+#139
                    end;
                }

                trigger OnAfterGetRecord()
                begin                    
                    CalcPercents(AmountDueToPrint, AmountDue);

                    if Number = 1 then
                        TempVendLedgEntry.Find('-')
                    else
                        TempVendLedgEntry.Next;
                    TempVendLedgEntry.SetRange("Date Filter", 0D, PeriodEndingDate[1]);
                    TempVendLedgEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                    if TempVendLedgEntry."Remaining Amount" = 0 then
                        CurrReport.Skip;
                    if TempVendLedgEntry."Currency Code" <> '' then
                        TempVendLedgEntry."Remaining Amt. (LCY)" :=
                          Round(
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PeriodEndingDate[1],
                              TempVendLedgEntry."Currency Code",
                              '',
                              TempVendLedgEntry."Remaining Amount"));
                    if PrintAmountsInLocal then begin
                        TempVendLedgEntry."Remaining Amount" :=
                          Round(
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PeriodEndingDate[1],
                              TempVendLedgEntry."Currency Code",
                              Vendor."Currency Code",
                              TempVendLedgEntry."Remaining Amount"),
                            Currency."Amount Rounding Precision");
                        AmountDueToPrint := TempVendLedgEntry."Remaining Amount";
                    end else
                        AmountDueToPrint := TempVendLedgEntry."Remaining Amt. (LCY)";

                    case AgingMethod of
                        AgingMethod::"Due Date":
                            AgingDate := TempVendLedgEntry."Due Date";
                        AgingMethod::"Trans Date":
                            AgingDate := TempVendLedgEntry."Posting Date";
                        AgingMethod::"Document Date":
                            AgingDate := TempVendLedgEntry."Document Date";
                    end;
                    j := 0;
                    while AgingDate < PeriodEndingDate[j + 1] do
                        j := j + 1;
                    if j = 0 then
                        j := 1;

                    AmountDue[j] := AmountDueToPrint;
                    "BalanceDue$"[j] := "BalanceDue$"[j] + TempVendLedgEntry."Remaining Amt. (LCY)";

                    "TotalBalanceDue$" := 0;
                    VendTotAmountDue[j] := VendTotAmountDue[j] + AmountDueToPrint;
                    VendTotAmountDueToPrint := VendTotAmountDueToPrint + AmountDueToPrint;

                    for j := 1 to 4 do
                        "TotalBalanceDue$" := "TotalBalanceDue$" + "BalanceDue$"[j];
                    CalcPercents("TotalBalanceDue$", "BalanceDue$");


                    "Vendor Ledger Entry" := TempVendLedgEntry;
                    if UseExternalDocNo then
                        DocNo := "Vendor Ledger Entry"."External Document No."
                    else
                        DocNo := "Vendor Ledger Entry"."Document No.";

                    // Do NOT use the following fields in the sections:
                    //   "Applied-To Doc. Type"
                    //   "Applied-To Doc. No."
                    //   Open
                    //   "Paym. Disc. Taken"
                    //   "Closed by Entry No."
                    //   "Closed at Date"
                    //   "Closed by Amount"

                    if PrintDetail and PrintToExcel then
                        MakeExcelDataBody;
                end;

                trigger OnPostDataItem()
                begin
                    if TempVendLedgEntry.Count > 0 then begin
                        for j := 1 to 4 do
                            AmountDue[j] := VendTotAmountDue[j];
                        AmountDueToPrint := VendTotAmountDueToPrint;
                        if not PrintDetail and PrintToExcel then
                            MakeExcelDataBody;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CreateTotals(AmountDueToPrint, AmountDue);
                    SetRange(Number, 1, TempVendLedgEntry.Count);
                    TempVendLedgEntry.SetCurrentKey("Vendor No.", "Posting Date");
                    Clear("BalanceDue$");
                    Clear(VendTotAmountDue);
                    VendTotAmountDueToPrint := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
            begin
                if PrintAmountsInLocal then begin
                    GetCurrencyRecord(Currency, "Currency Code");
                    CurrencyFactor := CurrExchRate.ExchangeRate(PeriodEndingDate[1], "Currency Code");
                end;

                if Blocked <> Blocked::" " then
                    BlockedDescription := StrSubstNo(Text003, Blocked)
                else
                    BlockedDescription := '';

                TempVendLedgEntry.DeleteAll;

                if ShowOnlyOverDueBy <> '' then
                    CalculatedDate := CalcDate('-' + ShowOnlyOverDueBy, PeriodEndingDate[1]);

                if ShowAllForOverdue and (ShowOnlyOverDueBy <> '') then begin
                    VendLedgEntry.SetRange("Vendor No.", "No.");
                    VendLedgEntry.SetRange(Open, true);
                    VendLedgEntry.SetRange("Due Date", 0D, CalculatedDate);
                    if not (VendLedgEntry.FindSet) then CurrReport.Skip;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Clear("BalanceDue$");
                if PeriodEndingDate[1] = 0D then
                    PeriodEndingDate[1] := WorkDate;

                if PrintDetail then begin
                    SubTitle := Text004;
                end else begin
                    SubTitle := Text005;
                end;
                SubTitle := SubTitle + Text006 + ' ' + Format(PeriodEndingDate[1], 0, 4) + ')';

                if AgingMethod = AgingMethod::"Due Date" then begin
                    DateTitle := Text007;
                    ShortDateTitle := Text008;
                    ColumnHead[2] := Text009 + ' '
                                     + Format(PeriodEndingDate[1] - PeriodEndingDate[3])
                                     + ' ' + Text010;
                    ColumnHeadHead := ' ' + Text011 + ' ';
                end else
                    if AgingMethod = AgingMethod::"Trans Date" then begin
                        DateTitle := Text012;
                        ShortDateTitle := Text013;
                        ColumnHead[2] := Format(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                                         + ' - '
                                         + Format(PeriodEndingDate[1] - PeriodEndingDate[3])
                                         + ' ' + Text010;
                        ColumnHeadHead := ' ' + Text014 + ' ';
                    end else begin
                        DateTitle := Text015;
                        ShortDateTitle := Text016;
                        ColumnHead[2] := Format(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                                         + ' - '
                                         + Format(PeriodEndingDate[1] - PeriodEndingDate[3])
                                         + ' ' + Text010;
                        ColumnHeadHead := ' ' + Text017 + ' ';
                    end;

                ColumnHead[1] := Text018;
                ColumnHead[3] := Format(PeriodEndingDate[1] - PeriodEndingDate[3] + 1)
                                 + ' - '
                                 + Format(PeriodEndingDate[1] - PeriodEndingDate[4])
                                 + ' ' + Text010;
                ColumnHead[4] := 'Over '
                                 + Format(PeriodEndingDate[1] - PeriodEndingDate[4])
                                 + ' ' + Text010;

                if PrintToExcel then
                    MakeExcelInfo;
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
                group(Options)
                {
                    Caption = 'Options';
                    field("PeriodEndingDate[1]"; PeriodEndingDate[1])
                    {
                    ApplicationArea = All;
                        Caption = 'Aged as of';

                        trigger OnValidate()
                        begin
                            PeriodEndingDate1OnAfterValida;
                        end;
                    }
                    field(AgingMethod; AgingMethod)
                    {
                    ApplicationArea = All;
                        Caption = 'Aging Method';
                        OptionCaption = 'Due Date,Trans Date,Document Date';
                    }
                    field(PeriodCalculation; PeriodCalculation)
                    {
                    ApplicationArea = All;
                        Caption = 'Length of Aging Periods';

                        trigger OnValidate()
                        begin
                            if PeriodCalculation = '' then
                                Error('You must enter a period calculation in the '
                                      + 'Length of Aging Periods field');
                        end;
                    }
                    field(ShowOnlyOverDueBy; ShowOnlyOverDueBy)
                    {
                    ApplicationArea = All;
                        Caption = 'Show If Overdue By';
                        DateFormula = true;

                        trigger OnValidate()
                        begin
                            if AgingMethod <> AgingMethod::"Due Date" then
                                Error(Text120);
                            if ShowOnlyOverDueBy = '' then ShowAllForOverdue := false;
                        end;
                    }
                    field(DimDepto; DimDepto)
                    {
                    ApplicationArea = All;
                        Caption = 'Dimensión';
                        TableRelation = Dimension;
                    }
                    field(ShowAllForOverdue; ShowAllForOverdue)
                    {
                    ApplicationArea = All;
                        Caption = 'Show All for Overdue By Vendor';

                        trigger OnValidate()
                        begin
                            if AgingMethod <> AgingMethod::"Due Date" then
                                Error(Text120);
                            if ShowAllForOverdue and (ShowOnlyOverDueBy = '') then
                                Error(Text119);
                        end;
                    }
                    field(PrintAmountsInLocal; PrintAmountsInLocal)
                    {
                    ApplicationArea = All;
                        Caption = 'Print Amounts in Vendor''s Currency';
                        MultiLine = true;

                        trigger OnValidate()
                        begin
                            if ShowAllForOverdue and (ShowOnlyOverDueBy = '') then
                                Error(Text119);
                        end;
                    }
                    field(PrintDetail; PrintDetail)
                    {
                    ApplicationArea = All;
                        Caption = 'Print Detail';
                    }
                    field(UseExternalDocNo; UseExternalDocNo)
                    {
                    ApplicationArea = All;
                        Caption = 'Use External Doc. No.';
                    }
                    field(PrintToExcel; PrintToExcel)
                    {
                    ApplicationArea = All;
                        Caption = 'Print to Excel';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PeriodEndingDate[1] = 0D then begin
                PeriodEndingDate[1] := WorkDate;
                PeriodCalculation := Text023;
            end;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if PrintToExcel then
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        if AgingMethod = AgingMethod::"Due Date" then begin
            PeriodEndingDate[2] := PeriodEndingDate[1];
            for j := 3 to 4 do
                PeriodEndingDate[j] := CalcDate('-(' + PeriodCalculation + ')', PeriodEndingDate[j - 1]);
        end else begin
            for j := 2 to 4 do
                PeriodEndingDate[j] := CalcDate('-(' + PeriodCalculation + ')', PeriodEndingDate[j - 1]);
        end;
        PeriodEndingDate[5] := 0D;
        CompanyInformation.Get;
        GLSetup.Get;
        FilterString := Vendor.GetFilters;

        if DimDepto = '' then
            Error(Error001);
    end;

    var
        CompanyInformation: Record "Company Information";
        TempVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        ExcelBuf: Record "Excel Buffer" temporary;
        PIL: Record "Purch. Inv. Line";
        PIH: Record "Purch. Inv. Header";
        PeriodCalculation: Code[20];
        ShowOnlyOverDueBy: Code[10];
        AgingMethod: Option "Due Date","Trans Date","Document Date";
        PrintAmountsInLocal: Boolean;
        PrintDetail: Boolean;
        PrintToExcel: Boolean;
        AmountDue: array[4] of Decimal;
        "BalanceDue$": array[4] of Decimal;
        ClosingAmount: Decimal;
        ColumnHead: array[4] of Text[20];
        ColumnHeadHead: Text[59];
        PercentString: array[4] of Text[10];
        Percent: Decimal;
        "TotalBalanceDue$": Decimal;
        AmountDueToPrint: Decimal;
        BlockedDescription: Text[80];
        j: Integer;
        CurrencyFactor: Decimal;
        FilterString: Text[250];
        SubTitle: Text[88];
        DateTitle: Text[20];
        ShortDateTitle: Text[20];
        PeriodEndingDate: array[5] of Date;
        AgingDate: Date;
        UseExternalDocNo: Boolean;
        DocNo: Code[20];
        Text001: Label 'Amounts are in %1';
        Text002: Label 'US Dollars';
        Text003: Label '*** This vendor is blocked for %1 processing ***';
        Text004: Label '(Detail';
        Text005: Label '(Summary';
        Text006: Label ', aged as of';
        Text007: Label 'due date.';
        Text008: Label 'Due Date';
        Text009: Label 'Up To';
        Text010: Label 'Days';
        Text011: Label 'Aged Overdue Amounts';
        Text012: Label 'transaction date.';
        Text013: Label 'Trx Date';
        Text014: Label 'Aged Vendor Balances';
        Text015: Label 'document date.';
        Text016: Label 'Doc Date';
        Text017: Label 'Aged Vendor Balances';
        Text018: Label 'Current';
        Text021: Label 'Amounts are in the vendor''s local currency (report totals are in %1).';
        Text022: Label 'Report Total Amount Due (%1)';
        Text023: Label '30D';
        Text101: Label 'Data';
        Text102: Label 'Aged Accounts Payable';
        Text103: Label 'Company Name';
        Text104: Label 'Report No.';
        Text105: Label 'Report Name';
        Text106: Label 'User ID';
        Text107: Label 'Date / Time';
        Text108: Label 'Vendor Filters';
        Text109: Label 'Aged by';
        Text110: Label 'Amounts are';
        Text111: Label 'In our Functional Currency';
        Text112: Label 'As indicated in Data';
        Text113: Label 'Aged as of';
        Text114: Label 'Aging Date (%1)';
        Text115: Label 'Balance Due';
        Text116: Label 'Document Currency';
        Text117: Label 'Vendor Currency';
        ByVendor: Boolean;
        ShowAllForOverdue: Boolean;
        Text119: Label 'Show Only Overdue By Needs a Valid Date Formula';
        CalculatedDate: Date;
        Text120: Label 'This option is only allowed for method Due Date';
        VendTotAmountDue: array[4] of Decimal;
        VendTotAmountDueToPrint: Decimal;
        RazonGasto: Text[1024];
        DimDepto: Code[20];
        DimDeptoPRT: Code[20];
        Importe: Decimal;
        Error001: Label 'Dimension must be selected in the Option Tab';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Aged_byCaptionLbl: Label 'Aged by';
        NameCaptionLbl: Label 'Name';
        AmountDueToPrint_Control74CaptionLbl: Label 'Balance Due';
        DocNoCaptionLbl: Label 'Number';
        DescriptionCaptionLbl: Label 'Description';
        TypeCaptionLbl: Label 'Type';
        AmountDueToPrint_Control63CaptionLbl: Label 'Balance Due';
        DocumentCaptionLbl: Label 'Document';
        Vendor_Ledger_Entry___Currency_Code_CaptionLbl: Label 'Doc. Curr.';
        ExpenseLbl: Label 'Reason / Account Expense';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Contact:';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Balance_to_Carry_ForwardCaptionLbl: Label 'Balance to Carry Forward';
        Total_Amount_DueCaptionLbl: Label 'Total Amount Due';
        Total_Amount_DueCaption_Control86Lbl: Label 'Total Amount Due';
        DimSetEntry: Record "Dimension Set Entry";

    local procedure InsertTemp(var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        if TempVendLedgEntry.Get(VendLedgEntry."Entry No.") then
            exit;
        TempVendLedgEntry := VendLedgEntry;
        case AgingMethod of
            AgingMethod::"Due Date":
                TempVendLedgEntry."Posting Date" := TempVendLedgEntry."Due Date";
            AgingMethod::"Document Date":
                TempVendLedgEntry."Posting Date" := TempVendLedgEntry."Document Date";
        end;
        TempVendLedgEntry.Insert;
    end;


    procedure CalcPercents(Total: Decimal; Amounts: array[4] of Decimal)
    var
        i: Integer;
        j: Integer;
    begin
        Clear(PercentString);
        if Total <> 0 then
            for i := 1 to 4 do begin
                Percent := Amounts[i] / Total * 100.0;
                if StrLen(Format(Round(Percent))) + 4 > MaxStrLen(PercentString[1]) then
                    PercentString[i] := PadStr(PercentString[i], MaxStrLen(PercentString[i]), '*')
                else begin
                    PercentString[i] := Format(Round(Percent));
                    j := StrPos(PercentString[i], '.');
                    if j = 0 then
                        PercentString[i] := PercentString[i] + '.00'
                    else
                        if j = StrLen(PercentString[i]) - 1 then
                            PercentString[i] := PercentString[i] + '0';
                    PercentString[i] := PercentString[i] + '%';
                end;
            end;
    end;

    local procedure GetCurrencyRecord(var Currency: Record Currency; CurrencyCode: Code[10])
    begin
        if CurrencyCode = '' then begin
            Clear(Currency);
            Currency.Description := GLSetup."LCY Code";
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        end else
            if Currency.Code <> CurrencyCode then
                Currency.Get(CurrencyCode);
    end;

    local procedure GetCurrencyCaptionCode(CurrencyCode: Code[10]): Text[80]
    begin
        if PrintAmountsInLocal then begin
            if CurrencyCode = '' then
                exit('101,1,' + Text001)
            else begin
                GetCurrencyRecord(Currency, CurrencyCode);
                exit('101,4,' + StrSubstNo(Text001, Currency.Description));
            end;
        end else
            exit('');
    end;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(Text103), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInformation.Name, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text105), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Format(Text102), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text104), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Aged Accounts Payable", false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text106), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(UserId, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text107), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Today, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Time, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text108), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FilterString, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text109), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(DateTitle, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text113), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(PeriodEndingDate[1], false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text110), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        if PrintAmountsInLocal then
            ExcelBuf.AddInfoColumn(Format(Text112), false, false, false, false, '', ExcelBuf."Cell Type"::Text)
        else
            ExcelBuf.AddInfoColumn(Format(Text111), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Vendor Ledger Entry".FieldCaption("Vendor No."), false, '', true, false, true, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vendor.FieldCaption(Name), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        if PrintDetail then begin
            ExcelBuf.AddColumn(StrSubstNo(Text114, ShortDateTitle), false, '', true, false, true, '@', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Vendor Ledger Entry".FieldCaption(Description), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Vendor Ledger Entry".FieldCaption("Document Type"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Vendor Ledger Entry".FieldCaption("Document No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        end;
        ExcelBuf.AddColumn(Format(Text115), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ColumnHead[1], false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ColumnHead[2], false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ColumnHead[3], false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ColumnHead[4], false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        if PrintAmountsInLocal then begin
            if PrintDetail then
                ExcelBuf.AddColumn(Format(Text116), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text)
            else
                ExcelBuf.AddColumn(Format(Text117), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        end;
    end;

    local procedure MakeExcelDataBody()
    var
        CurrencyCodeToPrint: Code[20];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Vendor."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vendor.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        if PrintDetail then begin
            ExcelBuf.AddColumn(AgingDate, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Vendor Ledger Entry".Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Format("Vendor Ledger Entry"."Document Type"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(DocNo, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        end;
        ExcelBuf.AddColumn(-AmountDueToPrint, false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-AmountDue[1], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-AmountDue[2], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-AmountDue[3], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-AmountDue[4], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Text);
        if PrintAmountsInLocal then begin
            if PrintDetail then
                CurrencyCodeToPrint := "Vendor Ledger Entry"."Currency Code"
            else
                CurrencyCodeToPrint := Vendor."Currency Code";
            if CurrencyCodeToPrint = '' then
                CurrencyCodeToPrint := GLSetup."LCY Code";
            ExcelBuf.AddColumn(CurrencyCodeToPrint, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)
        end;
    end;

    local procedure CreateExcelbook()
    begin
        /*         ExcelBuf.CreateBookAndOpenExcel('', Text101, Text102, CompanyName, UserId); */
        Error('');
    end;

    local procedure PeriodEndingDate1OnAfterValida()
    begin
        if PeriodEndingDate[1] = 0D then
            PeriodEndingDate[1] := WorkDate;
    end;
}

