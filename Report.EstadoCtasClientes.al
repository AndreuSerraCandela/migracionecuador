report 56524 "Estado Ctas. Clientes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EstadoCtasClientes.rdlc';
    Caption = 'Análisis Cta Clientes';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING ("Customer Posting Group") ORDER(Ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group", "Currency Code", "Payment Terms Code";
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
            column(Subtitle; Subtitle)
            {
            }
            column(Customer_TABLECAPTION__________FilterString; Customer.TableCaption + ': ' + FilterString)
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
            column(Customer_Contact; Contact)
            {
            }
            column(ctacble; ctacble)
            {
            }
            column(Customer_Address; Address)
            {
            }
            column(Customer_City; City)
            {
            }
            column(Customer__Post_Code_; "Post Code")
            {
            }
            column(CustomerBlockedText; CustomerBlockedText)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Análisis_Cta_ClientesCaption"; Análisis_Cta_ClientesCaptionLbl)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption; "Cust. Ledger Entry".FieldCaption("Posting Date"))
            {
            }
            column(TipoCaption; TipoCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Due_Date_Caption; "Cust. Ledger Entry".FieldCaption("Due Date"))
            {
            }
            column(Importe_Pendiente__DL_Caption; "Cust. Ledger Entry".FieldCaption("Remaining Amt. (LCY)"))
            {
            }
            column("NúmeroCaption"; NúmeroCaptionLbl)
            {
            }
            column("Días_Venci_Caption"; Días_Venci_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_Caption; Cust__Ledger_Entry__Currency_Code_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amount_Caption; "Cust. Ledger Entry".FieldCaption("Remaining Amount"))
            {
            }
            column(Cust__Ledger_Entry_AmountCaption; "Cust. Ledger Entry".FieldCaption(Amount))
            {
            }
            column(Cust__Ledger_Entry__Amount__LCY__Caption; "Cust. Ledger Entry".FieldCaption("Amount (LCY)"))
            {
            }
            column(Phone_Caption; Phone_CaptionLbl)
            {
            }
            column(Contact_Caption; Contact_CaptionLbl)
            {
            }
            column(Contact_Caption_Control1000000002; Contact_Caption_Control1000000002Lbl)
            {
            }
            column(ClienteCaption; ClienteCaptionLbl)
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Customer_Currency_Filter; "Currency Filter")
            {
            }
            column(Customer_Date_Filter; "Date Filter")
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD ("No."), "Global Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"), "Currency Code" = FIELD ("Currency Filter"), "Posting Date" = FIELD ("Date Filter");
                DataItemTableView = SORTING ("Customer No.", Open, Positive, "Due Date") WHERE (Open = CONST (true));
                column(Cust__Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Cust__Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(Cust__Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Cust__Ledger_Entry__Due_Date_; "Due Date")
                {
                }
                column(OverDueDays; OverDueDays)
                {
                }
                column(Cust__Ledger_Entry__Currency_Code_; GetCurrency("Currency Code"))
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amount_; "Remaining Amount")
                {
                }
                column(RemainAmountToPrint; "Remaining Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry_Amount; Amount)
                {
                }
                column(Cust__Ledger_Entry__Amount__LCY__; "Amount (LCY)")
                {
                }
                column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Customer_No_; "Customer No.")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(Cust__Ledger_Entry_Currency_Code; "Currency Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                    if ("Due Date" <> 0D) and (ToDate > "Due Date") and ("Remaining Amount" > 0) then
                        OverDueDays := ToDate - "Due Date"
                    else
                        OverDueDays := 0;

                    if not CurrTotalBuff.Get("Currency Code") then begin
                        CurrTotalBuff."Currency Code" := "Currency Code";
                        CurrTotalBuff."Total Amount" := "Remaining Amount";
                        CurrTotalBuff."Total Amount (LCY)" := "Remaining Amt. (LCY)";
                        CurrTotalBuff.Insert;
                    end
                    else begin
                        CurrTotalBuff."Total Amount" += "Remaining Amount";
                        CurrTotalBuff."Total Amount (LCY)" += "Remaining Amt. (LCY)";
                        CurrTotalBuff.Modify;
                    end;

                    if not CustCurrTotalBuff.Get("Currency Code") then begin
                        CustCurrTotalBuff."Currency Code" := "Currency Code";
                        CustCurrTotalBuff."Total Amount" := "Remaining Amount";
                        CustCurrTotalBuff."Total Amount (LCY)" := "Remaining Amt. (LCY)";
                        CustCurrTotalBuff.Insert;
                    end
                    else begin
                        CustCurrTotalBuff."Total Amount" += "Remaining Amount";
                        CustCurrTotalBuff."Total Amount (LCY)" += "Remaining Amt. (LCY)";
                        CustCurrTotalBuff.Modify;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CreateTotals("Remaining Amt. (LCY)", "Remaining Amt. (LCY)");
                    if ToDate = 0D then
                        DateToConvertCurrency := WorkDate
                    else begin
                        SetRange("Due Date", 0D, ToDate);
                        DateToConvertCurrency := ToDate;
                    end;

                    if GetFilter("Posting Date") <> '' then
                        CopyFilter("Posting Date", "Date Filter");

                    CustCurrTotalBuff.Reset;
                    CustCurrTotalBuff.DeleteAll;
                end;
            }
            dataitem(CustCurrencyTotal; "Integer")
            {
                DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));
                column(CustomerNo; Customer."No.")
                {
                }
                column(GetCurrency_CustCurrTotalBuff__Currency_Code__; GetCurrency(CustCurrTotalBuff."Currency Code"))
                {
                }
                column(CustCurrTotalBuff__Total_Amount_; CustCurrTotalBuff."Total Amount")
                {
                }
                column(CustCurrTotalBuff__Total_Amount__LCY__; CustCurrTotalBuff."Total Amount (LCY)")
                {
                }
                column(CustCurrencyTotal_Number; Number)
                {
                }
                column(CustCurrTotalBuff__Total_Amount__Control1000000016; CustCurrTotalBuff."Total Amount")
                {
                }
                column(CustCurrTotalBuff__Total_Amount__LCY___Control1000000017; CustCurrTotalBuff."Total Amount (LCY)")
                {
                }
                column(GetCurrency_CustCurrTotalBuff__Currency_Code___Control1000000018; GetCurrency(CustCurrTotalBuff."Currency Code"))
                {
                }
                column(CustCurrTotalBuff__Total_Amount__LCY___Control1000000020; CustCurrTotalBuff."Total Amount (LCY)")
                {
                }
                column(Customer_totalCaption; Customer_totalCaptionLbl)
                {
                }
                column(Customer_total__Caption; Customer_total__CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then
                        if CustCurrTotalBuff.Next = 0 then
                            CurrReport.Break;
                end;

                trigger OnPreDataItem()
                begin
                    if not CustCurrTotalBuff.FindSet then
                        CurrReport.Break;

                    //CurrReport.CreateTotals(CustCurrTotalBuff."Total Amount", CustCurrTotalBuff."Total Amount (LCY)");
                end;
            }

            trigger OnAfterGetRecord()
            var
                recPosting: Record "Customer Posting Group";
            begin
                if Blocked <> Blocked::" " then
                    CustomerBlockedText := StrSubstNo(Text1020000, Blocked)
                else
                    CustomerBlockedText := '';

                recPosting.Reset;
                if recPosting.Get("Customer Posting Group") then
                    ctacble := recPosting."Receivables Account"
                else
                    ctacble := '';

                sumUSD := 0;
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CreateTotals("Cust. Ledger Entry"."Remaining Amt. (LCY)");
            end;
        }
        dataitem(CurrencyTotal; "Integer")
        {
            DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));
            column(CurrTotalBuff__Total_Amount_; CurrTotalBuff."Total Amount")
            {
            }
            column(CurrTotalBuff__Total_Amount__LCY__; CurrTotalBuff."Total Amount (LCY)")
            {
            }
            column(GetCurrency_CurrTotalBuff__Currency_Code__; GetCurrency(CurrTotalBuff."Currency Code"))
            {
            }
            column(CurrencyTotal_Number; Number)
            {
            }
            column(CurrTotalBuff__Total_Amount__Control1000000026; CurrTotalBuff."Total Amount")
            {
            }
            column(CurrTotalBuff__Total_Amount__LCY___Control1000000027; CurrTotalBuff."Total Amount (LCY)")
            {
            }
            column(GetCurrency_CurrTotalBuff__Currency_Code___Control1000000028; GetCurrency(CurrTotalBuff."Currency Code"))
            {
            }
            column(CustCurrTotalBuff__Total_Amount__LCY___Control1000000029; CustCurrTotalBuff."Total Amount (LCY)")
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Total__Caption; Total__CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number > 1 then
                    if CurrTotalBuff.Next = 0 then
                        CurrReport.Break;
            end;

            trigger OnPreDataItem()
            begin
                if not CurrTotalBuff.FindSet then
                    CurrReport.Break;

                //CurrReport.CreateTotals(CurrTotalBuff."Total Amount", CurrTotalBuff."Total Amount (LCY)");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("<Control1000000001>"; ToDate)
                {
                ApplicationArea = All;
                    Caption = 'Fecha final';
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
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
        CompanyInformation.Get;
        GLSetup.Get;
        FilterString := Customer.GetFilters;

        if ToDate <> 0D then
            Subtitle := Text000 + ' ' + Format(ToDate, 0, 4) + ')';
    end;

    var
        CompanyInformation: Record "Company Information";
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        CustCurrTotalBuff: Record "Currency Total Buffer" temporary;
        CurrTotalBuff: Record "Currency Total Buffer" temporary;
        FilterString: Text[250];
        CustomerBlockedText: Text[80];
        Subtitle: Text[126];
        ToDate: Date;
        DateToConvertCurrency: Date;
        OverDueDays: Integer;
        Text000: Label '(Open Entries Due as of';
        Text1020000: Label ' *** Customer is Blocked for %1 processing ***';
        Text002: Label 'Amount due is in %1';
        Text003: Label 'Amounts are in the customer''s local currency (report totals are in %1).';
        Text004: Label 'Report Total Amount Due (%1)';
        sumUSD: Decimal;
        sumPostingGroup: Decimal;
        ctacble: Text[20];
        sumUSDTotal: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        "Análisis_Cta_ClientesCaptionLbl": Label 'ACCOUNT STATUS BY CUSTOMER (Detailed)';
        DocumentCaptionLbl: Label 'Document';
        TipoCaptionLbl: Label 'Tipo';
        "NúmeroCaptionLbl": Label 'Número';
        "Días_Venci_CaptionLbl": Label 'Días Venci.';
        Cust__Ledger_Entry__Currency_Code_CaptionLbl: Label 'Currency Code';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Contact:';
        Contact_Caption_Control1000000002Lbl: Label 'Acc. No.:';
        ClienteCaptionLbl: Label 'Customer';
        Customer_totalCaptionLbl: Label 'Customer total';
        Customer_total__CaptionLbl: Label 'Customer total $';
        TotalCaptionLbl: Label 'Total';
        Total__CaptionLbl: Label 'Total $';

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

