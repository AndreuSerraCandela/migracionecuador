page 55010 "Datos ATS"
{
    ApplicationArea = all;
    // #14564  FAA   24/03/2015    ATS Ecuador cambios y nuevas modificaciones.
    // #34860  CAT   11/11/2015  Gestionar el No. de establecimientos
    // #45384  MOI   15/02/2016    Se activa el boton para generar el XML.


    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(FechaDesde; FechaDesde)
            {
                Caption = 'Fecha Desde';
            }
            field(FechaHasta; FechaHasta)
            {
                Caption = 'Fecha Hasta';
            }
            field(TipoTrans; TipoTrans)
            {
                Caption = 'Tipo';
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("1er. paso")
            {
                Caption = '1er. paso';
                action("<Action1000000004>")
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    var
                        rProveedor: Record Vendor;
                        recLinFac: Record "Purch. Inv. Line";
                        recLinNC: Record "Purch. Cr. Memo Line";
                        DetATSCompras: Record "ATS Compras/Ventas";
                        DetATSVentasxCliente: Record "ATS Ventas x Cliente";
                        DetATSVentasxEstablec: Record "ATS Ventas x Establecimiento";
                        DetATSExportaciones: Record "ATS Exportaciones";
                        DetATSComprobAnulados: Record "ATS Comprobantes Anulados";
                        Texto001: Label 'Proceso finalizado.';
                        Error002: Label 'No. de Establecimientos ingresado no es válido.';
                    begin

                        if (FechaDesde = 0D) or (FechaHasta = 0D) then
                            Error(Error001);

                        DetATSCompras.DeleteAll;
                        DetATSVentasxCliente.DeleteAll;
                        DetATSVentasxEstablec.DeleteAll;
                        DetATSExportaciones.DeleteAll;
                        DetATSComprobAnulados.DeleteAll;

                        FuncionesATSEcuador.CrearEnvio(Date2DMY(FechaDesde, 2), Date2DMY(FechaDesde, 3));//#34860
                        FuncionesATSEcuador.ReporteATSCompra(FechaDesde, FechaHasta);
                        FuncionesATSEcuador.ReporteATSVentaDetallado(FechaDesde, FechaHasta);
                        FuncionesATSEcuador.ReporteATSVentas(FechaDesde, FechaHasta);
                        FuncionesATSEcuador.ReporteATSExportaciones(FechaDesde, FechaHasta);
                        FuncionesATSEcuador.ReporteATSAnulados(FechaDesde, FechaHasta);
                        Message(Texto001);

                        //CASE TipoTrans OF
                        //  TipoTrans::Compra                   : FuncionesATSEcuador.ReporteATSCompra(FechaDesde, FechaHasta);
                        //  TipoTrans::Venta                    : FuncionesATSEcuador.ReporteATSVentas(FechaDesde,FechaHasta);
                        //  TipoTrans::Exportaciones            : ERROR('Opción no disponible');
                        //  TipoTrans::"Comprobantes Anulados"  : FuncionesATSEcuador.ReporteATSAnulados(FechaDesde,FechaHasta);
                        //END;
                    end;
                }
            }
            group("2do. paso")
            {
                Caption = '2do. paso';
                Image = ReleaseDoc;
                action("Consulta Compras")
                {
                    Caption = 'Consulta Compras';
                    Image = View;
                    RunObject = Page "Detalle Datos ATS";
                    RunPageView = WHERE(Tipo = CONST(Compra));
                }
                action("Consulta Ventas")
                {
                    Caption = 'Consulta Ventas';
                    Image = View;
                    RunObject = Page "Detalle ATS Ventas";
                    RunPageView = WHERE(Tipo = CONST(Venta));
                }
                action("Consulta Resumen Ventas")
                {
                    Caption = 'Consulta Resumen Ventas';
                    Image = View;
                    RunObject = Page "Detalle Datos ATS Vtas.";
                }
                action("Consulta Exportaciones")
                {
                    Caption = 'Consulta Exportaciones';
                    Image = View;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = New;
                    RunObject = Page "SRI Exportaciones";
                }
                action("Consulta Comp. Anulados")
                {
                    Caption = 'Consulta Comp. Anulados';
                    Image = View;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = New;
                    RunObject = Page "SRI Comprobantes anulados";
                }
            }
            group("3er. paso")
            {
                Caption = '3er. paso';
                Image = ReleaseDoc;
                action("Generar Archivo XML")
                {
                    Caption = 'Generar Archivo XML';
                    Image = Export;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = New;

                    trigger OnAction()
                    var
                        Error001: Label 'No se ha definido el periodo de fechas.';
                        Error002: Label 'No hay datos generados.';
                        FuncATS: Codeunit "Funciones ATS";
                        Texto001: Label 'Fichero XML generado: %1 ';
                        texFicheroXML: Text[250];
                        DetATSCompras: Record "ATS Compras/Ventas";
                        DetATSVentasxCliente: Record "ATS Ventas x Cliente";
                        DetATSVentasxEstablec: Record "ATS Ventas x Establecimiento";
                        DetATSExportaciones: Record "ATS Exportaciones";
                        DetATSComprobAnulados: Record "ATS Comprobantes Anulados";
                    begin
                        if (FechaDesde = 0D) or (FechaHasta = 0D) then
                            Error(Error001);

                        DetATSCompras.SetRange("Mes - Periodo", Date2DMY(FechaDesde, 2));
                        DetATSCompras.SetRange("Año - Periodo", Date2DMY(FechaDesde, 3));
                        DetATSVentasxCliente.SetRange(DetATSVentasxCliente."Mes -  Periodo", Date2DMY(FechaDesde, 2));
                        DetATSVentasxCliente.SetRange(DetATSVentasxCliente."Año - Periodo", Date2DMY(FechaDesde, 3));
                        DetATSVentasxEstablec.SetRange(DetATSVentasxEstablec."Mes -  Periodo", Date2DMY(FechaDesde, 2));
                        DetATSVentasxEstablec.SetRange(DetATSVentasxEstablec."Año - Periodo", Date2DMY(FechaDesde, 3));
                        DetATSExportaciones.SetRange(DetATSExportaciones."Mes -  Periodo", Date2DMY(FechaDesde, 2));
                        DetATSExportaciones.SetRange(DetATSExportaciones."Año - Periodo", Date2DMY(FechaDesde, 3));
                        DetATSComprobAnulados.SetRange(DetATSComprobAnulados."Mes -  Periodo", Date2DMY(FechaDesde, 2));
                        DetATSComprobAnulados.SetRange(DetATSComprobAnulados."Año - Periodo", Date2DMY(FechaDesde, 3));

                        if (not DetATSCompras.FindFirst) and
                           (not DetATSVentasxCliente.FindFirst) and
                           (not DetATSVentasxEstablec.FindFirst) and
                           (not DetATSExportaciones.FindFirst) and
                           (not DetATSComprobAnulados.FindFirst) then
                            Error(Error002);

                        Clear(FuncATS);
                        //FuncATS.GenerarXML(texFicheroXML,DATE2DMY(FechaDesde,2),DATE2DMY(FechaDesde,3));
                        FuncATS.GenerarXMLDotNet(texFicheroXML, Date2DMY(FechaDesde, 2), Date2DMY(FechaDesde, 3));
                        Message(Texto001, texFicheroXML)
                    end;
                }
            }
        }
    }

    var
        FechaDesde: Date;
        FechaHasta: Date;
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        DetATS: Record "ATS Compras/Ventas";
        Error001: Label 'Debe indicar Fecha Desde y Fecha Hasta';
        TipoTrans: Option Compra,Venta,Exportaciones,"Comprobantes Anulados";
        Corregida: Boolean;
        Text002: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Err002: Label 'El Campo Tipo Contribuyente del Proveedor %1 , debe ser Persona Natural o Sociedad';
        Err003: Label 'El Campo Tipo Contribuyente del Proveedor %1, no puede estar en blanco.';
        FuncionesATSEcuador: Codeunit "Funciones ATS";
        NoEstablec: Integer;
}

