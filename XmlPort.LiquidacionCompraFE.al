xmlport 55019 "Liquidacion Compra FE"
{
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        tableelement(facturasfe; "Documento FE")
        {
            XmlName = 'liquidacionCompra';
            textattribute(id)
            {

                trigger OnBeforePassVariable()
                begin
                    id := 'comprobante';
                end;
            }
            textattribute(version)
            {

                trigger OnBeforePassVariable()
                begin
                    version := '1.1.0';
                end;
            }
            textelement(infoTributaria)
            {
                textelement(ambiente)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case FacturasFE.Ambiente of
                            FacturasFE.Ambiente::Pruebas:
                                ambiente := '1';
                            FacturasFE.Ambiente::Produccion:
                                ambiente := '2';
                        end;
                    end;
                }
                textelement(tipoEmision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case FacturasFE."Tipo emision" of
                            FacturasFE."Tipo emision"::Normal:
                                tipoEmision := '1';
                            FacturasFE."Tipo emision"::Contingencia:
                                tipoEmision := '2';
                        end;
                    end;
                }
                textelement(razonSocial)
                {

                    trigger OnBeforePassVariable()
                    begin
                        razonSocial := recInfoEmpresa.Name;
                    end;
                }
                textelement(nombreComercial)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        nombreComercial := recInfoEmpresa."Name 2";
                    end;
                }
                fieldelement(ruc; FacturasFE.RUC)
                {
                }
                fieldelement(claveAcceso; FacturasFE.Clave)
                {
                }
                fieldelement(codDoc; FacturasFE."Tipo comprobante")
                {
                }
                fieldelement(estab; FacturasFE.Establecimiento)
                {
                }
                fieldelement(ptoEmi; FacturasFE."Punto de emision")
                {
                }
                fieldelement(secuencial; FacturasFE.Secuencial)
                {
                }
                textelement(dirMatriz)
                {

                    trigger OnBeforePassVariable()
                    begin
                        dirMatriz := recInfoEmpresa.Address;
                    end;
                }
            }
            textelement(infoLiquidacionCompra)
            {
                MinOccurs = Zero;
                textelement(fechaEmision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        fechaEmision := FormatFecha(FacturasFE."Fecha emision");
                    end;
                }
                fieldelement(dirEstablecimiento; FacturasFE."Dir. establecimiento")
                {
                }
                fieldelement(contribuyenteEspecial; FacturasFE."Contribuyente especial")
                {
                }
                fieldelement(obligadoContabilidad; FacturasFE."Obligado contabilidad")
                {
                    FieldValidate = no;
                }
                fieldelement(tipoIdentificacionProveedor; FacturasFE."Tipo id.")
                {
                }
                fieldelement(razonSocialProveedor; FacturasFE."Razon social")
                {
                }
                fieldelement(identificacionProveedor; FacturasFE."Id. comprador")
                {
                }
                textelement(direccionProveedor)
                {
                }
                fieldelement(totalSinImpuestos; FacturasFE."Total sin impuestos")
                {
                }
                fieldelement(totalDescuento; FacturasFE."Total descuento")
                {
                }
                textelement(codDocReembolso)
                {

                    trigger OnBeforePassVariable()
                    begin

                        if FacturasFE."Tipo Doc" = '41' then
                            codDocReembolso := '41';
                    end;
                }
                textelement(totalComprobantesReembolso)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CalcularRembolso;
                    end;
                }
                textelement(totalBaseImponibleReembolso)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CalcularRembolso;
                    end;
                }
                textelement(totalImpuestoReembolso)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CalcularRembolso;
                    end;
                }
                textelement(totalConImpuestos)
                {
                    tableelement(impuestosfacturafe; "Total Impuestos FE")
                    {
                        LinkFields = "No. documento" = FIELD("No. documento");
                        LinkTable = FacturasFE;
                        MinOccurs = Zero;
                        XmlName = 'totalImpuesto';
                        fieldelement(codigo; ImpuestosFacturaFE.Codigo)
                        {
                        }
                        fieldelement(codigoPorcentaje; ImpuestosFacturaFE."Codigo Porcentaje")
                        {
                        }
                        textelement(descuentoAdicional)
                        {
                        }
                        fieldelement(baseImponible; ImpuestosFacturaFE."Base Imponible")
                        {
                        }
                        fieldelement(tarifa; ImpuestosFacturaFE.Tarifa)
                        {
                        }
                        fieldelement(valor; ImpuestosFacturaFE.Valor)
                        {
                        }
                    }
                }
                fieldelement(importeTotal; FacturasFE."Importe total")
                {
                }
                fieldelement(moneda; FacturasFE.Moneda)
                {
                }
            }
            textelement(detalles)
            {
                tableelement(detalle; "Detalle FE")
                {
                    LinkFields = "No. documento" = FIELD("No. documento");
                    LinkTable = FacturasFE;
                    XmlName = 'detalle';
                    fieldelement(codigoPrincipal; Detalle."Codigo Principal")
                    {
                    }
                    fieldelement(codigoAuxiliar; Detalle."Codigo Auxiliar")
                    {
                    }
                    fieldelement(descripcion; Detalle.Descripcion)
                    {
                    }
                    textelement(unidadMedida)
                    {
                    }
                    fieldelement(cantidad; Detalle.Cantidad)
                    {
                    }
                    fieldelement(precioUnitario; Detalle."Precio Unitario")
                    {
                    }
                    fieldelement(descuento; Detalle.Descuento)
                    {
                    }
                    fieldelement(precioTotalSinImpuesto; Detalle."Precio Total Sin Impuesto")
                    {
                    }
                    textelement(detallesAdicionales)
                    {
                        textelement(detadicional2)
                        {
                            XmlName = 'detAdicional';
                            textattribute(nombredetad2)
                            {
                                XmlName = 'nombre';

                                trigger OnBeforePassVariable()
                                begin
                                    nombreDetAd2 := Tex001;
                                end;
                            }
                            fieldattribute(valor; Detalle."Detalle adicional 2")
                            {
                            }
                        }
                    }
                    textelement(impuestos)
                    {
                        tableelement(impuesto; "Impuestos FE")
                        {
                            LinkFields = "No. documento" = FIELD("No. documento"), "No. linea" = FIELD("No. linea");
                            LinkTable = Detalle;
                            MinOccurs = Zero;
                            XmlName = 'impuesto';
                            fieldelement(codigo; Impuesto.Codigo)
                            {
                            }
                            fieldelement(codigoPorcentaje; Impuesto."Codigo Porcentaje")
                            {
                            }
                            fieldelement(tarifa; Impuesto.Tarifa)
                            {
                            }
                            fieldelement(baseImponible; Impuesto."Base Imponible")
                            {
                            }
                            fieldelement(valor; Impuesto.Valor)
                            {
                            }
                        }
                    }
                }
            }
            textelement(reembolsos)
            {
                MinOccurs = Zero;
                tableelement(rembolso; "Facturas de reembolso")
                {
                    LinkFields = "Document No." = FIELD("Documento Origen");
                    LinkTable = FacturasFE;
                    MaxOccurs = Unbounded;
                    MinOccurs = Zero;
                    XmlName = 'reembolsoDetalle';
                    fieldelement(tipoIdentificacionProveedorReembolso; Rembolso."Tipo ID")
                    {
                    }
                    fieldelement(identificacionProveedorReembolso; Rembolso.RUC)
                    {
                    }
                    textelement(codPaisPagoProveedorReembolso)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            codPaisPagoProveedorReembolso := '593';
                        end;
                    }
                    fieldelement(tipoProveedorReembolso; Rembolso."Tipo Proveedor Reembolso")
                    {
                    }
                    fieldelement(codDocReembolso; Rembolso."Tipo Comprobante")
                    {
                    }
                    fieldelement(estabDocReembolso; Rembolso."Establecimiento Comprobante")
                    {
                    }
                    fieldelement(ptoEmiDocReembolso; Rembolso."Punto Emision Comprobante")
                    {
                    }
                    fieldelement(secuencialDocReembolso; Rembolso."Numero Secuencial Comprobante")
                    {
                    }
                    textelement(fechaEmisionDocReembolso)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            fechaEmisionDocReembolso := FormatFecha(Rembolso."Fecha Comprobante");
                        end;
                    }
                    fieldelement(numeroautorizacionDocReemb; Rembolso."No. Autorización Comprobante")
                    {
                    }
                    textelement(detalleImpuestos)
                    {
                        MinOccurs = Zero;
                        textelement(detalleImpuesto)
                        {
                            MinOccurs = Zero;
                            textelement(codigo)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    if Rembolso."Monto IVA" <> 0 then
                                        codigo := '2'
                                    else
                                        codigo := '2';
                                end;
                            }
                            textelement(codigoPorcentaje)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    if Rembolso."Monto IVA" <> 0 then
                                        codigoPorcentaje := '2'
                                    else
                                        codigoPorcentaje := '0';
                                end;
                            }
                            textelement(tarifa)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    if Rembolso."Monto IVA" <> 0 then
                                        tarifa := '12'
                                    else
                                        tarifa := '0';
                                end;
                            }
                            textelement(baseImponibleReembolso)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    if Rembolso."Monto IVA" <> 0 then
                                        baseImponibleReembolso := Format(Round(Rembolso."Base X" + Rembolso."Base 0"), 0, 9)
                                    else
                                        baseImponibleReembolso := Format(Round(Rembolso."Base X" + Rembolso."Base 0"), 0, 9);
                                end;
                            }
                            textelement(impuestoReembolso)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    if Rembolso."Monto IVA" <> 0 then
                                        impuestoReembolso := Format(Round(Rembolso."Monto IVA"), 0, 9)
                                    else
                                        impuestoReembolso := Format(0)
                                end;
                            }
                        }
                    }
                }
            }
            textelement(infoAdicional)
            {
                textelement(campoadicional1)
                {
                    XmlName = 'campoAdicional';
                    textattribute(nombre1)
                    {
                        XmlName = 'nombre';

                        trigger OnBeforePassVariable()
                        begin
                            if campoAdicional1 <> '' then
                                nombre1 := 'Direción';
                        end;
                    }

                    trigger OnBeforePassVariable()
                    begin
                        campoAdicional1 := FacturasFE."Adicional - Direccion";
                    end;
                }
                textelement(campoadicional2)
                {
                    XmlName = 'campoAdicional';
                    textattribute(nombre2)
                    {
                        XmlName = 'nombre';

                        trigger OnBeforePassVariable()
                        begin
                            if campoAdicional2 <> '' then
                                nombre2 := 'Teléfono';
                        end;
                    }

                    trigger OnBeforePassVariable()
                    begin
                        campoAdicional2 := FacturasFE."Adicional - Telefono";
                    end;
                }
                textelement(campoadicional3)
                {
                    MinOccurs = Zero;
                    XmlName = 'campoAdicional';
                    textattribute(nombre3)
                    {
                        Occurrence = Optional;
                        XmlName = 'nombre';

                        trigger OnBeforePassVariable()
                        begin
                            if campoAdicional3 <> '' then
                                nombre3 := 'Email';
                        end;
                    }

                    trigger OnBeforePassVariable()
                    begin
                        campoAdicional3 := FacturasFE."Adicional - Email";
                    end;
                }
                textelement(campoadicional4)
                {
                    MinOccurs = Zero;
                    XmlName = 'campoAdicional';
                    textattribute(nombre4)
                    {
                        Occurrence = Optional;
                        XmlName = 'nombre';

                        trigger OnBeforePassVariable()
                        begin
                            if campoAdicional4 <> '' then
                                nombre4 := Text002;
                        end;
                    }

                    trigger OnBeforePassVariable()
                    begin
                        campoAdicional4 := FacturasFE."Adicional - Pedido";
                    end;
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
        recInfoEmpresa.Get;
        recInfoEmpresa.TestField("VAT Registration No.");
        recInfoEmpresa.TestField(Name);
        recInfoEmpresa.TestField(Address);
        //recInfoEmpresa.TESTFIELD("Cod. contribuyente especial");

        recCFgFE.Get;
    end;

    var
        recInfoEmpresa: Record "Company Information";
        recCFgFE: Record "Config. Comprobantes elec.";
        Tex001: Label '% Dto.';
        Text002: Label 'Nº VPP';


    procedure FormatFecha(datPrmFecha: Date): Text[30]
    begin
        exit(Format(datPrmFecha, 0, '<Day,2>/<Month,2>/<Year4>'));
    end;


    procedure CalcularRembolso()
    var
        FacReembolso: Record "Facturas de reembolso";
    begin
        if FacturasFE."Tipo Doc" = '41' then begin
            FacReembolso.Reset;
            FacReembolso.SetRange("Document No.", FacturasFE."Documento Origen");
            FacReembolso.CalcSums("Base 0", "Base X", "Monto IVA");
            totalBaseImponibleReembolso := Format(Round(FacReembolso."Base 0" + FacReembolso."Base X"), 0, 9);
            totalImpuestoReembolso := Format(Round(FacReembolso."Monto IVA"), 0, 9);
            totalComprobantesReembolso := Format(Round(FacReembolso."Base 0" + FacReembolso."Base X" + FacReembolso."Monto IVA"), 0, 9);
        end;
    end;
}

