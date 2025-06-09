report 76018 "DsPOS - Resumen del turno"
{
    DefaultLayout = RDLC;
    RDLCLayout = './DsPOSResumendelturno.rdlc';

    dataset
    {
        dataitem(Turno; "Turnos TPV")
        {
            DataItemTableView = SORTING("No. tienda", "No. TPV", Fecha, "No. turno");
            RequestFilterFields = "No. tienda", "No. TPV", Fecha, "No. turno";
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
            dataitem(DetalleDePedidos; "Transacciones TPV")
            {
                DataItemLink = "Cod. tienda" = FIELD("No. tienda"), "Cod. TPV" = FIELD("No. TPV"), Fecha = FIELD(Fecha), "No. turno" = FIELD("No. turno");
                DataItemTableView = SORTING("Cod. tienda", "Cod. TPV", Fecha, "No. turno", "No. Transaccion") WHERE("Tipo Transaccion" = CONST(Venta));
                column(Ped_Filtro; codFiltro)
                {
                }
                column(Ped_ClienteCaption; lblCliente)
                {
                }
                column(Ped_NombreClienteCaption; lblNombreCliente)
                {
                }
                column(Ped_Cliente; "Cod. cliente")
                {
                    //Comentado OptionCaption = 'Cliente';
                }
                column(Ped_NombreCliente; "Nombre cliente")
                {
                    //Comentado OptionCaption = 'Nombre del cliente';
                }
                column(Ped_NoDocumento; "No. Registrado")
                {
                    IncludeCaption = true;
                    //Comentado OptionCaption = 'Nº de documento';
                }
                column(Ped_ImporteIVAInc; "Importe IVA inc.")
                {
                    IncludeCaption = true;
                    //Comentado OptionCaption = 'Importe';
                }
                column(Ped_Hora; Hora)
                {
                    //Comentado OptionCaption = 'Time';
                }
                /*column(Ped_NCF; cFComunes.Devolver_NCF(DetalleDePedidos)) //Comentado
                {
                    //Comentado OptionCaption = 'Nº Compr. Fiscal';
                }*/

                trigger OnPreDataItem()
                begin
                    codFiltro := 'VTAS';
                end;
            }
            dataitem(NotasDeCredito; "Transacciones TPV")
            {
                DataItemLink = "Cod. tienda" = FIELD("No. tienda"), "Cod. TPV" = FIELD("No. TPV"), Fecha = FIELD(Fecha), "No. turno" = FIELD("No. turno");
                DataItemTableView = SORTING("Cod. tienda", "Cod. TPV", Fecha, "No. turno", "No. Transaccion") WHERE("Tipo Transaccion" = CONST(Abono));
                column(NC_Filtro; codFiltro)
                {
                }
                column(NC_ClienteCaption; lblCliente)
                {
                }
                column(NC_NombreClienteCaption; lblNombreCliente)
                {
                }
                column(NC_Cliente; "Cod. cliente")
                {
                    //Comentado OptionCaption = 'Cliente';
                }
                column(NC_NombreCliente; "Nombre cliente")
                {
                    //Comentado OptionCaption = 'Cliente';
                }
                column(NC_NoDocumento; "No. Registrado")
                {
                    IncludeCaption = true;
                    //Comentado OptionCaption = 'Nº de nota de crédito';
                }
                column(NC_Importe; "Importe IVA inc.")
                {
                    IncludeCaption = true;
                    //ComentadoOptionCaption = 'Importe';
                }
                column(NC_Hora; Hora)
                {
                    //Comentado OptionCaption = 'Time';
                }
                /*column(NC_NCF; cFComunes.Devolver_NCF(NotasDeCredito)) //Comentado
                {
                    //Comentado OptionCaption = 'Nº Compr. Fiscal';
                }*/

                trigger OnAfterGetRecord()
                var
                    recCabAbo: Record "Sales Cr.Memo Header";
                begin
                end;

                trigger OnPreDataItem()
                begin
                    codFiltro := 'NC';
                end;
            }
            dataitem(Anulaciones; "Transacciones TPV")
            {
                DataItemLink = "Cod. tienda" = FIELD("No. tienda"), "Cod. TPV" = FIELD("No. TPV"), Fecha = FIELD(Fecha), "No. turno" = FIELD("No. turno");
                DataItemTableView = SORTING("Cod. tienda", "Cod. TPV", Fecha, "No. turno", "No. Transaccion") WHERE("Tipo Transaccion" = CONST(Anulacion));
                column(Anul_Filtro; codFiltro)
                {
                }
                column(Anul_ClienteCaption; lblCliente)
                {
                }
                column(Anul_NombreCliente; "Nombre cliente")
                {
                    //Comentado OptionCaption = 'Cliente';
                }
                column(Anul_NoDocumento; "No. Registrado")
                {
                    IncludeCaption = true;
                    //Comentado OptionCaption = 'Nº de anulación';
                }
                column(Anul_Importe; "Importe IVA inc.")
                {
                    IncludeCaption = true;
                    //Comentado OptionCaption = 'Importe';
                }
                column(Anul_Hora; Hora)
                {
                    //Comentado OptionCaption = 'Time';
                }
                /*column(Anul_NCF; cFComunes.Devolver_NCF(Anulaciones)) //Comentado
                {
                    //ComentadoOptionCaption = 'Nº Compr. Fiscal';
                }*/
                column(Anul_Cliente; "Cod. cliente")
                {
                    //Comentado OptionCaption = 'Cliente';
                }
                column(Anul_NombreClienteCaption; lblNombreCliente)
                {
                }

                trigger OnPreDataItem()
                begin
                    codFiltro := 'ANUL';
                end;
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
        codFiltro: Text;
        lblApertura: Label 'Apertura:';
        lblCierre: Label 'Cierre:';
        TexNombreInforme: Label 'RESUMEN DE VENTAS';
        lblCliente: Label 'Cliente';
        lblNombreCliente: Label 'Nombre cliente';
        TexPagina: Label 'Nº pág.:';
        texTipoOperacion: Text;
        Text005: Label 'Notas de crédito';
        Text006: Label 'Anulaciones';
        Text007: Label 'Detalle de Facturas';
        Text008: Label 'Ventas:';
        decImporteEnCaja: Decimal;
    //ComentadocFComunes: Codeunit "Funciones DsPOS - Comunes";
}

