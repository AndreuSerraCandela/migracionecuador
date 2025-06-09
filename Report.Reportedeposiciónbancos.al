report 56056 "Reporte de posición bancos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reportedeposiciónbancos.rdlc';

    dataset
    {
        dataitem(Cabecera; "Integer")
        {
            DataItemTableView = SORTING (Number) ORDER(Ascending);
            MaxIteration = 1;
            column(COMPANYNAME; CompanyName)
            {
            }
            column(wTxtMoneda; wTxtMoneda)
            {
            }
            column(wFechaBalance; wFechaBalance)
            {
            }
            column(wTipoCambioDR; wTipoCambioDR)
            {
                DecimalPlaces = 0 : 5;
            }
            column(TODAY; Today)
            {
            }
            column(TIME; Time)
            {
                AutoFormatType = 0;
            }
            column(REPORTE_POSICION_EN_BANCOSCaption; REPORTE_POSICION_EN_BANCOSCaptionLbl)
            {
            }
            column(Cuenta_bancariaCaption; Cuenta_bancariaCaptionLbl)
            {
            }
            column("Saldo_inicial_del_díaCaption"; Saldo_inicial_del_díaCaptionLbl)
            {
            }
            column(IngresosCaption; IngresosCaptionLbl)
            {
            }
            column(EgresosCaption; EgresosCaptionLbl)
            {
            }
            column(Saldo_en_librosCaption; Saldo_en_librosCaptionLbl)
            {
            }
            column(MonedaCaption; MonedaCaptionLbl)
            {
            }
            column("Al_DíaCaption"; Al_DíaCaptionLbl)
            {
            }
            column(Tipo_de_CambioCaption; Tipo_de_CambioCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(Cabecera_Number; Number)
            {
            }
            dataitem("Bank Account"; "Bank Account")
            {
                DataItemTableView = SORTING ("Currency Code") ORDER(Descending);
                column(Bank_Account__Currency_Code_; "Currency Code")
                {
                }
                column(No________Name; wNombre1)
                {
                }
                column(wSaldoInicial; wSaldoInicial)
                {
                }
                column(wIngresos; wIngresos)
                {
                }
                column(wEgresos; wEgresos)
                {
                }
                column(Bank_Account__Net_Change_; "Net Change")
                {
                }
                column(wNombre2; wNombre2)
                {
                }
                column(Bank_Account__Net_Change__Control1000000012; "Net Change")
                {
                }
                column(MONEDACaption_Control1000000007; MONEDACaption_Control1000000007Lbl)
                {
                }
                column(TotalesCaption; TotalesCaptionLbl)
                {
                }
                column(Bank_Account_No_; "No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    lrBank: Record "Bank Account";
                    lrMov: Record "Bank Account Ledger Entry";
                begin
                    Clear(wSaldoInicial);
                    Clear(wIngresos);
                    Clear(wEgresos);

                    if "Bank Account No." <> '' then begin
                        wNombre1 := CopyStr("No.", 1, 3) + ' ' + "Bank Account No.";
                        wNombre2 := "Search Name";
                    end
                    else begin
                        wNombre1 := Name;
                        wNombre2 := "Search Name";
                    end;

                    lrBank.Reset;
                    lrBank.Get("Bank Account"."No.");
                    lrBank.SetRange("Date Filter", 0D, wFechaBalance - 1);
                    lrBank.CalcFields("Net Change");
                    wSaldoInicial := lrBank."Net Change";

                    //... Se calculan los ingresos y egresos en la fecha de balance.
                    lrMov.Reset;
                    lrMov.SetCurrentKey("Bank Account No.", "Posting Date");
                    lrMov.SetRange("Bank Account No.", "Bank Account"."No.");
                    lrMov.SetRange("Posting Date", wFechaBalance);
                    lrMov.SetFilter(Amount, '>=%1', 0);
                    if lrMov.Find('-') then
                        repeat
                            wIngresos := wIngresos + lrMov.Amount;
                        until lrMov.Next = 0;

                    lrMov.SetFilter(Amount, '<%1', 0);
                    if lrMov.Find('-') then
                        repeat
                            wEgresos := wEgresos + Abs(lrMov.Amount);
                        until lrMov.Next = 0;

                    CalcFields("Net Change");


                    if ("Currency Code" = wDivisaLocal) or ("Currency Code" = '') then
                        wSaldoDL := wSaldoDL + "Net Change";

                    if "Currency Code" = wDivisaRef then
                        wSaldoDR := wSaldoDR + "Net Change";
                end;

                trigger OnPostDataItem()
                var
                    lrExchangeRate: Record "Currency Exchange Rate";
                    lAux: Decimal;
                begin
                    lAux := lrExchangeRate.ExchangeAmtFCYToFCY(wFechaBalance, '', wDivisaRef, wSaldoDL);
                    wTotalDR := wSaldoDR + lAux;
                end;

                trigger OnPreDataItem()
                begin
                    if wDivisa <> '' then
                        SetRange("Currency Code", wDivisa);

                    SetRange("Date Filter", 0D, wFechaBalance);
                end;
            }
            dataitem(Total; "Integer")
            {
                DataItemTableView = SORTING (Number) ORDER(Ascending);
                MaxIteration = 1;
                column(wTotalDR; wTotalDR)
                {
                }
                column(TOTAL_GENERAL_DOLARESCaption; TOTAL_GENERAL_DOLARESCaptionLbl)
                {
                }
                column(Total_Number; Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                lrExchangeRate: Record "Currency Exchange Rate";
                lAux: Decimal;
            begin
                lAux := lrExchangeRate.ExchangeAmtFCYToFCY(wFechaBalance, '', wDivisaRef, wSaldoDL);
                wTotalDR := wSaldoDR + lAux;
            end;

            trigger OnPreDataItem()
            var
                lrConfig: Record "General Ledger Setup";
                lrExchangeRate: Record "Currency Exchange Rate";
            begin
                lrConfig.Get;
                wDivisaLocal := lrConfig."LCY Code";

                //... De momento, a piñón fijo.
                wDivisaRef := 'USD';

                wTipoCambioDR := 1 / lrExchangeRate.ExchangeRate(wFechaBalance, wDivisaRef);

                wSaldoDL := 0;
                wSaldoDR := 0;

                if wDivisa <> '' then
                    wTxtMoneda := wDivisa
                else
                    wTxtMoneda := Text001;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha Balance"; wFechaBalance)
                {
                ApplicationArea = All;
                }
                field(Moneda; wDivisa)
                {
                ApplicationArea = All;
                    TableRelation = Currency.Code;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            wFechaBalance := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        TextL001: Label 'Falta especificar la fecha de balance';
    begin
        if wFechaBalance = 0D then
            Error(TextL001);
    end;

    var
        wFechaBalance: Date;
        wSaldoInicial: Decimal;
        wIngresos: Decimal;
        wEgresos: Decimal;
        wDivisa: Code[10];
        Text001: Label 'Todos';
        wTxtMoneda: Text[30];
        wTipoCambioDR: Decimal;
        wDivisaLocal: Code[10];
        wDivisaRef: Code[10];
        wSaldoDL: Decimal;
        wSaldoDR: Decimal;
        wTotalDR: Decimal;
        wNombre1: Text[80];
        wNombre2: Text[50];
        REPORTE_POSICION_EN_BANCOSCaptionLbl: Label 'REPORTE POSICION EN BANCOS';
        Cuenta_bancariaCaptionLbl: Label 'Cuenta bancaria';
        "Saldo_inicial_del_díaCaptionLbl": Label 'Saldo inicial del día';
        IngresosCaptionLbl: Label 'Ingresos';
        EgresosCaptionLbl: Label 'Egresos';
        Saldo_en_librosCaptionLbl: Label 'Saldo en libros';
        MonedaCaptionLbl: Label 'Moneda';
        "Al_DíaCaptionLbl": Label 'Al Día';
        Tipo_de_CambioCaptionLbl: Label 'Tipo de Cambio';
        PageCaptionLbl: Label 'Page';
        MONEDACaption_Control1000000007Lbl: Label 'MONEDA';
        TotalesCaptionLbl: Label 'Totales';
        TOTAL_GENERAL_DOLARESCaptionLbl: Label 'TOTAL GENERAL DOLARES';
}

