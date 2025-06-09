report 55006 "Nota Credito Ecuador"
{
    // MOI - 22/04/2015(#16268): Se crea el campo direccion y se añade al dataset.
    DefaultLayout = RDLC;
    RDLCLayout = './NotaCreditoEcuador.rdlc';

    Caption = 'Sales Credit Memo';
    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Sales Cr.Memo Header" = rm,
                  TableData "Sales Shipment Buffer" = rm,
                  TableData "NCF Anulados" = rim;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Credit Memo';
            column(Sales_Cr_Memo_Header_No_; "No.")
            {
            }
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                    //DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Posted Credit Memo"), "Print On Credit Memo" = CONST(true));

                    trigger OnAfterGetRecord()
                    begin
                        TempSalesCrMemoLine.Init;
                        TempSalesCrMemoLine."Document No." := "Sales Cr.Memo Header"."No.";
                        TempSalesCrMemoLine."Line No." := HighestLineNo + 10;
                        HighestLineNo := TempSalesCrMemoLine."Line No.";

                        if StrLen(Comment) <= MaxStrLen(TempSalesCrMemoLine.Description) then begin
                            TempSalesCrMemoLine.Description := Comment;
                            TempSalesCrMemoLine."Description 2" := '';
                        end else begin
                            SpacePointer := MaxStrLen(TempSalesCrMemoLine.Description) + 1;
                            while (SpacePointer > 1) and (Comment[SpacePointer] <> ' ') do
                                SpacePointer := SpacePointer - 1;
                            if SpacePointer = 1 then
                                SpacePointer := MaxStrLen(TempSalesCrMemoLine.Description) + 1;
                            TempSalesCrMemoLine.Description := CopyStr(Comment, 1, SpacePointer - 1);
                            TempSalesCrMemoLine."Description 2" :=
                              CopyStr(CopyStr(Comment, SpacePointer + 1), 1, MaxStrLen(TempSalesCrMemoLine."Description 2"));
                        end;
                        TempSalesCrMemoLine.Insert;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempSalesCrMemoLine := "Sales Cr.Memo Line";
                    TempSalesCrMemoLine.Insert;
                    HighestLineNo := "Line No.";
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesCrMemoLine.Reset;
                    TempSalesCrMemoLine.DeleteAll;
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                //DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Posted Credit Memo"), "Print On Credit Memo" = CONST(true), "Document Line No." = CONST(0));

                trigger OnAfterGetRecord()
                begin
                    TempSalesCrMemoLine.Init;
                    TempSalesCrMemoLine."Document No." := "Sales Cr.Memo Header"."No.";
                    TempSalesCrMemoLine."Line No." := HighestLineNo + 1000;
                    HighestLineNo := TempSalesCrMemoLine."Line No.";

                    if StrLen(Comment) <= MaxStrLen(TempSalesCrMemoLine.Description) then begin
                        TempSalesCrMemoLine.Description := Comment;
                        TempSalesCrMemoLine."Description 2" := '';
                    end else begin
                        SpacePointer := MaxStrLen(TempSalesCrMemoLine.Description) + 1;
                        while (SpacePointer > 1) and (Comment[SpacePointer] <> ' ') do
                            SpacePointer := SpacePointer - 1;
                        if SpacePointer = 1 then
                            SpacePointer := MaxStrLen(TempSalesCrMemoLine.Description) + 1;
                        TempSalesCrMemoLine.Description := CopyStr(Comment, 1, SpacePointer - 1);
                        TempSalesCrMemoLine."Description 2" :=
                          CopyStr(CopyStr(Comment, SpacePointer + 1), 1, MaxStrLen(TempSalesCrMemoLine."Description 2"));
                    end;
                    TempSalesCrMemoLine.Insert;
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesCrMemoLine.Init;
                    TempSalesCrMemoLine."Document No." := "Sales Cr.Memo Header"."No.";
                    TempSalesCrMemoLine."Line No." := HighestLineNo + 1000;
                    HighestLineNo := TempSalesCrMemoLine."Line No.";

                    TempSalesCrMemoLine.Insert;
                end;
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    /*column(CurrReport_PAGENO; CurrReport.PageNo)
                    {
                    }*/
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(PrintFooter; PrintFooter)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(Serie_Factura_________No__Comprobante_Fiscal_; 'D.: ' + "Sales Cr.Memo Header"."No. Comprobante Fiscal")
                    {
                        Description = '"Serie Factura" + ''-''+"No. Comprobante Fiscal"';
                    }
                    column(Sales_Invoice_Header__Posting_Date_; Format("Sales Cr.Memo Header"."Document Date"))
                    {
                    }
                    column(RUC; "Sales Cr.Memo Header"."VAT Registration No.")
                    {
                    }
                    column(Phone_No; Cliente."Phone No.")
                    {
                    }
                    column(Sales_Invoice_Header__Bill_to_Customer_No__; "Sales Cr.Memo Header"."Bill-to Customer No." + ' - ' + "Sales Cr.Memo Header"."Bill-to Name")
                    {
                    }
                    column(Establecimiento; "Sales Cr.Memo Header"."Ship-to Code" + ' - ' + "Sales Cr.Memo Header"."Ship-to Name")
                    {
                    }
                    column(SCMH_Ship_To_Address; "Sales Cr.Memo Header"."Bill-to Address")
                    {
                    }
                    column(Bodega; 'Bod.: ' + "Sales Cr.Memo Header"."Location Code")
                    {
                        Description = '"Serie Factura" + ''-''+"No. Comprobante Fiscal"';
                    }
                    column(Vendedor; Vend)
                    {
                    }
                    column(Page_Caption; Page_CaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    column(gtDireccion; gtDireccion)
                    {
                    }
                    dataitem(SalesCrMemoLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        /*column(STRSUBSTNO_Text001_CurrReport_PAGENO___1_; StrSubstNo(Text001, CurrReport.PageNo - 1))
                        {
                        }*/
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLine__No__; TempSalesCrMemoLine."No.")
                        {
                        }
                        column(Line_Disc_Pct; TempSalesCrMemoLine."Line Discount %")
                        {
                        }
                        column(TempSalesCrMemoLine_Quantity; TempSalesCrMemoLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(UnitPrice; TempSalesCrMemoLine."Unit Price")
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(AmountExclInvDisc_Control53; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLine_Description_________TempSalesCrMemoLine__Description_2_; TempSalesCrMemoLine.Description + ' ' + TempSalesCrMemoLine."Description 2")
                        {
                        }
                        /*column(STRSUBSTNO_Text002_CurrReport_PAGENO___1_; StrSubstNo(Text002, CurrReport.PageNo + 1))
                        {
                        }*/
                        column(AmountExclInvDisc_Control40; AmountExclInvDisc)
                        {
                        }
                        column(TaxLiable; TaxLiable)
                        {
                        }
                        column(TempSalesCrMemoLine_Amount___TaxLiable; TempSalesCrMemoLine.Amount - TaxLiable)
                        {
                        }
                        column(AmountExclInvDisc_Control79; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLine_Amount___AmountExclInvDisc; TempSalesCrMemoLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLine__Amount_Including_VAT____TempSalesCrMemoLine_Amount; TempSalesCrMemoLine."Amount Including VAT" - TempSalesCrMemoLine.Amount)
                        {
                        }
                        column(TempSalesCrMemoLine__Amount_Including_VAT_; TempSalesCrMemoLine."Amount Including VAT")
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel_1_; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownLabel_2_; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt_1_; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt_2_; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownAmt_3_; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownLabel_3_; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt_4_; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel_4_; BreakdownLabel[4])
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(NoDocExt; 'Aplica a factura: ' + SIH."No. Serie NCF Facturas" + ' - ' + "Sales Cr.Memo Header"."No. Comprobante Fiscal Rel.")
                        {
                        }
                        column(Bodega2; Bodega2)
                        {
                            Description = '"Serie Factura" + ''-''+"No. Comprobante Fiscal"';
                        }
                        column(Item_No_Caption; Item_No_CaptionLbl)
                        {
                        }
                        column(Desc_Pct; Desc_PctLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                        {
                        }
                        column(Total_PriceCaption; Total_PriceCaptionLbl)
                        {
                        }
                        column(Subtotal_Caption; Subtotal_CaptionLbl)
                        {
                        }
                        column(Invoice_Discount_Caption; Invoice_Discount_CaptionLbl)
                        {
                        }
                        column(Total_Caption; Total_CaptionLbl)
                        {
                        }
                        column(Amount_Subject_to_Sales_TaxCaption; Amount_Subject_to_Sales_TaxCaptionLbl)
                        {
                        }
                        column(Amount_Exempt_from_Sales_TaxCaption; Amount_Exempt_from_Sales_TaxCaptionLbl)
                        {
                        }
                        column(SalesCrMemoLine_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;
                            if OnLineNumber = 1 then
                                TempSalesCrMemoLine.Find('-')
                            else
                                TempSalesCrMemoLine.Next;

                            if TempSalesCrMemoLine.Type = TempSalesCrMemoLine.Type::" " then begin
                                TempSalesCrMemoLine."No." := '';
                                TempSalesCrMemoLine."Unit of Measure" := '';
                                TempSalesCrMemoLine.Amount := 0;
                                TempSalesCrMemoLine."Amount Including VAT" := 0;
                                TempSalesCrMemoLine."Inv. Discount Amount" := 0;
                                TempSalesCrMemoLine.Quantity := 0;
                            end else
                                if TempSalesCrMemoLine.Type = TempSalesCrMemoLine.Type::"G/L Account" then
                                    TempSalesCrMemoLine."No." := '';

                            if TempSalesCrMemoLine.Amount <> TempSalesCrMemoLine."Amount Including VAT" then begin
                                TaxFlag := true;
                                TaxLiable := TempSalesCrMemoLine.Amount;
                            end else begin
                                TaxFlag := false;
                                TaxLiable := 0;
                            end;

                            AmountExclInvDisc := TempSalesCrMemoLine.Amount + TempSalesCrMemoLine."Inv. Discount Amount";

                            if TempSalesCrMemoLine.Quantity = 0 then
                                UnitPriceToPrint := 0  // so it won't print
                            else
                                UnitPriceToPrint := Round(AmountExclInvDisc / TempSalesCrMemoLine.Quantity, 0.00001);

                            //if IsServiceTier then begin
                            if OnLineNumber = NumberOfLines then
                                PrintFooter := true;
                            //end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            /*CurrReport.CreateTotals(TaxLiable, AmountExclInvDisc, TempSalesCrMemoLine.Amount, TempSalesCrMemoLine."Amount Including VAT",
                                                    TempSalesCrMemoLine."Unit Price", TempSalesCrMemoLine."Line Discount Amount",     //DYN.
                                                    TempSalesCrMemoLine.Quantity);*/  //DYN.

                            NumberOfLines := TempSalesCrMemoLine.Count;
                            SetRange(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                            PrintFooter := false;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    //CurrReport.PageNo := 1;

                    if CopyNo = NoLoops then begin
                        if not CurrReport.Preview then
                            SalesCrMemoPrinted.Run("Sales Cr.Memo Header");
                        CurrReport.Break;
                    end else
                        CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                        Clear(CopyTxt)
                    else
                        CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies);
                    if NoLoops <= 0 then
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                rDim: Record "Dimension Set Entry";
                lrSeriesNoLine: Record "No. Series Line";
            begin
                // DYN: ---------------------------- Codigo Dynasoft ------------------------------------------------
                //MOI
                gtDireccion := lrSeriesNoLine.getDireccionSucursal("Sales Cr.Memo Header"."Pre-Assigned No. Series", "Sales Cr.Memo Header"."Posting Date");
                //MOI
                Comentario := '';
                iBruto := 0;
                ImporteCargos := 0;
                ImporteSinCargos := 0;
                DescuentoCargos := 0;
                CantUnidades := 0;
                igv := 0;

                Cliente.Get("Sell-to Customer No.");

                if Loc.Get("Location Code") then;

                if "Currency Code" <> '' then begin
                    Currency.Get("Currency Code");
                    CurrName := Currency.Description;
                    CodDivLocal := "Currency Code";
                end
                else begin
                    CurrName := GLSetUp."Nombre Divisa Local";
                    CodDivLocal := GLSetUp."LCY Code";
                end;

                if Vendedor_Comprador.Get("Salesperson Code") then
                    Vend := 'Vendedor: ' + Vendedor_Comprador.Code + ' - ' + CopyStr(Vendedor_Comprador.Name, 1, 30);
                // VendorName := Vendedor_Comprador.Name;

                Bodega2 := 'Bod.: ' + "Sales Cr.Memo Header"."Location Code" + ' - ' + Loc.Name;

                //NoDocExt := "Sales Cr.Memo Header"."External Document No.";

                if PT.Get("Payment Terms Code") then
                    CondicionPago := PT.Description;

                SCL.SetRange("Document Type", SCL."Document Type"::"Posted Credit Memo");
                SCL.SetRange("No.", "No.");

                if SCL.FindFirst then
                    Comentario := SCL.Comment;


                CalcFields(Amount, "Amount Including VAT");

                if "Amount Including VAT" - Amount <> 0 then
                    txtIva := txt004
                else
                    txtIva := '';

                //ChkTransMgt.FormatNoText(DescriptionLine, "Amount Including VAT", 2058, "Currency Code");

                TotFactura := "Amount Including VAT";

                //Datos para Historico de RTC
                SIL.Reset;
                SIL.SetRange("Document No.", "No.");
                SIL.SetFilter(Type, '<>%1', SIL.Type::"Charge (Item)");
                if SIL.FindSet then
                    repeat
                        ImporteSinCargos += SIL.Amount + SIL."Line Discount Amount";
                        Descuento += SIL."Line Discount Amount";
                        CantUnidades += SIL.Quantity;
                        igv += SIL."Amount Including VAT" - SIL.Amount;
                    until SIL.Next = 0;

                SIL.Reset;
                SIL.SetRange("Document No.", "No.");
                SIL.SetRange(SIL.Type, SIL.Type::"Charge (Item)");
                if SIL.FindSet then
                    repeat
                        ImporteCargos += SIL.Amount + SIL."Line Discount Amount";
                        DescuentoCargos += SIL."Line Discount Amount";
                        igv += SIL."Amount Including VAT" - SIL.Amount;
                    until SIL.Next = 0;


                //Datos Dimensiones
                /*
                //Tipo Clinte
                PostedDocDim.RESET;
                PostedDocDim.SETRANGE("Table ID",114);
                PostedDocDim.SETRANGE("Document No.","No.");
                PostedDocDim.SETRANGE("Dimension Code",'TIPO_CLIENTE');
                PostedDocDim.SETRANGE("Line No.",0);
                IF PostedDocDim.FINDFIRST THEN
                  BEGIN
                    //TipoCliente := PostedDocDim."Dimension Value Code";
                    DimVal.RESET;
                    DimVal.SETRANGE("Dimension Code",PostedDocDim."Dimension Code");
                    DimVal.SETRANGE(Code,PostedDocDim."Dimension Value Code");
                    IF DimVal.FINDFIRST THEN
                      TipoCliente := DimVal.Name;
                  END;
                
                //Tipo Venta
                PostedDocDim.RESET;
                PostedDocDim.SETRANGE("Table ID",114);
                PostedDocDim.SETRANGE("Document No.","No.");
                PostedDocDim.SETRANGE("Dimension Code",'TIPO_VENTA');
                PostedDocDim.SETRANGE("Line No.",0);
                IF PostedDocDim.FINDFIRST THEN
                  BEGIN
                    //TipoCliente := PostedDocDim."Dimension Value Code";
                    DimVal.RESET;
                    DimVal.SETRANGE("Dimension Code",PostedDocDim."Dimension Code");
                    DimVal.SETRANGE(Code,PostedDocDim."Dimension Value Code");
                    IF DimVal.FINDFIRST THEN
                      TipoVenta := DimVal.Name;
                  END;
                */
                if "Sales Cr.Memo Header"."Dimension Set ID" <> 0 then begin
                    if rDim.Get("Sales Cr.Memo Header"."Dimension Set ID", 'TIPO_CLIENTE') then
                        TipoCliente := rDim."Dimension Value Name";
                    if rDim.Get("Sales Cr.Memo Header"."Dimension Set ID", 'TIPO_VENTA') then
                        TipoVenta := rDim."Dimension Value Name";
                end;
                //-MIG

                if Cust.Get("Sell-to Customer No.") then
                    Nombre := UpperCase(Cust.Name);

                if PostCodes.Get(Cust."Post Code", Cust.City) then begin
                    Provincia := PostCodes.County;
                    Departamento := PostCodes.Colonia;
                end;


                if ("No. Printed" > 0) and (not CurrReport.Preview) and (AnulaComp) then
                    if Confirm(txt0001, false, NoSerMagmnt.GetNextNo("No. Serie NCF Abonos", WorkDate, false)) then begin
                        NCFAnulados."No. documento" := "No.";
                        NCFAnulados."No. Serie NCF Facturas" := "No. Serie NCF Abonos";
                        NCFAnulados."No. Comprobante Fiscal" := "No. Comprobante Fiscal";
                        NCFAnulados."Fecha anulacion" := Today;
                        NCFAnulados."Tipo Documento" := 3;
                        NCFAnulados."No. Autorizacion" := "No. Autorizacion Comprobante";
                        NCFAnulados."Punto Emision" := "Punto de Emision Factura";
                        NCFAnulados.Establecimiento := "Establecimiento Factura";
                        NCFAnulados.Insert;
                        "No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo("No. Serie NCF Abonos", Today, true);
                        Modify;

                        CLE.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                        CLE.SetRange("Document No.", "No.");
                        CLE.SetRange("Document Type", CLE."Document Type"::"Credit Memo");
                        CLE.SetRange("Customer No.", "Sell-to Customer No.");
                        CLE.FindFirst;
                        CLE."No. Comprobante Fiscal" := "No. Comprobante Fiscal";
                        CLE.Modify;
                    end;

                PuntoLlegada := "Bill-to Address" + ', ' + "Bill-to City" + ', ' + Provincia + ', ' + Departamento;
                // DYN: ---------------------------- Codigo Dynasoft ------------------------------------------------

                // DYN: ---------------------------- Codigo Standard ------------------------------------------------
                if PrintCompany then begin
                    if RespCenter.Get("Responsibility Center") then begin
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    end;
                end;
                //ComentadoCurrReport.Language := Language.GetLanguageID("Language Code");

                if "Salesperson Code" = '' then
                    Clear(SalesPurchPerson)
                else
                    SalesPurchPerson.Get("Salesperson Code");

                if "Bill-to Customer No." = '' then begin
                    "Bill-to Name" := Text009;
                    "Ship-to Name" := Text009;
                end;

                FormatAddress.SalesCrMemoBillTo(BillToAddress, "Sales Cr.Memo Header");
                FormatAddress.SalesCrMemoShipTo(ShipToAddress, ShipToAddress, "Sales Cr.Memo Header");

                if LogInteraction then
                    if not CurrReport.Preview then
                        SegManagement.LogDocument(
                          6, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.", "Salesperson Code",
                          "Campaign No.", "Posting Description", '');

                Clear(BreakdownTitle);
                Clear(BreakdownLabel);
                Clear(BreakdownAmt);
                TotalTaxLabel := Text008;
                TaxRegNo := '';
                TaxRegLabel := '';
                if "Tax Area Code" <> '' then begin
                    TaxArea.Get("Tax Area Code");
                    // case TaxArea."Country/Region" of
                    //     TaxArea."Country/Region"::US:
                    //         TotalTaxLabel := Text005;
                    //     TaxArea."Country/Region"::CA:
                    //         begin
                    //             TotalTaxLabel := Text007;
                    //             TaxRegNo := CompanyInformation."VAT Registration No.";
                    //             TaxRegLabel := CompanyInformation.FieldCaption("VAT Registration No.");
                    //         end;
                    // end;
                    // SalesTaxCalc.StartSalesTaxCalculation;
                    // if TaxArea."Use External Tax Engine" then
                    //     SalesTaxCalc.CallExternalTaxEngineForDoc(DATABASE::"Sales Cr.Memo Header", 0, "No.")
                    // else begin
                    //     SalesTaxCalc.AddSalesCrMemoLines("No.");
                    //     SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                    // end;
                    // SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                    // BrkIdx := 0;
                    PrevPrintOrder := 0;
                    PrevTaxPercent := 0;
                    // TempSalesTaxAmtLine.Reset;
                    // //TempSalesTaxAmtLine.SetCurrentKey("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
                    // if TempSalesTaxAmtLine.Find('-') then
                    //     repeat
                    //         if (TempSalesTaxAmtLine."Print Order" = 0) or
                    //            (TempSalesTaxAmtLine."Print Order" <> PrevPrintOrder) or
                    //            (TempSalesTaxAmtLine."Tax %" <> PrevTaxPercent)
                    //         then begin
                    //             BrkIdx := BrkIdx + 1;
                    //             if BrkIdx > 1 then begin
                    //                 // if TaxArea."Country/Region" = TaxArea."Country/Region"::CA then
                    //                 //     BreakdownTitle := Text006
                    //                 // else
                    //                     BreakdownTitle := Text003;
                    //             end;
                    //             if BrkIdx > ArrayLen(BreakdownAmt) then begin
                    //                 BrkIdx := BrkIdx - 1;
                    //                 BreakdownLabel[BrkIdx] := Text004;
                    //             end else
                    //                 BreakdownLabel[BrkIdx] := StrSubstNo(TempSalesTaxAmtLine."Print Description", TempSalesTaxAmtLine."Tax %");
                    //         end;
                    //         BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + TempSalesTaxAmtLine."Tax Amount";
                    //     until Next = 0;
                    if BrkIdx = 1 then begin
                        Clear(BreakdownLabel);
                        Clear(BreakdownAmt);
                    end;
                end;
                // DYN: ---------------------------- Codigo Standard ------------------------------------------------

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Anular Comprobante"; AnulaComp)
                    {
                        Caption = 'Void Fiscal No.';
                        ApplicationArea = All;
                    }
                    field(NoCopies; NoCopies)
                    {
                        Caption = 'Number of Copies';
                        ApplicationArea = All;
                    }
                    field(PrintCompany; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                        ApplicationArea = All;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            /*   LogInteraction := SegManagement.FindInteractTmplCode(6) <> ''; */
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        // DYN: ---------------------------- Codigo Standard ------------------------------------------------

        CompanyInformation.Get;
        SalesSetup.Get;

        /*
        CASE SalesSetup."Logo Position on Documents" OF
          SalesSetup."Logo Position on Documents"::"No Logo":;
          SalesSetup."Logo Position on Documents"::Left:
            BEGIN
              CompanyInformation.CALCFIELDS(Picture);
            END;
          SalesSetup."Logo Position on Documents"::Center:
            BEGIN
              CompanyInfo1.GET;
              CompanyInfo1.CALCFIELDS(Picture);
            END;
          SalesSetup."Logo Position on Documents"::Right:
            BEGIN
              CompanyInfo2.GET;
              CompanyInfo2.CALCFIELDS(Picture);
            END;
        END;
        
        IF PrintCompany THEN
          FormatAddress.Company(CompanyAddress,CompanyInformation)
        ELSE
          CLEAR(CompanyAddress);
        */
        // DYN: ---------------------------- Codigo Standard ------------------------------------------------

        // DYN: ---------------------------- Codigo Dynasoft ------------------------------------------------

        GLSetUp.Get;
        GLSetUp.TestField("LCY Code");
        GLSetUp.TestField("Nombre Divisa Local");

        CompanyInformation.CalcFields(Picture);
        rPais.SetRange(Code, CompanyInformation."Country/Region Code");
        rPais.FindFirst;
        vPais := CompanyInformation.City + ', ' + CompanyInformation.Name + ' ' + CompanyInformation."Post Code";

    end;

    var
        TaxLiable: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempSalesCrMemoLine: Record "Sales Cr.Memo Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language2: Record Language;
        //TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text[10];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        TaxFlag: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesCrMemoPrinted: Codeunit "Sales Cr. Memo-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        Text000: Label 'COPY';
        Text001: Label 'Transferred from page %1';
        Text002: Label 'Transferred to page %1';
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array[4] of Text[30];
        BreakdownAmt: array[4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        Text009: Label 'VOID CREDIT MEMO';
        LogInteractionEnable: Boolean;
        "//DYN ---------------------": Integer;
        Cliente: Record Customer;
        Loc: Record Location;
        Currency: Record Currency;
        GLSetUp: Record "General Ledger Setup";
        Vendedor_Comprador: Record "Salesperson/Purchaser";
        PT: Record "Payment Terms";
        SCL: Record "Sales Comment Line";
        //ChkTransMgt: Report "Check Translation Management";
        SIL: Record "Sales Cr.Memo Line";
        DimVal: Record "Dimension Value";
        Cust: Record Customer;
        PostCodes: Record "Post Code";
        ConfSant: Record "Config. Empresa";
        NCFAnulados: Record "NCF Anulados";
        CLE: Record "Cust. Ledger Entry";
        rPais: Record "Country/Region";
        NoSeriesMgt: Codeunit "No. Series";
        Comentario: Text[1024];
        iBruto: Decimal;
        ImporteCargos: Decimal;
        ImporteSinCargos: Decimal;
        DescuentoCargos: Decimal;
        CantUnidades: Decimal;
        igv: Decimal;
        CurrName: Text[30];
        CodDivLocal: Code[20];
        VendorName: Text[50];
        CondicionPago: Text[100];
        txtIva: Text[30];
        DescriptionLine: array[2] of Text[250];
        TotFactura: Decimal;
        Descuento: Decimal;
        TipoCliente: Text[100];
        TipoVenta: Text[100];
        Nombre: Text[250];
        Provincia: Text[150];
        Departamento: Text[150];
        PuntoLlegada: Text[500];
        vPais: Text[50];
        txt004: Label '(*) IVA';
        Vend: Text[50];
        Bodega2: Text[50];
        NoDocExt: Text[50];
        SIH: Record "Sales Invoice Header";
        AnulaComp: Boolean;
        txt0001: Label 'This reprint will void the actual correlative and will assing a new one %1. Confirm that you want to proceed';
        NoSerMagmnt: Codeunit "No. Series";
        Page_CaptionLbl: Label 'Page:';
        Item_No_CaptionLbl: Label 'Item No.';
        Desc_PctLbl: Label 'Disc. %';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        Total_PriceCaptionLbl: Label 'Total Price';
        Subtotal_CaptionLbl: Label 'Subtotal:';
        Invoice_Discount_CaptionLbl: Label 'Invoice Discount:';
        Total_CaptionLbl: Label 'Total:';
        Amount_Subject_to_Sales_TaxCaptionLbl: Label 'Amount Subject to Sales Tax';
        Amount_Exempt_from_Sales_TaxCaptionLbl: Label 'Amount Exempt from Sales Tax';
        gtDireccion: Text[50];
}

