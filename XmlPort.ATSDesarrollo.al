xmlport 55008 ATS_Desarrollo
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

                            if secuencial = '' then
                                secuencial := '00';
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
                                VE.SetFilter("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
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
                                VE.SetFilter("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount = 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                end;
                            end;

                            baseNoGraIva := DelChr(Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,2>'), '=', ',');
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
                                    baseImponible := DelChr(Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>'), '=', ',')
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
                                    baseImponible := DelChr(Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>'), '=', ',');
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
                                VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount <> 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImpGrav_VLE := DelChr(Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>'), '=', ',')
                                end;
                            end
                            else begin
                                VE.Reset;
                                VE.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                                VE.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                                VE.SetRange(VE.Type, VE.Type::Purchase);
                                VE.SetFilter("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                                if VE.FindSet then begin
                                    repeat
                                        if VE.Amount <> 0 then
                                            baseNoGraIva_Dec += VE.Base;
                                        montoIva_Dec += VE.Amount;
                                    until VE.Next = 0;
                                    baseImpGrav := DelChr(Format(baseNoGraIva_Dec, 0, '<Precision,2:2><Standard format,0>'), '=', ',');
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
                                montoIva := DelChr(Format(montoIva_Dec, 0, '<Precision,2:2><Standard format,0>'), '=', ',');
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
                        tableelement("Historico Retencion Prov."; "Historico Retencion Prov.")
                        {
                            MinOccurs = Zero;
                            XmlName = 'detalleAir';
                            textelement(codRetAir)
                            {
                                MinOccurs = Zero;

                                trigger OnBeforePassVariable()
                                begin
                                    codRetAir := "Historico Retencion Prov."."Código Retención";
                                    /*
                                    IF "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice THEN
                                      BEGIN
                                        IF PIH.GET("Vendor Ledger Entry"."Document No.") THEN
                                          BEGIN
                                            HistRet.RESET;
                                            HistRet.SETRANGE("No. documento",PIH."No.");
                                            HistRet.SETRANGE("Cód. Proveedor",PIH."Buy-from Vendor No.");
                                            HistRet.SETRANGE("Fecha Registro",PIH."Posting Date");
                                            IF HistRet.FINDFIRST THEN
                                              codRetAir := HistRet."Código Retención";
                                          END;
                                      END
                                    ELSE
                                      BEGIN
                                        IF PCMH.GET("Vendor Ledger Entry"."Document No.") THEN
                                          BEGIN
                                            HistRet.RESET;
                                            HistRet.SETRANGE("No. documento",PCMH."No.");
                                            HistRet.SETRANGE("Cód. Proveedor",PCMH."Buy-from Vendor No.");
                                            HistRet.SETRANGE("Fecha Registro",PCMH."Posting Date");
                                            IF HistRet.FINDFIRST THEN
                                              codRetAir := HistRet."Código Retención";
                                          END;
                                      END;
                                    */

                                end;
                            }
                            textelement(baseImpAir)
                            {
                                MinOccurs = Zero;

                                trigger OnBeforePassVariable()
                                begin
                                    /*"Vendor Ledger Entry".CALCFIELDS("Original Amt. (LCY)");
                                    IF "Vendor Ledger Entry"."Original Amt. (LCY)" = 0 THEN
                                      baseImpAir := FORMAT(0.0,0,'<Precision,2:2><Standard format,0>')
                                    ELSE
                                      baseImpAir := FORMAT(ABS("Vendor Ledger Entry"."Original Amt. (LCY)"),0,'<Precision,2:2><Standard format,0>');
                                    */
                                    baseImpAir := DelChr(Format(Abs("Historico Retencion Prov."."Importe Base Retencion"), 0, '<Precision,2:2><Standard format,0>')
                                              , '=', ',');

                                end;
                            }
                            textelement(porcentajeAir)
                            {
                                MinOccurs = Zero;

                                trigger OnBeforePassVariable()
                                begin
                                    porcentajeAir := Format(0.0, 0, '<Precision,2:2><Standard format,0>');
                                    porcentajeAir := Format("Historico Retencion Prov."."Importe Retención", 0, '<Precision,2:2><Standard format,0>');
                                    valRetAir := DelChr(Format("Historico Retencion Prov."."Importe Retenido", 0, '<Precision,2:2><Standard format,0>'), '=', ',');
                                end;
                            }
                            textelement(valRetAir)
                            {
                                MinOccurs = Zero;
                            }

                            trigger OnPreXmlItem()
                            begin
                                "Historico Retencion Prov.".SetRange("Tipo documento", "Historico Retencion Prov."."Tipo documento"::Invoice);
                                "Historico Retencion Prov.".SetRange("No. documento", "Vendor Ledger Entry"."Document No.");
                                "Historico Retencion Prov.".SetRange("Cód. Proveedor", "Vendor Ledger Entry"."Vendor No.");
                                "Historico Retencion Prov.".SetRange("Retencion IVA", false);
                            end;
                        }
                    }
                    textelement(estabRetencion1)
                    {

                        trigger OnBeforePassVariable()
                        begin

                            if "Historico Retencion Prov.".Establecimiento <> '' then
                                estabRetencion1 := "Historico Retencion Prov.".Establecimiento
                            else
                                estabRetencion1 := '000';

                            if "Historico Retencion Prov."."Punto Emision" <> '' then
                                ptoEmiRetencion1 := "Historico Retencion Prov."."Punto Emision"
                            else
                                ptoEmiRetencion1 := '000';
                        end;
                    }
                    textelement(ptoEmiRetencion1)
                    {
                    }
                    textelement(secRetencion1)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Historico Retencion Prov.".NCF <> '' then
                                secRetencion1 := "Historico Retencion Prov.".NCF
                            else
                                secRetencion1 := '0';
                        end;
                    }
                    textelement(autRetencion1)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Historico Retencion Prov."."No. autorizacion NCF" <> '' then
                                autRetencion1 := "Historico Retencion Prov."."No. autorizacion NCF"
                            else
                                autRetencion1 := '0000';
                        end;
                    }
                    textelement(fechaEmiRet1)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "Historico Retencion Prov."."Fecha Impresion" <> 0D then
                                fechaEmiRet1 := FunSantEc.FechaXML("Historico Retencion Prov."."Fecha Impresion")
                            else
                                fechaEmiRet1 := '00/00/0000';
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

                    trigger OnAfterGetRecord()
                    begin
                        ConfSant.Get;
                        ConfSant.TestField("Grupo Reg. Iva Prod. Exento");

                        if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then begin
                            if PIH.Get("Vendor Ledger Entry"."Document No.") then begin
                                codSustento := PIH."Sustento del Comprobante";
                                PIH.CalcFields("Amount Including VAT");
                                PIH.CalcFields(Amount);
                                VendPostGp.Get(PIH."Vendor Posting Group");
                                if (VendPostGp."NCF Obligatorio" = false) and
                                  (VendPostGp."Permite Emitir NCF" = false) then
                                    currXMLport.Skip;
                            end
                        end
                        else begin
                            if PCMH.Get("Vendor Ledger Entry"."Document No.") then begin
                                codSustento := PCMH."Sustento del Comprobante";
                                PCMH.CalcFields("Amount Including VAT");
                                PCMH.CalcFields(Amount);
                                VendPostGp.Get(PCMH."Vendor Posting Group");
                                if (VendPostGp."NCF Obligatorio" = false) and
                                  (VendPostGp."Permite Emitir NCF" = false) then
                                    currXMLport.Skip;

                            end;
                        end;
                    end;

                    trigger OnPreXmlItem()
                    begin
                        "Vendor Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
                    end;

                    trigger OnAfterInitRecord()
                    begin
                        /*
                        ConfSant.GET;
                        ConfSant.TESTFIELD("Grupo Reg. Iva Prod. Exento");
                        
                        IF "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice THEN
                          BEGIN
                            IF PIH.GET("Vendor Ledger Entry"."Document No.") THEN
                              BEGIN
                                codSustento := PIH."Sustento del Comprobante";
                                PIH.CALCFIELDS("Amount Including VAT");
                                PIH.CALCFIELDS(Amount);
                              END
                          END
                        ELSE
                          BEGIN
                            IF PCMH.GET("Vendor Ledger Entry"."Document No.") THEN
                              BEGIN
                                codSustento := PCMH."Sustento del Comprobante";
                                PCMH.CALCFIELDS("Amount Including VAT");
                                PCMH.CALCFIELDS(Amount);
                              END;
                          END;
                        */

                    end;
                }
            }
            textelement(ventas)
            {
                tableelement("Documentos por Cliente ATS"; "Documentos por Cliente ATS")
                {
                    XmlName = 'detalleVentas';
                    SourceTableView = SORTING("Tipo ID Cliente", "ID Cliente", TipoComprobante) ORDER(Ascending);
                    textelement(tpIdCliente)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            tpIdCliente := "Documentos por Cliente ATS"."Tipo ID Cliente";
                        end;
                    }
                    textelement(idCliente)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            idCliente := "Documentos por Cliente ATS"."ID Cliente";
                        end;
                    }
                    textelement(tipocomprobante_vta)
                    {
                        XmlName = 'tipoComprobante';

                        trigger OnBeforePassVariable()
                        begin
                            tipoComprobante_Vta := "Documentos por Cliente ATS".TipoComprobante;
                        end;
                    }
                    textelement(numeroComprobantes)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            numeroComprobantes := Format("Documentos por Cliente ATS".NumroComprobantes);
                        end;
                    }
                    textelement(basenograiva_vta)
                    {
                        XmlName = 'baseNoGraIva';

                        trigger OnBeforePassVariable()
                        begin
                            baseNoGraIva_Vta := DelChr(Format("Documentos por Cliente ATS".BaseNoGraIva, 0, '<Precision,2:2><Standard format,0>'), '=', '-');
                        end;
                    }
                    textelement(baseimponible_vta)
                    {
                        XmlName = 'baseImponible';

                        trigger OnBeforePassVariable()
                        begin
                            baseImponible_Vta := DelChr(Format("Documentos por Cliente ATS".BaseImponible, 0, '<Precision,2:2><Standard format,0>'), '=', ',');
                        end;
                    }
                    textelement(baseImpGrav)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            baseImpGrav := DelChr(Format("Documentos por Cliente ATS".BaseImpGrav, 0, '<Precision,2:2><Standard format,0>'), '=', ',');
                        end;
                    }
                    textelement(montoiva_vta)
                    {
                        XmlName = 'montoIva';

                        trigger OnBeforePassVariable()
                        begin
                            montoIva_Vta := DelChr(Format("Documentos por Cliente ATS".MontoIva, 0, '<Precision,2:2><Standard format,0>'), '=', ',');
                        end;
                    }
                    textelement(valorRetIva)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            valorRetIva := DelChr(Format("Documentos por Cliente ATS".ValorRetIva, 0, '<Precision,2:2><Standard format,0>'), '=', '-');
                        end;
                    }
                    textelement(valorRetRenta)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            valorRetRenta := DelChr(Format("Documentos por Cliente ATS".ValorRetRenta, 0, '<Precision,2:2><Standard format,0>'), '=', '-');
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Vendor Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
                    end;

                    trigger OnBeforeInsertRecord()
                    begin
                        "Vendor Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
                        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
                    end;
                }
            }
            textelement(anulados)
            {
                tableelement("NCF Anulados"; "NCF Anulados")
                {
                    MinOccurs = Zero;
                    XmlName = 'detalleAnulados';
                    SourceTableView = SORTING("No. documento", "No. Comprobante Fiscal") ORDER(Ascending) WHERE("Tipo Documento" = FILTER(Invoice | "Credit Memo" | Retencion));
                    textelement(tipocomprobante_anul)
                    {
                        XmlName = 'tipoComprobante';

                        trigger OnBeforePassVariable()
                        begin
                            if "NCF Anulados"."Tipo Documento" = "NCF Anulados"."Tipo Documento"::Invoice then
                                tipoComprobante_Anul := '01';

                            if "NCF Anulados"."Tipo Documento" = "NCF Anulados"."Tipo Documento"::"Credit Memo" then
                                tipoComprobante_Anul := '04';

                            if "NCF Anulados"."Tipo Documento" = "NCF Anulados"."Tipo Documento"::Retencion then
                                tipoComprobante_Anul := '07';
                        end;
                    }
                    textelement(establecimiento_anul)
                    {
                        XmlName = 'establecimiento';

                        trigger OnBeforePassVariable()
                        begin
                            establecimiento_Anul := '';
                            if "NCF Anulados"."Tipo Documento" = "NCF Anulados"."Tipo Documento"::Invoice then
                                establecimiento_Anul := "NCF Anulados".Establecimiento;
                        end;
                    }
                    textelement(puntoemision_anul)
                    {
                        XmlName = 'puntoEmision';

                        trigger OnBeforePassVariable()
                        begin
                            puntoEmision_Anul := "NCF Anulados"."Punto Emision";
                        end;
                    }
                    textelement(secuencialInicio)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            secuencialInicio := '';
                            NoSeriesLine.Reset;
                            NoSeriesLine.SetCurrentKey("No. Autorizacion");
                            NoSeriesLine.SetRange("No. Autorizacion", "NCF Anulados"."No. Autorizacion");
                            NoSeriesLine.SetRange("Punto de Emision", "NCF Anulados"."Punto Emision");
                            NoSeriesLine.SetRange(Establecimiento, "NCF Anulados".Establecimiento);
                            if NoSeriesLine.FindFirst then
                                secuencialInicio := NoSeriesLine."Starting No.";
                        end;
                    }
                    textelement(secuencialFin)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            secuencialFin := NoSeriesLine."Ending No.";
                        end;
                    }
                    textelement(autorizacion_anul)
                    {
                        XmlName = 'autorizacion';

                        trigger OnBeforePassVariable()
                        begin
                            autorizacion_Anul := "NCF Anulados"."No. Autorizacion";
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
                    end;
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
        FechaInicial := 20130401D;
        FechaFinal := 20130430D;

        FunSantEc.ATS_ClientesContado(FechaInicial, FechaFinal);
        FunSantEc.ATS_DetalleVentas(FechaInicial, FechaFinal);

        "Vendor Ledger Entry".SetRange("Posting Date", FechaInicial, FechaFinal);
        //"Cust. Ledger Entry".SETRANGE("Posting Date",FechaInicial,FechaFinal);
        "NCF Anulados".SetRange("Fecha anulacion", FechaInicial, FechaFinal);
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
        VLE: Record "Vendor Ledger Entry";
        I: Integer;
        DocsPorCli: Record "Documentos por Cliente ATS";
        VendPostGp: Record "Vendor Posting Group";


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

