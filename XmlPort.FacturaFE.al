xmlport 55010 "Factura FE"
{
    // --------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     26/04/2023      YFC           SANTINAV-4582 Estructura XML Documentos Electrónicos y Validador tipo contribuyente
    // 002     05/10/2023      YFC           SANTINAV-5013: Factura SRI - BC - No coinciden

    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        tableelement(facturasfe; "Documento FE")
        {
            XmlName = 'factura';
            textattribute(id)
            {

                trigger OnBeforePassVariable()
                begin
                    id := 'comprobante';
                end;

                trigger OnAfterAssignVariable()
                begin

                    // ++ 002-YFC
                    SIL.Reset;
                    SIL.SetRange("Document No.", FacturasFE."No. documento");
                    SIL.SetFilter(Type, '<>%1', SIL.Type::" ");
                    SIL.SetFilter(Quantity, '<>%1', 0);
                    Cant_SIL := SIL.Count;

                    DetalleFE.Reset;
                    DetalleFE.SetRange(DetalleFE."No. documento", FacturasFE."No. documento");
                    Cant_DetalleFE := DetalleFE.Count;

                    if Cant_SIL <> Cant_DetalleFE then
                        Error(Error030, FacturasFE."No. documento");
                    // -- 002-YFC
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
            textelement(infoFactura)
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
                fieldelement(tipoIdentificacionComprador; FacturasFE."Tipo id.")
                {
                }
                fieldelement(guiaRemision; FacturasFE."Guia remision")
                {
                }
                fieldelement(razonSocialComprador; FacturasFE."Razon social")
                {
                }
                fieldelement(identificacionComprador; FacturasFE."Id. comprador")
                {
                }
                fieldelement(totalSinImpuestos; FacturasFE."Total sin impuestos")
                {
                }
                fieldelement(totalDescuento; FacturasFE."Total descuento")
                {
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
                fieldelement(propina; FacturasFE.Propina)
                {
                }
                fieldelement(importeTotal; FacturasFE."Importe total")
                {
                }
                fieldelement(moneda; FacturasFE.Moneda)
                {
                }
                textelement(pagos)
                {
                    textelement(pago)
                    {
                        fieldelement(formaPago; FacturasFE."Forma de Pago")
                        {
                        }
                        fieldelement(total; FacturasFE."Pago total")
                        {
                        }
                        fieldelement(plazo; FacturasFE."Plazo Pago")
                        {
                        }
                        fieldelement(unidadTiempo; FacturasFE."Unidad Tiempo Pago")
                        {
                        }
                    }
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
            textelement(retenciones)
            {
                MinOccurs = Zero;
                tableelement(retencion; "Retenciones FE")
                {
                    LinkFields = "No. documento" = FIELD("No. documento");
                    LinkTable = FacturasFE;
                    MaxOccurs = Unbounded;
                    MinOccurs = Zero;
                    XmlName = 'retencion';
                    fieldelement(codigo; Retencion.Codigo)
                    {
                    }
                    fieldelement(codigoPorcentaje; Retencion."Codigo retencion")
                    {
                    }
                    fieldelement(tarifa; Retencion."Base imponible")
                    {
                    }
                    fieldelement(valor; Retencion."Porcentaje retener")
                    {
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

        recCFgFE.Get;

        recInfoEmpresa.Get;
        recInfoEmpresa.TestField("VAT Registration No.");
        recInfoEmpresa.TestField(Name);
        recInfoEmpresa.TestField(Address);

        if recCFgFE."Activar Cod. Contribuyente Esp" then //001-YFC
            recInfoEmpresa.TestField("Cod. contribuyente especial");
    end;

    var
        recInfoEmpresa: Record "Company Information";
        recCFgFE: Record "Config. Comprobantes elec.";
        Tex001: Label '% Dto.';
        Text002: Label 'Nº VPP';
        SIL: Record "Sales Invoice Line";
        DetalleFE: Record "Detalle FE";
        Cant_SIL: Integer;
        Cant_DetalleFE: Integer;
        Error030: Label 'El documento %1 no se ha podido enviar al SRI. No se cargaron todas las líneas del documento.';


    procedure FormatFecha(datPrmFecha: Date): Text[30]
    begin
        exit(Format(datPrmFecha, 0, '<Day,2>/<Month,2>/<Year4>'));
    end;
}

