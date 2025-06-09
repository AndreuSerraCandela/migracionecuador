report 56533 "Obligaciones pendientes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Obligacionespendientes.rdlc';
    Caption = 'Outstanding Bonds';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Vendor Posting Group";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(STRSUBSTNO_Text000_CustDateFilter_; StrSubstNo(Text000, ToDate))
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
            column(Vendor_TABLECAPTION__________CustFilter; Vendor.TableCaption + ': ' + VendFilter)
            {
            }
            column(CustFilter; VendFilter)
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
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(Vendor___Detail_Trial_Bal_Caption; Vendor___Detail_Trial_Bal_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_Caption; Vendor_Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_No__Caption; "Vendor Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(GetCurrency__Currency_Code__Caption; GetCurrency__Currency_Code__CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Due_Date_Caption; "Vendor Ledger Entry".FieldCaption("Due Date"))
            {
            }
            column(Vendor_Ledger_Entry__Posting_Date_Caption; "Vendor Ledger Entry".FieldCaption("Posting Date"))
            {
            }
            column(Vendor_Ledger_Entry_DescriptionCaption; "Vendor Ledger Entry".FieldCaption(Description))
            {
            }
            column(Vendor_Ledger_Entry__Remaining_Amt___LCY__Caption; "Vendor Ledger Entry".FieldCaption("Remaining Amt. (LCY)"))
            {
            }
            column(Vendor_Ledger_Entry__Remaining_Amount_Caption; "Vendor Ledger Entry".FieldCaption("Remaining Amount"))
            {
            }
            column(OverDueDaysCaption; OverDueDaysCaptionLbl)
            {
            }
            column(Vendor__Phone_No__Caption; FieldCaption("Phone No."))
            {
            }
            column(Vendor_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Vendor_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Vendor_Currency_Filter; "Currency Filter")
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Currency Code" = FIELD("Currency Filter");
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code") WHERE(Open = CONST(true));
                column(Vendor_Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(GetCurrency__Currency_Code__; GetCurrency("Currency Code"))
                {
                }
                column(PageGroupNo_Control1000000015; "Amount (LCY)")
                {
                }
                column(Vendor_Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Vendor_Ledger_Entry__Due_Date_; "Due Date")
                {
                }
                column(Vendor_Ledger_Entry_Description; Description)
                {
                }
                column(Vendor_Ledger_Entry__Remaining_Amount_; "Remaining Amount")
                {
                }
                column(Vendor_Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
                {
                }
                column(OverDueDays; OverDueDays)
                {
                }
                column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Vendor_Ledger_Entry_Vendor_No_; "Vendor No.")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(Vendor_Ledger_Entry_Currency_Code; "Currency Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                    if ("Due Date" <> 0D) and (ToDate > "Due Date") and ("Remaining Amount" > 0) then
                        OverDueDays := ToDate - "Due Date"
                    else
                        OverDueDays := 0;

                    if not VendBuff.Get("Currency Code") then begin
                        VendBuff."Currency Code" := "Currency Code";
                        VendBuff."Total Amount" := "Remaining Amount";
                        VendBuff."Total Amount (LCY)" := "Remaining Amt. (LCY)";
                        VendBuff.Insert;
                    end
                    else begin
                        VendBuff."Total Amount" += "Remaining Amount";
                        VendBuff."Total Amount (LCY)" += "Remaining Amt. (LCY)";
                        VendBuff.Modify;
                    end;

                    if not TotalBuff.Get("Currency Code") then begin
                        TotalBuff."Currency Code" := "Currency Code";
                        TotalBuff."Total Amount" := "Remaining Amount";
                        TotalBuff."Total Amount (LCY)" := "Remaining Amt. (LCY)";
                        TotalBuff.Insert;
                    end
                    else begin
                        TotalBuff."Total Amount" += "Remaining Amount";
                        TotalBuff."Total Amount (LCY)" += "Remaining Amt. (LCY)";
                        TotalBuff.Modify;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CreateTotals("Remaining Amount", "Remaining Amt. (LCY)");

                    VendBuff.Reset;
                    VendBuff.DeleteAll;

                    SetRange("Posting Date", 0D, ToDate);
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(VendBuff__Total_Amount__LCY__; VendBuff."Total Amount (LCY)")
                {
                }
                column(VendBuff__Total_Amount_; VendBuff."Total Amount")
                {
                }
                column(GetCurrency_VendBuff__Currency_Code__; GetCurrency(VendBuff."Currency Code"))
                {
                }
                column(Vendor__No___Control1000000022; Vendor."No.")
                {
                }
                column(Integer_Number; Number)
                {
                }
                column(VendBuff__Total_Amount__LCY___Control1000000023; VendBuff."Total Amount (LCY)")
                {
                }
                column(VendBuff__Total_Amount__Control1000000024; VendBuff."Total Amount")
                {
                }
                column(GetCurrency_VendBuff__Currency_Code___Control1000000025; GetCurrency(VendBuff."Currency Code"))
                {
                }
                column(VendBuff__Total_Amount__LCY___Control1000000027; VendBuff."Total Amount (LCY)")
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        VendBuff.Reset;
                        if not VendBuff.FindSet then
                            CurrReport.Break;
                    end
                    else
                        if VendBuff.Next = 0 then
                            CurrReport.Break;
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CreateTotals(VendBuff."Total Amount", VendBuff."Total Amount (LCY)");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //if IsServiceTier then begin
                if PrintOnlyOnePerPage then
                    PageGroupNo := PageGroupNo + 1;
                //end;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                //CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                //CurrReport.CreateTotals("Vendor Ledger Entry"."Remaining Amount", "Vendor Ledger Entry"."Remaining Amt. (LCY)");
            end;
        }
        dataitem(Total; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(TotalBuff__Total_Amount__LCY__; TotalBuff."Total Amount (LCY)")
            {
            }
            column(TotalBuff__Total_Amount_; TotalBuff."Total Amount")
            {
            }
            column(GetCurrency_TotalBuff__Currency_Code__; GetCurrency(TotalBuff."Currency Code"))
            {
            }
            column(Total_Number; Number)
            {
            }
            column(TotalBuff__Total_Amount__LCY___Control1000000014; TotalBuff."Total Amount (LCY)")
            {
            }
            column(TotalBuff__Total_Amount__Control1000000016; TotalBuff."Total Amount")
            {
            }
            column(GetCurrency_TotalBuff__Currency_Code___Control1000000017; GetCurrency(TotalBuff."Currency Code"))
            {
            }
            column(TotalBuff__Total_Amount__LCY___Control1000000018; TotalBuff."Total Amount (LCY)")
            {
            }
            column(TotalCaption_Control1000000019; TotalCaption_Control1000000019Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    TotalBuff.Reset;
                    if not TotalBuff.FindSet then
                        CurrReport.Break;
                end
                else
                    if TotalBuff.Next = 0 then
                        CurrReport.Break;
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CreateTotals(TotalBuff."Total Amount", TotalBuff."Total Amount (LCY)");
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
                    field(ToDate; ToDate)
                    {
                        Caption = 'Ending Date';
                        ApplicationArea = All;
                    }
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        Caption = 'New Page per Vendor';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if ToDate = 0D then
                ToDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        VendFilter := Vendor.GetFilters;
        GLSetup.Get;
    end;

    var
        Text000: Label 'Period: %1';
        GLSetup: Record "General Ledger Setup";
        VendBuff: Record "Currency Total Buffer" temporary;
        TotalBuff: Record "Currency Total Buffer" temporary;
        PrintOnlyOnePerPage: Boolean;
        VendFilter: Text[250];
        PageGroupNo: Integer;
        RemainingAmt: Decimal;
        RemainingAmtLCY: Decimal;
        OverDueDays: Integer;
        ToDate: Date;
        Vendor___Detail_Trial_Bal_CaptionLbl: Label 'OUTSTANDING BONDS';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Vendor_Ledger_Entry__Document_Type_CaptionLbl: Label 'Document Type';
        GetCurrency__Currency_Code__CaptionLbl: Label 'Currency Code';
        OverDueDaysCaptionLbl: Label 'Due days';
        TotalCaptionLbl: Label 'Total';
        TotalCaption_Control1000000019Lbl: Label 'Total';

    local procedure GetCurrency(CurrencyCode: Code[10]): Code[10]
    var
        Currency: Record Currency;
    begin
        if CurrencyCode = '' then
            exit(GLSetup."LCY Code")
        else
            exit(CurrencyCode);
    end;
}

