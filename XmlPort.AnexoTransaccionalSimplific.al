xmlport 55004 "Anexo Transaccional Simplific."
{
    Direction = Export;
    Encoding = UTF8;

    schema
    {
        tableelement("Envios ATS"; "Envios ATS")
        {
            XmlName = 'iva';
            textelement(TipoIDInformante)
            {

                trigger OnBeforePassVariable()
                begin
                    TipoIDInformante := 'R';
                end;
            }
            textelement(IdInformante)
            {

                trigger OnBeforePassVariable()
                begin
                    IdInformante := CompInf."VAT Registration No.";
                end;
            }
            textelement(razonSocial)
            {

                trigger OnBeforePassVariable()
                var
                    rz: Text[100];
                begin
                    razonSocial := DelChr(CompInf.Name, '=', '.');
                end;
            }
            textelement(Anio)
            {

                trigger OnBeforePassVariable()
                begin

                    Anio := Format("Envios ATS".Año);
                    if StrLen(Format("Envios ATS".Año)) = 2 then
                        Anio := '20' + Format("Envios ATS".Año);
                end;
            }
            textelement(Mes)
            {

                trigger OnBeforePassVariable()
                begin

                    Mes := Format("Envios ATS".Mes);
                    if StrLen(Format("Envios ATS".Mes)) = 1 then
                        Mes := '0' + Format("Envios ATS".Mes);
                end;
            }
            textelement(numEstabRuc)
            {

                trigger OnBeforePassVariable()
                begin
                    case StrLen(Format(CompInf."No. Establecimientos inscritos")) of
                        1:
                            numEstabRuc := '00' + Format(CompInf."No. Establecimientos inscritos");
                        2:
                            numEstabRuc := '0' + Format(CompInf."No. Establecimientos inscritos");
                        3:
                            numEstabRuc := Format(CompInf."No. Establecimientos inscritos");
                    end;
                end;
            }
            textelement(totalVentas)
            {

                trigger OnBeforePassVariable()
                begin
                    totalVentas := FormateoImporte(getTotalVentas());
                end;
            }
            textelement(codigoOperativo)
            {

                trigger OnBeforePassVariable()
                begin

                    codigoOperativo := 'IVA';
                end;
            }
            textelement(compras)
            {
                MinOccurs = Zero;
                tableelement("ATS Compras/Ventas"; "ATS Compras/Ventas")
                {
                    LinkFields = "Mes - Periodo" = FIELD(Mes), "Año - Periodo" = FIELD("Año");
                    LinkTable = "Envios ATS";
                    MinOccurs = Zero;
                    XmlName = 'detalleCompras';
                    SourceTableView = SORTING("Tipo Documento", "No. Documento", "Cod. Retencion 1", "Tipo Retencion");
                    textelement(codSustento)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if StrLen("ATS Compras/Ventas"."Sustento del Comprobante") = 1 then
                                codSustento := '0' + "ATS Compras/Ventas"."Sustento del Comprobante"
                            else
                                codSustento := "ATS Compras/Ventas"."Sustento del Comprobante";
                        end;
                    }
                    fieldelement(tpIdProv; "ATS Compras/Ventas"."Cod. Tipo Indentificador")
                    {
                    }
                    textelement(idProv)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            idProv := DelChr("ATS Compras/Ventas"."RUC/Cedula", '=', '.');
                        end;
                    }
                    textelement(tipoComprobante)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if StrLen("ATS Compras/Ventas"."Tipo Comprobante") = 1 then
                                tipoComprobante := '0' + "ATS Compras/Ventas"."Tipo Comprobante"
                            else
                                tipoComprobante := "ATS Compras/Ventas"."Tipo Comprobante"
                        end;
                    }
                    textelement(parteRel)
                    {
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin

                            //IF "ATS Compras/Ventas"."Cod. Tipo Indentificador" = '03' THEN
                            if "ATS Compras/Ventas"."Parte Relacionada" then
                                parteRel := 'SI'
                            else
                                parteRel := 'NO';
                        end;
                    }
                    textelement(tipoProv)
                    {

                        trigger OnBeforePassVariable()
                        begin

                            if "ATS Compras/Ventas"."Cod. Tipo Indentificador" = '03' then
                                tipoProv := "ATS Compras/Ventas"."Tipo Contribuyente"
                        end;
                    }
                    textelement(fechaRegistro)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            fechaRegistro := FormateoFecha("ATS Compras/Ventas"."Fecha Registro");
                        end;
                    }
                    fieldelement(establecimiento; "ATS Compras/Ventas"."Establecimiento Documento")
                    {
                    }
                    fieldelement(puntoEmision; "ATS Compras/Ventas"."Punto Emision Documento")
                    {
                    }
                    fieldelement(secuencial; "ATS Compras/Ventas"."Numero Comprobante Fiscal")
                    {
                    }
                    textelement(fechaEmision)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            fechaEmision := FormateoFecha("ATS Compras/Ventas"."Fecha Emicion Doc");
                        end;
                    }
                    fieldelement(autorizacion; "ATS Compras/Ventas"."No. Autorizacion Documento")
                    {
                    }
                    textelement(baseNoGraIva)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            baseNoGraIva := FormateoImporte(0);
                        end;
                    }
                    textelement(baseImponible)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            baseImponible := FormateoImporte("ATS Compras/Ventas"."Base 0%")
                        end;
                    }
                    textelement(baseImpGrav)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            baseImpGrav := FormateoImporte("ATS Compras/Ventas"."Base 12%");
                        end;
                    }
                    textelement(baseImpExe)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            baseImpExe := FormateoImporte("ATS Compras/Ventas"._EXENTO);
                        end;
                    }
                    textelement(montoIce)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            montoIce := FormateoImporte(0);
                        end;
                    }
                    textelement(montoIva)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            montoIva := FormateoImporte("ATS Compras/Ventas"."Importe IVA");
                        end;
                    }
                    textelement(valRetBien10)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Compras/Ventas"."Porcentaje Retencion 2" = 10 then
                                valRetBien10 := FormateoImporte("ATS Compras/Ventas"."Importe Retencion 2")
                            else
                                valRetBien10 := FormateoImporte(0);
                        end;
                    }
                    textelement(valRetServ20)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Compras/Ventas"."Porcentaje Retencion 2" = 20 then
                                valRetServ20 := FormateoImporte("ATS Compras/Ventas"."Importe Retencion 2")
                            else
                                valRetServ20 := FormateoImporte(0);
                        end;
                    }
                    textelement(valorRetBienes)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Compras/Ventas"."Porcentaje Retencion 2" = 30 then
                                valorRetBienes := FormateoImporte("ATS Compras/Ventas"."Importe Retencion 2")
                            else
                                valorRetBienes := FormateoImporte(0);
                        end;
                    }
                    textelement(valorRetServicios)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Compras/Ventas"."Porcentaje Retencion 2" = 70 then
                                valorRetServicios := FormateoImporte("ATS Compras/Ventas"."Importe Retencion 2")
                            else
                                valorRetServicios := FormateoImporte(0);
                        end;
                    }
                    textelement(valRetServ100)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Compras/Ventas"."Porcentaje Retencion 2" = 100 then
                                valRetServ100 := FormateoImporte("ATS Compras/Ventas"."Importe Retencion 2")
                            else
                                valRetServ100 := FormateoImporte(0);
                        end;
                    }
                    textelement(pagoExterior)
                    {
                        fieldelement(pagoLocExt; "ATS Compras/Ventas"."Pago a residente")
                        {
                        }
                        textelement(paisEfecPago)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                if "ATS Compras/Ventas"."Pago a residente" = '02' then
                                    paisEfecPago := "ATS Compras/Ventas"."Codigo de Pais"
                                else
                                    paisEfecPago := 'NA';
                            end;
                        }
                        textelement(aplicConvDobTrib)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                case "ATS Compras/Ventas"."Tiene Convenio" of
                                    "ATS Compras/Ventas"."Tiene Convenio"::" ":
                                        aplicConvDobTrib := 'NA';
                                    "ATS Compras/Ventas"."Tiene Convenio"::"Sí":
                                        aplicConvDobTrib := 'SI';
                                    "ATS Compras/Ventas"."Tiene Convenio"::No:
                                        aplicConvDobTrib := 'NO';
                                end;
                            end;
                        }
                        textelement(pagExtSujRetNorLeg)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                case "ATS Compras/Ventas"."Sujeto a Retencion" of
                                    "ATS Compras/Ventas"."Sujeto a Retencion"::" ":
                                        pagExtSujRetNorLeg := 'NA';
                                    "ATS Compras/Ventas"."Sujeto a Retencion"::"Sí":
                                        pagExtSujRetNorLeg := 'SI';
                                    "ATS Compras/Ventas"."Sujeto a Retencion"::No:
                                        pagExtSujRetNorLeg := 'NO';
                                end;
                            end;
                        }
                        textelement(pagoRegFis)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                case "ATS Compras/Ventas"."Reg. Fiscal preferente/Paraiso" of
                                    "ATS Compras/Ventas"."Reg. Fiscal preferente/Paraiso"::" ":
                                        pagoRegFis := 'NA';
                                    "ATS Compras/Ventas"."Reg. Fiscal preferente/Paraiso"::"Sí":
                                        pagoRegFis := 'SI';
                                    "ATS Compras/Ventas"."Reg. Fiscal preferente/Paraiso"::No:
                                        pagoRegFis := 'NO';
                                end;
                            end;
                        }
                    }
                    textelement(formasDePago)
                    {
                        MinOccurs = Zero;
                        fieldelement(formaPago; "ATS Compras/Ventas"."Forma de Pago")
                        {
                            MinOccurs = Zero;
                        }

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Compras/Ventas"."Forma de Pago" = '' then
                                currXMLport.Skip;
                        end;
                    }
                    textelement(air)
                    {
                        tableelement(Integer; Integer)
                        {
                            XmlName = 'detalleAir';
                            SourceTableView = SORTING(Number);
                            textelement(codRetAir)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    codRetAir := "ATS Compras/Ventas"."Cod. Retencion 1";
                                end;
                            }
                            textelement(baseImpAir)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    baseImpAir := FormateoImporte("ATS Compras/Ventas"."Base Retencion 1");
                                end;
                            }
                            textelement(porcentajeAir)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    porcentajeAir := Format("ATS Compras/Ventas"."Porcentaje Retencion 1");
                                end;
                            }
                            textelement(valRetAir)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    valRetAir := FormateoImporte("ATS Compras/Ventas"."Importe Retencion 1")
                                end;
                            }

                            trigger OnPreXmlItem()
                            begin
                                Clear(noRet);
                                Clear(ret1);
                                if "ATS Compras/Ventas"."Cod. Retencion 1" <> '' then begin
                                    noRet += 1;
                                    ret1 := true;
                                end;
                                Integer.SetRange(Integer.Number, 1, noRet);
                            end;
                        }

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Compras/Ventas"."Cod. Retencion 1" = '' then
                                currXMLport.Skip;
                        end;
                    }
                    fieldelement(estabRetencion1; "ATS Compras/Ventas"."Establecimiento Retencion 1")
                    {
                    }
                    fieldelement(ptoEmiRetencion1; "ATS Compras/Ventas"."Punto Emision Retencion 1")
                    {
                    }
                    fieldelement(secRetencion1; "ATS Compras/Ventas"."No. Comprobante Retencion 1")
                    {
                    }
                    fieldelement(autRetencion1; "ATS Compras/Ventas"."No. Autorizacion Retencion 1")
                    {
                    }
                    textelement(fechaEmiRet1)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            if ret1 then
                                fechaEmiRet1 := FormateoFecha("ATS Compras/Ventas"."Fecha Emision Retencion");
                        end;
                    }
                    fieldelement(estabRetencion2; "ATS Compras/Ventas"."Establecimiento Retencion 2")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(ptoEmiRetencion2; "ATS Compras/Ventas"."Punto Emision Retencion 2")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(secRetencion2; "ATS Compras/Ventas"."No. Comprobante Retencion 2")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(autRetencion2; "ATS Compras/Ventas"."No. Autorizacion Retencion 2")
                    {
                        MinOccurs = Zero;
                    }
                    textelement(fechaEmiRet2)
                    {
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            if ret2 then
                                fechaEmiRet2 := FormateoFecha("ATS Compras/Ventas"."Fecha Emision Retencion");
                        end;
                    }
                    textelement(docModificado)
                    {
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            if StrLen("ATS Compras/Ventas"."Tipo Comprobante Factura Rel.") = 1 then
                                docModificado := '0' + "ATS Compras/Ventas"."Tipo Comprobante Factura Rel."
                            else
                                docModificado := "ATS Compras/Ventas"."Tipo Comprobante Factura Rel.";
                        end;
                    }
                    fieldelement(estabModificado; "ATS Compras/Ventas"."Establecimiento Factura Rel.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(ptoEmiModificado; "ATS Compras/Ventas"."Punto Emision Factura Rel.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(secModificado; "ATS Compras/Ventas"."No. Comprobante Fiscal Rel.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(autModificado; "ATS Compras/Ventas"."No.Autorizacion Factura Rel.")
                    {
                        MinOccurs = Zero;
                    }
                    textelement(reembolsos)
                    {
                        MinOccurs = Zero;
                        tableelement("Facturas de reembolso"; "Facturas de reembolso")
                        {
                            LinkFields = "Document No." = FIELD("No. Documento"), "Document Type" = FIELD("Tipo Documento");
                            LinkTable = "ATS Compras/Ventas";
                            XmlName = 'reembolso';
                            SourceTableView = SORTING("Document Type", "Document No.", "Line No.");
                            textelement(tipoComprobanteReemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    if StrLen("Facturas de reembolso"."Tipo Comprobante") = 1 then
                                        tipoComprobanteReemb := '0' + "Facturas de reembolso"."Tipo Comprobante"
                                    else
                                        tipoComprobanteReemb := "Facturas de reembolso"."Tipo Comprobante";
                                end;
                            }
                            textelement(tpIdProvReemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    case "Facturas de reembolso"."Tipo ID" of
                                        'R':
                                            tpIdProvReemb := '01';
                                        'C':
                                            tpIdProvReemb := '02';
                                        'P':
                                            tpIdProvReemb := '03';
                                    end;
                                end;
                            }
                            fieldelement(idProvReemb; "Facturas de reembolso".RUC)
                            {
                            }
                            fieldelement(establecimientoReemb; "Facturas de reembolso"."Establecimiento Comprobante")
                            {
                            }
                            fieldelement(puntoEmisionReemb; "Facturas de reembolso"."Punto Emision Comprobante")
                            {
                            }
                            fieldelement(secuencialReemb; "Facturas de reembolso"."Numero Secuencial Comprobante")
                            {
                            }
                            textelement(fechaEmisionReemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    fechaEmisionReemb := FormateoFecha("Facturas de reembolso"."Fecha Comprobante");
                                end;
                            }
                            fieldelement(autorizacionReemb; "Facturas de reembolso"."No. Autorización Comprobante")
                            {
                            }
                            textelement(baseImponibleReemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    baseImponibleReemb := FormateoImporte("Facturas de reembolso"."Base 0");
                                end;
                            }
                            textelement(baseImpGravReemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    baseImpGravReemb := FormateoImporte("Facturas de reembolso"."Base X");
                                end;
                            }
                            textelement(baseNoGraIvaReemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    baseNoGraIvaReemb := FormateoImporte("Facturas de reembolso"."Base No Objeto IVA");
                                end;
                            }
                            textelement(baseImpExeReemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    baseImpExeReemb := FormateoImporte(0);
                                end;
                            }
                            textelement(totbasesImpReemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    totbasesImpReemb := FormateoImporte("Facturas de reembolso"."Base No Objeto IVA" + "Facturas de reembolso"."Base 0" + "Facturas de reembolso"."Base X")
                                end;
                            }
                            textelement(montoIceReemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    montoIceReemb := FormateoImporte("Facturas de reembolso"."Monto ICE");
                                end;
                            }
                            textelement(montoIvaRemb)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    montoIvaRemb := FormateoImporte("Facturas de reembolso"."Monto IVA");
                                end;
                            }
                        }
                    }
                }
            }
            textelement(ventas)
            {
                tableelement("ATS Ventas x Cliente"; "ATS Ventas x Cliente")
                {
                    LinkFields = "Mes -  Periodo" = FIELD(Mes), "Año - Periodo" = FIELD("Año");
                    LinkTable = "Envios ATS";
                    XmlName = 'detalleVentas';
                    fieldelement(tpIdCliente; "ATS Ventas x Cliente"."Tipo Identificacion Cliente")
                    {
                    }
                    fieldelement(idCliente; "ATS Ventas x Cliente"."No. Identificación Cliente")
                    {
                    }
                    textelement(parterelv)
                    {
                        XmlName = 'parteRel';

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Ventas x Cliente"."Parte Relacionada" then
                                parteRelV := 'SI'
                            else
                                parteRelV := 'NO';
                        end;
                    }
                    textelement(tipocomprobantev)
                    {
                        XmlName = 'tipoComprobante';

                        trigger OnBeforePassVariable()
                        begin
                            if StrLen("ATS Ventas x Cliente"."Codigo Tipo Comprobante") = 1 then
                                tipoComprobanteV := '0' + "ATS Ventas x Cliente"."Codigo Tipo Comprobante"
                            else
                                tipoComprobanteV := "ATS Ventas x Cliente"."Codigo Tipo Comprobante";
                        end;
                    }
                    fieldelement(numeroComprobantes; "ATS Ventas x Cliente"."No. de Comprobantes")
                    {
                    }
                    textelement(basenograivav)
                    {
                        XmlName = 'baseNoGraIva';

                        trigger OnBeforePassVariable()
                        begin
                            baseNoGraIvaV := FormateoImporte("ATS Ventas x Cliente"."Base Imponible No objeto IVA");
                        end;
                    }
                    textelement(baseimponiblev)
                    {
                        XmlName = 'baseImponible';

                        trigger OnBeforePassVariable()
                        begin
                            baseImponibleV := FormateoImporte("ATS Ventas x Cliente"."Base Imponible 0% IVA");
                        end;
                    }
                    textelement(baseimpgravv)
                    {
                        XmlName = 'baseImpGrav';

                        trigger OnBeforePassVariable()
                        begin
                            baseImpGravV := FormateoImporte("ATS Ventas x Cliente"."Base Imposible 12% IVA");
                        end;
                    }
                    textelement(montoivav)
                    {
                        XmlName = 'montoIva';

                        trigger OnBeforePassVariable()
                        begin
                            montoIvaV := FormateoImporte("ATS Ventas x Cliente"."Monto IVA");
                        end;
                    }
                    textelement(montoicev)
                    {
                        XmlName = 'montoIce';
                    }
                    textelement(valorretivav)
                    {
                        XmlName = 'valorRetIva';

                        trigger OnBeforePassVariable()
                        begin
                            valorRetIvaV := FormateoImporte("ATS Ventas x Cliente"."Valor IVA retenido");
                        end;
                    }
                    textelement(valorRetRenta)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            valorRetRenta := FormateoImporte("ATS Ventas x Cliente"."Valor Renta retenido");
                        end;
                    }
                }
            }
            textelement(ventasEstablecimiento)
            {
                tableelement("ATS Ventas x Establecimiento"; "ATS Ventas x Establecimiento")
                {
                    LinkFields = "Mes -  Periodo" = FIELD(Mes), "Año - Periodo" = FIELD("Año");
                    LinkTable = "Envios ATS";
                    XmlName = 'ventaEst';
                    fieldelement(codEstab; "ATS Ventas x Establecimiento"."Cod.Establecimiento")
                    {
                    }
                    textelement(ventasEstab)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            ventasEstab := FormateoImporte("ATS Ventas x Establecimiento"."Ventas Establecimiento");
                        end;
                    }
                }
            }
            textelement(exportaciones)
            {
                MinOccurs = Zero;
                tableelement("ATS Exportaciones"; "ATS Exportaciones")
                {
                    LinkFields = "Mes -  Periodo" = FIELD(Mes), "Año - Periodo" = FIELD("Año");
                    LinkTable = "Envios ATS";
                    MinOccurs = Zero;
                    XmlName = 'detalleExportaciones';
                    fieldelement(tpIdClienteEx; "ATS Exportaciones"."Tipo Identificacion Cliente")
                    {
                    }
                    fieldelement(idClienteEx; "ATS Exportaciones"."No. Identificación Cliente")
                    {
                    }
                    textelement(parterelexp)
                    {
                        XmlName = 'parteRel';

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Exportaciones"."Parte Relacionada" then
                                parteRelExp := 'SI'
                            else
                                parteRelExp := 'NO';
                        end;
                    }
                    fieldelement(paisEfecExp; "ATS Exportaciones"."Pais Exportación")
                    {
                    }
                    textelement(pagoregfisexp)
                    {
                        XmlName = 'pagoRegFis';

                        trigger OnBeforePassVariable()
                        begin
                            if "ATS Exportaciones"."Reg. fiscal preferente/paraiso" then
                                pagoRegFisExp := 'SI'
                            else
                                pagoRegFisExp := 'NO';
                        end;
                    }
                    fieldelement(exportacionDe; "ATS Exportaciones"."Tipo Exportación")
                    {
                    }
                    fieldelement(paisEfecExp; "ATS Exportaciones"."Pais Exportación")
                    {
                    }
                    fieldelement(tipoComprobante; "ATS Exportaciones"."Tipo de Comprobante")
                    {
                    }
                    fieldelement(distAduanero; "ATS Exportaciones"."No. refrendo - distrito adua.")
                    {
                    }
                    textelement(fechaEmbarque)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            fechaEmbarque := FormateoFecha("ATS Exportaciones"."Fecha de Embarque");
                        end;
                    }
                    textelement(valorFOB)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            valorFOB := FormateoImporte("ATS Exportaciones"."Valor FOB");
                        end;
                    }
                    textelement(valorFOBComprobante)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            valorFOBComprobante := FormateoImporte("ATS Exportaciones"."Valor del comprobante local");
                        end;
                    }
                    fieldelement(anio; "ATS Exportaciones"."No. refrendo - Año")
                    {
                    }
                    fieldelement(regimen; "ATS Exportaciones"."No. refrendo - regimen")
                    {
                    }
                    fieldelement(correlativo; "ATS Exportaciones"."No. refrendo - Correlativo")
                    {
                    }
                    fieldelement(docTransp; "ATS Exportaciones"."No. de documento de transporte")
                    {
                    }
                    fieldelement(establecimiento; "ATS Exportaciones"."Establecimiento comprobante")
                    {
                    }
                    fieldelement(puntoEmision; "ATS Exportaciones"."Punto emision comprobante")
                    {
                    }
                    fieldelement(secuencial; "ATS Exportaciones"."No. Secuencial comprobante")
                    {
                    }
                    fieldelement(autorizacion; "ATS Exportaciones"."No. autorización comprobante")
                    {
                    }
                    textelement(fechaemisione)
                    {
                        XmlName = 'fechaEmision';

                        trigger OnBeforePassVariable()
                        begin
                            fechaEmisionE := FormateoFecha("ATS Exportaciones"."Fecha emision comprobante");
                        end;
                    }
                }
            }
            textelement(anulados)
            {
                MinOccurs = Zero;
                tableelement("ATS Comprobantes Anulados"; "ATS Comprobantes Anulados")
                {
                    LinkFields = "Mes -  Periodo" = FIELD(Mes), "Año - Periodo" = FIELD("Año");
                    LinkTable = "Envios ATS";
                    MinOccurs = Zero;
                    XmlName = 'detalleAnulados';
                    SourceTableView = SORTING("Tipo Comprobante anulado", Establecimiento, "Punto Emision", "No. secuencial - Desde");
                    fieldelement(tipoComprobante; "ATS Comprobantes Anulados"."Tipo Comprobante anulado")
                    {
                    }
                    fieldelement(establecimiento; "ATS Comprobantes Anulados".Establecimiento)
                    {
                    }
                    fieldelement(puntoEmision; "ATS Comprobantes Anulados"."Punto Emision")
                    {
                    }
                    fieldelement(secuencialInicio; "ATS Comprobantes Anulados"."No. secuencial - Desde")
                    {
                    }
                    fieldelement(secuencialFin; "ATS Comprobantes Anulados"."No. secuencial - Hasta")
                    {
                    }
                    fieldelement(autorizacion; "ATS Comprobantes Anulados"."No. autorización")
                    {
                    }
                }
            }
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

    trigger OnPreXmlPort()
    begin
        CompInf.Get;
        CompInf.TestField("VAT Registration No.");
        CompInf.TestField(Name);
        CompInf.TestField("No. Establecimientos inscritos");
        if (CompInf."No. Establecimientos inscritos" > 999) or (CompInf."No. Establecimientos inscritos" < 0) then
            Error(Error001);
    end;

    var
        CompInf: Record "Company Information";
        Error001: Label 'Year must be equal to 4 digits, greater than 2001 and not greater than %1';
        Error002: Label 'Month cannot be greater that the current';
        Error003: Label 'Month must be equal to 2 digits';
        ret1: Boolean;
        ret2: Boolean;
        noRet: Integer;


    procedure getTotalVentas() rtnTotVentas: Decimal
    var
        Ventas: Record "ATS Ventas x Cliente";
    begin

        rtnTotVentas := 0;
        Ventas.SetRange("Mes -  Periodo", "Envios ATS".Mes);
        Ventas.SetRange("Año - Periodo", "Envios ATS".Año);
        if Ventas.FindSet then
            repeat
                rtnTotVentas += Ventas."Base Imponible No objeto IVA" + Ventas."Base Imponible 0% IVA" + Ventas."Base Imposible 12% IVA";
            until Ventas.Next = 0;
    end;


    procedure FormateoFecha(prmFecha: Date): Code[10]
    begin
        exit(Format(prmFecha, 0, '<Day,2>/<Month,2>/<Year4>'));
    end;


    procedure FormateoImporte(prmImporte: Decimal): Code[15]
    begin
        exit(Format(prmImporte, 0, '<Precision,2:2><Sign><Integer><Decimals><Comma,.>'));
    end;
}

