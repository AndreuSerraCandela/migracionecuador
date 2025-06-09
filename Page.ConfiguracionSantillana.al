#pragma implicitwith disable
page 56002 "Configuracion Santillana"
{
    ApplicationArea = all;
    // #830  CAT Creacion de los campos:
    //     "Cód Cliente Call Center"
    //     "Días Borrado Rvas. Call"
    // 
    // #72814, RRT, 30.11.2017: Incluiri el sistema origen.
    // #81969 27/01/2018 PLB: Usuario notificacion para el "Historial MdE"
    //  Proyecto: Implementacion Business Central
    // 
    //  LDP: Luis Jose De La Cruz Paredes
    //  ------------------------------------------------------------------------
    //  No.        Fecha           Firma    Descripcion
    //  ------------------------------------------------------------------------
    //  SIC-JERM  04/09/2023       LDP      Creación campos: "Liquidar Pago TPV","Desliquidar Pago TPV"


    Caption = 'Santillana Setup';
    PageType = Card;
    SourceTable = "Config. Empresa";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Country; rec.Country)
                {
                }
                field("Dim. Tipo Facturacion"; rec."Dim. Tipo Facturacion")
                {
                }
                field("Funcionalidad NCF Activa"; rec."Funcionalidad NCF Activa")
                {
                }
                field("Ubicacion XML SRI"; rec."Ubicacion XML SRI")
                {
                }
            }
            group(Contabilidad)
            {
                Caption = 'Accounting';
                field("Grupo Reg. Iva Prod. Exento"; rec."Grupo Reg. Iva Prod. Exento")
                {
                }
                field("Activos Fijos Nuevos Bloqueado"; rec."Activos Fijos Nuevos Bloqueado")
                {
                }
            }
            group(Cobros)
            {
                field("Libro Diario Cheques Posf."; rec."Libro Diario Cheques Posf.")
                {
                }
                field("Seccion Diario Cheques Posf."; rec."Seccion Diario Cheques Posf.")
                {
                }
                field("% Retencion Vta."; rec."% Retencion Vta.")
                {
                }
            }
            group(Ventas)
            {
                field("Importe para solicitar ID"; rec."Importe para solicitar ID")
                {
                }
                field("Anula NCF al Reimprimir"; rec."Anula NCF al Reimprimir")
                {
                }
                field("Control Lin. por Factura"; rec."Control Lin. por Factura")
                {
                }
                field("Cantidad Lin. por factura"; rec."Cantidad Lin. por factura")
                {
                }
                field("No. Serie Consig. Reg."; rec."No. Serie Consig. Reg.")
                {
                }
                field("No. serie Dev. Consignacion"; rec."No. serie Dev. Consignacion")
                {
                }
                field("Titulo E-mail Confirm. Pedido"; rec."Titulo E-mail Confirm. Pedido")
                {
                }
                field("Credito excedido %"; rec."Credito excedido %")
                {
                }
                field("% Beneficio Vta. Cte. Internos"; rec."% Beneficio Vta. Cte. Internos")
                {
                }
                field("Ubicacion Reportes-Email"; rec."Ubicacion Reportes-Email")
                {
                }
                field("Notificacion de Credito %"; rec."Notificacion de Credito %")
                {
                }
                field("Proveedor Muestras"; rec."Proveedor Muestras")
                {
                }
                field("Imprimir Remision Venta"; rec."Imprimir Remision Venta")
                {
                }
                field("Habilitar NCF en Consignacion"; rec."Habilitar NCF en Consignacion")
                {
                }
                field("Location code for returns"; rec."Location code for returns")
                {
                }
                field("No. serie Cupon"; rec."No. serie Cupon")
                {
                }
                field("Cantidad Lineas en Cupón"; rec."Cantidad Lineas en Cupón")
                {
                }
                field("Funcionalidad Imp. Fiscal Act."; rec."Funcionalidad Imp. Fiscal Act.")
                {
                }
                field("Copia Fact. Imp. Fiscal Panama"; rec."Copia Fact. Imp. Fiscal Panama")
                {
                }
                field("Copia NDC Imp. Fiscal Panama"; rec."Copia NDC Imp. Fiscal Panama")
                {
                }
                field("Impresion Muestras"; rec."Impresion Muestras")
                {
                }
                field("Cód Cliente Call Center"; rec."Cód Cliente Call Center")
                {
                }
                field("Días Borrado Rvas. Call Center"; rec."Días Borrado Rvas. Call Center")
                {
                }
            }
            group(Compra)
            {
                Caption = 'Purchase';
                field("Proveedor Bloqueado al crear"; rec."Proveedor Bloqueado al crear")
                {
                }
                field("Genera NCF en Retencion"; rec."Genera NCF en Retencion")
                {
                }
                field("E-Mail copia pagos a Proveedor"; rec."E-Mail copia pagos a Proveedor")
                {
                }
            }
            group(Inventario)
            {
                field("NCF en Remision de Ventas"; rec."NCF en Remision de Ventas")
                {
                }
                field("Productos nuevos bloqueados"; rec."Productos nuevos bloqueados")
                {
                }
                field("Grpo. Contable Existencia"; rec."Grpo. Contable Existencia")
                {
                }
                field("Directorio temporal etiquetas"; rec."Directorio temporal etiquetas")
                {
                }
                field("Cta. Contable existencia"; rec."Cta. Contable existencia")
                {
                }
                field("Alm. por Def. Consignacion"; rec."Alm. por Def. Consignacion")
                {
                }
                field("Controla Transf. Alm. Consig."; rec."Controla Transf. Alm. Consig.")
                {
                }
                field("ID Formato Imp. Consignacion"; rec."ID Formato Imp. Consignacion")
                {
                }
                field("No. Serie Packing"; rec."No. Serie Packing")
                {
                }
                field("No. Serie Cajas Packing"; rec."No. Serie Cajas Packing")
                {
                }
                field("No. Serie Packing Reg."; rec."No. Serie Packing Reg.")
                {
                }
                field("ID Reporte Etiqueta de Caja"; rec."ID Reporte Etiqueta de Caja")
                {
                }
                field("ID Reporte Borrador Packing"; rec."ID Reporte Borrador Packing")
                {
                }
            }
            group("Refacturación")
            {
                field("Almacen refacturacion"; rec."Almacen refacturacion")
                {
                }
                field("Cod. Dimemsion Refacturacion"; rec."Cod. Dimemsion Refacturacion")
                {
                }
                field("Valor Dimemsion Refacturacion"; rec."Valor Dimemsion Refacturacion")
                {
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {
                }
            }
            group("Derechos de Autor")
            {
                field("% IVA Activo"; rec."% IVA Activo")
                {
                }
                field("Grupo Precio Int. Der. Aut."; rec."Grupo Precio Int. Der. Aut.")
                {
                }
            }
            group("Clasificación de devoluciones")
            {
                field("Liquidacion devoluciones"; rec."Liquidacion devoluciones")
                {
                }
                field("Almacen prod. defectuosos"; rec."Almacen prod. defectuosos")
                {
                }
                field("Codeunit clas. devoluciones"; rec."Codeunit clas. devoluciones")
                {
                }
                field("Fecha Origen"; rec."Fecha Origen")
                {
                }
                field("Fecha Inicio Campaña"; rec."Fecha Inicio Campaña")
                {
                }
                field("Fecha Fin Campaña"; rec."Fecha Fin Campaña")
                {
                }
                field("Emitir un Solo Documento"; rec."Emitir un Solo Documento")
                {
                }
                field("No. Serie Pre Devolucion"; rec."No. Serie Pre Devolucion")
                {
                }
            }
            group("Controls Activation")
            {
                Caption = 'Controls Activation';
                field("Clientes Nuevos Bloqueados"; rec."Clientes Nuevos Bloqueados")
                {
                }
                field("Cta. Ingresos Prov. Insolv."; rec."Cta. Ingresos Prov. Insolv.")
                {
                    Caption = 'Cta. Ingresos Prov. Insolvencias';
                }
                field("Cta. Gastos Prov. Insolv."; rec."Cta. Gastos Prov. Insolv.")
                {
                    Caption = 'Cta. Gastos Prov. Insolvencias';
                }
            }
            group(MdX)
            {
                field("Cod. sociedad maestros Santill"; rec."Cod. sociedad maestros Santill")
                {
                }
                field("Cod. Sociedad CO maestros"; rec."Cod. Sociedad CO maestros")
                {
                }
                field("Cod. pais maestros Santill"; rec."Cod. pais maestros Santill")
                {
                }
                field("Cod. divisa local MdX"; rec."Cod. divisa local MdX")
                {
                }
                field("Sistema origen"; rec."Sistema origen")
                {
                }
                field(GetSistemaOrigen; rec.GetSistemaOrigen)
                {
                    Caption = 'Sistema origen en respuesta';
                    Editable = false;
                    Importance = Additional;
                }
                group(MdE)
                {
                    field("MdE Activo"; rec."MdE Activo")
                    {
                    }
                    field("WS Respuesta MdE"; rec."WS Respuesta MdE")
                    {
                    }
                    field("WS Informacion Compl. MdE"; rec."WS Informacion Compl. MdE")
                    {
                    }
                    field("Centro de coste MdE"; rec."Centro de coste MdE")
                    {

                        trigger OnValidate()
                        begin
                            ValidaMdE;
                        end;
                    }
                    field("Dimension Centro Coste"; rec."Dimension Centro Coste")
                    {
                        Editable = blncentrocoste;
                    }
                    field("Departamento MdE"; rec."Departamento MdE")
                    {

                        trigger OnValidate()
                        begin
                            ValidaMdE;
                        end;
                    }
                    field("Dimension Departamento"; rec."Dimension Departamento")
                    {
                        Editable = blndepartamento;
                    }
                    field("Division MdE"; rec."Division MdE")
                    {

                        trigger OnValidate()
                        begin
                            ValidaMdE;
                        end;
                    }
                    field("Dimension Division"; rec."Dimension Division")
                    {
                        Editable = blndivision;
                    }
                    field("Area funcional MdE"; rec."Area funcional MdE")
                    {

                        trigger OnValidate()
                        begin
                            ValidaMdE;
                        end;
                    }
                    field("Dimension Area funcional"; rec."Dimension Area funcional")
                    {
                        Editable = blnareafuncional;
                    }
                    field("Posicion MdE"; rec."Posicion MdE")
                    {
                    }
                    field("Usuario notificaciones MdE"; rec."Usuario notificaciones MdE")
                    {
                    }
                }
            }
            group(Todo)
            {
                field(Country2; rec.Country)
                {
                }
                field("Titulo E-mail Pedido de Venta"; rec."Titulo E-mail Pedido de Venta")
                {
                }
                field("Ubicacion Temp. Reportes HTML"; rec."Ubicacion Temp. Reportes HTML")
                {
                }
                field("No. serie Dev. Consignacion2"; rec."No. serie Dev. Consignacion")
                {
                }
                field("No. serie Dev. Consg. Reg."; rec."No. serie Dev. Consg. Reg.")
                {
                }
                field("Grpo. Contable Existencia>"; rec."Grpo. Contable Existencia")
                {
                }
                field("Cta. Contable existencia>"; rec."Cta. Contable existencia")
                {
                }
                field("Alm. por Def. Consignacion>"; rec."Alm. por Def. Consignacion")
                {
                }
                field("Titulo E-mail Confirm. Pedido>"; rec."Titulo E-mail Confirm. Pedido")
                {
                }
                field("Credito excedido %>"; rec."Credito excedido %")
                {
                }
                field("Ubicacion Reportes-Email>"; rec."Ubicacion Reportes-Email")
                {
                }
                field("Nombre Reporte Prod. Cero>"; rec."Nombre Reporte Prod. Cero")
                {
                }
                field("Notificacion de Credito %>"; rec."Notificacion de Credito %")
                {
                }
                field("No. serie pre pedido>"; rec."No. serie pre pedido")
                {
                }
                field("No. Serie Consig. Reg.>"; rec."No. Serie Consig. Reg.")
                {
                }
                field("Proveedor Muestras>"; rec."Proveedor Muestras")
                {
                }
                field("Dim. Tipo Facturacion>"; rec."Dim. Tipo Facturacion")
                {
                }
                field("No. serie Cupon>"; rec."No. serie Cupon")
                {
                }
                field("Imprimir Remision Venta>"; rec."Imprimir Remision Venta")
                {
                }
                field("Habilitar NCF en Consignacion>"; rec."Habilitar NCF en Consignacion")
                {
                }
                field("Location code for returns>"; rec."Location code for returns")
                {
                }
                field("Direccion Cupon tienda 1>"; rec."Direccion Cupon tienda 1")
                {
                }
                field("Direccion Cupon tienda 2>"; rec."Direccion Cupon tienda 2")
                {
                }
                field("Direccion Cupon tienda 3>"; rec."Direccion Cupon tienda 3")
                {
                }
                field("Direccion Cupon tienda 4>"; rec."Direccion Cupon tienda 4")
                {
                }
                field("Direccion Cupon tienda 5>"; rec."Direccion Cupon tienda 5")
                {
                }
                field("Direccion Cupon tienda 6>"; rec."Direccion Cupon tienda 6")
                {
                }
                field("Cantidad Lineas en Cupón>"; rec."Cantidad Lineas en Cupón")
                {
                }
                field("VAT Prod. Posting Group>"; rec."VAT Prod. Posting Group")
                {
                }
                field("Controla Transf. Alm. Consig.>"; rec."Controla Transf. Alm. Consig.")
                {
                }
                field("Almacen refacturacion>"; rec."Almacen refacturacion")
                {
                }
                field("Cod. Dimemsion Refacturacion>"; rec."Cod. Dimemsion Refacturacion")
                {
                }
                field("Valor Dimemsion Refacturacion>"; rec."Valor Dimemsion Refacturacion")
                {
                }
                field("Payment Terms Code>"; rec."Payment Terms Code")
                {
                }
                field("No. Serie Pre Devolucion>"; rec."No. Serie Pre Devolucion")
                {
                }
                field("ID Empresa FE>"; rec."ID Empresa FE")
                {
                }
                field("Funcionalidad FE Activa>"; rec."Funcionalidad FE Activa")
                {
                }
                field("Reporte Factura Resguardo>"; rec."Reporte Factura Resguardo")
                {
                }
                field("Reporte Factura Fact. Elect.>"; rec."Reporte Factura Fact. Elect.")
                {
                }
                field("Reporte NC Resguardo>"; rec."Reporte NC Resguardo")
                {
                }
                field("Reporte NC Elect.>"; rec."Reporte NC Elect.")
                {
                }
                field("Ubicacion XML Respuesta>"; rec."Ubicacion XML Respuesta")
                {
                }
                field("% IVA Activo>"; rec."% IVA Activo")
                {
                }
                field("Grupo Precio Int. Der. Aut.>"; rec."Grupo Precio Int. Der. Aut.")
                {
                }
                field("No. Serie Packing>"; rec."No. Serie Packing")
                {
                }
                field("No. Serie Cajas Packing>"; rec."No. Serie Cajas Packing")
                {
                }
                field("No. Serie Packing Reg.>"; rec."No. Serie Packing Reg.")
                {
                }
                field("ID Reporte Etiqueta de Caja>"; rec."ID Reporte Etiqueta de Caja")
                {
                }
                field("ID Reporte Borrador Packing>"; rec."ID Reporte Borrador Packing")
                {
                }
                field("Clientes Nuevos Bloqueados>"; rec."Clientes Nuevos Bloqueados")
                {
                }
                field("Precio de Venta Muestras>"; rec."Precio de Venta Muestras")
                {
                }
                field("Precio de Venta Donaciones>"; rec."Precio de Venta Donaciones")
                {
                }
                field("Forma Pago Oblig. en Compra>"; rec."Forma Pago Oblig. en Compra")
                {
                }
                field("DS POS Activo>"; rec."DS POS Activo")
                {
                }
                field("Funcionalidad NCF Activa>"; rec."Funcionalidad NCF Activa")
                {
                }
                field("Crea Ped. Compra de Muestras>"; rec."Crea Ped. Compra de Muestras")
                {
                }
                field("Funcionalidad Consig. Activa>"; rec."Funcionalidad Consig. Activa")
                {
                }
                field("Cobrador Exigido en cobro>"; rec."Cobrador Exigido en cobro")
                {
                }
                field("uncionalidad Imp. Fiscal Act.2"; rec."Funcionalidad Imp. Fiscal Act.")
                {
                }
                field("copia Fact. Imp. Fiscal Panama2"; rec."Copia Fact. Imp. Fiscal Panama")
                {
                }
                field("Copia NDC Imp. Fiscal Panama2"; rec."Copia NDC Imp. Fiscal Panama")
                {
                }
                field("Impresion Muestras>"; rec."Impresion Muestras")
                {
                }
                field("Control Lin. por Factura>"; rec."Control Lin. por Factura")
                {
                }
                field("Cantidad Lin. por factura>"; rec."Cantidad Lin. por factura")
                {
                }
                field("Proveedor Bloqueado al crear>"; rec."Proveedor Bloqueado al crear")
                {
                }
                field("Genera NCF en Retencion>"; rec."Genera NCF en Retencion")
                {
                }
                field("NCF en Remision de Ventas>"; rec."NCF en Remision de Ventas")
                {
                }
                field("Vendedor Obligatorio>"; rec."Vendedor Obligatorio")
                {
                }
                field("Cantidades sin Decimales>"; rec."Cantidades sin Decimales")
                {
                }
                field("Cod. Auditoria en Ventas Oblg.>"; rec."Cod. Auditoria en Ventas Oblg.")
                {
                }
                field("Anula NCF al Reimprimir>"; rec."Anula NCF al Reimprimir")
                {
                }
                field("ID Reporte Copia Factura Vta.>"; rec."ID Reporte Copia Factura Vta.")
                {
                }
                field("ID Reporte Copia Remision Vta.>"; rec."ID Reporte Copia Remision Vta.")
                {
                }
                field("ID Reporte Copia Nota Cr. Vta.>"; rec."ID Reporte Copia Nota Cr. Vta.")
                {
                }
                field("ID Reporte Copia Rem. Transf.>"; rec."ID Reporte Copia Rem. Transf.")
                {
                }
                field("Productos nuevos bloqueados>"; rec."Productos nuevos bloqueados")
                {
                }
                field("Permite Vtas. Importe Cero>"; rec."Permite Vtas. Importe Cero")
                {
                }
                field("Permite Compras. Importe Cero>"; rec."Permite Compras. Importe Cero")
                {
                }
                field("Directorio temporal etiquetas>"; rec."Directorio temporal etiquetas")
                {
                }
                field("ID Reporte Comprobante Ret.>"; rec."ID Reporte Comprobante Ret.")
                {
                }
                field("Ubicacion XML SRI>"; rec."Ubicacion XML SRI")
                {
                }
                field("Grupo Reg. Iva Prod. Exento>"; rec."Grupo Reg. Iva Prod. Exento")
                {
                }
                field("% Beneficio Vta. Cte. Intern2"; rec."% Beneficio Vta. Cte. Internos")
                {
                }
                field("Libro Diario Cheques Posf.>"; rec."Libro Diario Cheques Posf.")
                {
                }
                field("Seccion Diario Cheques Posf.>"; rec."Seccion Diario Cheques Posf.")
                {
                }
                field("No. serie Ofertas Combo>"; rec."No. serie Ofertas Combo")
                {
                }
                field("Activos Fijos Nuevos Bloq"; rec."Activos Fijos Nuevos Bloqueado")
                {
                }
            }
            group("Notificacion Errores Cola")
            {
                field("Email GD Local"; rec."Email GD Local")
                {
                }
                field("Email Soporte Funcional"; rec."Email Soporte Funcional")
                {
                }
                field("Email Encargado Proyecto"; rec."Email Encargado Proyecto")
                {
                }
            }
            group("Configuracion TPV - SIC")
            {
                field("Liquidar Nota Credito TPV"; rec."Liquidar Nota Credito TPV")
                {
                }
                field("Liquidar Factura TPV"; rec."Liquidar Factura TPV")
                {
                }
                group("Conf. Series Pos-SIC")
                {
                    field("Serie Colegio SIC"; rec."Serie Colegio SIC")
                    {
                    }
                    field("Serie Vendedor SIC"; rec."Serie Vendedor SIC")
                    {
                    }
                    field("Serie Cliente SIC"; rec."Serie Cliente SIC")
                    {
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ValidaMdE;
    end;

    trigger OnOpenPage()
    begin
        ValidaMdE;
    end;

    var
        BlnCentroCoste: Boolean;
        BlnDepartamento: Boolean;
        BlnDivision: Boolean;
        BlnAreaFuncional: Boolean;


    procedure ValidaMdE()
    begin
        BlnCentroCoste := EsDimension(Rec."Centro de coste MdE");
        BlnDepartamento := EsDimension(Rec."Departamento MdE");
        BlnDivision := EsDimension(Rec."Division MdE");
        BlnAreaFuncional := EsDimension(Rec."Area funcional MdE");
    end;


    procedure EsDimension(var OptionValue: Option "No integrar",Division,Dimension): Boolean
    begin
        exit(OptionValue = OptionValue::Dimension);
    end;
}

#pragma implicitwith restore

