report 55016 "Customer situation detail"
{
    // .
    DefaultLayout = RDLC;
    RDLCLayout = './Customersituationdetail.rdlc';

    Caption = 'Customer situation detail';

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(HdrCompanyName; gCompanyInfo.Name)
            {
            }
            column(HdrDateTime; Format(WorkDate) + ' ' + Format(Time))
            {
            }
            column(HdrCompanyCity; LBL_CITY + ': ' + gCompanyInfo.City)
            {
            }
            column(CustNo; "No." + ' ' + Name)
            {
            }
            column(CustAddress; Address)
            {
            }
            column(CustCity; City)
            {
            }
            column(CustPhone; "Phone No.")
            {
            }
            column(HdrCustNo; HdrCustNoLbl)
            {
            }
            column(HdrAddress; FieldCaption(Address))
            {
            }
            column(HdrCity; HdrCityLbl)
            {
            }
            column(HdrPhone; FieldCaption("Phone No."))
            {
            }
            column(HdrDocType; "Cust. Ledger Entry".FieldCaption("Document Type"))
            {
            }
            column(HdrLocation; HdrLocationLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; Cust__Ledger_Entry__Document_No__CaptionLbl)
            {
            }
            column(CLEPaymentTermsCaption; CLEPaymentTermsCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__No__Comprobante_Fiscal_Caption; Cust__Ledger_Entry__No__Comprobante_Fiscal_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_Date_Caption; Cust__Ledger_Entry__Document_Date_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Due_Date_Caption; Cust__Ledger_Entry__Due_Date_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_AmountCaption; Cust__Ledger_Entry_AmountCaptionLbl)
            {
            }
            column(gCommentCaption; gCommentCaptionLbl)
            {
            }
            column(gSalesInvoice__Order_No__Caption; gSalesInvoice__Order_No__CaptionLbl)
            {
            }
            column(gObservationCaption; gObservationCaptionLbl)
            {
            }
            column(Customer_No_; "No.")
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD ("No.");
                DataItemTableView = SORTING ("Customer No.", Open, Positive, "Due Date", "Currency Code") ORDER(Ascending) WHERE (Open = CONST (true), "Document Type" = FILTER (Invoice));
                RequestFilterFields = "Posting Date", "Due Date";
                column(CLEDocType; "Document Type")
                {
                }
                column(CLELocationCode; Customer."Location Code")
                {
                }
                column(CLEPaymentTerms; gPaymentTerms.Description)
                {
                }
                column(Cust__Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Cust__Ledger_Entry__No__Comprobante_Fiscal_; "No. Comprobante Fiscal")
                {
                }
                column(Cust__Ledger_Entry__Document_Date_; "Document Date")
                {
                }
                column(Cust__Ledger_Entry__Due_Date_; "Due Date")
                {
                }
                column(Cust__Ledger_Entry_Amount; Amount)
                {
                }
                column(gComment; gComment)
                {
                }
                column(gSalesInvoice__Order_No__; gSalesInvoice."Order No.")
                {
                }
                column(gObservation; gObservation)
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
                    gSalesInvoice.Reset;
                    if "Document Type" = "Document Type"::Invoice then
                        if gSalesInvoice.Get("Document No.") then;
                    gComment := '';
                    if "Due Date" < WorkDate then
                        gComment := LBL_EXPIRED + ' ' + Format(WorkDate - "Due Date") + ' ' + LBL_DAYS;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                gPaymentTerms.Reset;
                if gPaymentTerms.Get("Payment Terms Code") then;
            end;

            trigger OnPreDataItem()
            begin
                gCompanyInfo.Get;
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
        gCompanyInfo: Record "Company Information";
        LBL_CITY: Label 'City';
        gPaymentTerms: Record "Payment Terms";
        gComment: Text[100];
        gSalesInvoice: Record "Sales Invoice Header";
        gObservation: Text[30];
        LBL_EXPIRED: Label 'Expired';
        LBL_DAYS: Label 'Days';
        HdrCustNoLbl: Label 'Customer';
        HdrCityLbl: Label 'City';
        HdrLocationLbl: Label 'Location Code';
        Cust__Ledger_Entry__Document_No__CaptionLbl: Label 'Document No.';
        CLEPaymentTermsCaptionLbl: Label 'Payment Terms';
        Cust__Ledger_Entry__No__Comprobante_Fiscal_CaptionLbl: Label 'Fiscal Document No.';
        Cust__Ledger_Entry__Document_Date_CaptionLbl: Label 'Document Date';
        Cust__Ledger_Entry__Due_Date_CaptionLbl: Label 'Due Date';
        Cust__Ledger_Entry_AmountCaptionLbl: Label 'Amount';
        gCommentCaptionLbl: Label 'Comment';
        gSalesInvoice__Order_No__CaptionLbl: Label 'Order No.';
        gObservationCaptionLbl: Label 'Observation';
}

