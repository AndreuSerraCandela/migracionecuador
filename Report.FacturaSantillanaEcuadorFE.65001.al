report 65001 "_Factura Santillana Ecuador FE"
{
    DefaultLayout = RDLC;
    RDLCLayout = './FacturaSantillanaEcuadorFE.65001.rdlc';
    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Shipment Buffer" = rm,
                  TableData "NCF Anulados" = rim;

    dataset
    {
        dataitem("Documento FE"; "Documento FE")
        {
            DataItemTableView = SORTING("No. documento") ORDER(Ascending) WHERE("Tipo documento" = CONST(Factura));
            RequestFilterFields = "No. documento";
            column(Documento_FE__Fecha_emision_; "Fecha emision")
            {
            }
            column(Documento_FE_RUC; RUC)
            {
            }
            column(recEmpresa__Cod__contribuyente_especial_; recEmpresa."Cod. contribuyente especial")
            {
            }
            column(recEmpresa_Address; recEmpresa.Address)
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
            column(recEmpresa_Address_Control1000000039; recEmpresa.Address)
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
            column(Documento_FE__Importe_total_; "Importe total")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Documento_FE__Total_sin_impuestos_; "Total sin impuestos")
            {
                DecimalPlaces = 0 : 2;
            }
            column(decIVA12; decIVA12)
            {
                DecimalPlaces = 0 : 2;
            }
            column(Documento_FE__Total_descuento_; "Total descuento")
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotal0; decTotal0)
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalNoObjeto; decTotalNoObjeto)
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotal12; decTotal12)
            {
                DecimalPlaces = 0 : 2;
            }
            column(decTotalExento; decTotalExento)
            {
                DecimalPlaces = 0 : 2;
            }
            column(decICE; decICE)
            {
                //Comentado DecimalPlaces = 0 : 2;
            }
            column(decIRBPNR; decIRBPNR)
            {
                //Comentado DecimalPlaces = 0 : 2;
            }
            column(decPropina; decPropina)
            {
                //Comentado DecimalPlaces = 0 : 2;
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
            column("NÒMERO_DE_AUTORIZACIÊNCaption"; NÒMERO_DE_AUTORIZACIÊNCaptionLbl)
            {
            }
            column(Establecimiento______Punto_de_emision______SecuencialCaption; Establecimiento______Punto_de_emision______SecuencialCaptionLbl)
            {
            }
            column(FACTURACaption; FACTURACaptionLbl)
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
            column(VALOR_TOTALCaption; VALOR_TOTALCaptionLbl)
            {
            }
            column(SUBTOTAL_0_Caption; SUBTOTAL_0_CaptionLbl)
            {
            }
            column(DESCUENTOCaption; DESCUENTOCaptionLbl)
            {
            }
            column(IVA_12_Caption; IVA_12_CaptionLbl)
            {
            }
            column("Información_AdicionalCaption"; Información_AdicionalCaptionLbl)
            {
            }
            column(SUBTOTAL_No_objeto_de_IVACaption; SUBTOTAL_No_objeto_de_IVACaptionLbl)
            {
            }
            column(SUBTOTAL_12_Caption; SUBTOTAL_12_CaptionLbl)
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
            }

            trigger OnAfterGetRecord()
            begin

                Clear(decTotal12);
                Clear(decTotal0);
                Clear(decTotalNoObjeto);
                Clear(decTotalExento);
                Clear(decIVA12);
                Clear(decICE);
                Clear(decIRBPNR);
                Clear(decPropina);

                recImpuestosFE.Reset;
                recImpuestosFE.SetRange("No. documento", "No. documento");
                if recImpuestosFE.FindSet then
                    repeat
                        case recImpuestosFE.Codigo of
                            '2':
                                begin  //IVA
                                    case recImpuestosFE."Codigo Porcentaje" of
                                        '0':
                                            decTotal0 += recImpuestosFE."Base Imponible";
                                        '2':
                                            begin
                                                decTotal12 += recImpuestosFE."Base Imponible";
                                                decIVA12 += recImpuestosFE.Valor;
                                            end;
                                        '6':
                                            decTotalNoObjeto += recImpuestosFE."Base Imponible";
                                        '7':
                                            decTotalExento += recImpuestosFE."Base Imponible";
                                    end;
                                end;
                            '3':
                                ; //ICE No se usa
                            '5':
                                ; //IRBPNR No se usa
                        end;
                    until "Documento FE".Next = 0;


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
        RUC_CaptionLbl: Label 'RUC:';
        Dir__Sucursal_CaptionLbl: Label 'Dir. Sucursal:';
        Contribuyente_especial_Nro_CaptionLbl: Label 'Contribuyente especial Nro:';
        Dir__Matriz_CaptionLbl: Label 'Dir. Matriz:';
        OBLIGADO_A_LLEVAR_CONTABILIDAD_CaptionLbl: Label 'OBLIGADO A LLEVAR CONTABILIDAD:';
        "Razón_Solical__Nombres_y_Apellidos_CaptionLbl": Label 'Razón Solical /Nombres y Apellidos:';
        "Identificación_CaptionLbl": Label 'Identificación:';
        "Fecha_Emisión_CaptionLbl": Label 'Fecha Emisión:';
        "Guia_Remisión_CaptionLbl": Label 'Guia Remisión:';
        "NÒMERO_DE_AUTORIZACIÊNCaptionLbl": Label 'NÒMERO DE AUTORIZACIÊN';
        Establecimiento______Punto_de_emision______SecuencialCaptionLbl: Label 'No.';
        FACTURACaptionLbl: Label 'FACTURA';
        Documento_FE__Fecha_hora_autorizacion_CaptionLbl: Label 'Fecha y hora de autorización';
        Documento_FE__Ambiente_autorizacion_CaptionLbl: Label 'AMBIENTE:';
        Documento_FE__Ambiente_autorizacion__Control1000000030CaptionLbl: Label 'EMISIÊN:';
        CLAVE_DE_ACCESOCaptionLbl: Label 'CLAVE DE ACCESO';
        SICaptionLbl: Label 'SI';
        VALOR_TOTALCaptionLbl: Label 'VALOR TOTAL';
        SUBTOTAL_0_CaptionLbl: Label 'SUBTOTAL 0%';
        DESCUENTOCaptionLbl: Label 'DESCUENTO';
        IVA_12_CaptionLbl: Label 'IVA 12%';
        "Información_AdicionalCaptionLbl": Label 'Información Adicional';
        SUBTOTAL_No_objeto_de_IVACaptionLbl: Label 'SUBTOTAL No objeto de IVA';
        SUBTOTAL_12_CaptionLbl: Label 'SUBTOTAL 12%';
        SUBTOTAL_Exento_IVACaptionLbl: Label 'SUBTOTAL Exento IVA';
        SUBTOTAL_SIN_IMPUESTOSCaptionLbl: Label 'SUBTOTAL SIN IMPUESTOS';
        ICECaptionLbl: Label 'ICE';
        IRBPNRCaptionLbl: Label 'IRBPNR';
        PROPINACaptionLbl: Label 'PROPINA';
        Detalle_FE__Precio_Total_Sin_Impuesto_CaptionLbl: Label 'Precio Total';
}

