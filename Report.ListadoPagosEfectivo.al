report 76069 "Listado Pagos Efectivo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListadoPagosEfectivo.rdlc';

    dataset
    {
        dataitem("Empresas Cotizacion"; "Empresas Cotizacion")
        {
            DataItemTableView = SORTING("Empresa cotizacion");
            column(Empresas_Cotizacion_Empresa_cotizacion; "Empresa cotizacion")
            {
            }
            dataitem("Centros de Trabajo"; "Centros de Trabajo")
            {
                DataItemLink = "Empresa cotización" = FIELD("Empresa cotizacion");
                DataItemTableView = SORTING("Empresa cotización", "Centro de trabajo");
                RequestFilterFields = "Empresa cotización", "Centro de trabajo";
                column(Centros_de_Trabajo_Empresa_cotizacion; "Empresa cotización")
                {
                }
                column(Centros_de_Trabajo_Centro_de_trabajo; "Centro de trabajo")
                {
                }
                dataitem(Employee; Employee)
                {
                    DataItemLink = "Working Center" = FIELD("Centro de trabajo");
                    DataItemTableView = SORTING("Last Name", "First Name", "Middle Name");
                    column(Centros_de_Trabajo___C_P__; "Centros de Trabajo"."C.P.")
                    {
                    }
                    column(Centros_de_Trabajo___Poblaci_n_; "Centros de Trabajo".Población)
                    {
                    }
                    column(Empresas_Cotizaci_n__Provincia; "Empresas Cotizacion".Provincia)
                    {
                    }
                    column(USERID; UserId)
                    {
                    }
                    column(COMPANYNAME; CompanyName)
                    {
                    }
                    column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
                    {
                    }
                    /*column(CurrReport_PAGENO; CurrReport.PageNo)
                    {
                    }*/
                    column(Employee__Working_Center_; "Working Center")
                    {
                    }
                    column(Total; Total)
                    {
                    }
                    column(Centro_de_Trabajo_Caption; Centro_de_Trabajo_CaptionLbl)
                    {
                    }
                    column(Pago_N_minas_en_efectivoCaption; Pago_N_minas_en_efectivoCaptionLbl)
                    {
                    }
                    column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                    {
                    }
                    column(V1Caption; V1CaptionLbl)
                    {
                    }
                    column(DOCCaption; DOCCaptionLbl)
                    {
                    }
                    column(NameCaption; NameCaptionLbl)
                    {
                    }
                    column(AmountCaption; AmountCaptionLbl)
                    {
                    }
                    column(Income_detailCaption; Income_detailCaptionLbl)
                    {
                    }
                    column(Importe_TOTALCaption; Importe_TOTALCaptionLbl)
                    {
                    }
                    column(Employee_No_; "No.")
                    {
                    }
                    dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
                    {
                        DataItemLink = "No. empleado" = FIELD("No.");
                        DataItemLinkReference = Employee;
                        DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
                        RequestFilterFields = "Período", "Tipo de nomina";
                        column(Employee__Document_ID_; Employee."Document ID")
                        {
                        }
                        column(Employee__Full_Name_; Employee."Full Name")
                        {
                        }
                        column(Total_Ingresos___Total_deducciones_; "Total Ingresos" - "Total deducciones")
                        {
                        }
                        column(Historico_Cab__nomina_No__empleado; "No. empleado")
                        {
                        }
                        column(Historico_Cab__nomina_Ano; Ano)
                        {
                        }
                        column("Historico_Cab__nomina_Período"; Período)
                        {
                        }
                        column(Historico_Cab__nomina_Tipo_Nomina; "Tipo Nomina")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CalcFields("Total deducciones", "Total Ingresos");

                            importe := "Total Ingresos" - "Total deducciones";
                            Total := Total + importe;
                            Cheques := Cheques + 1;

                            for i := "Monedas usadas" downto 1 do begin
                                monedas[2, i] := monedas[2, i] + Round(importe / monedas[1, i], 1, '<');
                                // MESSAGE('%1 %2 %3',importe,monedas[1,i],monedas[2,i]);
                                importe := importe - (Round(importe / monedas[1, i], 1, '<') * monedas[1, i]);
                            end;
                            importe := "Total Ingresos" - "Total deducciones";
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not ok then
                            "Forma de Cobro" := 0;

                        //IF  ("Forma de Cobro" <>1) AND
                        //    (("Empresas Cotización"."Forma de Pago" <> 1) OR ("Forma de Cobro" <> 0)) THEN
                        //     CurrReport.SKIP;
                    end;
                }
                dataitem(Counter2; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(COMPANYNAME_Control76; CompanyName)
                    {
                    }
                    column(Centros_de_Trabajo___C_P___Control79; "Centros de Trabajo"."C.P.")
                    {
                    }
                    column(Centros_de_Trabajo___Poblaci_n__Control80; "Centros de Trabajo".Población)
                    {
                    }
                    column(FORMAT_TODAY_0_4__Control81; Format(Today, 0, 4))
                    {
                    }
                    column(USERID_Control82; UserId)
                    {
                    }
                    /*column(CurrReport_PAGENO_Control84; CurrReport.PageNo)
                    {
                    }*/
                    column(Centros_de_Trabajo___Centro_de_trabajo_; "Centros de Trabajo"."Centro de trabajo")
                    {
                    }
                    column(monedas_1_1_; monedas[1, 1])
                    {
                    }
                    column(monedas_2_1_; monedas[2, 1])
                    {
                    }
                    column(monedas_1_1__monedas_2_1_; monedas[1, 1] * monedas[2, 1])
                    {
                    }
                    column(monedas_1_2_; monedas[1, 2])
                    {
                    }
                    column(monedas_2_2_; monedas[2, 2])
                    {
                    }
                    column(monedas_1_2__monedas_2_2_; monedas[1, 2] * monedas[2, 2])
                    {
                    }
                    column(monedas_1_3_; monedas[1, 3])
                    {
                    }
                    column(monedas_2_3_; monedas[2, 3])
                    {
                    }
                    column(monedas_1_3__monedas_2_3_; monedas[1, 3] * monedas[2, 3])
                    {
                    }
                    column(monedas_1_4_; monedas[1, 4])
                    {
                    }
                    column(monedas_2_4_; monedas[2, 4])
                    {
                    }
                    column(monedas_1_4__monedas_2_4_; monedas[1, 4] * monedas[2, 4])
                    {
                    }
                    column(monedas_1_5_; monedas[1, 5])
                    {
                    }
                    column(monedas_2_5_; monedas[2, 5])
                    {
                    }
                    column(monedas_1_5__monedas_2_5_; monedas[1, 5] * monedas[2, 5])
                    {
                    }
                    column(monedas_1_6_; monedas[1, 6])
                    {
                    }
                    column(monedas_2_6_; monedas[2, 6])
                    {
                    }
                    column(monedas_1_6__monedas_2_6_; monedas[1, 6] * monedas[2, 6])
                    {
                    }
                    column(monedas_1_7_; monedas[1, 7])
                    {
                    }
                    column(monedas_2_7_; monedas[2, 7])
                    {
                    }
                    column(monedas_1_7__monedas_2_7_; monedas[1, 7] * monedas[2, 7])
                    {
                    }
                    column(monedas_1_8_; monedas[1, 8])
                    {
                    }
                    column(monedas_2_8_; monedas[2, 8])
                    {
                    }
                    column(monedas_1_8__monedas_2_8_; monedas[1, 8] * monedas[2, 8])
                    {
                    }
                    column(monedas_1_9_; monedas[1, 9])
                    {
                    }
                    column(monedas_2_9_; monedas[2, 9])
                    {
                    }
                    column(monedas_1_9__monedas_2_9_; monedas[1, 9] * monedas[2, 9])
                    {
                    }
                    column(monedas_1_10_; monedas[1, 10])
                    {
                    }
                    column(monedas_2_10_; monedas[2, 10])
                    {
                    }
                    column(monedas_1_10__monedas_2_10_; monedas[1, 10] * monedas[2, 10])
                    {
                    }
                    column(monedas_1_11_; monedas[1, 11])
                    {
                    }
                    column(monedas_2_11_; monedas[2, 11])
                    {
                    }
                    column(monedas_1_11__monedas_2_11_; monedas[1, 11] * monedas[2, 11])
                    {
                    }
                    column(Total_monedas_; "Total monedas")
                    {
                    }
                    column(Centro_de_Trabajo_Caption_Control74; Centro_de_Trabajo_Caption_Control74Lbl)
                    {
                    }
                    column(Pago_N_minas_en_efectivoCaption_Control77; Pago_N_minas_en_efectivoCaption_Control77Lbl)
                    {
                    }
                    column(CurrReport_PAGENO_Control84Caption; CurrReport_PAGENO_Control84CaptionLbl)
                    {
                    }
                    column(V2Caption; V2CaptionLbl)
                    {
                    }
                    column(Valor_Monedas_BilletesCaption; Valor_Monedas_BilletesCaptionLbl)
                    {
                    }
                    column(CantidadCaption; CantidadCaptionLbl)
                    {
                    }
                    column(Desglose_de_monedasCaption; Desglose_de_monedasCaptionLbl)
                    {
                    }
                    column(ImporteCaption; ImporteCaptionLbl)
                    {
                    }
                    column(Counter2_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        cabecera := 1;
                        //CurrReport.NewPage;

                        for i := 1 to "Monedas usadas" do begin
                            "Total monedas" := "Total monedas" + (monedas[1, i] * monedas[2, i]);
                        end;

                        if "Total monedas" = 0 then
                            CurrReport.Skip;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    cabecera := 0;

                    for i := 1 to "Monedas usadas" do begin
                        monedas[2, i] := 0;
                    end;
                    Total := 0;
                    "Total monedas" := 0;
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
                field("Fecha Pago"; fechatrans)
                {
                ApplicationArea = All;
                }
                field("Desglose Moneda 1"; monedas[1, 1])
                {
                ApplicationArea = All;
                }
                field("Desglose Moneda 2"; monedas[1, 2])
                {
                ApplicationArea = All;
                }
                field("Desglose Moneda 3"; monedas[1, 3])
                {
                ApplicationArea = All;
                }
                field("Desglose Moneda 4"; monedas[1, 4])
                {
                ApplicationArea = All;
                }
                field("Desglose Moneda 5"; monedas[1, 5])
                {
                ApplicationArea = All;
                }
                field("Desglose Moneda 6"; monedas[1, 6])
                {
                ApplicationArea = All;
                }
                field("Desglose Moneda 7"; monedas[1, 7])
                {
                ApplicationArea = All;
                }
                field("Desglose Moneda 8"; monedas[1, 8])
                {
                ApplicationArea = All;
                }
                field("Desglose Moneda 9"; monedas[1, 9])
                {
                ApplicationArea = All;
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

    trigger OnInitReport()
    begin
        monedas[1, 1] := 1;
        monedas[1, 2] := 5;
        monedas[1, 3] := 25;
        monedas[1, 4] := 50;
        monedas[1, 5] := 100;
        monedas[1, 6] := 200;
        monedas[1, 7] := 500;
        monedas[1, 8] := 1000;
        monedas[1, 9] := 2000;
        "Monedas usadas" := 9;

        if fechatrans = 0D then fechatrans := WorkDate;
    end;

    var
        ok: Boolean;
        cabecera: Integer;
        importe: Decimal;
        i: Integer;
        "Monedas usadas": Integer;
        monedas: array[2, 20] of Decimal;
        "Total monedas": Decimal;
        Cheques: Decimal;
        RegTrabajad: Record Employee;
        Total: Decimal;
        fechatrans: Date;
        Total1: Decimal;
        Xbancos: Record Bancos;
        transac: Integer;
        Centro_de_Trabajo_CaptionLbl: Label 'Centro de Trabajo:';
        Pago_N_minas_en_efectivoCaptionLbl: Label 'Pago Nóminas en efectivo';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        V1CaptionLbl: Label '1';
        DOCCaptionLbl: Label 'DOC';
        NameCaptionLbl: Label 'Name';
        AmountCaptionLbl: Label 'Amount';
        Income_detailCaptionLbl: Label 'Income detail';
        Importe_TOTALCaptionLbl: Label 'Importe TOTAL';
        Centro_de_Trabajo_Caption_Control74Lbl: Label 'Centro de Trabajo:';
        Pago_N_minas_en_efectivoCaption_Control77Lbl: Label 'Pago Nóminas en efectivo';
        CurrReport_PAGENO_Control84CaptionLbl: Label 'Pág.';
        V2CaptionLbl: Label '2';
        Valor_Monedas_BilletesCaptionLbl: Label 'Valor Monedas/Billetes';
        CantidadCaptionLbl: Label 'Cantidad';
        Desglose_de_monedasCaptionLbl: Label 'Desglose de monedas';
        ImporteCaptionLbl: Label 'Importe';
}

