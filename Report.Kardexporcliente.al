report 56525 "Kardex por cliente"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Kardexporcliente.rdlc';
    Caption = 'Customer - Detail Trial Bal.';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group", "Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(STRSUBSTNO_Text000_CustDateFilter_; StrSubstNo(Text000, CustDateFilter))
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
            column(ExcludeBalanceOnly; ExcludeBalanceOnly)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter; Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer__Phone_No__; "Phone No.")
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(StartBalanceLCY; StartBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(StartBalanceLCY____Cust__Ledger_Entry___Amount__LCY_____Correction___ApplicationRounding; StartBalanceLCY + "Cust. Ledger Entry"."Amount (LCY)")
            {
                AutoFormatType = 1;
            }
            column(StartBalanceLCY_Control71; StartBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(Customer___Detail_Trial_Bal_Caption; Customer___Detail_Trial_Bal_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(This_report_also_includes_customers_that_only_have_balances_Caption; This_report_also_includes_customers_that_only_have_balances_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption; Cust__Ledger_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_Type_Caption; Cust__Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; "Cust. Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption; "Cust. Ledger Entry".FieldCaption(Description))
            {
            }
            column(CustEntryDueDateCaption; CustEntryDueDateCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Entry_No__Caption; "Cust. Ledger Entry".FieldCaption("Entry No."))
            {
            }
            column(CustBalanceLCY_Control56Caption; CustBalanceLCY_Control56CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Amount__LCY__Caption; "Cust. Ledger Entry".FieldCaption("Amount (LCY)"))
            {
            }
            column(Cust__Ledger_Entry_AmountCaption; "Cust. Ledger Entry".FieldCaption(Amount))
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_Caption; "Cust. Ledger Entry".FieldCaption("Currency Code"))
            {
            }
            column(Customer__Phone_No__Caption; FieldCaption("Phone No."))
            {
            }
            column(Total__LCY_Caption; Total__LCY_CaptionLbl)
            {
            }
            column(Total__LCY__Before_PeriodCaption_Control16; Total__LCY__Before_PeriodCaption_Control16Lbl)
            {
            }
            column(Customer_Date_Filter; "Date Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Sell-to Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Date Filter" = FIELD("Date Filter");
                DataItemTableView = SORTING("Customer No.", "Posting Date");
                column(StartBalanceLCY___StartBalAdjLCY____Amount__LCY__; StartBalanceLCY + "Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(Cust__Ledger_Entry__Posting_Date_; Format("Posting Date"))
                {
                }
                column(Cust__Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(Cust__Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Cust__Ledger_Entry_Description; Description)
                {
                }
                column(CustEntryDueDate; Format(CustEntryDueDate))
                {
                }
                column(Cust__Ledger_Entry__Entry_No__; "Entry No.")
                {
                }
                column(CustBalanceLCY; CustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(Cust__Ledger_Entry__Currency_Code_; "Currency Code")
                {
                }
                column(Cust__Ledger_Entry_Amount; Amount)
                {
                }
                column(Cust__Ledger_Entry__Amount__LCY__; "Amount (LCY)")
                {
                }
                column(StartBalanceLCY___StartBalAdjLCY____Amount__LCY___Control59; StartBalanceLCY + "Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(ContinuedCaption; ContinuedCaptionLbl)
                {
                }
                column(ContinuedCaption_Control46; ContinuedCaption_Control46Lbl)
                {
                }
                column(Cust__Ledger_Entry_Sell_to_Customer_No_; "Sell-to Customer No.")
                {
                }
                column(Cust__Ledger_Entry_Posting_Date; "Posting Date")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Cust__Ledger_Entry_Date_Filter; "Date Filter")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Amount (LCY)");

                    CustLedgEntryExists := true;
                    CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    if ("Document Type" = "Document Type"::Payment) or ("Document Type" = "Document Type"::Refund) then
                        CustEntryDueDate := 0D
                    else
                        CustEntryDueDate := "Due Date";
                end;

                trigger OnPreDataItem()
                begin
                    CustLedgEntryExists := false;
                    //CurrReport.CreateTotals("Amount (LCY)");
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CustBalanceLCY_Control62; CustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(StartBalanceLCY_footer; StartBalanceLCY)
                {
                }
                column(Customer_Name_Control48; Customer.Name)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not CustLedgEntryExists and ((StartBalanceLCY = 0) or ExcludeBalanceOnly) then begin
                        StartBalanceLCY := 0;
                        CurrReport.Skip;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //if IsServiceTier then begin
                if PrintOnlyOnePerPage then
                    PageGroupNo := PageGroupNo + 1;
                //end;

                StartBalanceLCY := 0;
                if CustDateFilter <> '' then begin
                    if GetRangeMin("Date Filter") <> 0D then begin
                        SetRange("Date Filter", 0D, GetRangeMin("Date Filter") - 1);
                        CalcFields("Net Change (LCY)");
                        StartBalanceLCY := "Net Change (LCY)";
                        SetFilter("Date Filter", CustDateFilter);
                    end;
                end;
                CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnly or (StartBalanceLCY = 0);
                CustBalanceLCY := StartBalanceLCY;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                //CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                //CurrReport.CreateTotals("Cust. Ledger Entry"."Amount (LCY)", StartBalanceLCY);
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
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                    ApplicationArea = All;
                        Caption = 'New Page per Customer';
                    }
                    field(ExcludeBalanceOnly; ExcludeBalanceOnly)
                    {
                    ApplicationArea = All;
                        Caption = 'Exclude Customers That Have a Balance Only';
                        MultiLine = true;
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

    trigger OnPreReport()
    begin
        CustFilter := Customer.GetFilters;
        CustDateFilter := Customer.GetFilter("Date Filter");
    end;

    var
        Text000: Label 'Period: %1';
        CustLedgEntry: Record "Cust. Ledger Entry";
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        CustFilter: Text[250];
        CustDateFilter: Text[30];
        CustEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        Text001: Label 'Appln Rounding:';
        CustBalanceLCY: Decimal;
        CustLedgEntryExists: Boolean;
        PageGroupNo: Integer;
        Customer___Detail_Trial_Bal_CaptionLbl: Label 'KARDEX BY CUSTOMER (Detailed)';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        This_report_also_includes_customers_that_only_have_balances_CaptionLbl: Label 'This report also includes customers that only have balances.';
        Cust__Ledger_Entry__Posting_Date_CaptionLbl: Label 'Posting Date';
        Cust__Ledger_Entry__Document_Type_CaptionLbl: Label 'Document Type';
        CustEntryDueDateCaptionLbl: Label 'Due Date';
        CustBalanceLCY_Control56CaptionLbl: Label 'Balance ($)';
        Total__LCY_CaptionLbl: Label 'Total ($)';
        Total__LCY__Before_PeriodCaption_Control16Lbl: Label 'Total ($) Before Period';
        ContinuedCaptionLbl: Label 'Continued';
        ContinuedCaption_Control46Lbl: Label 'Continued';
}

