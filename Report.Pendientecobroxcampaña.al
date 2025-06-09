report 56528 "Pendiente cobro x campaña"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Pendientecobroxcampaña.rdlc';
    Caption = 'Pendiente cobro x campaña';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            MaxIteration = 1;
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(STRSUBSTNO_Text001_FORMAT_StartDate__; StrSubstNo(Text001, Format(StartDate)))
            {

            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter; "Salesperson/Purchaser".TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(DueAmount_OldDueAmount_Control40; DueAmount + OldDueAmount)
            {
                AutoFormatType = 1;
            }
            column(OldDueAmount_Control39; OldDueAmount)
            {
                AutoFormatType = 1;
            }
            column(DueAmount_SalesAmount_Control41; GetPercent(SalesAmount, DueAmount))
            {
                AutoFormatType = 1;
            }
            column(DueAmount_Control38; DueAmount)
            {
                AutoFormatType = 1;
            }
            column(SalesAmount_Control37; SalesAmount)
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
            column(Customer__No__Caption; "Salesperson/Purchaser".FieldCaption(Code))
            {
            }
            column(Customer_NameCaption; "Salesperson/Purchaser".FieldCaption(Name))
            {
            }
            column(SalesAmount_Caption; SalesAmount_CaptionLbl)
            {
            }
            column(DueAmount_Caption; DueAmount_CaptionLbl)
            {
            }
            column(OldDueAmount_Caption; OldDueAmount_CaptionLbl)
            {
            }
            column(DueAmount_OldDueAmount_Caption; DueAmount_OldDueAmount_CaptionLbl)
            {
            }
            column(DueAmount_SalesAmount_Caption; DueAmount_SalesAmount_CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Integer_Number; Number)
            {
            }
            dataitem("Salesperson/Purchaser"; "Salesperson/Purchaser")
            {
                RequestFilterFields = "Code", "Home Page";
                column(Customer_Name; Name)
                {
                }
                column(DueAmount_OldDueAmount; DueAmount + OldDueAmount)
                {
                    AutoFormatType = 1;
                }
                column(OldDueAmount; OldDueAmount)
                {
                    AutoFormatType = 1;
                }
                column(DueAmount_SalesAmount; GetPercent(SalesAmount, DueAmount))
                {
                    AutoFormatType = 1;
                }
                column(DueAmount; DueAmount)
                {
                    AutoFormatType = 1;
                }
                column(SalesAmount; SalesAmount)
                {
                    AutoFormatType = 1;
                }
                column(Customer__No__; Code)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SalesAmount := 0;
                    DueAmount := 0;
                    OldDueAmount := 0;

                    CustLedgEntry.SetCurrentKey("Salesperson Code", "Posting Date");
                    CustLedgEntry.SetRange("Salesperson Code", Code);
                    CustLedgEntry.SetRange("Posting Date", BeginDate, EndDate);
                    CustLedgEntry.SetFilter("Document Type", '%1|%2',
                      CustLedgEntry."Document Type"::Invoice,
                      CustLedgEntry."Document Type"::"Credit Memo");
                    if CustLedgEntry.FindSet then
                        repeat
                            CustLedgEntry.CalcFields("Original Amt. (LCY)", "Remaining Amt. (LCY)");
                            SalesAmount += CustLedgEntry."Original Amt. (LCY)";
                            DueAmount += CustLedgEntry."Remaining Amt. (LCY)";
                        until CustLedgEntry.Next = 0;

                    CustLedgEntry.SetRange("Posting Date", 0D, BeginDate - 1);
                    if CustLedgEntry.FindSet then
                        repeat
                            CustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                            OldDueAmount := CustLedgEntry."Remaining Amt. (LCY)";
                        until CustLedgEntry.Next = 0;

                    if (SalesAmount = 0) and (DueAmount = 0) and (OldDueAmount = 0) then
                        CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CreateTotals(SalesAmount, DueAmount, OldDueAmount);
                end;
            }
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
                    field(StartDate; StartDate)
                    {
                        Caption = 'Campaign Starting Date';
                        ApplicationArea = Basic, Suite;
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
        CustFilter := "Salesperson/Purchaser".GetFilters;

        BeginDate := StartDate;
        EndDate := CalcDate('<+1Y>', BeginDate);
    end;

    var
        Text001: Label 'As of %1';
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustPostGroup: Record "Customer Posting Group";
        StartDate: Date;
        BeginDate: Date;
        EndDate: Date;
        CustFilter: Text[250];
        i: Integer;
        SalesAmount: Decimal;
        DueAmount: Decimal;
        OldDueAmount: Decimal;
        Customer___Summary_Aging_Simp_CaptionLbl: Label 'REMAINING AMOUNT BY SALESPERSON (CURRENTY AND PREVIOUS CAMPAIGN)';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in $';
        SalesAmount_CaptionLbl: Label 'Sales Campaign';
        DueAmount_CaptionLbl: Label 'Open amount';
        OldDueAmount_CaptionLbl: Label 'Old Open amount';
        DueAmount_OldDueAmount_CaptionLbl: Label 'Total open amount';
        DueAmount_SalesAmount_CaptionLbl: Label '% Open amount';
        TotalCaptionLbl: Label 'Total';


    procedure GetPercent(SalesAmount: Decimal; DueAmount: Decimal): Decimal
    begin
        if (SalesAmount = 0) or (DueAmount = 0) then
            exit(0)
        else
            exit((DueAmount / SalesAmount) * 100);
    end;
}

