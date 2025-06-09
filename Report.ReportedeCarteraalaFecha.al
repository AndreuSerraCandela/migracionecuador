report 55023 "Reporte de Cartera a la Fecha"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportedeCarteraalaFecha.rdlc';

    dataset
    {
        dataitem("Salesperson/Purchaser"; "Salesperson/Purchaser")
        {
            RequestFilterFields = "Code";
            column(HdrDateTime; Format(WorkDate) + ' ' + Format(Time))
            {
            }
            column(HdrCompanyName; CompanyName)
            {
            }
            column(HdrReportTitle; LBL_REP_TITLE + ' ' + Format(gEndDate))
            {
            }
            column(SPCode; Code)
            {
            }
            column(SPName; Name)
            {
            }
            column(gNetSales; gNetSales)
            {
            }
            column(gEndOfLastYearBal; gLYBal)
            {
            }
            column(gCYBal; gCYBal)
            {
            }
            column(gChequesPoftfech; gChequesPostfech)
            {
            }
            column(gCurrBal; gCurrBal)
            {
            }
            column(gCurrBalPerc; gCurrBalPerc)
            {
            }
            column(gCurrBalTotal; gCurrBalTotal)
            {
            }
            column(gChequesPoftfechTotal; gChequesPostfechTotal)
            {
            }
            column(gCYBalTotal; gCYBalTotal)
            {
            }
            column(gEndOfLastYearBalTotal; gLYBalTotal)
            {
            }
            column(gNetSalesTotal; gNetSalesTotal)
            {
            }
            column(SPCodeCaption; SPCodeCaptionLbl)
            {
            }
            column(SPNameCaption; SPNameCaptionLbl)
            {
            }
            column(gNetSalesCap; gNetSalesCapLbl)
            {
            }
            column(gEndOfLastYearBalCap; gEndOfLastYearBalCapLbl)
            {
            }
            column(gCYBalCap; gCYBalCapLbl)
            {
            }
            column(gChequesPoftfechCap; gChequesPoftfechCapLbl)
            {
            }
            column(gCurrBalPercCap; gCurrBalPercCapLbl)
            {
            }
            column(gCurrBalCap; gCurrBalCapLbl)
            {
            }
            column(gPercCap; gPercCapLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                lSkipCust: Boolean;
            begin
                gCYStartDate := CalcDate(DF_CY + '-' + DF_1Y + '+' + DF_1D, gEndDate);
                gCYEndDate := CalcDate('+' + DF_1Y + '-' + DF_1D, gCYStartDate);
                gLYStartDate := CalcDate('-' + DF_1Y, gCYStartDate);
                gLYEndDate := CalcDate('-' + DF_1Y, gCYEndDate);

                gNetSales := 0;
                gLYBal := 0;
                gCYBal := 0;
                gChequesPostfech := 0;
                gCurrBal := 0;
                gCurrBalPerc := 0;


                gCLE.Reset;
                gCLE.SetCurrentKey("Salesperson Code", "Posting Date");
                gCLE.SetRange("Salesperson Code", Code);
                gCLE.SetRange("Posting Date", gLYStartDate, gLYEndDate);
                gCLE.SetFilter("Document Type", '%1|%2|%3',
                  gCLE."Document Type"::Invoice, gCLE."Document Type"::Payment, gCLE."Document Type"::" ");
                if gCLE.FindSet then
                    repeat
                        lSkipCust := false;
                        if gRespCtr <> '' then begin
                            gCust.Get(gCLE."Customer No.");
                            if gCust."Responsibility Center" <> gRespCtr then
                                lSkipCust := true;
                        end;
                        if not lSkipCust then begin
                            if (gCLE."Document Type" = gCLE."Document Type"::Invoice) or (gCLE."Document Type" = gCLE."Document Type"::" ") then begin
                                gCLE.CalcFields(Amount, "Remaining Amount");
                                gNetSales += gCLE.Amount;
                                gLYBal += gCLE."Remaining Amount";
                            end;
                            if gCLE."Document Type" = gCLE."Document Type"::Payment then begin
                                if gCLE."Cheque Posfechado" then
                                    gChequesPostfech += +gCLE.Amount;
                            end;
                        end;
                    until gCLE.Next = 0;

                gCLE.SetRange("Posting Date", gCYStartDate, gCYEndDate);
                if gCLE.FindSet then
                    repeat
                        lSkipCust := false;
                        if gRespCtr <> '' then begin
                            gCust.Get(gCLE."Customer No.");
                            if gCust."Responsibility Center" <> gRespCtr then
                                lSkipCust := true;
                        end;
                        if not lSkipCust then begin
                            if (gCLE."Document Type" = gCLE."Document Type"::Invoice) or (gCLE."Document Type" = gCLE."Document Type"::" ") then begin
                                gCLE.CalcFields(Amount, "Remaining Amount");
                                gNetSales += gCLE.Amount;
                                gCYBal += gCLE."Remaining Amount";
                            end;
                            if gCLE."Document Type" = gCLE."Document Type"::Payment then begin
                                if gCLE."Cheque Posfechado" then
                                    gChequesPostfech += +gCLE.Amount;
                            end;
                        end;
                    until gCLE.Next = 0;

                gCurrBal := gLYBal + gCYBal;

                if gNetSales = 0 then
                    CurrReport.Skip;

                gNetSalesTotal += gNetSales;
                gLYBalTotal += gLYBal;
                gCYBalTotal := gCYBal;
                gChequesPostfechTotal += gChequesPostfech;
                gCurrBalTotal += gCurrBal;
                if gNetSales > 0 then
                    gCurrBalPerc := gCurrBal / gNetSales * 100;
            end;

            trigger OnPreDataItem()
            begin
                gNetSalesTotal := 0;
                gLYBalTotal := 0;
                gCYBalTotal := 0;
                gChequesPostfechTotal := 0;
                gCurrBalTotal := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Responsibility Center"; gRespCtr)
                {
                ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpRespCtr;
                    end;
                }
                field("End Date"; gEndDate)
                {
                ApplicationArea = All;
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

    trigger OnInitReport()
    begin
        gEndDate := WorkDate;
    end;

    trigger OnPreReport()
    begin
        if gEndDate = 0D then
            Error(ERR_ENDDATE);
    end;

    var
        LBL_REP_TITLE: Label 'Reporte de Cartera a la Fecha';
        gEndDate: Date;
        gRespCtr: Code[20];
        gNetSales: Decimal;
        gLYBal: Decimal;
        gCYBal: Decimal;
        gChequesPostfech: Decimal;
        gCurrBal: Decimal;
        gCurrBalPerc: Decimal;
        gNetSalesTotal: Decimal;
        gLYBalTotal: Decimal;
        gCYBalTotal: Decimal;
        gChequesPostfechTotal: Decimal;
        gCurrBalTotal: Decimal;
        gCLE: Record "Cust. Ledger Entry";
        gCYStartDate: Date;
        gCYEndDate: Date;
        gLYStartDate: Date;
        gLYEndDate: Date;
        DF_CY: Label 'CY';
        DF_1D: Label '1D';
        DF_1Y: Label '1Y';
        ERR_ENDDATE: Label 'The End Date must be specified';
        gCust: Record Customer;
        SPCodeCaptionLbl: Label 'Code';
        SPNameCaptionLbl: Label 'Name';
        gNetSalesCapLbl: Label 'Ventas Liquidas';
        gEndOfLastYearBalCapLbl: Label 'Deuda Ano Anter.';
        gCYBalCapLbl: Label 'Deuda campaña';
        gChequesPoftfechCapLbl: Label 'Cheques Postfec.';
        gCurrBalPercCapLbl: Label '% Cart. Pend.';
        gCurrBalCapLbl: Label 'Deuda Real';
        gPercCapLbl: Label '%';
        TotalCaptionLbl: Label 'Total:';


    procedure LookUpRespCtr()
    var
        lRespCtr: Record "Responsibility Center";
    begin
        if PAGE.RunModal(0, lRespCtr) = ACTION::LookupOK then
            gRespCtr := lRespCtr.Code;
    end;
}

