xmlport 55013 "Nota Debito FE"
{
    Encoding = UTF8;
    FormatEvaluate = Legacy;

    schema
    {
        tableelement(notadebito; "Documento FE")
        {
            XmlName = 'NotaDebito';
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
                        case NotaDebito.Ambiente of
                            NotaDebito.Ambiente::Pruebas:
                                ambiente := '1';
                            NotaDebito.Ambiente::Produccion:
                                ambiente := '2';
                        end;
                    end;
                }
                textelement(tipoEmision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case NotaDebito."Tipo emision" of
                            NotaDebito."Tipo emision"::Normal:
                                tipoEmision := '1';
                            NotaDebito."Tipo emision"::Contingencia:
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
                fieldelement(ruc; NotaDebito.RUC)
                {
                }
                fieldelement(claveAcceso; NotaDebito.Clave)
                {
                }
                fieldelement(codDoc; NotaDebito."Tipo comprobante")
                {
                }
                fieldelement(estab; NotaDebito.Establecimiento)
                {
                }
                fieldelement(ptoEmi; NotaDebito."Punto de emision")
                {
                }
                fieldelement(secuencial; NotaDebito.Secuencial)
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
            textelement(infoNotaDebito)
            {
                MinOccurs = Zero;
                textelement(fechaEmision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        fechaEmision := FormatFecha(NotaDebito."Fecha emision");
                    end;
                }
                fieldelement(dirEstablecimiento; NotaDebito."Dir. establecimiento")
                {
                }
                fieldelement(tipoIdentificacionComprador; NotaDebito."Tipo id.")
                {
                }
                fieldelement(razonSocialComprador; NotaDebito."Razon social")
                {
                }
                fieldelement(identificacionComprador; NotaDebito."Id. comprador")
                {
                }
                fieldelement(contribuyenteEspecial; NotaDebito."Contribuyente especial")
                {
                }
                fieldelement(obligadoContabilidad; NotaDebito."Obligado contabilidad")
                {
                    FieldValidate = no;
                }
                fieldelement(rise; NotaDebito.Rise)
                {
                }
                fieldelement(codDocModificado; NotaDebito."Cod. doc. modificado")
                {
                }
                fieldelement(numDocModificado; NotaDebito."Num. doc. modificado")
                {
                }
                fieldelement(fechaEmisionDocSustento; NotaDebito."Fecha emisión doc. sustento")
                {
                }
                fieldelement(totalSinImpuestos; NotaDebito."Total sin impuestos")
                {
                }
                tableelement(impuestos; "Total Impuestos FE")
                {
                    LinkFields = "No. documento" = FIELD("No. documento");
                    LinkTable = NotaDebito;
                    MinOccurs = Zero;
                    XmlName = 'impuestos';
                    textelement(impuesto)
                    {
                        fieldelement(codigo; Impuestos.Codigo)
                        {
                        }
                        fieldelement(codigoPorcentaje; Impuestos."Codigo Porcentaje")
                        {
                        }
                        fieldelement(baseImponible; Impuestos."Base Imponible")
                        {
                        }
                        fieldelement(tarifa; Impuestos.Tarifa)
                        {
                        }
                        fieldelement(valor; Impuestos.Valor)
                        {
                        }
                    }
                }
                fieldelement(valorTotal; NotaDebito."Importe total")
                {
                }
            }
            textelement(motivos)
            {
                textelement(motivo)
                {
                    textelement(razon)
                    {
                    }
                    textelement(valor)
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
                        campoAdicional1 := NotaDebito."Adicional - Direccion";
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
                        campoAdicional2 := NotaDebito."Adicional - Telefono";
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
                        campoAdicional3 := NotaDebito."Adicional - Email";
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

