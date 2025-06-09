report 56075 "Antiguedad Deuda Opc. Detalle"
{
    //               .-
    DefaultLayout = RDLC;
    RDLCLayout = './AntiguedadDeudaOpcDetalle.rdlc';

    Caption = 'Customer - Sum/Detail Aging Simp.';

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
            column(Detallado; Detallado)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter; Customer.TableCaption + ': ' + CustFilter)
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
            column(CustBalanceDueLCY_1_; CustBalanceDueLCY[1])
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
            column(CustBalanceDueLCY_1__Control29; CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(Customer__Salesperson_Code_; "Salesperson Code")
            {
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
            column(CustBalanceDueLCY_1__Control35; CustBalanceDueLCY[1])
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
            column(CustBalanceDueLCY_1__Control41; CustBalanceDueLCY[1])
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
            column(CustBalanceDueLCY_1__Control29Caption; CustBalanceDueLCY_1__Control29CaptionLbl)
            {
            }
            column(Sales_PersonCaption; Sales_PersonCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__Caption; "Cust. Ledger Entry".FieldCaption("Remaining Amt. (LCY)"))
            {
            }
            column(Cust__Ledger_Entry__Original_Amt___LCY__Caption; "Cust. Ledger Entry".FieldCaption("Original Amt. (LCY)"))
            {
            }
            column(Sales_PersonCaption_Control1103355022; Sales_PersonCaption_Control1103355022Lbl)
            {
            }
            column(Cust__Ledger_Entry__Due_Date_Caption; "Cust. Ledger Entry".FieldCaption("Due Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; "Cust. Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry__Document_Type_Caption; "Cust. Ledger Entry".FieldCaption("Document Type"))
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption; "Cust. Ledger Entry".FieldCaption("Posting Date"))
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
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD ("No.");
                RequestFilterFields = "Posting Date", "Document Type", "Salesperson Code";
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
                column(Cust__Ledger_Entry__Original_Amt___LCY__; "Original Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
                {
                }
                column(txtVendedor; Vendedor)
                {
                }
                column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Customer_No_; "Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rVendedor.Reset;
                    //Evaluar que no me aparezca un codigo vacío
                    if "Cust. Ledger Entry"."Salesperson Code" <> '' then begin
                        rVendedor.Get("Cust. Ledger Entry"."Salesperson Code");
                        Vendedor := "Cust. Ledger Entry"."Salesperson Code" + '-' +
                                                                     rVendedor.Name;
                    end
                    else
                        Vendedor := '';
                end;
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
                if not PrintCust then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CreateTotals(CustBalanceDueLCY);
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
                field(StartDate; StartDate)
                {
                ApplicationArea = All;
                    Caption = 'Fecha incial';
                }
                field(Detallado; Detallado)
                {
                ApplicationArea = All;
                    Caption = 'Detallado';
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
    end;

    var
        Text001: Label 'As of %1';
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        rVendedor: Record "Salesperson/Purchaser";
        StartDate: Date;
        CustFilter: Text[250];
        PeriodStartDate: array[6] of Date;
        CustBalanceDueLCY: array[5] of Decimal;
        PrintCust: Boolean;
        i: Integer;
        Detallado: Boolean;
        Vendedor: Text[50];
        Customer___Summary_Aging_Simp_CaptionLbl: Label 'Customer - Summary Aging Simp.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        CustBalanceDueLCY_5__Control25CaptionLbl: Label 'Not Due';
        CustBalanceDueLCY_4__Control26CaptionLbl: Label '0-30 days';
        CustBalanceDueLCY_3__Control27CaptionLbl: Label '31-60 days';
        CustBalanceDueLCY_2__Control28CaptionLbl: Label '61-90 days';
        CustBalanceDueLCY_1__Control29CaptionLbl: Label 'Over 90 days';
        Sales_PersonCaptionLbl: Label 'Sales Person';
        Sales_PersonCaption_Control1103355022Lbl: Label 'Sales Person';
        CustBalanceDueLCY_5_CaptionLbl: Label 'Continued';
        CustBalanceDueLCY_5__Control31CaptionLbl: Label 'Continued';
        TotalCaptionLbl: Label 'Total';
}

