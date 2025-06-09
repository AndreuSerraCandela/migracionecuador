report 56109 "Saldo x Antigüedad Vendedor"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SaldoxAntigüedadVendedor.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Customer No.", "Posting Date", "Currency Code");
            RequestFilterFields = "Customer No.", "Salesperson Code", "Remaining Amt. (LCY)";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
            {
            }
            column(Cust__Ledger_Entry__Customer_No__; "Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Salesperson_Code_; "Salesperson Code")
            {
            }
            column(Cust__Ledger_EntryCaption; Cust__Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption; FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Salesperson_Code_Caption; FieldCaption("Salesperson Code"))
            {
            }
            column(Importe_Pendiente__DL_Caption; Importe_Pendiente__DL_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Customer No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total para ';
        Cust__Ledger_EntryCaptionLbl: Label 'Cust. Ledger Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Importe_Pendiente__DL_CaptionLbl: Label 'Importe Pendiente (DL)';
}

