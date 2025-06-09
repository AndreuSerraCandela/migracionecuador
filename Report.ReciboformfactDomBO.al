report 54010 "Recibo form.fact. Dom. BO"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReciboformfactDomBO.rdlc';
    Permissions = TableData "Historico Cab. nomina" = rimd,
                  TableData "Historico Lin. nomina" = rimd;

    dataset
    {
        dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
            RequestFilterFields = "No. empleado", "Tipo de nomina", "Período";
            column("Histórico_Cab__nómina_No__empleado"; "No. empleado")
            {
            }
            column("Histórico_Cab__nómina_Ano"; Ano)
            {
            }
            column("Histórico_Cab__nómina_Período"; Período)
            {
            }
            column("Histórico_Cab__nómina_Tipo_Nomina"; "Tipo Nomina")
            {
            }
            dataitem("Historico Lin. nomina"; "Historico Lin. nomina")
            {
                DataItemLink = "No. empleado" = FIELD("No. empleado"), "Tipo Nómina" = FIELD("Tipo Nomina"), "Período" = FIELD("Período");
                DataItemTableView = SORTING("No. empleado", "Tipo Nómina", "Período", "No. Orden") WHERE("Excluir de listados" = CONST(false));
                column("Histórico_Lín__nómina__No__empleado_"; 'Empleado: ' + "Historico Cab. nomina"."Full name")
                {
                }
                column(TODAY; Today)
                {
                }
                column(TIME; Time)
                {
                }
                column("Histórico_Cab__nómina__Inicio"; Format("Historico Cab. nomina".Inicio, 0, '<Month Text>-<Year4>'))
                {
                }
                column(TotIng___TotDed; 'Salario Básico Mensual Bolivianos: ' + Format(Round(Salario, 0.01), 0, '<Integer thousand><Decimals,3>'))
                {
                }
                column(rEmpresa_Picture; Empresa.Imagen)
                {
                }
                column(rnl; 'Registro Patronal No. ' + Empresa."ID RNL")
                {
                }
                column(cargo; Cargos.Descripcion)
                {
                }
                column(DescDeducc_1_; DescDeducc[1])
                {
                }
                column(DescDeducc_2_; DescDeducc[2])
                {
                }
                column(DescDeducc_3_; DescDeducc[3])
                {
                }
                column(DescDeducc_4_; DescDeducc[4])
                {
                }
                column(DescDeducc_5_; DescDeducc[5])
                {
                }
                column(DescDeducc_6_; DescDeducc[6])
                {
                }
                column(DescDeducc_7_; DescDeducc[7])
                {
                }
                column(DescDeducc_8_; DescDeducc[8])
                {
                }
                column(DescDeducc_9_; DescDeducc[9])
                {
                }
                column(DescIngreso_1_; DescIngreso[1])
                {
                }
                column(DescIngreso_2_; DescIngreso[2])
                {
                }
                column(DescIngreso_3_; DescIngreso[3])
                {
                }
                column(DescIngreso_4_; DescIngreso[4])
                {
                }
                column(DescIngreso_5_; DescIngreso[5])
                {
                }
                column(DescIngreso_6_; DescIngreso[6])
                {
                }
                column(DescIngreso_7_; DescIngreso[7])
                {
                }
                column(DescIngreso_8_; DescIngreso[8])
                {
                }
                column(DescIngreso_9_; DescIngreso[9])
                {
                }
                column(DescIngreso_10_; DescIngreso[10])
                {
                }
                column(DescDeducc_10_; DescDeducc[10])
                {
                }
                column(Horas_1_; Horas[1])
                {
                    AutoFormatType = 1;
                }
                column(Horas_2_; Horas[2])
                {
                    AutoFormatType = 1;
                }
                column(Horas_3_; Horas[3])
                {
                    AutoFormatType = 1;
                }
                column(Horas_4_; Horas[4])
                {
                    AutoFormatType = 1;
                }
                column(Horas_5_; Horas[5])
                {
                    AutoFormatType = 1;
                }
                column(Horas_6_; Horas[6])
                {
                    AutoFormatType = 1;
                }
                column(Horas_7_; Horas[7])
                {
                    AutoFormatType = 1;
                }
                column(Horas_8_; Horas[8])
                {
                    AutoFormatType = 1;
                }
                column(Horas_9_; Horas[9])
                {
                    AutoFormatType = 1;
                }
                column(Horas_10_; Horas[10])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_1_; ImportIngreso[1])
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0 : 2;
                }
                column(ImportIngreso_2_; ImportIngreso[2])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_3_; ImportIngreso[3])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_4_; ImportIngreso[4])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_5_; ImportIngreso[5])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_6_; ImportIngreso[6])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_7_; ImportIngreso[7])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_8_; ImportIngreso[8])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_9_; ImportIngreso[9])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_10_; ImportIngreso[10])
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_1__; Abs(ImportEgreso[1]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_2__; Abs(ImportEgreso[2]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_3__; Abs(ImportEgreso[3]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_4__; Abs(ImportEgreso[4]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_5__; Abs(ImportEgreso[5]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_6__; Abs(ImportEgreso[6]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_7__; Abs(ImportEgreso[7]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_8__; Abs(ImportEgreso[8]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_9__; Abs(ImportEgreso[9]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_10__; Abs(ImportEgreso[10]))
                {
                    AutoFormatType = 1;
                }
                column(ImporteIngresoTotal; ImporteIngresoTotal)
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgresoTotal_; Abs(ImportEgresoTotal))
                {
                    AutoFormatType = 1;
                }
                column(ImporteIngresoTotal1; ImporteIngresoTotal + ImportEgresoTotal)
                {
                    AutoFormatType = 1;
                }
                column(DescRCIVA_101_; TextoRCIVA)
                {
                }
                column(DescIngreso_101_; 'SON BOLIVIANOS: ' + DescriptionLine[1])
                {
                }
                column(Empleado_No_Documento; 'C.I. ' + Emp."Document ID")
                {
                }
                column(TODAYCaption; TODAYCaptionLbl)
                {
                }
                column(TIMECaption; TIMECaptionLbl)
                {
                }
                column("Recibo_de_nómina_períodoCaption"; Recibo_de_nómina_períodoCaptionLbl)
                {
                }
                column("Recibo_de_nómina_período2Caption"; Recibo_de_nómina_período2CaptionLbl)
                {
                }
                column(DescuentosCaption; DescuentosCaptionLbl)
                {
                }
                column(IngresosCaption; IngresosCaptionLbl)
                {
                }
                column("DescripciónCaption"; DescripciónCaptionLbl)
                {
                }
                column(HorasCaption; HorasCaptionLbl)
                {
                }
                column(ValorCaption; ValorCaptionLbl)
                {
                }
                column(ValorCaption_Control41; ValorCaption_Control41Lbl)
                {
                }
                column("DescripciónCaption_Control43"; DescripciónCaption_Control43Lbl)
                {
                }
                column(Total_ingresosCaption; Total_ingresosCaptionLbl)
                {
                }
                column(Total_deduccionesCaption; Total_deduccionesCaptionLbl)
                {
                }
                column(Total_ingresosnCaption; Total_ingresosnCaptionLbl)
                {
                }
                column(Agree_with_ReceiveCaption; Agree_with_ReceiveCaptionLbl)
                {
                }
                column("Recibo_de_nómina_msg1Caption"; Recibo_de_nómina_msg1CaptionLbl)
                {
                }
                column(Agree_with_Receive2Caption; Agree_with_Receive2CaptionLbl)
                {
                }
                column("Histórico_Lín__nómina_No__empleado"; "No. empleado")
                {
                }
                column("Histórico_Lín__nómina_Tipo_Nómina"; "Tipo Nómina")
                {
                }
                column("Histórico_Lín__nómina_Período"; Período)
                {
                }
                column("Histórico_Lín__nómina_No__Orden"; "No. Orden")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Tipo concepto" = "Tipo concepto"::Ingresos then begin
                        i += 1;
                        DescIngreso[i] := Descripción;
                        Horas[i] := Cantidad;
                        ImportIngreso[i] := Total;
                        ImporteIngresoTotal += ImportIngreso[i];
                        if "Salario Base" then
                            Salario := "Importe Base";
                    end
                    else begin
                        id += 1;
                        DescDeducc[id] := Descripción;
                        Cant[id] := Cantidad;
                        ImportEgreso[id] := Total;
                        ImportEgresoTotal += ImportEgreso[id];
                    end;
                end;

                trigger OnPreDataItem()
                begin

                    for i := 1 to 10 do begin
                        DescIngreso[i] := '';
                        Horas[i] := 0;
                        ImportIngreso[i] := 0;
                    end;
                    for id := 1 to 10 do begin
                        DescDeducc[i] := '';
                        Cant[i] := 0;
                        ImportEgreso[i] := 0;
                    end;
                    i := 0;
                    id := 0;
                end;
            }
            dataitem(HLN; "Historico Lin. nomina")
            {
                DataItemLink = "No. empleado" = FIELD("No. empleado"), "Tipo Nómina" = FIELD("Tipo Nomina"), "Período" = FIELD("Período");
                DataItemTableView = SORTING("No. empleado", "Tipo Nómina", "Período", "No. Orden") WHERE("Excluir de listados" = CONST(false));
                column("Histórico_Lín__nómina__No__empleado2_"; 'Empleado: ' + "Historico Cab. nomina"."Full name")
                {
                }
                column(TODAY2; Today)
                {
                }
                column(TIME2; Time)
                {
                }
                column("Histórico_Cab__nómina__Inicio2"; Format("Historico Cab. nomina".Inicio, 0, '<Month Text>-<Year4>'))
                {
                }
                column(Empresa_Picture2; Empresa.Imagen)
                {
                }
                column(rnl2; 'Registro Patronal No. ' + Empresa."ID RNL")
                {
                }
                column(cargo2; Cargos.Descripcion)
                {
                }
                column(TotIng___TotDed2; 'Salario Básico Mensual Bolivianos: ' + Format(Round(Salario, 0.01), 0, '<Integer thousand><Decimals,3>'))
                {
                }
                column(DescDeducc_12_; DescDeducc[1])
                {
                }
                column(DescDeducc_22_; DescDeducc[2])
                {
                }
                column(DescDeducc_32_; DescDeducc[3])
                {
                }
                column(DescDeducc_42_; DescDeducc[4])
                {
                }
                column(DescDeducc_52_; DescDeducc[5])
                {
                }
                column(DescDeducc_62_; DescDeducc[6])
                {
                }
                column(DescDeducc_72_; DescDeducc[7])
                {
                }
                column(DescDeducc_82_; DescDeducc[8])
                {
                }
                column(DescDeducc_92_; DescDeducc[9])
                {
                }
                column(DescIngreso_12_; DescIngreso[1])
                {
                }
                column(DescIngreso_22_; DescIngreso[2])
                {
                }
                column(DescIngreso_32_; DescIngreso[3])
                {
                }
                column(DescIngreso_42_; DescIngreso[4])
                {
                }
                column(DescIngreso_52_; DescIngreso[5])
                {
                }
                column(DescIngreso_62_; DescIngreso[6])
                {
                }
                column(DescIngreso_72_; DescIngreso[7])
                {
                }
                column(DescIngreso_82_; DescIngreso[8])
                {
                }
                column(DescIngreso_92_; DescIngreso[9])
                {
                }
                column(DescIngreso_102_; DescIngreso[10])
                {
                }
                column(DescDeducc_102_; DescDeducc[10])
                {
                }
                column(Horas_12_; Horas[1])
                {
                    AutoFormatType = 1;
                }
                column(Horas_22_; Horas[2])
                {
                    AutoFormatType = 1;
                }
                column(Horas_32_; Horas[3])
                {
                    AutoFormatType = 1;
                }
                column(Horas_42_; Horas[4])
                {
                    AutoFormatType = 1;
                }
                column(Horas_52_; Horas[5])
                {
                    AutoFormatType = 1;
                }
                column(Horas_62_; Horas[6])
                {
                    AutoFormatType = 1;
                }
                column(Horas_72_; Horas[7])
                {
                    AutoFormatType = 1;
                }
                column(Horas_82_; Horas[8])
                {
                    AutoFormatType = 1;
                }
                column(Horas_92_; Horas[9])
                {
                    AutoFormatType = 1;
                }
                column(Horas_102_; Horas[10])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_12_; ImportIngreso[1])
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0 : 2;
                }
                column(ImportIngreso_22_; ImportIngreso[2])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_32_; ImportIngreso[3])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_42_; ImportIngreso[4])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_52_; ImportIngreso[5])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_62_; ImportIngreso[6])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_72_; ImportIngreso[7])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_82_; ImportIngreso[8])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_92_; ImportIngreso[9])
                {
                    AutoFormatType = 1;
                }
                column(ImportIngreso_102_; ImportIngreso[10])
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_12__; Abs(ImportEgreso[1]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_22__; Abs(ImportEgreso[2]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_32__; Abs(ImportEgreso[3]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_42__; Abs(ImportEgreso[4]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_52__; Abs(ImportEgreso[5]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_62__; Abs(ImportEgreso[6]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_72__; Abs(ImportEgreso[7]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_82__; Abs(ImportEgreso[8]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_92__; Abs(ImportEgreso[9]))
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgreso_102__; Abs(ImportEgreso[10]))
                {
                    AutoFormatType = 1;
                }
                column(ImporteIngresoTotal2; ImporteIngresoTotal)
                {
                    AutoFormatType = 1;
                }
                column(ABS_ImportEgresoTotal2_; Abs(ImportEgresoTotal))
                {
                    AutoFormatType = 1;
                }
                column(ImporteIngresoTotal12; ImporteIngresoTotal + ImportEgresoTotal)
                {
                    AutoFormatType = 1;
                }
                column(DescRCIVA_102_; TextoRCIVA)
                {
                }
                column(DescIngreso_1012_; 'SON BOLIVIANOS: ' + DescriptionLine[1])
                {
                }
                column(Empleado_No_Documento2; 'C.I. ' + Emp."Document ID")
                {
                }
                column(TODAY2Caption; TODAY2CaptionLbl)
                {
                }
                column(TIME2Caption; TIME2CaptionLbl)
                {
                }
                column("Recibo_de_nómina_período22Caption"; Recibo_de_nómina_período22CaptionLbl)
                {
                }
                column("Recibo_de_nómina_período222Caption"; Recibo_de_nómina_período222CaptionLbl)
                {
                }
                column(Descuentos2Caption; Descuentos2CaptionLbl)
                {
                }
                column(Ingresos2Caption; Ingresos2CaptionLbl)
                {
                }
                column("Descripción2Caption"; Descripción2CaptionLbl)
                {
                }
                column(Horas2Caption; Horas2CaptionLbl)
                {
                }
                column(Valor2Caption; Valor2CaptionLbl)
                {
                }
                column(ValorCaption2_Control41; ValorCaption2_Control41Lbl)
                {
                }
                column("DescripciónCaption2_Control43"; DescripciónCaption2_Control43Lbl)
                {
                }
                column(Total_ingresos2Caption; Total_ingresos2CaptionLbl)
                {
                }
                column(Total_deducciones2Caption; Total_deducciones2CaptionLbl)
                {
                }
                column(Total_ingresosn2Caption; Total_ingresosn2CaptionLbl)
                {
                }
                column("Recibo_de_nómina_msg2Caption"; Recibo_de_nómina_msg2CaptionLbl)
                {
                }
                column(Agree_with_Receive22Caption; Agree_with_Receive22CaptionLbl)
                {
                }
                column(Agree_with_Receive222Caption; Agree_with_Receive222CaptionLbl)
                {
                }
                column(HLN_No__empleado; "No. empleado")
                {
                }
                column("HLN_Tipo_Nómina"; "Tipo Nómina")
                {
                }
                column("HLN_Período"; Período)
                {
                }
                column(HLN_No__Orden; "No. Orden")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ImportIngreso);
                Clear(ImportEgreso);
                Clear(ImporteIngresoTotal);
                Clear(ImportEgresoTotal);
                Clear(TotIng);
                Clear(TotDed);
                Clear(Horas);
                Clear(DescIngreso);
                Clear(DescDeducc);
                Clear(Cant);
                CalcFields("Total Ingresos", "Total deducciones");
                TotIng := "Total Ingresos";
                TotDed := "Total deducciones";
                txtDesc := '';
                TextoRCIVA := '';

                if not Cargos.Get(Cargo) then
                    Cargos.Init
                else
                    txtDesc := Cargos.Descripcion;

                Emp.Get("No. empleado");

                if not Depto.Get(Emp.Departamento) then
                    Depto.Init
                else
                    txtDesc += ' / ' + Depto.Descripcion;

                if not SubDepto.Get(Emp.Departamento, Emp."Sub-Departamento") then
                    SubDepto.Init
                else
                    txtDesc += ' / ' + SubDepto.Descripcion;


                TextoInformativo := '';
                "Historico Lin. nomina".Reset;
                "Historico Lin. nomina".SetRange("No. empleado", "No. empleado");
                "Historico Lin. nomina".SetRange("Tipo Nómina", "Tipo Nomina");
                "Historico Lin. nomina".SetRange(Período, Período);
                "Historico Lin. nomina".SetRange("No. Documento", "No. Documento");
                "Historico Lin. nomina".SetRange("Texto Informativo", true);
                if "Historico Lin. nomina".FindFirst then begin
                    TextoRCIVA += 'Formulario 110 presentado: ' + Format("Historico Lin. nomina"."Importe Base", 0,
                    '<Integer Thousand><Decimals,3>');
                end;

                "Historico Lin. nomina".Reset;
                "Historico Lin. nomina".SetRange("No. empleado", "No. empleado");
                "Historico Lin. nomina".SetRange("Tipo Nómina", "Tipo Nomina");
                "Historico Lin. nomina".SetRange(Período, Período);
                "Historico Lin. nomina".SetRange("No. Documento", "No. Documento");
                "Historico Lin. nomina".SetRange("Excluir de listados", true);
                if "Historico Lin. nomina".FindFirst then begin
                    TotIng -= "Historico Lin. nomina".Total;
                end;

                BKIsr.Reset;
                BKIsr.SetRange("Cod. Empleado", "No. empleado");
                if BKIsr.FindFirst then begin
                    TextoRCIVA += ', Saldo RC IVA anterior: ' + Format(BKIsr."Document ID", 0,
                   '<Integer Thousand><Decimals,3>');
                end;

                Isr.Reset;
                Isr.SetRange("Cód. Empleado", "No. empleado");
                if Isr.FindFirst then begin
                    TextoRCIVA += ', Nuevo saldo RC IVA: ' + Format(Isr."Importe Pendiente", 0,
                   '<Integer Thousand><Decimals,3>');
                end;
            end;

            trigger OnPreDataItem()
            begin
                Empresa.FindFirst;
                Empresa.CalcFields(Imagen);
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

    var
        Empresa: Record "Empresas Cotizacion";
        Emp: Record Employee;
        Cargos: Record "Puestos laborales";
        Depto: Record Departamentos;
        SubDepto: Record "Sub-Departamentos";
        //ChkTransMgt: Report "Check Translation Management";
        Isr: Record "Saldos a favor ISR";
        BKIsr: Record "Prestaciones masivas";
        DescIngreso: array[10] of Text[50];
        DescDeducc: array[10] of Text[50];
        DescriptionLine: array[2] of Text[1024];
        Horas: array[10] of Decimal;
        ImportIngreso: array[10] of Decimal;
        Cant: array[10] of Decimal;
        ImportEgreso: array[10] of Decimal;
        i: Integer;
        id: Integer;
        ImporteIngresoTotal: Decimal;
        ImportEgresoTotal: Decimal;
        TotIng: Decimal;
        TotDed: Decimal;
        txtDesc: Text[250];
        TextoInformativo: Text[250];
        TextoRCIVA: Text[250];
        Salario: Decimal;
        TODAYCaptionLbl: Label 'Date:';
        TIMECaptionLbl: Label 'Time:';
        "Recibo_de_nómina_períodoCaptionLbl": Label 'LIQUIDACION DE SALARIOS';
        "Recibo_de_nómina_período2CaptionLbl": Label 'ORIGINAL';
        DescuentosCaptionLbl: Label 'Descuentos';
        IngresosCaptionLbl: Label 'Ingresos';
        "DescripciónCaptionLbl": Label 'Descripción';
        HorasCaptionLbl: Label 'Qty/Time';
        ValorCaptionLbl: Label 'Valor';
        ValorCaption_Control41Lbl: Label 'Valor';
        "DescripciónCaption_Control43Lbl": Label 'Descripción';
        Total_ingresosCaptionLbl: Label 'Total ingresos';
        Total_deduccionesCaptionLbl: Label 'Total deducciones';
        Total_ingresosnCaptionLbl: Label 'NETO A PERCIBIR';
        Agree_with_ReceiveCaptionLbl: Label 'Agree with Receive';
        "Recibo_de_nómina_msg1CaptionLbl": Label 'Percibí con total conformidad de SANTILLANA S.A.el importe detallado precedentemente, manifestando asimismo haber recibido una copia de la presente liquidacion, firmada por el Empleador.';
        Agree_with_Receive2CaptionLbl: Label 'By the company';
        TODAY2CaptionLbl: Label 'Date:';
        TIME2CaptionLbl: Label 'Time:';
        "Recibo_de_nómina_período22CaptionLbl": Label 'LIQUIDACION DE SALARIOS';
        "Recibo_de_nómina_período222CaptionLbl": Label 'COPIA';
        Descuentos2CaptionLbl: Label 'Descuentos';
        Ingresos2CaptionLbl: Label 'Ingresos';
        "Descripción2CaptionLbl": Label 'Descripción';
        Horas2CaptionLbl: Label 'Qty/Time';
        Valor2CaptionLbl: Label 'Valor';
        ValorCaption2_Control41Lbl: Label 'Valor';
        "DescripciónCaption2_Control43Lbl": Label 'Descripción';
        Total_ingresos2CaptionLbl: Label 'Total ingresos';
        Total_deducciones2CaptionLbl: Label 'Total deducciones';
        Total_ingresosn2CaptionLbl: Label 'NETO A PERCIBIR';
        "Recibo_de_nómina_msg2CaptionLbl": Label 'Percibí con total conformidad de SANTILLANA S.A.el importe detallado precedentemente, manifestando asimismo haber recibido una copia de la presente liquidacion, firmada por el Empleador.';
        Agree_with_Receive22CaptionLbl: Label 'By the company';
        Agree_with_Receive222CaptionLbl: Label 'Agree with Receive';
}

