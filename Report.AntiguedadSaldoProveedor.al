report 56128 "Antiguedad Saldo Proveedor"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AntiguedadSaldoProveedor.rdlc';
    ProcessingOnly = false;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.";
            column(FiltroProv; FiltroProv)
            {
            }
            column(USERID; UserId)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4____FORMAT_TIME_; Format(Today, 0, 4) + Format(Time))
            {
            }
            column(EmptyString; '')
            {
            }
            column(FechaInicPeriodo_1_; FechaInicPeriodo[1])
            {
            }
            column(FechaInicPeriodo_2_; FechaInicPeriodo[2])
            {
            }
            column(FechaInicPeriodo_3_; FechaInicPeriodo[3])
            {
            }
            column(FechaInicPeriodo_4_; FechaInicPeriodo[4])
            {
            }
            column(wLabelRango_1_; wLabelRango[1])
            {
            }
            column(wLabelRango_2_; wLabelRango[2])
            {
            }
            column(wLabelRango_3_; wLabelRango[3])
            {
            }
            column(wLabelRango_4_; wLabelRango[4])
            {
            }
            column(FechaFinPeriodo_1_; FechaFinPeriodo[1])
            {
            }
            column(FechaFinPeriodo_2_; FechaFinPeriodo[2])
            {
            }
            column(FechaFinPeriodo_3_; FechaFinPeriodo[3])
            {
            }
            column(FechaFinPeriodo_4_; FechaFinPeriodo[4])
            {
            }
            column(FORMAT_wFechaInicio_0_4_; Format(wFechaInicio, 0, 4))
            {
            }
            column(wDetallado; wDetallado)
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(wTotalImporteMasDe90; wTotalImporteMasDe90)
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
            column(wTotalVencido; wTotalVencido)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wTotalSaldo; wTotalSaldo)
            {
            }
            column(wTotalImporteNoVencido; wTotalImporteNoVencido)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporte30; wGranTotalImporte30)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporte60; wGranTotalImporte60)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporte90; wGranTotalImporte90)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporteMasDe90; wGranTotalImporteMasDe90)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalVencido; wGranTotalVencido)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalSaldo; wGranTotalSaldo)
            {
                DecimalPlaces = 2 : 2;
            }
            column(wGranTotalImporteNoVencido; wGranTotalImporteNoVencido)
            {
                DecimalPlaces = 2 : 2;
            }
            column("PáginaCaption"; PáginaCaptionLbl)
            {
            }
            column(Proveedor___Saldo_por_AntiguedadCaption; Proveedor___Saldo_por_AntiguedadCaptionLbl)
            {
            }
            column(SaldoCaption; SaldoCaptionLbl)
            {
            }
            column(DescripcionCaption; DescripcionCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
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
            column("DíasCaption"; DíasCaptionLbl)
            {
            }
            column(VencidoCaption_Control70; VencidoCaption_Control70Lbl)
            {
            }
            column(No_VencidasCaption; No_VencidasCaptionLbl)
            {
            }
            column(FacturasCaption; FacturasCaptionLbl)
            {
            }
            column(Saldos_al__Caption; Saldos_al__CaptionLbl)
            {
            }
            column(SubtotalCaption; SubtotalCaptionLbl)
            {
            }
            column(TotalCaption_Control51; TotalCaption_Control51Lbl)
            {
            }
            dataitem(MovProvNoVencido; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Entry Type", "Currency Code");
                column(wImporteNoVencido; wImporteNoVencido)
                {
                }
                column(MovProvNoVencido__Document_No__; "Document No.")
                {
                }
                column(MovProvNoVencido_Entry_No_; "Entry No.")
                {
                }
                column(MovProvNoVencido_Vendor_No_; "Vendor No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovProv.Reset;
                    rMovProv.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                    rMovProv.SetRange("Document No.", "Document No.");
                    if rMovProv.Find('-') then
                        if rMovProv.Open = false then
                            CurrReport.Skip;



                    BuscarPagos(MovProvNoVencido);
                    if "Posting Date" > wFechaInicio then
                        CurrReport.Skip
                    else
                        if ("Amount (LCY)" + wPagosAplicados) = 0 then
                            CurrReport.Skip
                        else begin
                            wImporteNoVencido := "Amount (LCY)" + wPagosAplicados;
                            wTotalImporteNoVencido += "Amount (LCY)" + wPagosAplicados;
                            wGranTotalImporteNoVencido += "Amount (LCY)" + wPagosAplicados;
                            wTotalNoVencido += "Amount (LCY)" + wPagosAplicados;
                            wSaldo += "Amount (LCY)" + wPagosAplicados;
                            wTotalSaldo += "Amount (LCY)" + wPagosAplicados;
                            wGranTotalSaldo += "Amount (LCY)" + wPagosAplicados;
                        end;
                end;

                trigger OnPreDataItem()
                begin
                    MovProvNoVencido.SetFilter(MovProvNoVencido."Initial Entry Due Date", '>%1|=%1', wFechaInicio);
                    wPagosAplicados := 0;
                end;
            }
            dataitem(MovProv30; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Entry Type", "Currency Code") WHERE("Document Type" = FILTER(Invoice));
                column(wImporte30; wImporte30)
                {
                }
                column(MovProv30__Document_No__; "Document No.")
                {
                }
                column(wDias30; wDias30)
                {
                }
                column(MovProv30_Entry_No_; "Entry No.")
                {
                }
                column(MovProv30_Vendor_No_; "Vendor No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovProv.Reset;
                    rMovProv.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                    rMovProv.SetRange("Document No.", "Document No.");
                    if rMovProv.Find('-') then
                        if rMovProv.Open = false then
                            CurrReport.Skip;


                    BuscarPagos(MovProv30);
                    if ("Amount (LCY)" + wPagosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporte30 := "Amount (LCY)" + wPagosAplicados;
                        wTotalImporte30 += "Amount (LCY)" + wPagosAplicados;
                        wGranTotalImporte30 += "Amount (LCY)" + wPagosAplicados;
                        wTotalVencido += "Amount (LCY)" + wPagosAplicados;
                        wGranTotalSaldo += "Amount (LCY)" + wPagosAplicados;
                        wGranTotalVencido += "Amount (LCY)" + wPagosAplicados;
                        wSaldo += "Amount (LCY)" + wPagosAplicados;
                        wTotalSaldo += "Amount (LCY)" + wPagosAplicados;

                        wDias30 := wFechaInicio - MovProv30."Initial Entry Due Date";
                        if wDias30 < 0 then wDias30 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovProv30.SetRange("Initial Entry Due Date", FechaFinPeriodo[1], FechaInicPeriodo[1]);
                    wPagosAplicados := 0;
                end;
            }
            dataitem(MovProv60; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Entry Type", "Currency Code") WHERE("Document Type" = FILTER(Invoice));
                column(wImporte60; wImporte60)
                {
                }
                column(MovProv60__Document_No__; "Document No.")
                {
                }
                column(wDias60; wDias60)
                {
                }
                column(MovProv60_Entry_No_; "Entry No.")
                {
                }
                column(MovProv60_Vendor_No_; "Vendor No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovProv.Reset;
                    rMovProv.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                    rMovProv.SetRange("Document No.", "Document No.");
                    if rMovProv.Find('-') then
                        if rMovProv.Open = false then
                            CurrReport.Skip;

                    BuscarPagos(MovProv60);
                    if ("Amount (LCY)" + wPagosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporte60 := "Amount (LCY)" + wPagosAplicados;
                        wTotalImporte60 += "Amount (LCY)" + wPagosAplicados;
                        wGranTotalImporte60 += "Amount (LCY)" + wPagosAplicados;
                        wTotalVencido += "Amount (LCY)" + wPagosAplicados;
                        wGranTotalVencido += "Amount (LCY)" + wPagosAplicados;
                        wSaldo += "Amount (LCY)" + wPagosAplicados;
                        wTotalSaldo += "Amount (LCY)" + wPagosAplicados;
                        wGranTotalSaldo += "Amount (LCY)" + wPagosAplicados;

                        wDias60 := wFechaInicio - MovProv60."Initial Entry Due Date";
                        if wDias60 < 0 then wDias60 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovProv60.SetRange("Initial Entry Due Date", FechaFinPeriodo[2], FechaInicPeriodo[2]);
                    wPagosAplicados := 0;
                end;
            }
            dataitem(MovProv90; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Entry Type", "Currency Code") WHERE("Document Type" = FILTER(Invoice));
                column(wImporte90; wImporte90)
                {
                }
                column(MovProv90__Document_No__; "Document No.")
                {
                }
                column(wDias90; wDias90)
                {
                }
                column(MovProv90_Entry_No_; "Entry No.")
                {
                }
                column(MovProv90_Vendor_No_; "Vendor No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovProv.Reset;
                    rMovProv.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                    rMovProv.SetRange("Document No.", "Document No.");
                    if rMovProv.Find('-') then
                        if rMovProv.Open = false then
                            CurrReport.Skip;


                    BuscarPagos(MovProv90);
                    if ("Amount (LCY)" + wPagosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporte90 := "Amount (LCY)" + wPagosAplicados;
                        wTotalImporte90 += "Amount (LCY)" + wPagosAplicados;
                        wGranTotalImporte90 += "Amount (LCY)" + wPagosAplicados;
                        wTotalVencido += "Amount (LCY)" + wPagosAplicados;
                        wGranTotalVencido += "Amount (LCY)" + wPagosAplicados;
                        wSaldo += "Amount (LCY)" + wPagosAplicados;
                        wTotalSaldo += "Amount (LCY)" + wPagosAplicados;
                        wGranTotalSaldo += "Amount (LCY)" + wPagosAplicados;

                        wDias90 := wFechaInicio - MovProv90."Initial Entry Due Date";
                        if wDias90 < 0 then wDias90 := 0;

                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovProv90.SetRange("Initial Entry Due Date", FechaFinPeriodo[3], FechaInicPeriodo[3]);
                    wPagosAplicados := 0;
                end;
            }
            dataitem(MovProvMasDe90; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Entry Type", "Currency Code") WHERE("Document Type" = FILTER(Invoice));
                column(MovProvMasDe90__Document_No__; "Document No.")
                {
                }
                column(wImporteMasDe90; wImporteMasDe90)
                {
                }
                column(wDiasMasDe90; wDiasMasDe90)
                {
                }
                column(MovProvMasDe90_Entry_No_; "Entry No.")
                {
                }
                column(MovProvMasDe90_Vendor_No_; "Vendor No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rMovProv.Reset;
                    rMovProv.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                    rMovProv.SetRange("Document No.", "Document No.");
                    if rMovProv.Find('-') then
                        if rMovProv.Open = false then
                            CurrReport.Skip;


                    BuscarPagos(MovProvMasDe90);
                    if ("Amount (LCY)" + wPagosAplicados) = 0 then
                        CurrReport.Skip
                    else begin
                        wImporteMasDe90 := ("Amount (LCY)" + wPagosAplicados);
                        wTotalImporteMasDe90 += ("Amount (LCY)" + wPagosAplicados);
                        wGranTotalImporteMasDe90 += ("Amount (LCY)" + wPagosAplicados);
                        wTotalVencido += ("Amount (LCY)" + wPagosAplicados);
                        wGranTotalVencido += ("Amount (LCY)" + wPagosAplicados);
                        wSaldo += ("Amount (LCY)" + wPagosAplicados);
                        wTotalSaldo += ("Amount (LCY)" + wPagosAplicados);
                        wGranTotalSaldo += ("Amount (LCY)" + wPagosAplicados);

                        wDiasMasDe90 := wFechaInicio - MovProvMasDe90."Initial Entry Due Date";
                        if wDias90 < 0 then wDias90 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    MovProvMasDe90.SetRange("Initial Entry Due Date", FechaFinPeriodo[4], FechaInicPeriodo[4]);
                    //MESSAGE('desde %1 hasta %2',FechaFinPeriodo[4],FechaInicPeriodo[4]);
                    wPagosAplicados := 0;
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
/*                 CurrReport.CreateTotals(wTotalImporteNoVencido, wTotalImporte30, wTotalImporte60, wTotalImporte90, wTotalImporteMasDe90,
                                        wTotalVencido, wTotalSaldo); */
                wPagosAplicados := 0;
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
                    Caption = 'Longitud periodo';
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
        FiltroProv := Vendor.GetFilters;

        FechaInicPeriodo[1] := wFechaInicio - 1;
        for I := 2 to 6 do begin
            FechaInicPeriodo[I] := (CalcDate('-' + wLongitudPeriodo, FechaInicPeriodo[I - 1]));
        end;

        FechaFinPeriodo[1] := FechaInicPeriodo[2] + 1;
        FechaFinPeriodo[2] := FechaInicPeriodo[3] + 1;
        FechaFinPeriodo[3] := FechaInicPeriodo[4] + 1;
        FechaFinPeriodo[4] := CalcDate('-9999D', FechaInicPeriodo[4]);

        wFecha1 := CalcDate('-' + wLongitudPeriodo, FechaInicPeriodo[1]);
        wRango := FechaInicPeriodo[1] - wFecha1;

        wLabelRango[1] := '1 - ' + Format(wRango);
        wLabelRango[2] := Format(wRango + 1) + ' - ' + Format(wRango * 2);
        wLabelRango[3] := Format(wRango * 2 + 1) + ' - ' + Format(wRango * 3);
        wLabelRango[4] := 'Mas de ' + Format(wRango * 3);
    end;

    var
        rMovProvTemp: Record "Detailed Vendor Ledg. Entry";
        FechaInicPeriodo: array[7] of Date;
        FechaFinPeriodo: array[7] of Date;
        I: Integer;
        FiltroProv: Text[50];
        wLongitudPeriodo: Code[10];
        indicador: Integer;
        wMasDe90: Decimal;
        wImporte30: Decimal;
        wTotalImporte30: Decimal;
        wImporte60: Decimal;
        wTotalImporte60: Decimal;
        wImporte90: Decimal;
        wTotalImporte90: Decimal;
        wImporteMasDe90: Decimal;
        wTotalImporteMasDe90: Decimal;
        wSaldo: Decimal;
        wTotalSaldo: Decimal;
        wTotalVencido: Decimal;
        wDetallado: Boolean;
        wFechaInicio: Date;
        wGranTotalVencido: Decimal;
        wGranTotalSaldo: Decimal;
        wGranTotalImporteNoVencido: Decimal;
        wGranTotalImporte90: Decimal;
        wGranTotalImporte30: Decimal;
        wGranTotalImporte60: Decimal;
        wGranTotalImporteMasDe90: Decimal;
        wRango: Integer;
        wLabelRango: array[4] of Text[30];
        wFecha1: Date;
        wDiasVencido: Integer;
        wDias30: Integer;
        wDias60: Integer;
        wDias90: Integer;
        wDiasMasDe90: Integer;
        wDias: Integer;
        wPagosAplicados: Decimal;
        wImporteNoVencido: Decimal;
        wTotalImporteNoVencido: Decimal;
        wTotalNoVencido: Decimal;
        rMovProv: Record "Vendor Ledger Entry";
        "PáginaCaptionLbl": Label 'Página';
        Proveedor___Saldo_por_AntiguedadCaptionLbl: Label 'Proveedor - Saldo por Antiguedad';
        SaldoCaptionLbl: Label 'Saldo';
        DescripcionCaptionLbl: Label 'Descripcion';
        No_CaptionLbl: Label 'No.';
        Saldo_vencidoCaptionLbl: Label 'Saldo vencido';
        TotalCaptionLbl: Label 'Total';
        VencidoCaptionLbl: Label 'Vencido';
        "DíasCaptionLbl": Label 'Días';
        VencidoCaption_Control70Lbl: Label 'Vencido';
        No_VencidasCaptionLbl: Label 'No Vencidas';
        FacturasCaptionLbl: Label 'Facturas';
        Saldos_al__CaptionLbl: Label 'Saldos al :';
        SubtotalCaptionLbl: Label 'Subtotal';
        TotalCaption_Control51Lbl: Label ' Total';


    procedure BuscarPagos(rDetailedMovProv: Record "Detailed Vendor Ledg. Entry")
    begin
        // Buscar Pagos si la liquidacion fue por Numero de Documento

        wPagosAplicados := 0;

        //Busco los pagos aplicados a la factura
        rMovProvTemp.Reset;
        rMovProvTemp.SetCurrentKey("Vendor Ledger Entry No.", "Posting Date", "Entry Type");
        rMovProvTemp.SetRange(rMovProvTemp."Vendor Ledger Entry No.", rDetailedMovProv."Vendor Ledger Entry No.");
        rMovProvTemp.SetRange(rMovProvTemp."Posting Date", FechaFinPeriodo[1], FechaInicPeriodo[1]);
        rMovProvTemp.SetRange(rMovProvTemp."Entry Type", rMovProvTemp."Entry Type"::Application);
        if rMovProvTemp.Find('-') then
            repeat
                wPagosAplicados += rMovProvTemp."Amount (LCY)";
            until rMovProvTemp.Next = 0;
    end;
}

