report 56531 "Ctas. por cobrar por promotor"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Ctasporcobrarporpromotor.rdlc';
    Caption = 'Ctas. por cobrar por promotor';

    dataset
    {
        dataitem("Salesperson/Purchaser"; "Salesperson/Purchaser")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code", Name;
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
            column(Customer_TABLECAPTION__________FilterString; "Salesperson/Purchaser".TableCaption + ': ' + FilterString)
            {
            }
            column(Salesperson_Purchaser_Code; Code)
            {
            }
            column(Salesperson_name; Name)
            {
            }
            column(Customer__Phone_No__; "Phone No.")
            {
            }
            column(Customer_Contact; "Home Page")
            {
            }
            column(Cust__Ledger_Entry___Remaining_Amt___LCY__; "Cust. Ledger Entry"."Remaining Amt. (LCY)")
            {
            }
            column(Cust__Ledger_Entry___Amount__LCY__; "Cust. Ledger Entry"."Amount (LCY)")
            {
            }
            column(Cust__Ledger_Entry___Amount__LCY____Cust__Ledger_Entry___Remaining_Amt___LCY__; "Cust. Ledger Entry"."Amount (LCY)" - "Cust. Ledger Entry"."Remaining Amt. (LCY)")
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
            column("NúmeroCaption"; NúmeroCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Amount__LCY__Caption; "Cust. Ledger Entry".FieldCaption("Amount (LCY)"))
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption; "Cust. Ledger Entry".FieldCaption("Customer No."))
            {
            }
            column(Importe_Pendiente__DL_Caption; "Cust. Ledger Entry".FieldCaption("Remaining Amt. (LCY)"))
            {
            }
            column(Amount__LCY____Remaining_Amt___LCY__Caption; Amount__LCY____Remaining_Amt___LCY__CaptionLbl)
            {
            }
            column(Customer_Name_Control1000000012Caption; Customer_Name_Control1000000012CaptionLbl)
            {
            }
            column(Phone_Caption; Phone_CaptionLbl)
            {
            }
            column(Contact_Caption; Contact_CaptionLbl)
            {
            }
            column(ClienteCaption; ClienteCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Salesperson_Purchaser_Date_Filter; "Date Filter")
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Salesperson Code" = FIELD (Code), "Posting Date" = FIELD ("Date Filter");
                DataItemTableView = SORTING ("Customer No.", "Posting Date", Open, "Provisionado por insolvencia") WHERE (Open = CONST (true));
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
                column(Cust__Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Amount__LCY__; "Amount (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Customer_No__; "Customer No.")
                {
                }
                column(Customer_Name; Customer.Name)
                {
                }
                column(Amount__LCY____Remaining_Amt___LCY__; "Amount (LCY)" - "Remaining Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amt___LCY___Control1000000001; "Remaining Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Amount__LCY___Control1000000002; "Amount (LCY)")
                {
                }
                column(Salesperson_Purchaser__Code; "Salesperson/Purchaser".Code)
                {
                }
                column(Amount__LCY____Remaining_Amt___LCY___Control1000000015; "Amount (LCY)" - "Remaining Amt. (LCY)")
                {
                }
                column(TotalCaption_Control1000000003; TotalCaption_Control1000000003Lbl)
                {
                }
                column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Salesperson_Code; "Salesperson Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //IF "Customer No." <> Customer."No." THEN
                    if not Customer.Get("Customer No.") then
                        Clear(Customer);
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CreateTotals("Cust. Ledger Entry"."Remaining Amt. (LCY)", "Cust. Ledger Entry"."Amount (LCY)");

                    if ToDate = 0D then
                        DateToConvertCurrency := WorkDate
                    else begin
                        SetRange("Due Date", 0D, ToDate);
                        DateToConvertCurrency := ToDate;
                    end;

                    if GetFilter("Posting Date") <> '' then
                        CopyFilter("Posting Date", "Date Filter");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                sumUSD := 0;
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CreateTotals("Cust. Ledger Entry"."Remaining Amt. (LCY)", "Cust. Ledger Entry"."Amount (LCY)");
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
        FilterString := "Salesperson/Purchaser".GetFilters;

        if ToDate <> 0D then
            Subtitle := Text000 + ' ' + Format(ToDate, 0, 4) + ')';
    end;

    var
        CompanyInformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Customer: Record Customer;
        FilterString: Text[250];
        Subtitle: Text[126];
        ToDate: Date;
        DateToConvertCurrency: Date;
        Text000: Label '(Open Entries Due as of';
        Text1020000: Label ' *** Customer is Blocked for %1 processing ***';
        Text002: Label 'Amount due is in %1';
        Text003: Label 'Amounts are in the customer''s local currency (report totals are in %1).';
        Text004: Label 'Report Total Amount Due (%1)';
        sumUSD: Decimal;
        sumPostingGroup: Decimal;
        sumUSDTotal: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        "Análisis_Cta_ClientesCaptionLbl": Label 'ACCOUNT STATUS BY CUSTOMER (Detailed)';
        DocumentCaptionLbl: Label 'Document';
        TipoCaptionLbl: Label 'Tipo';
        "NúmeroCaptionLbl": Label 'Número';
        Amount__LCY____Remaining_Amt___LCY__CaptionLbl: Label 'Advance ($)';
        Customer_Name_Control1000000012CaptionLbl: Label 'Name';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Zone:';
        ClienteCaptionLbl: Label 'Salesperson';
        TotalCaptionLbl: Label 'Total';
        TotalCaption_Control1000000003Lbl: Label 'Total';

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

