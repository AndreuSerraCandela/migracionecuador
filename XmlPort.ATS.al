xmlport 55000 ATS
{

    schema
    {
        textelement(iva)
        {
            textelement(numeroRuc)
            {

                trigger OnBeforePassVariable()
                begin
                    numeroRuc := CompInf."VAT Registration No.";
                end;
            }
            textelement(razonSocial)
            {

                trigger OnBeforePassVariable()
                begin
                    razonSocial := CompInf.Name;
                end;
            }
            textelement(anio)
            {

                trigger OnBeforePassVariable()
                begin
                    anio := Format(A);
                end;
            }
            textelement(mes)
            {

                trigger OnBeforePassVariable()
                begin
                    if StrLen(Format(M)) = 1 then
                        mes := '0' + Format(M)
                    else
                        mes := Format(M)
                end;
            }
            textelement(compras)
            {
                tableelement("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    CalcFields = "Original Amt. (LCY)";
                    XmlName = 'detalleCompras';
                    SourceTableView = SORTING("Document Type", "Vendor No.", "Posting Date", "Currency Code") ORDER(Ascending) WHERE("Document Type" = FILTER(Invoice | "Credit Memo"));
                    textelement(codSustento)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            ConfSant.Get;
                            ConfSant.TestField("Grupo Reg. Iva Prod. Exento");

                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then begin
                                if PIH.Get("Vendor Ledger Entry"."Document No.") then begin
                                    codSustento := PIH."Sustento del Comprobante";
                                    PIH.CalcFields("Amount Including VAT");
                                    PIH.CalcFields(Amount);
                                end
                            end
                            else begin
                                if PCMH.Get("Vendor Ledger Entry"."Document No.") then begin
                                    codSustento := PCMH."Sustento del Comprobante";
                                    PCMH.CalcFields("Amount Including VAT");
                                    PCMH.CalcFields(Amount);
                                end;
                            end;
                        end;
                    }
                    textelement(tpIdProv)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            Vendor.Get("Vendor Ledger Entry"."Vendor No.");
                            if Vendor."Tipo Documento" = Vendor."Tipo Documento"::RUC then
                                tpIdProv := '01';
                            if Vendor."Tipo Documento" = Vendor."Tipo Documento"::Cedula then
                                tpIdProv := '02';
                            if Vendor."Tipo Documento" = Vendor."Tipo Documento"::Pasaporte then
                                tpIdProv := '03';
                        end;
                    }
                    textelement(idProv)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then
                                idProv := DelChr(PIH."VAT Registration No.", '=', '-')
                            else
                                idProv := DelChr(PCMH."VAT Registration No.", '=', '-')
                        end;
                    }
                    textelement(tipoComprobante)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then
                                tipoComprobante := PIH."Tipo de Comprobante"
                            else
                                tipoComprobante := PCMH."Tipo de Comprobante";
                        end;
                    }
                    textelement(fechaRegistro)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            fechaRegistro := FunSantEc.FechaXML("Vendor Ledger Entry"."Posting Date");
                        end;
                    }
                    textelement(establecimiento)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then begin
                                AutSRIProv.Reset;
                                AutSRIProv.SetRange("Cod. Proveedor", PIH."Buy-from Vendor No.");
                                AutSRIProv.SetRange("No. Autorizacion", PIH."No. Autorizacion Comprobante");
                                if AutSRIProv.FindFirst then;
                                establecimiento := AutSRIProv.Establecimiento;
                            end
                            else begin
                                AutSRIProv.Reset;
                                AutSRIProv.SetRange("Cod. Proveedor", PCMH."Buy-from Vendor No.");
                                AutSRIProv.SetRange("No. Autorizacion", PCMH."No. Autorizacion Comprobante");
                                if AutSRIProv.FindFirst then;
                                establecimiento := AutSRIProv.Establecimiento;
                            end;
                        end;
                    }
                    textelement(puntoEmision)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then
                                puntoEmision := AutSRIProv."Punto de Emision";
                            /*
                                END
                            ELSE
                              BEGIN
                                AutSRIProv.GET(PCMH."Buy-from Vendor No.",PCMH."No. Autorizacion Comprobante");
                                puntoEmision := AutSRIProv."Punto de Emision";
                              END;
                            */

                        end;
                    }
                    textelement(secuencial)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then
                                secuencial := PIH."No. Comprobante Fiscal"
                            else
                                secuencial := PCMH."No. Comprobante Fiscal";
                        end;
                    }
                    textelement(fechaemision_vle)
                    {
                        XmlName = 'fechaEmision';

                        trigger OnBeforePassVariable()
                        begin
                            fechaEmision_VLE := FunSantEc.FechaXML("Vendor Ledger Entry"."Document Date");
                        end;
                    }
                    textelement(autorizacion)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then begin
                                if PIH.Get("Vendor Ledger Entry"."Document No.") then
                                    autorizacion := PIH."No. Autorizacion Comprobante";
                            end
                            else begin
                                if PCMH.Get("Vendor Ledger Entry"."Document No.") then
                                    autorizacion := PCMH."No. Autorizacion Comprobante";
                            end;
                        end;
                    }
                    textelement(baseNoGraIva)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            baseNoGraIva_Dec := 0;
                            montoIva_Dec := 0;
                            baseNoGraIva := Format(0, 0, '<Precision,2:2><Standard format,2>');
                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                VE.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                                VE.SetRange(Type, VE.Type::Purchase);
                                VE.SetRange("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount = 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                end;
                            end
                            else begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                VE.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                                VE.SetRange(VE.Type, VE.Type::Purchase);
                                VE.SetRange("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount = 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                end;
                            end;

                            baseNoGraIva := Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,2>');
                        end;
                    }
                    textelement(baseImponible)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            baseNoGraIva_Dec := 0;
                            montoIva_Dec := 0;
                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                VE.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                                VE.SetRange(Type, VE.Type::Purchase);
                                VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount = 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImponible := Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>')
                                end;
                            end
                            else begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                VE.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                                VE.SetRange(VE.Type, VE.Type::Purchase);
                                VE.SetRange("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                                VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount = 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImponible := Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>')
                                end;
                            end;
                        end;
                    }
                    textelement(baseimpgrav_vle)
                    {
                        XmlName = 'baseImpGrav';

                        trigger OnBeforePassVariable()
                        begin
                            baseNoGraIva_Dec := 0;
                            montoIva_Dec := 0;
                            baseImpGrav_VLE := Format(0.0, 0, '<Precision,2:2><Standard format,0>');

                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                VE.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                                VE.SetRange(Type, VE.Type::Purchase);
                                VE.SetRange("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount <> 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImpGrav_VLE := Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>')
                                end;
                            end
                            else begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                VE.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                                VE.SetRange(VE.Type, VE.Type::Purchase);
                                VE.SetRange("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount <> 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImpGrav := Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>')
                                end
                            end;
                        end;
                    }
                    textelement(montoIce)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if montoIce = '' then
                                montoIce := Format(0.0, 0, '<Precision,2:2><Standard format,0>')
                            else
                                montoIce := Format(montoIce, 0, '<Precision,2:2><Standard format,0>')
                        end;
                    }
                    textelement(montoIva)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if montoIva_Dec = 0 then
                                montoIva := Format(0.0, 0, '<Precision,2:2><Standard format,0>')
                            else
                                montoIva := Format(montoIva_Dec, 0, '<Precision,2:2><Standard format,0>');
                        end;
                    }
                    textelement(valorRetBienes)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if valorRetBienes = '' then
                                valorRetBienes := Format(0.0, 0, '<Precision,2:2><Standard format,0>')
                            else
                                valorRetBienes := Format(valorRetBienes, 0, '<Precision,2:2><Standard format,0>')
                        end;
                    }
                    textelement(valorRetServicios)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if valorRetServicios = '' then
                                valorRetServicios := Format(0.0, 0, '<Precision,2:2><Standard format,0>')
                            else
                                valorRetServicios := Format(valorRetServicios, 0, '<Precision,2:2><Standard format,0>')
                        end;
                    }
                    textelement(valRetServ100)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if valRetServ100 = '' then
                                valRetServ100 := Format(0.0, 0, '<Precision,2:2><Standard format,0>')
                            else
                                valRetServ100 := Format(valRetServ100, 0, '<Precision,2:2><Standard format,0>')
                        end;
                    }
                    textelement(air)
                    {
                        textelement(detalleAir)
                        {
                            textelement(codRetAir)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then begin
                                        if PIH.Get("Vendor Ledger Entry"."Document No.") then begin
                                            HistRet.Reset;
                                            HistRet.SetRange("No. documento", PIH."No.");
                                            HistRet.SetRange("Cód. Proveedor", PIH."Buy-from Vendor No.");
                                            HistRet.SetRange("Fecha Registro", PIH."Posting Date");
                                            if HistRet.FindFirst then
                                                codRetAir := HistRet."Código Retención";
                                        end;
                                    end
                                    else begin
                                        if PCMH.Get("Vendor Ledger Entry"."Document No.") then begin
                                            HistRet.Reset;
                                            HistRet.SetRange("No. documento", PCMH."No.");
                                            HistRet.SetRange("Cód. Proveedor", PCMH."Buy-from Vendor No.");
                                            HistRet.SetRange("Fecha Registro", PCMH."Posting Date");
                                            if HistRet.FindFirst then
                                                codRetAir := HistRet."Código Retención";
                                        end;
                                    end;
                                end;
                            }
                            textelement(baseImpAir)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    "Vendor Ledger Entry".CalcFields("Original Amt. (LCY)");
                                    if "Vendor Ledger Entry"."Original Amt. (LCY)" = 0 then
                                        baseImpAir := Format(0.0, 0, '<Precision,2:2><Standard format,0>')
                                    else
                                        baseImpAir := Format(Abs("Vendor Ledger Entry"."Original Amt. (LCY)"), 0, '<Precision,2:2><Standard format,0>');
                                end;
                            }
                            textelement(porcentajeAir)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    porcentajeAir := Format(0.0, 0, '<Precision,2:2><Standard format,0>');
                                    porcentajeAir := Format(HistRet."Importe Retención", 0, '<Precision,2:2><Standard format,0>');
                                    valRetAir := Format(HistRet."Importe Retenido", 0, '<Precision,2:2><Standard format,0>');
                                end;
                            }
                            textelement(valRetAir)
                            {
                            }
                        }
                    }
                    textelement(estabRetencion1)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            estabRetencion1 := HistRet.Establecimiento;
                            ptoEmiRetencion1 := HistRet."Punto Emision";
                        end;
                    }
                    textelement(ptoEmiRetencion1)
                    {
                    }
                    textelement(secRetencion1)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            secRetencion1 := HistRet.NCF;
                        end;
                    }
                    textelement(autRetencion1)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            autRetencion1 := HistRet."No. autorizacion NCF";
                        end;
                    }
                    textelement(fechaEmiRet1)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            fechaEmiRet1 := FunSantEc.FechaXML(HistRet."Fecha Impresion");
                        end;
                    }
                    textelement(docModificado)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            docModificado := '0';
                            estabModificado := '000';
                            ptoEmiModificado := '000';
                            secModificado := '0';
                            autModificado := '0000';

                            if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::"Credit Memo" then begin
                                if PCMH.Get("Vendor Ledger Entry"."Document No.") then begin
                                    if (PCMH."No. Autorizacion Fact. Rel." <> '') and (PCMH."Punto de Emision Fact. Rel." <> '') and
                                      (PCMH."Establecimiento Fact. Rel" <> '') and (PCMH."Tipo de Comprobante Fact. Rel." <> '') then begin
                                        docModificado := PCMH."Tipo de Comprobante Fact. Rel.";
                                    end
                                    else
                                      //en caso de que la nota de credito no tenga lleno el dato lo buscamos de la factura liquidada.
                                      begin
                                        if "Vendor Ledger Entry"."Closed by Entry No." <> 0 then begin
                                            VLE.Get("Vendor Ledger Entry"."Closed by Entry No.");
                                            if VLE."Document Type" = VLE."Document Type"::Invoice then begin
                                                PIH.Get(VLE."Document No.");
                                                docModificado := PIH."Tipo de Comprobante Fact. Rel.";
                                                estabModificado := PIH."Establecimiento Fact. Rel";
                                                ptoEmiModificado := PIH."Punto de Emision Fact. Rel.";
                                                secModificado := PIH."No. Comprobante Fiscal Rel.";
                                                autModificado := PIH."No. Autorizacion Fact. Rel.";
                                            end
                                        end
                                        else begin
                                            VLE.Reset;
                                            VLE.SetCurrentKey("Closed by Entry No.");
                                            VLE.SetRange("Closed by Entry No.", "Vendor Ledger Entry"."Entry No.");
                                            VLE.SetRange(VLE."Document Type", VLE."Document Type"::Invoice);
                                            if VLE.FindFirst then begin
                                                PIH.Get(VLE."Document No.");
                                                docModificado := PIH."Tipo de Comprobante Fact. Rel.";
                                                estabModificado := PIH."Establecimiento Fact. Rel";
                                                ptoEmiModificado := PIH."Punto de Emision Fact. Rel.";
                                                secModificado := PIH."No. Comprobante Fiscal Rel.";
                                                autModificado := PIH."No. Autorizacion Fact. Rel.";
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    }
                    textelement(estabModificado)
                    {
                    }
                    textelement(ptoEmiModificado)
                    {
                    }
                    textelement(secModificado)
                    {
                    }
                    textelement(autModificado)
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Vendor Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "Cust. Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
                        Exportaciones_Exp.SetRange("Posting Date", FechaInicial, FechaFinal);
                    end;

                    trigger OnAfterInitRecord()
                    begin
                        ConfSant.Get;
                        ConfSant.TestField("Grupo Reg. Iva Prod. Exento");

                        if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then begin
                            if PIH.Get("Vendor Ledger Entry"."Document No.") then begin
                                codSustento := PIH."Sustento del Comprobante";
                                PIH.CalcFields("Amount Including VAT");
                                PIH.CalcFields(Amount);
                            end
                        end
                        else begin
                            if PCMH.Get("Vendor Ledger Entry"."Document No.") then begin
                                codSustento := PCMH."Sustento del Comprobante";
                                PCMH.CalcFields("Amount Including VAT");
                                PCMH.CalcFields(Amount);
                            end;
                        end;
                    end;
                }
            }
            textelement(ventas)
            {
                tableelement("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    XmlName = 'detalleVentas';
                    SourceTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code") ORDER(Ascending) WHERE("Document Type" = FILTER(Invoice | "Credit Memo"));
                    textelement(tpIdCliente)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice then begin
                                if SIH.Get("Cust. Ledger Entry"."Document No.") then;
                            end
                            else
                                if SCMH.Get("Cust. Ledger Entry"."Document No.") then;

                            Customer.Get("Cust. Ledger Entry"."Customer No.");
                            if Customer."Tipo Documento" = Customer."Tipo Documento"::RUC then
                                tpIdCliente := '04';
                            if Customer."Tipo Documento" = Customer."Tipo Documento"::Cedula then
                                tpIdCliente := '05';
                            if Customer."Tipo Documento" = Customer."Tipo Documento"::Pasaporte then
                                tpIdCliente := '06';

                            //TPV
                            /*   if SIH."Venta TPV" = SIH."Venta TPV"::"1" then
                                  if SIH."Tipo Ruc/Cedula" = SIH."Tipo Ruc/Cedula"::" " then
                                      tpIdCliente := '07'; */
                            //TPV
                        end;
                    }
                    textelement(idCliente)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice then
                                idCliente := DelChr(SIH."VAT Registration No.", '=', '-')
                            else
                                idCliente := DelChr(SCMH."VAT Registration No.", '=', '-')
                        end;
                    }
                    textelement(tipocomprobante_vta)
                    {
                        XmlName = 'tipoComprobante';

                        trigger OnBeforePassVariable()
                        begin
                            if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice then
                                tipoComprobante_Vta := SIH."Tipo de Comprobante"
                            else
                                tipoComprobante_Vta := SCMH."Tipo de Comprobante"
                        end;
                    }
                    textelement(numeroComprobantes)
                    {

                        trigger OnBeforePassVariable()
                        begin

                            I := 0;
                            if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice then begin
                                SIH.Reset;
                                SIH.SetCurrentKey("Posting Date", "VAT Registration No.");
                                SIH.SetRange("Posting Date", FechaInicial, FechaFinal);
                                SIH.SetRange("VAT Registration No.", idCliente);
                                if SIH.FindSet then
                                    repeat
                                        I += 1;
                                    until (SIH.Next = 0) or (SIH."No." = "Cust. Ledger Entry"."Document No.");
                                numeroComprobantes := Format(I);
                            end;

                            if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::"Credit Memo" then begin
                                SCMH.Reset;
                                SCMH.SetCurrentKey("Posting Date", "VAT Registration No.");
                                SCMH.SetRange("Posting Date", FechaInicial, FechaFinal);
                                SCMH.SetRange("VAT Registration No.", idCliente);
                                if SCMH.FindSet then
                                    repeat
                                        I += 1;
                                    until (SCMH.Next = 0) or (SCMH."No." = "Cust. Ledger Entry"."Document No.");
                                numeroComprobantes := Format(I);
                            end;

                            /*
                            IF "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice THEN
                              BEGIN
                                SIH.RESET;
                                SIH.SETCURRENTKEY("Posting Date","VAT Registration No.");
                                SIH.SETRANGE("Posting Date",FechaInicial,FechaFinal);
                                SIH.SETRANGE("VAT Registration No.",idCliente);
                                SIH.SETRANGE("No.","Cust. Ledger Entry"."Document No.");
                                IF SIH.FINDFIRST THEN
                                  BEGIN
                                    DocPorCliente.INIT;
                                    DocPorCliente."ID Cliente"    := idCliente;
                                    DocPorCliente."No. Documento" := SIH."No.";
                                    DocPorCliente.INSERT;
                                  END
                              END;
                            
                            IF "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::"Credit Memo" THEN
                              BEGIN
                                SCMH.RESET;
                                SCMH.SETCURRENTKEY("Posting Date","VAT Registration No.");
                                SCMH.SETRANGE("Posting Date",FechaInicial,FechaFinal);
                                SCMH.SETRANGE("VAT Registration No.",idCliente);
                                SCMH.SETRANGE("No.","Cust. Ledger Entry"."Document No.");
                                IF SCMH.FINDFIRST THEN
                                  BEGIN
                                    DocPorCliente.INIT;
                                    DocPorCliente."ID Cliente"    := idCliente;
                                    DocPorCliente."No. Documento" := SCMH."No.";
                                    DocPorCliente.INSERT;
                                  END
                              END;
                            
                            DocPorCliente.RESET;
                            DocPorCliente.SETRANGE("ID Cliente",idCliente);
                            numeroComprobantes := FORMAT(DocPorCliente.COUNT);
                            */

                        end;
                    }
                    textelement(basenograiva_vta)
                    {
                        XmlName = 'baseNoGraIva';

                        trigger OnBeforePassVariable()
                        begin
                            baseNoGraIva_Vta := Format(0.0, 0, '<Precision,2:2><Standard format,0>');
                            montoIva_Dec := 0;
                            baseNoGraIva_Dec := 0;

                            if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice then begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Cust. Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                VE.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
                                VE.SetRange(Type, VE.Type::Sale);
                                VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount = 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseNoGraIva_Vta := Format(Abs(baseNoGraIva_Dec), 0, '<Precision,2:2><Standard format,0>')
                                end;
                            end
                            else begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Cust. Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                VE.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
                                VE.SetRange(VE.Type, VE.Type::Sale);
                                VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount = 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseNoGraIva_Vta := Format(Abs(baseNoGraIva_Dec), 0, '<Precision,2:2><Standard format,0>')
                                end;
                            end;
                        end;
                    }
                    textelement(baseimponible_vta)
                    {
                        XmlName = 'baseImponible';

                        trigger OnBeforePassVariable()
                        begin
                            baseImponible_Vta := Format(0.0, 0, '<Precision,2:2><Standard format,0>');
                            baseNoGraIva_Dec := 0;
                            montoIva_Dec := 0;
                            if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice then begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Cust. Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                VE.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
                                VE.SetRange(Type, VE.Type::Sale);
                                VE.SetFilter("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount = 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImponible_Vta := Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>')
                                end;
                            end
                            else begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Cust. Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                VE.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
                                VE.SetRange(VE.Type, VE.Type::Sale);
                                VE.SetFilter("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount = 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImponible_Vta := Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>')
                                end;
                            end;
                        end;
                    }
                    textelement(baseImpGrav)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            baseImpGrav := Format(0.0, 0, '<Precision,2:2><Standard format,0>');
                            baseNoGraIva_Dec := 0;
                            montoIva_Dec := 0;
                            if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice then begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Cust. Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                                VE.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
                                VE.SetRange(Type, VE.Type::Sale);
                                VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount <> 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImpGrav := Format(Abs(baseNoGraIva_Dec), 0, '<Precision,2:2><Standard format,0>')
                                end;
                            end
                            else begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Cust. Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                VE.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
                                VE.SetRange(VE.Type, VE.Type::Sale);
                                VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount <> 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImpGrav := Format(Abs(baseNoGraIva_Dec), 0, '<Precision,2:2><Standard format,0>')
                                end;
                            end;
                        end;
                    }
                    textelement(montoiva_vta)
                    {
                        XmlName = 'montoIva';

                        trigger OnBeforePassVariable()
                        begin
                            if montoIva_Dec = 0 then
                                montoIva_Vta := Format(0.0, 0, '<Precision,2:2><Standard format,0>')
                            else
                                montoIva_Vta := Format(montoIva_Dec, 0, '<Precision,2:2><Standard format,0>');
                        end;
                    }
                    textelement(valorRetIva)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            valorRetIva := Format(0.0, 0, '<Precision,2:2><Standard format,0>');
                        end;
                    }
                    textelement(valorRetRenta)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            valorRetRenta := Format(0.0, 0, '<Precision,2:2><Standard format,0>');
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Vendor Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "Cust. Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
                        Exportaciones_Exp.SetRange("Posting Date", FechaInicial, FechaFinal);
                    end;

                    trigger OnBeforeInsertRecord()
                    begin
                        "Vendor Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "Cust. Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
                        Exportaciones_Exp.SetRange("Posting Date", FechaInicial, FechaFinal);
                    end;
                }
            }
            textelement(anulados)
            {
                tableelement("NCF Anulados"; "NCF Anulados")
                {
                    XmlName = 'detalleAnulados';
                    SourceTableView = SORTING("No. documento", "No. Comprobante Fiscal") ORDER(Ascending) WHERE("Tipo Documento" = FILTER(Invoice | "Credit Memo"));
                    textelement(tipocomprobante_anul)
                    {
                        XmlName = 'tipoComprobante';

                        trigger OnBeforePassVariable()
                        begin
                            if "NCF Anulados"."Tipo Documento" = "NCF Anulados"."Tipo Documento"::Invoice then begin
                                if SIH.Get("NCF Anulados"."No. documento") then
                                    tipoComprobante := SIH."Tipo de Comprobante";
                            end
                            else begin
                                if SCMH.Get("NCF Anulados"."No. documento") then
                                    tipoComprobante := SCMH."Tipo de Comprobante";
                            end;
                        end;
                    }
                    textelement(establecimiento_anul)
                    {
                        XmlName = 'establecimiento';

                        trigger OnBeforePassVariable()
                        begin
                            if "NCF Anulados"."Tipo Documento" = "NCF Anulados"."Tipo Documento"::Invoice then begin
                                NoSeriesLine.Reset;
                                NoSeriesLine.SetCurrentKey("No. Autorizacion");
                                NoSeriesLine.SetRange("No. Autorizacion", SIH."No. Autorizacion Comprobante");
                                establecimiento_Anul := NoSeriesLine."No. Autorizacion";
                            end
                            else begin
                                NoSeriesLine.Reset;
                                NoSeriesLine.SetCurrentKey("No. Autorizacion");
                                NoSeriesLine.SetRange("No. Autorizacion", SCMH."No. Autorizacion Comprobante");
                                establecimiento_Anul := NoSeriesLine."No. Autorizacion";
                            end;
                        end;
                    }
                    textelement(puntoemision_anul)
                    {
                        XmlName = 'puntoEmision';

                        trigger OnBeforePassVariable()
                        begin
                            puntoEmision_Anul := NoSeriesLine."Punto de Emision";
                        end;
                    }
                    textelement(secuencialInicio)
                    {
                    }
                    textelement(secuencialFin)
                    {
                    }
                    textelement(autorizacion_anul)
                    {
                        XmlName = 'autorizacion';

                        trigger OnBeforePassVariable()
                        begin
                            autorizacion_Anul := NoSeriesLine."No. Autorizacion";
                        end;
                    }
                }
            }
            textelement(exportaciones)
            {
                tableelement(exportaciones_exp; "Cust. Ledger Entry")
                {
                    XmlName = 'detalleExportaciones';
                    SourceTableView = SORTING("Entry No.") ORDER(Ascending) WHERE("Entry No." = FILTER(> 999999999));
                    textelement(exportacionDe)
                    {
                    }
                    textelement(tipocomprobante_exp)
                    {
                        XmlName = 'tipoComprobante';
                    }
                    textelement(distAduanero)
                    {
                    }
                    textelement(anio_exp)
                    {
                        XmlName = 'anio';
                    }
                    textelement(regimen)
                    {
                    }
                    textelement(correlativo)
                    {
                    }
                    textelement(verificador)
                    {
                    }
                    textelement(docTransp)
                    {
                    }
                    textelement(fechaEmbarque)
                    {
                    }
                    textelement(fue)
                    {
                    }
                    textelement(valorFOB)
                    {
                    }
                    textelement(valorFOBComprobante)
                    {
                    }
                    textelement(establecimiento_exp)
                    {
                        XmlName = 'establecimiento';
                    }
                    textelement(puntoemision_exp)
                    {
                        XmlName = 'puntoEmision';
                    }
                    textelement(secuencial_exp)
                    {
                        XmlName = 'secuencial';
                    }
                    textelement(autorizacion_exp)
                    {
                        XmlName = 'autorizacion';
                    }
                    textelement(fechaEmision)
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Vendor Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "Cust. Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
                        Exportaciones_Exp.SetRange("Posting Date", FechaInicial, FechaFinal);
                    end;
                }
            }
            textelement(recap)
            {
                textelement(detallerecap)
                {
                    textelement(establecimientoRecap)
                    {
                    }
                    textelement(identificacionRecap)
                    {
                    }
                    textelement(tipocomprobante_recap)
                    {
                        XmlName = 'tipoComprobante';
                    }
                    textelement(numeroRecap)
                    {
                    }
                    textelement(fechaPago)
                    {
                    }
                    textelement(tarjetaCredito)
                    {
                    }
                    textelement(fechaEmisionRecap)
                    {
                    }
                    textelement(consumoCero)
                    {
                    }
                    textelement(consumoGravado)
                    {
                    }
                    textelement(totalConsumo)
                    {
                    }
                    textelement(montoiva_recap)
                    {
                        XmlName = 'montoIva';
                    }
                    textelement(comision)
                    {
                    }
                    textelement(numeroVouchers)
                    {
                    }
                    textelement(valorretbienes_recap)
                    {
                        XmlName = 'valorRetBienes';
                    }
                    textelement(valorretservicios_recap)
                    {
                        XmlName = 'valorRetServicios';
                    }
                    textelement(valretserv100_recap)
                    {
                        XmlName = 'valRetServ100';
                        textelement(air_recap)
                        {
                            XmlName = 'air';
                            textelement(codretair_recap)
                            {
                                XmlName = 'codRetAir';
                            }
                            textelement(baseimpair_recap)
                            {
                                XmlName = 'baseImpAir';
                            }
                            textelement(porcentajeair_recap)
                            {
                                XmlName = 'porcentajeAir';
                            }
                            textelement(valretair_recap)
                            {
                                XmlName = 'valRetAir';
                            }
                        }
                        textelement(establecimiento_recap)
                        {
                            XmlName = 'establecimiento';
                        }
                        textelement(puntoemision_recap)
                        {
                            XmlName = 'puntoEmision';
                        }
                        textelement(secuencial_recap)
                        {
                            XmlName = 'secuencial';
                        }
                        textelement(autorizacion_recap)
                        {
                            XmlName = 'autorizacion';
                        }
                        textelement(fechaemision_recap)
                        {
                            XmlName = 'fechaEmision';
                        }
                    }
                }
            }
            textelement(fideicomisos)
            {
                textelement(detallefideicomisos)
                {
                    textelement(tipoBeneficiario)
                    {
                    }
                    textelement(idBeneficiario)
                    {
                    }
                    textelement(rucFideicomiso)
                    {
                    }
                    textelement(fValor)
                    {
                        textelement(detallefValor)
                        {
                            textelement(tipoFideicomiso)
                            {
                            }
                            textelement(totalF)
                            {
                            }
                            textelement(individualF)
                            {
                            }
                            textelement(porRetF)
                            {
                            }
                            textelement(valorRetF)
                            {
                            }
                        }
                    }
                }
            }
            textelement(rendFinancieros)
            {
                textelement(detalleredFinancieros)
                {
                    textelement(retenido)
                    {
                    }
                    textelement(idRetenido)
                    {
                    }
                    textelement(ahorroPN)
                    {
                        textelement(totalDep)
                        {
                        }
                        textelement(rendGen)
                        {
                        }
                    }
                    textelement(ctaExenta)
                    {
                        textelement(totaldep_1)
                        {
                            XmlName = 'totalDep';
                        }
                        textelement(rendgen_1)
                        {
                            XmlName = 'rendGen';
                        }
                    }
                    textelement(retenciones)
                    {
                        textelement(detRet)
                        {
                            textelement(estabRetencion)
                            {
                            }
                            textelement(ptoEmiRetencion)
                            {
                            }
                            textelement(secRetencion)
                            {
                            }
                            textelement(autRetencion)
                            {
                            }
                            textelement(fechaEmiRet)
                            {
                            }
                            textelement(airRend)
                            {
                                textelement(detalleAirRend)
                                {
                                    textelement(codretair_rendfin)
                                    {
                                        XmlName = 'codRetAir';
                                    }
                                    textelement(deposito)
                                    {
                                    }
                                    textelement(baseimpair_rendfin)
                                    {
                                        XmlName = 'baseImpAir';
                                    }
                                    textelement(porcentajeair_rendfin)
                                    {
                                        XmlName = 'porcentajeAir';
                                    }
                                    textelement(valretair_rendfin)
                                    {
                                        XmlName = 'valRetAir';
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Año"; A)
                {
                ApplicationArea = All;
                    Caption = 'Year';

                    trigger OnValidate()
                    begin
                        /*
                        AnoActual := DATE2DMY(WORKDATE,3);
                        IF STRLEN(FORMAT(A)) <> 4 THEN
                          ERROR(Error001,FORMAT(AnoActual));
                        */

                    end;
                }
                field(Mes; M)
                {
                ApplicationArea = All;
                    Caption = 'Month';

                    trigger OnValidate()
                    begin
                        /*
                        AnoActual := DATE2DMY(WORKDATE,3);
                        MesActual := DATE2DMY(WORKDATE,2);
                        IF AnoActual = A THEN
                          BEGIN
                            IF STRLEN(FORMAT(M)) > 2 THEN
                              ERROR(Error003);
                        
                            IF M > MesActual THEN
                              ERROR(Error002);
                          END;
                        */

                    end;
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        CompInf.Get;
        CompInf.TestField("VAT Registration No.");
    end;

    trigger OnPreXmlPort()
    begin
        DocPorCliente.DeleteAll;

        AnoActual := Date2DMY(WorkDate, 3);
        if StrLen(Format(A)) <> 4 then
            Error(Error001, Format(AnoActual));

        AnoActual := Date2DMY(WorkDate, 3);
        MesActual := Date2DMY(WorkDate, 2);

        if AnoActual = A then begin
            if StrLen(Format(M)) > 2 then
                Error(Error003);

            if M > MesActual then
                Error(Error002);
        end;

        FechaInicial := DMY2Date(1, M, A);

        Fecha.Reset;
        Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
        Fecha.SetRange("Period Start", DMY2Date(1, M, A));
        Fecha.FindFirst;
        FechaFinal := Fecha."Period End";

        //Para evitar tomar los datos del balance inicial
        if FechaInicial = 20130101D then
            FechaInicial := 20130102D;
        //Para evitar tomar los datos del balance inicial

        //PARA PRUEBAS
        FechaInicial := 20130302D;
        FechaFinal := 20130304D;

        "Vendor Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
        "Cust. Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
        Exportaciones_Exp.SetRange("Posting Date", FechaInicial, FechaFinal);
    end;

    var
        CompInf: Record "Company Information";
        A: Integer;
        M: Integer;
        txtA: Text[30];
        Error001: Label 'Year must be equal to 4 digits, greater than 2001 and not greater than %1';
        AnoActual: Integer;
        MesActual: Integer;
        Error002: Label 'Month cannot be greater that the current';
        Error003: Label 'Month must be equal to 2 digits';
        Fecha: Record Date;
        FechaInicial: Date;
        FechaFinal: Date;
        Vendor: Record Vendor;
        AutSRIProv: Record "Autorizaciones SRI Proveedores";
        Longitud: Integer;
        UltimosSiete: Integer;
        VE: Record "VAT Entry";
        baseNoGraIva_Dec: Decimal;
        montoIva_Dec: Decimal;
        RetDocReg: Record "Retencion Doc. Reg. Prov.";
        NoSeriesLine: Record "No. Series Line";
        PIH: Record "Purch. Inv. Header";
        PCMH: Record "Purch. Cr. Memo Hdr.";
        SIH: Record "Sales Invoice Header";
        SCMH: Record "Sales Cr.Memo Header";
        Customer: Record Customer;
        ConfSant: Record "Config. Empresa";
        dia_: Text[2];
        mes_: Text[2];
        anio_: Text[4];
        Fecha_: Date;
        FunSantEc: Codeunit "Funciones Ecuador";
        HistRet: Record "Historico Retencion Prov.";
        VLE: Record "Vendor Ledger Entry";
        I: Integer;
        DocPorCliente: Record "Documentos por Cliente ATS";


    procedure FechaString(Fecha: Date): Text[30]
    var
        dia: Text[2];
        mes: Text[2];
        anio: Text[3];
    begin
        dia_ := Format(Date2DMY(Fecha_, 1));
        if StrLen(dia_) = 1 then
            dia_ := '0' + dia_;
        mes_ := Format(Date2DMY(Fecha_, 2));
        if StrLen(mes_) = 1 then
            mes_ := '0' + mes_;
        anio_ := Format(Date2DMY(Fecha_, 3));
        exit(dia_ + '/' + mes_ + '/' + anio_);
    end;
}

