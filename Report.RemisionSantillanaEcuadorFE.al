report 55039 "Remision Santillana Ecuador FE"
{
    // #35982  20/11/2015 JML : Modificaciones para esquema off-line
    //                          Quito fecha y hora autorización
    // 
    // #35029  05/09/2017 RRT:  Impresión por lotes.
    // 
    // YFC     : Yefrecis Francisco Cruz
    // ------------------------------------------------------------------------
    // No.         Firma     Fecha            Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC      20/01/2021       SANTINAV-2065 - AJustes
    // 002         YFC      20/01/2021       SANTINAV-1999 - Ajustes
    DefaultLayout = RDLC;
    RDLCLayout = './RemisionSantillanaEcuadorFE.rdlc';

    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Shipment Buffer" = rm,
                  TableData "NCF Anulados" = rim;

    dataset
    {
        dataitem("Documento FE"; "Documento FE")
        {
            DataItemTableView = SORTING("No. documento") ORDER(Ascending) WHERE("Tipo documento" = CONST(Remision));
            RequestFilterFields = "No. documento", Establecimiento, "Punto de emision", Secuencial, "Fecha emision";
            column(NoDoc; "Documento FE"."No. documento")
            {
            }
            column(Documento_FE_RUC; RUC)
            {
            }
            column(recEmpresa__Cod__contribuyente_especial_; recEmpresa."Cod. contribuyente especial")
            {
            }
            column(DireccionEstablecimiento; "Dir. establecimiento")
            {
            }
            column(Documento_FE__No__autorizacion_; "No. autorizacion")
            {
            }
            column(Establecimiento______Punto_de_emision______Secuencial; Establecimiento + '-' + "Punto de emision" + '-' + Secuencial)
            {
            }
            column(Documento_FE__Fecha_hora_autorizacion_; "Fecha hora autorizacion")
            {
            }
            column(Documento_FE__Ambiente_autorizacion_; Ambiente)
            {
            }
            column(texEmision; texEmision)
            {
            }
            column(Documento_FE_Clave; Clave)
            {
            }
            column(recEmpresa_Picture; recEmpresa.Picture)
            {
            }
            column(recEmpresa_Name; recEmpresa.Name)
            {
            }
            column(recEmpresa_Address; recEmpresa.Address)
            {
            }
            column(recTmpBLOB_Picture; recTmpBLOB.Picture)
            {
            }
            column(Documento_FE_NombreTransportista; "Nombre transportista")
            {
            }
            column(Documento_FE__RUC_transportista_; "RUC transportista")
            {
            }
            column(Documento_FE_Placa; Placa)
            {
            }
            column(Documento_FE__Razon_social_destinatario_; "Razon social destinatario")
            {
            }
            column(Documento_FE__Dir__partida_; "Dir. partida")
            {
            }
            column(Documento_FE__Fecha_ini__transporte_; "Fecha ini. transporte")
            {
            }
            column(Documento_FE__Fecha_fin_transporte_; "Fecha fin transporte")
            {
            }
            column(Documento_FE_Ruta; Ruta)
            {
            }
            column(Documento_FE__Cod__etablecimiento_destino_; "Cod. etablecimiento destino")
            {
            }
            column(Documento_FE__Doc__aduanero_unico_; "Doc. aduanero unico")
            {
            }
            column(Documento_FE__Razon_social_destinatario__Control1000000014; "Razon social destinatario")
            {
            }
            column(Documento_FE_RUC_Control1000000027; RUC)
            {
            }
            column(Documento_FE__Direccion_destinatario_; "Direccion destinatario")
            {
            }
            column(Documento_FE_Motivo; Motivo)
            {
            }
            column(Documento_FE__Num__aut__doc__sustento_OLD; "Num. aut. doc. sustento")
            {
            }
            column(Text003; Text003)
            {
            }
            column("Documento_FE__Fecha_emisión_doc__sustento__OLD"; "Fecha emisión doc. sustento")
            {
            }
            column(Documento_FE__Num__doc__sustento__OLD; "Num. doc. sustento")
            {
            }
            column(Documento_FE__Num__aut__doc__sustento_; num_aut_doc_sustento)
            {
            }
            column("Documento_FE__Fecha_emisión_doc__sustento_"; fecha_emision_doc_sustento)
            {
            }
            column(Documento_FE__Num__doc__sustento_; num_doc_sustento)
            {
            }
            column(RUC_Caption; RUC_CaptionLbl)
            {
            }
            column(Dir__Sucursal_Caption; Dir__Sucursal_CaptionLbl)
            {
            }
            column(Contribuyente_especial_Nro_Caption; Contribuyente_especial_Nro_CaptionLbl)
            {
            }
            column(Dir__Matriz_Caption; Dir__Matriz_CaptionLbl)
            {
            }
            column(OBLIGADO_A_LLEVAR_CONTABILIDAD_Caption; OBLIGADO_A_LLEVAR_CONTABILIDAD_CaptionLbl)
            {
            }
            column(RUC_CI__Transportista_Caption; RUC_CI__Transportista_CaptionLbl)
            {
            }
            column("NÒMERO_DE_AUTORIZACIÊNCaption"; NÒMERO_DE_AUTORIZACIÊNCaptionLbl)
            {
            }
            column(Establecimiento______Punto_de_emision______SecuencialCaption; Establecimiento______Punto_de_emision______SecuencialCaptionLbl)
            {
            }
            column("GUIA_DE_REMISIÊNCaption"; GUIA_DE_REMISIÊNCaptionLbl)
            {
            }
            column(Documento_FE__Fecha_hora_autorizacion_Caption; Documento_FE__Fecha_hora_autorizacion_CaptionLbl)
            {
            }
            column(Documento_FE__Ambiente_autorizacion_Caption; Documento_FE__Ambiente_autorizacion_CaptionLbl)
            {
            }
            column(Documento_FE__Ambiente_autorizacion__Control1000000030Caption; Documento_FE__Ambiente_autorizacion__Control1000000030CaptionLbl)
            {
            }
            column(CLAVE_DE_ACCESOCaption; CLAVE_DE_ACCESOCaptionLbl)
            {
            }
            column(SICaption; SICaptionLbl)
            {
            }
            column("Razón_Solical__Nombres_y_Apellidos_Caption"; Razón_Solical__Nombres_y_Apellidos_CaptionLbl)
            {
            }
            column(Placa_Caption; Placa_CaptionLbl)
            {
            }
            column(Punto_de_partida_Caption; Punto_de_partida_CaptionLbl)
            {
            }
            column(Fecha_fin_transporte_Caption; Fecha_fin_transporte_CaptionLbl)
            {
            }
            column(Fecha_inicio_transporte_Caption; Fecha_inicio_transporte_CaptionLbl)
            {
            }
            column("Código_Establecimiento_DestinoCaption"; Código_Establecimiento_DestinoCaptionLbl)
            {
            }
            column("Razón_Solical__Nombres_y_Apellidos_Caption_Control1000000004"; Razón_Solical__Nombres_y_Apellidos_Caption_Control1000000004Lbl)
            {
            }
            column(Documento_aduanero_Caption; Documento_aduanero_CaptionLbl)
            {
            }
            column(RUC_CI__Destinatario_Caption; RUC_CI__Destinatario_CaptionLbl)
            {
            }
            column(Ruta_Caption; Ruta_CaptionLbl)
            {
            }
            column(Destino__Punto_de_llegada_Caption; Destino__Punto_de_llegada_CaptionLbl)
            {
            }
            column("Fecha_de_emisión_Caption"; Fecha_de_emisión_CaptionLbl)
            {
            }
            column(Motivo_traslado_Caption; Motivo_traslado_CaptionLbl)
            {
            }
            column("Número_de_autorización_Caption"; Número_de_autorización_CaptionLbl)
            {
            }
            column(Comprobante_de_venta_Caption; Comprobante_de_venta_CaptionLbl)
            {
            }
            column(Documento_FE_No__documento; "No. documento")
            {
            }
            column(Adicionales_Caption; Adicionales_Lbl)
            {
            }
            column(Direccion_Caption; Direccion_Lbl)
            {
            }
            column(Telefono_Caption; Telefono_Lbl)
            {
            }
            column(Email_Caption; Email_Lbl)
            {
            }
            column(Pedido_Caption; texCaptionPedido)
            {
            }
            column(Adicional_Direccion; "Adicional - Direccion")
            {
            }
            column(Adicional_Telefono_OLD; "Adicional - Telefono")
            {
            }
            column(Adicional_Email_OLD; "Adicional - Email")
            {
            }
            column(Adicional_Telefono; rec_DocumentoFE."Adicional - Telefono")
            {
            }
            column(Adicional_Email; rec_DocumentoFE."Adicional - Email")
            {
            }
            column(Adicional_Pedido; "Adicional - Pedido")
            {
            }
            column(IdDdestinatario; "Id. destinatario")
            {
            }
            dataitem("Detalle FE"; "Detalle FE")
            {
                DataItemLink = "No. documento" = FIELD("No. documento");
                DataItemTableView = SORTING("No. documento", "No. linea");
                column(Detalle_FE__Codigo_Principal_; "Codigo Principal")
                {
                }
                column(Detalle_FE__Codigo_Auxiliar_; "Codigo Auxiliar")
                {
                }
                column(Detalle_FE_Descripcion; Descripcion)
                {
                }
                column(Detalle_FE_Cantidad; Cantidad)
                {
                }
                column(Detalle_FE_DescripcionCaption; FieldCaption(Descripcion))
                {
                }
                column(Detalle_FE_CantidadCaption; FieldCaption(Cantidad))
                {
                }
                column(Detalle_FE__Codigo_Auxiliar_Caption; FieldCaption("Codigo Auxiliar"))
                {
                }
                column(Detalle_FE__Codigo_Principal_Caption; FieldCaption("Codigo Principal"))
                {
                }
                column(Detalle_FE_No__documento; "No. documento")
                {
                }
                column(Detalle_FE_No__linea; "No. linea")
                {
                }
                column(Detalle_FE_DetalleAdicional1; "Detalle adicional 1")
                {
                    IncludeCaption = true;
                }
                column(Detalle_FE_DetalleAdicional2; "Detalle adicional 2")
                {
                    IncludeCaption = true;
                }
                column(Detalle_FE_DetalleAdicional3; "Detalle adicional 3")
                {
                    IncludeCaption = true;
                }
            }

            trigger OnAfterGetRecord()
            begin

                recTmpBLOB.Init;
                cduBarras.C128MakeBarcode(Clave, recTmpBLOB, 5300, 423, 96, true);

                texCaptionPedido := '';
                case "Subtipo documento" of
                    "Subtipo documento"::Venta:
                        texCaptionPedido := PedidoV_Lbl;
                    "Subtipo documento"::Transferencia:
                        texCaptionPedido := PedidoT_Lbl;
                end;

                case "Tipo emision" of
                    "Tipo emision"::Normal:
                        texEmision := Text002;
                    "Tipo emision"::Contingencia:
                        texEmision := Text004;
                end;

                // ++ 001-YFC
                Clear(rec_DocumentoFE);
                Clear(num_doc_sustento);
                Clear(num_aut_doc_sustento);
                Clear(fecha_emision_doc_sustento);

                if "Documento FE"."Adicional - Pedido" <> '' then begin
                    rec_SIH.Reset;
                    rec_SIH.SetCurrentKey("Order No.");
                    rec_SIH.SetRange("Order No.", "Documento FE"."Adicional - Pedido");
                end
                else // ++ 002-YFC
                  begin
                    rec_SSH.Get("Documento FE"."No. documento");
                    rec_SIH.Reset;
                    rec_SIH.SetCurrentKey("Sell-to Customer No.", "No. Autorizacion Comprobante");
                    rec_SIH.SetRange("Sell-to Customer No.", rec_SSH."Sell-to Customer No.");
                    rec_SIH.SetRange("No. Autorizacion Comprobante", rec_SSH."No. Autorizacion Comprobante");
                end;
                // -- 002-YFC
                if rec_SIH.FindFirst then begin
                    if rec_DocumentoFE.Get(rec_SIH."No.") then;

                    num_doc_sustento := PADSTR2(rec_SIH."Establecimiento Factura", 3, '0') + '-' +
                                                      PADSTR2(rec_SIH."Punto de Emision Factura", 3, '0') + '-' +
                                                      PADSTR2(rec_SIH."No. Comprobante Fiscal", 9, '0');
                    num_aut_doc_sustento := rec_SIH."No. Autorizacion Comprobante";
                    fecha_emision_doc_sustento := rec_SIH."Document Date";

                end
                // -- 001-YFC
            end;
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
    begin
        recEmpresa.Get;
        recEmpresa.CalcFields(Picture);
    end;

    var
        recEmpresa: Record "Company Information";
        recImpuestosFE: Record "Impuestos FE";
        recTmpBLOB: Record "Company Information" temporary;
        cduBarras: Codeunit "Barcode 128";
        decTotal12: Decimal;
        decTotal0: Decimal;
        decTotalNoObjeto: Decimal;
        decTotalExento: Decimal;
        decIVA12: Decimal;
        decICE: Integer;
        decIRBPNR: Integer;
        decPropina: Integer;
        Text001: Label 'SI';
        Text002: Label 'NORMAL';
        texEmision: Text;
        Text003: Label 'FACTURA';
        Text004: Label 'Emisión por Indisponibilidad del Sistema';
        RUC_CaptionLbl: Label 'RUC:';
        Dir__Sucursal_CaptionLbl: Label 'Dir. Sucursal:';
        Contribuyente_especial_Nro_CaptionLbl: Label 'Contribuyente especial Nro:';
        Dir__Matriz_CaptionLbl: Label 'Dir. Matriz:';
        OBLIGADO_A_LLEVAR_CONTABILIDAD_CaptionLbl: Label 'OBLIGADO A LLEVAR CONTABILIDAD:';
        RUC_CI__Transportista_CaptionLbl: Label 'RUC/CI (Transportista)';
        "NÒMERO_DE_AUTORIZACIÊNCaptionLbl": Label 'NÚMERO DE AUTORIZACIÓN';
        Establecimiento______Punto_de_emision______SecuencialCaptionLbl: Label 'No.';
        "GUIA_DE_REMISIÊNCaptionLbl": Label 'GUIA DE REMISIÓN';
        Documento_FE__Fecha_hora_autorizacion_CaptionLbl: Label 'FECHA Y HORA DE AUTORIZACIÓN';
        Documento_FE__Ambiente_autorizacion_CaptionLbl: Label 'AMBIENTE:';
        Documento_FE__Ambiente_autorizacion__Control1000000030CaptionLbl: Label 'EMISIÓN:';
        CLAVE_DE_ACCESOCaptionLbl: Label 'CLAVE DE ACCESO';
        SICaptionLbl: Label 'SI';
        "Razón_Solical__Nombres_y_Apellidos_CaptionLbl": Label 'Razón Solical /Nombres y Apellidos:';
        Placa_CaptionLbl: Label 'Placa:';
        Punto_de_partida_CaptionLbl: Label 'Punto de partida:';
        Fecha_fin_transporte_CaptionLbl: Label 'Fecha fin transporte:';
        Fecha_inicio_transporte_CaptionLbl: Label 'Fecha inicio transporte:';
        "Código_Establecimiento_DestinoCaptionLbl": Label 'Código Establecimiento Destino';
        "Razón_Solical__Nombres_y_Apellidos_Caption_Control1000000004Lbl": Label 'Razón Solical /Nombres y Apellidos:';
        Documento_aduanero_CaptionLbl: Label 'Documento aduanero:';
        RUC_CI__Destinatario_CaptionLbl: Label 'Identificación (Destinatario)';
        Ruta_CaptionLbl: Label 'Ruta:';
        Destino__Punto_de_llegada_CaptionLbl: Label 'Destino (Punto de llegada)';
        "Fecha_de_emisión_CaptionLbl": Label 'Fecha de emisión:';
        Motivo_traslado_CaptionLbl: Label 'Motivo traslado:';
        "Número_de_autorización_CaptionLbl": Label 'Número de autorización:';
        Comprobante_de_venta_CaptionLbl: Label 'Comprobante de venta:';
        Direccion_Lbl: Label 'Dirección';
        Telefono_Lbl: Label 'Teléfono';
        Email_Lbl: Label 'Email';
        Adicionales_Lbl: Label 'Información Adicional';
        PedidoV_Lbl: Label 'Nº VPP:';
        PedidoT_Lbl: Label 'Nº PT:';
        texCaptionPedido: Text;
        rec_DocumentoFE: Record "Documento FE";
        rec_SIH: Record "Sales Invoice Header";
        num_aut_doc_sustento: Text[49];
        num_doc_sustento: Text[20];
        fecha_emision_doc_sustento: Date;
        rec_SSH: Record "Sales Shipment Header";


    procedure PADSTR2(texPrmEntrada: Text[30]; intPrmLongitud: Integer; texPrmCaracter: Text[1]): Text[30]
    begin
        if StrLen(texPrmEntrada) < intPrmLongitud then
            texPrmEntrada := PadStr('', intPrmLongitud - StrLen(texPrmEntrada), texPrmCaracter) + texPrmEntrada;

        exit(texPrmEntrada);
    end;
}

