report 55038 "NC Santillana Ecuador FE"
{
    // #35982  20/11/2015 JML : Modificaciones para esquema off-line
    //                          Quito fecha y hora autorización
    // #53693  07/06/2016 JMB   Añadir nuevo codigo de IVA 14%, en el CASE y los TXT Labels
    // #35029  05/09/2017 RRT:  Impresión por lotes.
    DefaultLayout = RDLC;
    RDLCLayout = './NCSantillanaEcuadorFE.rdlc';

    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Shipment Buffer" = rm,
                  TableData "NCF Anulados" = rim;

    dataset
    {
        dataitem("Documento FE"; "Documento FE")
        {
            DataItemTableView = SORTING("No. documento") ORDER(Ascending) WHERE("Tipo documento" = CONST(NotaCredito));
            RequestFilterFields = "No. documento", Establecimiento, "Punto de emision", Secuencial, "Fecha emision";
            column(NoDoc; "No. documento")
            {
            }
            column(Documento_FE__Fecha_emision_; "Fecha emision")
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
            column(Documento_FE__Razon_social_; "Razon social")
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
            column(Documento_FE__Id__comprador_; "Id. comprador")
            {
            }
            column(Documento_FE__Guia_remision_; "Guia remision")
            {
            }
            column(recTmpBLOB_Picture; recTmpBLOB.Picture)
            {
            }
            column("Documento_FE__Fecha_emisión_doc__sustento_"; "Fecha emisión doc. sustento")
            {
            }
            column(Documento_FE__Num__doc__sustento_; "Num. doc. modificado")
            {
            }
            column(Documento_FE_Motivo; Motivo)
            {
            }
            column(Documento_FE__Importe_total_; "Importe total")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Documento_FE__Total_sin_impuestos_; decTotalSinImpuesto)
            {
                DecimalPlaces = 0 : 2;
            }
            column(decIVA12; decIVA12)
            {
                DecimalPlaces = 2 : 2;
            }
            column(decIVA14; decIVA14)
            {
                DecimalPlaces = 2 : 2;
            }
            column(Documento_FE__Total_descuento_; "Total descuento")
            {
                DecimalPlaces = 2 : 2;
            }
            column(decTotal0; decTotal0)
            {
                DecimalPlaces = 2 : 2;
            }
            column(decTotalNoObjeto; decTotalNoObjeto)
            {
                DecimalPlaces = 2 : 2;
            }
            column(decTotal12; decTotal12)
            {
                DecimalPlaces = 2 : 2;
            }
            column(decTotal14; decTotal14)
            {
                DecimalPlaces = 2 : 2;
            }
            column(decTotalExento; decTotalExento)
            {
                DecimalPlaces = 2 : 2;
            }
            column(decICE; decICE)
            {
                //ComentadoDecimalPlaces = 2 : 2;
            }
            column(decIRBPNR; decIRBPNR)
            {
                //Comentado DecimalPlaces = 2 : 2;
            }
            column(decPropina; decPropina)
            {
                //Comentado DecimalPlaces = 2 : 2;
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
            column("Razón_Solical__Nombres_y_Apellidos_Caption"; Razón_Solical__Nombres_y_Apellidos_CaptionLbl)
            {
            }
            column("Identificación_Caption"; Identificación_CaptionLbl)
            {
            }
            column("Fecha_Emisión_Caption"; Fecha_Emisión_CaptionLbl)
            {
            }
            column("Guia_Remisión_Caption"; Guia_Remisión_CaptionLbl)
            {
            }
            column(NUMERO_DE_AUTORIZACIONCaption; NUMERO_DE_AUTORIZACIONCaptionLbl)
            {
            }
            column(Establecimiento______Punto_de_emision______SecuencialCaption; Establecimiento______Punto_de_emision______SecuencialCaptionLbl)
            {
            }
            column("NOTA_DE_CRÉDITOCaption"; NOTA_DE_CRÉDITOCaptionLbl)
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
            column("Fecha_Emisión__comprobante_a_modificar__Caption"; Fecha_Emisión__comprobante_a_modificar__CaptionLbl)
            {
            }
            column(FACTURACaption; FACTURACaptionLbl)
            {
            }
            column(Comprobante_que_se_modificaCaption; Comprobante_que_se_modificaCaptionLbl)
            {
            }
            column("Razón_de_modificación_Caption"; Razón_de_modificación_CaptionLbl)
            {
            }
            column(VALOR_TOTALCaption; VALOR_TOTALCaptionLbl)
            {
            }
            column(SUBTOTAL_0_Caption; SUBTOTAL_0_CaptionLbl)
            {
            }
            column(DESCUENTOCaption; DESCUENTOCaptionLbl)
            {
            }
            column(IVA_movil; IVA_movil)
            {
            }
            column(IVA_12_Caption; IVA_12_CaptionLbl)
            {
            }
            column(IVA_14_Caption; IVA_14_CaptionLbl)
            {
            }
            column(SUBTOTAL_movil; SUBTOTAL_movil)
            {
            }
            column(SUBTOTAL_No_objeto_de_IVACaption; SUBTOTAL_No_objeto_de_IVACaptionLbl)
            {
            }
            column(SUBTOTAL_12_Caption; SUBTOTAL_12_CaptionLbl)
            {
            }
            column(SUBTOTAL_14_Caption; SUBTOTAL_14_CaptionLbl)
            {
            }
            column(SUBTOTAL_Exento_IVACaption; SUBTOTAL_Exento_IVACaptionLbl)
            {
            }
            column(SUBTOTAL_SIN_IMPUESTOSCaption; SUBTOTAL_SIN_IMPUESTOSCaptionLbl)
            {
            }
            column(ICECaption; ICECaptionLbl)
            {
            }
            column(IRBPNRCaption; IRBPNRCaptionLbl)
            {
            }
            column(PROPINACaption; PROPINACaptionLbl)
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
            column(Adicional_Direccion; "Adicional - Direccion")
            {
            }
            column(Adicional_Telefono; "Adicional - Telefono")
            {
            }
            column(Adicional_Email; "Adicional - Email")
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
                column(Detalle_FE__Precio_Unitario_; "Precio Unitario")
                {
                }
                column(Detalle_FE_Descuento; Descuento)
                {
                }
                column(Detalle_FE__Precio_Total_Sin_Impuesto_; "Precio Total Sin Impuesto")
                {
                }
                column(Detalle_FE__Precio_Total_Sin_Impuesto_Caption; Detalle_FE__Precio_Total_Sin_Impuesto_CaptionLbl)
                {
                }
                column(Detalle_FE_DescuentoCaption; FieldCaption(Descuento))
                {
                }
                column(Detalle_FE__Precio_Unitario_Caption; FieldCaption("Precio Unitario"))
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
                Clear(decTotal14);
                Clear(decTotal12);
                Clear(decTotal0);
                Clear(decTotalNoObjeto);
                Clear(decTotalExento);
                Clear(decIVA14);
                Clear(decIVA12);
                Clear(decICE);
                Clear(decIRBPNR);
                Clear(decPropina);
                Clear(decTotalSinImpuesto);
                Clear(SUBTOTAL_movil);
                Clear(IVA_movil);
                /*
                recImpuestosFE.RESET;
                recImpuestosFE.SETRANGE("No. documento", "No. documento");
                IF recImpuestosFE.FINDSET THEN
                  REPEAT
                    CASE recImpuestosFE.Codigo OF
                      '2' : BEGIN  //IVA
                        CASE recImpuestosFE."Codigo Porcentaje" OF
                          '0' : decTotal0 += recImpuestosFE."Base Imponible";
                          '2' : BEGIN
                             decTotal12 += recImpuestosFE."Base Imponible";
                             decIVA12   += recImpuestosFE.Valor;
                          END;
                          // #53693: Inicio
                          '3' : BEGIN
                             decTotal14 += recImpuestosFE."Base Imponible";
                             decIVA14   += recImpuestosFE.Valor;
                          END;
                          // #53693: Fin
                          '6' : decTotalNoObjeto += recImpuestosFE."Base Imponible";
                          '7' : decTotalExento   += recImpuestosFE."Base Imponible";
                        END;
                      END;
                      '3' : ; //ICE No se usa
                      '5' : ; //IRBPNR No se usa
                    END;
                  UNTIL "Documento FE".NEXT = 0;
                */

                TIPOIVA := false;
                recImpuestosFE.Reset;
                recImpuestosFE.SetRange("No. documento", "No. documento");
                if recImpuestosFE.FindSet then
                    repeat
                        case recImpuestosFE.Codigo of
                            '2':
                                begin  //IVA
                                    case recImpuestosFE."Codigo Porcentaje" of
                                        '0':
                                            begin
                                                decTotal0 += recImpuestosFE.Subtotal;
                                                if TIPOIVA then begin
                                                    SUBTOTAL_movil := 'SUBTOTAL 12%';
                                                    IVA_movil := 'IVA 12%';
                                                end
                                                else begin
                                                    SUBTOTAL_movil := 'SUBTOTAL 15%';
                                                    IVA_movil := 'IVA 15%';
                                                end;
                                            end;
                                        '2':
                                            begin
                                                decTotal12 += recImpuestosFE.Subtotal;
                                                decIVA12 += recImpuestosFE.Valor;
                                                SUBTOTAL_movil := 'SUBTOTAL ' + Format(recImpuestosFE.Tarifa) + '%';
                                                IVA_movil := 'IVA ' + Format(recImpuestosFE.Tarifa) + '%';
                                                TIPOIVA := true;
                                            end;
                                        // #53693: Inicio
                                        '3':
                                            begin
                                                decTotal14 += recImpuestosFE."Base Imponible";
                                                decIVA14 += recImpuestosFE.Valor;
                                                if TIPOIVA then begin
                                                    SUBTOTAL_movil := 'SUBTOTAL 12%';
                                                    IVA_movil := 'IVA 12%';
                                                end
                                                else begin
                                                    SUBTOTAL_movil := 'SUBTOTAL 15%';
                                                    IVA_movil := 'IVA 15%';
                                                end;
                                            end;
                                        '4':
                                            begin
                                                decTotal12 += recImpuestosFE.Subtotal;
                                                decIVA12 += recImpuestosFE.Valor;
                                                SUBTOTAL_movil := 'SUBTOTAL ' + Format(recImpuestosFE.Tarifa) + '%';
                                                IVA_movil := 'IVA ' + Format(recImpuestosFE.Tarifa) + '%';
                                            end;
                                        // #53693: Fin
                                        '6':
                                            begin
                                                decTotalNoObjeto += recImpuestosFE.Subtotal;
                                                if TIPOIVA then begin
                                                    SUBTOTAL_movil := 'SUBTOTAL 12%';
                                                    IVA_movil := 'IVA 12%';
                                                end
                                                else begin
                                                    SUBTOTAL_movil := 'SUBTOTAL 15%';
                                                    IVA_movil := 'IVA 15%';
                                                end;
                                            end;
                                        '7':
                                            begin
                                                decTotalExento += recImpuestosFE.Subtotal;
                                                if TIPOIVA then begin
                                                    SUBTOTAL_movil := 'SUBTOTAL 12%';
                                                    IVA_movil := 'IVA 12%';
                                                end
                                                else begin
                                                    SUBTOTAL_movil := 'SUBTOTAL 15%';
                                                    IVA_movil := 'IVA 15%';
                                                end;
                                            end;
                                    end;
                                end;
                            '3':
                                ; //ICE No se usa
                            '5':
                                ; //IRBPNR No se usa
                        end;
                        decTotalSinImpuesto += recImpuestosFE.Subtotal;
                    until recImpuestosFE.Next = 0;

                recTmpBLOB.Init;
                cduBarras.C128MakeBarcode(Clave, recTmpBLOB, 5300, 423, 96, true);

                case "Tipo emision" of
                    "Tipo emision"::Normal:
                        texEmision := Text002;
                    "Tipo emision"::Contingencia:
                        texEmision := Text003;
                end;

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
        decTotal14: Decimal;
        decTotal0: Decimal;
        decTotalNoObjeto: Decimal;
        decTotalExento: Decimal;
        decIVA12: Decimal;
        decIVA14: Decimal;
        decICE: Integer;
        decIRBPNR: Integer;
        decPropina: Integer;
        Text001: Label 'SI';
        Text002: Label 'NORMAL';
        Text003: Label 'Emisión por Indisponibilidad del Sistema';
        RUC_CaptionLbl: Label 'RUC:';
        Dir__Sucursal_CaptionLbl: Label 'Dir. Sucursal:';
        Contribuyente_especial_Nro_CaptionLbl: Label 'Contribuyente especial Nro:';
        Dir__Matriz_CaptionLbl: Label 'Dir. Matriz:';
        OBLIGADO_A_LLEVAR_CONTABILIDAD_CaptionLbl: Label 'OBLIGADO A LLEVAR CONTABILIDAD:';
        "Razón_Solical__Nombres_y_Apellidos_CaptionLbl": Label 'Razón Social /Nombres y Apellidos:';
        "Identificación_CaptionLbl": Label 'Identificación:';
        "Fecha_Emisión_CaptionLbl": Label 'Fecha Emisión:';
        "Guia_Remisión_CaptionLbl": Label 'Guia Remisión:';
        NUMERO_DE_AUTORIZACIONCaptionLbl: Label 'NÚMERO DE AUTORIZACIÓN';
        Establecimiento______Punto_de_emision______SecuencialCaptionLbl: Label 'No.';
        "NOTA_DE_CRÉDITOCaptionLbl": Label 'NOTA DE CRÉDITO';
        Documento_FE__Fecha_hora_autorizacion_CaptionLbl: Label 'FECHA Y HORA DE AUTORIZACIÓN';
        Documento_FE__Ambiente_autorizacion_CaptionLbl: Label 'AMBIENTE:';
        Documento_FE__Ambiente_autorizacion__Control1000000030CaptionLbl: Label 'EMISIÓN:';
        CLAVE_DE_ACCESOCaptionLbl: Label 'CLAVE DE ACCESO';
        SICaptionLbl: Label 'SI';
        "Fecha_Emisión__comprobante_a_modificar__CaptionLbl": Label 'Fecha Emisión (comprobante a modificar):';
        FACTURACaptionLbl: Label 'FACTURA';
        Comprobante_que_se_modificaCaptionLbl: Label 'Comprobante que se modifica';
        "Razón_de_modificación_CaptionLbl": Label 'Razón de modificación:';
        VALOR_TOTALCaptionLbl: Label 'VALOR TOTAL';
        SUBTOTAL_0_CaptionLbl: Label 'SUBTOTAL 0%';
        DESCUENTOCaptionLbl: Label 'DESCUENTO';
        IVA_12_CaptionLbl: Label '<IVA 15%>';
        IVA_14_CaptionLbl: Label 'IVA 14%';
        SUBTOTAL_No_objeto_de_IVACaptionLbl: Label 'SUBTOTAL No objeto de IVA';
        SUBTOTAL_12_CaptionLbl: Label '<SUBTOTAL 15%>';
        SUBTOTAL_14_CaptionLbl: Label 'SUBTOTAL 14%';
        SUBTOTAL_Exento_IVACaptionLbl: Label 'SUBTOTAL Exento IVA';
        SUBTOTAL_SIN_IMPUESTOSCaptionLbl: Label 'SUBTOTAL SIN IMPUESTOS';
        ICECaptionLbl: Label 'ICE';
        IRBPNRCaptionLbl: Label 'IRBPNR';
        PROPINACaptionLbl: Label 'PROPINA';
        Detalle_FE__Precio_Total_Sin_Impuesto_CaptionLbl: Label 'Precio Total';
        Direccion_Lbl: Label 'Dirección';
        Telefono_Lbl: Label 'Teléfono';
        Email_Lbl: Label 'Email';
        Adicionales_Lbl: Label 'Información Adicional';
        decTotalSinImpuesto: Decimal;
        texEmision: Text;
        SUBTOTAL_movil: Text;
        IVA_movil: Text;
        TIPOIVA: Boolean;
}

