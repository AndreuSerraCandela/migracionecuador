report 76016 "DsPOS - Cuadre de caja"
{
    // #355717, RRT, 24.03.2021: Añadir el importe recontado, y la diferencia si la hay.
    DefaultLayout = RDLC;
    RDLCLayout = './DsPOSCuadredecaja.rdlc';


    dataset
    {
        dataitem(Turno; "Turnos TPV")
        {
            DataItemTableView = SORTING("No. tienda", "No. TPV", Fecha, "No. turno");
            RequestFilterFields = "No. tienda", "No. TPV", Fecha, "No. turno";
            column(Detallado; blnDetallado)
            {
            }
            column(NombreInformeCaption; TexNombreInforme)
            {
            }
            column(PaginaCaption; TexPagina)
            {
            }
            column(NombreTienda; "Nombre tienda")
            {
                IncludeCaption = true;
                //Comentado OptionCaption = 'Tienda';
            }
            column(NombreTPV; "Nombre TPV")
            {
                IncludeCaption = true;
                //Comentado OptionCaption = 'TPV';
            }
            column(Fecha; Fecha)
            {
                IncludeCaption = true;
                //Comentado OptionCaption = 'Fecha';
            }
            column(TurnoCaption; lblTurno)
            {
            }
            column(NoTurno; "No. turno")
            {
                IncludeCaption = true;
            }
            column(AperturaCaption; lblApertura)
            {
            }
            column(CierreCaption; lblCierre)
            {
            }
            column(EnCajaCaption; lblEnCaja)
            {
            }
            column(HoraApertura; "Hora apertura")
            {
                IncludeCaption = true;
                //Comentado OptionCaption = 'Apertura:';
            }
            column(HoraCierre; "Hora cierre")
            {
                IncludeCaption = true;
                //Comentado OptionCaption = 'Cierre:';
            }
            column(UsuarioApertura; "Usuario apertura")
            {
                IncludeCaption = true;
            }
            column(UsuarioCierre; "Usuario cierre")
            {
                IncludeCaption = true;
            }
            column(Cobros_Lbl; Text003)
            {
            }
            column(Oper_lbl; Text004)
            {
            }
            column(NC_Lbl; Text005)
            {
            }
            column(Anul_lbl; Text006)
            {
            }
            column(Pedidos_lbl; Text007)
            {
            }
            column(VTAS_lbl; Text008)
            {
            }
            column(Total_lbl; lblTotal)
            {
            }
            column(EnCaja_lbl; lblEnCaja)
            {
            }
            dataitem(Pagos; "Transacciones Caja TPV")
            {
                DataItemLink = "Cod. tienda" = FIELD("No. tienda"), "Cod. TPV" = FIELD("No. TPV"), Fecha = FIELD(Fecha), "No. turno" = FIELD("No. turno");
                DataItemTableView = SORTING("Cod. tienda", "Cod. TPV", Fecha, "No. turno", "Forma de pago") WHERE("Tipo transaccion" = FILTER("Cobro TPV" | Anulacion));
                column(Pagos_TipoMov; TipoMov)
                {
                }
                column(Pagos_Filtro; codFiltro)
                {
                }
                column(Pagos_FormaDePago; "Forma de pago")
                {
                    IncludeCaption = true;
                    //Comentado OptionCaption = 'Forma de pago';
                }
                column(Pagos_Importe; Importe)
                {
                    IncludeCaption = true;
                }
                column(Pagos_ImporteDL; "Importe (DL)")
                {
                    IncludeCaption = true;
                }
                column(Pagos_Descuadre; wDescuadre)
                {
                }
                column(Pagos_NoFactura; "No. Registrado")
                {
                    IncludeCaption = true;
                }
                /*column(Pagos_NCF; cfComunes.Devolver_NCF_TransCaja(Pagos)) //Comentado
                {
                }*/
                column(Pagos_Hora; Hora)
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                var
                    lrLinDeclaracion: Record "Lin. declaracion caja";
                    lrFormasPago: Record "Formas de Pago";
                    lrTransCaja: Record "Transacciones Caja TPV";
                begin

                    case Pagos."Tipo transaccion" of
                        Pagos."Tipo transaccion"::"Cobro TPV":
                            TipoMov := TipoMov::"Cobro TPV";
                        Pagos."Tipo transaccion"::Anulacion:
                            TipoMov := TipoMov::"Anulación";
                    end;

                    if Pagos.Cambio then
                        TipoMov := TipoMov::Cambio;

                    //+#355717
                    wDescuadre := 0;

                    if lrFormasPago.Get(Pagos."Forma de pago") then
                        if lrFormasPago."Realizar recuento" then
                            if not rTMPFormaPago.Get(Pagos."Forma de pago") then begin

                                lrTransCaja.Reset;
                                lrTransCaja.SetRange("Cod. tienda", Pagos."Cod. tienda");
                                lrTransCaja.SetRange("Cod. TPV", Pagos."Cod. TPV");
                                lrTransCaja.SetRange(Fecha, Pagos.Fecha);
                                lrTransCaja.SetRange("No. turno", Pagos."No. turno");
                                lrTransCaja.SetRange("Forma de pago", Pagos."Forma de pago");
                                lrTransCaja.CalcSums(Importe);

                                lrLinDeclaracion.Reset;
                                lrLinDeclaracion.SetRange("No. tienda", Pagos."Cod. tienda");
                                lrLinDeclaracion.SetRange("No. TPV", Pagos."Cod. TPV");
                                lrLinDeclaracion.SetRange(Fecha, Pagos.Fecha);
                                lrLinDeclaracion.SetRange("No. turno", Pagos."No. turno");
                                lrLinDeclaracion.SetRange("Forma de pago", Pagos."Forma de pago");
                                lrLinDeclaracion.CalcSums("Importe contado");

                                wDescuadre := lrLinDeclaracion."Importe contado" - lrTransCaja.Importe;

                                rTMPFormaPago.Init;
                                rTMPFormaPago."ID Pago" := Pagos."Forma de pago";
                                rTMPFormaPago.Insert;

                            end;
                    //-#355717
                end;

                trigger OnPreDataItem()
                begin
                    codFiltro := 'PAGOS';

                    //+#355717
                    rTMPFormaPago.Reset;
                    rTMPFormaPago.DeleteAll;
                    //-#355717
                end;
            }
            dataitem(FondoCaja; "Transacciones Caja TPV")
            {
                DataItemLink = "Cod. tienda" = FIELD("No. tienda"), "Cod. TPV" = FIELD("No. TPV"), Fecha = FIELD(Fecha), "No. turno" = FIELD("No. turno");
                DataItemTableView = SORTING("Cod. tienda", "Cod. TPV", Fecha, "No. turno", "No. transaccion") WHERE("Tipo transaccion" = CONST(Fondo));
                column(FC_Filtro; codFiltro)
                {
                }
                column(FC_Caption; lblFondo)
                {
                }
                column(FC_Importe; "Importe (DL)")
                {
                    IncludeCaption = true;
                    //Comentado OptionCaption = 'Fondo de caja:';
                }

                trigger OnPreDataItem()
                begin
                    codFiltro := 'FC';
                end;
            }
            dataitem(OperacionesCaja; "Transacciones Caja TPV")
            {
                DataItemLink = "Cod. tienda" = FIELD("No. tienda"), "Cod. TPV" = FIELD("No. TPV"), Fecha = FIELD(Fecha), "No. turno" = FIELD("No. turno");
                DataItemTableView = SORTING("Cod. tienda", "Cod. TPV", Fecha, "No. turno", "Tipo transaccion") WHERE("Tipo transaccion" = FILTER(Entrada | Salida));
                column(OC_Filtro; codFiltro)
                {
                }
                column(OC_Tipo; texTipoOperacion)
                {
                }
                column(OC_Importe; "Importe (DL)")
                {
                    IncludeCaption = true;
                    //Comentado OptionCaption = 'Fondo de caja:';
                }

                trigger OnAfterGetRecord()
                begin
                    case "Tipo transaccion" of
                        "Tipo transaccion"::Entrada:
                            texTipoOperacion := Text001;
                        "Tipo transaccion"::Salida:
                            texTipoOperacion := Text002;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    codFiltro := 'OC';
                end;
            }
            dataitem(TotalesCaja; "Transacciones Caja TPV")
            {
                DataItemLink = "Cod. tienda" = FIELD("No. tienda"), "Cod. TPV" = FIELD("No. TPV"), Fecha = FIELD(Fecha), "No. turno" = FIELD("No. turno");
                DataItemTableView = SORTING("Cod. tienda", "Cod. TPV", Fecha, "No. turno", "Cod. divisa");
                column(TC_Filtro; codFiltro)
                {
                }
                column(TC_Divisa; "Cod. divisa")
                {
                    IncludeCaption = true;
                }
                column(TC_DescripcionDivisa; TraerDescripcionDivisa)
                {
                }
                column(TC_Importe; Importe)
                {
                    IncludeCaption = true;
                }
                column(TC_ImporteDL; "Importe (DL)")
                {
                    IncludeCaption = true;
                }
                column(TC_FactorDivisa; "Factor divisa")
                {
                    IncludeCaption = true;
                }
                column(TC_TotalEnCaja; "Total caja turno (DL)")
                {
                }
                column(TC_TotalEnCaja_lbl; lblTotalEnCaja)
                {
                }

                trigger OnAfterGetRecord()
                var
                    recTrans: Record "Transacciones Caja TPV";
                begin
                end;

                trigger OnPreDataItem()
                begin
                    codFiltro := 'TC';
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1000000002)
                {
                    ShowCaption = false;
                    field(blnDetallado; blnDetallado)
                    {
                    ApplicationArea = All;
                        Caption = 'Mostrar detalle';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        Error001: Label 'Debe indicar filtro %1';
    begin
        if Turno.GetFilter("No. tienda") = '' then
            Error(Error001, Turno.FieldCaption("No. tienda"));

        if Turno.GetFilter("No. TPV") = '' then
            Error(Error001, Turno.FieldCaption("No. TPV"));

        if Turno.GetFilter(Fecha) = '' then
            Error(Error001, Turno.FieldCaption(Fecha));

        if Turno.GetFilter("No. turno") = '' then
            Error(Error001, Turno.FieldCaption("No. turno"));
    end;

    var
        lblFondo: Label 'Fondo de caja:';
        codFiltro: Text;
        texNombreCliente: Text[50];
        codCliente: Code[20];
        lblTotal: Label 'Total para:';
        lblEnCaja: Label 'Totales por Divisa:';
        lblApertura: Label 'Apertura:';
        lblCierre: Label 'Cierre:';
        lblTurno: Label 'Turno nº:';
        lblTotalEnCaja: Label 'Valor en caja en divisa local:';
        TexNombreInforme: Label 'CUADRE DE CAJA';
        TexCliente: Label 'Cliente';
        TexPagina: Label 'Nº pág.:';
        Text001: Label 'Entradas de caja:';
        Text002: Label 'Salidas de caja:';
        texTipoOperacion: Text;
        Text003: Label 'Cobros:';
        Text004: Label 'Operaciones de caja:';
        Text005: Label 'Notas de crédito';
        Text006: Label 'Anulaciones';
        Text007: Label 'Detalle de pedidos';
        Text008: Label 'Ventas:';
        blnDetallado: Boolean;
        //Comentado cfComunes: Codeunit "Funciones DsPOS - Comunes";
        TipoMov: Option "Cobro TPV","Anulación",Cambio;
        wDescuadre: Decimal;
        rTMPFormaPago: Record "Formas de Pago" temporary;


    procedure TraerDescripcionDivisa(): Text
    var
        recDivisa: Record Currency;
        recFormaPago: Record "Formas de Pago";
        Text001: Label 'Divisa local';
    begin
        if recFormaPago.Get(TotalesCaja."Forma de pago") then
            if recFormaPago."Efectivo Local" then
                exit(Text001);

        exit(TotalesCaja."Cod. divisa");
    end;
}

