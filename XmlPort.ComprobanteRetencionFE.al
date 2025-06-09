xmlport 55014 "Comprobante Retencion FE"
{
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        tableelement(retencionfe; "Documento FE")
        {
            XmlName = 'comprobanteRetencion';
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
                    version := '1.0.0';
                end;
            }
            textelement(infoTributaria)
            {
                textelement(ambiente)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case RetencionFE.Ambiente of
                            RetencionFE.Ambiente::Pruebas:
                                ambiente := '1';
                            RetencionFE.Ambiente::Produccion:
                                ambiente := '2';
                        end;
                    end;
                }
                textelement(tipoEmision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case RetencionFE."Tipo emision" of
                            RetencionFE."Tipo emision"::Normal:
                                tipoEmision := '1';
                            RetencionFE."Tipo emision"::Contingencia:
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
                fieldelement(ruc; RetencionFE.RUC)
                {
                }
                fieldelement(claveAcceso; RetencionFE.Clave)
                {
                }
                fieldelement(codDoc; RetencionFE."Tipo comprobante")
                {
                }
                fieldelement(estab; RetencionFE.Establecimiento)
                {
                }
                fieldelement(ptoEmi; RetencionFE."Punto de emision")
                {
                }
                fieldelement(secuencial; RetencionFE.Secuencial)
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
            textelement(infoCompRetencion)
            {
                MinOccurs = Zero;
                textelement(fechaEmision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        fechaEmision := FormatFecha(RetencionFE."Fecha emision");
                    end;
                }
                fieldelement(dirEstablecimiento; RetencionFE."Dir. establecimiento")
                {
                }
                fieldelement(contribuyenteEspecial; RetencionFE."Contribuyente especial")
                {
                }
                fieldelement(obligadoContabilidad; RetencionFE."Obligado contabilidad")
                {
                    FieldValidate = no;
                }
                fieldelement(tipoIdentificacionSujetoRetenido; RetencionFE."Tipo id.")
                {
                }
                fieldelement(razonSocialSujetoRetenido; RetencionFE."Razon social")
                {
                }
                fieldelement(identificacionSujetoRetenido; RetencionFE."id. sujeto retenido")
                {
                }
                fieldelement(periodoFiscal; RetencionFE."Periodo fiscal")
                {
                }
            }
            textelement(impuestos)
            {
                tableelement("Retenciones FE"; "Retenciones FE")
                {
                    LinkFields = "No. documento" = FIELD("No. documento");
                    LinkTable = RetencionFE;
                    XmlName = 'impuesto';
                    fieldelement(codigo; "Retenciones FE".Codigo)
                    {
                    }
                    fieldelement(codigoRetencion; "Retenciones FE"."Codigo retencion")
                    {
                    }
                    fieldelement(baseImponible; "Retenciones FE"."Base imponible")
                    {
                    }
                    fieldelement(porcentajeRetener; "Retenciones FE"."Porcentaje retener")
                    {
                    }
                    fieldelement(valorRetenido; "Retenciones FE"."Valor retenido")
                    {
                    }
                    fieldelement(codDocSustento; "Retenciones FE"."Cod. doc. sustento")
                    {
                    }
                    fieldelement(numDocSustento; "Retenciones FE"."Num. doc. sustento")
                    {
                    }
                    textelement(fechaEmisionDocSustento)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            fechaEmisionDocSustento := FormatFecha("Retenciones FE"."Fecha emision doc. sustento");
                        end;
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
                        campoAdicional1 := RetencionFE."Adicional - Direccion";
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
                        campoAdicional2 := RetencionFE."Adicional - Telefono";
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
                        campoAdicional3 := RetencionFE."Adicional - Email";
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

        recCFgFE.Get;
    end;

    var
        recInfoEmpresa: Record "Company Information";
        recCFgFE: Record "Config. Comprobantes elec.";


    procedure FormatFecha(datPrmFecha: Date): Text[30]
    begin
        exit(Format(datPrmFecha, 0, '<Day,2>/<Month,2>/<Year4>'));
    end;
}

