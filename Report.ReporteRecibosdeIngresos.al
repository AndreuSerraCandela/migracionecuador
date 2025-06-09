report 56076 "Reporte Recibos de Ingresos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReporteRecibosdeIngresos.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Document No.", "Document Type", "Customer No.");
            RequestFilterFields = "Document No.", "Posting Date", "Document Type";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }

            column(USERID; UserId)
            {
            }
            column(Cust__Ledger_Entry__Document_No__; "Document No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Customer_No__; "Customer No.")
            {
            }
            column(Cust__Ledger_Entry_Description; Description)
            {
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
            column(Cust__Ledger_Entry__Salesperson_Code_; "Salesperson Code")
            {
            }
            column(Cust__Ledger_Entry__Applies_to_Doc__No__; "Applies-to Doc. No.")
            {
            }
            column(Cust__Ledger_EntryCaption; Cust__Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption; FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_Caption; FieldCaption("Currency Code"))
            {
            }
            column(Cust__Ledger_Entry_AmountCaption; FieldCaption(Amount))
            {
            }
            column(Cust__Ledger_Entry__Amount__LCY__Caption; FieldCaption("Amount (LCY)"))
            {
            }
            column(Cust__Ledger_Entry__Salesperson_Code_Caption; FieldCaption("Salesperson Code"))
            {
            }
            column(Cust__Ledger_Entry__Applies_to_Doc__No__Caption; FieldCaption("Applies-to Doc. No."))
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
}

