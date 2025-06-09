xmlport 55011 "Remision FE"
{
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        tableelement(remisionfe; "Documento FE")
        {
            XmlName = 'guiaRemision';
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
                        case RemisionFE.Ambiente of
                            RemisionFE.Ambiente::Pruebas:
                                ambiente := '1';
                            RemisionFE.Ambiente::Produccion:
                                ambiente := '2';
                        end;
                    end;
                }
                textelement(tipoEmision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case RemisionFE."Tipo emision" of
                            RemisionFE."Tipo emision"::Normal:
                                tipoEmision := '1';
                            RemisionFE."Tipo emision"::Contingencia:
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
                fieldelement(ruc; RemisionFE.RUC)
                {
                }
                fieldelement(claveAcceso; RemisionFE.Clave)
                {
                }
                fieldelement(codDoc; RemisionFE."Tipo comprobante")
                {
                }
                fieldelement(estab; RemisionFE.Establecimiento)
                {
                }
                fieldelement(ptoEmi; RemisionFE."Punto de emision")
                {
                }
                fieldelement(secuencial; RemisionFE.Secuencial)
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
            textelement(infoGuiaRemision)
            {
                MinOccurs = Zero;
                fieldelement(dirEstablecimiento; RemisionFE."Dir. establecimiento")
                {
                }
                fieldelement(dirPartida; RemisionFE."Dir. partida")
                {
                }
                fieldelement(razonSocialTransportista; RemisionFE."Nombre transportista")
                {
                }
                fieldelement(tipoIdentificacionTransportista; RemisionFE."Tipo id. trans.")
                {
                }
                fieldelement(rucTransportista; RemisionFE."RUC transportista")
                {
                }
                fieldelement(rise; RemisionFE.Rise)
                {
                }
                fieldelement(obligadoContabilidad; RemisionFE."Obligado contabilidad")
                {
                    FieldValidate = no;
                }
                fieldelement(contribuyenteEspecial; RemisionFE."Contribuyente especial")
                {
                }
                textelement(fechaIniTransporte)
                {

                    trigger OnBeforePassVariable()
                    begin
                        fechaIniTransporte := FormatFecha(RemisionFE."Fecha ini. transporte");
                    end;
                }
                textelement(fechaFinTransporte)
                {

                    trigger OnBeforePassVariable()
                    begin
                        fechaFinTransporte := FormatFecha(RemisionFE."Fecha fin transporte");
                    end;
                }
                fieldelement(placa; RemisionFE.Placa)
                {
                }
            }
            textelement(destinatarios)
            {
                textelement(destinatario)
                {
                    fieldelement(identificacionDestinatario; RemisionFE."Id. destinatario")
                    {
                    }
                    fieldelement(razonSocialDestinatario; RemisionFE."Razon social destinatario")
                    {
                    }
                    fieldelement(dirDestinatario; RemisionFE."Direccion destinatario")
                    {
                    }
                    fieldelement(motivoTraslado; RemisionFE.Motivo)
                    {
                    }
                    fieldelement(docAduaneroUnico; RemisionFE."Doc. aduanero unico")
                    {
                    }
                    fieldelement(codEstabDestino; RemisionFE."Cod. etablecimiento destino")
                    {
                    }
                    fieldelement(ruta; RemisionFE.Ruta)
                    {
                    }
                    fieldelement(codDocSustento; RemisionFE."Cod. doc. sustento")
                    {
                    }
                    fieldelement(numDocSustento; RemisionFE."Num. doc. sustento")
                    {
                    }
                    fieldelement(numAutDocSustento; RemisionFE."Num. aut. doc. sustento")
                    {
                    }
                    textelement(fechaEmisionDocSustento)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            fechaEmisionDocSustento := FormatFecha(RemisionFE."Fecha emisión doc. sustento");
                        end;
                    }
                    textelement(detalles)
                    {
                        tableelement(detallesfe; "Detalle FE")
                        {
                            LinkFields = "No. documento" = FIELD("No. documento");
                            LinkTable = RemisionFE;
                            XmlName = 'detalle';
                            fieldelement(codigoInterno; DetallesFE."Codigo Principal")
                            {
                            }
                            fieldelement(codigoAdicional; DetallesFE."Codigo Auxiliar")
                            {
                            }
                            fieldelement(descripcion; DetallesFE.Descripcion)
                            {
                            }
                            fieldelement(cantidad; DetallesFE.Cantidad)
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
                    MinOccurs = Zero;
                    XmlName = 'campoAdicional';
                    textattribute(nombre1)
                    {
                        Occurrence = Optional;
                        XmlName = 'nombre';

                        trigger OnBeforePassVariable()
                        begin
                            if campoAdicional1 <> '' then
                                nombre1 := 'Direción';
                        end;
                    }

                    trigger OnBeforePassVariable()
                    begin
                        campoAdicional1 := RemisionFE."Adicional - Direccion";
                    end;
                }
                textelement(campoadicional2)
                {
                    MinOccurs = Zero;
                    XmlName = 'campoAdicional';
                    textattribute(nombre2)
                    {
                        Occurrence = Optional;
                        XmlName = 'nombre';

                        trigger OnBeforePassVariable()
                        begin
                            if campoAdicional2 <> '' then
                                nombre2 := 'Teléfono';
                        end;
                    }

                    trigger OnBeforePassVariable()
                    begin
                        campoAdicional2 := RemisionFE."Adicional - Telefono";
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
                        campoAdicional3 := RemisionFE."Adicional - Email";
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
                                case RemisionFE."Subtipo documento" of
                                    RemisionFE."Subtipo documento"::Venta:
                                        nombre4 := Text001;
                                    RemisionFE."Subtipo documento"::Transferencia:
                                        nombre4 := Text002;
                                end;
                        end;
                    }

                    trigger OnBeforePassVariable()
                    begin
                        campoAdicional4 := RemisionFE."Adicional - Pedido";
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
        Text001: Label 'Nº VPP';
        Text002: Label 'Nº PT';


    procedure FormatFecha(datPrmFecha: Date): Text[30]
    begin
        exit(Format(datPrmFecha, 0, '<Day,2>/<Month,2>/<Year4>'));
    end;
}

