report 56092 "Antiguedad Saldo Cliente"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AntiguedadSaldoCliente.rdlc';
    Caption = 'Customer - Summary Aging Simp.';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(FiltroCust; FiltroCust)
            {
            }
            column(EmptyString; '')
            {
            }
            column(FechaInicPeriodo_4_; FechaInicPeriodo[4])
            {
            }
            column(wLabelRango_4_; wLabelRango[4])
            {
            }
            column(FechaFinPeriodo_4_; FechaFinPeriodo[4])
            {
            }
            column(FechaInicPeriodo_3_; FechaInicPeriodo[3])
            {
            }
            column(wLabelRango_3_; wLabelRango[3])
            {
            }
            column(FechaFinPeriodo_3_; FechaFinPeriodo[3])
            {
            }
            column(FechaInicPeriodo_2_; FechaInicPeriodo[2])
            {
            }
            column(wLabelRango_2_; wLabelRango[2])
            {
            }
            column(FechaFinPeriodo_2_; FechaFinPeriodo[2])
            {
            }
            column(FechaInicPeriodo_1_; FechaInicPeriodo[1])
            {
            }
            column(wLabelRango_1_; wLabelRango[1])
            {
            }
            column(FechaFinPeriodo_1_; FechaFinPeriodo[1])
            {
            }
            column(FORMAT_wFechaInicio_0_4_; Format(wFechaInicio, 0, 4))
            {
            }
            column(wLabelRango_5_; wLabelRango[5])
            {
            }
            column(FechaInicPeriodo_5_; FechaInicPeriodo[5])
            {
            }
            column(FechaFinPeriodo_5_; FechaFinPeriodo[5])
            {
            }
            column(wLabelRango_6_; wLabelRango[6])
            {
            }
            column(FechaInicPeriodo_6_; FechaInicPeriodo[6])
            {
            }
            column(FechaFinPeriodo_6_; FechaFinPeriodo[6])
            {
            }
            column(wDetallado; wDetallado)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(wTotalSaldo; wTotalSaldo)
            {
            }
            column(wTotalVencido; wTotalVencido)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wTotalImporte120; wTotalImporte120)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wTotalImporte90; wTotalImporte90)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wTotalImporte60; wTotalImporte60)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wTotalImporte30; wTotalImporte30)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wTotalImporteNoVencido; wTotalImporteNoVencido)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wTotalImporte150; wTotalImporte150)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wTotalImporte180; wTotalImporte180)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalSaldo; wGranTotalSaldo)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalVencido; wGranTotalVencido)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporte120; wGranTotalImporte120)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporte90; wGranTotalImporte90)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporte60; wGranTotalImporte60)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporte30; wGranTotalImporte30)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporteNoVencido; wGranTotalImporteNoVencido)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporte180; wGranTotalImporte180)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporte150; wGranTotalImporte150)
            {
                DecimalPlaces = 2 : 2;
            }
            column(Customer___Summary_Aging_Simp_Caption; Customer___Summary_Aging_Simp_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("DíasCaption"; DíasCaptionLbl)
            {
            }
            column(SaldoCaption; SaldoCaptionLbl)
            {
            }
            column(VencidosCaption; VencidosCaptionLbl)
            {
            }
            column(Saldo_vencidoCaption; Saldo_vencidoCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(VencidoCaption; VencidoCaptionLbl)
            {
            }
            column(No_VencidasCaption; No_VencidasCaptionLbl)
            {
            }
            column(FacturasCaption; FacturasCaptionLbl)
            {
            }
            column(DescripcionCaption; DescripcionCaptionLbl)
            {
            }
            column(Saldos_al__Caption; Saldos_al__CaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(SubtotalCaption; SubtotalCaptionLbl)
            {
            }
            column(TotalCaption_Control1100244075; TotalCaption_Control1100244075Lbl)
            {
            }
            dataitem(MovCustNoVencido; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code") WHERE(Amount = FILTER(> 0));
                column(wImporteNoVencido; wImporteNoVencido)
                {
                }
                column(MovCustNoVencido__Document_No__; "Document No.")
                {
                }
                column(MovCustNoVencido__Posting_Date_; "Posting Date")
                {
                }
                column(MovCustNoVencido_Amount; Amount)
                {
                }
                column(MovCustNoVencido_Entry_No_; "Entry No.")
                {
                }
                column(MovCustNoVencido_Customer_No_; "Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovClie.Reset;
                    rMovClie.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                    rMovClie.SetRange("Document No.", MovCustNoVencido."Document No.");
                    if rMovClie.Find('-') then
                        if rMovClie.Open = false then
                            CurrReport.Skip;

                    BuscarCobros(MovCustNoVencido);
                    if "Posting Date" > wFechaInicio then
                        CurrReport.Skip
                    else
                        if ("Amount (LCY)" + wCobrosAplicados) = 0 then
                            CurrReport.Skip
                        else begin
                            wImporteNoVencido := "Amount (LCY)" + wCobrosAplicados;
                            wTotalImporteNoVencido += "Amount (LCY)" + wCobrosAplicados;
                            wGranTotalImporteNoVencido += "Amount (LCY)" + wCobrosAplicados;
                            wTotalNoVencido += "Amount (LCY)" + wCobrosAplicados;
                            //wSaldo                     += "Amount (LCY)" + wCobrosAplicados; //-#139
                            wTotalSaldo += "Amount (LCY)" + wCobrosAplicados;
                            wGranTotalSaldo += "Amount (LCY)" + wCobrosAplicados;
                        end;
                end;

                trigger OnPreDataItem()
                begin
                    MovCustNoVencido.SetFilter(MovCustNoVencido."Initial Entry Due Date", '>%1|=%1', wFechaInicio);
                    wCobrosAplicados := 0;
                end;
            }
            dataitem(MovCust30; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code") ORDER(Ascending) WHERE(Amount = FILTER(> 0));
                column(wImporte30; wImporte30)
                {
                }
                column(MovCust30__Document_No__; "Document No.")
                {
                }
                column(wDias30; wDias30)
                {
                }
                column(MovCust30__Posting_Date_; "Posting Date")
                {
                }
                column(MovCust30_Amount; Amount)
                {
                }
                column(MovCust30_Entry_No_; "Entry No.")
                {
                }
                column(MovCust30_Customer_No_; "Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovClie.Reset;
                    rMovClie.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                    rMovClie.SetRange("Document No.", MovCustNoVencido."Document No.");
                    if rMovClie.Find('-') then
                        if rMovClie.Open = false then
                            CurrReport.Skip;

                    BuscarCobros(MovCust30);
                    if ("Amount (LCY)" + wCobrosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporte30 := "Amount (LCY)" + wCobrosAplicados;
                        wTotalImporte30 += "Amount (LCY)" + wCobrosAplicados;
                        wGranTotalImporte30 += "Amount (LCY)" + wCobrosAplicados;
                        wTotalVencido += "Amount (LCY)" + wCobrosAplicados;
                        wGranTotalSaldo += "Amount (LCY)" + wCobrosAplicados;
                        wGranTotalVencido += "Amount (LCY)" + wCobrosAplicados;
                        //wSaldo               += "Amount (LCY)" + wCobrosAplicados; //-#139
                        wTotalSaldo += "Amount (LCY)" + wCobrosAplicados;

                        wDias30 := wFechaInicio - MovCust30."Initial Entry Due Date";
                        if wDias30 < 0 then wDias30 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovCust30.SetRange("Initial Entry Due Date", FechaFinPeriodo[1], FechaInicPeriodo[1]);
                    wCobrosAplicados := 0;
                end;
            }
            dataitem(MovCust60; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code") ORDER(Ascending) WHERE(Amount = FILTER(> 0));
                column(wDias60; wDias60)
                {
                }
                column(wImporte60; wImporte60)
                {
                }
                column(MovCust60__Document_No__; "Document No.")
                {
                }
                column(MovCust60__Posting_Date_; "Posting Date")
                {
                }
                column(MovCust60_Amount; Amount)
                {
                }
                column(MovCust60_Entry_No_; "Entry No.")
                {
                }
                column(MovCust60_Customer_No_; "Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovClie.Reset;
                    rMovClie.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                    rMovClie.SetRange("Document No.", MovCustNoVencido."Document No.");
                    if rMovClie.Find('-') then
                        if rMovClie.Open = false then
                            CurrReport.Skip;

                    BuscarCobros(MovCust60);
                    if ("Amount (LCY)" + wCobrosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporte60 := "Amount (LCY)" + wCobrosAplicados;
                        wTotalImporte60 += "Amount (LCY)" + wCobrosAplicados;
                        wGranTotalImporte60 += "Amount (LCY)" + wCobrosAplicados;
                        wTotalVencido += "Amount (LCY)" + wCobrosAplicados;
                        wGranTotalVencido += "Amount (LCY)" + wCobrosAplicados;
                        //wSaldo               += "Amount (LCY)" + wCobrosAplicados; //-#139
                        wTotalSaldo += "Amount (LCY)" + wCobrosAplicados;
                        wGranTotalSaldo += "Amount (LCY)" + wCobrosAplicados;

                        wDias60 := wFechaInicio - MovCust60."Initial Entry Due Date";
                        if wDias60 < 0 then wDias60 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovCust60.SetRange("Initial Entry Due Date", FechaFinPeriodo[2], FechaInicPeriodo[2]);
                    wCobrosAplicados := 0;
                end;
            }
            dataitem(MovCust90; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code") ORDER(Ascending) WHERE(Amount = FILTER(> 0));
                column(wDias90; wDias90)
                {
                }
                column(wImporte90; wImporte90)
                {
                }
                column(MovCust90__Document_No__; "Document No.")
                {
                }
                column(MovCust90__Posting_Date_; "Posting Date")
                {
                }
                column(MovCust90_Amount; Amount)
                {
                }
                column(MovCust90_Entry_No_; "Entry No.")
                {
                }
                column(MovCust90_Customer_No_; "Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovClie.Reset;
                    rMovClie.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                    rMovClie.SetRange("Document No.", MovCustNoVencido."Document No.");
                    if rMovClie.Find('-') then
                        if rMovClie.Open = false then
                            CurrReport.Skip;

                    BuscarCobros(MovCust90);
                    if ("Amount (LCY)" + wCobrosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporte90 := "Amount (LCY)" + wCobrosAplicados;
                        wTotalImporte90 += "Amount (LCY)" + wCobrosAplicados;
                        wGranTotalImporte90 += "Amount (LCY)" + wCobrosAplicados;
                        wTotalVencido += "Amount (LCY)" + wCobrosAplicados;
                        wGranTotalVencido += "Amount (LCY)" + wCobrosAplicados;
                        //wSaldo               += "Amount (LCY)" + wCobrosAplicados; //-#139
                        wTotalSaldo += "Amount (LCY)" + wCobrosAplicados;
                        wGranTotalSaldo += "Amount (LCY)" + wCobrosAplicados;

                        wDias90 := wFechaInicio - MovCust90."Initial Entry Due Date";
                        if wDias90 < 0 then wDias90 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovCust90.SetRange("Initial Entry Due Date", FechaFinPeriodo[3], FechaInicPeriodo[3]);
                    wCobrosAplicados := 0;
                end;
            }
            dataitem(MovCust120; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code") ORDER(Ascending) WHERE(Amount = FILTER(> 0));
                column(wDias120; wDias120)
                {
                }
                column(wImporte120; wImporte120)
                {
                }
                column(MovCust120__Document_No__; "Document No.")
                {
                }
                column(MovCust120__Posting_Date_; "Posting Date")
                {
                }
                column(MovCust120_Amount; Amount)
                {
                }
                column(MovCust120_Entry_No_; "Entry No.")
                {
                }
                column(MovCust120_Customer_No_; "Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovClie.Reset;
                    rMovClie.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                    rMovClie.SetRange("Document No.", MovCustNoVencido."Document No.");
                    if rMovClie.Find('-') then
                        if rMovClie.Open = false then
                            CurrReport.Skip;

                    BuscarCobros(MovCust120);
                    if ("Amount (LCY)" + wCobrosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporte120 := ("Amount (LCY)" + wCobrosAplicados);
                        wTotalImporte120 += ("Amount (LCY)" + wCobrosAplicados);
                        wGranTotalImporte120 += ("Amount (LCY)" + wCobrosAplicados);
                        wTotalVencido += ("Amount (LCY)" + wCobrosAplicados);
                        wGranTotalVencido += ("Amount (LCY)" + wCobrosAplicados);
                        //wSaldo                   += ("Amount (LCY)" + wCobrosAplicados); //-#139
                        wTotalSaldo += ("Amount (LCY)" + wCobrosAplicados);
                        wGranTotalSaldo += ("Amount (LCY)" + wCobrosAplicados);

                        wDias120 := wFechaInicio - MovCust120."Initial Entry Due Date";
                        if wDias120 < 0 then wDias120 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovCust120.SetRange("Initial Entry Due Date", FechaFinPeriodo[4], FechaInicPeriodo[4]);
                    wCobrosAplicados := 0;
                end;
            }
            dataitem(MovCust150; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code") ORDER(Ascending) WHERE(Amount = FILTER(> 0));
                column(wDias150; wDias150)
                {
                }
                column(wImporte150; wImporte150)
                {
                }
                column(MovCust150__Document_No__; "Document No.")
                {
                }
                column(MovCust150__Posting_Date_; "Posting Date")
                {
                }
                column(MovCust150_Amount; Amount)
                {
                }
                column(MovCust150_Entry_No_; "Entry No.")
                {
                }
                column(MovCust150_Customer_No_; "Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovClie.Reset;
                    rMovClie.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                    rMovClie.SetRange("Document No.", MovCustNoVencido."Document No.");
                    if rMovClie.Find('-') then
                        if rMovClie.Open = false then
                            CurrReport.Skip;

                    BuscarCobros(MovCust150);
                    if ("Amount (LCY)" + wCobrosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporte150 := ("Amount (LCY)" + wCobrosAplicados);
                        wTotalImporte150 += ("Amount (LCY)" + wCobrosAplicados);
                        wGranTotalImporte150 += ("Amount (LCY)" + wCobrosAplicados);
                        wTotalVencido += ("Amount (LCY)" + wCobrosAplicados);
                        wGranTotalVencido += ("Amount (LCY)" + wCobrosAplicados);
                        //wSaldo                   += ("Amount (LCY)" + wCobrosAplicados); //-#139
                        wTotalSaldo += ("Amount (LCY)" + wCobrosAplicados);
                        wGranTotalSaldo += ("Amount (LCY)" + wCobrosAplicados);

                        wDias150 := wFechaInicio - MovCust150."Initial Entry Due Date";
                        if wDias150 < 0 then wDias150 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovCust150.SetRange("Initial Entry Due Date", FechaFinPeriodo[5], FechaInicPeriodo[5]);
                    wCobrosAplicados := 0;
                end;
            }
            dataitem(MovCustMasDe180; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code") ORDER(Ascending) WHERE(Amount = FILTER(> 0));
                column(wImporte180; wImporte180)
                {
                }
                column(wDias180; wDias180)
                {
                }
                column(MovCustMasDe180__Document_No__; "Document No.")
                {
                }
                column(MovCustMasDe180__Posting_Date_; "Posting Date")
                {
                }
                column(MovCustMasDe180_Amount; Amount)
                {
                }
                column(MovCustMasDe180_Entry_No_; "Entry No.")
                {
                }
                column(MovCustMasDe180_Customer_No_; "Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovClie.Reset;
                    rMovClie.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                    rMovClie.SetRange("Document No.", MovCustNoVencido."Document No.");
                    if rMovClie.Find('-') then
                        if rMovClie.Open = false then
                            CurrReport.Skip;

                    BuscarCobros(MovCustMasDe180);
                    if ("Amount (LCY)" + wCobrosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporte180 := ("Amount (LCY)" + wCobrosAplicados);
                        wTotalImporte180 += ("Amount (LCY)" + wCobrosAplicados);
                        wGranTotalImporte180 += ("Amount (LCY)" + wCobrosAplicados);
                        wTotalVencido += ("Amount (LCY)" + wCobrosAplicados);
                        wGranTotalVencido += ("Amount (LCY)" + wCobrosAplicados);
                        //wSaldo                   += ("Amount (LCY)" + wCobrosAplicados); //-#139
                        wTotalSaldo += ("Amount (LCY)" + wCobrosAplicados);
                        wGranTotalSaldo += ("Amount (LCY)" + wCobrosAplicados);

                        wDiasMasDe180 := wFechaInicio - MovCustMasDe180."Initial Entry Due Date";
                        if wDias180 < 0 then wDias180 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovCustMasDe180.SetRange("Initial Entry Due Date", FechaFinPeriodo[6], FechaInicPeriodo[6]);
                    wCobrosAplicados := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Balance (LCY)");
                if "Balance (LCY)" = 0 then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
/*                 CurrReport.CreateTotals(wTotalImporteNoVencido, wTotalImporte30, wTotalImporte60, wTotalImporte90, wTotalImporte120,
                                        wTotalImporte150, wTotalImporte180, wGranTotalImporteNoVencido, wGranTotalSaldo, wGranTotalVencido);
                CurrReport.CreateTotals(wTotalVencido, wTotalSaldo); */

                wCobrosAplicados := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(wDetallado; wDetallado)
                {
                ApplicationArea = All;
                    Caption = 'Detallado';
                }
                field(wFechaInicio; wFechaInicio)
                {
                ApplicationArea = All;
                    Caption = 'Fecha';
                }
                field(wLongitudPeriodo; wLongitudPeriodo)
                {
                ApplicationArea = All;
                    Caption = 'Longitud Periodo';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            wFechaInicio := WorkDate;
            wLongitudPeriodo := '30D';
            wDetallado := true;
            FechaInicPeriodo[1] := wFechaInicio;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        FiltroCust := Customer.GetFilters;

        FechaInicPeriodo[1] := wFechaInicio - 1;
        for I := 2 to 6 do begin
            FechaInicPeriodo[I] := (CalcDate('-' + wLongitudPeriodo, FechaInicPeriodo[I - 1]));
        end;

        FechaFinPeriodo[1] := FechaInicPeriodo[2] + 1;
        FechaFinPeriodo[2] := FechaInicPeriodo[3] + 1;
        FechaFinPeriodo[3] := FechaInicPeriodo[4] + 1;
        FechaFinPeriodo[4] := FechaInicPeriodo[5] + 1;
        FechaFinPeriodo[5] := FechaInicPeriodo[6] + 1;
        FechaFinPeriodo[6] := CalcDate('-9999D', FechaInicPeriodo[6] + 1);

        wFecha1 := CalcDate('-' + wLongitudPeriodo, FechaInicPeriodo[1]);
        wRango := FechaInicPeriodo[1] - wFecha1;

        wLabelRango[1] := '1 - ' + Format(wRango);
        wLabelRango[2] := Format(wRango + 1) + ' - ' + Format(wRango * 2);
        wLabelRango[3] := Format(wRango * 2 + 1) + ' - ' + Format(wRango * 3);
        wLabelRango[4] := Format(wRango * 3 + 1) + ' - ' + Format(wRango * 4);
        wLabelRango[5] := Format(wRango * 4 + 1) + ' - ' + Format(wRango * 5);
        wLabelRango[6] := Format(wRango * 5 + 1) + ' - ' + Format(wRango * 6);
    end;

    var
        Text001: Label 'As of %1';
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        I: Integer;
        wCobrosAplicados: Decimal;
        rMovCustTemp: Record "Detailed Cust. Ledg. Entry";
        FechaFinPeriodo: array[7] of Date;
        FechaInicPeriodo: array[7] of Date;
        wTotalImporteNoVencido: Decimal;
        wTotalImporte30: Decimal;
        wTotalImporte60: Decimal;
        wTotalImporte90: Decimal;
        wTotalImporteMasDe90: Decimal;
        wTotalVencido: Decimal;
        wTotalSaldo: Decimal;
        wFechaInicio: Date;
        wImporteNoVencido: Decimal;
        wGranTotalImporteNoVencido: Decimal;
        wTotalNoVencido: Decimal;
        wGranTotalSaldo: Decimal;
        wImporte30: Decimal;
        wGranTotalImporte30: Decimal;
        wGranTotalVencido: Decimal;
        wDias30: Integer;
        wImporte60: Decimal;
        wGranTotalImporte60: Decimal;
        wDias60: Integer;
        wDias90: Integer;
        wImporte90: Decimal;
        wGranTotalImporte90: Decimal;
        wImporte120: Decimal;
        wTotalImporte120: Decimal;
        wGranTotalImporte120: Decimal;
        wDias120: Integer;
        FiltroCust: Text[60];
        wLongitudPeriodo: Code[10];
        wFecha1: Date;
        wRango: Integer;
        wLabelRango: array[6] of Text[30];
        wDetallado: Boolean;
        wImporte150: Decimal;
        wTotalImporte150: Decimal;
        wGranTotalImporte150: Decimal;
        wDias150: Integer;
        wImporte180: Decimal;
        wTotalImporte180: Decimal;
        wGranTotalImporte180: Decimal;
        wDiasMasDe180: Integer;
        wDias180: Integer;
        rMovClie: Record "Cust. Ledger Entry";
        Customer___Summary_Aging_Simp_CaptionLbl: Label 'Customer - Summary Aging Simp.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        "DíasCaptionLbl": Label 'Días';
        SaldoCaptionLbl: Label 'Saldo';
        VencidosCaptionLbl: Label 'Vencidos';
        Saldo_vencidoCaptionLbl: Label 'Saldo vencido';
        TotalCaptionLbl: Label 'Total';
        VencidoCaptionLbl: Label 'Vencido';
        No_VencidasCaptionLbl: Label 'No Vencidas';
        FacturasCaptionLbl: Label 'Facturas';
        DescripcionCaptionLbl: Label 'Descripcion';
        Saldos_al__CaptionLbl: Label 'Saldos al :';
        No_CaptionLbl: Label 'No.';
        SubtotalCaptionLbl: Label 'Subtotal';
        TotalCaption_Control1100244075Lbl: Label ' Total';


    procedure BuscarCobros(rDetailedMovCust: Record "Detailed Cust. Ledg. Entry")
    begin
        //Buscar cobros si la liquidacion fue por Numero de Documento

        wCobrosAplicados := 0;

        //Busco los cobros aplicados a la factura
        rMovCustTemp.Reset;
        //rMovCustTemp.SETCURRENTKEY("Cust. Ledger Entry No.","Posting Date","Entry Type"); //-#139
        rMovCustTemp.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date"); //+#139
        rMovCustTemp.SetRange("Cust. Ledger Entry No.", rDetailedMovCust."Cust. Ledger Entry No.");
        rMovCustTemp.SetRange("Posting Date", FechaFinPeriodo[1], FechaInicPeriodo[1]);
        rMovCustTemp.SetRange("Entry Type", rMovCustTemp."Entry Type"::Application);
        if rMovCustTemp.Find('-') then
            repeat
                wCobrosAplicados += rMovCustTemp."Amount (LCY)";
            until rMovCustTemp.Next = 0;
    end;
}

