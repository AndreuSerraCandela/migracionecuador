report 65003 "_Remision Santillana Ecuador F"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RemisionSantillanaEcuadorF.rdlc';
    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Shipment Buffer" = rm,
                  TableData "NCF Anulados" = rim;

    dataset
    {
        dataitem("Documento FE"; "Documento FE")
        {
            DataItemTableView = SORTING ("No. documento") ORDER(Ascending) WHERE ("Tipo documento" = CONST (Remision));
            RequestFilterFields = "No. documento";
            column(Documento_FE_RUC; RUC)
            {
            }
            column(recEmpresa__Cod__contribuyente_especial_; recEmpresa."Cod. contribuyente especial")
            {
            }
            column(recEmpresa_Address; recEmpresa.Address)
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
            column(recEmpresa_Address_Control1000000039; recEmpresa.Address)
            {
            }
            column(recTmpBLOB_Picture; recTmpBLOB.Picture)
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
            column(Documento_FE__Num__aut__doc__sustento_; "Num. aut. doc. sustento")
            {
            }
            column(Text003; Text003)
            {
            }
            column("Documento_FE__Fecha_emisión_doc__sustento_"; "Fecha emisión doc. sustento")
            {
            }
            column(Documento_FE__Num__doc__sustento_; "Num. doc. sustento")
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
            dataitem("Detalle FE"; "Detalle FE")
            {
                DataItemLink = "No. documento" = FIELD ("No. documento");
                DataItemTableView = SORTING ("No. documento", "No. linea");
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
            }

            trigger OnAfterGetRecord()
            begin

                recTmpBLOB.Init;
                cduBarras.C128MakeBarcode(Clave, recTmpBLOB, 5300, 423, 96, true);
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
        texEmision := Text002;
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
        texEmision: Text[30];
        Text003: Label 'FACTURA';
        RUC_CaptionLbl: Label 'RUC:';
        Dir__Sucursal_CaptionLbl: Label 'Dir. Sucursal:';
        Contribuyente_especial_Nro_CaptionLbl: Label 'Contribuyente especial Nro:';
        Dir__Matriz_CaptionLbl: Label 'Dir. Matriz:';
        OBLIGADO_A_LLEVAR_CONTABILIDAD_CaptionLbl: Label 'OBLIGADO A LLEVAR CONTABILIDAD:';
        RUC_CI__Transportista_CaptionLbl: Label 'RUC/CI (Transportista)';
        "NÒMERO_DE_AUTORIZACIÊNCaptionLbl": Label 'NÒMERO DE AUTORIZACIÊN';
        Establecimiento______Punto_de_emision______SecuencialCaptionLbl: Label 'No.';
        "GUIA_DE_REMISIÊNCaptionLbl": Label 'GUIA DE REMISIÊN';
        Documento_FE__Fecha_hora_autorizacion_CaptionLbl: Label 'Fecha y hora de autorización';
        Documento_FE__Ambiente_autorizacion_CaptionLbl: Label 'AMBIENTE:';
        Documento_FE__Ambiente_autorizacion__Control1000000030CaptionLbl: Label 'EMISIÊN:';
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
        RUC_CI__Destinatario_CaptionLbl: Label 'RUC/CI (Destinatario)';
        Ruta_CaptionLbl: Label 'Ruta:';
        Destino__Punto_de_llegada_CaptionLbl: Label 'Destino (Punto de llegada)';
        "Fecha_de_emisión_CaptionLbl": Label 'Fecha de emisión:';
        Motivo_traslado_CaptionLbl: Label 'Motivo traslado:';
        "Número_de_autorización_CaptionLbl": Label 'Número de autorización:';
        Comprobante_de_venta_CaptionLbl: Label 'Comprobante de venta:';
}

