report 56115 "Analisis de Cobro por cliente"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AnalisisdeCobroporcliente.rdlc';
    Caption = 'Customer Billing Analysis';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Date Filter";
            column(USERID; UserId)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(PromDiasN; PromDiasN)
            {
            }
            column(PromDiasD; PromDiasD)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer_Collection_AnalysisCaption; Customer_Collection_AnalysisCaptionLbl)
            {
            }
            column(Customer_No_Caption; Customer_No_CaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Expected_Collection_time_in_daysCaption; Expected_Collection_time_in_daysCaptionLbl)
            {
            }
            column(Real_Collection_Time_in_DaysCaption; Real_Collection_Time_in_DaysCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CantDias := 0;
                CantDias1 := 0;
                PromDiasN := 0;
                PromDiasD := 0;
                I := 0;

                //Como debió pagar
                SIH.Reset;
                CopyFilter("Date Filter", SIH."Posting Date");
                SIH.SetRange("Sell-to Customer No.", "No.");
                if SIH.FindSet then
                    repeat
                        if PT.Get(SIH."Payment Terms Code") then begin
                            CantDiastxt := CopyStr(Format(PT."Due Date Calculation"), 1, StrLen((Format(PT."Due Date Calculation"))) - 1);
                            Evaluate(CantDias, CantDiastxt);
                            CantDias1 += CantDias;
                            I += 1;
                        end;
                    until SIH.Next = 0;

                if (CantDias1 <> 0) and (I <> 0) then
                    PromDiasN := CantDias1 / I;

                I := 0;

                //Como Paga
                CLE.Reset;
                CLE.SetRange("Customer No.", "No.");
                CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                CopyFilter("Date Filter", CLE."Posting Date");
                if CLE.FindSet then
                    repeat
                        //Pagos de las facturas que tienen cerradas por no. de orden
                        if CLE."Closed by Entry No." <> 0 then begin
                            CantDias2 += CLE."Closed at Date" - CLE."Posting Date";
                            I += 1;
                        end
                        else begin
                            CLE1.Reset;
                            CLE1.SetRange(CLE1."Closed by Entry No.", CLE."Entry No.");
                            CLE1.SetRange(CLE1."Document Type", CLE1."Document Type"::Payment);
                            if CLE1.FindFirst then begin
                                CantDias2 += CLE1."Posting Date" - CLE."Posting Date";
                                I += 1;
                            end;
                        end;
                    until CLE.Next = 0;

                if (CantDias2 <> 0) and (I <> 0) then
                    PromDiasD := CantDias2 / I;
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

    trigger OnPreReport()
    begin
        Filtros := Customer.GetFilters;
    end;

    var
        AnoAct: Decimal;
        PT: Record "Payment Terms";
        CantDias: Decimal;
        CantDiastxt: Text[5];
        I: Integer;
        SIH: Record "Sales Invoice Header";
        PromDiasN: Decimal;
        CantDias1: Decimal;
        CLE: Record "Cust. Ledger Entry";
        CLE1: Record "Cust. Ledger Entry";
        CantDias2: Decimal;
        PromDiasD: Decimal;
        Filtros: Text[1024];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Customer_Collection_AnalysisCaptionLbl: Label 'Customer Collection Analysis';
        Customer_No_CaptionLbl: Label 'Customer No.';
        NameCaptionLbl: Label 'Name';
        Expected_Collection_time_in_daysCaptionLbl: Label 'Expected Collection time in days';
        Real_Collection_Time_in_DaysCaptionLbl: Label 'Real Collection Time in Days';
}

