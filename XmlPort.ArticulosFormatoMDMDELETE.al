xmlport 75002 "Articulos_Formato_MDM - DELETE"
{
    // --------------------------------------------------------------------------------
    // -- XMLport automatically created with Dynamics NAV XMLport Generator 1.3.0.2
    // -- Copyright ’ 2007-2012 Carsten Scholling
    // --------------------------------------------------------------------------------

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
                            textelement(item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';

                                trigger OnBeforePassVariable()
                                begin
                                    AsegDato('');
                                end;
                            }

                            trigger OnBeforePassVariable()
                            begin
                                AsegDato('');
                            end;

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(9, 0, item_Code, 'Paises');
                            end;
                        }

                        trigger OnBeforePassVariable()
                        begin
                            AsegDato('');
                        end;
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
                            textelement(tipologias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(5722, 0, Tipologias_item_Code, 'Tipologias');
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
                            textelement(isbn_tramitado_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 9, ISBN_Tramitado_item_Code, 'ISBN_Tramitado'); // No aplica
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
                            textelement(tipos_productos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 0, Tipos_Productos_item_Code, 'Tipos_Productos');
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
                            textelement(soportes_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 1, Soportes_item_Code, 'Soportes');
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
                            textelement(encuadernaciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 2, Encuadernaciones_item_Code, 'Encuadernaciones'); // No aplica
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
                            textelement(datos_tecnicos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 1, Datos_Tecnicos_item_Code, 'Datos_Tecnicos'); // No aplica
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
                            textelement(sociedades_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 2, Sociedades_item_Code, 'Sociedades');
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
                            textelement(lineas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 7, Lineas_item_Code, 'Lineas');
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
                            textelement(sellos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 10, Sellos_item_Code, 'Sellos');
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
                            textelement(ibic_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 10, IBIC_item_Code, 'IBIC'); // No aplica
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
                            textelement(idiomas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(8, 0, Idiomas_item_Code, 'Idiomas');
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
                            textelement(obras_proyectos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 11, Obras_Proyectos_item_Code, 'Obras_Proyectos'); // No aplica
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
                            textelement(series_metodos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Series Metodos
                                AddMstReg(349, -200, Series_Metodos_item_Code, 'Series_Metodos');
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
                            textelement(fich_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 12, Fich_item_Code, 'Ficheros_Digitales_Asociados'); // No aplica
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
                            textelement(code_autor)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code_Autor';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 5, Code_Autor, 'Autores');
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
                            textelement(item_code_autor)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code_Autor';
                            }
                            textelement(correo)
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
                            textelement(tipos_autorias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // AddMstReg(75009, 0, Tipos_Autorias_item_Code, 'Tipos_Autorias');
                                AddMstReg(-1, 29, Tipos_Autorias_item_Code, 'Tipos_Autorias'); // No aplica
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
                            textelement(form_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 13, Form_item_Code, 'Formatos_Digitales'); // No aplica
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
                            textelement(peso_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 14, Peso_item_Code, 'Peso_Digital_Unidades'); // No aplica
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
                            textelement(tipos_proteccion_item_code)
                            {
                                MaxOccurs = Unbounded;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 6, Tipos_Proteccion_item_Code, 'Tipos_Proteccion'); // No aplica
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
                            textelement(tipos_url_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 15, Tipos_URL_item_Code, 'Tipos_URL'); // No aplica
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
                            textelement(posicion_premio_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 16, Posicion_Premio_item_Code, 'Posicion_Premio'); // No aplica
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
                            textelement(plan_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 4, Plan_item_Code, 'Planes_Editoriales');
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
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(campanias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                //AddMstReg(-1, 17,  Campanias_item_Code, 'Campanias'); // No aplica
                                AddMstReg(75001, 13, Campanias_item_Code, 'Campanias');
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
                            textelement(ediciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 11, Ediciones_item_Code, 'Ediciones');
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
                            textelement(derechos_autor_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 7, Derechos_Autor_item_Code, 'Derechos_Autor'); // No aplica
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
                            textelement(cuentas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }
                            textelement(cuentas_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Cuentas
                                AddMstReg(349, -202, Cuentas_item_Code, 'Cuentas');
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
                            textelement(estr_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75002, 0, Estr_item_Code, 'Estructura_Analitica');
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
                            textelement(estados_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 12, Estados_item_Code, 'Estados');
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
                            textelement(tipos_relaciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 18, Tipos_Relaciones_item_Code, 'Tipos_Relaciones'); // No aplica
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
                            textelement(tipo_texto_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Tipo Texto
                                AddMstReg(349, -203, Tipo_Texto_item_Code, 'Tipo Texto');
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
                            textelement(materia_global_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 5, Materia_Global_item_Code, 'Materia_Global'); // No aplica
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
                            textelement(tipo_materia_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 4, Tipo_Materia_item_Code, 'Tipo_Materia'); // No aplica
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
                            textelement(asignaturas_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(asignaturas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 8, Asignaturas_item_Code, 'Asignaturas');
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
                            textelement(materias_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(materias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Materia
                                AddMstReg(349, -204, Materias_item_Code, 'Materias');
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
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(destinos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Destino
                                AddMstReg(349, -201, Destinos_item_Code, 'Destinos');
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
                            textelement(tema_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 8, Tema_item_Code, 'Temas_Transversales'); // No aplica
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
                            textelement(niveles_globales_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                //AddMstReg(75001, 10,  Niveles_Globales_item_Code, 'Niveles_Globales');
                                AddMstReg(-1, 3, Niveles_Globales_item_Code, 'Niveles_Globales'); // No aplica
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
                            textelement(niveles_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(niveles_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 3, Niveles_item_Code, 'Niveles');
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
                            textelement(ciclos_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(ciclos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 6, Ciclos_item_Code, 'Ciclos');
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
                            textelement(cursos_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(cursos_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(75001, 9, Cursos_item_Code, 'Cursos');
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
                            textelement(trim_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 19, Trim_item_Code, 'Trimestres_Creditos'); // No aplica
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
                            textelement(cargas_horarias_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Carga Horaria
                                AddMstReg(349, -205, Cargas_Horarias_item_Code, 'Cargas_Horarias');
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
                            textelement(common_european_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 20, Common_European_item_Code, 'Common_European'); // No aplica
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
                            textelement(origenes_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                // Dim Origen
                                AddMstReg(349, -206, Origenes_item_Code, 'Origenes');
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
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(monedas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 21, Monedas_item_Code, 'Monedas'); // No aplica
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
                            textelement(fech_item_pais)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Pais';
                            }
                            textelement(fech_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 22, Fech_item_Code, 'Fechas_Conmemorativas'); // No aplica
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
                            textelement(vida_util_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 23, Vida_Util_item_Code, 'Vida_Util'); // No aplica
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
                            textelement(zonas_geograficas_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 24, Zonas_Geograficas_item_Code, 'Zonas_Geograficas'); // No aplica
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
                            textelement(opciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 25, Opciones_item_Code, 'Opciones'); // No aplica
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
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(tipos_ediciones_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 26, Tipos_Ediciones_item_Code, 'Tipos_Ediciones'); // No aplica
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
                            textelement(prefijo_libro_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 27, Prefijo_Libro_item_Code, 'Prefijo_Libro'); // No aplica
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
                            textelement(prefijo_volumen_item_code)
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Code';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg(-1, 28, Prefijo_Volumen_item_Code, 'Prefijo_Volumen'); // No aplica
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
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(27, 1, Clave, 'Articulos_GENERAL');
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
                        textelement(item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(articulos_espec_item_pais)
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
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(27, 2, item_Clave, 'Articulos_ESPEC');
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
                        textelement(locales_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(locales_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Pais';
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
                        textelement(locales_espec_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(item_sociedad)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Sociedad';
                        }
                        textelement(locales_espec_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Pais';
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
                        textelement(localizados_es_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(loca_item_sociedad)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Sociedad';
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
                        textelement(clas_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(item_ibic)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'IBIC';
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(-1, 30, Clas_item_Clave, 'Clasificaciones_IBIC'); // No aplica
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
                        textelement(fich_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(tipo_fichero_digital_asocia)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Tipo_Fichero_Digital_Asociado';
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(-1, 32, Fich_item_Clave, 'Ficheros_Digitales_Asociados'); // No aplica
                        end;
                    }
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
                        textelement(asig_item_clave)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(autor)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Autor';
                        }
                        textelement(tipo_autoria)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Tipo_Autoria';
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            // En realidad NO podemos borrar el producto, por lo que lo que hacemos es una modificación de autor
                            //AddMstReg2(27, 3, Asig_item_Clave, 'Asignacion_Autores', TRUE);

                            AddMstReg(27, 3, Asig_item_Clave, 'Asignacion_Autores');  // Update
                            AddMstRegField(1, Asig_item_Clave, 'Asig_item_Clave');
                            AddMstRegField(-601, 'NULL', 'Autor'); // Valor Actual en blanco
                            AddMstRegField(-602, Autor, 'Autor Ant'); // Valor Anterior
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
                        textelement(arti_item_clave)
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
                        textelement(direcciones_url_item_clave)
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
                }
                textelement(premios)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Premios';
                    textelement(premios_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(premios_item_clave)
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

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(-1, 31, Premios_item_Clave, 'Premios'); // No aplica
                        end;
                    }
                }
                textelement(packs)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Packs';
                    textelement(packs_clave)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Clave';
                    }
                    textelement(packs_pais)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Pais';
                    }
                    textelement(packs_sociedad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Sociedad';
                    }
                    textelement(list)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        XmlName = 'List';
                        textelement(list_item)
                        {
                            MaxOccurs = Unbounded;
                            MinOccurs = Once;
                            XmlName = 'item';
                            textelement(articulo_pack)
                            {
                                MaxOccurs = Unbounded;
                                MinOccurs = Once;
                                TextType = Text;
                                XmlName = 'Articulo_Pack';
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                AddMstReg2(90, 0, Packs_Clave, 'Articulo_Pack', false);

                                AddMstRegField2(1, Packs_Clave, 'Packs_Clave', false);
                                AddMstRegField2(4, Articulo_Pack, 'Articulo_Pack', false);
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
                        textelement(body_asig_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(asig_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(asig_item_sociedad)
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

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(-1, 33, body_Asig_item_Clave, 'Asignacion_Articulos_Relacionados'); // No aplica
                        end;
                    }
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
                        textelement(mens_body_asig_item_clave)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(body_asig_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(body_asig_item_sociedad)
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

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(-1, 35, mens_body_Asig_item_Clave, 'Asignacion_Fechas_Conmemorativas'); // No aplica
                        end;
                    }
                }
                textelement(asignacion_temas_transversa)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Asignacion_Temas_Transversales';
                    textelement(dele_mensaje_body_asig_item)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(dele_mens_body_asig_item_cl)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(mensaje_body_asig_item_pais)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(mens_body_asig_item_socieda)
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

                        trigger OnAfterAssignVariable()
                        begin
                            AddMstReg(-1, 34, dele_mens_body_Asig_item_Cl, 'Asignacion_Temas_Transversales'); // No aplica
                        end;
                    }
                }
                textelement(asignacion_depositos_legale)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Asignacion_Depositos_Legales';
                    textelement(dele_mensaje_body_asig_item1)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(dele_mens_body_asig_item_cl1)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(dele_mensaje_body_asig_item2)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(mens_body_asig_item_socieda1)
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
                }
                textelement(asignacion_zonas_geografica)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'Asignacion_Zonas_Geograficas';
                    textelement(dele_mensaje_body_asig_item3)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Once;
                        XmlName = 'item';
                        textelement(dele_mens_body_asig_item_cl2)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Clave';
                        }
                        textelement(dele_mensaje_body_asig_item4)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Once;
                            TextType = Text;
                            XmlName = 'Pais';
                        }
                        textelement(mens_body_asig_item_socieda2)
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
        cGestM.AddMstRegHeader(2, 0);
    end;

    var
        cGestM: Codeunit "Gest. Maestros MdM";
        wTblInsertd: Boolean;


    procedure AddMstReg(pwIdTabla: Integer; pwTipo: Integer; pwCode: Code[30]; pwNombreElemento: Text)
    var
        lwValDmD: Boolean;
    begin
        // AddMstReg
        // Añade una linea en la tabla previa de maestros MdM

        lwValDmD := pwIdTabla = -1; // Lo situa como Valor MdM Si el id de tabla es -1 (No Aplica)

        AddMstReg2(pwIdTabla, pwTipo, pwCode, pwNombreElemento, lwValDmD);
    end;


    procedure AddMstReg2(pwIdTabla: Integer; pwTipo: Integer; pwCode: Code[30]; pwNombreElemento: Text; pwValMdM: Boolean)
    var
        lwOper: Integer;
    begin
        // AddMstReg2
        // Añade una linea en la tabla previa de maestros MdM

        wTblInsertd := pwCode <> '?';
        if not wTblInsertd then
            exit;

        lwOper := 2; // Delete
        if (pwIdTabla = 27) and (pwTipo = 3) then // Autores. Se consideran modificaciones en Producto
            lwOper := 1; // Update

        //cGestM.AddMstReg2(lwOper, pwIdTabla ,pwTipo ,pwCode, '', pwNombreElemento, '', pwValMdM);
        cGestM.AddMstReg2(lwOper, pwIdTabla, pwTipo, pwCode, '', pwNombreElemento, '', false);
    end;


    procedure AddMstRegField(pwIdField: Integer; pwValue: Text; pwNombreElemento: Text)
    begin
        // AddMstRegField

        AddMstRegField2(pwIdField, pwValue, pwNombreElemento, false);
    end;


    procedure AddMstRegField2(pwIdField: Integer; pwValue: Text; pwNombreElemento: Text; pwValMdM: Boolean)
    begin
        // AddMstRegField2

        if wTblInsertd then
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


    procedure AsegDato(pwDato: Text)
    begin
        // AsegDato

        if DelChr(pwDato, '<>') = '' then
            currXMLport.Skip;
    end;
}

