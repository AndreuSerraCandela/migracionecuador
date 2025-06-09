report 76072 "Lista acumulado Regalía"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListaacumuladoRegalía.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            CalcFields = Salario, "Acumulado Salario";
            DataItemTableView = SORTING("No.") WHERE(Status = CONST(Active));
            RequestFilterFields = "No.", "Posting Group";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(TotImporte; TotImporte)
            {
                AutoFormatType = 1;
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Full_Name_; "Full Name")
            {
            }
            column(AcumuladoSalario; AcumuladoSalario)
            {
                AutoFormatType = 1;
            }
            column(Employee_Salario; Salario)
            {
                AutoFormatType = 1;
            }
            column(Employee__Employment_Date_; "Employment Date")
            {
                AutoFormatType = 1;
            }
            column(TotImporte_Control25; TotImporte)
            {
                AutoFormatType = 1;
            }
            column(AcumuladoSalario_Control9; AcumuladoSalario)
            {
                AutoFormatType = 1;
            }
            column(TotEmpleados; TotEmpleados)
            {
                DecimalPlaces = 0 : 0;
            }
            column(Acumulado_de_regalia_por_empleadoCaption; Acumulado_de_regalia_por_empleadoCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TotImporteCaption; TotImporteCaptionLbl)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(AcumuladoSalarioCaption; AcumuladoSalarioCaptionLbl)
            {
            }
            column(Employee__Full_Name_Caption; FieldCaption("Full Name"))
            {
            }
            column(Employee_SalarioCaption; FieldCaption(Salario))
            {
            }
            column(Employee__Employment_Date_Caption; FieldCaption("Employment Date"))
            {
            }
            column(Total_Gral_Caption; Total_Gral_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                MontoVac: Decimal;
                DiasVac: Decimal;
                tDias: Integer;
            begin
                TotImporte := 0;
                UltIngresosxQuincena := 0;
                UltIngresosOtros := 0;
                TotNominas := 0;

                //Busco el contrato para saber la frecuencia de pago
                Contrato.Reset;
                Contrato.SetRange("No. empleado", "No.");
                if not Contrato.FindLast then
                    Contrato.Init;

                if ("Proyectar salario 12") and (Contrato.Activo) then begin
                    if Date2DMY(Contrato."Fecha inicio", 3) < Anotrabajo then begin
                        if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
                           (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") then
                            CantidadDeNominas := 24
                        else
                            if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Semanal then
                                CantidadDeNominas := 52
                            else
                                CantidadDeNominas := 12;
                    end
                    else begin
                        if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
                           (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") then begin
                            CantidadDeNominas := Date2DMY(Contrato."Fecha inicio", 2);
                            CantidadDeNominas := CantidadDeNominas * 2;
                            CantidadDeNominas := 24 - CantidadDeNominas;
                        end
                        else
                            if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Semanal then begin
                                Fecha.Reset;
                                Fecha.SetRange("Period Type", Fecha."Period Type"::Week);
                                Fecha.SetFilter("Period Start", '>=%1', Contrato."Fecha inicio");
                                Fecha.FindFirst;
                                CantidadDeNominas := 52 - Fecha."Period No.";
                            end
                            else
                                CantidadDeNominas := 12 - Date2DMY(Contrato."Fecha inicio", 2);
                    end;

                    //Busco todas las nominas generadas
                    HistLinNom.Reset;
                    HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, Total);
                    HistLinNom.SetRange("No. empleado", "No.");
                    // HistLinNom.SETRANGE("Tipo Nómina",HistLinNom."Tipo Nómina"::Normal);
                    if (TiposNom."Dia inicio 1ra" <> 1) then
                        HistLinNom.SetRange(Período, DMY2Date(TiposNom."Dia inicio 1ra", Date2DMY(CalcDate('-1M', Fecha."Period Start"), 2), Date2DMY(CalcDate('-1M', Fecha."Period Start"), 3)), DMY2Date(TiposNom."Dia inicio 2da", 12, Date2DMY(Fecha."Period Start", 3)))
                    else
                        HistLinNom.SetRange(Período, DMY2Date(1, 1, Date2DMY(NormalDate(Fecha."Period End"), 3)), DMY2Date(31, 12, Date2DMY(NormalDate(Fecha."Period End"), 3)));
                    HistLinNom.SetRange("Aplica para Regalia", true);
                    if HistLinNom.FindSet then
                        repeat
                            Mes := Date2DMY(HistLinNom.Período, 2);
                            TotImporte += HistLinNom.Total;
                        until HistLinNom.Next = 0;

                    //Busco la cantidad de nominas
                    HistCabNom.Reset;
                    HistCabNom.SetRange("No. empleado", "No.");
                    HistCabNom.SetRange("Tipo de nomina", TiposNom.Codigo);
                    if (TiposNom."Dia inicio 1ra" <> 1) then
                        HistCabNom.SetRange(Período, DMY2Date(TiposNom."Dia inicio 1ra", Date2DMY(CalcDate('-1M', Fecha."Period Start"), 2), Date2DMY(CalcDate('-1M', Fecha."Period Start"), 3)), DMY2Date(TiposNom."Dia inicio 2da", 12, Date2DMY(Fecha."Period Start", 3)))
                    else
                        HistCabNom.SetRange(Período, DMY2Date(1, 1, Date2DMY(NormalDate(Fecha."Period End"), 3)), DMY2Date(31, 12, Date2DMY(NormalDate(Fecha."Period End"), 3)));

                    //      HistCabNom.SETRANGE(Período,DMY2DATE(1,1,Anotrabajo),DMY2DATE(31,12,Anotrabajo));
                    if HistCabNom.FindSet then
                        repeat
                            TotNominas += 1;
                        until HistCabNom.Next = 0;

                    HistCabNom.Reset;
                    HistCabNom.SetRange("No. empleado", "No.");
                    //HistCabNom.SETRANGE("Tipo Nomina",HistCabNom."Tipo Nomina"::Normal);
                    HistCabNom.SetRange(Período, DMY2Date(1, 1, Anotrabajo), DMY2Date(31, 12, Anotrabajo));
                    if HistCabNom.FindLast then begin
                        HistLinNom.Reset;
                        HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, Total);
                        HistLinNom.SetRange("No. empleado", "No.");
                        //HistLinNom.SETRANGE("Tipo Nómina",HistLinNom."Tipo Nómina"::Normal);
                        HistLinNom.SetRange(Período, DMY2Date(1, Date2DMY(HistCabNom.Período, 2), Date2DMY(HistCabNom.Período, 3)), HistCabNom.Período);
                        HistLinNom.SetRange("Aplica para Regalia", true);
                        if HistLinNom.FindSet then
                            repeat
                                LinEsqSalarial.Reset;
                                LinEsqSalarial.SetRange("No. empleado", "No.");
                                LinEsqSalarial.SetRange("Concepto salarial", HistLinNom."Concepto salarial");
                                LinEsqSalarial.FindFirst;
                                if (ConfNominas."Concepto Sal. Base" = HistLinNom."Concepto salarial") and
                                   (Date2DMY(HistLinNom.Período, 1) > 1) then begin
                                    if LinEsqSalarial."1ra Quincena" and LinEsqSalarial."2da Quincena" then
                                        UltIngresosxQuincena += HistLinNom.Total
                                    else
                                        UltIngresosOtros += HistLinNom.Total;
                                end
                                else
                                    if (ConfNominas."Concepto Sal. Base" <> HistLinNom."Concepto salarial") then begin
                                        if LinEsqSalarial."1ra Quincena" and LinEsqSalarial."2da Quincena" then
                                            UltIngresosxQuincena += HistLinNom.Total
                                        else
                                            UltIngresosOtros += HistLinNom.Total;
                                    end;
                            until HistLinNom.Next = 0;


                        AcumuladoSalario := TotImporte;

                        if Mes <> 12 then begin
                            if Date2DMY(Contrato."Fecha inicio", 3) < Anotrabajo then begin
                                if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
                                   (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") then begin
                                    TotNominas := CantidadDeNominas - TotNominas;
                                end
                                else
                                    if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Semanal then
                                        TotNominas := CantidadDeNominas - TotNominas
                                    else
                                        TotNominas := CantidadDeNominas - TotNominas;
                            end
                            else begin
                                if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
                                   (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") then begin
                                    TotNominas := (12 - Mes) * 2;
                                end
                                else
                                    if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Semanal then begin
                                        TotNominas := CantidadDeNominas - TotNominas;
                                        TotNominas := 52 - TotNominas;
                                    end
                                    else begin
                                        TotNominas := CantidadDeNominas - TotNominas;
                                        TotNominas := 12 - TotNominas;
                                    end;
                            end;

                            //Mes := 12 - Mes;
                            TotImporte := TotImporte + (UltIngresosxQuincena * TotNominas) + UltIngresosOtros;
                            AcumuladoSalario := TotImporte;
                            TotImporte := TotImporte / 12;
                        end
                        else
                            if ((Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
                                (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal")) and
                                (Mes = 12) and ((TotNominas = 11) or (TotNominas = 23)) then
                                TotImporte := (TotImporte + UltIngresosxQuincena) / 12
                            else
                                TotImporte /= 12;
                    end;
                end
                else begin
                    //Busco todas las nominas generadas
                    HistLinNom.Reset;
                    HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, Total);
                    HistLinNom.SetRange("No. empleado", "No.");
                    HistLinNom.SetRange("Tipo Nómina", HistLinNom."Tipo Nómina"::Normal);
                    HistLinNom.SetRange(Período, DMY2Date(1, 1, Anotrabajo), DMY2Date(31, 12, Anotrabajo));
                    HistLinNom.SetRange("Aplica para Regalia", true);
                    if HistLinNom.FindSet then
                        repeat
                            TotImporte += HistLinNom.Total;
                        until HistLinNom.Next = 0;
                    AcumuladoSalario := TotImporte;
                    TotImporte := TotImporte / 12;
                end;

                TotImporte := Round(TotImporte, 0.01);
                if AplicarNomina then begin
                    LinEsqSalarial.Reset;
                    LinEsqSalarial.SetRange("No. empleado", "No.");
                    LinEsqSalarial.SetRange("Concepto salarial", ConfNominas."Concepto Regalia");
                    LinEsqSalarial.FindFirst;
                    LinEsqSalarial.Cantidad := 1;
                    LinEsqSalarial.Importe := TotImporte;
                    LinEsqSalarial."Tipo Nomina" := LinEsqSalarial."Tipo Nomina"::"Regalía";
                    LinEsqSalarial.Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin
                ConfNominas.Get();
                TiposNom.Reset;
                TiposNom.SetRange("Tipo de nomina", TiposNom."Tipo de nomina"::Regular);
                TiposNom.FindFirst;

                if AplicarNomina then
                    ConfNominas.TestField("Concepto Regalia");
                //CurrReport.CreateTotals(TotImporte, AcumuladoSalario, AcumuladoAusencias);
                if Anotrabajo = 0 then
                    Error(Err001);

                Fecha.Reset;
                Fecha.SetRange("Period Type", Fecha."Period Type"::Year);
                Fecha.SetRange("Period Start", DMY2Date(1, 1, Anotrabajo));
                Fecha.FindFirst;

                if (TiposNom."Dia inicio 1ra" <> 1) then
                    SetRange("Date Filter", DMY2Date(TiposNom."Dia inicio 1ra", Date2DMY(CalcDate('-1M', Fecha."Period Start"), 2), Date2DMY(CalcDate('-1M', Fecha."Period Start"), 3)), DMY2Date(TiposNom."Dia inicio 2da", 12, Date2DMY(Fecha."Period Start", 3)))
                else
                    SetRange("Date Filter", DMY2Date(1, 1, Date2DMY(NormalDate(Fecha."Period End"), 3)), DMY2Date(31, 12, Date2DMY(NormalDate(Fecha."Period End"), 3)));

                //Verifico que el historico tenga los datos segun la configuracion
                ConceptosSal.Reset;
                ConceptosSal.SetRange("Aplica para Regalia", true);
                ConceptosSal.FindSet;
                repeat
                    HistLinNom.Reset;
                    HistLinNom.SetRange("Concepto salarial", ConceptosSal.Codigo);
                    HistLinNom.SetFilter(Período, GetFilter("Date Filter"));
                    if HistLinNom.FindSet then
                        repeat
                            if HistLinNom."Aplica para Regalia" <> ConceptosSal."Aplica para Regalia" then begin
                                HistLinNom."Aplica para Regalia" := ConceptosSal."Aplica para Regalia";
                                HistLinNom.Modify;
                            end;
                        until HistLinNom.Next = 0;
                until ConceptosSal.Next = 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("Año a generar"; Anotrabajo)
                {
                ApplicationArea = All;
                }
                field("Aplicar a nómina"; AplicarNomina)
                {
                ApplicationArea = All;
                }
                field("Proyecto salario 12"; "Proyectar salario 12")
                {
                ApplicationArea = All;
                    Caption = 'Estimate 12th salary';
                }
                field("Concepto Regalia"; ConfNominas."Concepto Regalia")
                {
                ApplicationArea = All;
                    TableRelation = "Conceptos salariales";
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

    var
        ConfNominas: Record "Configuracion nominas";
        LinEsqSalarial: Record "Perfil Salarial";
        ConceptosSal: Record "Conceptos salariales";
        Fecha: Record Date;
        Contrato: Record Contratos;
        HistCabNom: Record "Historico Cab. nomina";
        HistLinNom: Record "Historico Lin. nomina";
        TiposNom: Record "Tipos de nominas";
        TotImporte: Decimal;
        Anotrabajo: Integer;
        AplicarNomina: Boolean;
        ConceptoSal: Code[10];
        "Proyectar salario 12": Boolean;
        SalarioActual: Decimal;
        AcumuladoSalario: Decimal;
        AcumuladoAusencias: Decimal;
        TotEmpleados: Decimal;
        Err001: Label 'You must select the working year to do the calculation';
        Mes: Integer;
        TotNominas: Integer;
        Acumulado_de_regalia_por_empleadoCaptionLbl: Label 'Acumulado de regalia por empleado';
        CurrReport_PAGENOCaptionLbl: Label 'página';
        TotImporteCaptionLbl: Label 'Regalía a pagar';
        AcumuladoSalarioCaptionLbl: Label 'Acumulado Regalía';
        Total_Gral_CaptionLbl: Label 'Total Gral.';
        UltIngresosxQuincena: Decimal;
        UltIngresosOtros: Decimal;
        CantidadDeNominas: Integer;
}

