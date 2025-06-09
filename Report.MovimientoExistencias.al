report 56050 "Movimiento Existencias"
{
    DefaultLayout = RDLC;
    RDLCLayout = './MovimientoExistencias.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Date Filter";
            column(USERID; UserId)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Item__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Q_DateLastPurch; Q_DateLastPurch)
            {
            }
            column(Q_QtyBegining; Q_QtyBegining)
            {
            }
            column(Q_PurchAndOutputQty; Q_PurchAndOutputQty)
            {
            }
            column(Q_Promo; Q_Promo)
            {
            }
            column(Q_Grupo; Q_Grupo)
            {
            }
            column(Q_Consumo; Q_Consumo)
            {
            }
            column(Q_Institucional; Q_Institucional)
            {
            }
            column(Q_Regular; Q_Regular)
            {
            }
            column(C_Regular; C_Regular)
            {
            }
            column(C_Institucional; C_Institucional)
            {
            }
            column(C_Promo; C_Promo)
            {
            }
            column(C_PurchAndOutputQty; C_PurchAndOutputQty)
            {
            }
            column(C_QtyBegining; C_QtyBegining)
            {
            }
            column(Item_Item__Unit_Cost_; Item."Unit Cost")
            {
            }
            column(Q_QtyEnd; Q_QtyEnd)
            {
            }
            column(Q_PosNegAdj; Q_PosNegAdj)
            {
            }
            column(C_PosNegAdj; C_PosNegAdj)
            {
            }
            column(C_QtyEnd; C_QtyEnd)
            {
            }
            column(C_Consumo; C_Consumo)
            {
            }
            column(C_Grupo; C_Grupo)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TitleCaption; TitleCaptionLbl)
            {
            }
            column(ISBNCaption; ISBNCaptionLbl)
            {
            }
            column(Item__No__Caption; FieldCaption("No."))
            {
            }
            column("TítuloCaption"; TítuloCaptionLbl)
            {
            }
            column(Fecha_ultima_compraCaption; Fecha_ultima_compraCaptionLbl)
            {
            }
            column(Exit__InicialesCaption; Exit__InicialesCaptionLbl)
            {
            }
            column("Salidas_por_promociónCaption"; Salidas_por_promociónCaptionLbl)
            {
            }
            column("Entradas__producción_o_comprasCaption"; Entradas__producción_o_comprasCaptionLbl)
            {
            }
            column(Ajustes_positivos_y_negativosCaption; Ajustes_positivos_y_negativosCaptionLbl)
            {
            }
            column(Consumo__salida__esto_es_el_traslado_a_PackCaption; Consumo__salida__esto_es_el_traslado_a_PackCaptionLbl)
            {
            }
            column(Salidas_por_ventas_InstitucionalCaption; Salidas_por_ventas_InstitucionalCaptionLbl)
            {
            }
            column(Salidas_por_ventas_RegularCaption; Salidas_por_ventas_RegularCaptionLbl)
            {
            }
            column(Salidas_por_ventas_RegularCaption_Control1000000040; Salidas_por_ventas_RegularCaption_Control1000000040Lbl)
            {
            }
            column("Salidas_por_promociónCaption_Control1000000041"; Salidas_por_promociónCaption_Control1000000041Lbl)
            {
            }
            column("Entradas__producción_o_comprasCaption_Control1000000042"; Entradas__producción_o_comprasCaption_Control1000000042Lbl)
            {
            }
            column(Exit__InicialesCaption_Control1000000043; Exit__InicialesCaption_Control1000000043Lbl)
            {
            }
            column(Coste_Unitario_MLCaption; Coste_Unitario_MLCaptionLbl)
            {
            }
            column(Existencias_finalesCaption; Existencias_finalesCaptionLbl)
            {
            }
            column(Existencias_finalesCaption_Control1000000046; Existencias_finalesCaption_Control1000000046Lbl)
            {
            }
            column(Ajustes_positivos_y_negativosCaption_Control1000000047; Ajustes_positivos_y_negativosCaption_Control1000000047Lbl)
            {
            }
            column(Consumo__salida__esto_es_el_traslado_a_PackCaption_Control1000000048; Consumo__salida__esto_es_el_traslado_a_PackCaption_Control1000000048Lbl)
            {
            }
            column(Salidas_por_ventas_GrupoCaption; Salidas_por_ventas_GrupoCaptionLbl)
            {
            }
            column(Salidas_por_ventas_InstitucionalCaption_Control1000000051; Salidas_por_ventas_InstitucionalCaption_Control1000000051Lbl)
            {
            }
            column(Salidas_por_ventas_GrupoCaption_Control1000000052; Salidas_por_ventas_GrupoCaption_Control1000000052Lbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                Item2: Record Item;
            begin
                Q_DateLastPurch := 0D;
                Q_QtyBegining := 0;
                Q_PurchAndOutputQty := 0;
                Q_Promo := 0;
                Q_Regular := 0;
                Q_Institucional := 0;
                Q_Grupo := 0;
                Q_Consumo := 0;
                Q_PosNegAdj := 0;
                Q_QtyEnd := 0;

                C_QtyBegining := 0;
                C_PurchAndOutputQty := 0;
                C_Promo := 0;
                C_Regular := 0;
                C_Institucional := 0;
                C_Grupo := 0;
                C_Consumo := 0;
                C_PosNegAdj := 0;
                C_QtyEnd := 0;

                ILE.SetCurrentKey("Item No.", "Posting Date");
                ILE.SetRange("Item No.", "No.");
                if not ILE.FindSet then
                    CurrReport.Skip;
                ILE.SetRange("Entry Type", ILE."Entry Type"::Purchase);
                if ILE.FindLast then
                    Q_DateLastPurch := ILE."Posting Date";

                ILE.Reset;
                ILE.SetCurrentKey("Item No.", "Posting Date");
                ILE.SetRange("Item No.", "No.");
                ILE.SetFilter("Posting Date", '..%1', GetRangeMin("Date Filter"));
                if ILE.FindSet then
                    repeat
                        ILE.CalcFields("Cost Amount (Actual)");

                        Q_QtyBegining += ILE.Quantity;
                        C_QtyBegining += ILE."Cost Amount (Actual)";
                    until ILE.Next = 0;

                ILE.SetFilter("Posting Date", '..%1', GetRangeMax("Date Filter"));
                if ILE.FindSet then
                    repeat
                        ILE.CalcFields("Cost Amount (Actual)");

                        Q_QtyEnd += ILE.Quantity;
                        C_QtyEnd += ILE."Cost Amount (Actual)";
                    until ILE.Next = 0;


                ILE.Reset;
                ILE.SetCurrentKey("Item No.", "Posting Date");
                ILE.SetRange("Item No.", "No.");
                if GetFilter("Date Filter") <> '' then
                    CopyFilter("Date Filter", ILE."Posting Date");
                if ILE.FindSet then
                    repeat
                        ILE.CalcFields("Cost Amount (Actual)");

                        if (ILE."Entry Type" = ILE."Entry Type"::Purchase) or (ILE."Entry Type" = ILE."Entry Type"::Output) then begin
                            Q_PurchAndOutputQty += ILE.Quantity;
                            C_PurchAndOutputQty += ILE."Cost Amount (Actual)";
                        end;

                        if (ILE."Entry Type" = ILE."Entry Type"::Sale) then begin
                            VE.Reset;
                            VE.SetRange("Item Ledger Entry No.", ILE."Entry No.");
                            VE.SetRange("Gen. Bus. Posting Group", 'PROMO');
                            VE.SetRange("Document Type", VE."Document Type"::"Sales Invoice");
                            if VE.FindSet then
                                repeat
                                    Q_Promo += VE."Invoiced Quantity";
                                    C_Promo += VE."Cost Amount (Actual)";
                                until VE.Next = 0;

                            if LED.Get(ILE."Dimension Set ID", 'TIPO VENTA') then begin
                                if (LED."Dimension Value Code" = 'LIB_QUIOSCOS') or
                                   (LED."Dimension Value Code" = 'LIB_REG_CONSIGN') or
                                   (LED."Dimension Value Code" = 'LIB_REG_FIRME') then begin
                                    Q_Regular += ILE.Quantity;
                                    C_Regular += ILE."Cost Amount (Actual)";
                                end;

                                if (LED."Dimension Value Code" = 'LIB_INSTITUCIONAL') then begin
                                    Q_Institucional += ILE.Quantity;
                                    C_Institucional += ILE."Cost Amount (Actual)";
                                end;

                                if (LED."Dimension Value Code" = 'LIB_GRUPO') then begin
                                    Q_Grupo += ILE.Quantity;
                                    C_Grupo += ILE."Cost Amount (Actual)";
                                end;
                            end;
                        end;
                        if ILE."Entry Type" = ILE."Entry Type"::Consumption then begin
                            Q_Consumo += ILE.Quantity;
                            C_Consumo += ILE."Cost Amount (Actual)";
                        end;
                        if (ILE."Entry Type" = ILE."Entry Type"::"Positive Adjmt.") or (ILE."Entry Type" = ILE."Entry Type"::"Negative Adjmt.") then begin
                            Q_PosNegAdj += ILE.Quantity;
                            C_PosNegAdj += ILE."Cost Amount (Actual)";
                        end;

                    until ILE.Next = 0;
                RowNo += 1;
                EnterCell(RowNo, 1, "Global Dimension 1 Code", false, false, '');
                EnterCell(RowNo, 2, "No.", false, false, '');
                EnterCell(RowNo, 3, Description, false, false, '');
                EnterCell(RowNo, 4, Format(Q_DateLastPurch), false, false, '');
                EnterCell(RowNo, 5, Format(Q_QtyBegining), false, false, '');
                EnterCell(RowNo, 6, Format(Q_PurchAndOutputQty), false, false, '');
                EnterCell(RowNo, 7, Format(Q_Promo), false, false, '');
                EnterCell(RowNo, 8, Format(Q_Regular), false, false, '');
                EnterCell(RowNo, 9, Format(Q_Institucional), false, false, '');
                EnterCell(RowNo, 10, Format(Q_Grupo), false, false, '');
                EnterCell(RowNo, 11, Format(Q_Consumo), false, false, '');
                EnterCell(RowNo, 12, Format(Q_PosNegAdj), false, false, '');
                EnterCell(RowNo, 13, Format(Q_QtyEnd), false, false, '');
                EnterCell(RowNo, 14, Format("Unit Cost"), false, false, '');
                EnterCell(RowNo, 15, Format(C_QtyBegining), false, false, '');
                EnterCell(RowNo, 16, Format(C_PurchAndOutputQty), false, false, '');
                EnterCell(RowNo, 17, Format(C_Promo), false, false, '');
                EnterCell(RowNo, 18, Format(C_Regular), false, false, '');
                EnterCell(RowNo, 19, Format(C_Institucional), false, false, '');
                EnterCell(RowNo, 20, Format(C_Grupo), false, false, '');
                EnterCell(RowNo, 21, Format(C_Consumo), false, false, '');
                EnterCell(RowNo, 22, Format(C_PosNegAdj), false, false, '');
                EnterCell(RowNo, 23, Format(C_QtyEnd), false, false, '');
            end;

            trigger OnPostDataItem()
            begin
                if RowNo > 1 then begin
                    /*                     ExcelBuf.CreateBookAndOpenExcel('',
                                            ExcelBuf.GetExcelReference(10),
                                            'Texto',
                                            CompanyName,
                                            UserId); */
                end;
            end;

            trigger OnPreDataItem()
            begin
                RowNo := 1;
                EnterCell(RowNo, 1, 'ISBN', true, true, '');
                EnterCell(RowNo, 2, '', true, true, '');
                EnterCell(RowNo, 3, 'Título', true, true, '');
                EnterCell(RowNo, 4, 'Fecha ultima compra', true, true, '');
                EnterCell(RowNo, 5, 'Exit. Iniciales', true, true, '');
                EnterCell(RowNo, 6, 'Entradas: producción o compras', true, true, '');
                EnterCell(RowNo, 7, 'Salidas por promoción', true, true, '');
                EnterCell(RowNo, 8, 'Salidas por ventas Regular', true, true, '');
                EnterCell(RowNo, 9, 'Salidas por ventas Institucional', true, true, '');
                EnterCell(RowNo, 10, 'Salidas por ventas Grupo', true, true, '');
                EnterCell(RowNo, 11, 'Consumo /salida (esto es el traslado a Pack', true, true, '');
                EnterCell(RowNo, 12, 'Ajustes positivos y negativos', true, true, '');
                EnterCell(RowNo, 13, 'Existencias finales', true, true, '');
                EnterCell(RowNo, 14, 'Coste Unitario ML', true, true, '');
                EnterCell(RowNo, 15, 'Exit. Iniciales', true, true, '');
                EnterCell(RowNo, 16, 'Entradas: producción o compras', true, true, '');
                EnterCell(RowNo, 17, 'Salidas por promoción', true, true, '');
                EnterCell(RowNo, 18, 'Salidas por ventas Regular', true, true, '');
                EnterCell(RowNo, 19, 'Salidas por ventas Institucional', true, true, '');
                EnterCell(RowNo, 20, 'Salidas por ventas Grupo', true, true, '');
                EnterCell(RowNo, 21, 'Consumo /salida (esto es el traslado a Pack', true, true, '');
                EnterCell(RowNo, 22, 'Ajustes positivos y negativos', true, true, '');
                EnterCell(RowNo, 23, 'Existencias finales', true, true, '');
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
        Q_DateLastPurch: Date;
        Q_QtyBegining: Decimal;
        Q_PurchAndOutputQty: Decimal;
        Q_Promo: Decimal;
        Q_Regular: Decimal;
        Q_Institucional: Decimal;
        Q_Grupo: Decimal;
        Q_Consumo: Decimal;
        Q_PosNegAdj: Decimal;
        Q_QtyEnd: Decimal;
        C_QtyBegining: Decimal;
        C_PurchAndOutputQty: Decimal;
        C_Promo: Decimal;
        C_Regular: Decimal;
        C_Institucional: Decimal;
        C_Grupo: Decimal;
        C_Consumo: Decimal;
        C_PosNegAdj: Decimal;
        C_QtyEnd: Decimal;
        ILE: Record "Item Ledger Entry";
        VE: Record "Value Entry";
        ExcelBuf: Record "Excel Buffer" temporary;
        RowNo: Integer;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        TitleCaptionLbl: Label 'Movimiento Existencias';
        ISBNCaptionLbl: Label 'ISBN';
        "TítuloCaptionLbl": Label 'Título';
        Fecha_ultima_compraCaptionLbl: Label 'Fecha ultima compra';
        Exit__InicialesCaptionLbl: Label 'Exit. Iniciales';
        "Salidas_por_promociónCaptionLbl": Label 'Salidas por promoción';
        "Entradas__producción_o_comprasCaptionLbl": Label 'Entradas: producción o compras';
        Ajustes_positivos_y_negativosCaptionLbl: Label 'Ajustes positivos y negativos';
        Consumo__salida__esto_es_el_traslado_a_PackCaptionLbl: Label 'Consumo /salida (esto es el traslado a Pack';
        Salidas_por_ventas_InstitucionalCaptionLbl: Label 'Salidas por ventas Institucional';
        Salidas_por_ventas_RegularCaptionLbl: Label 'Salidas por ventas Regular';
        Salidas_por_ventas_RegularCaption_Control1000000040Lbl: Label 'Salidas por ventas Regular';
        "Salidas_por_promociónCaption_Control1000000041Lbl": Label 'Salidas por promoción';
        "Entradas__producción_o_comprasCaption_Control1000000042Lbl": Label 'Entradas: producción o compras';
        Exit__InicialesCaption_Control1000000043Lbl: Label 'Exit. Iniciales';
        Coste_Unitario_MLCaptionLbl: Label 'Coste Unitario ML';
        Existencias_finalesCaptionLbl: Label 'Existencias finales';
        Existencias_finalesCaption_Control1000000046Lbl: Label 'Existencias finales';
        Ajustes_positivos_y_negativosCaption_Control1000000047Lbl: Label 'Ajustes positivos y negativos';
        Consumo__salida__esto_es_el_traslado_a_PackCaption_Control1000000048Lbl: Label 'Consumo /salida (esto es el traslado a Pack';
        Salidas_por_ventas_GrupoCaptionLbl: Label 'Salidas por ventas Grupo';
        Salidas_por_ventas_InstitucionalCaption_Control1000000051Lbl: Label 'Salidas por ventas Institucional';
        Salidas_por_ventas_GrupoCaption_Control1000000052Lbl: Label 'Salidas por ventas Grupo';
        LED: Record "Dimension Set Entry";

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; UnderLine: Boolean; NumberFormat: Text[30])
    begin
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf.Insert;
    end;
}

