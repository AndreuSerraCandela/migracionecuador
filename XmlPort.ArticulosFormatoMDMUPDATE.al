xmlport 75001 "Articulos_Formato_MDM - UPDATE"
{
    // --------------------------------------------------------------------------------
    // -- XMLport automatically created with Dynamics NAV XMLport Generator 1.3.0.2
    // -- Copyright ’ 2007-2012 Carsten Scholling
    // --------------------------------------------------------------------------------
    // // Nos interesa insertar solo los campos de los valores informados. Que pueden venir en blanco. Para ello utilizamos la matriz wInstFld

    UseDefaultNamespace = true;

    schema
    {
        textelement(mensaje)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            XmlName = 'mensaje';
            tableelement(tmpcab; "Imp.MdM Cabecera")
            {
                MaxOccurs = Once;
                MinOccurs = Once;
                XmlName = 'head';
                UseTemporary = true;
                textelement(id_mensaje)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'id_mensaje';
                }
                textelement(sistema_origen)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'sistema_origen';
                }
                textelement(pais_origen)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'pais_origen';
                }
                textelement(fecha_origen)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'fecha_origen';
                }
                textelement(fecha)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'fecha';
                }
                textelement(tipo)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    TextType = Text;
                    XmlName = 'tipo';
                }
                textelement(error)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'error';
                    textelement(code)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'code';
                    }
                    textelement(level)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'level';
                    }
                    textelement(description)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'description';
                    }
                }
                fieldelement(num_reintentos; TmpCab."Attempt No")
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                var
                    lwOK: Boolean;
                begin

                    lwOK := Evaluate(TmpCab."Fecha Creacion", fecha_origen);
                    lwOK := Evaluate(TmpCab.fecha, fecha);
                    cGestM.SetDatosCab(id_mensaje, sistema_origen, pais_origen, TmpCab."Fecha Creacion", TmpCab.fecha, tipo);
                end;
            }
            textelement(body)
            {
                MaxOccurs = Once;
                MinOccurs = Once;
                XmlName = 'body';
                textelement(tablas_referencia)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Tablas_Referencia';
                    textelement(paises)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Paises';
                        textelement(item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(9, 0, pk_Code, item_Code, Valor_ES, 'Paises', Visible);
                            end;
                        }
                    }
                    textelement(tipologias)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Tipologias';
                        textelement(tipologias_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tipologias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(5722, 0, item_pk_Code, Tipologias_item_Code, item_Valor_ES, 'Tipologias', item_Visible);
                            end;
                        }
                    }
                    textelement(isbn_tramitado)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'ISBN_Tramitado';
                        textelement(isbn_tramitado_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(isbn_tramitado_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(isbn_tramitado_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(isbn_tramitado_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(isbn_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(isbn_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(isbn_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(isbn_tramitado_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 9, ISBN_Tramitado_item_pk_Code, ISBN_Tramitado_item_Code, ISBN_item_Valor_ES, 'ISBN_Tramitado', ISBN_Tramitado_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(tipos_productos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Tipos_Productos';
                        textelement(tipos_productos_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(tipos_productos_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(tipo_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tipos_productos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(tipo_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(tipo_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(tipo_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(tipo_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 0, Tipo_item_pk_Code, Tipos_Productos_item_Code, Tipo_item_Valor_ES, 'Tipos_Productos', Tipo_item_Visible);
                            end;
                        }
                    }
                    textelement(soportes)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Soportes';
                        textelement(soportes_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(soportes_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(soportes_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(soportes_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(soportes_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(soportes_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(soportes_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(soportes_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 1, Soportes_item_pk_Code, Soportes_item_Code, Soportes_item_Valor_ES, 'Soportes', Soportes_item_Visible);
                            end;
                        }
                    }
                    textelement(encuadernaciones)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Encuadernaciones';
                        textelement(encuadernaciones_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(encuadernaciones_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(encu_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(encuadernaciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(encu_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(encu_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(encu_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(encu_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 2, Encu_item_pk_Code, Encuadernaciones_item_Code, Encu_item_Valor_ES, 'Encuadernaciones', Encu_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(datos_tecnicos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Datos_Tecnicos';
                        textelement(datos_tecnicos_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(datos_tecnicos_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(datos_tecnicos_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(datos_tecnicos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(dato_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(dato_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(dato_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(datos_tecnicos_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 1, Datos_Tecnicos_item_pk_Code, Datos_Tecnicos_item_Code, Dato_item_Valor_ES, 'Datos_Tecnicos', Datos_Tecnicos_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(sociedades)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Sociedades';
                        textelement(sociedades_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(sociedades_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(sociedades_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(sociedades_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(sociedades_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(sociedades_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(sociedades_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(sociedades_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 2, Sociedades_item_pk_Code, Sociedades_item_Code, Sociedades_item_Valor_ES, 'Sociedades', Sociedades_item_Visible);
                            end;
                        }
                    }
                    textelement(lineas)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Lineas';
                        textelement(lineas_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(lineas_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(lineas_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(lineas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(lineas_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(lineas_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(lineas_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(lineas_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 7, Lineas_item_pk_Code, Lineas_item_Code, Lineas_item_Valor_ES, 'Lineas', Lineas_item_Visible);
                            end;
                        }
                    }
                    textelement(sellos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Sellos';
                        textelement(sellos_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(sellos_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(sellos_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(sellos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(sellos_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(sellos_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(sellos_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(sellos_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }
                            textelement(linea)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Linea';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 10, Sellos_item_pk_Code, Sellos_item_Code, Sellos_item_Valor_ES, 'Sellos', Sellos_item_Visible);
                            end;
                        }
                    }
                    textelement(ibic)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'IBIC';
                        textelement(ibic_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(ibic_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(ibic_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(ibic_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(ibic_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(ibic_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(ibic_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(ibic_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 10, IBIC_item_pk_Code, IBIC_item_Code, IBIC_item_Valor_ES, 'IBIC', IBIC_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(idiomas)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Idiomas';
                        textelement(idiomas_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(idiomas_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(idiomas_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(idiomas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(idiomas_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(idiomas_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(idiomas_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(idiomas_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(8, 0, Idiomas_item_pk_Code, Idiomas_item_Code, Idiomas_item_Valor_ES, 'Idiomas', Idiomas_item_Visible);
                            end;
                        }
                    }
                    textelement(obras_proyectos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Obras_Proyectos';
                        textelement(obras_proyectos_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(obras_proyectos_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(obra_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(obras_proyectos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(obra_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(obra_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(obra_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(obra_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 11, Obra_item_pk_Code, Obras_Proyectos_item_Code, Obra_item_Valor_ES, 'Obras_Proyectos', Obra_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(series_metodos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Series_Metodos';
                        textelement(series_metodos_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(series_metodos_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(series_metodos_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(series_metodos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(seri_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(seri_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(seri_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(code_linea)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code_Linea';
                            }
                            textelement(series_metodos_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Serie
                                AddMstReg(349, -200, Series_Metodos_item_pk_Code, Series_Metodos_item_Code, Seri_item_Valor_ES, 'Series_Metodos', Series_Metodos_item_Visible);
                            end;
                        }
                    }
                    textelement(ficheros_digitales_asociado)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Ficheros_Digitales_Asociados';
                        textelement(fich_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(fich_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(fich_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(fich_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(fich_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(fich_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(fich_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(fich_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 12, Fich_item_pk_Code, Fich_item_Code, Fich_item_Valor_ES, 'Ficheros_Digitales_Asociados', Fich_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(autores)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Autores';
                        textelement(autores_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(autores_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(code_autor)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code_Autor';
                                }
                            }
                            textelement(item_code_autor)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code_Autor';
                            }
                            textelement(nombre)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Nombre';
                            }
                            textelement(nombre_literario)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Nombre_Literario';
                            }
                            textelement(identificacion)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Identificacion';
                            }
                            textelement(identificacion_nula)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Identificacion_Nula';
                            }
                            textelement(direccion)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Direccion';
                            }
                            textelement(ciudad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Ciudad';
                            }
                            textelement(autores_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(dominio_publico)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Dominio_Publico';
                            }
                            textelement(biografia)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Biografia';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 5, Code_Autor, item_Code_Autor, Nombre_Literario, 'Autores', '');
                            end;
                        }
                    }
                    textelement(asignacion_autores_correos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Asignacion_Autores_Correos';
                        textelement(asig_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(asig_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(pk_code_autor)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code_Autor';
                                }
                                textelement(correo)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Zero;
                                    TextType = Text;
                                    XmlName = 'Correo';
                                }
                            }
                            textelement(asig_item_code_autor)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code_Autor';
                            }
                            textelement(item_correo)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Correo';
                            }
                        }
                    }
                    textelement(tipos_autorias)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Tipos_Autorias';
                        textelement(tipos_autorias_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(tipos_autorias_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(tipos_autorias_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tipos_autorias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(tabl_tipo_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(tabl_tipo_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(tabl_tipo_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(tipos_autorias_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                //AddMstReg(75009, 0, Tipos_Autorias_item_pk_Code, Tipos_Autorias_item_Code, Tabl_Tipo_item_Valor_ES, 'Tipos_Autorias', Tipos_Autorias_item_Visible);
                                AddMstReg(-1, 29, Tipos_Autorias_item_pk_Code, Tipos_Autorias_item_Code, Tabl_Tipo_item_Valor_ES, 'Tipos_Autorias', Tipos_Autorias_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(formatos_digitales)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Formatos_Digitales';
                        textelement(formatos_digitales_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(formatos_digitales_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(form_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(form_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(form_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(form_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(form_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(form_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 12, Form_item_pk_Code, Form_item_Code, Form_item_Valor_ES, 'Formatos_Digitales', Form_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(peso_digital_unidades)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Peso_Digital_Unidades';
                        textelement(peso_digital_unidades_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(peso_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(peso_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(peso_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(peso_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(peso_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(peso_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(peso_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 14, Peso_item_pk_Code, Peso_item_Code, Peso_item_Valor_ES, 'Peso_Digital_Unidades', Peso_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(tipos_proteccion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Tipos_Proteccion';
                        textelement(tipos_proteccion_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(tipos_proteccion_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(tabl_tipo_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tipos_proteccion_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(body_tabl_tipo_item_valor_e)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(body_tabl_tipo_item_valor_e1)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(body_tabl_tipo_item_valor_p)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(tabl_tipo_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 6, Tabl_Tipo_item_pk_Code, Tipos_Proteccion_item_Code, body_Tabl_Tipo_item_Valor_E, 'Tipos_Proteccion', Tabl_Tipo_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(tipos_url)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Tipos_URL';
                        textelement(tipos_url_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(tipos_url_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(tipos_url_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tipos_url_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(tipos_url_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(tipos_url_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(tipos_url_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(tipos_url_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 15, Tipos_URL_item_pk_Code, Tipos_URL_item_Code, Tipos_URL_item_Valor_ES, 'Tipos_URL', Tipos_URL_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(posicion_premio)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Posicion_Premio';
                        textelement(posicion_premio_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(posicion_premio_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(posi_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(posicion_premio_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(posi_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(posi_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(posi_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(posi_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 16, Posi_item_pk_Code, Posicion_Premio_item_Code, Posi_item_Valor_ES, 'Posicion_Premio', Posi_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(planes_editoriales)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Planes_Editoriales';
                        textelement(planes_editoriales_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(planes_editoriales_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(plan_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(plan_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(plan_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(plan_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(plan_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(plan_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 4, Plan_item_pk_Code, Plan_item_Code, Plan_item_Valor_ES, 'Planes_Editoriales', Plan_item_Visible);
                            end;
                        }
                    }
                    textelement(campanias)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Campanias';
                        textelement(campanias_item)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(campanias_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(campanias_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(campanias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(campanias_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(campanias_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(campanias_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(campanias_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                //AddMstReg(-1, 17, Campanias_item_pk_Code,  Campanias_item_Code, Campanias_item_Valor_ES, 'Campanias', Campanias_item_Visible); // No aplica
                                AddMstReg(75001, 13, Campanias_item_pk_Code, Campanias_item_Code, Campanias_item_Valor_ES, 'Campanias', Campanias_item_Visible);
                            end;
                        }
                    }
                    textelement(ediciones)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Ediciones';
                        textelement(ediciones_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(ediciones_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(ediciones_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(ediciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(ediciones_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(ediciones_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(ediciones_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(ediciones_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 11, Ediciones_item_pk_Code, Ediciones_item_Code, Ediciones_item_Valor_ES, 'Ediciones', Ediciones_item_Visible);
                            end;
                        }
                    }
                    textelement(derechos_autor)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Derechos_Autor';
                        textelement(derechos_autor_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(derechos_autor_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(derechos_autor_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(derechos_autor_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(dere_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(dere_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(dere_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(derechos_autor_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 7, Derechos_Autor_item_pk_Code, Derechos_Autor_item_Code, Dere_item_Valor_ES, 'Derechos_Autor', Derechos_Autor_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(cuentas)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Cuentas';
                        textelement(cuentas_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(cuentas_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(cuentas_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                                textelement(pk_pais)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Pais';
                                }
                            }
                            textelement(cuentas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(cuentas_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(cuentas_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(cuentas_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(cuentas_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(cuentas_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Cuentas
                                AddMstReg(349, -202, Cuentas_item_pk_Code, Cuentas_item_Code, Cuentas_item_Valor_ES, 'Cuentas', Cuentas_item_Visible);
                            end;
                        }
                    }
                    textelement(estructura_analitica)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Estructura_Analitica';
                        textelement(estructura_analitica_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(estr_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(estr_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(estr_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(estr_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(estr_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(estr_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(estr_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75002, 0, Estr_item_pk_Code, Estr_item_Code, Estr_item_Valor_ES, 'Estructura_Analitica', Estr_item_Visible);
                            end;
                        }
                    }
                    textelement(estados)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Estados';
                        textelement(estados_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(estados_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(estados_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(estados_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(estados_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(estados_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(estados_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(estados_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 12, Estados_item_pk_Code, Estados_item_Code, Estados_item_Valor_ES, 'Estados', Estados_item_Visible);
                            end;
                        }
                    }
                    textelement(tipos_relaciones)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Tipos_Relaciones';
                        textelement(tipos_relaciones_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(tipos_relaciones_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(body_tabl_tipo_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tipos_relaciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(body_tabl_tipo_item_valor_e2)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(body_tabl_tipo_item_valor_e3)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(body_tabl_tipo_item_valor_p1)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(body_tabl_tipo_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 18, body_Tabl_Tipo_item_pk_Code, Tipos_Relaciones_item_Code, body_Tabl_Tipo_item_Valor_E2, 'Tipos_Relaciones', body_Tabl_Tipo_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(tipo_texto)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Tipo_Texto';
                        textelement(tipo_texto_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(tipo_texto_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(tipo_texto_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tipo_texto_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(tipo_texto_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(tipo_texto_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(tipo_texto_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(tipo_texto_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Tipo Texto
                                AddMstReg(349, -203, Tipo_Texto_item_pk_Code, Series_Metodos_item_Code, Tipo_Texto_item_Valor_ES, 'Tipo_Texto', Tipo_Texto_item_Visible);
                            end;
                        }
                    }
                    textelement(materia_global)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Materia_Global';
                        textelement(materia_global_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(materia_global_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(materia_global_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(materia_global_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(mate_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(mate_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(mate_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(materia_global_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 5, Materia_Global_item_pk_Code, Materia_Global_item_Code, Mate_item_Valor_ES, 'Materia_Global', Materia_Global_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(tipo_materia)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Tipo_Materia';
                        textelement(tipo_materia_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(tipo_materia_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(tipo_materia_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tipo_materia_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(tipo_materia_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(tipo_materia_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(tipo_materia_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(tipo_materia_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 4, Tipo_Materia_item_pk_Code, Tipo_Materia_item_Code, Tipo_Materia_item_Valor_ES, 'Tipo_Materia', Tipo_Materia_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(asignaturas)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Asignaturas';
                        textelement(asignaturas_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(asignaturas_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(asignaturas_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                                textelement(item_pk_pais)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Zero;
                                    TextType = Text;
                                    XmlName = 'Pais';
                                }
                            }
                            textelement(asignaturas_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(asignaturas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(asignaturas_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(asignaturas_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(asignaturas_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(code_materia_global)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code_Materia_Global';
                            }
                            textelement(code_tipo_materia)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code_Tipo_Materia';
                            }
                            textelement(asignaturas_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 8, Asignaturas_item_pk_Code, Asignaturas_item_Code, Asignaturas_item_Valor_ES, 'Asignaturas', Asignaturas_item_Visible);
                            end;
                        }
                    }
                    textelement(materias)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Materias';
                        textelement(materias_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(materias_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(materias_item_pk_pais)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Pais';
                                }
                                textelement(materias_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(materias_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(materias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(materias_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(materias_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(materias_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(code_asignatura)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code_Asignatura';
                            }
                            textelement(materias_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(349, -204, Materias_item_pk_Code, Materias_item_Code, Materias_item_Valor_ES, 'Materias', Materias_item_Visible);
                            end;
                        }
                    }
                    textelement(destinos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Destinos';
                        textelement(destinos_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(destinos_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(destinos_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(destinos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(destinos_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(destinos_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(destinos_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(destinos_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Destino
                                AddMstReg(349, -201, Destinos_item_pk_Code, Destinos_item_Code, Destinos_item_Valor_ES, 'Destinos', Destinos_item_Visible);
                            end;
                        }
                    }
                    textelement(temas_transversales)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Temas_Transversales';
                        textelement(temas_transversales_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(temas_transversales_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(tema_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tema_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(tema_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(tema_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(tema_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(tema_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 8, Tema_item_pk_Code, Tema_item_Code, Tema_item_Valor_ES, 'Temas_Transversales', Tema_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(niveles_globales)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Niveles_Globales';
                        textelement(niveles_globales_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(niveles_globales_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(nive_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(niveles_globales_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(nive_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(nive_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(nive_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(nive_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // AddMstReg(75001, 10, Nive_item_pk_Code, Niveles_Globales_item_Code, Nive_item_Valor_ES, 'Niveles_Globales', Nive_item_Visible);
                                AddMstReg(-1, 3, Nive_item_pk_Code, Niveles_Globales_item_Code, Nive_item_Valor_ES, 'Niveles_Globales', Nive_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(niveles)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Niveles';
                        textelement(niveles_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(niveles_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(niveles_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Zero;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                                textelement(niveles_item_pk_pais)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Zero;
                                    TextType = Text;
                                    XmlName = 'Pais';
                                }
                            }
                            textelement(niveles_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(niveles_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(code_nivel_global)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code_Nivel_Global';
                            }
                            textelement(niveles_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(niveles_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(niveles_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(niveles_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 3, Niveles_item_pk_Code, Niveles_item_Code, Niveles_item_Valor_ES, 'Niveles', Niveles_item_Visible);
                            end;
                        }
                    }
                    textelement(ciclos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Ciclos';
                        textelement(ciclos_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(ciclos_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(ciclos_item_pk_pais)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Zero;
                                    TextType = Text;
                                    XmlName = 'Pais';
                                }
                                textelement(ciclos_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Zero;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(ciclos_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(ciclos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(code_nivel)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code_Nivel';

                                trigger OnAfterAssignVariable()
                                begin
                                    SetInsField(1); // Marcamos que ha pasado por aqui
                                end;
                            }
                            textelement(ciclos_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(ciclos_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(ciclos_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(ciclos_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 6, Ciclos_item_pk_Code, Ciclos_item_Code, Ciclos_item_Valor_ES, 'Ciclos', Ciclos_item_Visible);
                                AddMstRegField(4, Code_Nivel, 'Nivel', 1);
                                Clear(wInstFld);
                            end;
                        }
                    }
                    textelement(cursos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Cursos';
                        textelement(cursos_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(cursos_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(cursos_item_pk_pais)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Zero;
                                    TextType = Text;
                                    XmlName = 'Pais';
                                }
                                textelement(cursos_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(cursos_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(cursos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(code_ciclo)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code_Ciclo';

                                trigger OnAfterAssignVariable()
                                begin
                                    SetInsField(1); // Marcamos que ha pasado por aqui
                                end;
                            }
                            textelement(cursos_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(cursos_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(cursos_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(edad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Edad';
                            }
                            textelement(cursos_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 9, Cursos_item_pk_Code, Cursos_item_Code, Cursos_item_Valor_ES, 'Cursos', Cursos_item_Visible);
                                AddMstRegField(4, Code_Ciclo, 'Ciclo', 1);
                                Clear(wInstFld);
                            end;
                        }
                    }
                    textelement(trimestres_creditos)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Trimestres_Creditos';
                        textelement(trimestres_creditos_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(trimestres_creditos_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(trim_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(trim_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(trim_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(trim_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(trim_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(trim_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 19, Trim_item_pk_Code, Trim_item_Code, Trim_item_Valor_ES, 'Trimestres_Creditos', Trim_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(cargas_horarias)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Cargas_Horarias';
                        textelement(cargas_horarias_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(cargas_horarias_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(carg_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(cargas_horarias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(carg_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(carg_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(carg_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(carg_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Carga Horaria
                                AddMstReg(349, -205, Carg_item_pk_Code, Cargas_Horarias_item_Code, Carg_item_Valor_ES, 'Cargas_Horarias', Carg_item_Visible);
                            end;
                        }
                    }
                    textelement(common_european)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Common_European';
                        textelement(common_european_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(common_european_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(comm_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(common_european_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(comm_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(comm_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(comm_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(comm_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 20, Comm_item_pk_Code, Common_European_item_Code, Comm_item_Valor_ES, 'Common_European', Comm_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(origenes)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Origenes';
                        textelement(origenes_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(origenes_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(origenes_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(origenes_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(origenes_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(origenes_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(origenes_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(origenes_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Origen
                                AddMstReg(349, -206, Origenes_item_pk_Code, Origenes_item_Code, Origenes_item_Valor_ES, 'Origenes', Origenes_item_Visible);
                            end;
                        }
                    }
                    textelement(monedas)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Monedas';
                        textelement(monedas_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(monedas_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(monedas_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(monedas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(monedas_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(monedas_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(monedas_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(monedas_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 21, Monedas_item_pk_Code, Monedas_item_Code, Monedas_item_Valor_ES, 'Monedas', Monedas_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(fechas_conmemorativas)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Fechas_Conmemorativas';
                        textelement(fechas_conmemorativas_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(fech_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(fech_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(fech_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(fech_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(fech_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(fech_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(fech_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(item_fecha)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Fecha';
                            }
                            textelement(fech_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 22, Fech_item_pk_Code, Fech_item_Code, Fech_item_Valor_ES, 'Fechas_Conmemorativas', Fech_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(vida_util)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Vida_Util';
                        textelement(vida_util_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(vida_util_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(vida_util_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(vida_util_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(vida_util_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(vida_util_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(vida_util_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(vida_util_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 23, Vida_Util_item_pk_Code, Vida_Util_item_Code, Vida_Util_item_Valor_ES, 'Vida_Util', Vida_Util_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(zonas_geograficas)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Zonas_Geograficas';
                        textelement(zonas_geograficas_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(zonas_geograficas_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(zona_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(zonas_geograficas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(zona_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(zona_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(zona_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(zona_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 24, Zona_item_pk_Code, Zonas_Geograficas_item_Code, Zona_item_Valor_ES, 'Zonas_Geograficas', Zona_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(opciones)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Opciones';
                        textelement(opciones_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(opciones_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(opciones_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(opciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(opciones_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(opciones_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(opciones_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(opciones_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 25, Opciones_item_pk_Code, Opciones_item_Code, Opciones_item_Valor_ES, 'Opciones', Opciones_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(tipos_ediciones)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Tipos_Ediciones';
                        textelement(tipos_ediciones_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(tipos_ediciones_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(mens_body_tabl_tipo_item_pk)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(tipos_ediciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(body_tabl_tipo_item_valor_e4)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(body_tabl_tipo_item_valor_e5)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(body_tabl_tipo_item_valor_p2)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(mens_body_tabl_tipo_item_vi)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 26, mens_body_Tabl_Tipo_item_pk, Tipos_Ediciones_item_Code, body_Tabl_Tipo_item_Valor_E4, 'Tipos_Ediciones', mens_body_Tabl_Tipo_item_Vi); // No aplica
                            end;
                        }
                    }
                    textelement(prefijo_libro)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Prefijo_Libro';
                        textelement(prefijo_libro_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(prefijo_libro_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(prefijo_libro_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(prefijo_libro_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(prefijo_libro_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(prefijo_libro_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(prefijo_libro_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(prefijo_libro_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 27, Prefijo_Libro_item_pk_Code, Prefijo_Libro_item_Code, Prefijo_Libro_item_Valor_ES, 'Prefijo_Libro', Prefijo_Libro_item_Visible); // No aplica
                            end;
                        }
                    }
                    textelement(prefijo_volumen)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'Prefijo_Volumen';
                        textelement(prefijo_volumen_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(prefijo_volumen_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(pref_item_pk_code)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Code';
                                }
                            }
                            textelement(prefijo_volumen_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(pref_item_valor_es)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_ES';
                            }
                            textelement(pref_item_valor_en)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_EN';
                            }
                            textelement(pref_item_valor_pt)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Valor_PT';
                            }
                            textelement(pref_item_visible)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Visible';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 28, Pref_item_pk_Code, Prefijo_Volumen_item_Code, Pref_item_Valor_ES, 'Prefijo_Volumen', Pref_item_Visible); // No aplica
                            end;
                        }
                    }
                }
                textelement(articulos_general)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Articulos_GENERAL';
                    textelement(articulos_general_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(articulos_general_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                        }
                        textelement(item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(tipologia)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Tipologia';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(2); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(titulo_corto)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Titulo_Corto';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(3); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(titulo_catalogo)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Titulo_Catalogo';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(4); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(isbn)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'ISBN';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(5); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(item_isbn_tramitado)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'ISBN_Tramitado';
                        }
                        textelement(ean)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'EAN';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(6); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(tipo_producto)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Tipo_Producto';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(7); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(soporte_del_producto)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Soporte_del_Producto';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(13); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(alto)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Alto';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(8); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(ancho)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Ancho';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(9); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(encuadernacion)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Encuadernacion';
                        }
                        textelement(con_solapas)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Con_Solapas';
                        }
                        textelement(item_datos_tecnicos)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Datos_Tecnicos';
                        }
                        textelement(paginas)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Paginas';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(10); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(peso)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Peso';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(11); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(empresa_editora)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Empresa_Editora';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(12); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(item_linea)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Linea';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(14); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(sello)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Sello';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(15); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(fecha_alta)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Fecha_Alta';
                        }
                        textelement(idioma)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Idioma';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(16); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(idioma_original)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Idioma_Original';
                        }
                        textelement(titulo_original)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Titulo_Original';
                        }
                        textelement(idioma_resumen)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Idioma_Resumen';
                        }
                        textelement(resumen)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Resumen';
                        }
                        textelement(obra_proyecto)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Obra_Proyecto';
                        }
                        textelement(serie_metodo)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Serie_Metodo';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(17); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(orden_serie_metodo)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Orden_Serie_Metodo';
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg2(27, 1, Clave, item_Clave, Titulo_Catalogo, 'Articulos_GENERAL', '', false);

                            AddMstRegField(5702, Tipologia, 'Tipologia', 2);
                            AddMstRegField(3, Titulo_Catalogo, 'Titulo_Catalogo', 4);
                            AddMstRegField(5, Titulo_Corto, 'Titulo_Corto', 3);
                            AddMstRegField(50002, ISBN, 'ISBN', 5);
                            AddMstRegField(-400, EAN, 'EAN', 6); // Virtual
                            AddMstRegField(75001, Tipo_Producto, 'Tipo_Producto', 7);
                            AddMstRegField(75002, Soporte_del_Producto, 'Soporte_del_Producto', 13);
                            AddMstRegField(-101, Ancho, 'Ancho', 9); // Virtual.
                            AddMstRegField(-102, Alto, 'Alto', 8); // Virtual.
                            AddMstRegField(-103, Peso, 'Peso', 11); // Virtual.
                            AddMstRegField(50000, Paginas, 'Paginas', 10);
                            AddMstRegField(75003, Empresa_Editora, 'Empresa_Editora', 12);
                            AddMstRegField(75004, item_Linea, 'item_Linea', 14);
                            AddMstRegField(56010, Sello, 'Sello', 15);
                            AddMstRegField(56013, Idioma, 'Idioma', 16);
                            AddMstRegField(-200, Serie_Metodo, 'Serie_Metodo', 17); // Virtual. Dimension
                            Clear(wInstFld);
                        end;
                    }
                }
                textelement(articulos_espec)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Articulos_ESPEC';
                    textelement(articulos_espec_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(articulos_espec_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(arti_item_pk_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(sociedad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Sociedad';

                                trigger OnAfterAssignVariable()
                                begin
                                    SetInsField(4); // Marcamos que ha pasado por aqui
                                end;
                            }
                        }
                        textelement(articulos_espec_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(articulos_espec_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Pais';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(3); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(item_sociedad)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                        textelement(idioma_resenia)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Idioma_Resenia';
                        }
                        textelement(resenia)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Resenia';
                        }
                        textelement(idioma_titular_promocional)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Idioma_Titular_Promocional';
                        }
                        textelement(titular_promocional)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Titular_Promocional';
                        }
                        textelement(plan_editorial)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Plan_Editorial';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(5); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(campania)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Campania';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(22); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(edicion)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Edicion';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(6); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(derechos_de_autor)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Derechos_de_Autor';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(7); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(destino)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Destino';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(8); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(cuenta)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Cuenta';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(9); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(item_estructura_analitica)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Estructura_Analitica';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(10); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(estado)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Estado';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(11); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(fecha_estado)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Fecha_Estado';
                        }
                        textelement(fecha_almacen)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Fecha_Almacen';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(12); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(fecha_prevista_almacen)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Fecha_Prevista_Almacen';
                        }
                        textelement(fecha_comercializacion)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Fecha_Comercializacion';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(13); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(item_tipo_texto)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Tipo_Texto';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(14); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(asignatura)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Asignatura';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(15); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(materia)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Materia';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(16); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(nivel_escolar)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Nivel_Escolar';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(17); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(bimestre_trimestre)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Bimestre_Trimestre';
                        }
                        textelement(carga_horaria)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Carga_Horaria';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(18); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(common_european_framework)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Common_European_Framework';
                        }
                        textelement(observaciones)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Observaciones';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(21); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(origen)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Origen';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(19); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(vendible)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Vendible';
                        }
                        textelement(precio)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            XmlName = 'Precio';
                            textelement(precio_sin_impuestos)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Precio_sin_Impuestos';

                                trigger OnAfterAssignVariable()
                                begin
                                    SetInsField(20); // Marcamos que ha pasado por aqui
                                end;
                            }
                            textelement(precio_con_impuestos)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Precio_con_Impuestos';
                            }
                            textelement(moneda)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Moneda';
                            }
                        }
                        textelement(edad_interes_desde)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Edad_Interes_Desde';
                        }
                        textelement(edad_interes_hasta)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Edad_Interes_Hasta';
                        }
                        textelement(item_vida_util)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Vida_Util';
                        }
                        textelement(componentes)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Componentes';
                        }

                        trigger OnAfterAssignVariable()
                        var
                            Derechos_de_autor_NAV: Text;
                        begin
                            AddMstReg2(27, 2, pk_Clave, Articulos_ESPEC_item_Clave, Titulo_Catalogo, 'Articulos_ESPEC', '', false);

                            AddMstRegField(95, Articulos_ESPEC_item_Pais, 'Pais', 3);
                            AddMstRegField(75005, Sociedad, 'Sociedad', 4);
                            AddMstRegField(75006, Plan_Editorial, 'Plan_Editorial', 5);
                            AddMstRegField(56007, Edicion, 'Edicion', 6);

                            Derechos_de_autor_NAV := Format(Derechos_de_Autor in ['SI', 'DP']);
                            AddMstRegField(56017, Derechos_de_autor_NAV, 'Derechos_de_autor', 7);

                            AddMstRegField(-201, Destino, 'Destino', 8);  // Virtual. Dimension
                            AddMstRegField(-202, Cuenta, 'Cuenta', 9);  // Virtual. Dimension
                            AddMstRegField(75007, item_Estructura_Analitica, 'Estructura_Analitica', 10);
                            AddMstRegField(56008, Estado, 'Estado', 11);
                            AddMstRegField(75008, Fecha_Almacen, 'Fecha_Almacen', 12);
                            AddMstRegField(75009, Fecha_Comercializacion, 'Fecha_Comercializacion', 13);
                            AddMstRegField(-203, item_Tipo_Texto, 'item_Tipo_Texto', 14);// Virtual. Dimension.
                            AddMstRegField(75010, Asignatura, 'Asignatura', 15);
                            AddMstRegField(-204, Materia, 'Materia', 16); // Virtual. Dimension.
                            AddMstRegField(50005, Nivel_Escolar, 'Nivel_Escolar', 17);
                            AddMstRegField(-205, Carga_Horaria, 'Carga_Horaria', 18);// Virtual. Dimension
                            AddMstRegField(-206, Origen, 'Origen', 19);  // Virtual. Dimension
                            AddMstRegField(-300, Precio_sin_Impuestos, 'Precio_sin_Impuestos', 20);  // Virtual.
                            AddMstRegField(-500, Observaciones, 'Observaciones', 21);  // Virtual.
                            AddMstRegField(75011, Campania, 'Campania', 22);


                            Clear(wInstFld);
                        end;
                    }
                }
                textelement(locales)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Locales';
                    textelement(locales_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(locales_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(locales_item_pk_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                        }
                        textelement(locales_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(locales_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
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
                    }
                }
                textelement(locales_espec)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Locales_ESPEC';
                    textelement(locales_espec_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(locales_espec_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(locales_espec_item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(pk_sociedad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Sociedad';
                            }
                            textelement(locales_espec_item_pk_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                        }
                        textelement(locales_espec_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(locales_espec_item_sociedad)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                        textelement(locales_espec_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            XmlName = 'Pais';
                        }
                        textelement(fecha_limite_comercializaci)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Fecha_Limite_Comercializacion';
                        }
                        textelement(item_prefijo_volumen)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            XmlName = 'Prefijo_Volumen';
                        }
                        textelement(item_prefijo_libro)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            XmlName = 'Prefijo_Libro';
                        }
                    }
                }
                textelement(localizados_es)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Localizados_ES';
                    textelement(localizados_es_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(localizados_es_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(loca_item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(item_pk_sociedad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Sociedad';
                            }
                        }
                        textelement(localizados_es_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(loca_item_sociedad)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                        textelement(fecha_amortizacion)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Fecha_Amortizacion';
                        }
                        textelement(dias_alzado)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Dias_Alzado';
                        }
                        textelement(fecha_necesidad_comercial)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Fecha_Necesidad_Comercial';
                        }
                        textelement(forzar_envio_dilve)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Forzar_Envio_DILVE';
                        }
                        textelement(forzar_envio_precio_cero)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Forzar_Envio_Precio_Cero';
                        }
                        textelement(ordenacion)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Ordenacion';
                        }
                        textelement(ordenacion_manual)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Ordenacion_Manual';
                        }
                        textelement(tipo_edicion)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Tipo_Edicion';
                        }
                        textelement(almacenable)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Almacenable';
                        }
                        textelement(isbn_cedido)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'ISBN_Cedido';
                        }
                        textelement(ean_cedido)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'EAN_Cedido';
                        }
                    }
                }
                textelement(clasificaciones_ibic)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Clasificaciones_IBIC';
                    textelement(clasificaciones_ibic_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(clas_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(clas_item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(pk_ibic)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'IBIC';
                            }
                        }
                        textelement(clas_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(item_ibic)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'IBIC';
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(-1, 30, Clas_item_Clave, '', item_IBIC, 'Clasificaciones_IBIC', ''); // No aplica
                        end;
                    }
                }
                textelement(ficheros_digitales_asociado1)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Ficheros_Digitales_Asociados';
                    textelement(body_fich_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(body_fich_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(tipo_fichero_digital_asocia)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Tipo_Fichero_Digital_Asociado';
                            }
                            textelement(fich_item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                        }
                        textelement(fich_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(tipo_fichero_digital_asocia1)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Tipo_Fichero_Digital_Asociado';
                        }
                        textelement(ficherodigitalasociado)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'FicheroDigitalAsociado';
                        }
                        textelement(ficherodigitalprincipal)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'FicheroDigitalPrincipal';
                        }
                    }

                    trigger OnAfterAssignVariable()
                    begin
                        AddMstReg(-1, 32, Fich_item_Clave, '', FicheroDigitalAsociado, 'Ficheros_Digitales_Asociados', ''); // No aplica
                    end;
                }
                textelement(asignacion_autores)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Asignacion_Autores';
                    textelement(asignacion_autores_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(asignacion_autores_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(asig_item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(autor)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Autor';

                                trigger OnAfterAssignVariable()
                                begin
                                    SetInsField(3); // Marcamos que ha pasado por aqui
                                end;
                            }
                            textelement(tipo_autoria)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Tipo_Autoria';
                            }
                        }
                        textelement(asig_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(item_autor)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Autor';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(2); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(item_tipo_autoria)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Tipo_Autoria';
                        }
                        textelement(autor_catalogo)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Autor_Catalogo';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(1); // Marcamos que ha pasado por aqui
                            end;
                        }

                        trigger OnAfterAssignVariable()
                        begin

                            // Es en realidad una modificación sobre producto
                            // cGestM.AddMstReg2(1, 27, 3, Asig_item_pk_Clave, '', 'Asignacion_Autores', '', FALSE);
                            AddMstReg2(27, 3, Asig_item_pk_Clave, '', '', 'Asignacion_Autores', '', false);
                            AddMstRegField(-600, Autor_Catalogo, 'Autor_Catalogo', 1);
                            AddMstRegField(-601, item_Autor, 'Autor', 2);
                            AddMstRegField(-602, Autor, 'Autor Ant', 3); // Valor Anterior

                            Clear(wInstFld);
                        end;
                    }
                }
                textelement(articulos_digitales)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Articulos_Digitales';
                    textelement(articulos_digitales_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(articulos_digitales_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(arti_item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(formatodigital)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'FormatoDigital';
                            }
                            textelement(pesodigitalunidad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'PesoDigitalUnidad';
                            }
                            textelement(tipoproteccion)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'TipoProteccion';
                            }
                            textelement(versiondigital)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'VersionDigital';
                            }
                        }
                        textelement(arti_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(item_formatodigital)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'FormatoDigital';
                        }
                        textelement(item_pesodigitalunidad)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'PesoDigitalUnidad';
                        }
                        textelement(pesodigitalvalor)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'PesoDigitalValor';
                        }
                        textelement(item_tipoproteccion)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'TipoProteccion';
                        }
                        textelement(item_versiondigital)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'VersionDigital';
                        }
                    }
                }
                textelement(direcciones_url)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Direcciones_URL';
                    textelement(direcciones_url_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(direcciones_url_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(dire_item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(direccion_url)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Direccion_URL';
                            }
                            textelement(tipo_url)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Tipo_URL';
                            }
                        }
                        textelement(direcciones_url_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(item_direccion_url)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Direccion_URL';
                        }
                        textelement(principal)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Principal';
                        }
                        textelement(item_tipo_url)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Tipo_URL';
                        }
                    }
                }
                textelement(premios)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Premios';
                    textelement(premios_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Zero;
                        XmlName = 'item';
                        textelement(premios_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(premios_item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
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
                            textelement(anio_premio)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Anio_Premio';
                            }
                        }
                        textelement(premios_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(item_nombre_premio)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Nombre_Premio';
                        }
                        textelement(item_pais_premio)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Pais_Premio';
                        }
                        textelement(item_posicion_premio)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Posicion_Premio';
                        }
                        textelement(item_anio_premio)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Anio_Premio';
                        }
                        textelement(jurado_premio)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Jurado_Premio';
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(-1, 31, Premios_item_Clave, '', item_Nombre_Premio, 'Premios', ''); // No aplica
                        end;
                    }
                }
                textelement(packs)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Packs';
                    textelement(packs_pk)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        XmlName = 'pk';
                        textelement(packs_pk_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';

                            trigger OnAfterAssignVariable()
                            begin
                                SetInsField(1); // Marcamos que ha pasado por aqui
                            end;
                        }
                        textelement(packs_pk_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(packs_pk_sociedad)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                    }
                    textelement(packs_clave)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Clave';

                        trigger OnAfterAssignVariable()
                        begin
                            SetInsField(2); // Marcamos que ha pasado por aqui
                        end;
                    }
                    textelement(packs_pais)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Pais';
                    }
                    textelement(packs_sociedad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Sociedad';
                    }
                    textelement(list)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'List';
                        textelement(list_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(list_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                XmlName = 'pk';
                                textelement(articulo_pack)
                                {
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                    TextType = Text;
                                    XmlName = 'Articulo_Pack';
                                }
                            }
                            textelement(item_articulo_pack)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Articulo_Pack';

                                trigger OnAfterAssignVariable()
                                begin
                                    SetInsField(4); // Marcamos que ha pasado por aqui
                                end;
                            }
                            textelement(unidades)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Unidades';

                                trigger OnAfterAssignVariable()
                                begin
                                    SetInsField(5); // Marcamos que ha pasado por aqui
                                end;
                            }
                            textelement(orden)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Orden';

                                trigger OnAfterAssignVariable()
                                begin
                                    SetInsField(2); // Marcamos que ha pasado por aqui
                                end;
                            }

                            trigger OnAfterAssignVariable()
                            var
                                lwPack: Text;
                                lwArtPack: Text;
                            begin

                                if Packs_pk_Clave <> '' then begin
                                    SetInsField(1); // Marcamos que ha pasado por aqui
                                    SetInsField(3); // Marcamos que ha pasado por aqui
                                end;

                                lwPack := Packs_Clave;
                                Clear(lwArtPack);
                                if wInstFld[4] then
                                    lwArtPack := item_Articulo_Pack;
                                wTblInsertd := true;

                                if lwPack = '' then
                                    lwPack := Packs_pk_Clave;
                                if lwArtPack = '' then
                                    lwArtPack := Articulo_Pack;

                                /*
                                IF Packs_Clave = '' THEN
                                  Packs_Clave := Packs_pk_Clave;
                                IF item_Articulo_Pack = '' THEN
                                  item_Articulo_Pack := Articulo_Pack;
                                */

                                cGestM.AddMstReg2(1, 90, 0, Packs_pk_Clave, '', 'Articulo_Pack', '', false); // Update

                                if Packs_pk_Clave <> lwPack then begin // Rename
                                    AddMstRegField(1, Packs_pk_Clave, 'Clave', 1);
                                    cGestM.AddRenameField(lwPack);
                                end;

                                if lwArtPack <> Articulo_Pack then begin
                                    // Enviamos un campo virtual para informar del valor anterior
                                    AddMstRegField(-901, Articulo_Pack, 'Articulo_Pack Ant', 0);
                                end;

                                AddMstRegField(75000, Orden, 'Orden', 2);
                                AddMstRegField(3, 'ITEM', '', 0);
                                // AddMstRegField(4   , item_Articulo_Pack, 'Articulo_Pack',4);
                                AddMstRegField(4, lwArtPack, 'Articulo_Pack', 4);
                                AddMstRegField(8, Unidades, 'Unidades', 5);
                                Clear(wInstFld);

                            end;
                        }
                    }
                }
                textelement(asignacion_articulos_relaci)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Asignacion_Articulos_Relacionados';
                    textelement(body_asig_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(body_asig_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(body_asig_item_pk_clave)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(asig_item_pk_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Zero;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(asig_item_pk_sociedad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Sociedad';
                            }
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
                        textelement(body_asig_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(asig_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(asig_item_sociedad)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                        textelement(item_articulo_relacionado)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Articulo_Relacionado';
                        }
                        textelement(item_tipo_relacion)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Tipo_Relacion';
                        }
                    }

                    trigger OnAfterAssignVariable()
                    begin
                        AddMstReg(-1, 33, body_Asig_item_Clave, '', item_Articulo_Relacionado, 'Asignacion_Articulos_Relacionados', ''); // No aplica
                    end;
                }
                textelement(asignacion_fechas_conmemora)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Asignacion_Fechas_Conmemorativas';
                    textelement(mensaje_body_asig_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(mensaje_body_asig_item_pk)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(mens_body_asig_item_pk_clav)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(body_asig_item_pk_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(body_asig_item_pk_sociedad)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Sociedad';
                            }
                            textelement(fecha_conmemorativa)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Fecha_Conmemorativa';
                            }
                        }
                        textelement(mens_body_asig_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(body_asig_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(body_asig_item_sociedad)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                        textelement(item_fecha_conmemorativa)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Fecha_Conmemorativa';
                        }
                    }

                    trigger OnAfterAssignVariable()
                    begin
                        AddMstReg(-1, 35, mens_body_Asig_item_Clave, '', item_Fecha_Conmemorativa, 'Asignacion_Fechas_Conmemorativas', ''); // No aplica
                    end;
                }
                textelement(asignacion_temas_transversa)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Asignacion_Temas_Transversales';
                    textelement(upda_mensaje_body_asig_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(upda_mensaje_body_asig_item1)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(mens_body_asig_item_pk_clav1)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(mens_body_asig_item_pk_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(mens_body_asig_item_pk_soci)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Sociedad';
                            }
                            textelement(tema_transversal)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Tema_Transversal';
                            }
                        }
                        textelement(upda_mens_body_asig_item_cl)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(mensaje_body_asig_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(mens_body_asig_item_socieda)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                        textelement(item_tema_transversal)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Tema_Transversal';
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(-1, 34, upda_mens_body_Asig_item_Cl, '', item_Tema_Transversal, 'Asignacion_Temas_Transversales', ''); // No aplica
                        end;
                    }
                }
                textelement(asignacion_depositos_legale)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Asignacion_Depositos_Legales';
                    textelement(upda_mensaje_body_asig_item2)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(upda_mensaje_body_asig_item3)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(mens_body_asig_item_pk_clav2)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(upda_mens_body_asig_item_pk)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(mens_body_asig_item_pk_soci1)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Sociedad';
                            }
                            textelement(deposito_legal)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Deposito_Legal';
                            }
                        }
                        textelement(upda_mens_body_asig_item_cl1)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(upda_mensaje_body_asig_item4)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(mens_body_asig_item_socieda1)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                        textelement(item_deposito_legal)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Deposito_Legal';
                        }
                    }
                }
                textelement(asignacion_zonas_geografica)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Asignacion_Zonas_Geograficas';
                    textelement(upda_mensaje_body_asig_item5)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(upda_mensaje_body_asig_item6)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'pk';
                            textelement(mens_body_asig_item_pk_clav3)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Clave';
                            }
                            textelement(upda_mens_body_asig_item_pk1)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(mens_body_asig_item_pk_soci2)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Sociedad';
                            }
                            textelement(zona_geografica)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Zona_Geografica';
                            }
                        }
                        textelement(upda_mens_body_asig_item_cl2)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(upda_mensaje_body_asig_item7)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(mens_body_asig_item_socieda2)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                        textelement(item_zona_geografica)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Zona_Geografica';
                        }
                        textelement(zona_principal)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Zona_Principal';
                        }
                        textelement(opcion)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Opcion';
                        }
                        textelement(servicio_novedad)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;
                            TextType = Text;
                            XmlName = 'Servicio_Novedad';
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
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        wTblInsertd := true;
    end;

    trigger OnPreXmlPort()
    begin
        Clear(wInstFld);
        cGestM.SetAlowEmptyValues(true);
        cGestM.AddMstRegHeader(1, 0);
    end;

    var
        cGestM: Codeunit "Gest. Maestros MdM";
        wTblInsertd: Boolean;
        wInstFld: array[30] of Boolean;


    procedure AddMstReg(pwIdTabla: Integer; pwTipo: Integer; pwCodePk: Code[30]; pwCode: Code[30]; pwDescripcion: Text; pwNombreElemento: Text; pwVisible: Text[10])
    var
        lwValDmD: Boolean;
    begin
        // AddMstReg
        // Añade una linea en la tabla previa de maestros MdM

        lwValDmD := pwIdTabla = -1; // Lo situa como Valor MdM Si el id de tabla es -1 (No Aplica)

        AddMstReg2(pwIdTabla, pwTipo, pwCodePk, pwCode, pwDescripcion, pwNombreElemento, pwVisible, lwValDmD); // Update
    end;


    procedure AddMstReg2(pwIdTabla: Integer; pwTipo: Integer; pwCodePk: Code[30]; pwCode: Code[30]; pwDescripcion: Text; pwNombreElemento: Text; pwVisible: Text[10]; pwValMdM: Boolean)
    begin
        // AddMstReg2
        // Añade una linea en la tabla previa de maestros MdM

        wTblInsertd := pwCode <> '?';
        if not wTblInsertd then
            exit;

        if pwCodePk = '?' then
            pwCodePk := '';

        if pwCodePk = '' then
            pwCodePk := pwCode;

        // No renombramos los maestros. En su lugar anulamos el codigo antiguo y creamos uno nuevo
        if (pwCode <> pwCodePk) and (pwCode <> '') then begin
            cGestM.AddMstReg2(2, pwIdTabla, pwTipo, pwCodePk, pwDescripcion, pwNombreElemento, pwVisible, pwValMdM); // Delete
            cGestM.AddMstReg2(0, pwIdTabla, pwTipo, pwCode, pwDescripcion, pwNombreElemento, pwVisible, pwValMdM); // insert
        end
        else
            cGestM.AddMstReg2(1, pwIdTabla, pwTipo, pwCodePk, pwDescripcion, pwNombreElemento, pwVisible, pwValMdM); // Update
    end;


    procedure AddMstRegField(pwIdField: Integer; pwValue: Text; pwNombreElemento: Text; pwNo: Integer)
    begin
        // AddMstRegField

        AddMstRegField2(pwIdField, pwValue, pwNombreElemento, false, pwNo);
    end;


    procedure AddMstRegField2(pwIdField: Integer; pwValue: Text; pwNombreElemento: Text; pwValMdM: Boolean; pwNo: Integer)
    var
        lwOK: Boolean;
    begin
        // AddMstRegField2

        if pwNo > 0 then
            lwOK := wInstFld[pwNo] or (pwValue <> '')
        else
            lwOK := true;

        if wTblInsertd and lwOK then
            cGestM.AddMstRegField2(pwIdField, pwValue, pwNombreElemento, pwValMdM);
    end;


    procedure GetOutStrm(var wOutStrm: OutStream)
    begin
        // GetOutStrm

        cGestM.GetOutStrm(wOutStrm)
    end;


    procedure GestMessageXML(var pxResp: XMLport "Resp. Web Service MdM")
    begin
        // GestMessageXML

        cGestM.GestMessageXML(pxResp);
    end;


    procedure SetInsField(wNo: Integer)
    begin
        // SetInsField
        // Marca que ha pasado por un campo, por lo que viene informado
        wInstFld[wNo] := true;
    end;


    procedure AsegDato(pwDato: Text)
    begin
        // AsegDato

        if DelChr(pwDato, '<>') = '' then
            currXMLport.Skip;
    end;
}

