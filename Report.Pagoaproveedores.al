report 56532 "Pago a proveedores"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Pagoaproveedores.rdlc';
    Caption = 'Vendor Payments';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Vendor Posting Group", "Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(STRSUBSTNO_Text000_CustDateFilter_; StrSubstNo(Text000, VendDateFilter))
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
            column(Detailed_Vendor_Ledg__Entry___Amount__LCY__; "Detailed Vendor Ledg. Entry"."Amount (LCY)")
            {
                AutoFormatType = 1;
            }
            column(Vendor___Detail_Trial_Bal_Caption; Vendor___Detail_Trial_Bal_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Detailed_Vendor_Ledg__Entry__Document_Type_Caption; Detailed_Vendor_Ledg__Entry__Document_Type_CaptionLbl)
            {
            }
            column(Detailed_Vendor_Ledg__Entry__Document_No__Caption; "Detailed Vendor Ledg. Entry".FieldCaption("Document No."))
            {
            }
            column(Detailed_Vendor_Ledg__Entry_AmountCaption; Detailed_Vendor_Ledg__Entry_AmountCaptionLbl)
            {
            }
            column(RemainingAmtLCYCaption; RemainingAmtLCYCaptionLbl)
            {
            }
            column(RemainingAmtCaption; RemainingAmtCaptionLbl)
            {
            }
            column(Detailed_Vendor_Ledg__Entry__Currency_Code_Caption; Detailed_Vendor_Ledg__Entry__Currency_Code_CaptionLbl)
            {
            }
            column(BankAccLedgEntry__Bank_Account_No__Caption; BankAccLedgEntry__Bank_Account_No__CaptionLbl)
            {
            }
            column(BankAccLedgEntry__Currency_Code_Caption; BankAccLedgEntry__Currency_Code_CaptionLbl)
            {
            }
            column(BankAccLedgEntry__Document_No__Caption; BankAccLedgEntry__Document_No__CaptionLbl)
            {
            }
            column(BankAccLedgEntry__External_Document_No__Caption; BankAccLedgEntry__External_Document_No__CaptionLbl)
            {
            }
            column(Vendor_DocumentCaption; Vendor_DocumentCaptionLbl)
            {
            }
            column(Vendor__Phone_No__Caption; FieldCaption("Phone No."))
            {
            }
            column(Total__LCY_Caption; Total__LCY_CaptionLbl)
            {
            }
            column(Vendor_Date_Filter; "Date Filter")
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
            dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"), "Currency Code" = FIELD("Currency Filter");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Entry Type", "Currency Code") WHERE("Entry Type" = CONST(Application), "Initial Document Type" = FILTER(Invoice | "Credit Memo"));
                column(FORMAT__Posting_Date___Control35; Format("Posting Date"))
                {
                }
                column(Detailed_Vendor_Ledg__Entry__Document_Type_; "Document Type")
                {
                }
                column(Detailed_Vendor_Ledg__Entry__Document_No__; "Document No.")
                {
                }
                column(Detailed_Vendor_Ledg__Entry_Amount; Amount)
                {
                    AutoFormatType = 1;
                }
                column(Detailed_Vendor_Ledg__Entry__Currency_Code_; GetCurrency("Currency Code"))
                {
                }
                column(RemainingAmt; RemainingAmt)
                {
                }
                column(RemainingAmtLCY; RemainingAmtLCY)
                {
                }
                column(BankAccLedgEntry__Document_No__; BankAccLedgEntry."Document No.")
                {
                }
                column(BankAccLedgEntry__Bank_Account_No__; BankAccLedgEntry."Bank Account No.")
                {
                }
                column(BankAccLedgEntry__Currency_Code_; GetCurrency(BankAccLedgEntry."Currency Code"))
                {
                }
                column(BankAccLedgEntry__External_Document_No__; BankAccLedgEntry."External Document No.")
                {
                }
                column(PageGroupNo_Control1000000015; "Amount (LCY)")
                {
                }
                column(Detailed_Vendor_Ledg__Entry__Detailed_Vendor_Ledg__Entry___Amount__LCY__; "Detailed Vendor Ledg. Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(FORMAT__Posting_Date__; Format("Posting Date"))
                {
                }
                column(Vendor__No___Control1000000019; Vendor."No.")
                {
                }
                column(Detailed_Vendor_Ledg__Entry__Detailed_Vendor_Ledg__Entry___Amount__LCY___Control1000000020; "Detailed Vendor Ledg. Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(FORMAT__Posting_Date___Control35Caption; FORMAT__Posting_Date___Control35CaptionLbl)
                {
                }
                column(Total____Caption; Total____CaptionLbl)
                {
                }
                column(Total____Caption_Control1000000018; Total____Caption_Control1000000018Lbl)
                {
                }
                column(Detailed_Vendor_Ledg__Entry_Entry_No_; "Entry No.")
                {
                }
                column(Detailed_Vendor_Ledg__Entry_Posting_Date; "Posting Date")
                {
                }
                column(Detailed_Vendor_Ledg__Entry_Vendor_No_; "Vendor No.")
                {
                }
                column(Detailed_Vendor_Ledg__Entry_Initial_Entry_Global_Dim__1; "Initial Entry Global Dim. 1")
                {
                }
                column(Detailed_Vendor_Ledg__Entry_Initial_Entry_Global_Dim__2; "Initial Entry Global Dim. 2")
                {
                }
                column(Detailed_Vendor_Ledg__Entry_Currency_Code; "Currency Code")
                {
                }

                trigger OnAfterGetRecord()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                    DetVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                    EndLoop: Boolean;
                begin
                    VendLedgEntry.Get("Vendor Ledger Entry No.");
                    VendLedgEntry.SetRange("Date Filter", 0D, "Posting Date");
                    VendLedgEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                    RemainingAmt := -VendLedgEntry."Remaining Amount";
                    RemainingAmtLCY := -VendLedgEntry."Remaining Amt. (LCY)";

                    EndLoop := false;

                    DetVendLedgEntry.Copy("Detailed Vendor Ledg. Entry");
                    DetVendLedgEntry.Ascending := not Ascending;
                    DetVendLedgEntry.SetRange("Vendor Ledger Entry No.", "Vendor Ledger Entry No.");
                    DetVendLedgEntry.SetRange("Posting Date", "Posting Date");
                    if DetVendLedgEntry.Find('-') then
                        repeat
                            RemainingAmt += DetVendLedgEntry.Amount;
                            RemainingAmtLCY += DetVendLedgEntry."Amount (LCY)";
                            if DetVendLedgEntry."Entry No." = "Entry No." then
                                EndLoop := true;
                        until (DetVendLedgEntry.Next = 0) or (EndLoop);

                    BankAccLedgEntry.SetCurrentKey("Transaction No.");
                    BankAccLedgEntry.SetRange("Transaction No.", "Transaction No.");
                    BankAccLedgEntry.SetRange("Document No.", "Document No.");
                    BankAccLedgEntry.SetRange("Document Type", "Document Type");
                    if not BankAccLedgEntry.FindFirst then begin
                        BankAccLedgEntry.SetRange("Document No.");
                        BankAccLedgEntry.SetRange("Document Type");
                        if not BankAccLedgEntry.FindFirst then
                            Clear(BankAccLedgEntry);
                    end;

                    "Document Type" := VendLedgEntry."Document Type";
                    "Document No." := VendLedgEntry."Document No.";
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CreateTotals("Amount (LCY)");
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
                //CurrReport.CreateTotals("Detailed Vendor Ledg. Entry"."Amount (LCY)");
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
                        Caption = 'New Page per Vendor';
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
        VendFilter := Vendor.GetFilters;
        VendDateFilter := Vendor.GetFilter("Date Filter");
        GLSetup.Get;
    end;

    var
        Text000: Label 'Period: %1';
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        PrintOnlyOnePerPage: Boolean;
        VendFilter: Text[250];
        VendDateFilter: Text[30];
        Text001: Label 'Appln Rounding:';
        PageGroupNo: Integer;
        RemainingAmt: Decimal;
        RemainingAmtLCY: Decimal;
        Vendor___Detail_Trial_Bal_CaptionLbl: Label 'VENDOR PAYMENTS';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Detailed_Vendor_Ledg__Entry__Document_Type_CaptionLbl: Label 'Document Type';
        Detailed_Vendor_Ledg__Entry_AmountCaptionLbl: Label 'Paid Amount';
        RemainingAmtLCYCaptionLbl: Label 'Conv. $ Balance';
        RemainingAmtCaptionLbl: Label 'Conv. Balance';
        Detailed_Vendor_Ledg__Entry__Currency_Code_CaptionLbl: Label 'Currency Code';
        BankAccLedgEntry__Bank_Account_No__CaptionLbl: Label 'Bank Account No.';
        BankAccLedgEntry__Currency_Code_CaptionLbl: Label 'Currency Code';
        BankAccLedgEntry__Document_No__CaptionLbl: Label 'Document No.';
        BankAccLedgEntry__External_Document_No__CaptionLbl: Label 'Bank Transaction No.';
        Vendor_DocumentCaptionLbl: Label 'Vendor Document';
        Total__LCY_CaptionLbl: Label 'Total ($)';
        FORMAT__Posting_Date___Control35CaptionLbl: Label 'Posting Date';
        Total____CaptionLbl: Label 'Total ($)';
        Total____Caption_Control1000000018Lbl: Label 'Total ($)';

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

