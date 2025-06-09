report 56110 "Saldo x Antig. Vendedor Det."
{
    DefaultLayout = RDLC;
    RDLCLayout = './SaldoxAntigVendedorDet.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Customer No.", "Posting Date", "Currency Code");
            RequestFilterFields = "Customer No.", "Document No.", "Salesperson Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Cust__Ledger_Entry__Customer_No__; "Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Document_No__; "Document No.")
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_; "Currency Code")
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
            {
            }
            column(Cust__Ledger_Entry__Salesperson_Code_; "Salesperson Code")
            {
            }
            column(TotalFor___FIELDCAPTION__Customer_No___; TotalFor + FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY___Control1000000037; "Remaining Amt. (LCY)")
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
            column(Cust__Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_Caption; FieldCaption("Currency Code"))
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__Caption; FieldCaption("Remaining Amt. (LCY)"))
            {
            }
            column(Cust__Ledger_Entry__Salesperson_Code_Caption; FieldCaption("Salesperson Code"))
            {
            }
            column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Document No.");
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
        "DescripciónCaptionLbl": Label 'Descripción';
}

