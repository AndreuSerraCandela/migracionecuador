xmlport 55012 "Nota Credito FE"
{
    // --------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     15/06/2023      YFC           SANTINAV-4695 Desactivar tipo de contribuyente para notas de crédito nueva sociedad

    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        tableelement(notacreditofe; "Documento FE")
        {
            XmlName = 'notaCredito';
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
                        case NotaCreditoFE.Ambiente of
                            NotaCreditoFE.Ambiente::Pruebas:
                                ambiente := '1';
                            NotaCreditoFE.Ambiente::Produccion:
                                ambiente := '2';
                        end;
                    end;
                }
                textelement(tipoEmision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case NotaCreditoFE."Tipo emision" of
                            NotaCreditoFE."Tipo emision"::Normal:
                                tipoEmision := '1';
                            NotaCreditoFE."Tipo emision"::Contingencia:
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
                fieldelement(ruc; NotaCreditoFE.RUC)
                {
                }
                fieldelement(claveAcceso; NotaCreditoFE.Clave)
                {
                }
                fieldelement(codDoc; NotaCreditoFE."Tipo comprobante")
                {
                }
                fieldelement(estab; NotaCreditoFE.Establecimiento)
                {
                }
                fieldelement(ptoEmi; NotaCreditoFE."Punto de emision")
                {
                }
                fieldelement(secuencial; NotaCreditoFE.Secuencial)
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
            textelement(infoNotaCredito)
            {
                MinOccurs = Zero;
                textelement(fechaEmision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        fechaEmision := FormatFecha(NotaCreditoFE."Fecha emision");
                    end;
                }
                fieldelement(dirEstablecimiento; NotaCreditoFE."Dir. establecimiento")
                {
                }
                fieldelement(tipoIdentificacionComprador; NotaCreditoFE."Tipo id.")
                {
                }
                fieldelement(razonSocialComprador; NotaCreditoFE."Razon social")
                {
                }
                fieldelement(identificacionComprador; NotaCreditoFE."Id. comprador")
                {
                }
                fieldelement(contribuyenteEspecial; NotaCreditoFE."Contribuyente especial")
                {
                }
                fieldelement(obligadoContabilidad; NotaCreditoFE."Obligado contabilidad")
                {
                    FieldValidate = no;
                }
                fieldelement(codDocModificado; NotaCreditoFE."Cod. doc. modificado")
                {
                }
                fieldelement(numDocModificado; NotaCreditoFE."Num. doc. modificado")
                {
                }
                textelement(fechaEmisionDocSustento)
                {

                    trigger OnBeforePassVariable()
                    begin
                        fechaEmisionDocSustento := FormatFecha(NotaCreditoFE."Fecha emisión doc. sustento");
                    end;
                }
                fieldelement(totalSinImpuestos; NotaCreditoFE."Total sin impuestos")
                {
                }
                fieldelement(valorModificacion; NotaCreditoFE."Valor modificacion")
                {
                }
                fieldelement(moneda; NotaCreditoFE.Moneda)
                {
                }
                textelement(totalConImpuestos)
                {
                    tableelement(impuestosfacturafe; "Total Impuestos FE")
                    {
                        LinkFields = "No. documento" = FIELD("No. documento");
                        LinkTable = NotaCreditoFE;
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
                        fieldelement(valor; ImpuestosFacturaFE.Valor)
                        {
                        }
                    }
                }
                fieldelement(motivo; NotaCreditoFE.Motivo)
                {
                }
            }
            textelement(detalles)
            {
                tableelement(detalle; "Detalle FE")
                {
                    LinkFields = "No. documento" = FIELD("No. documento");
                    LinkTable = NotaCreditoFE;
                    XmlName = 'detalle';
                    fieldelement(codigoInterno; Detalle."Codigo Principal")
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
                        campoAdicional1 := NotaCreditoFE."Adicional - Direccion";
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
                                nombre2 := 'Telefono';
                        end;
                    }

                    trigger OnBeforePassVariable()
                    begin
                        campoAdicional2 := NotaCreditoFE."Adicional - Telefono";
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
                        campoAdicional3 := NotaCreditoFE."Adicional - Email";
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


    procedure FormatFecha(datPrmFecha: Date): Text[30]
    begin
        exit(Format(datPrmFecha, 0, '<Day,2>/<Month,2>/<Year4>'));
    end;
}

