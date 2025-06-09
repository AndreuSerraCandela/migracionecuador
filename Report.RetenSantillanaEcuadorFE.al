report 55040 "Reten. Santillana Ecuador FE"
{
    // #35982  20/11/2015 JML: Modificaciones para esquema off-line
    //                          Quito fecha y hora autorización
    // 
    // #35092 05.09.2017  RRT: Permitir la impresion por lotes.
    DefaultLayout = RDLC;
    RDLCLayout = './RetenSantillanaEcuadorFE.rdlc';

    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Shipment Buffer" = rm,
                  TableData "NCF Anulados" = rim;

    dataset
    {
        dataitem("Documento FE"; "Documento FE")
        {
            DataItemTableView = SORTING ("No. documento") ORDER(Ascending) WHERE ("Tipo documento" = CONST (Retencion));
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
            column(Documento_FE__Razon_social_destinatario_; "Razon social")
            {
            }
            column(Documento_FE__Fecha_emision_; "Fecha emision")
            {
            }
            column(Documento_FE__id__sujeto_retenido_; "id. sujeto retenido")
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
            column("Fecha_emisiónCaption"; Fecha_emisiónCaptionLbl)
            {
            }
            column("IdentificaciónCaption"; IdentificaciónCaptionLbl)
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
            dataitem("Retenciones FE"; "Retenciones FE")
            {
                DataItemLink = "No. documento" = FIELD ("No. documento");
                DataItemTableView = SORTING ("No. documento", Codigo);
                column(Retenciones_FE__Base_imponible_; "Base imponible")
                {
                }
                column(Retenciones_FE__Porcentaje_retener_; "Porcentaje retener")
                {
                }
                column(Retenciones_FE__Valor_retenido_; "Valor retenido")
                {
                }
                column(Retenciones_FE_Comprobante; Comprobante)
                {
                }
                column(Retenciones_FE__Num__doc__sustento_; "Num. doc. sustento")
                {
                }
                column(Retenciones_FE__Fecha_emision_doc__sustento_; "Fecha emision doc. sustento")
                {
                }
                column(Retenciones_FE__Ejercicio_fiscal_; "Ejercicio fiscal")
                {
                }
                column(Retenciones_FE_Impuesto; Impuesto)
                {
                }
                column(Retenciones_FE__Base_imponible_Caption; Retenciones_FE__Base_imponible_CaptionLbl)
                {
                }
                column(Retenciones_FE__Porcentaje_retener_Caption; Retenciones_FE__Porcentaje_retener_CaptionLbl)
                {
                }
                column(Retenciones_FE__Valor_retenido_Caption; FieldCaption("Valor retenido"))
                {
                }
                column(Retenciones_FE__Fecha_emision_doc__sustento_Caption; FieldCaption("Fecha emision doc. sustento"))
                {
                }
                column(Retenciones_FE__Ejercicio_fiscal_Caption; FieldCaption("Ejercicio fiscal"))
                {
                }
                column(Retenciones_FE__Num__doc__sustento_Caption; Retenciones_FE__Num__doc__sustento_CaptionLbl)
                {
                }
                column(Retenciones_FE_ComprobanteCaption; FieldCaption(Comprobante))
                {
                }
                column(Retenciones_FE_ImpuestoCaption; FieldCaption(Impuesto))
                {
                }
                column(Retenciones_FE_No__documento; "No. documento")
                {
                }
                column(Retenciones_FE_Codigo; Codigo)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin

                recTmpBLOB.Init;
                cduBarras.C128MakeBarcode(Clave, recTmpBLOB, 5300, 423, 96, true);

                case "Tipo emision" of
                    "Tipo emision"::Normal:
                        texEmision := Text002;
                    "Tipo emision"::Contingencia:
                        texEmision := Text004;
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
        "NÒMERO_DE_AUTORIZACIÊNCaptionLbl": Label 'NÚMERO DE AUTORIZACIÓN';
        Establecimiento______Punto_de_emision______SecuencialCaptionLbl: Label 'No.';
        "GUIA_DE_REMISIÊNCaptionLbl": Label 'COMPROBANTE DE RETENCIÓN';
        Documento_FE__Fecha_hora_autorizacion_CaptionLbl: Label 'FECHA Y HORA DE AUTORIZACIÓN';
        Documento_FE__Ambiente_autorizacion_CaptionLbl: Label 'AMBIENTE:';
        Documento_FE__Ambiente_autorizacion__Control1000000030CaptionLbl: Label 'EMISIÓN:';
        CLAVE_DE_ACCESOCaptionLbl: Label 'CLAVE DE ACCESO';
        SICaptionLbl: Label 'SI';
        "Razón_Solical__Nombres_y_Apellidos_CaptionLbl": Label 'Razón Solical /Nombres y Apellidos:';
        "Fecha_emisiónCaptionLbl": Label 'Fecha emisión';
        "IdentificaciónCaptionLbl": Label 'Identificación';
        Retenciones_FE__Base_imponible_CaptionLbl: Label 'Base imponible para la retención';
        Retenciones_FE__Porcentaje_retener_CaptionLbl: Label 'Porcentaje retención';
        Retenciones_FE__Num__doc__sustento_CaptionLbl: Label 'Número';
        Direccion_Lbl: Label 'Dirección';
        Telefono_Lbl: Label 'Teléfono';
        Email_Lbl: Label 'Email';
        Adicionales_Lbl: Label 'Información Adicional';
}

