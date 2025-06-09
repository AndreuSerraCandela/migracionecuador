xmlport 56200 "Web Service MdE"
{
    // --------------------------------------------------------------------------------
    // -- XMLport automatically created with Dynamics NAV XMLport Generator 1.3.0.2
    // -- Copyright ’ 2007-2012 Carsten Scholling
    // --------------------------------------------------------------------------------
    // 
    // #81969 27/01/2018 PLB: Se genera un historial MdE, si la fecha efectiva es hoy, se pasan los datos al empleado, si no se espera a que llegue el día (se procesa por una tarea programada)

    DefaultNamespace = 'http://prisa.com';
    Direction = Both;
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(mae)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            XmlName = 'mae';
            textelement(mensaje)
            {
                MaxOccurs = Once;
                MinOccurs = Once;
                XmlName = 'mensaje';
                textelement(head)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'head';
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
                        TextType = Text;
                        XmlName = 'fecha_origen';
                    }
                    textelement(fecha)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'fecha';
                    }
                    textelement(tipo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'tipo';
                    }
                }
                textelement(body)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'body';
                    textelement(operacion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Operacion';
                    }
                    textelement(numero_persona)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Numero_persona';
                    }
                    textelement(numero_persona_sistema_loca)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Numero_persona_sistema_local_hr';
                    }
                    textelement(m_fecha_inicio_contrato)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_fecha_inicio_contrato';
                    }
                    textelement(fecha_inicio_contrato)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Fecha_inicio_contrato';
                    }
                    textelement(m_fecha_fin_contrato)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_fecha_fin_contrato';
                    }
                    textelement(fecha_fin_contrato)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Fecha_fin_contrato';
                    }
                    textelement(m_fecha_antiguedad_reconoci)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_fecha_antiguedad_reconocida';
                    }
                    textelement(fecha_antiguedad_reconocida)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Fecha_antiguedad_reconocida';
                    }
                    textelement(m_fecha_efectiva)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_fecha_efectiva';
                    }
                    textelement(fecha_efectiva)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Fecha_efectiva';
                    }
                    textelement(m_motivo_contratacion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_motivo_contratacion';
                    }
                    textelement(motivo_contratacion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Motivo_contratacion';
                    }
                    textelement(m_tipo_baja)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_tipo_baja';
                    }
                    textelement(tipo_baja)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Tipo_baja';
                    }
                    textelement(m_destino_empleado)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_destino_empleado';
                    }
                    textelement(destino_empleado)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Destino_empleado';
                    }
                    textelement(m_tipo_documento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_tipo_documento';
                    }
                    textelement(tipo_documento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Tipo_documento';
                    }
                    textelement(m_numero_documento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_numero_documento';
                    }
                    textelement(numero_documento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Numero_documento';
                    }
                    textelement(m_tratamiento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_tratamiento';
                    }
                    textelement(tratamiento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Tratamiento';
                    }
                    textelement(m_nombre)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_nombre';
                    }
                    textelement(nombre)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Nombre';
                    }
                    textelement(m_nombre_preferido)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_nombre_preferido';
                    }
                    textelement(nombre_preferido)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Nombre_preferido';
                    }
                    textelement(m_primer_apellido)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_primer_apellido';
                    }
                    textelement(primer_apellido)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Primer_apellido';
                    }
                    textelement(m_segundo_apellido)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_segundo_apellido';
                    }
                    textelement(segundo_apellido)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Segundo_apellido';
                    }
                    textelement(m_genero)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_genero';
                    }
                    textelement(genero)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Genero';
                    }
                    textelement(m_estado_civil)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_estado_civil';
                    }
                    textelement(estado_civil)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Estado_civil';
                    }
                    textelement(m_discapacidad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_discapacidad';
                    }
                    textelement(discapacidad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Discapacidad';
                    }
                    textelement(m_fecha_nacimiento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_fecha_nacimiento';
                    }
                    textelement(fecha_nacimiento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Fecha_nacimiento';
                    }
                    textelement(m_provincia_nacimiento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_provincia_nacimiento';
                    }
                    textelement(provincia_nacimiento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Provincia_nacimiento';
                    }
                    textelement(m_pais_nacimiento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_pais_nacimiento';
                    }
                    textelement(pais_nacimiento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Pais_nacimiento';
                    }
                    textelement(m_nacionalidad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_nacionalidad';
                    }
                    textelement(nacionalidad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Nacionalidad';
                    }
                    textelement(m_pais)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_pais';
                    }
                    textelement(pais)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Pais';
                    }
                    textelement(m_tipo_calle)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_tipo_calle';
                    }
                    textelement(tipo_calle)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Tipo_calle';
                    }
                    textelement(m_nombre_calle)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_nombre_calle';
                    }
                    textelement(nombre_calle)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Nombre_calle';
                    }
                    textelement(m_numero)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_numero';
                    }
                    textelement(numero)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Numero';
                    }
                    textelement(m_adicional)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_adicional';
                    }
                    textelement(adicional)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Adicional';
                    }
                    textelement(m_codigo_postal)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_codigo_postal';
                    }
                    textelement(codigo_postal)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Codigo_postal';
                    }
                    textelement(m_ciudad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_ciudad';
                    }
                    textelement(ciudad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Ciudad';
                    }
                    textelement(m_provincia)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_provincia';
                    }
                    textelement(provincia)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Provincia';
                    }
                    textelement(m_direccion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_direccion';
                    }
                    textelement(direccion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Direccion';
                    }
                    textelement(m_numero_telefono)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_numero_telefono';
                    }
                    textelement(numero_telefono)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Numero_telefono';
                    }
                    textelement(m_extension)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_extension';
                    }
                    textelement(extension)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Extension';
                    }
                    textelement(m_posicion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_posicion';
                    }
                    textelement(posicion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Posicion';
                    }
                    textelement(m_fecha_entrada_posicion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_fecha_entrada_posicion';
                    }
                    textelement(fecha_entrada_posicion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Fecha_entrada_posicion';
                    }
                    textelement(m_unidad_negocio)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_unidad_negocio';
                    }
                    textelement(unidad_negocio)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Unidad_negocio';
                    }
                    textelement(m_zona_geografica)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_zona_geografica';
                    }
                    textelement(zona_geografica)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Zona_geografica';
                    }
                    textelement(m_pais_puesto)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_pais_puesto';
                    }
                    textelement(pais_puesto)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Pais_puesto';
                    }
                    textelement(m_division)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_division';
                    }
                    textelement(division)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Division';
                    }
                    textelement(m_sociedad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_sociedad';
                    }
                    textelement(sociedad)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Sociedad';
                    }
                    textelement(m_centro_trabajo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_centro_trabajo';
                    }
                    textelement(centro_trabajo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        XmlName = 'Centro_trabajo';
                    }
                    textelement(m_area_funcional_grupo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_area_funcional_grupo';
                    }
                    textelement(area_funcional_grupo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Area_funcional_grupo';
                    }
                    textelement(m_departamento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_departamento';
                    }
                    textelement(departamento)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Departamento';
                    }
                    textelement(m_departamento_grupo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_departamento_grupo';
                    }
                    textelement(departamento_grupo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Departamento_grupo';
                    }
                    textelement(m_producto_programa)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_producto_programa';
                    }
                    textelement(producto_programa)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Producto_programa';
                    }
                    textelement(m_categoria_grupo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_Categoria_grupo';
                    }
                    textelement(categoria_grupo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Categoria_grupo';
                    }
                    textelement(m_tipo_contrato_grupo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_tipo_contrato_grupo';
                    }
                    textelement(tipo_contrato_grupo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Tipo_contrato_grupo';
                    }
                    textelement(m_tipo_empleado_prisa)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_tipo_empleado_prisa';
                    }
                    textelement(tipo_empleado_prisa)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Tipo_empleado_prisa';
                    }
                    textelement(m_ambito_regional)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_ambito_regional';
                    }
                    textelement(ambito_regional)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Ambito_regional';
                    }
                    textelement(m_global)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_global';
                    }
                    textelement(global)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Global';
                    }
                    textelement(m_coorporativo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_coorporativo';
                    }
                    textelement(coorporativo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Coorporativo';
                    }
                    textelement(m_motivo_contratacion_siste)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_motivo_contratacion_sistema_local_hr';
                    }
                    textelement(motivo_contratacion_sistema)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Motivo_contratacion_sistema_local_hr';
                    }
                    textelement(m_motivo_terminacion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_motivo_terminacion';
                    }
                    textelement(motivo_terminacion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Motivo_terminacion';
                    }
                    textelement(m_procedencia_empleado)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_procedencia_empleado';
                    }
                    textelement(procedencia_empleado)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Procedencia_empleado';
                    }
                    textelement(m_expatriado)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_expatriado';
                    }
                    textelement(expatriado)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Expatriado';
                    }
                    textelement(m_representante_trabajadore)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_representante_trabajadores';
                    }
                    textelement(representante_trabajadores)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Representante_trabajadores';
                    }
                    textelement(m_clasificacion_digital)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_clasificacion_digital';
                    }
                    textelement(clasificacion_digital)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Clasificacion_digital';
                    }
                    textelement(m_salario_fijo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_salario_fijo';
                    }
                    textelement(salario_fijo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Salario_fijo';
                    }
                    textelement(m_posicion_superior)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_posicion_superior';
                    }
                    textelement(posicion_superior)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Posicion_superior';
                    }
                    textelement(m_responsable_funcional)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_responsable_funcional';
                    }
                    textelement(responsable_funcional)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Responsable_funcional';
                    }
                    textelement(m_area_funcional_unidad_neg)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'M_area_funcional_unidad_negocio';
                    }
                    textelement(area_funcional_unidad_negoc)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;
                        TextType = Text;
                        XmlName = 'Area_funcional_unidad_negocio';
                    }
                    textelement(m_error_interfaz)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'M_error_interfaz';
                    }
                    textelement(error_interfaz)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        TextType = Text;
                        XmlName = 'Error_interfaz';
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
        GlobalLanguage := 2058; // ESM (es-MX)
    end;

    trigger OnPostXmlPort()
    begin
        if not Exporting then begin //+#101415
            if ConfSant."Cod. sociedad maestros Santill" <> Sociedad then
                AddError(StrSubstNo(ErrorCompanyDoNotMatch, Sociedad, ConfSant."Cod. sociedad maestros Santill"), ErrorTipoConf);

            if IsOk then begin
                case Operacion of
                    'INSERT':
                        CreateEmployee(false);
                    'CHANGE':
                        ModifyEmployee();
                    'DELETE':
                        DeleteEmployee();
                    else
                        AddError(ErrorOperation, ErrorTipoDatos);
                end;
            end;

            //+#101415
            // Enviamos la respuesta elaborada a MdE
            //IF ConfSant."WS Respuesta MdE" <> '' THEN
            //  SendAsyncResponse();
            CreateAsyncResponse();
        end
        else
            Exporting := false;
        //+#101415
    end;

    trigger OnPreXmlPort()
    begin
        // la empresa tiene que tener el cód. sociedad de maestros Santillana definido
        if not Exporting then begin //+#101415
            ConfSant.Get;
            IsOk := true;
            Clear(EmployeeNo);

            if ConfSant."Cod. sociedad maestros Santill" = '' then
                AddError(StrSubstNo(ErrorCompanyConfig, ConfSant.FieldCaption("Cod. sociedad maestros Santill"), ConfSant.TableCaption), ErrorTipoConf);

            if ConfSant."Cod. pais maestros Santill" = '' then
                AddError(StrSubstNo(ErrorCompanyConfig, ConfSant.FieldCaption("Cod. pais maestros Santill"), ConfSant.TableCaption), ErrorTipoConf);

            if ConfSant."WS Respuesta MdE" = '' then
                AddError(StrSubstNo(ErrorCompanyConfig, ConfSant.FieldCaption("WS Respuesta MdE"), ConfSant.TableCaption), ErrorTipoConf);

            if (ConfSant."Departamento MdE" = ConfSant."Departamento MdE"::Dimension) and (ConfSant."Dimension Departamento" = '') then
                AddError(StrSubstNo(ErrorCompanyConfig, ConfSant.FieldCaption("Dimension Departamento"), ConfSant.TableCaption), ErrorTipoConf);

            if (ConfSant."Division MdE" = ConfSant."Division MdE"::Dimension) and (ConfSant."Dimension Division" = '') then
                AddError(StrSubstNo(ErrorCompanyConfig, ConfSant.FieldCaption("Dimension Division"), ConfSant.TableCaption), ErrorTipoConf);

            if (ConfSant."Area funcional MdE" = ConfSant."Area funcional MdE"::Dimension) and (ConfSant."Dimension Area funcional" = '') then
                AddError(StrSubstNo(ErrorCompanyConfig, ConfSant.FieldCaption("Dimension Area funcional"), ConfSant.TableCaption), ErrorTipoConf);

            //+#81969
            if not EmpCotiz.FindFirst then
                AddError(StrSubstNo(ErrorCompanyConfig, EmpCotiz.FieldCaption("Empresa cotizacion"), EmpCotiz.TableCaption), ErrorTipoConf);
            //-#81969
        end; //+#101415
    end;

    var
        ConfSant: Record "Config. Empresa";
        Employee: Record Employee;
        MdEHistory: Record "Historial MdE";
        EmpCotiz: Record "Empresas Cotizacion";
        MdEMgnt: Codeunit "MdE Management";
        EmployeeNo: Code[20];
        DescErrorArray: array[10] of Text;
        TipoErrorArray: array[10] of Text;
        ErrorEmployeeDoNotExist: Label 'El empleado %1 %2 no existe.';
        ErrorContractDoNotExist: Label 'El contrato para el empleado %1 %2 no existe.';
        ErrorCompanyConfig: Label 'Es necesario definir %1 en %2.';
        ErrorCompanyDoNotMatch: Label 'La información de companyia del XML (%1) no coincide con la de la base de datos (%2).';
        ErrorTipoConf: Label 'Error de configuración';
        ErrorTipoDatos: Label 'Error de datos';
        IsOk: Boolean;
        ErrorOperation: Label 'No se ha recibido un tipo de operación esperada ("INSERT", "CHANGE" o "DELETE").';
        ErrorTamanoCampo: Label 'El tamaño del valor del nodo %1 (%2) es mayor que el aceptado por el campo "%3" (%4).';
        ErrorTipoVar: Label 'El tipo de dato del nodo %1 (%2) no se ajusta al que necesita el campo "%3".';
        ErrorTipoDatoNoVal: Label 'El campo "%1" no es de un tipo de dato válido.';
        ErrorTablaRel: Label 'El valor del nodo %1 (%2) no existe en la tabla "%3".';
        ErrorEmployeeExist: Label 'Ya existe un empleado (Nº "%1") con Tipo documento "%2" y Nº documento "%3". No se puede crear el empleado "%4".';
        ErrorDimension: Label 'La dimensión "%2" se ha configurado para validar el nodo "%1" pero no existe en NAV.';
        ErrorValorDimension: Label 'El valor del nodo %1 (%2) no existe en la tabla en la dimensión %3.';
        ErrorFechas: Label 'La fecha inicio (%1) del contrato no puede ser superior a la fecha finalización (%2).';
        ErrorRecontratacion: Label 'El empleado "%1" está de baja, parece que está llegando una recontratación (fecha inicio contrato modificada), pero el "%2" no es de recontratación ("%3").';
        ErrorContratacion: Label 'Está dando una alta, pero el "%1" no es de nueva contratación ni recontratación ("%2").';
        CodeValue: Code[20];
        DimensionTxt: Label 'Dimensión %1';
        ErrorInsert: Label 'No se puede crear el %1 para el empleado %2.';
        ErrorInsertEmployee: Label ' Revise que, si está enviando un alta nueva, el número de serie asignado a recursos humanos en Dynamics NAV esté correctamente configurado.';
        ErrorModify: Label 'No se puede modificar el %1 para el empleado %2.';
        Exporting: Boolean;
        CreateDefaultDim: Boolean;
        ErrorDatoObligatorio: Label 'En la operación de tipo %1 el valor del nodo %2 es obligatorio y ha llegado en blanco.';

    local procedure CreateEmployee(FromModifyEmployee: Boolean)
    var
        Contrato: Record Contratos;
        Create: Boolean;
        NoOrden: Integer;
        Found: Boolean;
    begin
        //EmpCotiz.FINDFIRST; //-#81969

        Create := IsNewContract();

        if not Create and not IsRecontratacion() then begin
            AddError(StrSubstNo(ErrorContratacion, 'Motivo_contratacion_sistema_local', Motivo_contratacion_sistema), ErrorTipoDatos);
            exit;
        end;

        if not FromModifyEmployee then begin
            if LocalizarEmpleadoError(Create) then
                exit;
            Employee.Reset;
        end;

        //-#81969
        /*
        // Campos tabla 5200 "Employee"
        Employee.Company := EmpCotiz."Empresa cotización";
        UpdateTextField(Employee."Numero de persona", Numero_persona, 0, 'Numero_persona', Employee.FIELDCAPTION("Numero de persona"),MAXSTRLEN(Employee."Numero de persona"));
        Employee."First Name" := COPYSTR(Nombre, 1, MAXSTRLEN(Employee."First Name"));
        Employee."Last Name" := COPYSTR(Primer_apellido, 1, MAXSTRLEN(Employee."Last Name"));
        Employee."Second Last Name" := COPYSTR(Segundo_apellido, 1, MAXSTRLEN(Employee."Second Last Name"));
        IF IsOk THEN
          Employee.VALIDATE("Full Name");
        
        UpdateDateField(Employee."Employment Date", Fecha_antiguedad_reconocida, 0, 'Fecha_antiguedad_reconocida', Employee.FIELDCAPTION("Employment Date"));
        UpdateOptField(Employee."Document Type", Tipo_documento, 0, 'Tipo_documento', Employee.FIELDCAPTION("Document Type"));
        UpdateTextField(Employee."Document ID", Numero_documento, 0, 'Numero_documento', Employee.FIELDCAPTION("Document ID"),MAXSTRLEN(Employee."Document ID"));
        UpdateOptField(Employee.Gender, Genero, 0, 'Genero', Employee.FIELDCAPTION(Gender));
        UpdateOptField(Employee."Estado civil", Estado_civil, 0, 'Estado_civil', Employee.FIELDCAPTION("Estado civil"));
        UpdateDateField(Employee."Birth Date", Fecha_nacimiento, 0, 'Fecha_nacimiento', Employee.FIELDCAPTION("Birth Date"));
        UpdateTextField(Employee."Lugar nacimiento", COPYSTR(Provincia_nacimiento + '-' + Pais_nacimiento,1,MAXSTRLEN(Employee."Lugar nacimiento")),
         0, 'Provincia_nacimiento y Pais_nacimiento', Employee.FIELDCAPTION("Lugar nacimiento"),MAXSTRLEN(Employee."Lugar nacimiento"));
        
        IF IsOk THEN
          Employee.VALIDATE("Birth Date");
        
        UpdateCodeField(Employee.Nacionalidad, Nacionalidad, DATABASE::"Country/Region", 'Nacionalidad', Employee.FIELDCAPTION(Nacionalidad),MAXSTRLEN(Employee.Nacionalidad),'');
        UpdateCodeField(Employee."Country/Region Code", Pais, DATABASE::"Country/Region", 'Pais', Employee.FIELDCAPTION("Country/Region Code"),MAXSTRLEN(Employee."Country/Region Code"),'');
        UpdateTextField(Employee.Address, Nombre_calle, 0, 'Nombre_calle', Employee.FIELDCAPTION(Address),MAXSTRLEN(Employee.Address));
        UpdateTextField(Employee.City, Ciudad, 0, 'Ciudad', Employee.FIELDCAPTION(City),MAXSTRLEN(Employee.City));
        UpdateCodeField(Employee."Post Code", Codigo_postal, DATABASE::"Post Code", 'Codigo_postal', Employee.FIELDCAPTION("Post Code"),MAXSTRLEN(Employee."Post Code"),'');
        UpdateTextField(Employee.County, Provincia, 0, 'Provincia', Employee.FIELDCAPTION(County),MAXSTRLEN(Employee.County));
        UpdateTextField(Employee."E-Mail", Direccion, 0, 'Direccion', Employee.FIELDCAPTION("E-Mail"),MAXSTRLEN(Employee."E-Mail"));
        UpdateTextField(Employee."Phone No.", Numero_telefono, 0, 'Numero_telefono', Employee.FIELDCAPTION("Phone No."),MAXSTRLEN(Employee."Phone No."));
        
        IF ConfSant."Posicion MdE" = ConfSant."Posicion MdE"::"Puesto laboral" THEN
          UpdateCodeField(Employee."Job Type Code", Posicion, DATABASE::"Puestos laborales", 'Posicion', Employee.FIELDCAPTION("Job Type Code"),MAXSTRLEN(Employee."Job Type Code"),'');
        UpdateCodeField(Employee."Working Center", Centro_trabajo, DATABASE::"Centros de Trabajo", 'Centro_trabajo', Employee.FIELDCAPTION("Working Center"),MAXSTRLEN(Employee."Working Center"),'');
        UpdateOptField(Employee.Categoria, Categoria_grupo, 0, 'Categoria_grupo', Employee.FIELDCAPTION(Categoria));
        UpdateCodeField(Employee."Emplymt. Contract Code", Tipo_contrato_grupo, DATABASE::"Employment Contract", 'Tipo_contrato_grupo', Employee.FIELDCAPTION("Emplymt. Contract Code"),MAXSTRLEN(Employee."Emplymt. Contract Code"),'');
        
        // Campos configurables (division)
        IF ConfSant."Departamento MdE" = ConfSant."Departamento MdE"::Division THEN
          UpdateCodeField(Employee.Departamento, Departamento, DATABASE::Departamentos, 'Departamento', Employee.FIELDCAPTION(Departamento),MAXSTRLEN(Employee.Departamento),'');
        IF ConfSant."Division MdE" = ConfSant."Division MdE"::Division THEN
          UpdateCodeField(Employee.Departamento, Division, DATABASE::Departamentos, 'Division', Employee.FIELDCAPTION(Departamento),MAXSTRLEN(Employee.Departamento),'');
        IF ConfSant."Area funcional MdE" = ConfSant."Area funcional MdE"::Division THEN
          UpdateCodeField(Employee.Departamento, Area_funcional_grupo, DATABASE::Departamentos, 'Area_funcional_grupo', Employee.FIELDCAPTION(Departamento),MAXSTRLEN(Employee.Departamento),'');
        
        IF NOT IsOk THEN
          EXIT;
        
        Employee."Calcular Nomina" := TRUE;
        
        Employee.SetFromMde(TRUE);
        IF Create THEN BEGIN
          IF NOT Employee.INSERT(TRUE) THEN BEGIN
            AddError(STRSUBSTNO(ErrorInsert+ErrorInsertEmployee,Employee.TABLECAPTION,Numero_persona), ErrorTipoDatos);
            EXIT;
          END;
        END
        ELSE BEGIN
          IF NOT Employee.MODIFY(TRUE) THEN BEGIN
            AddError(STRSUBSTNO(ErrorModify,Employee.TABLECAPTION,Numero_persona), ErrorTipoDatos);
            EXIT;
          END;
        END;
        
        IF Employee."Job Type Code" <> '' THEN BEGIN
          Employee.VALIDATE("Job Type Code");
          IF NOT Employee.MODIFY(TRUE) THEN BEGIN
            AddError(STRSUBSTNO(ErrorModify,Employee.TABLECAPTION,Numero_persona), ErrorTipoDatos);
            EXIT;
          END;
        END;
        
        EmployeeNo := Employee."No.";
        
        // Campos configurables (dimension)
        IF ConfSant."Departamento MdE" = ConfSant."Departamento MdE"::Dimension THEN
          UpdateCodeField(CodeValue, Departamento, DATABASE::"Dimension Value", 'Departamento', STRSUBSTNO(DimensionTxt,ConfSant."Dimension Departamento"),MAXSTRLEN(CodeValue),ConfSant."Dimension Departamento");
        IF ConfSant."Division MdE" = ConfSant."Division MdE"::Dimension THEN
          UpdateCodeField(CodeValue, Division, DATABASE::"Dimension Value", 'Division', STRSUBSTNO(DimensionTxt,ConfSant."Dimension Division"),MAXSTRLEN(CodeValue),ConfSant."Dimension Division");
        IF ConfSant."Area funcional MdE" = ConfSant."Area funcional MdE"::Dimension THEN
          UpdateCodeField(CodeValue, Area_funcional_grupo, DATABASE::"Dimension Value", 'Area_funcional_grupo', STRSUBSTNO(DimensionTxt,ConfSant."Dimension Area funcional"),MAXSTRLEN(CodeValue),ConfSant."Dimension Area funcional");
        
        Employee.FIND; // refrescamos empleado, puede haberse actualizado con la actualización de una dimensión global
        
        // Campos tabla 76069 "Contratos"
        Contrato.SETRANGE("No. empleado", EmployeeNo);
        IF Contrato.FINDLAST THEN
          NoOrden := Contrato."No. Orden" + 100
        ELSE
          NoOrden := 100;
        
        Contrato.INIT;
        Contrato."No. empleado" := EmployeeNo;
        Contrato."No. Orden" := NoOrden;
        Contrato.VALIDATE("Cód. contrato", Employee."Emplymt. Contract Code");
        Contrato."Tipo Pago Nomina" := EmpCotiz."Tipo Pago Nomina";
        Contrato.SetFromMde(TRUE);
        IF NOT Contrato.INSERT(TRUE) THEN BEGIN
          AddError(STRSUBSTNO(ErrorInsert,Contrato.TABLECAPTION,Numero_persona), ErrorTipoDatos);
          EXIT;
        END;
        
        UpdateDateField(Contrato."Fecha inicio", Fecha_inicio_contrato, 0, 'Fecha_inicio_contrato', Contrato.FIELDCAPTION("Fecha inicio"));
        IF IsOk THEN
          Contrato.VALIDATE("Fecha inicio");
        UpdateDateField(Contrato."Fecha finalización", Fecha_fin_contrato, 0, 'Fecha_fin_contrato', Contrato.FIELDCAPTION("Fecha finalización"));
        IF IsOk THEN BEGIN
          Contrato.VALIDATE("Fecha finalización");
          Contrato.SetFromMde(TRUE);
          IF NOT Contrato.MODIFY(TRUE) THEN BEGIN
            AddError(STRSUBSTNO(ErrorModify,Contrato.TABLECAPTION,Numero_persona), ErrorTipoDatos);
            EXIT;
          END;
        END;
        */

        CreateDefaultDim := false;
        UpdateMdEHistory;
        CreateDefaultDim := true;

        if not IsOk then
            exit;

        if not Create and (MdEHistory."Fecha efectiva" > Today) then begin
            EmployeeNo := Employee."No.";
            MdEHistory."No." := Employee."No.";
            MdEHistory.Insert(true);
            exit;
        end;

        MdEHistory.InsertEmployee(Employee);
        IsOk := MdEHistory.GetErrors(DescErrorArray, TipoErrorArray);

        EmployeeNo := Employee."No.";
        //-#81969

    end;

    local procedure ModifyEmployee()
    var
        Contrato: Record Contratos;
        Found: Boolean;
        Recontratacion: Boolean;
    begin

        if LocalizarEmpleadoError(false) then
            exit;

        Employee.Reset;

        // Cuando recibimos un UPDATE y el empleado está de baja (o no hay línea de contrato) se entiende que es
        // una recontratación, si el motivo es una alta nueva, daremos el correspondiente error
        Contrato.SetRange("No. empleado", EmployeeNo);
        Recontratacion := not Contrato.Find('+');
        if not Recontratacion and (Contrato."Fecha finalización" <> 0D) then
            Recontratacion := true;
        if Recontratacion then begin
            if IsNewContract() or not IsRecontratacion() then
                AddError(StrSubstNo(ErrorRecontratacion, EmployeeNo, 'Motivo_contratacion_sistema_local', Motivo_contratacion_sistema), ErrorTipoDatos)
            else
                CreateEmployee(true);
            exit;
        end;

        //+#81969
        /*
        // Campos tabla 5200 "Employee"
        IF Employee."Numero de persona" <> Numero_persona THEN
          UpdateTextField(Employee."Numero de persona", Numero_persona, 0, 'Numero_persona', Employee.FIELDCAPTION("Numero de persona"),MAXSTRLEN(Employee."Numero de persona"));
        IF Modified(M_nombre) THEN
          Employee."First Name" := COPYSTR(Nombre, 1, MAXSTRLEN(Employee."First Name"));
        IF Modified(M_primer_apellido) THEN
          Employee."Last Name" := COPYSTR(Primer_apellido, 1, MAXSTRLEN(Employee."Last Name"));
        IF Modified(M_segundo_apellido) THEN
          Employee."Second Last Name" := COPYSTR(Segundo_apellido, 1, MAXSTRLEN(Employee."Second Last Name"));
        Employee.VALIDATE("Full Name");
        
        IF Modified(M_fecha_antiguedad_reconoci) THEN
          UpdateDateField(Employee."Employment Date", Fecha_antiguedad_reconocida, 0, 'Fecha_antiguedad_reconocida', Employee.FIELDCAPTION("Employment Date"));
        
        IF Modified(M_tipo_documento) THEN
          UpdateOptField(Employee."Document Type", Tipo_documento, 0, 'Tipo_documento', Employee.FIELDCAPTION("Document Type"));
        IF Modified(M_numero_documento) THEN
          UpdateTextField(Employee."Document ID", Numero_documento, 0, 'Numero_documento', Employee.FIELDCAPTION("Document ID"),MAXSTRLEN(Employee."Document ID"));
        
        IF Modified(M_genero) THEN
          UpdateOptField(Employee.Gender, Genero, 0, 'Genero', Employee.FIELDCAPTION(Gender));
        IF Modified(M_estado_civil) THEN
          UpdateOptField(Employee."Estado civil", Estado_civil, 0, 'Estado_civil', Employee.FIELDCAPTION("Estado civil"));
        IF Modified(M_fecha_nacimiento) THEN
          UpdateDateField(Employee."Birth Date", Fecha_nacimiento, 0, 'Fecha_nacimiento', Employee.FIELDCAPTION("Birth Date"));
        IF Modified(M_provincia_nacimiento) OR Modified(M_pais_nacimiento) THEN
          UpdateTextField(Employee."Lugar nacimiento", COPYSTR(Provincia_nacimiento + '-' + Pais_nacimiento,1,MAXSTRLEN(Employee."Lugar nacimiento")),
            0, 'Provincia_nacimiento y Pais_nacimiento', Employee.FIELDCAPTION("Lugar nacimiento"),MAXSTRLEN(Employee."Lugar nacimiento"));
        
        IF Modified(M_nacionalidad) THEN
          UpdateCodeField(Employee.Nacionalidad, Nacionalidad, DATABASE::"Country/Region", 'Nacionalidad', Employee.FIELDCAPTION(Nacionalidad),MAXSTRLEN(Employee.Nacionalidad),'');
        IF Modified(M_pais) THEN
          UpdateCodeField(Employee."Country/Region Code", Pais, DATABASE::"Country/Region", 'Pais', Employee.FIELDCAPTION("Country/Region Code"),MAXSTRLEN(Employee."Country/Region Code"),'');
        IF Modified(M_nombre_calle) THEN
          UpdateTextField(Employee.Address, Nombre_calle, 0, 'Nombre_calle', Employee.FIELDCAPTION(Address),MAXSTRLEN(Employee.Address));
        IF Modified(M_ciudad) THEN
          UpdateTextField(Employee.City, Ciudad, 0, 'Ciudad', Employee.FIELDCAPTION(City),MAXSTRLEN(Employee.City));
        IF Modified(M_codigo_postal) THEN
          UpdateCodeField(Employee."Post Code", Codigo_postal, DATABASE::"Post Code", 'Codigo_postal', Employee.FIELDCAPTION("Post Code"),MAXSTRLEN(Employee."Post Code"),'');
        IF Modified(M_provincia) THEN
          UpdateTextField(Employee.County, Provincia, 0, 'Provincia', Employee.FIELDCAPTION(County),MAXSTRLEN(Employee.County));
        
        IF Modified(M_direccion) THEN
          UpdateTextField(Employee."E-Mail", Direccion, 0, 'Direccion', Employee.FIELDCAPTION("E-Mail"),MAXSTRLEN(Employee."E-Mail"));
        IF Modified(M_numero_telefono) THEN
          UpdateTextField(Employee."Phone No.", Numero_telefono, 0, 'Numero_telefono', Employee.FIELDCAPTION("Phone No."),MAXSTRLEN(Employee."Phone No."));
        
        IF Modified(M_posicion) THEN
          IF ConfSant."Posicion MdE" = ConfSant."Posicion MdE"::"Puesto laboral" THEN
            UpdateCodeField(Employee."Job Type Code", Posicion, DATABASE::"Puestos laborales", 'Posicion', Employee.FIELDCAPTION("Job Type Code"),MAXSTRLEN(Employee."Job Type Code"),'');
        
        IF Modified(M_centro_trabajo) THEN
          UpdateCodeField(Employee."Working Center", Centro_trabajo, DATABASE::"Centros de Trabajo", 'Centro_trabajo', Employee.FIELDCAPTION("Working Center"),MAXSTRLEN(Employee."Working Center"),'');
        IF Modified(M_Categoria_grupo) THEN
          UpdateOptField(Employee.Categoria, Categoria_grupo, 0, 'Categoria_grupo', Employee.FIELDCAPTION(Categoria));
        IF Modified(M_tipo_contrato_grupo) THEN
          UpdateCodeField(Employee."Emplymt. Contract Code", Tipo_contrato_grupo, DATABASE::"Employment Contract", 'Tipo_contrato_grupo', Employee.FIELDCAPTION("Emplymt. Contract Code"),MAXSTRLEN(Employee."Emplymt. Contract Code"),'');
        
        // Campos configurables (division)
        IF Modified(M_departamento) AND (ConfSant."Departamento MdE" = ConfSant."Departamento MdE"::Division) THEN
          UpdateCodeField(Employee.Departamento, Departamento, DATABASE::Departamentos, 'Departamento', Employee.FIELDCAPTION(Departamento),MAXSTRLEN(Employee.Departamento),'');
        IF Modified(M_division) AND (ConfSant."Division MdE" = ConfSant."Division MdE"::Division) THEN
          UpdateCodeField(Employee.Departamento, Division, DATABASE::Departamentos, 'Division', Employee.FIELDCAPTION(Departamento),MAXSTRLEN(Employee.Departamento),'');
        IF Modified(M_area_funcional_grupo) AND (ConfSant."Area funcional MdE" = ConfSant."Area funcional MdE"::Division) THEN
          UpdateCodeField(Employee.Departamento, Area_funcional_grupo, DATABASE::Departamentos, 'Area_funcional_grupo', Employee.FIELDCAPTION(Departamento),MAXSTRLEN(Employee.Departamento),'');
        
        IF NOT IsOk THEN
          EXIT;
        
        Employee.SetFromMde(TRUE);
        IF NOT Employee.MODIFY(TRUE) THEN BEGIN
          AddError(STRSUBSTNO(ErrorModify,Employee.TABLECAPTION,Numero_persona), ErrorTipoDatos);
          EXIT;
        END;
        
        // Campos configurables (dimension)
        IF Modified(M_departamento) AND (ConfSant."Departamento MdE" = ConfSant."Departamento MdE"::Dimension) THEN
          UpdateCodeField(CodeValue, Departamento, DATABASE::"Dimension Value", 'Departamento', STRSUBSTNO(DimensionTxt,ConfSant."Dimension Departamento"),MAXSTRLEN(CodeValue),ConfSant."Dimension Departamento");
        IF Modified(M_division) AND (ConfSant."Division MdE" = ConfSant."Division MdE"::Dimension) THEN
          UpdateCodeField(CodeValue, Division, DATABASE::"Dimension Value", 'Division', STRSUBSTNO(DimensionTxt,ConfSant."Dimension Division"),MAXSTRLEN(CodeValue),ConfSant."Dimension Division");
        IF Modified(M_area_funcional_grupo) AND (ConfSant."Area funcional MdE" = ConfSant."Area funcional MdE"::Dimension) THEN
          UpdateCodeField(CodeValue, Area_funcional_grupo, DATABASE::"Dimension Value", 'Area_funcional_grupo', STRSUBSTNO(DimensionTxt,ConfSant."Dimension Area funcional"),MAXSTRLEN(CodeValue),ConfSant."Dimension Area funcional");
        
        // Campos tabla 76069 "Contratos"
        Contrato.SETRANGE("No. empleado", Employee."No.");
        IF NOT Contrato.FIND('+') THEN BEGIN
          AddError(STRSUBSTNO(ErrorContractDoNotExist, 'Numero_persona', Numero_persona), ErrorTipoDatos);
          EXIT;
        END;
        
        IF Modified(M_fecha_inicio_contrato) THEN
          UpdateDateField(Contrato."Fecha inicio", Fecha_inicio_contrato, 0, 'Fecha_inicio_contrato', Contrato.FIELDCAPTION("Fecha inicio"));
        IF Modified(M_fecha_fin_contrato) THEN
          UpdateDateField(Contrato."Fecha finalización", Fecha_fin_contrato, 0, 'Fecha_fin_contrato', Contrato.FIELDCAPTION("Fecha finalización"));
        IF Modified(M_tipo_baja) THEN
          UpdateCodeField(Contrato."Motivo baja", Tipo_baja, DATABASE::"Grounds for Termination", 'Tipo_baja', Contrato.FIELDCAPTION("Motivo baja"),MAXSTRLEN(Contrato."Motivo baja"),'');
        IF (Contrato."Fecha finalización" <> 0D) AND (Contrato."Fecha inicio" > Contrato."Fecha finalización") THEN BEGIN
          AddError(STRSUBSTNO(ErrorFechas, Contrato."Fecha inicio", Contrato."Fecha finalización"), ErrorTipoDatos);
          EXIT;
        END;
        IF Modified(M_tipo_contrato_grupo) THEN
          Contrato.VALIDATE("Cód. contrato", Employee."Emplymt. Contract Code");
        
        IF IsOk THEN BEGIN
          IF Modified(M_fecha_inicio_contrato) THEN
            Contrato.VALIDATE("Fecha inicio");
          IF Modified(M_fecha_fin_contrato) THEN
            Contrato.VALIDATE("Fecha finalización");
          Contrato.SetFromMde(TRUE);
          IF NOT Contrato.MODIFY(TRUE) THEN BEGIN
            AddError(STRSUBSTNO(ErrorModify,Contrato.TABLECAPTION,Numero_persona), ErrorTipoDatos);
            EXIT;
          END;
        END;
        */

        CreateDefaultDim := false;
        UpdateMdEHistory;
        CreateDefaultDim := true;

        if not IsOk then
            exit;

        if MdEHistory."Fecha efectiva" > Today then begin
            MdEHistory."No." := Employee."No.";
            MdEHistory.Insert(true);
            exit;
        end;

        MdEHistory.ModifyEmployee(Employee);
        IsOk := MdEHistory.GetErrors(DescErrorArray, TipoErrorArray);
        //-#81969

    end;

    local procedure DeleteEmployee()
    var
        Contrato: Record Contratos;
    begin
        EmployeeNo := Numero_persona_sistema_loca;
        if not Employee.Get(EmployeeNo) then begin
            Employee.SetRange("Numero de persona", Numero_persona);
            if not Employee.Find('-') then begin
                AddError(StrSubstNo(ErrorEmployeeDoNotExist, 'Numero_persona', Numero_persona), ErrorTipoDatos);
                exit;
            end;
            EmployeeNo := Employee."No.";
        end;

        //+#81969
        /*
        Contrato.SETRANGE("No. empleado", EmployeeNo);
        IF NOT Contrato.FIND('+') THEN BEGIN
          AddError(STRSUBSTNO(ErrorContractDoNotExist, 'Numero_persona', Numero_persona), ErrorTipoDatos);
          EXIT;
        END;
        
        IF Modified(M_fecha_fin_contrato) THEN BEGIN
          UpdateDateField(Contrato."Fecha finalización", Fecha_fin_contrato, 0, 'Fecha_fin_contrato', Contrato.FIELDCAPTION("Fecha finalización"));
          IF IsOk THEN
            Contrato.VALIDATE("Fecha finalización");
        END;
        IF Modified(M_tipo_baja) THEN
          UpdateCodeField(Contrato."Motivo baja", Tipo_baja, DATABASE::"Grounds for Termination", 'Tipo_baja', Contrato.FIELDCAPTION("Motivo baja"),MAXSTRLEN(Contrato."Motivo baja"),'');
        
        IF IsOk THEN BEGIN
          //Contrato.Activo := FALSE; // el usuario lo manipulará manualmente
          Contrato.VALIDATE(Finalizado, TRUE);
          Contrato.SetFromMde(TRUE);
          IF NOT Contrato.MODIFY(TRUE) THEN BEGIN
            AddError(STRSUBSTNO(ErrorModify,Contrato.TABLECAPTION,Numero_persona), ErrorTipoDatos);
            EXIT;
          END;
        END;
        */

        CreateDefaultDim := false;
        UpdateMdEHistory;
        CreateDefaultDim := true;

        if not IsOk then
            exit;

        if MdEHistory."Fecha efectiva" > Today then begin
            MdEHistory."No." := Employee."No.";
            MdEHistory.Insert(true);
            exit;
        end;

        MdEHistory.DeleteEmployee(Employee);
        IsOk := MdEHistory.GetErrors(DescErrorArray, TipoErrorArray);
        //-#81969

    end;

    local procedure Modified(Value: Text[30]): Boolean
    begin
        exit(Value = 'X');
    end;

    local procedure GetEstado(IsOk: Boolean): Text
    begin
        //5: Failed, 4: Successful, 2: Pending
        if IsOk then
            exit('4')
        else
            exit('5');
    end;

    local procedure AddError(ErrorText: Text; ErrorType: Text)
    var
        i: Integer;
        added: Boolean;
    begin
        if IsOk then
            IsOk := false;

        added := false;
        i := 0;
        repeat
            i += 1;
            if DescErrorArray[i] = '' then begin
                DescErrorArray[i] := ErrorText;
                TipoErrorArray[i] := ErrorType;
                added := true;
            end;
        until (i = ArrayLen(DescErrorArray)) or added;
    end;


    procedure CreateAsyncResponse()
    var
        XmlDomMgnt: Codeunit "XML DOM Management";
        /*    XmlNsMgr: DotNet "System.Xml.XmlNamespaceManager";
           XmlDoc: DotNet XmlDocument;
           XmlNode: DotNet XmlNode;
           XmlNode1: DotNet XmlNode;
           XmlNode2: DotNet XmlNode;
           XmlNode3: DotNet XmlNode;
           XmlNode4: DotNet XmlNode;
           XmlNode5: DotNet XmlNode;
           XmlNode6: DotNet XmlNode;
           XmlNode7: DotNet XmlNode;
           XmlNode8: DotNet XmlNode; */
        MyDT: DateTime;
        i: Integer;
        Response: Text;
        Content: Text;
        NodeName: Text[20];
    begin
        // //+#101415
        // if ConfSant."WS Respuesta MdE" = '' then
        //     exit;
        // //-#101415

        // if Evaluate(MyDT, fecha_origen, 9) then
        //     fecha_origen := MdEMgnt.FormatDateTime(DT2Date(MyDT), DT2Time(MyDT))
        // else
        //     if CopyStr(fecha_origen, StrLen(fecha_origen), 1) = 'Z' then
        //         fecha_origen := CopyStr(fecha_origen, 1, StrLen(fecha_origen) - 1);

        // XmlDoc := XmlDoc.XmlDocument;

        // // nivel 0
        // if IsOk then begin
        //     case Operacion of
        //         'INSERT':
        //             NodeName := 'retornoInsert';
        //         'CHANGE':
        //             NodeName := 'retornoUpdate';
        //         'DELETE':
        //             NodeName := 'retornoDelete';
        //     end;
        // end
        // else
        //     // Funciones del WS Hardcoded
        //     //NodeName := ConfSant."Funcion Error WS MdE";
        //     NodeName := 'retornoError';

        // XmlDoc.LoadXml(
        //   '<?xml version="1.0" encoding="utf-8"?>' +
        //   '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ret="http://retornoAsincrono.santillanaBus">' +
        //   '<soapenv:Header/>' +
        //   '<soapenv:Body>' +
        //   '<ret:' + NodeName + '/>' +
        //   '</soapenv:Body>' +
        //   '</soapenv:Envelope>');
        // XmlNsMgr := XmlNsMgr.XmlNamespaceManager(XmlDoc.NameTable);
        // XmlNsMgr.AddNamespace('soapenv', 'http://schemas.xmlsoap.org/soap/envelope/');
        // XmlNsMgr.AddNamespace('ret', 'http://retornoAsincrono.santillanaBus');
        // XmlNode := XmlDoc.SelectSingleNode('//soapenv:Body/ret:' + NodeName, XmlNsMgr);
        // XmlDomMgnt.AddElement(XmlNode, 'mensaje', '', NS, XmlNode1);

        // // nivel 1
        // XmlDomMgnt.AddElement(XmlNode1, 'head', '', NS, XmlNode2);

        // // nivel 2
        // XmlDomMgnt.AddElement(XmlNode2, 'id_mensaje', id_mensaje, NS, XmlNode3);//de la cabecera recibida
        // XmlDomMgnt.AddElement(XmlNode2, 'sistema_origen', ConfSant.GetSistemaOrigen, NS, XmlNode3);
        // XmlDomMgnt.AddElement(XmlNode2, 'pais_origen', pais_origen, NS, XmlNode3);
        // XmlDomMgnt.AddElement(XmlNode2, 'fecha_origen', fecha_origen, NS, XmlNode3);//de la cabecera recibida
        // XmlDomMgnt.AddElement(XmlNode2, 'fecha', MdEMgnt.FormatDateTime(Today, Time), NS, XmlNode3); // este no se informa
        // XmlDomMgnt.AddElement(XmlNode2, 'tipo', tipo, NS, XmlNode3); //de la cabecera recibida

        // if not IsOk then begin
        //     i := 1;
        //     while (i <= 10) and (DescErrorArray[i] <> '') do begin
        //         XmlDomMgnt.AddElement(XmlNode2, 'error', '', NS, XmlNode3);

        //         // nivel 3
        //         XmlDomMgnt.AddElement(XmlNode3, 'code', 'error', NS, XmlNode4); // ¿?
        //         XmlDomMgnt.AddElement(XmlNode3, 'level', TipoErrorArray[i], NS, XmlNode4);
        //         XmlDomMgnt.AddElement(XmlNode3, 'description', DescErrorArray[i], NS, XmlNode4);

        //         i += 1;
        //     end;
        // end;

        // // nivel 1
        // XmlDomMgnt.AddElement(XmlNode1, 'body', '', NS, XmlNode2);

        // // nivel 2
        // /*
        //     XmlDomMgnt.AddElement(XmlNode2,'Sociedad',ConfSant."Cod. sociedad maestros Santill",NS,XmlNode3);
        //     XmlDomMgnt.AddElement(XmlNode2,'EmpleadoSF',Numero_persona,NS,XmlNode3);
        //     XmlDomMgnt.AddElement(XmlNode2,'EmpleadoSL',EmployeeNo,NS,XmlNode3);
        //     XmlDomMgnt.AddElement(XmlNode2,'Estado',GetEstado(IsOk),NS,XmlNode3); //5: Failed, 4: Successful, 2: Pending

        //     XmlDomMgnt.AddElement(XmlNode2,'FechaIniRepl',FORMAT(MyDT,0,9),NS,XmlNode3); //hoy?
        //     XmlDomMgnt.AddElement(XmlNode2,'FechaProcRepl',FORMAT(MyDT,0,9),NS,XmlNode3); //hoy?
        // */
        // if IsOk then
        //     XmlDomMgnt.AddElement(XmlNode2, 'ok', '', NS, XmlNode3)
        // else
        //     XmlNode3 := XmlNode2;

        // // nivel 3
        // XmlDomMgnt.AddElement(XmlNode3, 'newCodes', '', NS, XmlNode4);

        // // nivel 4
        // XmlDomMgnt.AddElement(XmlNode4, 'newCodeForElement', '', NS, XmlNode5);
        // // nivel 4
        // XmlDomMgnt.AddElement(XmlNode5, 'element', 'empleado', NS, XmlNode6);
        // XmlDomMgnt.AddElement(XmlNode5, 'pk_fields', '', NS, XmlNode6);

        // // ID empleado
        // XmlDomMgnt.AddElement(XmlNode6, 'pk_field', '', NS, XmlNode7);
        // XmlDomMgnt.AddElement(XmlNode7, 'field_name', 'id', NS, XmlNode8);
        // XmlDomMgnt.AddElement(XmlNode7, 'received_value', Numero_persona, NS, XmlNode8);
        // XmlDomMgnt.AddElement(XmlNode7, 'new_value', EmployeeNo, NS, XmlNode8);

        // // Sociedad
        // XmlDomMgnt.AddElement(XmlNode6, 'pk_field', '', NS, XmlNode7);
        // XmlDomMgnt.AddElement(XmlNode7, 'field_name', 'sociedad', NS, XmlNode8);
        // XmlDomMgnt.AddElement(XmlNode7, 'received_value', Sociedad, NS, XmlNode8);
        // XmlDomMgnt.AddElement(XmlNode7, 'new_value', '', NS, XmlNode8);

        // if IsOk then
        //     XmlDomMgnt.AddElement(XmlNode3, 'message', '', NS, XmlNode4)
        // else begin
        //     i := 1;
        //     while (i <= 10) and (DescErrorArray[i] <> '') do begin
        //         XmlDomMgnt.AddElement(XmlNode2, 'error', '', NS, XmlNode3);

        //         // nivel 3
        //         XmlDomMgnt.AddElement(XmlNode3, 'code', 'error', NS, XmlNode4);
        //         XmlDomMgnt.AddElement(XmlNode3, 'description', TipoErrorArray[i], NS, XmlNode4);
        //         XmlDomMgnt.AddElement(XmlNode3, 'message', DescErrorArray[i], NS, XmlNode4);

        //         i += 1;
        //     end;
        // end;

        // //+#101415
        // //IF USERID <> 'DYNASOFT\PJLLANERAS' THEN // pruebas internas, no enviar al WS la respuesta asíncrona
        // //MdEMgnt.SendAsyncPostRequest('WS_RESPUESTA_MDE',ConfSant."WS Respuesta MdE", '', XmlDoc.OuterXml);
        // MdEMgnt.CreateAsyncPostRequest('WS_RESPUESTA_MDE', ConfSant."WS Respuesta MdE", '', XmlDoc.OuterXml);
        // //-#101415

    end;


    procedure SendAsyncResponse()
    begin
        //#101415
        if ConfSant."WS Respuesta MdE" = '' then
            exit;

        MdEMgnt.SendAsyncPostRequest();
    end;


    procedure GetInfo(var New_IsOk: Boolean; var New_id_mensaje: Text[36]; var New_Tipo: Text[20]; var New_FechaOrigen: Text[30]; var New_PaisOrigen: Text[20]; var New_DescErrorArray: array[10] of Text; var New_TipoErrorArray: array[10] of Text)
    begin
        New_IsOk := IsOk;
        New_id_mensaje := id_mensaje;
        New_Tipo := tipo;
        New_FechaOrigen := fecha_origen;
        New_PaisOrigen := pais_origen;
        CopyArray(New_DescErrorArray, DescErrorArray, 1);
        CopyArray(New_TipoErrorArray, TipoErrorArray, 1);
    end;

    local procedure UpdateTextField(var TextVar: Text[200]; NewValue: Text; TableRel: Integer; NodeName: Text[80]; FieldCaption: Text[80]; FieldLenght: Integer)
    begin
        if StrLen(NewValue) > FieldLenght then
            AddError(StrSubstNo(ErrorTamanoCampo, NodeName, NewValue, FieldCaption, FieldLenght), ErrorTipoDatos)
        else
            TextVar := NewValue;

        if IsOk and (TableRel > 0) then
            ValidateTableRel(NewValue, TableRel, NodeName, '');
    end;

    local procedure UpdateCodeField(var CodeVar: Code[100]; NewValue: Text; TableRel: Integer; NodeName: Text[80]; FieldCaption: Text[80]; FieldLenght: Integer; DimensionCode: Code[20])
    var
        DefaultDim: Record "Default Dimension";
    begin
        if StrLen(NewValue) > FieldLenght then
            AddError(StrSubstNo(ErrorTamanoCampo, NodeName, NewValue, FieldCaption, FieldLenght), ErrorTipoDatos)
        else
            if DimensionCode = '' then
                CodeVar := NewValue;

        if IsOk and (TableRel > 0) then begin
            ValidateTableRel(NewValue, TableRel, NodeName, DimensionCode);
            if CreateDefaultDim then //+#81969
                if IsOk and not ('' in [DimensionCode, NewValue, EmployeeNo]) and (TableRel = DATABASE::"Dimension Value") then begin
                    DefaultDim.SetFromMde(true);
                    if DefaultDim.Get(DATABASE::Employee, EmployeeNo, DimensionCode) then begin
                        DefaultDim."Dimension Value Code" := NewValue;
                        if not DefaultDim.Modify(true) then begin // (TRUE) --> Si son dimensiones globales, tienen que actualizar la ficha
                            AddError(StrSubstNo(ErrorModify, DefaultDim.TableCaption, Numero_persona), ErrorTipoDatos);
                            exit;
                        end;
                    end
                    else begin
                        DefaultDim."Table ID" := DATABASE::Employee;
                        DefaultDim."No." := EmployeeNo;
                        DefaultDim."Dimension Code" := DimensionCode;
                        DefaultDim."Dimension Value Code" := NewValue;
                        if not DefaultDim.Insert(true) then begin // (TRUE) --> Si son dimensiones globales, tienen que actualizar la ficha
                            AddError(StrSubstNo(ErrorInsert, DefaultDim.TableCaption, Numero_persona), ErrorTipoDatos);
                            exit;
                        end;
                    end;
                end;
        end;
    end;

    local procedure UpdateOptField(var OptVar: Option; NewValue: Text; TableRel: Integer; NodeName: Text[80]; FieldCaption: Text[80])
    begin
        if not Evaluate(OptVar, NewValue) then
            AddError(StrSubstNo(ErrorTipoVar, NodeName, NewValue, FieldCaption), ErrorTipoDatos);

        if IsOk and (TableRel > 0) then
            ValidateTableRel(NewValue, TableRel, NodeName, '');
    end;

    local procedure UpdateDateField(var DateVar: Date; NewValue: Text; TableRel: Integer; NodeName: Text[80]; FieldCaption: Text[80])
    var
        DateTimeVar: DateTime;
    begin
        if not Evaluate(DateTimeVar, NewValue, 9) then
            AddError(StrSubstNo(ErrorTipoVar, NodeName, NewValue, FieldCaption), ErrorTipoDatos)
        else
            DateVar := DT2Date(DateTimeVar);

        if IsOk and (TableRel > 0) then
            ValidateTableRel(Format(DateVar), TableRel, NodeName, '');
    end;

    local procedure ValidateTableRel(NewValue: Text[200]; TableRel: Integer; NodeName: Text[80]; DimensionCode: Code[20])
    var
        rPais: Record "Country/Region";
        rCodPostal: Record "Post Code";
        rContrato: Record "Employment Contract";
        rCentro: Record "Centros de Trabajo";
        rPuesto: Record "Puestos laborales";
        rMotivoBaja: Record "Grounds for Termination";
        rDptos: Record Departamentos;
        rDim: Record Dimension;
        rDimVal: Record "Dimension Value";
    begin
        case TableRel of
            DATABASE::"Country/Region":
                begin
                    rPais.SetRange(Code, NewValue);
                    if not rPais.FindFirst then
                        AddError(StrSubstNo(ErrorTablaRel, NodeName, NewValue, rPais.TableCaption), ErrorTipoDatos);
                end;
            DATABASE::"Post Code":
                begin
                    // No validamos el CP
                    //rCodPostal.SETRANGE(Code, NewValue);
                    //IF NOT rCodPostal.FINDFIRST THEN
                    //  AddError(STRSUBSTNO(ErrorTablaRel,NodeName,NewValue,rCodPostal.TABLECAPTION), ErrorTipoDatos);
                end;
            DATABASE::"Centros de Trabajo":
                begin
                    rCentro.SetRange("Centro de trabajo", NewValue);
                    rCentro.SetRange("Empresa cotización", EmpCotiz."Empresa cotizacion");
                    if not rCentro.FindFirst then
                        AddError(StrSubstNo(ErrorTablaRel, NodeName, EmpCotiz."Empresa cotizacion" + '-' + NewValue, rCentro.TableCaption), ErrorTipoDatos);
                end;
            DATABASE::"Employment Contract":
                begin
                    rContrato.SetRange(Code, NewValue);
                    if not rContrato.FindFirst then
                        AddError(StrSubstNo(ErrorTablaRel, NodeName, NewValue, rContrato.TableCaption), ErrorTipoDatos);
                end;
            DATABASE::"Puestos laborales":
                begin
                    rPuesto.SetRange(Codigo, NewValue);
                    if not rPuesto.FindFirst then
                        AddError(StrSubstNo(ErrorTablaRel, NodeName, NewValue, rPuesto.TableCaption), ErrorTipoDatos);
                end;
            DATABASE::Departamentos:
                begin
                    rDptos.SetRange(Codigo, NewValue);
                    if not rDptos.FindFirst then
                        AddError(StrSubstNo(ErrorTablaRel, NodeName, NewValue, rDptos.TableCaption), ErrorTipoDatos);
                end;
            DATABASE::"Grounds for Termination":
                begin
                    rMotivoBaja.SetRange(Code, NewValue);
                    if not rMotivoBaja.FindFirst then
                        AddError(StrSubstNo(ErrorTablaRel, NodeName, NewValue, rMotivoBaja.TableCaption), ErrorTipoDatos);
                end;
            DATABASE::"Dimension Value":
                begin
                    if not rDim.Get(DimensionCode) then
                        AddError(StrSubstNo(ErrorDimension, NodeName, DimensionCode), ErrorTipoDatos);
                    if not rDimVal.Get(DimensionCode, NewValue) then
                        AddError(StrSubstNo(ErrorValorDimension, NodeName, NewValue, DimensionCode), ErrorTipoDatos);
                end;
        end;
    end;

    local procedure LocalizarEmpleadoError(Create: Boolean) Error: Boolean
    var
        Found: Boolean;
        DocID: Text[15];
        NewDocID: Text[15];
        DocType: Integer;
    begin
        if Create then
            Clear(EmployeeNo)
        else
            EmployeeNo := Numero_persona_sistema_loca;

        Found := Employee.Get(EmployeeNo);
        if not Found then begin
            Employee.SetRange("Numero de persona", Numero_persona);
            Found := Employee.FindFirst;
            if Found then
                Found := Employee."Document ID" = Numero_documento;
            if not Found then begin
                Clear(Employee);
                UpdateOptField(Employee."Document Type", Tipo_documento, 0, 'Tipo_documento', Employee.FieldCaption("Document Type"));
                UpdateTextField(Employee."Document ID", Numero_documento, 0, 'Numero_documento', Employee.FieldCaption("Document ID"), MaxStrLen(Employee."Document ID"));
                if not IsOk then
                    exit(true);
                DocType := Employee."Document Type";
                DocID := Employee."Document ID";
                Employee.SetRange("Document Type", DocType);
                Employee.SetRange("Document ID", DocID);
                Found := Employee.FindFirst;

                if not Found then begin
                    NewDocID := DelChr(DocID, '=', '\|@#~¬º''¡ª!"·$%&/()=?¿[]{}`+Ùç,.-<^*õÇ;:_>');
                    if NewDocID <> DocID then begin
                        Employee.SetRange("Document ID", NewDocID);
                        Found := Employee.FindFirst;
                    end;
                end;

            end;
        end;

        if Create then begin
            if Found then begin
                AddError(StrSubstNo(ErrorEmployeeExist, Employee."No.", Employee."Document Type", Employee."Document ID", Numero_persona), ErrorTipoDatos);
                exit(true);
            end;
            Employee.Init;
        end
        else begin
            if not Found then begin
                AddError(StrSubstNo(ErrorEmployeeDoNotExist, 'Numero_persona', Numero_persona), ErrorTipoDatos);
                exit(true);
            end;
            EmployeeNo := Employee."No.";
        end;

        exit(false);
    end;


    procedure IsNewContract(): Boolean
    begin
        exit(Motivo_contratacion_sistema in ['AltasNAV01', 'AltasNAV02', 'AltasNAV03', 'AltasNAV04', 'AltasNAV05', 'AltasNAV06', 'AltasNAV07', 'AltasNAV13', 'AltasNAV14']);
    end;


    procedure IsRecontratacion(): Boolean
    begin
        exit(Motivo_contratacion_sistema in ['AltasNAV08', 'AltasNAV09', 'AltasNAV10', 'AltasNAV11']);
    end;


    procedure GetOutStrm(var wOutStrm: OutStream)
    begin
        //+#101415
        MdEMgnt.GetOutStrm(wOutStrm);

        Exporting := true;
    end;


    procedure UpdateMdEHistory()
    begin
        //+#81969
        MdEHistory.Init;
        MdEHistory."No." := '';
        MdEHistory."No. Mov." := 0;
        MdEHistory."Fecha y hora recepcion" := CurrentDateTime;

        case Operacion of
            'INSERT':
                begin
                    MdEHistory."Tipo envio" := MdEHistory."Tipo envio"::INSERT;

                    // campos employee
                    MdEHistory."M nombre" := Nombre <> '';
                    MdEHistory."M primer apellido" := Primer_apellido <> '';
                    MdEHistory."M segundo apellido" := Segundo_apellido <> '';
                    MdEHistory."M fecha antiguedad reconoci" := Fecha_antiguedad_reconocida <> '';
                    MdEHistory."M tipo documento" := Tipo_documento <> '';
                    MdEHistory."M numero documento" := Numero_documento <> '';
                    MdEHistory."M genero" := Genero <> '';
                    MdEHistory."M estado civil" := Estado_civil <> '';
                    MdEHistory."M fecha nacimiento" := Fecha_nacimiento <> '';
                    MdEHistory."M provincia nacimiento" := Provincia_nacimiento <> '';
                    MdEHistory."M pais nacimiento" := Pais_nacimiento <> '';
                    MdEHistory."M nacionalidad" := Nacionalidad <> '';
                    MdEHistory."M pais" := Pais <> '';
                    MdEHistory."M nombre calle" := Nombre_calle <> '';
                    MdEHistory."M ciudad" := Ciudad <> '';
                    MdEHistory."M codigo postal" := Codigo_postal <> '';
                    MdEHistory."M provincia" := Provincia <> '';
                    MdEHistory."M direccion" := Direccion <> '';
                    MdEHistory."M numero telefono" := Numero_telefono <> '';
                    MdEHistory."M posicion" := Posicion <> '';
                    MdEHistory."M centro trabajo" := Centro_trabajo <> '';
                    MdEHistory."M Categoria grupo" := Categoria_grupo <> '';
                    MdEHistory."M tipo contrato grupo" := Tipo_contrato_grupo <> '';

                    // Campos configurables (division/dimension)
                    MdEHistory."M departamento" := Departamento <> '';
                    MdEHistory."M division" := Division <> '';
                    MdEHistory."M area funcional grupo" := Area_funcional_grupo <> '';

                    // campos contrato
                    MdEHistory."M fecha inicio contrato" := Fecha_inicio_contrato <> '';
                    MdEHistory."M fecha fin contrato" := Fecha_fin_contrato <> '';
                    MdEHistory."M tipo baja" := Tipo_baja <> '';
                end;
            'CHANGE':
                begin
                    MdEHistory."Tipo envio" := MdEHistory."Tipo envio"::CHANGE;

                    // campos employee
                    MdEHistory."M nombre" := Modified(M_nombre);
                    MdEHistory."M primer apellido" := Modified(M_primer_apellido);
                    MdEHistory."M segundo apellido" := Modified(M_segundo_apellido);
                    MdEHistory."M fecha antiguedad reconoci" := Modified(M_fecha_antiguedad_reconoci);
                    MdEHistory."M tipo documento" := Modified(M_tipo_documento);
                    MdEHistory."M numero documento" := Modified(M_numero_documento);
                    MdEHistory."M genero" := Modified(M_genero);
                    MdEHistory."M estado civil" := Modified(M_estado_civil);
                    MdEHistory."M fecha nacimiento" := Modified(M_fecha_nacimiento);
                    MdEHistory."M provincia nacimiento" := Modified(M_provincia_nacimiento);
                    MdEHistory."M pais nacimiento" := Modified(M_pais_nacimiento);
                    MdEHistory."M nacionalidad" := Modified(M_nacionalidad);
                    MdEHistory."M pais" := Modified(M_pais);
                    MdEHistory."M nombre calle" := Modified(M_nombre_calle);
                    MdEHistory."M ciudad" := Modified(M_ciudad);
                    MdEHistory."M codigo postal" := Modified(M_codigo_postal);
                    MdEHistory."M provincia" := Modified(M_provincia);
                    MdEHistory."M direccion" := Modified(M_direccion);
                    MdEHistory."M numero telefono" := Modified(M_numero_telefono);
                    MdEHistory."M posicion" := Modified(M_posicion);
                    MdEHistory."M centro trabajo" := Modified(M_centro_trabajo);
                    MdEHistory."M Categoria grupo" := Modified(M_Categoria_grupo);
                    MdEHistory."M tipo contrato grupo" := Modified(M_tipo_contrato_grupo);

                    // Campos configurables (division/dimension)
                    MdEHistory."M departamento" := Modified(M_departamento);
                    MdEHistory."M division" := Modified(M_division);
                    MdEHistory."M area funcional grupo" := Modified(M_area_funcional_grupo);

                    // campos contrato
                    MdEHistory."M fecha inicio contrato" := Modified(M_fecha_inicio_contrato);
                    MdEHistory."M fecha fin contrato" := Modified(M_fecha_fin_contrato);
                    MdEHistory."M tipo baja" := Modified(M_tipo_baja);
                end;
            'DELETE':
                begin
                    MdEHistory."Tipo envio" := MdEHistory."Tipo envio"::DELETE;

                    if Fecha_fin_contrato = '' then begin
                        AddError(StrSubstNo(ErrorDatoObligatorio, 'DELETE', 'Fecha_fin_contrato'), ErrorTipoDatos);
                        exit;
                    end;
                    if Tipo_baja = '' then begin
                        AddError(StrSubstNo(ErrorDatoObligatorio, 'DELETE', 'Tipo_baja'), ErrorTipoDatos);
                        exit;
                    end;

                    MdEHistory."M fecha fin contrato" := true;
                    MdEHistory."M tipo baja" := true;
                end;
        end;

        UpdateDateField(MdEHistory."Fecha efectiva", Fecha_efectiva, 0, 'Fecha_efectiva', MdEHistory.FieldCaption("Fecha efectiva"));
        if MdEHistory."Fecha efectiva" = 0D then
            MdEHistory."Fecha efectiva" := Today;

        if MdEHistory."Numero de persona" <> Numero_persona then
            UpdateTextField(MdEHistory."Numero de persona", Numero_persona, 0, 'Numero_persona', MdEHistory.FieldCaption("Numero de persona"), MaxStrLen(MdEHistory."Numero de persona"));
        MdEHistory.Company := EmpCotiz."Empresa cotizacion";
        if MdEHistory."M nombre" then
            MdEHistory."First Name" := CopyStr(Nombre, 1, MaxStrLen(MdEHistory."First Name"));
        if MdEHistory."M primer apellido" then
            MdEHistory."Last Name" := CopyStr(Primer_apellido, 1, MaxStrLen(MdEHistory."Last Name"));
        if MdEHistory."M segundo apellido" then
            MdEHistory."Second Last Name" := CopyStr(Segundo_apellido, 1, MaxStrLen(MdEHistory."Second Last Name"));
        MdEHistory.Validate("Full Name");

        if MdEHistory."M fecha antiguedad reconoci" then
            UpdateDateField(MdEHistory."Employment Date", Fecha_antiguedad_reconocida, 0, 'Fecha_antiguedad_reconocida', MdEHistory.FieldCaption("Employment Date"));

        if MdEHistory."M tipo documento" then
            UpdateOptField(MdEHistory."Document Type", Tipo_documento, 0, 'Tipo_documento', MdEHistory.FieldCaption("Document Type"));
        if MdEHistory."M numero documento" then
            UpdateTextField(MdEHistory."Document ID", Numero_documento, 0, 'Numero_documento', MdEHistory.FieldCaption("Document ID"), MaxStrLen(MdEHistory."Document ID"));

        if MdEHistory."M genero" then
            UpdateOptField(MdEHistory.Gender, Genero, 0, 'Genero', MdEHistory.FieldCaption(MdEHistory.Gender));
        if MdEHistory."M estado civil" then
            UpdateOptField(MdEHistory."Estado civil", Estado_civil, 0, 'Estado_civil', MdEHistory.FieldCaption("Estado civil"));
        if MdEHistory."M fecha nacimiento" then
            UpdateDateField(MdEHistory."Birth Date", Fecha_nacimiento, 0, 'Fecha_nacimiento', MdEHistory.FieldCaption("Birth Date"));
        if MdEHistory."M provincia nacimiento" or MdEHistory."M pais nacimiento" then
            UpdateTextField(MdEHistory."Lugar nacimiento", CopyStr(Provincia_nacimiento + '-' + Pais_nacimiento, 1, MaxStrLen(MdEHistory."Lugar nacimiento")),
              0, 'Provincia_nacimiento y Pais_nacimiento', MdEHistory.FieldCaption("Lugar nacimiento"), MaxStrLen(MdEHistory."Lugar nacimiento"));

        if MdEHistory."M nacionalidad" then
            UpdateCodeField(MdEHistory._Nacionalidad, Nacionalidad, DATABASE::"Country/Region", 'Nacionalidad', MdEHistory.FieldCaption(MdEHistory._Nacionalidad), MaxStrLen(MdEHistory._Nacionalidad), '');
        if MdEHistory."M pais" then
            UpdateCodeField(MdEHistory."Country/Region Code", Pais, DATABASE::"Country/Region", 'Pais', MdEHistory.FieldCaption("Country/Region Code"), MaxStrLen(MdEHistory."Country/Region Code"), '');
        if MdEHistory."M nombre calle" then
            UpdateTextField(MdEHistory.Address, Nombre_calle, 0, 'Nombre_calle', MdEHistory.FieldCaption(MdEHistory.Address), MaxStrLen(MdEHistory.Address));
        if MdEHistory."M ciudad" then
            UpdateTextField(MdEHistory.City, Ciudad, 0, 'Ciudad', MdEHistory.FieldCaption(MdEHistory.City), MaxStrLen(MdEHistory.City));
        if MdEHistory."M codigo postal" then
            UpdateCodeField(MdEHistory."Post Code", Codigo_postal, DATABASE::"Post Code", 'Codigo_postal', MdEHistory.FieldCaption("Post Code"), MaxStrLen(MdEHistory."Post Code"), '');
        if MdEHistory."M provincia" then
            UpdateTextField(MdEHistory.County, Provincia, 0, 'Provincia', MdEHistory.FieldCaption(MdEHistory.County), MaxStrLen(MdEHistory.County));

        if MdEHistory."M direccion" then
            UpdateTextField(MdEHistory."E-Mail", Direccion, 0, 'Direccion', MdEHistory.FieldCaption("E-Mail"), MaxStrLen(MdEHistory."E-Mail"));
        if MdEHistory."M numero telefono" then
            UpdateTextField(MdEHistory."Phone No.", Numero_telefono, 0, 'Numero_telefono', MdEHistory.FieldCaption("Phone No."), MaxStrLen(MdEHistory."Phone No."));

        if MdEHistory."M posicion" then
            if ConfSant."Posicion MdE" = ConfSant."Posicion MdE"::"Puesto laboral" then
                UpdateCodeField(MdEHistory."Job Type Code", Posicion, DATABASE::"Puestos laborales", 'Posicion', MdEHistory.FieldCaption("Job Type Code"), MaxStrLen(MdEHistory."Job Type Code"), '');

        if MdEHistory."M centro trabajo" then
            UpdateCodeField(MdEHistory."Working Center", Centro_trabajo, DATABASE::"Centros de Trabajo", 'Centro_trabajo', MdEHistory.FieldCaption("Working Center"), MaxStrLen(MdEHistory."Working Center"), '');
        if MdEHistory."M Categoria grupo" then
            UpdateOptField(MdEHistory._Categoria, Categoria_grupo, 0, 'Categoria_grupo', MdEHistory.FieldCaption(MdEHistory._Categoria));
        if MdEHistory."M tipo contrato grupo" then
            UpdateCodeField(MdEHistory."Emplymt. Contract Code", Tipo_contrato_grupo, DATABASE::"Employment Contract", 'Tipo_contrato_grupo', MdEHistory.FieldCaption("Emplymt. Contract Code"), MaxStrLen(MdEHistory."Emplymt. Contract Code"), '');

        // Campos configurables (division)
        if MdEHistory."M departamento" and (ConfSant."Departamento MdE" = ConfSant."Departamento MdE"::Division) then
            UpdateCodeField(MdEHistory._Departamento, Departamento, DATABASE::Departamentos, 'Departamento', MdEHistory.FieldCaption(MdEHistory._Departamento), MaxStrLen(MdEHistory._Departamento), '');
        if MdEHistory."M division" and (ConfSant."Division MdE" = ConfSant."Division MdE"::Division) then
            UpdateCodeField(MdEHistory._Departamento, Division, DATABASE::Departamentos, 'Division', MdEHistory.FieldCaption(MdEHistory._Departamento), MaxStrLen(MdEHistory._Departamento), '');
        if MdEHistory."M area funcional grupo" and (ConfSant."Area funcional MdE" = ConfSant."Area funcional MdE"::Division) then
            UpdateCodeField(MdEHistory._Departamento, Area_funcional_grupo, DATABASE::Departamentos, 'Area_funcional_grupo', MdEHistory.FieldCaption(MdEHistory._Departamento), MaxStrLen(MdEHistory._Departamento), '');

        if not IsOk then
            exit;

        // Campos configurables (dimension)
        if MdEHistory."M departamento" and (ConfSant."Departamento MdE" = ConfSant."Departamento MdE"::Dimension) then begin
            MdEHistory."Cod. Dimension" := ConfSant."Dimension Departamento";
            UpdateCodeField(MdEHistory."Valor Dimension", Departamento, DATABASE::"Dimension Value", 'Departamento', StrSubstNo(DimensionTxt, ConfSant."Dimension Departamento"), MaxStrLen(CodeValue), ConfSant."Dimension Departamento");
        end;
        if MdEHistory."M division" and (ConfSant."Division MdE" = ConfSant."Division MdE"::Dimension) then begin
            MdEHistory."Cod. Dimension" := ConfSant."Dimension Division";
            UpdateCodeField(MdEHistory."Valor Dimension", Division, DATABASE::"Dimension Value", 'Division', StrSubstNo(DimensionTxt, ConfSant."Dimension Division"), MaxStrLen(CodeValue), ConfSant."Dimension Division");
        end;
        if MdEHistory."M area funcional grupo" and (ConfSant."Area funcional MdE" = ConfSant."Area funcional MdE"::Dimension) then begin
            MdEHistory."Cod. Dimension" := ConfSant."Dimension Area funcional";
            UpdateCodeField(MdEHistory."Valor Dimension", Area_funcional_grupo, DATABASE::"Dimension Value", 'Area_funcional_grupo', StrSubstNo(DimensionTxt, ConfSant."Dimension Area funcional"), MaxStrLen(CodeValue), ConfSant."Dimension Area funcional");
        end;

        // Campos tabla 76069 "Contratos"
        if MdEHistory."M fecha inicio contrato" then
            UpdateDateField(MdEHistory."Alta contrato", Fecha_inicio_contrato, 0, 'Fecha_inicio_contrato', MdEHistory.FieldCaption("Alta contrato"));
        if MdEHistory."M fecha fin contrato" then
            UpdateDateField(MdEHistory."Fin contrato", Fecha_fin_contrato, 0, 'Fecha_fin_contrato', MdEHistory.FieldCaption("Fin contrato"));
        if MdEHistory."M tipo baja" then
            UpdateCodeField(MdEHistory."Grounds for Term. Code", Tipo_baja, DATABASE::"Grounds for Termination", 'Tipo_baja', MdEHistory.FieldCaption("Grounds for Term. Code"), MaxStrLen(MdEHistory."Grounds for Term. Code"), '');
        if (MdEHistory."Fin contrato" <> 0D) and (MdEHistory."Alta contrato" > MdEHistory."Fin contrato") then begin
            AddError(StrSubstNo(ErrorFechas, MdEHistory."Alta contrato", MdEHistory."Fin contrato"), ErrorTipoDatos);
            exit;
        end;

        if MdEHistory."M tipo contrato grupo" then
            MdEHistory.Validate("Emplymt. Contract Code");

        if IsOk then begin
            if MdEHistory."M fecha inicio contrato" then
                MdEHistory.Validate("Alta contrato");
            if MdEHistory."M fecha fin contrato" then
                MdEHistory.Validate("Fin contrato");
        end;
    end;
}

