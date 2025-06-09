xmlport 75004 "MDM-Migracion Inicial Art."
{
    // --------------------------------------------------------------------------------
    // -- XMLport automatically created with Dynamics NAV XMLport Generator 1.3.0.2
    // -- Copyright ’ 2007-2012 Carsten Scholling
    // --------------------------------------------------------------------------------
    // wSopPapel Indica el valor Sorte = "Papel" lo que implique se se comuniquen o no determinados campos
    // wTipSLIC wTipSDIG Son tipologias de tipo SLIC o SDIC. Implica que determinados campos se consideren obligatorios y deban de comunicarse o no

    DefaultFieldsValidation = false;
    Direction = Export;
    Encoding = UTF16;
    Format = Xml;
    FormatEvaluate = Xml;

    schema
    {
        textelement(mensaje)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            XmlName = 'mensaje';
            textelement(body)
            {
                MaxOccurs = Once;
                MinOccurs = Once;
                XmlName = 'body';
                textelement(articulos)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'Articulos';
                    tableelement(Item; Item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        RequestFilterFields = "No.";
                        XmlName = 'Articulo';
                        SourceTableView = SORTING("No.");
                        textelement(articulo_general)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'Articulo_GENERAL';
                            fieldelement(Clave; Item."No.")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                            fieldelement(Tipologia; Item."Item Category Code")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;

                                trigger OnBeforePassField()
                                begin
                                    AsegDato(Item."Item Category Code");
                                end;
                            }
                            textelement(titulo_corto)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Titulo_Corto';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Titulo_Corto);
                                end;
                            }
                            textelement(titulo)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Titulo_Catalogo';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Titulo);
                                end;
                            }
                            textelement(ISBN)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(ISBN);
                                end;
                            }
                            textelement(isbn_tramitado)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'ISBN_Tramitado';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato('');
                                end;
                            }
                            textelement(ean)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'EAN';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(EAN);
                                end;
                            }
                            fieldelement(Tipo_Producto; Item."Tipo Producto")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;

                                trigger OnBeforePassField()
                                begin
                                    AsegDato(Item."Tipo Producto");
                                end;
                            }
                            fieldelement(Soporte_del_Producto; Item.Soporte)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;

                                trigger OnBeforePassField()
                                begin
                                    AsegDato(Item.Soporte);
                                end;
                            }
                            textelement(alto)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Alto';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Alto);
                                end;
                            }
                            textelement(ancho)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Ancho';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Ancho);
                                end;
                            }
                            textelement(encuadernacion)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Encuadernacion';

                                trigger OnBeforePassVariable()
                                begin
                                    if not EsPapel then
                                        currXMLport.Skip;
                                    AsegDato(Encuadernacion);
                                end;
                            }
                            textelement(con_solapas)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Con_Solapas';

                                trigger OnBeforePassVariable()
                                begin
                                    if not EsPapel then
                                        currXMLport.Skip;
                                    AsegDato(Con_Solapas);
                                end;
                            }
                            textelement(datos_tecnicos)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Datos_Tecnicos';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Datos_Tecnicos);
                                end;
                            }
                            textelement(paginas)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Paginas';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Paginas);
                                end;
                            }
                            textelement(peso)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Peso';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Peso);
                                end;
                            }
                            fieldelement(Empresa_Editora; Item."Empresa Editora")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;

                                trigger OnBeforePassField()
                                begin
                                    AsegDato(Item."Empresa Editora");
                                end;
                            }
                            fieldelement(Linea; Item.Linea)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;

                                trigger OnBeforePassField()
                                begin
                                    AsegDato(Item.Linea);
                                end;
                            }
                            textelement(sello)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'Sello';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Sello);
                                end;
                            }
                            textelement(fecha_alta)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Fecha_Alta';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Fecha_Alta);
                                end;
                            }
                            textelement(idioma)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'Idioma';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Idioma);
                                end;
                            }
                            textelement(idioma_original)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Idioma_Original';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Idioma_Original);
                                end;
                            }
                            textelement(titulo_original)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Titulo_Original';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Titulo_Original);
                                end;
                            }
                            textelement(idioma_resumen)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Idioma_Resumen';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Idioma_Resumen);
                                end;
                            }
                            textelement(resumen)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Resumen';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Resumen);
                                end;
                            }
                            textelement(obra_proyecto)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Obra_Proyecto';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Obra_Proyecto);
                                end;
                            }
                            textelement(serie_metodo)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Serie_Metodo';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Serie_Metodo);
                                end;
                            }
                            textelement(orden_serie_metodo)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Orden_Serie_Metodo';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Orden_Serie_Metodo);
                                end;
                            }
                            textelement(clasificaciones_ibic)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Clasificaciones_IBIC';
                                textelement(clasificacion_ibic)
                                {
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Once;
                                    XmlName = 'Clasificacion_IBIC';
                                    textelement(ibic)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'IBIC';
                                    }
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    currXMLport.Skip;
                                end;
                            }
                            textelement(ficheros_digitales_asociado)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Ficheros_Digitales_Asociados';
                                textelement(fichero_digital_asociado)
                                {
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Once;
                                    XmlName = 'Fichero_Digital_Asociado';
                                    textelement(tipo_fichero_digital_asocia)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Tipo_Fichero_Digital_Asociado';
                                    }
                                    textelement(ficherodigitalasociado)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'FicheroDigitalAsociado';
                                    }
                                    textelement(ficherodigitalprincipal)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'FicheroDigitalPrincipal';
                                    }
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    currXMLport.Skip;
                                end;
                            }
                            textelement(asignacion_autores)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Asignacion_Autores';
                                textelement(asignacion_autor)
                                {
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Once;
                                    XmlName = 'Asignacion_Autor';
                                    textelement(autor)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        XmlName = 'Autor';

                                        trigger OnBeforePassVariable()
                                        begin
                                            AsegDato(Autor);
                                        end;
                                    }
                                    textelement(tipo_autoria)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        XmlName = 'Tipo_Autoria';

                                        trigger OnBeforePassVariable()
                                        begin
                                            AsegDato(Tipo_Autoria);
                                        end;
                                    }
                                    textelement(autor_catalogo)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        XmlName = 'Autor_Catalogo';

                                        trigger OnBeforePassVariable()
                                        begin
                                            AsegDato(Autor_Catalogo);
                                        end;
                                    }

                                    trigger OnBeforePassVariable()
                                    begin
                                        AsegDato(Autor);
                                    end;
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Autor);
                                end;
                            }
                            textelement(articulos_digitales)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Articulos_Digitales';
                                textelement(articulo_digital)
                                {
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Once;
                                    XmlName = 'Articulo_Digital';
                                    textelement(formatodigital)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'FormatoDigital';

                                        trigger OnBeforePassVariable()
                                        begin
                                            AsegDato(FormatoDigital);
                                        end;
                                    }
                                    textelement(pesodigitalunidad)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'PesoDigitalUnidad';

                                        trigger OnBeforePassVariable()
                                        begin
                                            AsegDato(PesoDigitalUnidad);
                                        end;
                                    }
                                    textelement(pesodigitalvalor)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'PesoDigitalValor';

                                        trigger OnBeforePassVariable()
                                        begin
                                            AsegDato(PesoDigitalValor);
                                        end;
                                    }
                                    textelement(tipoproteccion)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'TipoProteccion';

                                        trigger OnBeforePassVariable()
                                        begin
                                            AsegDato(TipoProteccion);
                                        end;
                                    }
                                    textelement(versiondigital)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'VersionDigital';

                                        trigger OnBeforePassVariable()
                                        begin
                                            AsegDato(VersionDigital);
                                        end;
                                    }

                                    trigger OnBeforePassVariable()
                                    begin

                                        if EsTipSlicSdig then begin
                                            FormatoDigital := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Formato Digital", '', wObligaCampos);
                                            PesoDigitalUnidad := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Peso Digital Unidad", '', wObligaCampos);
                                            PesoDigitalValor := '0';
                                            TipoProteccion := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Tipo Protección", '', wObligaCampos);
                                        end
                                        else begin
                                            FormatoDigital := '';
                                            PesoDigitalUnidad := '';
                                            PesoDigitalValor := '';
                                            TipoProteccion := '';
                                        end;

                                        if (FormatoDigital = '') and (PesoDigitalUnidad = '') and (PesoDigitalValor = '') and (TipoProteccion = '') then
                                            currXMLport.Skip;
                                    end;
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    if not EsTipSlicSdig then
                                        currXMLport.Skip;
                                end;
                            }
                            textelement(direcciones_url)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Direcciones_URL';
                                textelement(direccion_url)
                                {
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Once;
                                    XmlName = 'Direccion_URL';
                                    textelement(direccion_url_direccion_url)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Direccion_URL';
                                    }
                                    textelement(principal)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Principal';
                                    }
                                    textelement(tipo_url)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Tipo_URL';
                                    }
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    currXMLport.Skip;
                                end;
                            }
                            textelement(premios)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Premios';
                                textelement(premio)
                                {
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Once;
                                    XmlName = 'Premio';
                                    textelement(nombre_premio)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Nombre_Premio';
                                    }
                                    textelement(pais_premio)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Pais_Premio';
                                    }
                                    textelement(posicion_premio)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Posicion_Premio';
                                    }
                                    textelement(anio_premio)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Anio_Premio';
                                    }
                                    textelement(jurado_premio)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Jurado_Premio';
                                    }
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    currXMLport.Skip;
                                end;
                            }
                        }
                        textelement(articulo_espec)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'Articulo_ESPEC';
                            fieldelement(Clave; Item."No.")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                            fieldelement(Sociedad; Item.Sociedad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;

                                trigger OnBeforePassField()
                                begin
                                    AsegDato(Item.Sociedad);
                                end;
                            }
                            textelement(pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'Pais';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Pais);
                                end;
                            }
                            textelement(idioma_resenia)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Idioma_Resenia';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Idioma_Resenia);
                                end;
                            }
                            textelement(resenia)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Resenia';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Resenia);
                                end;
                            }
                            textelement(idioma_titular_promocional)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Idioma_Titular_Promocional';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Idioma_Titular_Promocional);
                                end;
                            }
                            textelement(titular_promocional)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Titular_Promocional';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Titular_Promocional);
                                end;
                            }
                            fieldelement(Plan_Editorial; Item."Plan Editorial")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;

                                trigger OnBeforePassField()
                                begin
                                    AsegDato(Item."Plan Editorial");
                                end;
                            }
                            textelement(campania)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Campania';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Campania);
                                end;
                            }
                            textelement(edicion)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Edicion';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Edicion);
                                end;
                            }
                            textelement(derechos_de_autor)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Derechos_de_Autor';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Derechos_de_Autor);
                                end;
                            }
                            textelement(destino)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Destino';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Destino);
                                end;
                            }
                            textelement(cuenta)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Cuenta';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Cuenta);
                                end;
                            }
                            fieldelement(Estructura_Analitica; Item."Estructura Analitica")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;

                                trigger OnBeforePassField()
                                begin
                                    AsegDato(Item."Estructura Analitica");
                                end;
                            }
                            textelement(estado)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'Estado';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Estado);
                                end;
                            }
                            textelement(fecha_estado)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Fecha_Estado';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Fecha_Estado);
                                end;
                            }
                            textelement(fecha_almacen)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Fecha_Almacen';
                            }
                            textelement(fecha_prevista_almacen)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Fecha_Prevista_Almacen';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Fecha_Prevista_Almacen);
                                end;
                            }
                            textelement(fecha_comercializacion)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Fecha_Comercializacion';
                            }
                            textelement(tipo_texto)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Tipo_Texto';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Tipo_Texto);
                                end;
                            }
                            fieldelement(Asignatura; Item.Asignatura)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;

                                trigger OnBeforePassField()
                                begin
                                    AsegDato(Item.Asignatura);
                                end;
                            }
                            textelement(materia)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Materia';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Materia);
                                end;
                            }
                            textelement(nivel_escolar)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Nivel_Escolar';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Nivel_Escolar);
                                end;
                            }
                            textelement(bimestre_trimestre)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Bimestre_Trimestre';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Bimestre_Trimestre);
                                end;
                            }
                            textelement(carga_horaria)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Carga_Horaria';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Carga_Horaria);
                                end;
                            }
                            textelement(common_european_framework)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Common_European_Framework';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Common_European_Framework);
                                end;
                            }
                            textelement(observaciones)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Observaciones';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Observaciones);
                                end;
                            }
                            textelement(origen)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Origen';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Origen);
                                end;
                            }
                            textelement(vendible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Vendible';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Vendible);
                                end;
                            }
                            textelement(precio)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Precio';
                                textelement(precio_sin_impuestos)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Precio_sin_Impuestos';

                                    trigger OnBeforePassVariable()
                                    begin
                                        AsegDato(Precio_sin_Impuestos);
                                    end;
                                }
                                textelement(precio_con_impuestos)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Precio_con_Impuestos';

                                    trigger OnBeforePassVariable()
                                    begin
                                        AsegDato(Precio_con_Impuestos);
                                    end;
                                }
                                textelement(moneda)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Moneda';

                                    trigger OnBeforePassVariable()
                                    begin
                                        AsegDato(Moneda);
                                    end;
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Precio_sin_Impuestos);
                                end;
                            }
                            textelement(edad_interes_desde)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Edad_Interes_Desde';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Edad_Interes_Desde);
                                end;
                            }
                            textelement(edad_interes_hasta)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Edad_Interes_Hasta';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Edad_Interes_Hasta);
                                end;
                            }
                            textelement(vida_util)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Vida_Util';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato(Vida_Util);
                                end;
                            }
                            textelement(packs)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Packs';
                                tableelement(bomline; "BOM Component")
                                {
                                    LinkFields = "Parent Item No." = FIELD("No.");
                                    LinkTable = Item;
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Zero;
                                    XmlName = 'Pack';
                                    SourceTableView = WHERE(Type = CONST(Item));
                                    textelement(articulo_pack)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        XmlName = 'Articulo_Pack';
                                    }
                                    fieldelement(Unidades; BOMLine."Quantity per")
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                    }
                                    fieldelement(Orden; BOMLine."Line No.")
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                    }

                                    trigger OnAfterGetRecord()
                                    begin
                                        if BOMLine.Count = 0 then
                                            currXMLport.Skip;

                                        Articulo_Pack := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Artículo Pack", BOMLine."No.", false);
                                        //Articulo_Pack  := GetTexMaxErr(Articulo_Pack,10, Text003);
                                    end;
                                }
                                textelement(componentes)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Zero;
                                    TextType = Text;
                                    XmlName = 'Componentes';

                                    trigger OnBeforePassVariable()
                                    begin
                                        AsegDato(Componentes);
                                    end;
                                }

                                trigger OnBeforePassVariable()
                                var
                                    lrLinBom: Record "BOM Component";
                                begin
                                    Clear(lrLinBom);
                                    lrLinBom.SetRange("Parent Item No.", Item."No.");
                                    if lrLinBom.IsEmpty then
                                        currXMLport.Skip;
                                end;
                            }
                            textelement(asignacion_articulos_relaci)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Asignacion_Articulos_Relacionados';
                                textelement(asignacion_articulo_relacio)
                                {
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Once;
                                    XmlName = 'Asignacion_Articulo_Relaciodado';
                                    textelement(articulo_relacionado)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Articulo_Relacionado';
                                    }
                                    textelement(tipo_relacion)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Tipo_Relacion';
                                    }
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    currXMLport.Skip;
                                end;
                            }
                            textelement(asignacion_fechas_conmemora)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Asignacion_Fechas_Conmemorativas';
                                textelement(asignacion_fecha_conmemorat)
                                {
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Once;
                                    XmlName = 'Asignacion_Fecha_Conmemorativa';
                                    textelement(fecha_conmemorativa)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Fecha_Conmemorativa';
                                    }
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    currXMLport.Skip;
                                end;
                            }
                            textelement(asignacion_temas_tranversal)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Asignacion_Temas_Tranversales';
                                textelement(asignacion_tema_tranversal)
                                {
                                    MaxOccurs = Unbounded;
                                    MinOccurs = Once;
                                    XmlName = 'Asignacion_Tema_Tranversal';
                                    textelement(tema_tranversal)
                                    {
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                        TextType = Text;
                                        XmlName = 'Tema_Tranversal';
                                    }
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    currXMLport.Skip;
                                end;
                            }

                            trigger OnBeforePassVariable()
                            var
                                lrCommentLine: Record "Comment Line";
                            begin


                                Derechos_de_Autor := Format(Item."Derecho de autor", 0, 9);
                                Pais := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"País", Item."Country/Region of Origin Code", false);

                                Edicion := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Edición", Item.Edicion, false);
                                Edicion := GetTexMaxErr(Edicion, 10, Item.FieldCaption(Edicion));

                                Estado := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::Estado, Item.Estado, false);
                                Estado := GetTexMaxErr(Estado, 10, Item.FieldCaption(Estado));

                                Nivel_Escolar := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Nivel Escolar", Item."Nivel Escolar (Grado)", false);
                                Nivel_Escolar := GetTexMaxErr(Nivel_Escolar, 10, Item.FieldCaption("Nivel Escolar (Grado)"));

                                SePrecioVta(Today);

                                Observaciones := '';
                                Clear(lrCommentLine);
                                lrCommentLine.SetRange("Table Name", lrCommentLine."Table Name"::Item);
                                lrCommentLine.SetRange("No.", Item."No.");
                                if lrCommentLine.FindLast then
                                    Observaciones := GettTextSnt(lrCommentLine.Comment);


                                Fecha_Almacen := DateFormatXML(Item."Fecha Almacen");
                                Fecha_Comercializacion := DateFormatXML(Item."Fecha Comercializacion");
                            end;
                        }
                        textelement(locales)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Zero;
                            XmlName = 'Locales';
                            textelement(locales_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(locales_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(entrega_biblioteca_nacional)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Entrega_Biblioteca_Nacional';
                            }

                            trigger OnBeforePassVariable()
                            begin
                                currXMLport.Skip;
                            end;
                        }
                        textelement(locales_espec)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Zero;
                            XmlName = 'Locales_ESPEC';
                            textelement(locales_espec_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(locales_espec_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(locales_espec_sociedad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Sociedad';
                            }
                            textelement(fecha_limite_comercializaci)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Fecha_Limite_Comercializacion';
                            }
                            textelement(prefijo_volumen)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'Prefijo_Volumen';
                            }
                            textelement(prefijo_libro)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                XmlName = 'Prefijo_Libro';
                            }

                            trigger OnBeforePassVariable()
                            begin
                                currXMLport.Skip;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            lwValor: Code[20];
                        begin

                            Titulo := GettTextSnt(Item.Description);
                            Titulo_Corto := GettTextSnt(GetTexMax(Item."Description 2", 40));
                            ISBN := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::ISBN, Item.ISBN, false);
                            ISBN := GetTexMaxErr(ISBN, 13, Item.FieldCaption(ISBN));

                            // Este valor no está incluido en Navision por lo que ha de estar configurados por defecto
                            if ISBN = '' then
                                lwValor := 'NO'
                            else
                                lwValor := 'SI';
                            ISBN_Tramitado := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"ISBN Tramitado", lwValor, wObligaCampos); // Es obligado

                            EAN := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::EAN, cFunMdM.GetEAN(Item), false);
                            EAN := GetTexMaxErr(EAN, 13, Text002);

                            Sello := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::Sello, Item.Sello, false);
                            Sello := GetTexMaxErr(Sello, 10, Item.FieldCaption(Sello));

                            Idioma := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::Idioma, Item.Idioma, false);
                            Idioma := GetTexMaxErr(Idioma, 10, Item.FieldCaption(Idioma));

                            Autor := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::Autor, Item.Autor, false);
                            Autor := GetTexMaxErr(Autor, 10, Item.FieldCaption(Autor));
                            if Autor <> '' then begin
                                Autor_Catalogo := Format(true);
                                Tipo_Autoria := '000002'; // A piñon
                            end
                            else begin
                                Autor_Catalogo := '';
                                Tipo_Autoria := '';
                            end;

                            if Item."No. Paginas" = 0 then begin
                                if EsPapel then // Si es Papel se convierte en obligatorio, devolvemos 1
                                    Paginas := DecFormatXMLDef(1);
                            end
                            else
                                Paginas := DecFormatXMLDef(Item."No. Paginas");

                            SetUnid(Item."No.", Item."Base Unit of Measure");

                            // Dimensiones
                            Serie_Metodo := GetDim(0);
                            Destino := GetDim(1);
                            Cuenta := GetDim(2);
                            Tipo_Texto := GetDim(3);
                            Materia := GetDim(4);
                            Carga_Horaria := GetDim(5);
                            Origen := GetDim(6);
                        end;
                    }
                }
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(wSopPapel; wSopPapel)
                {
                ApplicationArea = All;
                    Caption = 'Soporte Papel';
                    TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Soporte),
                                                              Bloqueado = CONST(false));
                    ToolTip = 'Código Soporte que corresponde a "Papel" para discriminar la información de ciertos campos';
                }
                field(wTipSLIC; wTipSLIC)
                {
                ApplicationArea = All;
                    Caption = 'Tipología SLIC';
                    TableRelation = "Item Category" WHERE(Bloqueado = CONST(false));
                    ToolTip = 'Código de Tipologia que corresponde a SLIC para discriminar la información de determinados campos';
                }
                field(wTipSDIG; wTipSDIG)
                {
                ApplicationArea = All;
                    Caption = 'Tipología SDIG';
                    TableRelation = "Item Category" WHERE(Bloqueado = CONST(false));
                    ToolTip = 'Código de Tipologia que corresponde a SDIG para discriminar la información de determinados campos';
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        wObligaCampos := false; // Refiere a si obliga o no a que campos no requeridos estén debidamente configurados en la tabla de conversión
    end;

    trigger OnPreXmlPort()
    begin

        rConfMdM.Get;
        rConfMdM.TestField("VAT Bus. Posting Group");
        rConfMdM.TestField("Divisa Local MdM");

        // Valores no incluidos en Navision que han de estar configurados por defecto
        Encuadernacion := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Encuadernación", '', wObligaCampos);
        Con_Solapas := BolFormatXML(false); //Booleano sin marcar
                                            // La fecha de alta con el que se van a cargar en el MdM los productos que se migren de NAV, será a uno del mes en el que se lance el proceso de migración
                                            // Fecha_Alta        := FORMAT(CALCDATE('<CM>', TODAY));

        /*
        FormatoDigital    := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Formato Digital",'', wObligaCampos);
        PesoDigitalUnidad := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Peso Digital Unidad",'', wObligaCampos);
        PesoDigitalValor  := '0';
        TipoProteccion    := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Tipo Protección",'', wObligaCampos);
        */

        Vendible := BolFormatXML(true); // Este valor siempre será True.

        // Se reporta 01/01/2016 a piñon
        // Fecha_Estado      := FORMAT(010116D);
        // Se reporta 1/12/2017 a piñon
        Fecha_Estado := DateFormatXML(20171201D);
        Fecha_Alta := DateFormatXML(20171201D);

        // Moneda
        Vida_Util := rConvNavMdM.GetNav2MdM(rConvNavMdM."Tipo Registro"::"Vida util", '', wObligaCampos);
        Moneda := rConfMdM."Divisa Local MdM";

    end;

    var
        rConfMdM: Record "Configuracion MDM";
        rConvNavMdM: Record "Conversion NAV MdM";
        VatSetup: Record "VAT Posting Setup";
        cFunMdM: Codeunit "Funciones MdM";
        Text001: Label 'La longitud de %1 No puede ser superior a %2 en Producto %3';
        Text002: Label 'EAN';
        Text003: Label 'Articulo Pack';
        cGestMdm: Codeunit "Gest. Maestros MdM";
        wObligaCampos: Boolean;
        wSopPapel: Code[10];
        wTipSLIC: Code[10];
        wTipSDIG: Code[10];


    procedure DateFormatXML(plval: Date): Text
    begin
        // DateFormatXML

        exit(Format(plval, 0, 9));
    end;


    procedure DecFormatXML(plval: Decimal): Text
    begin
        // DecFormatXML

        exit(Format(plval, 0, 9));
    end;


    procedure DecFormatXMLDef(plval: Decimal) wResult: Text
    begin
        // DecFormatXMLDef

        if plval = 0 then
            plval := 99; // Valor por defecto

        exit(DecFormatXML(plval));
    end;


    procedure BolFormatXML(pwBol: Boolean) wVal: Text
    begin
        // BolFormatXML

        //EXIT(FORMAT(pwBol,0,9));
        exit(Format(pwBol));
    end;


    procedure GetTexMax(pwText: Text; pwMax: Integer) wResult: Text
    begin
        // GetTexMax

        if StrLen(pwText) > pwMax then
            wResult := CopyStr(pwText, 1, pwMax)
        else
            wResult := pwText;
    end;


    procedure GetTexMaxErr(pwText: Text; pwMax: Integer; pwFieldName: Text) wResult: Text
    begin
        // GetTexMaxErr


        if StrLen(pwText) > pwMax then
            Error(Text001, pwFieldName, pwMax, Item."No.")
        else
            wResult := pwText;
    end;


    procedure GetDim(pwId: Integer) wValue: Text
    var
        lwId2: Integer;
    begin
        // GetDim

        lwId2 := 0;
        case pwId of // Id del tipo de conversion
            0:
                lwId2 := 7;
            1:
                lwId2 := 14;
            2:
                lwId2 := 15;
            3:
                lwId2 := 17;
            4:
                lwId2 := 18;
            5:
                lwId2 := 20;
            6:
                lwId2 := 21;
        end;

        wValue := cFunMdM.GetDimValueT(Item."No.", pwId); // Devuelve el valor de la dimension
        wValue := rConvNavMdM.GetNav2MdM(lwId2, wValue, false); // Mira si hay alguna conversión a MdM
        wValue := GetTexMaxErr(wValue, 10, cFunMdM.GetDimNameField(pwId)); // Limita la longitud máxima
    end;


    procedure SetUnid(pwItemNo: Code[20]; pwCodUnidadBase: Code[10])
    var
        lrUnid: Record "Item Unit of Measure";
    begin
        // SetUnid

        Ancho := '';
        Alto := '';
        Peso := '';

        if pwItemNo = '' then
            exit;

        Clear(lrUnid);
        if not lrUnid.Get(pwItemNo, pwCodUnidadBase) then
            lrUnid.Init;

        Ancho := DecFormatXMLDef(lrUnid.Width);
        Alto := DecFormatXMLDef(lrUnid.Height);
        Peso := DecFormatXMLDef(lrUnid.Weight);

        // Valores por defecto Que ha de informar si es Papel
        if EsPapel then begin
            if lrUnid.Width = 0 then
                Ancho := DecFormatXMLDef(1);
            if lrUnid.Height = 0 then
                Alto := DecFormatXMLDef(1);
        end;
    end;


    procedure SePrecioVta(pwFecha: Date) wEnc: Boolean
    var
        lrPrec: Record "Price List Line";
        lwPrecioConImp: Decimal;
        lwPrecioSinImp: Decimal;
        lwDivisa: Code[10];
    begin
        // SePrecioVta

        Clear(lwPrecioConImp);
        Clear(lwPrecioSinImp);

        /*
        CLEAR(VatSetup);
        CLEAR(lrPrec);
        lrPrec.SETRANGE("Item No.", Item."No.");
        //lrPrec.SETRANGE("Sales Type", lrPrec."Sales Type"::"Customer Price Group");
        lrPrec.SETRANGE("Sales Type", lrPrec."Sales Type"::"All Customers");
        lrPrec.SETFILTER("Currency Code", '%1', '');
        lrPrec.SETRANGE("Unit of Measure Code", Item."Base Unit of Measure");
        lrPrec.SETFILTER("Starting Date", '<=%1', pwFecha);
        lrPrec.SETFILTER("Ending Date",'>%1|%2', pwFecha,0D);
        wEnc := lrPrec.FINDLAST;
        IF NOT wEnc  THEN BEGIN
          lrPrec.SETRANGE("Sales Type", lrPrec."Sales Type"::"Customer Price Group");
          wEnc := lrPrec.FINDLAST;
        END;
        IF wEnc THEN BEGIN
          IF lrPrec."VAT Bus. Posting Gr. (Price)" <> '' THEN
            VatSetup.SETRANGE("VAT Bus. Posting Group", lrPrec."VAT Bus. Posting Gr. (Price)")
          ELSE IF Item."VAT Bus. Posting Gr. (Price)" <> '' THEN
            VatSetup.SETRANGE("VAT Bus. Posting Group", Item."VAT Bus. Posting Gr. (Price)")
          ELSE
            VatSetup.SETRANGE("VAT Bus. Posting Group", rConfMdM."VAT Bus. Posting Group");
          VatSetup.SETRANGE("VAT Prod. Posting Group", Item."VAT Prod. Posting Group");
          IF NOT VatSetup.FINDFIRST THEN
            CLEAR(VatSetup);
        
          IF lrPrec."Price Includes VAT" THEN BEGIN
            lwPrecioConImp := lrPrec."Unit Price";
            lwPrecioSinImp := lwPrecioConImp / (1 + VatSetup."VAT %");
          END
          ELSE BEGIN
            lwPrecioSinImp := lrPrec."Unit Price";
            lwPrecioConImp := lwPrecioSinImp * (1 + VatSetup."VAT %");
          END;
        END;
        */

        wEnc := cGestMdm.GetPrecioVta(Item, pwFecha, lwPrecioConImp, lwPrecioSinImp, lwDivisa);

        if lwPrecioSinImp <> 0 then begin
            Precio_con_Impuestos := DecFormatXML(Round(lwPrecioConImp));
            Precio_sin_Impuestos := DecFormatXML(Round(lwPrecioSinImp));
        end;

    end;


    procedure AsegDato(pwDato: Text)
    begin
        // AsegDato

        if DelChr(pwDato, '<>') = '' then
            currXMLport.Skip;
    end;


    procedure AsegDatoDec(pwDato: Decimal)
    begin
        // AsegDatoDec

        if pwDato = 0 then
            currXMLport.Skip;
    end;


    procedure AsegDatoDate(pwDato: Date)
    begin
        // AsegDatoDate

        if pwDato = 0D then
            currXMLport.Skip;
    end;


    procedure GettTextSnt(pwDato: Text) Result: Text
    begin
        // GettTextSnt

        pwDato := DelChr(pwDato, '<>');
        Result := pwDato;
        if Result <> '' then
            Result := StrSubstNo('![CDATA[%1]]', Result);
        //Result := STRSUBSTNO('<![CDATA[%1]]>', Result);
    end;


    procedure EsPapel() Result: Boolean
    begin
        // wEsPapel
        // Devuelve true si el codgio Soporte corresponde a Papel

        Result := false;
        if wSopPapel = '' then
            exit;

        Result := wSopPapel = Item.Soporte;
    end;


    procedure EsTipSlicSdig() Result: Boolean
    begin
        // EsTipSlicSdig

        Result := false;

        if wTipSLIC <> '' then begin
            if Item."Item Category Code" = wTipSLIC then
                Result := true;
        end;

        if wTipSDIG <> '' then begin
            if Item."Item Category Code" = wTipSDIG then
                Result := true;
        end;
    end;
}

