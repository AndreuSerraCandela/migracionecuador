page 55013 "Datos ATS Anulados"
{
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            field(FechaDesde; FechaDesde)
            {
                Caption = 'Fecha Desde';
            }
            field(FechaHasta; FechaHasta)
            {
                Caption = 'Fecha Hasta';
            }
            field(TipoTrans; TipoTrans)
            {
                Caption = 'Tipo';
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000004>")
            {
                Caption = '&Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if (FechaDesde = 0D) or (FechaHasta = 0D) then
                        Error(Error001);
                    DetATS.DeleteAll;

                    if TipoTrans = TipoTrans::Compra then begin
                        Counter := 0;
                        PIH.Reset;
                        PIH.SetCurrentKey("Posting Date");
                        PIH.SetRange("Posting Date", FechaDesde, FechaHasta);
                        if PIH.FindSet then begin
                            CounterTotal := PIH.Count;
                            Window.Open(Text001);
                            repeat
                                Corregida := false;
                                //Revisar si la factura fue liquidada con una nota de credito por correccion
                                VLE.Reset;
                                VLE.SetCurrentKey("Document Type", "Vendor No.", "Posting Date", "Currency Code");
                                VLE.SetRange("Document Type", VLE."Document Type"::Invoice);
                                VLE.SetRange("Vendor No.", PIH."Pay-to Vendor No.");
                                VLE.SetRange("Posting Date", PIH."Posting Date");
                                VLE.SetRange("Document No.", PIH."No.");
                                if VLE.FindFirst then begin
                                    //Si la factura esta cerrada
                                    if VLE."Closed by Entry No." <> 0 then begin
                                        VLE1.Get(VLE."Closed by Entry No.");
                                        if VLE1."Document Type" = VLE1."Document Type"::"Credit Memo" then begin
                                            PCMH.Get(VLE1."Document No.");
                                            if PCMH.Correction then
                                                Corregida := true
                                        end;
                                    end
                                    else begin
                                        VLE1.Reset;
                                        VLE1.SetCurrentKey("Closed by Entry No.");
                                        VLE1.SetRange("Closed by Entry No.", VLE."Entry No.");
                                        VLE1.SetRange("Document Type", VLE1."Document Type"::"Credit Memo");
                                        if VLE1.FindFirst then begin
                                            PCMH.Get(VLE1."Document No.");
                                            if PCMH.Correction then
                                                Corregida := true
                                        end;
                                    end;
                                end;
                                if Corregida then begin
                                    Counter := Counter + 1;
                                    Window.Update(1, PIH."No.");
                                    Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                                    DetATS.Init;
                                    DetATS."Tipo Documento" := DetATS."Tipo Documento"::Invoice;
                                    DetATS."No. Documento" := PIH."No.";
                                    DetATS.Tipo := DetATS.Tipo::Compra;
                                    DetATS.Descripcion := PIH."Posting Description";
                                    DetATS."Fecha Registro" := PIH."Posting Date";
                                    DetATS."Numero Comprobante Fiscal" := PIH."No. Comprobante Fiscal";
                                    PIH.CalcFields(Amount);
                                    PIH.CalcFields("Amount Including VAT");
                                    DetATS.Importe := PIH.Amount;
                                    DetATS."Importe IVA" := PIH."Amount Including VAT" - PIH.Amount;
                                    DetATS."Importe IVA Incl." := PIH."Amount Including VAT";
                                    DetATS."Source Type" := DetATS."Source Type"::Vendor;
                                    DetATS."Source No." := PIH."Pay-to Vendor No.";
                                    DetATS."RUC/Cedula" := PIH."VAT Registration No.";
                                    HR.Reset;
                                    //HR.SETRANGE("Tipo documento",HR."Tipo documento"::Invoice);
                                    HR.SetRange("No. documento", PIH."No.");
                                    HR.SetRange("Cód. Proveedor", PIH."Pay-to Vendor No.");
                                    HR.SetRange("Fecha Registro", PIH."Posting Date");
                                    //HR.SETRANGE(Anulada,FALSE);
                                    //HR.SETFILTER(NCF,'<>%1','');
                                    I := 0;
                                    if HR.FindSet then begin
                                        repeat
                                            I += 1;
                                            if I = 1 then begin
                                                DetATS."Cod. Retencion 1" := HR."Código Retención";
                                                DetATS."Importe Retencion 1" := HR."Importe Retenido";
                                                DetATS."Base Retencion 1" := HR."Importe Base Retencion";
                                                DetATS."Porcentaje Retencion 1" := HR."Importe Retención";
                                                DetATS."No. Comprobante Retencion 1" := HR.NCF;
                                                DetATS."No. Autorizacion Retencion 1" := HR."No. autorizacion NCF";
                                                DetATS."Punto Emision Retencion 1" := HR."Punto Emision";
                                                DetATS."Establecimiento Retencion 1" := HR.Establecimiento;
                                                NoSeriesLine.Reset;
                                                NoSeriesLine.SetRange("No. Autorizacion", HR."No. autorizacion NCF");
                                                NoSeriesLine.SetRange(Establecimiento, HR.Establecimiento);
                                                NoSeriesLine.SetRange("Punto de Emision", HR."Punto Emision");
                                                if NoSeriesLine.FindFirst then
                                                    DetATS."Fecha Caducidad Retencion 1" := NoSeriesLine."Fecha Caducidad";
                                            end;

                                            if I = 2 then begin
                                                DetATS."Cod. Retencion 2" := HR."Código Retención";
                                                DetATS."Importe Retencion 2" := HR."Importe Retenido";
                                                DetATS."Base Retencion 2" := HR."Importe Base Retencion";
                                                DetATS."Porcentaje Retencion 2" := HR."Importe Retención";
                                                DetATS."No. Comprobante Retencion 2" := HR.NCF;
                                                DetATS."No. Autorizacion Retencion 2" := HR."No. autorizacion NCF";
                                                DetATS."Punto Emision Retencion 2" := HR."Punto Emision";
                                                DetATS."Establecimiento Retencion 2" := HR.Establecimiento;
                                                NoSeriesLine.Reset;
                                                NoSeriesLine.SetRange("No. Autorizacion", HR."No. autorizacion NCF");
                                                NoSeriesLine.SetRange(Establecimiento, HR.Establecimiento);
                                                NoSeriesLine.SetRange("Punto de Emision", HR."Punto Emision");
                                                if NoSeriesLine.FindFirst then
                                                    DetATS."Fecha Caducidad Retencion 2" := NoSeriesLine."Fecha Caducidad";
                                            end;

                                            if I = 3 then begin
                                                DetATS."Cod. Retencion 3" := HR."Código Retención";
                                                DetATS."Importe Retencion 3" := HR."Importe Retenido";
                                                DetATS."Base Retencion 3" := HR."Importe Base Retencion";
                                                DetATS."Porcentaje Retencion 3" := HR."Importe Retención";
                                                DetATS."No. Comprobante Retencion 3" := HR.NCF;
                                                DetATS."No. Autorizacion Retencion 3" := HR."No. autorizacion NCF";
                                                DetATS."Punto Emision Retencion 3" := HR."Punto Emision";
                                                DetATS."Establecimiento Retencion 3" := HR.Establecimiento;
                                                NoSeriesLine.Reset;
                                                NoSeriesLine.SetRange("No. Autorizacion", HR."No. autorizacion NCF");
                                                NoSeriesLine.SetRange(Establecimiento, HR.Establecimiento);
                                                NoSeriesLine.SetRange("Punto de Emision", HR."Punto Emision");
                                                if NoSeriesLine.FindFirst then
                                                    DetATS."Fecha Caducidad Retencion 3" := NoSeriesLine."Fecha Caducidad";
                                            end;
                                        until (HR.Next = 0) or (I = 3);
                                    end
                                    else begin
                                        DetATS."Cod. Retencion 1" := '332';
                                    end;
                                    DetATS."No. Autorizacion Documento" := PIH."No. Autorizacion Comprobante";
                                    DetATS."Punto Emision Documento" := PIH."Punto de Emision";
                                    DetATS."Establecimiento Documento" := PIH.Establecimiento;
                                    DetATS."No. Pedido" := PIH."Order No.";
                                    //DetATS."Comprobante Egreso"
                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                    VE.SetRange("Document No.", PIH."No.");
                                    VE.SetRange("Posting Date", PIH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Purchase);
                                    VE.SetRange(VE."VAT Prod. Posting Group", '_EXENTO');
                                    if VE.FindSet then
                                        repeat
                                            DetATS._EXENTO += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                    VE.SetRange("Document No.", PIH."No.");
                                    VE.SetRange("Posting Date", PIH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Purchase);
                                    VE.SetRange(VE."VAT Prod. Posting Group", '_GR_12');
                                    if VE.FindSet then
                                        repeat
                                            DetATS._GR_12 += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                    VE.SetRange("Document No.", PIH."No.");
                                    VE.SetRange("Posting Date", PIH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Purchase);
                                    VE.SetRange(VE."VAT Prod. Posting Group", '_GR_0');
                                    if VE.FindSet then
                                        repeat
                                            DetATS._GR_0 += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                    VE.SetRange("Document No.", PIH."No.");
                                    VE.SetRange("Posting Date", PIH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Purchase);
                                    VE.SetRange(VE."VAT Prod. Posting Group", '10_SERVIC');
                                    if VE.FindSet then
                                        repeat
                                            DetATS."10_SERVIC" += VE.Amount;
                                        until VE.Next = 0;

                                    // DetATS."Tipo Retencion"               := FORMAT(HR."Código Retención");
                                    DetATS."Fecha Caducidad" := PIH."Fecha Caducidad";
                                    //DetATS."% Retencion"                  := HR."Importe Retención";
                                    //DetATS."Retencion IVA"                := HR."Retencion IVA";
                                    DetATS."Tipo Comprobante" := PIH."Tipo de Comprobante";
                                    //DetATS."Importe Base Retencion"       := HR."Importe Base Retencion";
                                    /*MovCont.RESET;
                                    MovCont.SETCURRENTKEY("G/L Account No.","Posting Date");
                                    MovCont.SETRANGE("G/L Account No.",HR."Cta. Contable");
                                    MovCont.SETRANGE("Posting Date",HR."Fecha Registro");
                                    MovCont.SETRANGE("Document No.",HR."No. documento");
                                    MovCont.SETRANGE("Document Type",MovCont."Document Type"::Payment);
                                    IF MovCont.FINDFIRST THEN
                                      DetATS."Secuencia Contabilidad" := MovCont."Entry No.";
                                    MovCont.INSERT;
                                    */

                                    DetATS.Insert;
                                end;
                            until PIH.Next = 0;
                            Window.Close;
                        end;

                        Commit;
                        DetalleATSPage.RunModal;
                    end
                    else begin
                        SIH.Reset;
                        SIH.SetCurrentKey("Posting Date");
                        SIH.SetRange("Posting Date", FechaDesde, FechaHasta);
                        if SIH.FindSet then begin
                            CounterTotal := SIH.Count;
                            Window.Open(Text001);
                            repeat
                                Counter := Counter + 1;
                                Window.Update(1, SIH."No.");
                                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                                Corregida := false;
                                //Revisar si la factura fue liquidada con una nota de credito por correccion
                                CLE.Reset;
                                CLE.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
                                CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                                CLE.SetRange("Customer No.", SIH."Bill-to Customer No.");
                                CLE.SetRange("Posting Date", SIH."Posting Date");
                                CLE.SetRange("Document No.", SIH."No.");
                                if CLE.FindFirst then begin
                                    //Si la factura esta cerrada
                                    if CLE."Closed by Entry No." <> 0 then begin
                                        CLE1.Get(CLE."Closed by Entry No.");
                                        if CLE1."Document Type" = CLE1."Document Type"::"Credit Memo" then begin
                                            SCMH.Get(CLE1."Document No.");
                                            if SCMH.Correction then
                                                Corregida := true;
                                        end;
                                    end
                                    else begin
                                        CLE1.Reset;
                                        CLE1.SetCurrentKey("Closed by Entry No.");
                                        CLE1.SetRange("Closed by Entry No.", CLE."Entry No.");
                                        CLE1.SetRange("Document Type", CLE1."Document Type"::"Credit Memo");
                                        if CLE1.FindFirst then begin
                                            SCMH.Get(CLE1."Document No.");
                                            if SCMH.Correction then
                                                Corregida := true
                                        end;
                                    end;
                                end;
                                if Corregida then begin
                                    DetATS.Init;
                                    DetATS."Tipo Documento" := DetATS."Tipo Documento"::Invoice;
                                    DetATS."No. Documento" := SIH."No.";
                                    DetATS.Tipo := DetATS.Tipo::Venta;
                                    DetATS.Descripcion := SIH."Posting Description";
                                    DetATS."Fecha Registro" := SIH."Posting Date";
                                    DetATS."Numero Comprobante Fiscal" := SIH."No. Comprobante Fiscal";
                                    SIH.CalcFields(Amount);
                                    SIH.CalcFields("Amount Including VAT");
                                    DetATS.Importe := SIH.Amount;
                                    DetATS."Importe IVA" := SIH."Amount Including VAT" - SIH.Amount;
                                    DetATS."Importe IVA Incl." := SIH."Amount Including VAT";
                                    DetATS."Source Type" := DetATS."Source Type"::Customer;
                                    DetATS."Source No." := SIH."Bill-to Customer No.";
                                    DetATS."RUC/Cedula" := SIH."VAT Registration No.";
                                    DetATS."No. Autorizacion Documento" := SIH."No. Autorizacion Comprobante";
                                    DetATS."Punto Emision Documento" := SIH."Punto de Emision Factura";
                                    DetATS."Establecimiento Documento" := SIH."Establecimiento Factura";

                                    if SIH."Venta TPV" = TRUE then
                                        DetATS."Tipo Comprobante" := '01'
                                    else
                                        DetATS."Tipo Comprobante" := SIH."Tipo de Comprobante";

                                    /*
                                     IF SIH."Tipo pedido" = SIH."Tipo pedido"::TPV THEN
                                       DetATS."Tipo Documento" := SIH."Tipo Ruc/Cedula"
                                     ELSE
                                       BEGIN
                                         Cust.GET(SIH."Bill-to Customer No.");
                                         DetATS."Tipo Documento" := Cust."Tipo Ruc/Cedula";
                                       END;
                                    */
                                    if SIH."Fecha Caducidad Comprobante" = 0D then begin
                                        NoSeriesLine.Reset;
                                        NoSeriesLine.SetRange("Series Code", SIH."No. Serie NCF Facturas");
                                        NoSeriesLine.SetFilter("Starting No.", '<=%1', SIH."No. Comprobante Fiscal");
                                        NoSeriesLine.SetFilter("Ending No.", '>=%1', SIH."No. Comprobante Fiscal");
                                        //IF SalesHeader."Tipo pedido" <> SalesHeader."Tipo pedido"::TPV THEN
                                        //  BEGIN
                                        NoSeriesLine.SetRange(Establecimiento, SIH."Establecimiento Factura");
                                        NoSeriesLine.SetRange("Punto de Emision", SIH."Punto de Emision Factura");
                                        //  END;
                                        if NoSeriesLine.FindFirst then
                                            DetATS."Fecha Caducidad" := NoSeriesLine."Fecha Caducidad";
                                    end
                                    else
                                        DetATS."Fecha Caducidad" := SIH."Fecha Caducidad Comprobante";

                                    DetATS."No. Pedido" := SIH."Order No.";
                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                    VE.SetRange("Document No.", SIH."No.");
                                    VE.SetRange("Posting Date", SIH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '_EXENTO');
                                    if VE.FindSet then
                                        repeat
                                            DetATS._EXENTO += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                    VE.SetRange("Document No.", SIH."No.");
                                    VE.SetRange("Posting Date", SIH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '12% IVA');
                                    if VE.FindSet then
                                        repeat
                                            DetATS."12% IVA" += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                    VE.SetRange("Document No.", SIH."No.");
                                    VE.SetRange("Posting Date", SIH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '_GR_0');
                                    if VE.FindSet then
                                        repeat
                                            DetATS._GR_0 += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                    VE.SetRange("Document No.", SIH."No.");
                                    VE.SetRange("Posting Date", SIH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '_GR_12');
                                    if VE.FindSet then
                                        repeat
                                            DetATS._GR_12 += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                    VE.SetRange("Document No.", SIH."No.");
                                    VE.SetRange("Posting Date", SIH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '10_SERVIC');
                                    if VE.FindSet then
                                        repeat
                                            DetATS."10_SERVIC" += VE.Amount;
                                        until VE.Next = 0;
                                    DetATS.Insert;
                                end;
                            until SIH.Next = 0;
                            Window.Close;
                            SCMH.Reset;
                            SCMH.SetCurrentKey("Posting Date");
                            SCMH.SetRange("Posting Date", FechaDesde, FechaHasta);
                            SCMH.SetRange(Correction, true);
                            if SCMH.FindSet then begin
                                CounterTotal := SCMH.Count;
                                Window.Open(Text001);
                                repeat
                                    Counter := Counter + 1;
                                    Window.Update(1, SCMH."No.");
                                    Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                                    DetATS.Init;
                                    DetATS."Tipo Documento" := DetATS."Tipo Documento"::"Credit Memo";
                                    DetATS."No. Documento" := SCMH."No.";
                                    DetATS.Tipo := DetATS.Tipo::Venta;
                                    DetATS.Descripcion := SCMH."Posting Description";
                                    DetATS."Fecha Registro" := SCMH."Posting Date";
                                    DetATS."Numero Comprobante Fiscal" := SCMH."No. Comprobante Fiscal";
                                    SCMH.CalcFields(Amount);
                                    SCMH.CalcFields("Amount Including VAT");
                                    DetATS.Importe := SCMH.Amount;
                                    DetATS."Importe IVA" := SCMH."Amount Including VAT" - SCMH.Amount;
                                    DetATS."Importe IVA Incl." := SCMH."Amount Including VAT";
                                    DetATS."Source Type" := DetATS."Source Type"::Customer;
                                    DetATS."Source No." := SCMH."Bill-to Customer No.";
                                    DetATS."RUC/Cedula" := SCMH."VAT Registration No.";
                                    DetATS."No. Autorizacion Documento" := SCMH."No. Autorizacion Comprobante";
                                    DetATS."Punto Emision Documento" := SCMH."Punto de Emision Factura";
                                    DetATS."Establecimiento Documento" := SCMH."Establecimiento Factura";
                                    DetATS."Tipo Comprobante" := SCMH."Tipo de Comprobante";
                                    if SCMH."Fecha Caducidad Comprobante" = 0D then begin
                                        NoSeriesLine.Reset;
                                        NoSeriesLine.SetRange("Series Code", SCMH."No. Serie NCF Abonos");
                                        NoSeriesLine.SetFilter("Starting No.", '<=%1', SCMH."No. Comprobante Fiscal");
                                        NoSeriesLine.SetFilter("Ending No.", '>=%1', SCMH."No. Comprobante Fiscal");
                                        NoSeriesLine.SetRange(Establecimiento, SCMH."Establecimiento Factura");
                                        NoSeriesLine.SetRange("Punto de Emision", SCMH."Punto de Emision Factura");
                                        if NoSeriesLine.FindFirst then
                                            DetATS."Fecha Caducidad" := NoSeriesLine."Fecha Caducidad";
                                    end
                                    else
                                        DetATS."Fecha Caducidad" := SCMH."Fecha Caducidad Comprobante";

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                    VE.SetRange("Document No.", SCMH."No.");
                                    VE.SetRange("Posting Date", SCMH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '_EXENTO');
                                    if VE.FindSet then
                                        repeat
                                            DetATS._EXENTO += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                    VE.SetRange("Document No.", SCMH."No.");
                                    VE.SetRange("Posting Date", SCMH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '12% IVA');
                                    if VE.FindSet then
                                        repeat
                                            DetATS."12% IVA" += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                    VE.SetRange("Document No.", SCMH."No.");
                                    VE.SetRange("Posting Date", SCMH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '_GR_0');
                                    if VE.FindSet then
                                        repeat
                                            DetATS._GR_0 += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                    VE.SetRange("Document No.", SCMH."No.");
                                    VE.SetRange("Posting Date", SCMH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '_GR_12');
                                    if VE.FindSet then
                                        repeat
                                            DetATS._GR_12 += VE.Amount;
                                        until VE.Next = 0;

                                    VE.Reset;
                                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                    VE.SetRange("Document No.", SCMH."No.");
                                    VE.SetRange("Posting Date", SCMH."Posting Date");
                                    VE.SetRange(Type, VE.Type::Sale);
                                    VE.SetRange("VAT Prod. Posting Group", '10_SERVIC');
                                    if VE.FindSet then
                                        repeat
                                            DetATS."10_SERVIC" += VE.Amount;
                                        until VE.Next = 0;
                                    DetATS.Insert;
                                until SCMH.Next = 0;
                                Window.Close;
                            end;
                        end;
                        Commit;
                        DetalleATSPageVtas.RunModal;
                    end;

                end;
            }
        }
    }

    var
        FechaDesde: Date;
        FechaHasta: Date;
        PIH: Record "Purch. Inv. Header";
        HR: Record "Historico Retencion Prov.";
        VE: Record "VAT Entry";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        DetATS: Record "ATS Compras/Ventas";
        Vendor: Record Vendor;
        NoSeriesLine: Record "No. Series Line";
        MovCont: Record "G/L Entry";
        I: Integer;
        Error001: Label 'Debe indicar Fecha Desde y Fecha Hasta';
        DetalleATSPage: Page "Detalle Datos ATS";
        DetalleATSPageVtas: Page "Detalle Datos ATS Vtas.";
        TipoTrans: Option Compra,Venta;
        SIH: Record "Sales Invoice Header";
        Cust: Record Customer;
        SCMH: Record "Sales Cr.Memo Header";
        VLE: Record "Vendor Ledger Entry";
        VLE1: Record "Vendor Ledger Entry";
        PCMH: Record "Purch. Cr. Memo Hdr.";
        Corregida: Boolean;
        CLE: Record "Cust. Ledger Entry";
        CLE1: Record "Cust. Ledger Entry";
}

