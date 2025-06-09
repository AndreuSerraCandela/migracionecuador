report 56091 "Lista Movs. Cliente"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListaMovsCliente.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code") ORDER(Ascending) WHERE("Document Type" = FILTER(Invoice | "Credit Memo" | " "));
            RequestFilterFields = "Customer No.", "Posting Date", "Document Type";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(Cust__Ledger_Entry__GETFILTERS; "Cust. Ledger Entry".GetFilters)
            {
            }
            column(Cust__Ledger_Entry__Customer_No__; "Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Document_Type_; "Document Type")
            {
            }
            column(Cust__Ledger_Entry__Document_No__; "Document No.")
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY___Control1103350008; "Remaining Amt. (LCY)")
            {
            }
            column(Cust__Ledger_EntryCaption; Cust__Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_Type_Caption; FieldCaption("Document Type"))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__Caption; FieldCaption("Remaining Amt. (LCY)"))
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption; FieldCaption("Customer No."))
            {
            }
            column(Total_para_cliente__Caption; Total_para_cliente__CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Entry No.");
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
        Cust__Ledger_EntryCaptionLbl: Label 'Cust. Ledger Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Total_para_cliente__CaptionLbl: Label 'Total para cliente  ';
}

