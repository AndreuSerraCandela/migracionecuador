report 76075 "Contabilizar Nominas - new"
{
    AdditionalSearchTerms = 'Post Payroll';
    //ApplicationArea = Basic, Suite, BasicHR;
    Caption = 'Post Payroll';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Cab. nómina"; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
            RequestFilterFields = "No. empleado", "Período", "Frecuencia de pago", "Tipo de nomina";
            dataitem("Lín. nómina"; "Historico Lin. nomina")
            {
                DataItemLink = "No. Documento" = FIELD("No. Documento"), "No. empleado" = FIELD("No. empleado"), "Tipo de nomina" = FIELD("Tipo de nomina"), "Período" = FIELD("Período");
                DataItemTableView = SORTING("No. empleado", "Tipo Nómina", "Período", "No. Orden") WHERE("Concepto salarial" = FILTER(<> ''), Cantidad = FILTER(<> 0), "Excluir de listados" = CONST(false));

                trigger OnAfterGetRecord()
                var
                    NoCuenta: Code[20];
                    TotRecDistrib: Integer;
                    ImporteDistrib: Decimal;
                    DistribAcumulado: Decimal;
                    Secuencia: Integer;
                begin
                    if not HayNominas then
                        exit;

                    CxCMod := false;

                    CxCEmpl.SetRange("Employee No.", "No. empleado");
                    CxCEmpl.SetRange(Pendiente, true);
                    if CxCEmpl.FindFirst then;



                    ConceptosSalariales.Get("Concepto salarial");


                    //Del Histórico de Nominas
                    if GpoContEmpl.Get(Empleado."Posting Group") then begin
                        ConfGpoContEmpl.Reset;
                        //    ConfGpoContEmpl.SETRANGE("Shortcut Dimension",ConfNomina."Dimension Conceptos Salariales");
                        ConfGpoContEmpl.SetRange(Código, GpoContEmpl.Código);
                        ConfGpoContEmpl.SetRange("Código Concepto Salarial", "Concepto salarial");
                        if ConfGpoContEmpl.FindFirst then begin
                            if ConfGpoContEmpl."Tipo Cuenta Cuota Obrera" <> ConfGpoContEmpl."Tipo Cuenta Cuota Obrera"::Cliente then begin
                                ConfGpoContEmpl.TestField("No. Cuenta Cuota Obrera");
                                NoCuenta := ConfGpoContEmpl."No. Cuenta Cuota Obrera";
                            end
                            else begin
                                Empleado.TestField("Codigo Cliente");
                                NoCuenta := Empleado."Codigo Cliente";
                                TipoCta := 2;
                            end;
                            case ConfGpoContEmpl."Tipo Cuenta Cuota Obrera" of
                                0:
                                    TipoCta := 0;
                                else
                                    TipoCta := 2;
                            end;

                            if ConceptosSalariales."Validar Contrapartida CO" then begin
                                ConfGpoContEmpl.TestField("No. Cuenta Contrapartida CO");
                                case ConfGpoContEmpl."Tipo Cuenta Contrapartida CO" of
                                    0:
                                        TipoContrapartida := 0;
                                    else
                                        TipoContrapartida := 2;
                                end;

                                NoCuentaContrapartida := ConfGpoContEmpl."No. Cuenta Contrapartida CO";
                            end;
                        end
                        else
                            if "Concepto salarial" <> ConfNomina."Concepto CxC Empl." then begin
                                case ConceptosSalariales."Tipo Cuenta Cuota Obrera" of
                                    0:
                                        TipoCta := 0;
                                    1:
                                        TipoCta := 2;
                                    else
                                        TipoCta := 1;
                                end;

                                if TipoCta <> 1 then  //Cliente
                                   begin
                                    ConceptosSalariales.TestField("No. Cuenta Cuota Obrera");
                                    NoCuenta := ConceptosSalariales."No. Cuenta Cuota Obrera";
                                end;

                                if ConceptosSalariales."Validar Contrapartida CO" then begin
                                    ConceptosSalariales.TestField("No. Cuenta Contrapartida CO");
                                    case ConceptosSalariales."Tipo Cuenta Contrapartida CO" of
                                        0:
                                            TipoContrapartida := 0;
                                        else
                                            TipoContrapartida := 2;
                                    end;

                                    NoCuentaContrapartida := ConceptosSalariales."No. Cuenta Contrapartida CO";
                                end;
                            end;
                    end
                    else begin
                        ConceptosSalariales.Get("Concepto salarial");
                        case ConceptosSalariales."Tipo Cuenta Cuota Obrera" of
                            0:
                                TipoCta := 0;
                            1:
                                TipoCta := 2;
                            else
                                TipoCta := 1;
                        end;

                        if TipoCta <> 1 then  //Cliente
                           begin
                            ConceptosSalariales.TestField("No. Cuenta Cuota Obrera");
                            NoCuenta := ConceptosSalariales."No. Cuenta Cuota Obrera";
                        end;

                        if ConceptosSalariales."Validar Contrapartida CO" then begin
                            ConceptosSalariales.TestField("No. Cuenta Contrapartida CO");
                            case ConceptosSalariales."Tipo Cuenta Contrapartida CO" of
                                0:
                                    TipoContrapartida := 0;
                                else
                                    TipoContrapartida := 2;
                            end;

                            NoCuentaContrapartida := ConceptosSalariales."No. Cuenta Contrapartida CO";
                        end;

                        if "Concepto salarial" = ConfNomina."Concepto CxC Empl." then begin
                            TipoCta := 1;
                            NoCuenta := Empleado."Codigo Cliente";
                        end;

                        //Para salir del paso en Hemingway
                        if ("Concepto salarial" = ConfNomina."Concepto CxC Empl.") or
                           (ConceptosSalariales."Tipo Cuenta Cuota Obrera" = 2) or
                          (("Concepto salarial" = '212') or ("Concepto salarial" = '213') or ("Concepto salarial" = '214') or ("Concepto salarial" = '215')) then begin
                            TipoCta := 1;
                            if ConceptosSalariales."No. Cuenta Cuota Obrera" <> '' then
                                NoCuenta := ConceptosSalariales."No. Cuenta Cuota Obrera"
                            else begin
                                Empleado.TestField("Codigo Cliente");
                                NoCuenta := Empleado."Codigo Cliente";
                            end;
                        end;

                    end;


                    //MESSAGE('%1 %2',RelEmpWorkType."Employee No.", "Cab. nómina"."No. empleado");
                    //Para la distribucion % del concepto salarial entre diferentes valores de Dim.
                    TotRecDistrib := 0;
                    DistribAcumulado := 0;
                    ImporteDistrib := Total;
                    Secuencia := 0;

                    DistribEDEmp.Reset;
                    DistribEDEmp.SetRange("Employee no.", Empleado."No.");
                    DistribEDEmp.SetRange("Concepto salarial", "Concepto salarial");
                    TotRecDistrib := DistribEDEmp.Count;
                    if DistribEDEmp.FindSet then
                        repeat
                            Secuencia += 1;
                            if TotRecDistrib = Secuencia then
                                Total := Round(ImporteDistrib - DistribAcumulado, 0.01)
                            else begin
                                Total := Round(ImporteDistrib * DistribEDEmp."% a distribuir" / 100, 0.01);
                                DistribAcumulado += Total;
                            end;

                            //Para los que son de proyectos
                            if (gDCA."Cod. Empleado" = "Cab. nómina"."No. empleado") and ("Cab. nómina"."Tipo Nomina" = "Cab. nómina"."Tipo Nomina"::Normal) then begin
                                if ("Tipo concepto" = "Tipo concepto"::Ingresos) or
                                   (("Concepto salarial" <> ConfNomina."Concepto ISR") and ("Concepto salarial" <> ConfNomina."Concepto AFP") and
                                   ("Concepto salarial" <> ConfNomina."Concepto SFS") and ("Concepto salarial" <> ConfNomina."Concepto INFOTEP")) then begin
                                    LlenaDatosCOjOB("Concepto salarial", TipoCta, NoCuenta, Total, false, "No. empleado");
                                    if ConceptosSalariales."Validar Contrapartida CO" then
                                        LlenaDatosCOjOB("Concepto salarial", TipoContrapartida, NoCuentaContrapartida, Total * -1, true,
                                                 "No. empleado");
                                end;
                            end
                            else begin
                                LlenaDatosCO("Concepto salarial", TipoCta, NoCuenta, Total, false, "No. empleado");
                                //Para los que son de proyectos
                                if ConceptosSalariales."Validar Contrapartida CO" then
                                    LlenaDatosCO("Concepto salarial", TipoContrapartida, NoCuentaContrapartida, Total * -1, true,
                                                 "No. empleado");
                            end;
                        until DistribEDEmp.Next = 0
                    else begin
                        //Para los que son de proyectos
                        if (gDCA."Cod. Empleado" = "Cab. nómina"."No. empleado") and ("Cab. nómina"."Tipo Nomina" = "Cab. nómina"."Tipo Nomina"::Normal) then begin
                            if ("Tipo concepto" = "Tipo concepto"::Ingresos) or
                               (("Concepto salarial" <> ConfNomina."Concepto ISR") and ("Concepto salarial" <> ConfNomina."Concepto AFP") and
                               ("Concepto salarial" <> ConfNomina."Concepto SFS") and ("Concepto salarial" <> ConfNomina."Concepto INFOTEP")) then begin
                                LlenaDatosCOjOB("Concepto salarial", TipoCta, NoCuenta, Total, false, "No. empleado");
                                if ConceptosSalariales."Validar Contrapartida CO" then
                                    LlenaDatosCOjOB("Concepto salarial", TipoContrapartida, NoCuentaContrapartida, Total, true,
                                             "No. empleado");
                            end;
                        end
                        else begin
                            LlenaDatosCO("Concepto salarial", TipoCta, NoCuenta, Total, false, "No. empleado");
                            //Para los que son de proyectos
                            if ConceptosSalariales."Validar Contrapartida CO" then
                                LlenaDatosCO("Concepto salarial", TipoContrapartida, NoCuentaContrapartida, Total, true,
                                             "No. empleado");
                        end;
                    end;

                    InsertaAporteCooperativa("Lín. nómina");
                    InsertaDescCooperativa("Lín. nómina");

                    Clear(NoCuenta);
                    Clear(TipoCta);
                    Clear(NoCuentaContrapartida);
                    Clear(TipoContrapartida);
                end;

                trigger OnPostDataItem()
                var
                    ProvJob: Record "Conceptos Salariales Provision";
                begin
                    if (gDCA."Cod. Empleado" = "Cab. nómina"."No. empleado") and ("Cab. nómina"."Tipo Nomina" = "Cab. nómina"."Tipo Nomina"::Normal) then begin
                        CalcularDtosCOTSSJob(Date2DMY(inicial, 3), "Cab. nómina"."No. empleado"); //Para calcular TSS
                        CalcularISRJob(Date2DMY(inicial, 3), "Cab. nómina"."No. empleado"); //Para calcular ISR
                        CalcularDtosCPTSSJob(Date2DMY(inicial, 3), "Cab. nómina"."No. empleado"); //Para calcular Cuotas Patronales
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if not HayNominas then
                        exit;

                    CxCEmpl.Reset;
                    CxCEmpl.SetCurrentKey("Employee No.", Pendiente);

                    SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
                end;
            }
            dataitem(Prorrata; "Perfil Salarial")
            {
                DataItemLink = "No. empleado" = FIELD("No. empleado");
                DataItemTableView = SORTING("No. empleado", "Perfil salarial", "Concepto salarial", Cargo) WHERE(Provisionar = CONST(true));
                dataitem("Conceptos Salariales Provision"; "Conceptos Salariales Provision")
                {
                    DataItemLink = "Código" = FIELD("Concepto salarial");
                    DataItemTableView = SORTING("Código", "Gpo. Contable Empleado");

                    trigger OnAfterGetRecord()
                    var
                        ConceptosProrr: Record "Conceptos Salariales Provision";
                        ConceptosFormula: Record "Conceptos formula";
                        PS: Record "Perfil Salarial";
                        Fecha: Record Date;
                        TempHistLinNom: Record "Historico Lin. nomina" temporary;
                        Acumulado: Decimal;
                        FechaFin: Date;
                        CantEmpl: Integer;
                        DiasVacaciones: Decimal;
                        MontoVacaciones: Decimal;
                        Diastxt: Text[30];
                        FIni: Date;
                        Acumulado2: Decimal;
                    begin
                        // IF  "Cab. nómina"."Tipo Nomina" <> "Cab. nómina"."Tipo Nomina"::Normal THEN
                        //    CurrReport.SKIP;

                        if Tiposdenominas."Tipo de nomina" <> Tiposdenominas."Tipo de nomina"::Regular then
                            CurrReport.Skip;

                        Empleado.Get("Lín. nómina"."No. empleado");
                        if GpoContable.Get(Empleado."Posting Group") then
                            if GpoContEmpl."Excluir contabilizacion" then
                                CurrReport.Skip;

                        Acumulado := 0;
                        Clear(HistLinNom);
                        HistLinNom.Reset;
                        HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                        HistLinNom.SetRange("No. empleado", "Cab. nómina"."No. empleado");
                        HistLinNom.SetRange(Período, "Cab. nómina".Período);
                        HistLinNom.SetRange("Concepto salarial", Código);
                        if "Cab. nómina".GetFilter("Job No.") <> '' then
                            HistLinNom.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
                        if HistLinNom.FindSet then
                            repeat
                                Acumulado += HistLinNom.Total;
                            until HistLinNom.Next = 0;

                        Empleado.Salario := 0;
                        Clear(HistLinNom);
                        HistLinNom.Reset;
                        HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                        HistLinNom.SetRange("No. empleado", "Cab. nómina"."No. empleado");
                        HistLinNom.SetRange(Período, "Cab. nómina".Período);
                        //HistLinNom.SETRANGE("Concepto salarial",Código);
                        if "Cab. nómina".GetFilter("Job No.") <> '' then
                            HistLinNom.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
                        HistLinNom.SetRange("Salario Base", true);
                        if HistLinNom.FindSet then
                            repeat
                                Empleado.Salario += HistLinNom.Total;
                            until HistLinNom.Next = 0
                        else
                            Empleado.CalcFields(Salario);

                        Acumulado /= 12;
                        case ConfNomina."Nomina de Pais" of
                            'BO':
                                begin
                                    if Empleado."Employment Date" = 0D then
                                        Error(Err001, Empleado.FieldCaption("Employment Date"), Empleado.TableCaption, Empleado."No.");

                                    //CalculoFechas.CalculoEntreFechas(Empleado."Employment Date", final, Anos, Meses, Dias); Nomina

                                    if ConfNomina."Concepto Incentivos" = Código then begin
                                        Empleado.Salario := 0;
                                        Acumulado2 := 0;

                                        //Se busca el acumulado de los 3 ultimos meses
                                        FIni := DMY2Date(1, Date2DMY(CalcDate('-3M', "Cab. nómina".Período), 2), Date2DMY(CalcDate('-3M', "Cab. nómina".Período), 3));
                                        Clear(HistLinNom);
                                        HistLinNom.Reset;
                                        HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                                        HistLinNom.SetRange("No. empleado", "Cab. nómina"."No. empleado");
                                        HistLinNom.SetRange(Período, FIni, CalcDate('-1D', "Cab. nómina".Período));
                                        if "Cab. nómina".GetFilter("Job No.") <> '' then
                                            HistLinNom.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
                                        HistLinNom.SetRange("Aplica para Regalia", true);
                                        //        MESSAGE('%1',HistLinNom.GETFILTERS);
                                        if HistLinNom.FindSet then
                                            repeat
                                                Empleado.Salario += HistLinNom.Total;
                                            until HistLinNom.Next = 0;

                                        //Se calculan los dias transcurridos al presente periodo y hasta el mes anterior
                                        if Empleado."Fecha despues quinquenios" <> 0D then begin
                                            DiasVacaciones := final - Empleado."Fecha despues quinquenios";
                                            Dias := CalcDate('-1D', inicial) - Empleado."Fecha despues quinquenios";
                                        end
                                        else begin
                                            DiasVacaciones := final - Empleado."Employment Date";
                                            Dias := CalcDate('-1D', inicial) - Empleado."Employment Date";
                                        end;

                                        //Salario promedio de los ultimos 3 meses
                                        Empleado.Salario /= 3;

                                        //Importe de Indemnización acumulada actual
                                        MontoVacaciones := Round((Empleado.Salario * Dias / 365), 0.01);
                                        //        error('%1\ %2\ %3\ %4\ %5',empleado.salario,diasvacaciones,montovacaciones,final,Empleado."Employment Date");
                                        //Importe de Indemnización acumulada mes anterior

                                        FIni := DMY2Date(1, Date2DMY(CalcDate('-2M', inicial), 2), Date2DMY(CalcDate('-2M', inicial), 3));
                                        Clear(HistLinNom);
                                        Clear(Empleado.Salario);
                                        HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                                        HistLinNom.SetRange("No. empleado", "Cab. nómina"."No. empleado");
                                        HistLinNom.SetRange(Período, FIni, "Cab. nómina".GetRangeMax(Período));
                                        HistLinNom.SetRange("Aplica para Regalia", true);
                                        //        message('%1',histlinnom.getfilters);
                                        if HistLinNom.FindSet then
                                            repeat
                                                Empleado.Salario += HistLinNom.Total;
                                            until HistLinNom.Next = 0;

                                        //Salario promedio de los ultimos 3 meses
                                        Empleado.Salario /= 3;

                                        Acumulado2 := Round((Empleado.Salario * DiasVacaciones / 365), 0.01);

                                        Acumulado := Round(Acumulado2 - MontoVacaciones, 0.01);
                                        //        ERROR('aa%1 %2 %3 %4',Acumulado,Acumulado2,MontoVacaciones);
                                        //message('Ind %1 %2 %3 %4 %5',acumulado,montovacaciones,acumulado2,DIAS,DIASVACACIONES);
                                    end
                                    else
                                        if ConfNomina."Concepto Regalia" = Código then begin
                                            Empleado.Salario := 0;
                                            Acumulado2 := 0;

                                            //Se busca el acumulado de los 3 ultimos meses
                                            FIni := DMY2Date(1, Date2DMY(CalcDate('-3M', "Cab. nómina".Período), 2), Date2DMY(CalcDate('-3M', "Cab. nómina".Período), 3));
                                            Clear(HistLinNom);
                                            HistLinNom.Reset;
                                            HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                                            HistLinNom.SetRange("No. empleado", "Cab. nómina"."No. empleado");
                                            HistLinNom.SetRange(Período, FIni, CalcDate('-1D', "Cab. nómina".Período));
                                            HistLinNom.SetRange("Aplica para Regalia", true);
                                            if HistLinNom.FindSet then
                                                repeat
                                                    Empleado.Salario += HistLinNom.Total;
                                                until HistLinNom.Next = 0;

                                            //Se calculan los dias transcurridos al presente periodo y hasta el mes anterior

                                            if Anos <> 0 then begin
                                                DiasVacaciones := final - DMY2Date(1, 1, Date2DMY(final, 3));
                                                Dias := CalcDate('-1D', inicial) - DMY2Date(1, 1, Date2DMY(final, 3));
                                            end
                                            else begin
                                                DiasVacaciones := final - DMY2Date(1, Date2DMY(Empleado."Employment Date", 2), Date2DMY(Empleado."Employment Date", 3));
                                                Dias := CalcDate('-1D', inicial) - DMY2Date(1, Date2DMY(Empleado."Employment Date", 2),
                                                                  Date2DMY(Empleado."Employment Date", 3));
                                            end;

                                            //Salario promedio de los ultimos 3 meses
                                            Empleado.Salario /= 3;

                                            //Importe de regalia acumulada actual
                                            MontoVacaciones := Round((Empleado.Salario * Dias / 365), 0.01);

                                            //Importe de regalia acumulada mes anterior

                                            FIni := DMY2Date(1, Date2DMY(CalcDate('-2M', "Cab. nómina".Período), 2),
                                                              Date2DMY(CalcDate('-2M', "Cab. nómina".Período), 3));

                                            Clear(HistLinNom);
                                            Clear(Empleado.Salario);
                                            HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                                            HistLinNom.SetRange("No. empleado", "Cab. nómina"."No. empleado");
                                            HistLinNom.SetRange(Período, FIni, "Cab. nómina".GetRangeMax(Período));
                                            HistLinNom.SetRange("Aplica para Regalia", true);
                                            if HistLinNom.FindSet then
                                                repeat
                                                    Empleado.Salario += HistLinNom.Total;
                                                until HistLinNom.Next = 0;

                                            //Salario promedio de los ultimos 3 meses
                                            Empleado.Salario /= 3;
                                            Acumulado2 := Round((Empleado.Salario * DiasVacaciones / 365), 0.01);

                                            Acumulado := Round(Acumulado2 - MontoVacaciones, 0.01);

                                            //        ERROR('bb %1 %2 %3 %4 %5',Acumulado,MontoVacaciones,Acumulado2,Dias,DiasVacaciones);
                                            //        message('reg %1 %2 %3 %4 %5',acumulado,montovacaciones,acumulado2,DIAS,DIASVACACIONES);
                                        end;
                                end;
                            'DO':
                                begin
                                    case "Tipo provision" of
                                        0: //Variable
                                            begin
                                                if ConfNomina."Concepto Vacaciones" = Código then begin
                                                    Acumulado := ProvisionaVacaciones;
                                                end
                                                else
                                                    if ConfNomina."Concepto Regalia" = Código then begin
                                                        Acumulado := ProvisionaRegalia;
                                                    end
                                                    else
                                                        if ConfNomina."Concepto Bonificacion" = Código then begin
                                                            Acumulado := ProvisionaBonificacion;
                                                        end
                                            end;
                                        1://Fijo
                                            begin
                                            end;
                                        2: //Formula
                                            begin
                                                /*
                                               PS.RESET;
                                               PS.SETRANGE("No. empleado",Empleado."No.");
                                               PS.SETRANGE("Concepto salarial",Código);
                                               PS.FINDFIRST;
                                               PS.VALIDATE("Fórmula cálculo","Fórmula cálculo");
                                               Acumulado         := PS.Importe;
                                               */
                                                ConceptosFormula.Find('-');
                                                ConceptosFormula.DeleteAll;
                                                TempHistLinNom.Reset;
                                                TempHistLinNom.Validate("No. empleado", Empleado."No.");
                                                TempHistLinNom.Validate("Concepto salarial", Código);
                                                TempHistLinNom.Validate(Período, inicial);
                                                TempHistLinNom.Validate(Fórmula, "Fórmula cálculo");

                                                Acumulado := TempHistLinNom.Total;
                                                /*
                                                IF DiasTranscurridos < 25 THEN
                                                  BEGIN
                                                    IF (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) OR
                                                       (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") THEN
                                                        Acumulado /= 2
                                                  END;
                                                 */
                                            end;
                                    end;
                                end;
                            'GT':
                                begin
                                    case "Tipo provision" of
                                        0:
                                            ; //Variable
                                        1:
                                            ; //Fijo
                                        2: //Fórmula
                                            begin
                                                PS.Reset;
                                                PS.SetRange("No. empleado", Empleado."No.");
                                                PS.SetRange("Concepto salarial", Código);
                                                PS.FindFirst;
                                                PS.Validate("Formula calculo", "Fórmula cálculo");
                                                Acumulado := PS.Importe;
                                            end;
                                    end;
                                end;
                            'EC':
                                begin
                                    case "Tipo provision" of
                                        0: //Variable
                                            begin
                                                PS.Reset;
                                                PS.SetRange("No. empleado", Empleado."No.");
                                                PS.SetRange("Concepto salarial", Código);
                                                PS.FindFirst;

                                                if Empleado."Fin contrato" <> 0D then begin
                                                    if (((Date2DMY(Empleado."Employment Date", 2) = Date2DMY(FechaRegistro, 2)) and
                                                         (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(FechaRegistro, 3)))) and
                                                       (((Date2DMY(Empleado."Fin contrato", 2) = Date2DMY(FechaRegistro, 2)) and
                                                         (Date2DMY(Empleado."Fin contrato", 3) = Date2DMY(FechaRegistro, 3)))) then begin
                                                        //CalculoFechas.CalculoEntreFechas(Empleado."Employment Date", Empleado."Fin contrato", Anos, Meses, Dias); //Nomina
                                                    end
                                                    else
                                                        if (((Date2DMY(Empleado."Fin contrato", 2) = Date2DMY(FechaRegistro, 2)) and
                                                             (Date2DMY(Empleado."Fin contrato", 3) = Date2DMY(FechaRegistro, 3)))) and
                                                             (Empleado."Fin contrato" <> 0D) then begin
                                                            Dias := Date2DMY(Empleado."Fin contrato", 1);
                                                            if Date2DMY(FechaRegistro, 2) = 2 then
                                                                Dias := 30 - Dias;
                                                        end;
                                                end
                                                else
                                                    if (((Date2DMY(Empleado."Employment Date", 2) = Date2DMY(FechaRegistro, 2)) and
                                                         (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(FechaRegistro, 3)) and
                                                         (Empleado."Fin contrato" = 0D))) then begin
                                                        Dias := Date2DMY(Empleado."Employment Date", 1);
                                                        if Date2DMY(FechaRegistro, 2) = 2 then
                                                            Dias := 30 - Dias;
                                                        if (Dias > 30) or (Dias = 0) then
                                                            Dias := 30;
                                                    end;
                                                /*else Nomina
                                                    CalculoFechas.CalculoEntreFechas(Empleado."Employment Date", final, Anos, Meses, Dias);*/
                                                if (Anos >= 1) or (Meses >= 1) then
                                                    Dias := 30;
                                                //         message('%1 %2 %3 %4',empleado."no.",dias,meses,anos);
                                                PS.Importe := ConfNomina."Salario Minimo" / 360;
                                                PS.Importe *= Dias;
                                                Acumulado := Round(PS.Importe, ConfContabilidad."Amount Rounding Precision");
                                            end;

                                        1: //Fijo
                                            begin
                                                PS.Reset;
                                                PS.SetRange("No. empleado", Empleado."No.");
                                                PS.SetRange("Concepto salarial", Código);
                                                PS.FindFirst;
                                                if Empleado."Fin contrato" <> 0D then begin
                                                    if (((Date2DMY(Empleado."Employment Date", 2) = Date2DMY(FechaRegistro, 2)) and
                                                         (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(FechaRegistro, 3)))) and
                                                       (((Date2DMY(Empleado."Fin contrato", 2) = Date2DMY(FechaRegistro, 2)) and
                                                         (Date2DMY(Empleado."Fin contrato", 3) = Date2DMY(FechaRegistro, 3)))) then begin
                                                        //CalculoFechas.CalculoEntreFechas(Empleado."Employment Date", Empleado."Fin contrato", Anos, Meses, Dias); Nomina
                                                        Evaluate(PS.Importe, "Fórmula cálculo");
                                                        Acumulado := Round((PS.Importe / 30) * Dias, ConfContabilidad."Amount Rounding Precision");
                                                    end
                                                    else
                                                        if (((Date2DMY(Empleado."Fin contrato", 2) = Date2DMY(FechaRegistro, 2)) and
                                                             (Date2DMY(Empleado."Fin contrato", 3) = Date2DMY(FechaRegistro, 3)))) and
                                                             (Empleado."Fin contrato" <> 0D) then begin
                                                            Dias := Date2DMY(Empleado."Fin contrato", 1);
                                                            if Date2DMY(FechaRegistro, 2) = 2 then
                                                                Dias := 30 - Dias + 1;

                                                            Evaluate(PS.Importe, "Fórmula cálculo");
                                                            Acumulado := Round((PS.Importe / 30) * Dias, ConfContabilidad."Amount Rounding Precision");
                                                        end;
                                                end
                                                else
                                                    if (((Date2DMY(Empleado."Employment Date", 2) = Date2DMY(FechaRegistro, 2)) and
                                                         (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(FechaRegistro, 3)) and
                                                         (Empleado."Fin contrato" = 0D))) then begin
                                                        Dias := Date2DMY(Empleado."Employment Date", 1);
                                                        //             IF DATE2DMY(FechaRegistro,2) = 2 THEN
                                                        Dias := 30 - Dias + 1;

                                                        Evaluate(PS.Importe, "Fórmula cálculo");
                                                        Acumulado := Round((PS.Importe / 30) * Dias, ConfContabilidad."Amount Rounding Precision");
                                                    end
                                                    else begin
                                                        Evaluate(Acumulado, "Fórmula cálculo");
                                                    end;
                                                //            message('%1 %2 %3 %4 %5',dias,Empleado."Employment Date",fecharegistro);
                                            end;
                                        2: //Fórmula
                                            begin
                                                PS.Reset;
                                                PS.SetRange("No. empleado", Empleado."No.");
                                                PS.SetRange("Concepto salarial", Código);
                                                PS.FindFirst;
                                                PS.Validate("Formula calculo", "Fórmula cálculo");
                                                Acumulado := PS.Importe;
                                            end;
                                    end;
                                end;
                            'PY':
                                begin
                                    case "Tipo provision" of
                                        0:
                                            ; //Variable
                                        1:
                                            ; //Fijo
                                        2: //Fórmula
                                            begin
                                                PS.Reset;
                                                PS.SetRange("No. empleado", Empleado."No.");
                                                PS.SetRange("Concepto salarial", Código);
                                                PS.FindFirst;
                                                PS.Validate("Formula calculo", "Fórmula cálculo");
                                                Acumulado := PS.Importe;
                                            end;
                                    end;
                                end;
                            'HN':
                                begin
                                    case "Tipo provision" of
                                        0:
                                            ; //Variable
                                        1:
                                            ; //Fijo
                                        2: //Fórmula
                                            begin
                                                PS.Reset;
                                                PS.SetRange("No. empleado", Empleado."No.");
                                                PS.SetRange("Concepto salarial", Código);
                                                PS.FindFirst;
                                                PS.Validate("Formula calculo", "Fórmula cálculo");
                                                Acumulado := PS.Importe;
                                            end;
                                    end;
                                end;
                            'PR':
                                begin
                                    case "Tipo provision" of
                                        0: //Variable
                                            begin
                                                if Empleado."Employment Date" = 0D then
                                                    Error(Err001, Empleado.FieldCaption("Employment Date"), Empleado.TableCaption, Empleado."No.");

                                                /*DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.", Date2DMY(Empleado."Employment Date", 2), Nomina
                                                                                                     Date2DMY(WorkDate, 3), MontoVacaciones, Empleado."Employment Date", final);*/
                                                Empleado.Salario /= 23.83;
                                                MontoVacaciones := (Empleado.Salario * DiasVacaciones) / 12;
                                                Acumulado := MontoVacaciones;

                                            end;
                                        1:
                                            ; //Fijo
                                        2: //Fórmula
                                            begin
                                                PS.Reset;
                                                PS.SetRange("No. empleado", Empleado."No.");
                                                PS.SetRange("Concepto salarial", Código);
                                                PS.FindFirst;
                                                PS.Validate("Formula calculo", "Fórmula cálculo");
                                                Acumulado := PS.Importe;
                                            end;
                                    end;

                                end;
                        end;

                        if Acumulado <> 0 then begin
                            if (gDCA."Cod. Empleado" = "Cab. nómina"."No. empleado") and ("Cab. nómina"."Tipo Nomina" = "Cab. nómina"."Tipo Nomina"::Normal) then
                                InsertaProvisionJob(Código, Acumulado)
                            else
                                InsertaProvision(Código, Acumulado);
                        end;

                    end;

                    trigger OnPreDataItem()
                    begin
                        // IF  "Cab. nómina"."Tipo Nomina" <> "Cab. nómina"."Tipo Nomina"::Normal THEN
                        //    CurrReport.SKIP;

                        if Tiposdenominas."Tipo de nomina" <> Tiposdenominas."Tipo de nomina"::Regular then
                            CurrReport.Skip;

                        "Conceptos Salariales Provision".SetRange(Código, Prorrata."Concepto salarial");
                        if Empleado."Posting Group" <> '' then
                            "Conceptos Salariales Provision".SetRange("Gpo. Contable Empleado", Empleado."Posting Group");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    Prorrata.SetRange("No. empleado", "Cab. nómina"."No. empleado");
                    Prorrata.SetRange(Provisionar, true);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not "Repetir Contabiliz." then
                    if "No. Contabilización" <> '' then begin
                        HayNominas := false;
                        exit;
                    end;

                Contador := Contador + 1;
                Ventana.Update(1, Round(Contador / AModificar * 10000, 1));

                Empleado.Get("No. empleado");
                Empresa.Get(Empleado.Company);

                if NumDoc = '' then
                    NumDoc := GestNumSerie.GetNextNo(ConfNomina."No. serie nominas", final, true);

                "No. Contabilización" := NumDoc;
                Modify();
                HayNominas := true;

                Contrato.Reset;
                Contrato.SetRange("No. empleado", Empleado."No.");
                Contrato.FindLast;

                gDCA.Reset;
                gDCA.SetRange("Cod. Empleado", "No. empleado");
                if GetFilter("Job No.") <> '' then
                    gDCA.SetFilter("Job No.", GetFilter("Job No."));
                if not gDCA.FindFirst then
                    gDCA.Init;
            end;

            trigger OnPreDataItem()
            begin
                if FechaRegistro = 0D then
                    Error('Debe entrar fecha de registro');

                if CodSección = '' then
                    Error('Favor de introducir la sección del diario');
                /*
                IF NOT "Repetir Contabiliz." THEN
                  "Cab. nómina".SETRANGE("No. Contabilización",'');
                */
                AModificar := Count;

                Ventana.Open(Text003);

                Contador := 0;
                Contador2 := 0;
                NoLinea := 0;

                ConfNomina.Get();
                Tiposdenominas.Get("Cab. nómina".GetRangeMin("Tipo de nomina"));

            end;
        }
        dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo de nomina");
            dataitem("Lin. Aportes Empresas"; "Lin. Aportes Empresas")
            {
                DataItemLink = "No. Empleado" = FIELD("No. empleado"), "Período" = FIELD("Período"), "Tipo de nomina" = FIELD("Tipo de nomina");
                DataItemTableView = SORTING("No. Documento", "No. Empleado", "No. orden");

                trigger OnAfterGetRecord()
                var
                    NoCuenta: Code[20];
                begin
                    if not HayNominas then
                        exit;

                    Empleado.Get("No. Empleado");

                    ConceptosSalariales.Get("Concepto Salarial");

                    //Del Histórico de Cuota Patronal
                    if GpoContEmpl.Get(Empleado."Posting Group") then begin
                        //    ConfGpoContEmpl.SETRANGE("Shortcut Dimension",ConfNomina."Dimension Conceptos Salariales");
                        ConfGpoContEmpl.Reset;
                        ConfGpoContEmpl.SetRange(Código, GpoContEmpl.Código);
                        ConfGpoContEmpl.SetRange("Código Concepto Salarial", "Concepto Salarial");
                        if ConfGpoContEmpl.FindFirst then begin
                            ConfGpoContEmpl.TestField("No. Cuenta Cuota Patronal");
                            NoCuenta := ConfGpoContEmpl."No. Cuenta Cuota Patronal";
                            case ConfGpoContEmpl."Tipo Cuenta Cuota Patronal" of
                                0:
                                    TipoCta := 0;
                                else
                                    TipoCta := 2;
                            end;

                            if ConceptosSalariales."Validar Contrapartida CP" then begin
                                ConfGpoContEmpl.TestField("No. Cuenta Contrapartida CP");
                                case ConfGpoContEmpl."Tipo Cuenta Contrapartida CP" of
                                    0:
                                        TipoContrapartida := 0;
                                    else
                                        TipoContrapartida := 2;
                                end;

                                NoCuentaContrapartida := ConfGpoContEmpl."No. Cuenta Contrapartida CP";
                            end;
                        end
                        else begin
                            case ConceptosSalariales."Tipo Cuenta Cuota Patronal" of
                                0:
                                    TipoCta := 0;
                                else
                                    TipoCta := 2;
                            end;
                            ConceptosSalariales.TestField("No. Cuenta Cuota Patronal");
                            NoCuenta := ConceptosSalariales."No. Cuenta Cuota Patronal";
                            if ConceptosSalariales."Validar Contrapartida CP" then begin
                                ConceptosSalariales.TestField("No. Cuenta Contrapartida CP");
                                case ConceptosSalariales."Tipo Cuenta Contrapartida CP" of
                                    0:
                                        TipoContrapartida := 0;
                                    else
                                        TipoContrapartida := 2;
                                end;

                                NoCuentaContrapartida := ConceptosSalariales."No. Cuenta Contrapartida CP";
                            end;
                        end;
                    end
                    else begin
                        case ConceptosSalariales."Tipo Cuenta Cuota Patronal" of
                            0:
                                TipoCta := 0;
                            else
                                TipoCta := 2;
                        end;
                        ConceptosSalariales.TestField("No. Cuenta Cuota Patronal");
                        NoCuenta := ConceptosSalariales."No. Cuenta Cuota Patronal";
                        if ConceptosSalariales."Validar Contrapartida CP" then begin
                            ConceptosSalariales.TestField("No. Cuenta Contrapartida CP");
                            case ConceptosSalariales."Tipo Cuenta Contrapartida CP" of
                                0:
                                    TipoContrapartida := 0;
                                else
                                    TipoContrapartida := 2;
                            end;

                            NoCuentaContrapartida := ConceptosSalariales."No. Cuenta Contrapartida CP";
                        end;
                    end;

                    //MESSAGE('%1 %2 %3 %$ %5',"Concepto Salarial",NoCuenta,NoCuentaContrapartida,Importe);
                    if (gDCA."Cod. Empleado" <> "Cab. nómina"."No. empleado") and ("Historico Cab. nomina"."Tipo Nomina" = "Historico Cab. nomina"."Tipo Nomina"::Normal) then begin

                        LlenaDatosCp("Concepto Salarial", TipoCta, NoCuenta, Importe, false, "No. Empleado");
                        if ConceptosSalariales."Validar Contrapartida CP" then
                            LlenaDatosCp("Concepto Salarial", TipoContrapartida, NoCuentaContrapartida, Importe, true, "No. Empleado");
                    end;

                    Clear(NoCuenta);
                    Clear(TipoCta);
                    Clear(NoCuentaContrapartida);
                    Clear(TipoContrapartida);
                end;

                trigger OnPreDataItem()
                begin
                    if not HayNominas then
                        exit;
                    //MESSAGE('Paso1 %1 bb%2 cc%3 dd%4',HayNominas,GETFILTERS,"Cab. nómina".getfilters);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Contador2 := Contador2 + 1;
                Ventana.Update(2, Round(Contador2 / NumRecords * 10000, 1));

                tmpContab.DeleteAll;
            end;

            trigger OnPostDataItem()
            begin
                HayNominas := false;
            end;

            trigger OnPreDataItem()
            begin
                CopyFilters("Cab. nómina");
                NumRecords := Count;
            end;
        }
        dataitem("Temp Contabilizacion Nom."; "Temp Contabilizacion Nom.")
        {
            DataItemTableView = SORTING(Step, "No. Cuenta", "Cod. Empleado", "Valor Dim 1", "Valor Dim 2", "Valor Dim 3", "Valor Dim 4", "Valor Dim 5", "Valor Dim 6", "No. Linea", "Forma de Cobro") WHERE(Step = CONST(1));

            trigger OnAfterGetRecord()
            begin
                if "Forma de Cobro" <> "Forma de Cobro"::"Transferencia Banc." then begin
                    TotalDbCk += "Importe Db CK";
                    TotalCrCk += "Importe Cr CK";
                end
                else begin
                    TotalDb += "Importe Db";
                    TotalCr += "Importe Cr";
                end;

                "Cab. nómina".Reset;
                "Cab. nómina".SetRange("No. empleado", "Cod. Empleado");
                "Cab. nómina".FindLast;

                InsertaLinDiario("Temp Contabilizacion Nom.");
            end;

            trigger OnPostDataItem()
            begin
                "Importe Db" := TotalDb;
                "Importe Cr" := TotalCr;
                "Importe Db CK" := TotalDbCk;
                "Importe Cr CK" := TotalCrCk;

                InsertaContrapartidaCO("Temp Contabilizacion Nom.");
            end;

            trigger OnPreDataItem()
            begin
                NoLinea := 0;
                //COMMIT;
                //CurrReport.BREAK;

                TotalDb := 0;
                TotalCr := 0;
                TotalDbCk := 0;
                TotalCrCk := 0;
            end;
        }
        dataitem(TempContabNom; "Temp Contabilizacion Nom.")
        {
            DataItemTableView = SORTING(Step, "No. Cuenta", "Cod. Empleado", "Valor Dim 1", "Valor Dim 2", "Valor Dim 3", "Valor Dim 4", "Valor Dim 5", "Valor Dim 6", "No. Linea", "Forma de Cobro") WHERE(Step = CONST(2));

            trigger OnAfterGetRecord()
            begin
                TotalDb += "Importe Db";
                TotalCr += "Importe Cr";

                "Cab. nómina".Reset;
                "Cab. nómina".SetRange("No. empleado", "Cod. Empleado");
                "Cab. nómina".FindLast;

                InsertaLinDiario(TempContabNom);
            end;

            trigger OnPostDataItem()
            begin
                "Importe Db" := TotalDb;
                "Importe Cr" := TotalCr;
                "Importe Db CK" := TotalDbCk;
                "Importe Cr CK" := TotalCrCk;

                InsertaContrapartidaCP(TempContabNom);
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.BREAK;
                TotalDb := 0;
                TotalCr := 0;
                TotalCrCk := 0;
                TotalDbCk := 0;
            end;
        }
        dataitem("Temp Contabilizacion Job"; "Temp Contabilizacion Nom.")
        {
            DataItemTableView = SORTING(Step, "No. Cuenta", "Cod. Empleado", "Valor Dim 1", "Valor Dim 2", "Valor Dim 3", "Valor Dim 4", "Valor Dim 5", "Valor Dim 6", "No. Linea", "Forma de Cobro") WHERE(Step = CONST(3));

            trigger OnAfterGetRecord()
            begin
                TotalDb += "Importe Db";
                TotalCr += "Importe Cr";
                TotalDbCk += "Importe Db CK";
                TotalCrCk += "Importe Cr CK";

                "Cab. nómina".Reset;
                "Cab. nómina".SetRange("No. empleado", "Cod. Empleado");
                "Cab. nómina".FindLast;

                insertalindiariojOB("Temp Contabilizacion Job");
            end;

            trigger OnPostDataItem()
            begin
                "Importe Db" := TotalDb;
                "Importe Cr" := TotalCr;
                "Importe Db CK" := TotalDbCk;
                "Importe Cr CK" := TotalCrCk;

                InsertaContrapartidaCOJob("Temp Contabilizacion Job");
            end;

            trigger OnPreDataItem()
            begin
                NoLinea := 0;
                //COMMIT;
                //CurrReport.BREAK;

                TotalDb := 0;
                TotalCr := 0;
                TotalDbCk := 0;
                TotalCrCk := 0;
            end;
        }
        dataitem(TempContabJob; "Temp Contabilizacion Nom.")
        {
            DataItemTableView = SORTING(Step, "No. Cuenta", "Cod. Empleado", "Valor Dim 1", "Valor Dim 2", "Valor Dim 3", "Valor Dim 4", "Valor Dim 5", "Valor Dim 6", "No. Linea", "Forma de Cobro") WHERE(Step = CONST(4));

            trigger OnAfterGetRecord()
            begin
                TotalDb += "Importe Db";
                TotalCr += "Importe Cr";
                TotalDbCk += "Importe Db CK";
                TotalCrCk += "Importe Cr CK";

                "Cab. nómina".Reset;
                "Cab. nómina".SetRange("No. empleado", "Cod. Empleado");
                "Cab. nómina".FindLast;

                insertalindiariojOB(TempContabJob);
            end;

            trigger OnPostDataItem()
            begin
                "Importe Db" := TotalDb;
                "Importe Cr" := TotalCr;
                "Importe Db CK" := TotalDbCk;
                "Importe Cr CK" := TotalCrCk;

                InsertaContrapartidaCPJob(TempContabJob);
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.BREAK;
                TotalDb := 0;
                TotalCr := 0;
                TotalDbCk := 0;
                TotalCrCk := 0;
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
                field("Libro Diario"; "Repetir Contabiliz.")
                {
                ApplicationArea = All;
                    Caption = 'Repeat Journal Post';
                }
                field("CodSección"; CodSección)
                {
                ApplicationArea = All;
                    Caption = 'Batch Journal name';

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        ConfNomina.Get();
                        Seccion.SetRange(Seccion."Journal Template Name", ConfNomina."Journal Template Name");
                        if PAGE.RunModal(PAGE::"General Journal Batches", Seccion) = ACTION::LookupOK then
                            CodSección := Seccion.Name
                        else
                            CodSección := '';
                    end;
                }
                field(FechaRegistro; FechaRegistro)
                {
                ApplicationArea = All;
                    Caption = 'Posting Date';
                }
                field(CodDivisa; CodDivisa)
                {
                ApplicationArea = All;
                    Caption = 'Currency code';
                    TableRelation = Currency;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin

            ConfNomina.Get();
            Seccion.SetRange(Seccion."Journal Template Name", ConfNomina."Journal Template Name");
            CodSección := ConfNomina."Journal Batch Name";
            FechaRegistro := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        "Repetir Contabiliz." := false;
        Divisa.InitRoundingPrecision;

        DC.SetCurrentKey(DC.Orden);
        DC.Find('-');
        repeat
            Indice += 1;
            CodDim[Indice] := DC."Cod. Dimension";
        until DC.Next = 0;
    end;

    trigger OnPostReport()
    begin
        Ventana.Close;
        //CalculoFechas.InicializaConceptosSalariales;
        Message(Text002);
    end;

    trigger OnPreReport()
    var
        AA: Integer;
        MM: Integer;
    begin
        ConfContabilidad.Get();
        ConfNomina.Get();

        inicial := "Cab. nómina".GetRangeMin(Período);
        final := "Cab. nómina".GetRangeMax(Período);

        if inicial = final then
            Error(Err003);

        //CalculoFechas.CalculoEntreFechas(inicial, final, AA, MM, DiasTranscurridos); Nomina

        LibrosDiarios.Get(ConfNomina."Journal Template Name");

        //Verifico si existe una linea
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", ConfNomina."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", CodSección);
        if (GenJnlLine.FindSet) and (GenJnlLine.Count < 3) then
            GenJnlLine.DeleteAll;
        ;

        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", ConfNomina."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", CodSección);
        if GenJnlLine.FindLast then
            NoLinea := GenJnlLine."Line No.";

        if ContabNom.Find('-') then
            ContabNom.DeleteAll;

        if TempContabNom.Find('-') then
            TempContabNom.DeleteAll;

        if "Temp Contabilizacion Job".Find('-') then
            "Temp Contabilizacion Job".DeleteAll;

        if TempContabJob.Find('-') then
            TempContabJob.DeleteAll;
    end;

    var
        ConfContab: Record "General Ledger Setup";
        ConfNomina: Record "Configuracion nominas";
        LibrosDiarios: Record "Gen. Journal Template";
        Empleado: Record Employee;
        Empresa: Record "Empresas Cotizacion";
        CxCEmpl: Record "Histórico Cab. Préstamo";
        Seccion: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GpoContEmpl: Record "Grupos Contables Empleados";
        ConfContabilidad: Record "General Ledger Setup";
        ConfGpoContEmpl: Record "Dist. Ctas. Gpo. Cont. Empl.";
        ConfCodOrigen: Record "Source Code Setup";
        DC: Record "Dimensiones Contabilizacion";
        recDimSet: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        Contrato: Record Contratos;
        ConceptosSalariales: Record "Conceptos salariales";
        Divisa: Record Currency;
        GpoContable: Record "Grupos Contables Empleados";
        DefDim: Record "Default Dimension";
        TiposCotizacion: Record "Tipos de Cotización";
        JobJNL: Record "Gen. Journal Line";
        DCA: Record "Distrib. Control de asis. Proy";
        gDCA: Record "Distrib. Control de asis. Proy";
        recTmpDimEntry: Record "Dimension Set Entry" temporary;
        PerfilSal: Record "Perfil Salarial";
        tmpContab: Record "Temp Contabilizacion Nom." temporary;
        ContabNom: Record "Temp Contabilizacion Nom.";
        HistLinNom: Record "Historico Lin. nomina";
        Tiposdenominas: Record "Tipos de nominas";
        DistribEDEmp: Record "Distribucion ED empleados";
        cduDim: Codeunit DimensionManagement;
        GestNumSerie: Codeunit "No. Series";
        //CalculoFechas: Codeunit "Funciones Nomina"; Nomina
        CodOrigen: Code[20];
        inicial: Date;
        final: Date;
        "Repetir Contabiliz.": Boolean;
        i: Integer;
        concepto: array[10, 15] of Decimal;
        NumDoc: Code[20];
        HayNominas: Boolean;
        NoCuentaContrapartida: Code[20];
        "CodSección": Code[20];
        TipoContrapartida: Integer;
        FechaRegistro: Date;
        Ventana: Dialog;
        AModificar: Decimal;
        Contador: Decimal;
        Text001: Label 'Net to income';
        Text002: Label 'Posting finished';
        Text003: Label 'Processing Employee Quote  @1@@@@@@@@@@@@@ \Processing Employer Quote  @2@@@@@@@@@@@@@';
        Text007: Label 'Copy Dimensions';
        Contador2: Decimal;
        TipoCta: Integer;
        CxCMod: Boolean;
        NoLinea: Integer;
        NumLin: Integer;
        RangoLinea: Integer;
        Err001: Label 'Configure %1 to %2 %3';
        NoEmpl: Code[20];
        NoLin: Integer;
        CodDim: array[6] of Code[20];
        Indice: Integer;
        NumRecords: Integer;
        Err002: Label 'Missing Account No.';
        TotalDb: Decimal;
        TotalCr: Decimal;
        TotalDbCk: Decimal;
        TotalCrCk: Decimal;
        DiasTranscurridos: Integer;
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        Err003: Label 'Specify a range of dates in the period filter';
        PrimeraQ: Boolean;
        SegundaQ: Boolean;
        CodDivisa: Code[20];


    procedure LlenaDatosCO(cConceptoSal: Code[20]; iTipoCuenta: Integer; cCodCuenta: Code[20]; dImporte: Decimal; Contrapartida: Boolean; CodEmpleado: Code[20])
    var
        DimExiste: Boolean;
    begin
        //LlenadatosCO
        Clear(ContabNom);
        ContabNom.SetRange(Step, 1);
        ContabNom.SetRange("Tipo Cuenta", iTipoCuenta);
        ContabNom.SetRange("No. Cuenta", cCodCuenta);
        ContabNom.SetRange("Forma de Cobro", "Cab. nómina"."Forma de Cobro");

        recDimSet.Reset;
        recDimSet.SetFilter("Dimension Set ID", '%1|%2', "Cab. nómina"."Dimension Set ID", "Lín. nómina"."Dimension Set ID");
        if recDimSet.FindSet() then
            repeat
                DimExiste := false;
                if ConceptosSalariales."Contabilizacion x Dimension" then begin
                    if recDimSet."Dimension Code" = CodDim[1] then begin
                        // contabnom.SETRANGE("Cod. Dim 1",recDimSet."Dimension Code");
                        if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[1]) then begin
                            ContabNom.SetRange("Valor Dim 1", DistribEDEmp.Codigo);
                            DimExiste := true;
                        end
                        else begin
                            ContabNom.SetRange("Valor Dim 1", recDimSet."Dimension Value Code");
                            if (ConceptosSalariales.Provisionar) and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                                ContabNom.SetRange("Valor Dim 1", cConceptoSal);
                        end;
                    end;

                    if recDimSet."Dimension Code" = CodDim[2] then begin
                        //  contabnom.SETRANGE("Cod. Dim 2",recDimSet."Dimension Code");
                        if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[2]) then begin
                            ContabNom.SetRange("Valor Dim 2", DistribEDEmp.Codigo);
                            DimExiste := true;
                        end
                        else begin
                            ContabNom.SetRange("Valor Dim 2", recDimSet."Dimension Value Code");
                            if (ConceptosSalariales.Provisionar) and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                                ContabNom.SetRange("Valor Dim 2", cConceptoSal);
                        end;
                    end;

                    if recDimSet."Dimension Code" = CodDim[3] then begin
                        //  contabnom.SETRANGE("Cod. Dim 3",recDimSet."Dimension Code");
                        if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[3]) then begin
                            ContabNom.SetRange("Valor Dim 3", DistribEDEmp.Codigo);
                            DimExiste := true;
                        end
                        else begin
                            ContabNom.SetRange("Valor Dim 3", recDimSet."Dimension Value Code");
                            if (ConceptosSalariales.Provisionar) and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                                ContabNom.SetRange("Valor Dim 3", cConceptoSal);
                        end;
                    end;

                    if recDimSet."Dimension Code" = CodDim[4] then begin
                        // contabnom.SETRANGE("Cod. Dim 4",recDimSet."Dimension Code");
                        if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[4]) then begin
                            ContabNom.SetRange("Valor Dim 4", DistribEDEmp.Codigo);
                            DimExiste := true;
                        end
                        else begin
                            ContabNom.SetRange("Valor Dim 4", recDimSet."Dimension Value Code");
                            if (ConceptosSalariales.Provisionar) and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                                ContabNom.SetRange("Valor Dim 4", cConceptoSal);
                        end;
                    end;

                    if recDimSet."Dimension Code" = CodDim[5] then begin
                        //  contabnom.SETRANGE("Cod. Dim 5",recDimSet."Dimension Code");
                        if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[5]) then begin
                            ContabNom.SetRange("Valor Dim 5", DistribEDEmp.Codigo);
                            DimExiste := true;
                        end
                        else begin
                            ContabNom.SetRange("Valor Dim 5", recDimSet."Dimension Value Code");
                            if (ConceptosSalariales.Provisionar) and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                                ContabNom.SetRange("Valor Dim 5", cConceptoSal);
                        end;
                    end;

                    if recDimSet."Dimension Code" = CodDim[6] then begin
                        // contabnom.SETRANGE("Cod. Dim 6",recDimSet."Dimension Code");
                        if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[6]) then begin
                            ContabNom.SetRange("Valor Dim 6", DistribEDEmp.Codigo);
                            DimExiste := true;
                        end
                        else begin
                            ContabNom.SetRange("Valor Dim 6", recDimSet."Dimension Value Code");
                            if (ConceptosSalariales.Provisionar) and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                                ContabNom.SetRange("Valor Dim 6", cConceptoSal);
                        end;
                    end;

                    if (not DimExiste) and (DistribEDEmp."Dimension Code" <> '') then
                        ContabNom.SetRange("Valor Dim 6", DistribEDEmp.Codigo);
                end;
            until recDimSet.Next = 0;

        if not ConceptosSalariales."Contabilizacion Resumida" then
            ContabNom.SetRange("Cod. Empleado", CodEmpleado);

        if ContabNom.FindFirst then begin
            if not Contrapartida then begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" += dImporte
                    else
                        ContabNom."Importe Cr CK" += Abs(dImporte);
                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" += dImporte
                    else
                        ContabNom."Importe Cr" += Abs(dImporte);
                end;
            end
            else begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte < 0 then
                        ContabNom."Importe Cr CK" += Abs(dImporte)
                    else
                        ContabNom."Importe Db CK" += dImporte;
                end
                else begin
                    if dImporte < 0 then
                        ContabNom."Importe Cr" += Abs(dImporte)
                    else
                        ContabNom."Importe Db" += dImporte;
                end;
            end;
        end
        else begin
            NoLin += 100;

            Clear(ContabNom);
            ContabNom."Tipo Cuenta" := iTipoCuenta;
            ContabNom."No. Cuenta" := cCodCuenta;
            ContabNom."No. Linea" := NoLin;
            ContabNom."Cod. Empleado" := CodEmpleado;
            ContabNom.Contrapartida := Contrapartida;
            ContabNom.Step := 1;

            if not ConceptosSalariales."Contabilizacion Resumida" then
                ContabNom.Descripcion := CopyStr(Empleado."No." + ' ' + Empleado."Full Name", 1, 50)
            else
                ContabNom.Descripcion := ConceptosSalariales.Descripcion;

            if not Contrapartida then begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" := dImporte
                    else
                        ContabNom."Importe Cr CK" := Abs(dImporte);
                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" := dImporte
                    else
                        ContabNom."Importe Cr" := Abs(dImporte);
                end;
            end
            else begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" := dImporte
                    else
                        ContabNom."Importe Cr CK" := Abs(dImporte);

                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" := dImporte
                    else
                        ContabNom."Importe Cr" := Abs(dImporte);
                end;
            end;

            recDimSet.Reset;
            recDimSet.SetFilter("Dimension Set ID", '%1|%2', "Cab. nómina"."Dimension Set ID", "Lín. nómina"."Dimension Set ID");
            if recDimSet.FindSet() then
                repeat
                    if ConceptosSalariales."Contabilizacion x Dimension" then begin
                        if recDimSet."Dimension Code" = CodDim[1] then begin
                            ContabNom."Cod. Dim 1" := recDimSet."Dimension Code";
                            if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[1]) then
                                ContabNom."Valor Dim 1" := DistribEDEmp.Codigo
                            else
                                ContabNom."Valor Dim 1" := recDimSet."Dimension Value Code";
                        end
                        else
                            if recDimSet."Dimension Code" = CodDim[2] then begin
                                ContabNom."Cod. Dim 2" := recDimSet."Dimension Code";
                                if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[2]) then
                                    ContabNom."Valor Dim 2" := DistribEDEmp.Codigo
                                else
                                    ContabNom."Valor Dim 2" := recDimSet."Dimension Value Code";
                            end
                            else
                                if recDimSet."Dimension Code" = CodDim[3] then begin
                                    ContabNom."Cod. Dim 3" := recDimSet."Dimension Code";
                                    if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[3]) then
                                        ContabNom."Valor Dim 3" := DistribEDEmp.Codigo
                                    else
                                        ContabNom."Valor Dim 3" := recDimSet."Dimension Value Code";
                                end
                                else
                                    if recDimSet."Dimension Code" = CodDim[4] then begin
                                        ContabNom."Cod. Dim 4" := recDimSet."Dimension Code";
                                        if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[4]) then
                                            ContabNom."Valor Dim 4" := DistribEDEmp.Codigo
                                        else
                                            ContabNom."Valor Dim 4" := recDimSet."Dimension Value Code";
                                    end
                                    else
                                        if recDimSet."Dimension Code" = CodDim[5] then begin
                                            ContabNom."Cod. Dim 5" := recDimSet."Dimension Code";
                                            if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[5]) then
                                                ContabNom."Valor Dim 5" := DistribEDEmp.Codigo
                                            else
                                                ContabNom."Valor Dim 5" := recDimSet."Dimension Value Code";
                                        end
                                        else
                                            if recDimSet."Dimension Code" = CodDim[6] then begin
                                                ContabNom."Cod. Dim 6" := recDimSet."Dimension Code";
                                                if (DistribEDEmp."Dimension Code" <> '') and (DistribEDEmp."Dimension Code" = CodDim[6]) then
                                                    ContabNom."Valor Dim 6" := DistribEDEmp.Codigo
                                                else
                                                    ContabNom."Valor Dim 6" := recDimSet."Dimension Value Code";
                                            end;

                        if (not DimExiste) and (DistribEDEmp."Dimension Code" <> '') then begin
                            ContabNom."Cod. Dim 6" := DistribEDEmp."Dimension Code";
                            ContabNom."Valor Dim 6" := DistribEDEmp.Codigo;
                        end;

                        ContabNom."Dimension Set ID" := recDimSet."Dimension Set ID";
                    end;
                until recDimSet.Next = 0
        end;

        //   MESSAGE('%1 %2 %3 %4',cConceptoSal,contabnom."Valor Dim 4",ConceptosSalariales.Prorratear);
        //MESSAGE('%1',"Temp Contabilizacion Nom.");
        if ConceptosSalariales.Provisionar then begin
            for i := 1 to 6 do begin
                if ConfNomina."Dimension Conceptos Salariales" = CodDim[i] then begin
                    if ContabNom."Cod. Dim 1" = CodDim[i] then
                        ContabNom."Valor Dim 1" := cConceptoSal
                    else
                        if ContabNom."Cod. Dim 2" = CodDim[i] then
                            ContabNom."Valor Dim 2" := cConceptoSal
                        else
                            if ContabNom."Cod. Dim 3" = CodDim[i] then
                                ContabNom."Valor Dim 3" := cConceptoSal
                            else
                                if ContabNom."Cod. Dim 4" = CodDim[i] then
                                    ContabNom."Valor Dim 4" := cConceptoSal
                                else
                                    if ContabNom."Cod. Dim 5" = CodDim[i] then
                                        ContabNom."Valor Dim 5" := cConceptoSal
                                    else
                                        if ContabNom."Cod. Dim 6" = CodDim[i] then
                                            ContabNom."Valor Dim 6" := cConceptoSal;
                end;
            end;
        end;
        //Para las Dim del perfil de salario (linea del concepto salarial)
        //Para las Dim por Grupo contable
        DefDim.Reset;
        DefDim.SetFilter("Table ID", '%1|%2|%3', 76053, 76062, 76061);
        if Empleado."Posting Group" <> '' then
            DefDim.SetFilter("No.", Empleado."Posting Group" + '*' + cConceptoSal + '*')
        else
            DefDim.SetFilter("No.", '*' + cConceptoSal + '*');
        if DefDim.FindSet then
            repeat
                if CodDim[1] = DefDim."Dimension Code" then begin
                    ContabNom."Cod. Dim 1" := DefDim."Dimension Code";
                    if (DistribEDEmp."Dimension Code" <> '') and (DefDim."Dimension Code" = DistribEDEmp."Dimension Code") then
                        ContabNom."Valor Dim 1" := DistribEDEmp.Codigo
                    else
                        ContabNom."Valor Dim 1" := DefDim."Dimension Value Code";
                end
                else
                    if CodDim[2] = DefDim."Dimension Code" then begin
                        ContabNom."Cod. Dim 2" := DefDim."Dimension Code";
                        if (DistribEDEmp."Dimension Code" <> '') and (DefDim."Dimension Code" = DistribEDEmp."Dimension Code") then
                            ContabNom."Valor Dim 2" := DistribEDEmp.Codigo
                        else
                            ContabNom."Valor Dim 2" := DefDim."Dimension Value Code";
                    end
                    else
                        if CodDim[3] = DefDim."Dimension Code" then begin
                            ContabNom."Cod. Dim 3" := DefDim."Dimension Code";
                            if (DistribEDEmp."Dimension Code" <> '') and (DefDim."Dimension Code" = DistribEDEmp."Dimension Code") then
                                ContabNom."Valor Dim 3" := DistribEDEmp.Codigo
                            else
                                ContabNom."Valor Dim 3" := DefDim."Dimension Value Code";
                        end
                        else
                            if CodDim[4] = DefDim."Dimension Code" then begin
                                ContabNom."Cod. Dim 4" := DefDim."Dimension Code";
                                if (DistribEDEmp."Dimension Code" <> '') and (DefDim."Dimension Code" = DistribEDEmp."Dimension Code") then
                                    ContabNom."Valor Dim 4" := DistribEDEmp.Codigo
                                else
                                    ContabNom."Valor Dim 4" := DefDim."Dimension Value Code";
                            end
                            else
                                if CodDim[5] = DefDim."Dimension Code" then begin
                                    ContabNom."Cod. Dim 5" := DefDim."Dimension Code";
                                    if (DistribEDEmp."Dimension Code" <> '') and (DefDim."Dimension Code" = DistribEDEmp."Dimension Code") then
                                        ContabNom."Valor Dim 5" := DistribEDEmp.Codigo
                                    else
                                        ContabNom."Valor Dim 5" := DefDim."Dimension Value Code";
                                end
                                else
                                    if CodDim[6] = DefDim."Dimension Code" then begin
                                        ContabNom."Cod. Dim 6" := DefDim."Dimension Code";
                                        if (DistribEDEmp."Dimension Code" <> '') and (DefDim."Dimension Code" = DistribEDEmp."Dimension Code") then
                                            ContabNom."Valor Dim 6" := DistribEDEmp.Codigo
                                        else
                                            ContabNom."Valor Dim 6" := DefDim."Dimension Value Code";
                                    end;

                if (not DimExiste) and (DistribEDEmp."Dimension Code" <> '') then
                    ContabNom."Valor Dim 6" := DistribEDEmp.Codigo;

            until DefDim.Next = 0;
        ContabNom."Forma de Cobro" := "Cab. nómina"."Forma de Cobro";

        if not ContabNom.Insert then
            ContabNom.Modify;
    end;


    procedure LlenaDatosCp(cConceptoSal: Code[20]; iTipoCuenta: Integer; cCodCuenta: Code[20]; dImporte: Decimal; Contrapartida: Boolean; CodEmpleado: Code[20])
    begin
        //LlenadatosCP
        Clear(TempContabNom);
        TempContabNom.SetRange("Tipo Cuenta", iTipoCuenta);
        TempContabNom.SetRange("No. Cuenta", cCodCuenta);
        TempContabNom.SetRange(Step, 2);


        HistLinNom.Reset;
        HistLinNom.SetCurrentKey("No. empleado", "Tipo Nómina", Período, "No. Orden");
        HistLinNom.SetRange("No. empleado", "Lin. Aportes Empresas"."No. Empleado");
        HistLinNom.SetFilter("Tipo de nomina", "Cab. nómina".GetFilter("Tipo de nomina"));
        HistLinNom.SetRange("No. Documento", "Lin. Aportes Empresas"."No. Documento");
        HistLinNom.SetRange(Período, "Lin. Aportes Empresas".Período);
        HistLinNom.SetRange("Concepto salarial", "Lin. Aportes Empresas"."Concepto Salarial");
        if not HistLinNom.FindFirst then
            HistLinNom.Init;


        recDimSet.Reset;
        recDimSet.SetRange("Dimension Set ID", "Lin. Aportes Empresas"."Dimension Set ID");
        if recDimSet.FindSet() then
            repeat
                if recDimSet."Dimension Code" = CodDim[1] then begin
                    TempContabNom.SetRange("Cod. Dim 1", recDimSet."Dimension Code");
                    TempContabNom.SetRange("Valor Dim 1", recDimSet."Dimension Value Code");
                    if ConceptosSalariales.Provisionar and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                        ContabNom.SetRange("Valor Dim 1", cConceptoSal);
                end;

                if recDimSet."Dimension Code" = CodDim[2] then begin
                    TempContabNom.SetRange("Cod. Dim 2", recDimSet."Dimension Code");
                    TempContabNom.SetRange("Valor Dim 2", recDimSet."Dimension Value Code");
                    if ConceptosSalariales.Provisionar and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                        ContabNom.SetRange("Valor Dim 1", cConceptoSal);

                end;

                if ConceptosSalariales."Contabilizacion x Dimension" then begin
                    if recDimSet."Dimension Code" = CodDim[3] then begin
                        TempContabNom.SetRange("Cod. Dim 3", recDimSet."Dimension Code");
                        TempContabNom.SetRange("Valor Dim 3", recDimSet."Dimension Value Code");
                        if ConceptosSalariales.Provisionar and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                            ContabNom.SetRange("Valor Dim 1", cConceptoSal);
                    end;

                    if recDimSet."Dimension Code" = CodDim[4] then begin
                        TempContabNom.SetRange("Cod. Dim 4", recDimSet."Dimension Code");
                        TempContabNom.SetRange("Valor Dim 4", recDimSet."Dimension Value Code");
                        if ConceptosSalariales.Provisionar and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                            ContabNom.SetRange("Valor Dim 1", cConceptoSal);
                    end;

                    if recDimSet."Dimension Code" = CodDim[5] then begin
                        TempContabNom.SetRange("Cod. Dim 5", recDimSet."Dimension Code");
                        TempContabNom.SetRange("Valor Dim 5", recDimSet."Dimension Value Code");
                        if ConceptosSalariales.Provisionar and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                            ContabNom.SetRange("Valor Dim 1", cConceptoSal);
                    end;

                    if recDimSet."Dimension Code" = CodDim[6] then begin
                        TempContabNom.SetRange("Cod. Dim 6", recDimSet."Dimension Code");
                        TempContabNom.SetRange("Valor Dim 6", recDimSet."Dimension Value Code");
                        if ConceptosSalariales.Provisionar and (recDimSet."Dimension Code" = ConfNomina."Dimension Conceptos Salariales") then
                            ContabNom.SetRange("Valor Dim 1", cConceptoSal);
                    end;
                end;
                if not ConceptosSalariales."Contabilizacion Resumida" then
                    TempContabNom.SetRange("Cod. Empleado", CodEmpleado);

            until recDimSet.Next = 0;

        if TempContabNom.FindFirst then begin
            if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                if not Contrapartida then
                    TempContabNom."Importe Cr CK" += Abs(dImporte)
                else
                    TempContabNom."Importe Db CK" += Abs(dImporte);
            end
            else begin
                if not Contrapartida then
                    TempContabNom."Importe Cr" += Abs(dImporte)
                else
                    TempContabNom."Importe Db" += Abs(dImporte);
            end
        end
        else begin
            NoLin += 100;

            Clear(TempContabNom);
            TempContabNom."Tipo Cuenta" := iTipoCuenta;
            TempContabNom."No. Cuenta" := cCodCuenta;
            TempContabNom."No. Linea" := NoLin;
            TempContabNom."Cod. Empleado" := CodEmpleado;
            TempContabNom.Contrapartida := Contrapartida;
            TempContabNom.Step := 2;

            if not ConceptosSalariales."Contabilizacion Resumida" then
                TempContabNom.Descripcion := CopyStr(Empleado."No." + ' ' + Empleado."Full Name", 1, 50)
            else
                TempContabNom.Descripcion := ConceptosSalariales.Descripcion;

            if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                if not Contrapartida then
                    TempContabNom."Importe Cr CK" := Abs(dImporte)
                else
                    TempContabNom."Importe Db CK" := Abs(dImporte);
            end
            else begin
                if not Contrapartida then
                    TempContabNom."Importe Cr" := Abs(dImporte)
                else
                    TempContabNom."Importe Db" := Abs(dImporte);
            end;
            recDimSet.Reset;
            recDimSet.SetRange("Dimension Set ID", "Lin. Aportes Empresas"."Dimension Set ID");
            if recDimSet.FindSet() then
                repeat
                    if recDimSet."Dimension Code" = CodDim[1] then //Siempre llevara la primera DIM (Departamento)
                       begin
                        TempContabNom."Cod. Dim 1" := recDimSet."Dimension Code";
                        TempContabNom."Valor Dim 1" := recDimSet."Dimension Value Code";
                    end;

                    if recDimSet."Dimension Code" = CodDim[2] then //Siempre llevara la segunda DIM (Concepto Sal.)
                       begin
                        TempContabNom."Cod. Dim 2" := recDimSet."Dimension Code";
                        TempContabNom."Valor Dim 2" := recDimSet."Dimension Value Code";
                    end;

                    if ConceptosSalariales."Contabilizacion x Dimension" then begin
                        if recDimSet."Dimension Code" = CodDim[3] then begin
                            TempContabNom."Cod. Dim 3" := recDimSet."Dimension Code";
                            TempContabNom."Valor Dim 3" := recDimSet."Dimension Value Code";
                        end
                        else
                            if recDimSet."Dimension Code" = CodDim[4] then begin
                                TempContabNom."Cod. Dim 4" := recDimSet."Dimension Code";
                                TempContabNom."Valor Dim 4" := recDimSet."Dimension Value Code";
                            end
                            else
                                if recDimSet."Dimension Code" = CodDim[5] then begin
                                    TempContabNom."Cod. Dim 5" := recDimSet."Dimension Code";
                                    TempContabNom."Valor Dim 5" := recDimSet."Dimension Value Code";
                                end
                                else
                                    if recDimSet."Dimension Code" = CodDim[6] then begin
                                        TempContabNom."Cod. Dim 6" := recDimSet."Dimension Code";
                                        TempContabNom."Valor Dim 6" := recDimSet."Dimension Value Code";
                                    end;
                        TempContabNom."Dimension Set ID" := recDimSet."Dimension Set ID";
                    end;
                until recDimSet.Next = 0;
        end;

        if not TempContabNom.Insert then
            TempContabNom.Modify;
    end;


    procedure InsertaLinDiario(TmpContNom: Record "Temp Contabilizacion Nom.")
    var
        DefDim: Record "Default Dimension";
        DimMgt: Codeunit DimensionManagement;
        CLE: Record "Cust. Ledger Entry";
        Encontrado: Boolean;
    begin
        GenJnlLine.Reset;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := ConfNomina."Journal Template Name";
        GenJnlLine."Journal Batch Name" := CodSección;
        GenJnlLine."Posting Date" := FechaRegistro;
        if TmpContNom."Tipo Cuenta" = 0 then
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account"
        else
            if TmpContNom."Tipo Cuenta" = 1 then
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer
            else
                if TmpContNom."Tipo Cuenta" = 2 then
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;

        NoLinea += 100;
        GenJnlLine."Line No." := NoLinea;

        GenJnlLine.Validate("Account No.", TmpContNom."No. Cuenta");
        GenJnlLine.TestField("Account No.");
        GenJnlLine."Document No." := NumDoc;
        GenJnlLine.Description := CopyStr(TmpContNom.Descripcion, 1, 50);

        if CodDivisa <> '' then
            GenJnlLine.Validate("Currency Code", CodDivisa);

        if "Cab. nómina"."Shortcut Dimension 1 Code" <> '' then
            GenJnlLine.Validate("Shortcut Dimension 1 Code", "Cab. nómina"."Shortcut Dimension 1 Code");

        if "Cab. nómina"."Shortcut Dimension 2 Code" <> '' then
            GenJnlLine.Validate("Shortcut Dimension 2 Code", "Cab. nómina"."Shortcut Dimension 2 Code");

        if TmpContNom."Importe Db" <> 0 then
            GenJnlLine.Validate("Debit Amount", TmpContNom."Importe Db")
        else
            if TmpContNom."Importe Cr" <> 0 then
                GenJnlLine.Validate("Credit Amount", TmpContNom."Importe Cr")
            else
                if TmpContNom."Importe Db CK" <> 0 then
                    GenJnlLine.Validate("Debit Amount", TmpContNom."Importe Db CK")
                else
                    GenJnlLine.Validate("Credit Amount", TmpContNom."Importe Cr CK");

        //Adicionado para Hemingway para liquidar documentos pendientes
        /*
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
           BEGIN
             Encontrado := FALSE;
             CLE.RESET;
             CLE.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
             CLE.SETRANGE("Customer No.",GenJnlLine."Account No.");
             CLE.SETRANGE(Open,TRUE);
             CLE.SETRANGE(Positive,TRUE);
             IF CLE.FINDSET THEN
                REPEAT
        
                UNTIL CLE.NEXT = 0 OR Encontrado;
           END;
        */

        if GenJnlLine.Amount <> 0 then begin
            GenJnlLine.Insert(true);

            //DimMgt.GetDimensionSet(TempDimSetEntry,GenJnlLine."Dimension Set ID");

            Clear(TempDimSetEntry);
            TempDimSetEntry.DeleteAll;

            //Busco DefDim del Maestro
            DefDim.Reset;
            case TmpContNom."Tipo Cuenta" of
                0: //Cuenta
                    begin
                        DefDim.SetRange("Table ID", 15);
                    end;
                1: //Cliente
                    begin
                        DefDim.SetRange("Table ID", 18);
                    end;
                2: //Proveedor
                    begin
                        //IF TmpContNom."Importe Db" <> 0 THEN
                        //  GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                        // ELSE
                        //  GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;

                        //GenJnlLine."External Document No." := FORMAT(TODAY) + '-' + FORMAT(NoLin);
                        DefDim.SetRange("Table ID", 23);
                    end;
            end;

            DefDim.SetRange("Value Posting", DefDim."Value Posting"::"Same Code");
            DefDim.SetRange("No.", TmpContNom."No. Cuenta");
            if DefDim.FindSet then
                repeat
                    UpdateDimSet(DefDim."Dimension Code", DefDim."Dimension Value Code");
                until DefDim.Next = 0;


            if (TmpContNom."Cod. Dim 1" <> '') and (TmpContNom."Valor Dim 1" <> '') then begin
                UpdateDimSet(TmpContNom."Cod. Dim 1", TmpContNom."Valor Dim 1");
                if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 1" then
                    GenJnlLine."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 1"
                else
                    if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 1" then
                        GenJnlLine."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 1"
            end;

            if (TmpContNom."Cod. Dim 2" <> '') and (TmpContNom."Valor Dim 2" <> '') then begin
                TmpContNom.TestField("Cod. Dim 2");
                //    UpdateDimSet(TempDimSetEntry,TmpContNom."Cod. Dim 2",TmpContNom."Valor Dim 2");
                UpdateDimSet(TmpContNom."Cod. Dim 2", TmpContNom."Valor Dim 2");
                if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 2" then
                    GenJnlLine."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 2"
                else
                    if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 2" then
                        GenJnlLine."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 2"
            end;

            if (TmpContNom."Cod. Dim 3" <> '') and (TmpContNom."Valor Dim 3" <> '') then begin
                TmpContNom.TestField("Cod. Dim 3");
                UpdateDimSet(TmpContNom."Cod. Dim 3", TmpContNom."Valor Dim 3");
                if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 3" then
                    GenJnlLine."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 3"
                else
                    if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 3" then
                        GenJnlLine."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 3"
            end;

            if (TmpContNom."Cod. Dim 4" <> '') and (TmpContNom."Valor Dim 4" <> '') then begin
                TmpContNom.TestField("Cod. Dim 4");
                UpdateDimSet(TmpContNom."Cod. Dim 4", TmpContNom."Valor Dim 4");
                if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 4" then
                    GenJnlLine."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 4"
                else
                    if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 4" then
                        GenJnlLine."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 4"
            end;

            if (TmpContNom."Cod. Dim 5" <> '') and (TmpContNom."Valor Dim 5" <> '') then begin
                UpdateDimSet(TmpContNom."Cod. Dim 5", TmpContNom."Valor Dim 5");
                if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 5" then
                    GenJnlLine."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 5"
                else
                    if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 5" then
                        GenJnlLine."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 5"
            end;

            if (TmpContNom."Cod. Dim 6" <> '') and (TmpContNom."Valor Dim 6" <> '') then begin
                UpdateDimSet(TmpContNom."Cod. Dim 6", TmpContNom."Valor Dim 6");
                if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 6" then
                    GenJnlLine."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 6"
                else
                    if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 6" then
                        GenJnlLine."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 6"
            end;

            GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);

            GenJnlLine.Modify;
        end;

    end;


    procedure InsertaProvision(ConceptoSal: Code[20]; ImportProrr: Decimal)
    var
        NoCuenta: Code[20];
        CSP: Record "Conceptos Salariales Provision";
    begin
        //Del Diario de pagos
        ConceptosSalariales.Get(ConceptoSal);

        //Del Histórico de Nominas
        if GpoContEmpl.Get(Empleado."Posting Group") then begin
            ConfGpoContEmpl.SetRange(Código, GpoContEmpl.Código);
            ConfGpoContEmpl.SetRange("Código Concepto Salarial", ConceptoSal);
            if ConfGpoContEmpl.FindFirst then begin
                ConfGpoContEmpl.TestField("No. Cuenta Cuota Obrera");
                NoCuenta := ConfGpoContEmpl."No. Cuenta Cuota Obrera";
                case ConfGpoContEmpl."Tipo Cuenta Cuota Obrera" of
                    0:
                        TipoCta := 0;
                    else
                        TipoCta := 2;
                end;

                if (ConceptosSalariales."Validar Contrapartida CO") and (not ConfGpoContEmpl.Provisionar) then begin
                    ConfGpoContEmpl.TestField("No. Cuenta Contrapartida CO");
                    case ConfGpoContEmpl."Tipo Cuenta Contrapartida CO" of
                        0:
                            TipoContrapartida := 0;
                        else
                            TipoContrapartida := 2;
                    end;

                    NoCuentaContrapartida := ConfGpoContEmpl."No. Cuenta Contrapartida CO";
                end;

                if ConfGpoContEmpl.Provisionar then begin
                    "Conceptos Salariales Provision".TestField("No. Cuenta");
                    NoCuenta := "Conceptos Salariales Provision"."No. Cuenta";

                    CSP.Reset;
                    CSP.SetRange(Código, ConceptoSal);
                    CSP.SetRange("Gpo. Contable Empleado", ConfGpoContEmpl.Código);
                    if CSP.FindFirst then begin
                        CSP.TestField("No. Cuenta");
                        NoCuenta := CSP."No. Cuenta";
                        TipoCta := 0;
                        ConceptosSalariales."Validar Contrapartida CO" := CSP."Validar Contrapartida";
                        if CSP."Validar Contrapartida" then begin
                            CSP.TestField("No. Cuenta Contrapartida");
                            TipoContrapartida := 0;
                            NoCuentaContrapartida := CSP."No. Cuenta Contrapartida";
                        end;
                    end;

                end;
            end
            else begin
                case ConceptosSalariales."Tipo Cuenta Cuota Obrera" of
                    0:
                        TipoCta := 0;
                    1:
                        TipoCta := 1;
                    else
                        TipoCta := 2;
                end;

                if TipoCta <> 1 then //Cliente
                   begin
                    ConceptosSalariales.TestField("No. Cuenta Cuota Obrera");
                    NoCuenta := ConceptosSalariales."No. Cuenta Cuota Obrera";
                end;

                if ConceptosSalariales."Validar Contrapartida CO" then begin
                    ConceptosSalariales.TestField("No. Cuenta Contrapartida CO");
                    case ConceptosSalariales."Tipo Cuenta Contrapartida CO" of
                        0:
                            TipoContrapartida := 0;
                        else
                            TipoContrapartida := 2;
                    end;

                    NoCuentaContrapartida := ConceptosSalariales."No. Cuenta Contrapartida CO";
                end;
            end;
        end
        else begin
            case ConceptosSalariales."Tipo Cuenta Cuota Obrera" of
                0:
                    TipoCta := 0;
                1:
                    TipoCta := 1;
                else
                    TipoCta := 2;
            end;

            if TipoCta <> 1 then //Cliente
               begin
                "Conceptos Salariales Provision".TestField("No. Cuenta");
                NoCuenta := "Conceptos Salariales Provision"."No. Cuenta";
            end;

            if "Conceptos Salariales Provision"."Validar Contrapartida" then begin
                "Conceptos Salariales Provision".TestField("No. Cuenta Contrapartida");
                TipoContrapartida := 0;
                NoCuentaContrapartida := "Conceptos Salariales Provision"."No. Cuenta Contrapartida";
            end;
        end;

        if NoCuenta = '' then
            Error(Err002);

        LlenaDatosCO(ConceptoSal, TipoCta, NoCuenta, ImportProrr, false,
                      "Cab. nómina"."No. empleado");

        if "Conceptos Salariales Provision"."Validar Contrapartida" then begin
            LlenaDatosCO(ConceptoSal, TipoContrapartida, NoCuentaContrapartida, ImportProrr * -1,
               true, "Cab. nómina"."No. empleado");
        end;
    end;


    procedure CxC()
    begin
        /*
        IF ConceptosSalariales.Código = ConfNomina."Concepto Salarial CxC Empl." THEN
           BEGIN
            GenJnlLine.RESET;
            IF CxCEmpl."Tipo Contrapartida" <> CxCEmpl."Tipo Contrapartida"::Cliente THEN
               BEGIN
                IF CxCEmpl."Tipo Contrapartida" = CxCEmpl."Tipo Contrapartida"::Proveedor THEN
                   GenJnlLine."Account Type"   := GenJnlLine."Account Type"::Vendor
                ELSE
                IF CxCEmpl."Tipo Contrapartida" = CxCEmpl."Tipo Contrapartida"::Cuenta THEN
                   GenJnlLine."Account Type"   := GenJnlLine."Account Type"::"G/L Account"
                ELSE
                   GenJnlLine."Account Type"   := GenJnlLine."Account Type"::"Bank Account";
        
                GenJnlLine.RESET;
                GenJnlLine.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Account No.");
                GenJnlLine.SETRANGE("Journal Template Name", ConfNomina."Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", CodSección);
                GenJnlLine.SETRANGE("Posting Date", FechaRegistro);
                GenJnlLine.SETRANGE("Account No.",CxCEmpl."Cta. Contrapartida");
                IF GenJnlLine.FINDFIRST THEN
                   BEGIN
                    GenJnlLine."Credit Amount" += total;
                    GenJnlLine.VALIDATE("Credit Amount");
                    GenJnlLine.MODIFY;
                    CxCMod := TRUE;
                   END;
               END
            ELSE
               BEGIN
                GenJnlLine."Account Type"      := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No."       := Empleado."Código Cliente";
               END;
        
            GenJnlLine.VALIDATE("Account No.");
           END;
        */

    end;


    procedure InsertaContrapartidaCO(TmpContNomCont: Record "Temp Contabilizacion Nom.")
    begin
        // GRN Graba contrapartida por el neto para pagos transferencias
        GenJnlLine.Init;
        if (TmpContNomCont."Importe Db" <> 0) or (TmpContNomCont."Importe Cr" <> 0) then begin
            ConfNomina.TestField("Cód. Cta. Nominas Pago Transf.");
            NoLinea += 1000;
            GenJnlLine."Journal Template Name" := ConfNomina."Journal Template Name";
            GenJnlLine."Journal Batch Name" := CodSección;
            GenJnlLine."Posting Date" := FechaRegistro;
            GenJnlLine."Document No." := NumDoc;
            GenJnlLine."Line No." := NoLinea;
            GenJnlLine.Description := Text001;
            if (Tiposdenominas."Tipo de nomina" = Tiposdenominas."Tipo de nomina"::Prestaciones) then begin
                ConfNomina.TestField("Cta. Nominas Otros Pagos");
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", ConfNomina."Cta. Nominas Otros Pagos");
            end
            else begin
                if (ConfNomina."Tipo cuenta" = ConfNomina."Tipo cuenta"::Cuenta) then
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account"
                else
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";

                GenJnlLine.Validate("Account No.", ConfNomina."Cód. Cta. Nominas Pago Transf.");
            end;
            if CodDivisa <> '' then
                GenJnlLine.Validate("Currency Code", CodDivisa);
            GenJnlLine."Credit Amount" := Round(TmpContNomCont."Importe Db" - TmpContNomCont."Importe Cr",
                                                        Divisa."Amount Rounding Precision");
            GenJnlLine.Validate("Credit Amount");
            if GenJnlLine."Amount (LCY)" <> 0 then
                GenJnlLine.Insert;
        end;

        // GRN Graba contrapartida por el neto para pagos diferentes transferencias
        GenJnlLine.Init;
        if (TmpContNomCont."Importe Db CK" <> 0) or (TmpContNomCont."Importe Cr CK" <> 0) then begin
            ConfNomina.TestField(ConfNomina."Cta. Nominas Otros Pagos");
            NoLinea += 1000;
            GenJnlLine."Journal Template Name" := ConfNomina."Journal Template Name";
            GenJnlLine."Journal Batch Name" := CodSección;
            GenJnlLine."Posting Date" := FechaRegistro;
            GenJnlLine."Document No." := NumDoc;
            GenJnlLine."Line No." := NoLinea;
            GenJnlLine.Description := Text001;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";

            GenJnlLine.Validate("Account No.", ConfNomina."Cta. Nominas Otros Pagos");
            if CodDivisa <> '' then
                GenJnlLine.Validate("Currency Code", CodDivisa);
            GenJnlLine."Credit Amount" := Round(TmpContNomCont."Importe Db CK" - TmpContNomCont."Importe Cr CK",
                                                        Divisa."Amount Rounding Precision");
            GenJnlLine.Validate("Credit Amount");
            if GenJnlLine."Amount (LCY)" <> 0 then
                GenJnlLine.Insert;
        end;
    end;


    procedure InsertaContrapartidaCP(TmpContNomCont: Record "Temp Contabilizacion Nom.")
    begin
        // GRN Graba contrapartida por el neto para pagos transferencias

        //MESSAGE('dbck %1   crck %2   db %3   cr %4',TmpContNomCont."Importe Db",TmpContNomCont."Importe Cr",
        //    TmpContNomCont."Importe Db CK"\,TmpContNomCont."Importe Cr CK");

        TmpContNomCont."Importe Db" := Round(TmpContNomCont."Importe Db", Divisa."Amount Rounding Precision");
        TmpContNomCont."Importe Cr" := Round(TmpContNomCont."Importe Cr", Divisa."Amount Rounding Precision");
        TmpContNomCont."Importe Db CK" := Round(TmpContNomCont."Importe Db CK", Divisa."Amount Rounding Precision");
        TmpContNomCont."Importe Cr CK" := Round(TmpContNomCont."Importe Cr CK", Divisa."Amount Rounding Precision");

        //   MESSAGE('dbck %1   crck %2   db %3   cr %4',TmpContNomCont."Importe Db",TmpContNomCont."Importe Cr",
        //   TmpContNomCont."Importe Db CK",TmpContNomCont."Importe Cr CK");

        GenJnlLine.Init;
        if ((TmpContNomCont."Importe Db" <> 0) or (TmpContNomCont."Importe Cr" <> 0)) and
            (TmpContNomCont."Importe Db" <> TmpContNomCont."Importe Cr") then begin
            ConfNomina.TestField("Cód. Cta. Nominas Pago Transf.");
            NoLinea += 1000;
            GenJnlLine."Journal Template Name" := ConfNomina."Journal Template Name";
            GenJnlLine."Journal Batch Name" := CodSección;
            GenJnlLine."Posting Date" := FechaRegistro;
            GenJnlLine."Document No." := NumDoc;
            GenJnlLine."Line No." := NoLinea;
            GenJnlLine.Description := Text001;
            if ConfNomina."Tipo cuenta" = ConfNomina."Tipo cuenta"::Cuenta then
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account"
            else
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
            if CodDivisa <> '' then
                GenJnlLine.Validate("Currency Code", CodDivisa);
            GenJnlLine.Validate("Account No.", ConfNomina."Cód. Cta. Nominas Pago Transf.");
            GenJnlLine."Debit Amount" := Round(TmpContNomCont."Importe Db", Divisa."Amount Rounding Precision");
            GenJnlLine.Validate("Debit Amount");
            if GenJnlLine."Amount (LCY)" <> 0 then
                GenJnlLine.Insert;
        end;

        // GRN Graba contrapartida por el neto para pagos diferentes transferencias
        GenJnlLine.Init;
        if ((TmpContNomCont."Importe Db CK" <> 0) or (TmpContNomCont."Importe Cr CK" <> 0)) and
            (TmpContNomCont."Importe Db CK" <> TmpContNomCont."Importe Cr CK") then begin
            ConfNomina.TestField(ConfNomina."Cta. Nominas Otros Pagos");
            NoLinea += 1000;
            GenJnlLine."Journal Template Name" := ConfNomina."Journal Template Name";
            GenJnlLine."Journal Batch Name" := CodSección;
            GenJnlLine."Posting Date" := FechaRegistro;
            GenJnlLine."Document No." := NumDoc;
            GenJnlLine."Line No." := NoLinea;
            GenJnlLine.Description := Text001;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            if CodDivisa <> '' then
                GenJnlLine.Validate("Currency Code", CodDivisa);
            GenJnlLine.Validate("Account No.", ConfNomina."Cta. Nominas Otros Pagos");
            GenJnlLine."Debit Amount" := Round(TmpContNomCont."Importe Db CK", Divisa."Amount Rounding Precision");
            GenJnlLine.Validate("Debit Amount");
            if GenJnlLine."Amount (LCY)" <> 0 then
                GenJnlLine.Insert;
        end;
    end;


    procedure UpdateDimSet(DimCode: Code[20]; DimValueCode: Code[20])
    var
        DimVal: Record "Dimension Value";
    begin
        if (DimCode = '') or (DimValueCode = '') then
            exit;

        DimVal.Get(DimCode, DimValueCode);

        TempDimSetEntry.Validate("Dimension Code", DimCode);
        TempDimSetEntry.Validate("Dimension Value Code", DimValueCode);
        TempDimSetEntry.Validate("Dimension Value ID", DimVal."Dimension Value ID");

        if TempDimSetEntry.Insert then;
    end;

    local procedure ProvisionaVacaciones(): Decimal
    var
        Fecha: Record Date;
        DiasVacaciones: Integer;
        MontoVacacionesMesAnt: Decimal;
        MontoVacaciones: Decimal;
        FechaFin: Date;
        AnosAntiguedad: Integer;
        MesesAntiguedad: Integer;
        FechaDic: Date;
        FechaContrato: Date;
        Acumulado: Decimal;
    begin
        ConfNomina.Get();
        /*IF Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal THEN
           IF DATE2DMY(inicial,1) = 1 THEN
              EXIT;
              */
        Empleado.CalcFields(Salario);
        if Empleado."Employment Date" = 0D then
            Error(Err001, Empleado.FieldCaption("Employment Date"), Empleado.TableCaption, Empleado."No.");

        if Empleado."Employment Date" = 0D then
            Error(Err001, Empleado.FieldCaption("Employment Date"), Empleado.TableCaption, Empleado."No.");

        /*if Empleado."Employment Date" > inicial then
            DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.", Date2DMY(Empleado."Employment Date", 2), Nomina
                                                                Date2DMY(inicial, 3), MontoVacaciones, Empleado."Employment Date", final)
        else
            DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.", Date2DMY(inicial, 2),
                                                                Date2DMY(inicial, 3), MontoVacaciones, Empleado."Employment Date", final);*/

        Acumulado := 0;

        //Busco los ingresos del periodo
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Empleado."No.");
        HistLinNom.SetRange("Aplica para Regalia", true);
        HistLinNom.SetRange(Período, DMY2Date(1, Date2DMY(inicial, 2), Date2DMY(inicial, 3)), final);
        if "Cab. nómina".GetFilter("Job No.") <> '' then
            HistLinNom.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));

        if HistLinNom.FindSet then
            repeat
                Acumulado += HistLinNom.Total;
            until HistLinNom.Next = 0;

        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
            Acumulado := Acumulado / 12
        else
            if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal" then
                Acumulado := Acumulado / 26
            else
                Acumulado /= 12;


        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal" then
            Empleado.Salario := Acumulado;

        Empleado.Salario := Acumulado / 23.83;

        if DiasTranscurridos < 25 then begin
            if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
               (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") then
                MontoVacaciones := Empleado.Salario * DiasVacaciones
        end
        else
            MontoVacaciones := Empleado.Salario * DiasVacaciones;

        //ERROR('%1 %2',MontoVacaciones,Empleado.Salario * DiasVacaciones/12);
        //error('%1 %2 %3 %4 %5 %6',Empleado."No.","Cab. nómina".Fin,DiasVacaciones,AnosAntiguedad,MesesAntiguedad,MontoVacaciones);
        //Cuando es vacaciones colectivas, el derecho se obtiene a partir del quinto mes
        //ERROR('%1',MontoVacaciones);

        exit(MontoVacaciones);


        /*GRN Esto Seccion hizo para elmufdi y ya No va
        ConfNomina.GET();
        Empleado.CALCFIELDS(Salario);
        IF Empleado."Employment Date" = 0D THEN
           ERROR(Err001,Empleado.FIELDCAPTION("Employment Date"),Empleado.TABLECAPTION,Empleado."No.");
        
        
        FechaContrato := Empleado."Employment Date";
        IF (FechaContrato >= inicial) AND (FechaContrato < final) THEN
           EXIT;
        
        IF DATE2DMY(Empleado."Employment Date",3) <> DATE2DMY(WORKDATE,3) THEN
           BEGIN
            FechaDic := DMY2DATE(31,12,DATE2DMY(WORKDATE,3));
            CalculoFechas.CálculoEntreFechas(Empleado."Employment Date",FechaDic,Anos,Meses,Dias);
            AnosAntiguedad := Anos;
            MesesAntiguedad := Meses;
          END;
        //Cuando es vacaciones colectivas, el cálculo se obtiene a partir del quinto mes
        IF NOT ConfNomina."Vacaciones colectivas" THEN
           BEGIN
            CalculoFechas.CálculoEntreFechas(Empleado."Employment Date","Cab. nómina".Fin,Anos,Meses,Dias);
            IF (Anos = 0) AND (Meses = 5) THEN
                 DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.",DATE2DMY(Empleado."Employment Date",2),
                                                          DATE2DMY(WORKDATE,3),MontoVacaciones,Empleado."Employment Date")
            ELSE
            IF (Anos = 0) AND ((Meses > 5) AND (Meses < 12)) THEN
                DiasVacaciones := 1
            ELSE
              DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.",DATE2DMY(Empleado."Employment Date",2),
                                                              DATE2DMY(WORKDATE,3),MontoVacaciones,Empleado."Employment Date");
           END
        ELSE
           BEGIN
            FechaFin := DMY2DATE(31,12,DATE2DMY(WORKDATE,3));
            CalculoFechas.CálculoEntreFechas(Empleado."Employment Date",FechaFin,Anos,Meses,Dias);
            IF (Anos = 0) AND (Meses = 5) THEN
                 DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.",DATE2DMY(Empleado."Employment Date",2),
                                                          DATE2DMY(WORKDATE,3),MontoVacaciones,Empleado."Employment Date")
            ELSE
            IF (Anos = 0) AND ((Meses > 5) AND (Meses < 12)) THEN
                DiasVacaciones := 1
            ELSE
              DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.",DATE2DMY(Empleado."Employment Date",2),
                                                              DATE2DMY(WORKDATE,3),MontoVacaciones,Empleado."Employment Date");
           END;
        
        //MESSAGE('%1 %2 %3 %4',Empleado."No.","Cab. nómina".Fin,DiasVacaciones);
        
        Empleado.Salario /= 23.83;
        
        IF DiasTranscurridos < 25 THEN
          BEGIN
            IF Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal THEN
              MontoVacaciones := (Empleado.Salario * DiasVacaciones) * 0.5
            ELSE
            IF Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal" THEN
              MontoVacaciones := (Empleado.Salario * DiasVacaciones) * 0.5
          END
        ELSE
          MontoVacaciones := Empleado.Salario * DiasVacaciones;
        
        //Cuando es vacaciones colectivas, el derecho se obtiene a partir del quinto mes
        IF ConfNomina."Vacaciones colectivas" THEN
           BEGIN
            // Primero se busca el acumulado del mes anterior
            IF DATE2DMY(Empleado."Employment Date",3) <> DATE2DMY(WORKDATE,3) THEN
               BEGIN
                FechaDic := DMY2DATE(31,12,DATE2DMY(WORKDATE,3));
                CalculoFechas.CálculoEntreFechas(Empleado."Employment Date",FechaDic,Anos,Meses,Dias);
                AnosAntiguedad := Anos;
                MesesAntiguedad := Meses;
                FechaContrato := DMY2DATE(1,1,DATE2DMY(WORKDATE,3));
              END;
        
            IF (DATE2DMY(Empleado."Employment Date",2) = DATE2DMY(WORKDATE,2)) AND
               (DATE2DMY(Empleado."Employment Date",3) = DATE2DMY(WORKDATE,3)) THEN
               EXIT;
        
            FechaFin := CALCDATE('-1M',"Cab. nómina".Fin);
            Fecha.RESET;
            Fecha.SETRANGE("Period Type",Fecha."Period Type"::Month);
            Fecha.SETRANGE("Period Start",DMY2DATE(1,DATE2DMY(FechaFin,2),DATE2DMY(FechaFin,3)));
            IF Fecha.FINDFIRST THEN
               FechaFin:= NORMALDATE(Fecha."Period End");
        
        
            IF  FechaContrato > FechaFin THEN
               EXIT;
        
            CalculoFechas.CálculoEntreFechas(FechaContrato,FechaFin,Anos,Meses,Dias);
        
            IF (Anos = 0) AND (Meses = 5) THEN
                DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.",DATE2DMY(FechaFin,2),
                                                          DATE2DMY(FechaFin,3),MontoVacaciones,FechaContrato)
            ELSE
              BEGIN
                DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.",DATE2DMY(FechaFin,2),
                                                              DATE2DMY(FechaFin,3),MontoVacaciones,FechaContrato);
              END;
        
            IF AnosAntiguedad >= 5 THEN
               BEGIN
                CASE DiasVacaciones OF
                  6:
                   DiasVacaciones := 7;
                  7:
                   DiasVacaciones := 9;
                  8:
                   DiasVacaciones := 10;
                  9:
                   DiasVacaciones := 12;
                  10:
                   DiasVacaciones := 13;
                  11:
                   DiasVacaciones := 15;
                  12:
                   DiasVacaciones := 16;
                  14:
                   DiasVacaciones := 18;
                END;
               END;
            MontoVacacionesMesAnt := (Empleado.Salario * DiasVacaciones);
        // MESSAGE('%1 %2 %3 %4 %5 %6 %7 %8',Empleado."No.","Cab. nómina".Fin,DiasVacaciones,AnosAntiguedad,MesesAntiguedad,DiasTranscurridos,MontoVacaciones,MontoVacacionesMesAnt);
        {
            IF DiasTranscurridos < 25 THEN
              BEGIN
                IF Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal THEN
                  MontoVacacionesMesAnt := (Empleado.Salario * DiasVacaciones) * 0.5
                ELSE
                IF Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal" THEN
                  MontoVacacionesMesAnt := (Empleado.Salario * DiasVacaciones) * 0.5
              END
            ELSE
              MontoVacacionesMesAnt := (Empleado.Salario * DiasVacaciones);
        }
            IF DATE2DMY("Cab. nómina".Fin,2) < 5 THEN
               MontoVacacionesMesAnt := 0;
        
           END;
        
           //Se busca el acumulado al periodo actual
             IF DATE2DMY(Empleado."Employment Date",3) <> DATE2DMY(WORKDATE,3) THEN
               BEGIN
                FechaDic := DMY2DATE(31,12,DATE2DMY(WORKDATE,3));
                CalculoFechas.CálculoEntreFechas(Empleado."Employment Date",FechaDic,Anos,Meses,Dias);
                AnosAntiguedad := Anos;
                MesesAntiguedad := Meses;
                Empleado."Employment Date" := DMY2DATE(1,1,DATE2DMY(WORKDATE,3));
              END;
        
            FechaFin := "Cab. nómina".Fin;
            Fecha.RESET;
            Fecha.SETRANGE("Period Type",Fecha."Period Type"::Month);
            Fecha.SETRANGE("Period Start",DMY2DATE(1,DATE2DMY(FechaFin,2),DATE2DMY(FechaFin,3)));
            IF Fecha.FINDFIRST THEN
               FechaFin:= NORMALDATE(Fecha."Period End");
        
            CalculoFechas.CálculoEntreFechas(Empleado."Employment Date",FechaFin,Anos,Meses,Dias);
        {
            //Para cuando el dia es el ultimo del mes
            IF DATE2DMY(FechaFin,1) = Dias THEN
               Meses += 1;
        }
            IF (Anos = 0) AND (Meses = 5) THEN
                DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.",DATE2DMY(FechaFin,2),
                                                          DATE2DMY(FechaFin,3),MontoVacaciones,Empleado."Employment Date")
        {    ELSE
            IF (Anos = 0) AND ((Meses > 5) AND (Meses < 12)) THEN
                DiasVacaciones := 1
        }
            ELSE
              BEGIN
                DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.",DATE2DMY(FechaFin,2),
                                                              DATE2DMY(FechaFin,3),MontoVacaciones,Empleado."Employment Date");
              END;
        
            IF AnosAntiguedad >= 5 THEN
               BEGIN
                CASE DiasVacaciones OF
                  6:
                   DiasVacaciones := 7;
                  7:
                   DiasVacaciones := 9;
                  8:
                   DiasVacaciones := 10;
                  9:
                   DiasVacaciones := 12;
                  10:
                   DiasVacaciones := 13;
                  11:
                   DiasVacaciones := 15;
                  12:
                   DiasVacaciones := 16;
                  14:
                   DiasVacaciones := 18;
                END;
               END;
        //    MontoVacaciones := (Empleado.Salario * DiasVacaciones);
        // MESSAGE('%1 %2 %3 %4 %5 %6 %7 %8',Empleado."No.","Cab. nómina".Fin,DiasVacaciones,AnosAntiguedad,MesesAntiguedad,DiasTranscurridos,MontoVacaciones,MontoVacacionesMesAnt);
        
        
        {
            IF DiasTranscurridos < 25 THEN
              BEGIN
                IF Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal THEN
                  MontoVacaciones := (Empleado.Salario * DiasVacaciones) * 0.5
                ELSE
                IF Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal" THEN
                  MontoVacaciones := (Empleado.Salario * DiasVacaciones) * 0.5
              END
            ELSE
        }
            MontoVacaciones := Empleado.Salario * DiasVacaciones;
        
            IF DATE2DMY("Cab. nómina".Fin,2) < 5 THEN
               MontoVacaciones := 0;
        
        ERROR('%1 %2 %3 %4 %5',MontoVacaciones,MontoVacacionesMesAnt,MontoVacaciones - MontoVacacionesMesAnt,DiasVacaciones,Empleado.Salario);
            MontoVacaciones := MontoVacaciones - MontoVacacionesMesAnt;
        
        IF (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) OR
           (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") THEN
          MontoVacaciones /= 2;
        
        //ERROR('%1 %2 %3 %4 %5',MontoVacaciones,MontoVacacionesMesAnt,MontoVacaciones - MontoVacacionesMesAnt,DiasVacaciones,Contrato."Frecuencia de pago");
        
        EXIT(MontoVacaciones);
        */

    end;

    local procedure ProvisionaRegalia(): Decimal
    var
        DiasVacaciones: Integer;
        MontoVacaciones: Decimal;
        Acumulado: Decimal;
    begin
        if Empleado."Employment Date" = 0D then
            Error(Err001, Empleado.FieldCaption("Employment Date"), Empleado.TableCaption, Empleado."No.");

        Acumulado := 0;
        //Busco los ingresos del periodo
        //Busqueda de todos los conceptos que cotizan para el calculo del Regalia
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Empleado."No.");
        if (ConfNomina."Registro de provision" = ConfNomina."Registro de provision"::"Bi-Semanal") or
           (ConfNomina."Registro de provision" = ConfNomina."Registro de provision"::Quincenal) then begin
            if (Tiposdenominas."Dia inicio 1ra" > Tiposdenominas."Dia inicio 2da") and (SegundaQ) and (Tiposdenominas."Tipo de nomina" = Tiposdenominas."Tipo de nomina"::Regular) then
                HistLinNom.SetRange(Período, DMY2Date(Tiposdenominas."Dia inicio 1ra", Date2DMY(CalcDate('-1M', inicial), 2), Date2DMY(CalcDate('-1M', final), 3)), final)
            else
                if (Tiposdenominas."Dia inicio 1ra" > Tiposdenominas."Dia inicio 2da") and (Tiposdenominas."Tipo de nomina" = Tiposdenominas."Tipo de nomina"::Prestaciones) then
                    HistLinNom.SetRange(Período, DMY2Date(Tiposdenominas."Dia inicio 1ra", Date2DMY(CalcDate('-1M', inicial), 2), Date2DMY(CalcDate('-1M', final), 3)), final)
                else
                    HistLinNom.SetRange(Período, inicial, final);
        end
        else
            HistLinNom.SetRange(Período, inicial, final);

        if "Cab. nómina".GetFilter("Job No.") <> '' then
            HistLinNom.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
        HistLinNom.SetFilter("Tipo de nomina", "Cab. nómina".GetFilter("Tipo de nomina"));
        HistLinNom.SetRange("Aplica para Regalia", true);
        if HistLinNom.FindSet then
            repeat
                Acumulado += HistLinNom.Total;
            until HistLinNom.Next = 0;

        if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
           (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") then
            Acumulado := Acumulado / 12
        /*ELSE
        IF Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal" THEN
            Acumulado := Acumulado / 26
        */
        else
            Acumulado /= 12;
        /*
        IF ConfNomina."Registro de provision" = ConfNomina."Registro de provision"::Quincenal
          BEGIN
            IF (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) OR
               (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") THEN
               Acumulado /= 2;
          END;
        */
        Acumulado := Round(Acumulado, 0.01);
        exit(Acumulado);

    end;

    local procedure ProvisionaBonificacion(): Decimal
    var
        DiasBonific: Integer;
        Acumulado: Decimal;
    begin

        //Busqueda de todos los conceptos que cotizan para el calculo del Regalia
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Empleado."No.");
        if (ConfNomina."Registro de provision" = ConfNomina."Registro de provision"::"Bi-Semanal") or
           (ConfNomina."Registro de provision" = ConfNomina."Registro de provision"::Quincenal) then begin
            if (Tiposdenominas."Dia inicio 1ra" > Tiposdenominas."Dia inicio 2da") and (SegundaQ) and (Tiposdenominas."Tipo de nomina" = Tiposdenominas."Tipo de nomina"::Regular) then
                HistLinNom.SetRange(Período, DMY2Date(Tiposdenominas."Dia inicio 1ra", Date2DMY(CalcDate('-1M', inicial), 2), Date2DMY(CalcDate('-1M', final), 3)), final)
            else
                if (Tiposdenominas."Dia inicio 1ra" > Tiposdenominas."Dia inicio 2da") and (Tiposdenominas."Tipo de nomina" = Tiposdenominas."Tipo de nomina"::Prestaciones) then
                    HistLinNom.SetRange(Período, DMY2Date(Tiposdenominas."Dia inicio 1ra", Date2DMY(CalcDate('-1M', inicial), 2), Date2DMY(CalcDate('-1M', final), 3)), final)
                else
                    HistLinNom.SetRange(Período, inicial, final);
        end
        else
            HistLinNom.SetRange(Período, inicial, final);

        if "Cab. nómina".GetFilter("Job No.") <> '' then
            HistLinNom.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
        HistLinNom.SetFilter("Tipo de nomina", "Cab. nómina".GetFilter("Tipo de nomina"));
        HistLinNom.SetRange("Aplica para Regalia", true);
        if HistLinNom.FindSet then
            repeat
                Acumulado += HistLinNom.Total;
            until HistLinNom.Next = 0;
        //Busco los dias que tocan
        //DiasBonific := CalculoFechas.CalculoDiasBonificacion(Empleado."No.", final); Nomina

        //Reviso datos del contrato
        if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
           (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") then
            Acumulado /= 12
        else
            if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Semanal) then
                Acumulado /= 26
            else
                Acumulado /= 12;

        Acumulado /= 23.83;

        Acumulado := Acumulado * DiasBonific;
        /*
        IF DiasTranscurridos < 25 THEN
          BEGIN
            IF (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) OR
               (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") THEN
               Acumulado /= 2;
          END;
        */
        Acumulado := Round(Acumulado, 0.01);

        exit(Acumulado);

    end;


    procedure insertalindiariojOB(TmpContNom: Record "Temp Contabilizacion Nom.")
    var
        Date: Record Date;
        Date2: Record Date;
        TSH: Record "Time Sheet Header";
        TSL: Record "Time Sheet Line";
        TSD: Record "Time Sheet Detail";
        Res: Record Resource;
        ResourcesSetup: Record "Resources Setup";
        REP: Record "Relacion Empleados - Proyectos";
        DefDim: Record "Default Dimension";
        JPL: Record "Job Planning Line";
        DimMgt: Codeunit DimensionManagement;
        EsImpuesto: Boolean;
    begin
        //GRN ResourcesSetup.GET();
        //GRN Res.GET(CodRecurso);

        //EsImpuesto := FALSE;
        /*
        REP.RESET;
        REP.SETRANGE("Employee No.",TmpContNom."Cod. Empleado");
        REP.SETRANGE("Concepto salarial",TmpContNom.Concepto);
        IF NOT REP.FINDFIRST THEN
           REP.INIT;
        
        
        IF TmpContNom.Concepto = '' THEN
           REP.INIT;
        
        TiposCotizacion.RESET;
        TiposCotizacion.SETRANGE(Código,TmpContNom.Concepto);
        IF TiposCotizacion.FINDLAST THEN
           EsImpuesto := TRUE;
        */

        NumLin += 1000;
        JobJNL.Init;
        JobJNL.Validate("Journal Template Name", ConfNomina."Job Journal Template Name");
        JobJNL.Validate("Journal Batch Name", ConfNomina."Job Journal Batch Name");
        JobJNL."Line No." := NumLin;
        JobJNL.Validate("Posting Date", FechaRegistro);
        JobJNL."Account Type" := JobJNL."Account Type"::"G/L Account";
        JobJNL."Document No." := NumDoc;
        JobJNL.Validate("Account No.", TmpContNom."No. Cuenta");

        JobJNL.Validate("Job No.", TmpContNom."Job code");
        JobJNL.Validate("Job Task No.", TmpContNom."Job task");
        JobJNL."Job Line Type" := JobJNL."Job Line Type"::Billable;

        if JobJNL."Job No." <> '' then
            JobJNL.Validate("Job Quantity", 1);

        //Busco la linea de planificacion
        if TmpContNom."Job code" <> '' then begin
            JPL.Reset;
            JPL.SetRange("Job No.", TmpContNom."Job code");
            JPL.SetRange("Job Task No.", TmpContNom."Job task");
            JPL.SetRange(Type, JPL.Type::"G/L Account");
            JPL.SetRange("No.", ConfNomina."Cta. Lin. Planif. Proyectos");
            JPL.FindFirst;
            JobJNL.Validate("Job Planning Line No.", JPL."Line No.");
        end;

        if TmpContNom."Importe Db" <> 0 then
            JobJNL.Validate(Amount, TmpContNom."Importe Db")
        else
            if TmpContNom."Importe Cr" <> 0 then
                JobJNL.Validate(Amount, TmpContNom."Importe Cr" * -1)
            else
                if TmpContNom."Importe Db CK" <> 0 then
                    JobJNL.Validate(Amount, TmpContNom."Importe Db CK")
                else
                    if TmpContNom."Importe Cr CK" <> 0 then
                        JobJNL.Validate(Amount, TmpContNom."Importe Cr CK" * -1);

        if JobJNL.Insert(true) then;

        Clear(TempDimSetEntry);
        TempDimSetEntry.DeleteAll;

        //Busco DefDim del Maestro
        DefDim.Reset;
        case TmpContNom."Tipo Cuenta" of
            0: //Cuenta
                begin
                    DefDim.SetRange("Table ID", 15);
                end;
            1: //Cliente
                begin
                    DefDim.SetRange("Table ID", 18);
                end;
            2: //Proveedor
                begin
                    DefDim.SetRange("Table ID", 23);
                end;
        end;

        DefDim.SetRange("Value Posting", DefDim."Value Posting"::"Same Code");
        DefDim.SetRange("No.", TmpContNom."No. Cuenta");
        if DefDim.FindSet then
            repeat
                UpdateDimSet(DefDim."Dimension Code", DefDim."Dimension Value Code");
            until DefDim.Next = 0;

        if (TmpContNom."Cod. Dim 1" <> '') and (TmpContNom."Valor Dim 1" <> '') then begin
            UpdateDimSet(TmpContNom."Cod. Dim 1", TmpContNom."Valor Dim 1");
            if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 1" then
                JobJNL."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 1"
            else
                if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 1" then
                    JobJNL."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 1"
        end;

        if (TmpContNom."Cod. Dim 2" <> '') and (TmpContNom."Valor Dim 2" <> '') then begin
            TmpContNom.TestField("Cod. Dim 2");
            //    UpdateDimSet(TempDimSetEntry,TmpContNom."Cod. Dim 2",TmpContNom."Valor Dim 2");
            UpdateDimSet(TmpContNom."Cod. Dim 2", TmpContNom."Valor Dim 2");
            if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 2" then
                JobJNL."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 2"
            else
                if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 2" then
                    JobJNL."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 2"
        end;

        if (TmpContNom."Cod. Dim 3" <> '') and (TmpContNom."Valor Dim 3" <> '') then begin
            TmpContNom.TestField("Cod. Dim 3");
            UpdateDimSet(TmpContNom."Cod. Dim 3", TmpContNom."Valor Dim 3");
            if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 3" then
                JobJNL."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 3"
            else
                if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 3" then
                    JobJNL."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 3"
        end;

        if (TmpContNom."Cod. Dim 4" <> '') and (TmpContNom."Valor Dim 4" <> '') then begin
            TmpContNom.TestField("Cod. Dim 4");
            UpdateDimSet(TmpContNom."Cod. Dim 4", TmpContNom."Valor Dim 4");
            if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 4" then
                JobJNL."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 4"
            else
                if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 4" then
                    JobJNL."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 4"
        end;

        if (TmpContNom."Cod. Dim 5" <> '') and (TmpContNom."Valor Dim 5" <> '') then begin
            UpdateDimSet(TmpContNom."Cod. Dim 5", TmpContNom."Valor Dim 5");
            if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 5" then
                JobJNL."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 5"
            else
                if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 5" then
                    JobJNL."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 5"
        end;

        if (TmpContNom."Cod. Dim 6" <> '') and (TmpContNom."Valor Dim 6" <> '') then begin
            UpdateDimSet(TmpContNom."Cod. Dim 6", TmpContNom."Valor Dim 6");
            if ConfContabilidad."Global Dimension 1 Code" = TmpContNom."Cod. Dim 6" then
                JobJNL."Shortcut Dimension 1 Code" := TmpContNom."Valor Dim 6"
            else
                if ConfContabilidad."Global Dimension 2 Code" = TmpContNom."Cod. Dim 6" then
                    JobJNL."Shortcut Dimension 2 Code" := TmpContNom."Valor Dim 6"
        end;
        /*
        IF (TmpContNom."Cod. Dim 1" <> '') AND (TmpContNom."Valor Dim 1" <>'') THEN
          UpdateDimSet(TmpContNom."Cod. Dim 1",TmpContNom."Valor Dim 1");
        
        IF (TmpContNom."Cod. Dim 2" <> '') AND (TmpContNom."Valor Dim 2" <>'') THEN
           BEGIN
            TmpContNom.TESTFIELD("Cod. Dim 2");
        //    UpdateDimSet(TempDimSetEntry,TmpContNom."Cod. Dim 2",TmpContNom."Valor Dim 2");
            UpdateDimSet(TmpContNom."Cod. Dim 2",TmpContNom."Valor Dim 2");
           END;
        
        IF (TmpContNom."Cod. Dim 3" <> '') AND (TmpContNom."Valor Dim 3" <>'') THEN
           BEGIN
            TmpContNom.TESTFIELD("Cod. Dim 3");
            UpdateDimSet(TmpContNom."Cod. Dim 3",TmpContNom."Valor Dim 3");
           END;
        
        IF (TmpContNom."Cod. Dim 4" <> '') AND (TmpContNom."Valor Dim 4" <>'') THEN
           BEGIN
            TmpContNom.TESTFIELD("Cod. Dim 4");
            UpdateDimSet(TmpContNom."Cod. Dim 4",TmpContNom."Valor Dim 4");
           END;
        
        IF (TmpContNom."Cod. Dim 5" <> '') AND (TmpContNom."Valor Dim 5" <>'') THEN
          UpdateDimSet(TmpContNom."Cod. Dim 5",TmpContNom."Valor Dim 5");
        
        IF (TmpContNom."Cod. Dim 6" <> '') AND (TmpContNom."Valor Dim 6" <>'') THEN
          UpdateDimSet(TmpContNom."Cod. Dim 6",TmpContNom."Valor Dim 6");
        */
        if JobJNL."Job No." <> '' then begin
            //Inserto Dim del proyecto
            DefDim.Reset;
            DefDim.SetRange("Value Posting", DefDim."Value Posting"::"Same Code");
            DefDim.SetRange("No.", TmpContNom."Job code");
            if DefDim.FindSet then
                repeat
                    UpdateDimSet(DefDim."Dimension Code", DefDim."Dimension Value Code");
                until DefDim.Next = 0;
        end;

        JobJNL."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        JobJNL.Modify;

    end;


    procedure LlenaDatosCOjOB(cConceptoSal: Code[20]; iTipoCuenta: Integer; cCodCuenta: Code[20]; dImporte: Decimal; Contrapartida: Boolean; CodEmpleado: Code[20])
    var
        REP: Record "Relacion Empleados - Proyectos";
        TmpDCA: Record "Temp Contabilizacion Nom." temporary;
        NoCuenta: Code[20];
        ImporteTotalSalario: Decimal;
        ImporteTarea: Decimal;
        ImporteBase: Decimal;
        RateSalario: Decimal;
    begin
        //LlenadatosCO
        ConfNomina.TestField("Cta. Lin. Planif. Proyectos");

        Clear("Temp Contabilizacion Nom.");
        ContabNom.SetRange("Tipo Cuenta", iTipoCuenta);
        ContabNom.SetRange("No. Cuenta", cCodCuenta);
        ContabNom.SetRange(Concepto, cConceptoSal);
        ContabNom.SetRange("Forma de Cobro", "Cab. nómina"."Forma de Cobro");
        //contabnom.SETRANGE("Job code","Cab. nómina"."Job No.");
        ContabNom.SetRange(Step, 3);

        //Tabla temporal para poder calcula la distribucion de la provision
        tmpContab.SetRange("Tipo Cuenta", iTipoCuenta);
        tmpContab.SetRange("No. Cuenta", cCodCuenta);
        tmpContab.SetRange(Concepto, cConceptoSal);
        tmpContab.SetRange("Cod. Empleado", CodEmpleado);
        tmpContab.SetRange("Forma de Cobro", "Cab. nómina"."Forma de Cobro");
        //tmpcontab.SETRANGE("Job code","Cab. nómina"."Job No.");
        tmpContab.SetRange(Step, 3);

        DCA.Reset;
        DCA.SetFilter("Fecha registro", "Cab. nómina".GetFilter(Período));
        DCA.SetRange("Cod. Empleado", CodEmpleado);
        DCA.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
        if cConceptoSal = ConfNomina."Concepto Horas Ext. 100%" then
            DCA.SetFilter("Horas extras al 100", '<>%1', 0)
        else
            if cConceptoSal = ConfNomina."Concepto Horas Ext. 35%" then
                DCA.SetFilter("Horas extras al 35", '<>%1', 0)
            else
                if cConceptoSal = ConfNomina."Concepto Dias feriados" then
                    DCA.SetFilter("Horas feriadas", '<>%1', 0)
                else
                    if cConceptoSal = ConfNomina."Concepto Sal. Base" then
                        DCA.SetFilter("Horas regulares", '<>%1', 0)
                    else
                        DCA.SetFilter("Horas regulares", '999999');

        if DCA.FindSet then
            repeat
                FiltraDimSet("Cab. nómina"."Dimension Set ID", "Lín. nómina"."Dimension Set ID", CodEmpleado); //Nueva programacion

                dImporte := 0;

                PerfilSal.Reset;
                PerfilSal.SetRange("Concepto salarial", cConceptoSal);
                PerfilSal.SetRange("No. empleado", DCA."Cod. Empleado");
                PerfilSal.FindFirst;

                if not ConceptosSalariales."No distribuir en proyectos" then begin
                    ContabNom.SetRange("Job code", DCA."Job No.");
                    ContabNom.SetRange("Job task", DCA."Job Task No.");
                    tmpContab.SetRange("Job code", DCA."Job No.");
                    tmpContab.SetRange("Job task", DCA."Job Task No.");
                end;

                if (DCA."Horas extras al 100" <> 0) and (cConceptoSal = ConfNomina."Concepto Horas Ext. 100%") then begin
                    dImporte += PerfilSal.Importe * DCA."Horas extras al 100";
                end
                else
                    if (DCA."Horas extras al 35" <> 0) and (cConceptoSal = ConfNomina."Concepto Horas Ext. 35%") then begin
                        dImporte += PerfilSal.Importe * DCA."Horas extras al 35";
                    end
                    else
                        if (DCA."Horas feriadas" <> 0) and (cConceptoSal = ConfNomina."Concepto Dias feriados") then begin
                            dImporte += PerfilSal.Importe * DCA."Horas feriadas";
                        end
                        else
                            if (DCA."Horas regulares" <> 0) then begin
                                dImporte += PerfilSal.Importe * DCA."Horas regulares";
                            end;

                if ContabNom.FindFirst then begin
                    if not Contrapartida then begin
                        if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                            if dImporte > 0 then
                                ContabNom."Importe Db CK" += dImporte
                            else
                                ContabNom."Importe Cr CK" += Abs(dImporte);
                        end
                        else begin
                            if dImporte > 0 then
                                ContabNom."Importe Db" += dImporte
                            else
                                ContabNom."Importe Cr" += Abs(dImporte);
                        end;
                    end
                    else
                        if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                            if dImporte > 0 then
                                ContabNom."Importe Db CK" := dImporte
                            else
                                ContabNom."Importe Cr CK" := Abs(dImporte);

                        end
                        else begin
                            if dImporte > 0 then
                                ContabNom."Importe Db" := dImporte
                            else
                                ContabNom."Importe Cr" := Abs(dImporte);
                        end;
                end
                else begin
                    NoLin += 100;

                    Clear("Temp Contabilizacion Nom.");
                    ContabNom."Tipo Cuenta" := iTipoCuenta;
                    ContabNom."No. Cuenta" := cCodCuenta;
                    ContabNom."No. Linea" := NoLin;
                    ContabNom."Cod. Empleado" := CodEmpleado;
                    ContabNom.Concepto := cConceptoSal;
                    if not ConceptosSalariales."No distribuir en proyectos" then begin
                        ContabNom."Job code" := DCA."Job No.";
                        ContabNom."Job task" := DCA."Job Task No.";
                    end;

                    ContabNom."Forma de Cobro" := "Cab. nómina"."Forma de Cobro";
                    ContabNom.Step := 3;


                    if not ConceptosSalariales."Contabilizacion Resumida" then
                        ContabNom.Descripcion := CopyStr(Empleado."No." + ' ' + Empleado."Full Name", 1, 50)
                    else
                        ContabNom.Descripcion := ConceptosSalariales.Descripcion;

                    if not Contrapartida then begin
                        if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                            if dImporte > 0 then
                                ContabNom."Importe Db CK" += dImporte
                            else
                                ContabNom."Importe Cr CK" += Abs(dImporte);
                        end
                        else begin
                            if dImporte > 0 then
                                ContabNom."Importe Db" += dImporte
                            else
                                ContabNom."Importe Cr" += Abs(dImporte);
                        end;
                    end
                    else
                        if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                            if dImporte > 0 then
                                ContabNom."Importe Db CK" := dImporte
                            else
                                ContabNom."Importe Cr CK" := Abs(dImporte);

                        end
                        else begin
                            if dImporte > 0 then
                                ContabNom."Importe Db" := dImporte
                            else
                                ContabNom."Importe Cr" := Abs(dImporte);
                        end;
                    LlenaDimSet("Cab. nómina"."Dimension Set ID", "Lín. nómina"."Dimension Set ID"); //Nueva programacion

                end;

                if dImporte <> 0 then begin
                    if not ContabNom.Insert then
                        ContabNom.Modify;
                end;
                if tmpContab.FindFirst then begin
                    if not Contrapartida then begin
                        if dImporte > 0 then
                            tmpContab."Importe Db" += dImporte
                        else
                            tmpContab."Importe Cr" += Abs(dImporte);
                    end
                    else begin
                        if dImporte > 0 then
                            tmpContab."Importe Cr" += dImporte
                        else
                            tmpContab."Importe Db" += Abs(dImporte);
                    end;
                end
                else begin
                    NoLin += 100;

                    Clear("Temp Contabilizacion Nom.");
                    tmpContab."Tipo Cuenta" := iTipoCuenta;
                    tmpContab."No. Cuenta" := cCodCuenta;
                    tmpContab."No. Linea" := NoLin;
                    tmpContab."Cod. Empleado" := CodEmpleado;
                    tmpContab.Concepto := cConceptoSal;
                    if not ConceptosSalariales."No distribuir en proyectos" then begin
                        tmpContab."Job code" := DCA."Job No.";
                        tmpContab."Job task" := DCA."Job Task No.";
                    end;
                    tmpContab."Forma de Cobro" := "Cab. nómina"."Forma de Cobro";
                    tmpContab.Step := 3;

                    if not ConceptosSalariales."Contabilizacion Resumida" then
                        tmpContab.Descripcion := CopyStr(Empleado."No." + ' ' + Empleado."Full Name", 1, 50)
                    else
                        tmpContab.Descripcion := ConceptosSalariales.Descripcion;

                    if not Contrapartida then begin
                        if dImporte > 0 then
                            tmpContab."Importe Db" := dImporte
                        else
                            tmpContab."Importe Cr" := Abs(dImporte);
                    end
                    else begin
                        if dImporte > 0 then
                            tmpContab."Importe Cr" := dImporte
                        else
                            tmpContab."Importe Db" := Abs(dImporte);
                    end;
                end;
                if dImporte <> 0 then begin
                    if not tmpContab.Insert then
                        tmpContab.Modify;
                end;
            until DCA.Next = 0

        else
            if not ConceptosSalariales."No distribuir en proyectos" then begin
                ImporteTotalSalario := 0;
                RateSalario := 0;
                ImporteTarea := 0;
                ImporteBase := dImporte;

                //Busco el total del ingreso por concepto de salario para tener estimacion del % a distribuir por tarea
                HistLinNom.Reset;
                HistLinNom.SetRange("No. empleado", "Cab. nómina"."No. empleado");
                HistLinNom.SetRange(Período, inicial, final);
                HistLinNom.SetRange("Salario Base", true);
                HistLinNom.SetRange("Tipo Nómina", "Cab. nómina"."Tipo Nomina");
                HistLinNom.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
                if HistLinNom.FindSet then
                    repeat
                        ImporteTotalSalario := HistLinNom.Total;
                        RateSalario := HistLinNom."Importe Base";
                    until HistLinNom.Next = 0;

                //Busco todas las combinaciones de proyectos y tareas para el empleado
                TmpDCA.DeleteAll;

                DCA.Reset;
                DCA.SetRange("Fecha registro", inicial, final);
                DCA.SetRange("Cod. Empleado", "Cab. nómina"."No. empleado");
                DCA.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
                DCA.SetFilter("Horas regulares", '>%1', 0);
                //IF DCA.FINDSET THEN
                DCA.FindSet;
                repeat
                    TmpDCA.Reset;
                    TmpDCA.SetRange("Cod. Empleado", DCA."Cod. Empleado");
                    if not ConceptosSalariales."No distribuir en proyectos" then begin
                        TmpDCA.SetRange("Valor Dim 2", DCA."Job No.");
                        TmpDCA.SetRange("Valor Dim 3", DCA."Job Task No.");
                    end;

                    if TmpDCA.FindFirst then
                        TmpDCA.Importe += DCA."Horas regulares" * RateSalario
                    else begin
                        TmpDCA.Init;
                        TmpDCA."Cod. Empleado" := DCA."Cod. Empleado";
                        if not ConceptosSalariales."No distribuir en proyectos" then begin
                            TmpDCA."Valor Dim 2" := DCA."Job No.";
                            TmpDCA."Valor Dim 3" := DCA."Job Task No.";
                            TmpDCA.Importe += DCA."Horas regulares" * RateSalario;
                        end;
                    end;
                    if not TmpDCA.Insert then
                        TmpDCA.Modify;
                until DCA.Next = 0;
                //Para distribuir Importe
                TmpDCA.Reset;
                TmpDCA.Find('-');
                repeat
                    ContabNom.Reset;
                    ContabNom.SetRange("Tipo Cuenta", iTipoCuenta);
                    ContabNom.SetRange("No. Cuenta", cCodCuenta);
                    ContabNom.SetRange(Concepto, cConceptoSal);
                    ContabNom.SetRange("Forma de Cobro", "Cab. nómina"."Forma de Cobro");
                    ContabNom.SetFilter("Job code", "Cab. nómina".GetFilter("Job No."));

                    ContabNom.SetRange(Step, 3);

                    FiltraDimSet("Cab. nómina"."Dimension Set ID", "Lín. nómina"."Dimension Set ID", CodEmpleado); //Nueva programacion
                    PerfilSal.Reset;
                    PerfilSal.SetRange("Concepto salarial", cConceptoSal);
                    PerfilSal.SetRange("No. empleado", CodEmpleado);
                    PerfilSal.FindFirst;

                    ImporteTarea := TmpDCA.Importe / ImporteTotalSalario; //Represento el % sobre el ingreso total
                    dImporte := ImporteBase * ImporteTarea; //Calculo la proporcion que toca a este prorrateo

                    if not ConceptosSalariales."No distribuir en proyectos" then begin
                        ContabNom.SetRange("Job code", TmpDCA."Valor Dim 2");
                        ContabNom.SetRange("Job task", TmpDCA."Valor Dim 3");
                    end;

                    if ContabNom.FindFirst then begin
                        if not Contrapartida then begin
                            if dImporte > 0 then
                                ContabNom."Importe Db" += dImporte
                            else
                                ContabNom."Importe Cr" += Abs(dImporte);
                        end
                        else begin
                            if dImporte > 0 then
                                ContabNom."Importe Cr" += dImporte
                            else
                                ContabNom."Importe Db" += Abs(dImporte);
                        end;
                    end
                    else begin
                        NoLin += 100;

                        Clear("Temp Contabilizacion Nom.");
                        ContabNom."Tipo Cuenta" := iTipoCuenta;
                        ContabNom."No. Cuenta" := cCodCuenta;
                        ContabNom."No. Linea" := NoLin;
                        ContabNom."Cod. Empleado" := CodEmpleado;
                        ContabNom.Concepto := cConceptoSal;
                        ContabNom."Forma de Cobro" := "Cab. nómina"."Forma de Cobro";
                        if not ConceptosSalariales."No distribuir en proyectos" then begin
                            ContabNom."Job code" := TmpDCA."Valor Dim 2";
                            ContabNom."Job task" := TmpDCA."Valor Dim 3";
                        end;
                        ContabNom.Step := 3;

                        if not ConceptosSalariales."Contabilizacion Resumida" then
                            ContabNom.Descripcion := CopyStr(Empleado."No." + ' ' + Empleado."Full Name", 1, 50)
                        else
                            ContabNom.Descripcion := ConceptosSalariales.Descripcion;

                        if not Contrapartida then begin
                            if dImporte > 0 then
                                ContabNom."Importe Db" := dImporte
                            else
                                ContabNom."Importe Cr" := Abs(dImporte);
                        end
                        else begin
                            if dImporte > 0 then
                                ContabNom."Importe Cr" := dImporte
                            else
                                ContabNom."Importe Db" := Abs(dImporte);
                        end;

                        LlenaDimSet("Cab. nómina"."Dimension Set ID", "Lín. nómina"."Dimension Set ID");
                    end;
                    if dImporte <> 0 then begin
                        if not ContabNom.Insert then
                            ContabNom.Modify;
                    end;
                until TmpDCA.Next = 0;
            end
            else begin
                FiltraDimSet("Cab. nómina"."Dimension Set ID", "Lín. nómina"."Dimension Set ID", CodEmpleado); //Nueva programacion
                                                                                                               //    contabnom.FINDFIRST;
                if ContabNom.FindFirst then
                    LlenaTempExiste(Contrapartida, dImporte)
                else
                    LlenaTempNOExiste(iTipoCuenta, cCodCuenta, CodEmpleado, Contrapartida, dImporte, cConceptoSal, 3);
            end;
    end;


    procedure InsertaProvisionJob(ConceptoSal: Code[20]; ImportProrr: Decimal)
    var
        CSP: Record "Conceptos Salariales Provision";
        TmpDCA: Record "Temp Contabilizacion Nom." temporary;
        NoCuenta: Code[20];
        ImporteTotalSalario: Decimal;
        ImporteTarea: Decimal;
    begin
        //Del Diario de pagos
        ConceptosSalariales.Get(ConceptoSal);
        //Del Histórico de Nominas
        if GpoContEmpl.Get(Empleado."Posting Group") then begin
            ConfGpoContEmpl.SetRange(Código, GpoContEmpl.Código);
            ConfGpoContEmpl.SetRange("Código Concepto Salarial", ConceptoSal);
            if ConfGpoContEmpl.FindFirst then begin
                ConfGpoContEmpl.TestField("No. Cuenta Cuota Obrera");
                NoCuenta := ConfGpoContEmpl."No. Cuenta Cuota Obrera";
                case ConfGpoContEmpl."Tipo Cuenta Cuota Obrera" of
                    0:
                        TipoCta := 0;
                    else
                        TipoCta := 2;
                end;

                if (ConceptosSalariales."Validar Contrapartida CO") and (not ConfGpoContEmpl.Provisionar) then begin
                    ConfGpoContEmpl.TestField("No. Cuenta Contrapartida CO");
                    case ConfGpoContEmpl."Tipo Cuenta Contrapartida CO" of
                        0:
                            TipoContrapartida := 0;
                        else
                            TipoContrapartida := 2;
                    end;

                    NoCuentaContrapartida := ConfGpoContEmpl."No. Cuenta Contrapartida CO";
                end;

                if ConfGpoContEmpl.Provisionar then begin
                    "Conceptos Salariales Provision".TestField("No. Cuenta");
                    NoCuenta := "Conceptos Salariales Provision"."No. Cuenta";

                    CSP.Reset;
                    CSP.SetRange(Código, ConceptoSal);
                    CSP.SetRange("Gpo. Contable Empleado", ConfGpoContEmpl.Código);
                    if CSP.FindFirst then begin
                        CSP.TestField("No. Cuenta");
                        NoCuenta := CSP."No. Cuenta";
                        TipoCta := 0;
                        ConceptosSalariales."Validar Contrapartida CO" := CSP."Validar Contrapartida";
                        if CSP."Validar Contrapartida" then begin
                            CSP.TestField("No. Cuenta Contrapartida");
                            TipoContrapartida := 0;
                            NoCuentaContrapartida := CSP."No. Cuenta Contrapartida";
                        end;
                    end;

                end;
            end
            else begin
                case ConceptosSalariales."Tipo Cuenta Cuota Obrera" of
                    0:
                        TipoCta := 0;
                    1:
                        TipoCta := 1;
                    else
                        TipoCta := 2;
                end;

                if TipoCta <> 1 then //Cliente
                   begin
                    ConceptosSalariales.TestField("No. Cuenta Cuota Obrera");
                    NoCuenta := ConceptosSalariales."No. Cuenta Cuota Obrera";
                end;

                if ConceptosSalariales."Validar Contrapartida CO" then begin
                    ConceptosSalariales.TestField("No. Cuenta Contrapartida CO");
                    case ConceptosSalariales."Tipo Cuenta Contrapartida CO" of
                        0:
                            TipoContrapartida := 0;
                        else
                            TipoContrapartida := 2;
                    end;

                    NoCuentaContrapartida := ConceptosSalariales."No. Cuenta Contrapartida CO";
                end;
            end;
        end
        else begin
            case ConceptosSalariales."Tipo Cuenta Cuota Obrera" of
                0:
                    TipoCta := 0;
                1:
                    TipoCta := 1;
                else
                    TipoCta := 2;
            end;

            if TipoCta <> 1 then //Cliente
               begin
                "Conceptos Salariales Provision".TestField("No. Cuenta");
                NoCuenta := "Conceptos Salariales Provision"."No. Cuenta";
            end;

            if "Conceptos Salariales Provision"."Validar Contrapartida" then begin
                "Conceptos Salariales Provision".TestField("No. Cuenta Contrapartida");
                TipoContrapartida := 0;
                NoCuentaContrapartida := "Conceptos Salariales Provision"."No. Cuenta Contrapartida";
            end;
        end;

        if NoCuenta = '' then
            Error(Err002);

        ImporteTotalSalario := 0;
        ImporteTarea := 0;

        //Busco el total del ingreso por concepto de salario para tener estimacion del % a distribuir por tarea
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", "Cab. nómina"."No. empleado");
        HistLinNom.SetRange(Período, inicial, final);
        HistLinNom.SetRange("Salario Base", true);
        HistLinNom.SetRange("Tipo Nómina", "Cab. nómina"."Tipo Nomina");
        HistLinNom.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
        if HistLinNom.FindSet then
            repeat
                ImporteTotalSalario := HistLinNom.Total;
            until HistLinNom.Next = 0;

        //Busco todas las combinaciones de proyectos y tareas para el empleado
        TmpDCA.DeleteAll;

        DCA.Reset;
        DCA.SetRange("Fecha registro", inicial, final);
        DCA.SetRange("Cod. Empleado", "Cab. nómina"."No. empleado");
        DCA.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
        DCA.SetFilter("Horas regulares", '>%1', 0);
        //IF DCA.FINDSET THEN
        DCA.FindSet;
        repeat
            TmpDCA.Init;
            TmpDCA."Cod. Empleado" := DCA."Cod. Empleado";
            TmpDCA."Valor Dim 2" := DCA."Job No.";
            TmpDCA."Valor Dim 3" := DCA."Job Task No.";
            if TmpDCA.Insert then;
        until DCA.Next = 0;

        //Para distribuir Importe
        TmpDCA.Find('-');
        repeat
            tmpContab.Reset;
            tmpContab.SetRange("Cod. Empleado", "Cab. nómina"."No. empleado");
            tmpContab.SetRange(Concepto, ConfNomina."Concepto Sal. Base");
            tmpContab.SetRange("Job code", TmpDCA."Valor Dim 2");
            tmpContab.SetRange("Job task", TmpDCA."Valor Dim 3");
            tmpContab.FindFirst;

            ImporteTarea := (tmpContab."Importe Db" + tmpContab."Importe Db CK") / ImporteTotalSalario; //Represento el % sobre el ingreso total
            ImporteTarea := ImportProrr * ImporteTarea; //Calculo la proporcion que toca a este prorrateo


            LlenaDatosProvisionJOB(ConceptoSal, TipoCta, NoCuenta, ImporteTarea, false,
                                      "Cab. nómina"."No. empleado", tmpContab."Job code", tmpContab."Job task");
            if ConceptosSalariales."Validar Contrapartida CO" then
                LlenaDatosProvisionJOB(ConceptoSal, TipoContrapartida, NoCuentaContrapartida, ImporteTarea * -1, true,
                                 "Cab. nómina"."No. empleado", '', '');

        until TmpDCA.Next = 0;
    end;


    procedure LlenaDatosProvisionJOB(cConceptoSal: Code[20]; iTipoCuenta: Integer; cCodCuenta: Code[20]; dImporte: Decimal; Contrapartida: Boolean; CodEmpleado: Code[20]; JobNo: Code[20]; JobTask: Code[20])
    var
        REP: Record "Relacion Empleados - Proyectos";
    begin
        //LlenadatosCO
        ConfNomina.TestField("Cta. Lin. Planif. Proyectos");

        Clear("Temp Contabilizacion Nom.");
        ContabNom.SetRange("Tipo Cuenta", iTipoCuenta);
        ContabNom.SetRange("No. Cuenta", cCodCuenta);
        ContabNom.SetRange("Forma de Cobro", "Cab. nómina"."Forma de Cobro");
        ContabNom.SetRange("Job code", JobNo);
        ContabNom.SetRange("Job task", JobTask);
        ContabNom.SetRange(Concepto, cConceptoSal);
        ContabNom.SetRange("Cod. Empleado", CodEmpleado);
        ContabNom.SetRange(Step, 3);

        if ContabNom.FindFirst then begin
            if not Contrapartida then begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" += dImporte
                    else
                        ContabNom."Importe Cr CK" += Abs(dImporte);
                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" += dImporte
                    else
                        ContabNom."Importe Cr" += Abs(dImporte);
                end;
            end
            else begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" += dImporte
                    else
                        ContabNom."Importe Cr CK" += Abs(dImporte);
                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" += dImporte
                    else
                        ContabNom."Importe Cr" += Abs(dImporte);
                end;
            end;
        end
        else begin
            NoLin += 100;
            Clear("Temp Contabilizacion Nom.");
            ContabNom."Tipo Cuenta" := iTipoCuenta;
            ContabNom."No. Cuenta" := cCodCuenta;
            ContabNom."No. Linea" := NoLin;
            ContabNom."Cod. Empleado" := CodEmpleado;
            ContabNom.Step := 3;
            ContabNom."Job code" := JobNo;
            ContabNom."Job task" := JobTask;
            ContabNom.Contrapartida := Contrapartida;
            ContabNom.Concepto := cConceptoSal;
            ContabNom."Forma de Cobro" := "Cab. nómina"."Forma de Cobro";

            if not ConceptosSalariales."Contabilizacion Resumida" then
                ContabNom.Descripcion := CopyStr(Empleado."No." + ' ' + Empleado."Full Name", 1, 50)
            else
                ContabNom.Descripcion := ConceptosSalariales.Descripcion;

            if not Contrapartida then begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" := dImporte
                    else
                        ContabNom."Importe Cr CK" := Abs(dImporte);
                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" := dImporte
                    else
                        ContabNom."Importe Cr" := Abs(dImporte);
                end;
            end
            else begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" := dImporte
                    else
                        ContabNom."Importe Cr CK" := Abs(dImporte);

                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" := dImporte
                    else
                        ContabNom."Importe Cr" := Abs(dImporte);
                end;
            end;

            recDimSet.Reset;
            //    recDimSet.SETFILTER("Dimension Set ID",'%1|%2',"Cab. nómina"."Dimension Set ID",DimSetId);
            recDimSet.SetFilter("Dimension Set ID", '%1|%2', "Cab. nómina"."Dimension Set ID", HistLinNom."Dimension Set ID");
            if recDimSet.FindSet() then
                repeat
                    if ConceptosSalariales."Contabilizacion x Dimension" then begin
                        if recDimSet."Dimension Code" = CodDim[1] then begin
                            ContabNom."Cod. Dim 1" := recDimSet."Dimension Code";
                            ContabNom."Valor Dim 1" := recDimSet."Dimension Value Code";
                        end
                        else
                            if recDimSet."Dimension Code" = CodDim[2] then begin
                                ContabNom."Cod. Dim 2" := recDimSet."Dimension Code";
                                ContabNom."Valor Dim 2" := recDimSet."Dimension Value Code";
                            end
                            else
                                if recDimSet."Dimension Code" = CodDim[3] then begin
                                    ContabNom."Cod. Dim 3" := recDimSet."Dimension Code";
                                    ContabNom."Valor Dim 3" := recDimSet."Dimension Value Code";
                                end
                                else
                                    if recDimSet."Dimension Code" = CodDim[4] then begin
                                        ContabNom."Cod. Dim 4" := recDimSet."Dimension Code";
                                        ContabNom."Valor Dim 4" := recDimSet."Dimension Value Code";
                                    end
                                    else
                                        if recDimSet."Dimension Code" = CodDim[5] then begin
                                            ContabNom."Cod. Dim 5" := recDimSet."Dimension Code";
                                            ContabNom."Valor Dim 5" := recDimSet."Dimension Value Code";
                                        end
                                        else
                                            if recDimSet."Dimension Code" = CodDim[6] then begin
                                                ContabNom."Cod. Dim 6" := recDimSet."Dimension Code";
                                                ContabNom."Valor Dim 6" := recDimSet."Dimension Value Code";
                                            end;
                        ContabNom."Dimension Set ID" := recDimSet."Dimension Set ID";
                    end;
                until recDimSet.Next = 0
        end;

        //   MESSAGE('%1 %2 %3 %4',cConceptoSal,contabnom."Valor Dim 4",ConceptosSalariales.Prorratear);
        //MESSAGE('%1',"Temp Contabilizacion Nom.");
        if ConceptosSalariales.Provisionar then begin
            for i := 1 to 6 do begin
                if ConfNomina."Dimension Conceptos Salariales" = CodDim[i] then begin
                    if ContabNom."Cod. Dim 1" = CodDim[i] then
                        ContabNom."Valor Dim 1" := cConceptoSal
                    else
                        if ContabNom."Cod. Dim 2" = CodDim[i] then
                            ContabNom."Valor Dim 2" := cConceptoSal
                        else
                            if ContabNom."Cod. Dim 3" = CodDim[i] then
                                ContabNom."Valor Dim 3" := cConceptoSal
                            else
                                if ContabNom."Cod. Dim 4" = CodDim[i] then
                                    ContabNom."Valor Dim 4" := cConceptoSal
                                else
                                    if ContabNom."Cod. Dim 5" = CodDim[i] then
                                        ContabNom."Valor Dim 5" := cConceptoSal
                                    else
                                        if ContabNom."Cod. Dim 6" = CodDim[i] then
                                            ContabNom."Valor Dim 6" := cConceptoSal;
                end;
            end;
        end;
        //Para las Dim del perfil de salario (linea del concepto salarial)
        //Para las Dim por Grupo contable
        DefDim.Reset;
        DefDim.SetFilter("Table ID", '%1|%2|%3', 76053, 76062, 76061);
        if Empleado."Posting Group" <> '' then
            DefDim.SetFilter("No.", Empleado."Posting Group" + '*' + cConceptoSal + '*')
        else
            DefDim.SetFilter("No.", '*' + cConceptoSal + '*');
        if DefDim.FindSet then
            repeat
                // ERROR('%1\%2',DefDim.GETFILTERS,DefDim);
                if CodDim[1] = DefDim."Dimension Code" then begin
                    ContabNom."Cod. Dim 1" := DefDim."Dimension Code";
                    ContabNom."Valor Dim 1" := DefDim."Dimension Value Code";
                end
                else
                    if CodDim[2] = DefDim."Dimension Code" then begin
                        ContabNom."Cod. Dim 2" := DefDim."Dimension Code";
                        ContabNom."Valor Dim 2" := DefDim."Dimension Value Code";
                    end
                    else
                        if CodDim[3] = DefDim."Dimension Code" then begin
                            ContabNom."Cod. Dim 3" := DefDim."Dimension Code";
                            ContabNom."Valor Dim 3" := DefDim."Dimension Value Code";
                        end
                        else
                            if CodDim[4] = DefDim."Dimension Code" then begin
                                ContabNom."Cod. Dim 4" := DefDim."Dimension Code";
                                ContabNom."Valor Dim 4" := DefDim."Dimension Value Code";
                            end
                            else
                                if CodDim[5] = DefDim."Dimension Code" then begin
                                    ContabNom."Cod. Dim 5" := DefDim."Dimension Code";
                                    ContabNom."Valor Dim 5" := DefDim."Dimension Value Code";
                                end
                                else
                                    if CodDim[6] = DefDim."Dimension Code" then begin
                                        ContabNom."Cod. Dim 6" := DefDim."Dimension Code";
                                        ContabNom."Valor Dim 6" := DefDim."Dimension Value Code";
                                    end;
            until DefDim.Next = 0;

        if not ContabNom.Insert then
            ContabNom.Modify;
    end;


    procedure LlenaDatosDescJob(cConceptoSal: Code[20]; iTipoCuenta: Integer; cCodCuenta: Code[20]; dImporte: Decimal; Contrapartida: Boolean; CodEmpleado: Code[20]; JobNo: Code[20]; JobTask: Code[20]; Paso: Integer; DimSetId: Integer)
    begin
        //LlenadatosCOJOB
        Clear("Temp Contabilizacion Nom.");
        ContabNom.SetRange("Tipo Cuenta", iTipoCuenta);
        ContabNom.SetRange("No. Cuenta", cCodCuenta);
        ContabNom.SetRange("Forma de Cobro", "Cab. nómina"."Forma de Cobro");
        ContabNom.SetRange("Job code", JobNo);
        ContabNom.SetRange("Job task", JobTask);
        ContabNom.SetRange(Step, Paso);

        recDimSet.Reset;
        recDimSet.SetFilter("Dimension Set ID", '%1|%2', "Cab. nómina"."Dimension Set ID", DimSetId);
        if recDimSet.FindSet() then
            repeat
                if ConceptosSalariales."Contabilizacion x Dimension" then begin
                    if recDimSet."Dimension Code" = CodDim[1] then begin
                        ContabNom.SetRange("Cod. Dim 1", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 1", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[2] then begin
                        ContabNom.SetRange("Cod. Dim 2", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 2", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[3] then begin
                        ContabNom.SetRange("Cod. Dim 3", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 3", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[4] then begin
                        ContabNom.SetRange("Cod. Dim 4", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 4", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[5] then begin
                        ContabNom.SetRange("Cod. Dim 5", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 5", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[6] then begin
                        ContabNom.SetRange("Cod. Dim 6", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 6", recDimSet."Dimension Value Code");
                    end;
                    if not ConceptosSalariales."Contabilizacion Resumida" then
                        ContabNom.SetRange("Cod. Empleado", CodEmpleado);

                end;
            until recDimSet.Next = 0;

        if ContabNom.FindFirst then begin
            if not Contrapartida then begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" += dImporte
                    else
                        ContabNom."Importe Cr CK" += Abs(dImporte);
                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" += dImporte
                    else
                        ContabNom."Importe Cr" += Abs(dImporte);
                end;
            end
            else begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" += dImporte
                    else
                        ContabNom."Importe Cr CK" += Abs(dImporte);
                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" += dImporte
                    else
                        ContabNom."Importe Cr" += Abs(dImporte);
                end;
            end;
        end
        else begin
            NoLin += 100;

            Clear("Temp Contabilizacion Nom.");
            ContabNom."Tipo Cuenta" := iTipoCuenta;
            ContabNom."No. Cuenta" := cCodCuenta;
            ContabNom."No. Linea" := NoLin;
            ContabNom."Cod. Empleado" := CodEmpleado;
            ContabNom.Step := Paso;
            ContabNom."Job code" := JobNo;
            ContabNom."Job task" := JobTask;
            ContabNom."Forma de Cobro" := "Cab. nómina"."Forma de Cobro";
            ContabNom.Concepto := cConceptoSal;
            ContabNom.Contrapartida := Contrapartida;
            if not ConceptosSalariales."Contabilizacion Resumida" then
                ContabNom.Descripcion := CopyStr(Empleado."No." + ' ' + Empleado."Full Name", 1, 50)
            else
                ContabNom.Descripcion := ConceptosSalariales.Descripcion;

            if not Contrapartida then begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" := dImporte
                    else
                        ContabNom."Importe Cr CK" := Abs(dImporte);
                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" := dImporte
                    else
                        ContabNom."Importe Cr" := Abs(dImporte);
                end;
            end
            else begin
                if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                    if dImporte > 0 then
                        ContabNom."Importe Db CK" := dImporte
                    else
                        ContabNom."Importe Cr CK" := Abs(dImporte);

                end
                else begin
                    if dImporte > 0 then
                        ContabNom."Importe Db" := dImporte
                    else
                        ContabNom."Importe Cr" := Abs(dImporte);
                end;
            end;

            recDimSet.Reset;
            recDimSet.SetFilter("Dimension Set ID", '%1|%2', "Cab. nómina"."Dimension Set ID", DimSetId);
            if recDimSet.FindSet() then
                repeat
                    if ConceptosSalariales."Contabilizacion x Dimension" then begin
                        if recDimSet."Dimension Code" = CodDim[1] then begin
                            ContabNom."Cod. Dim 1" := recDimSet."Dimension Code";
                            ContabNom."Valor Dim 1" := recDimSet."Dimension Value Code";
                        end
                        else
                            if recDimSet."Dimension Code" = CodDim[2] then begin
                                ContabNom."Cod. Dim 2" := recDimSet."Dimension Code";
                                ContabNom."Valor Dim 2" := recDimSet."Dimension Value Code";
                            end
                            else
                                if recDimSet."Dimension Code" = CodDim[3] then begin
                                    ContabNom."Cod. Dim 3" := recDimSet."Dimension Code";
                                    ContabNom."Valor Dim 3" := recDimSet."Dimension Value Code";
                                end
                                else
                                    if recDimSet."Dimension Code" = CodDim[4] then begin
                                        ContabNom."Cod. Dim 4" := recDimSet."Dimension Code";
                                        ContabNom."Valor Dim 4" := recDimSet."Dimension Value Code";
                                    end
                                    else
                                        if recDimSet."Dimension Code" = CodDim[5] then begin
                                            ContabNom."Cod. Dim 5" := recDimSet."Dimension Code";
                                            ContabNom."Valor Dim 5" := recDimSet."Dimension Value Code";
                                        end
                                        else
                                            if recDimSet."Dimension Code" = CodDim[6] then begin
                                                ContabNom."Cod. Dim 6" := recDimSet."Dimension Code";
                                                ContabNom."Valor Dim 6" := recDimSet."Dimension Value Code";
                                            end;
                        ContabNom."Dimension Set ID" := recDimSet."Dimension Set ID";
                    end;
                until recDimSet.Next = 0
        end;

        //   MESSAGE('%1 %2 %3 %4',cConceptoSal,contabnom."Valor Dim 4",ConceptosSalariales.Prorratear);
        //MESSAGE('%1',"Temp Contabilizacion Nom.");
        if ConceptosSalariales.Provisionar then begin
            for i := 1 to 6 do begin
                if ConfNomina."Dimension Conceptos Salariales" = CodDim[i] then begin
                    if ContabNom."Cod. Dim 1" = CodDim[i] then
                        ContabNom."Valor Dim 1" := cConceptoSal
                    else
                        if ContabNom."Cod. Dim 2" = CodDim[i] then
                            ContabNom."Valor Dim 2" := cConceptoSal
                        else
                            if ContabNom."Cod. Dim 3" = CodDim[i] then
                                ContabNom."Valor Dim 3" := cConceptoSal
                            else
                                if ContabNom."Cod. Dim 4" = CodDim[i] then
                                    ContabNom."Valor Dim 4" := cConceptoSal
                                else
                                    if ContabNom."Cod. Dim 5" = CodDim[i] then
                                        ContabNom."Valor Dim 5" := cConceptoSal
                                    else
                                        if ContabNom."Cod. Dim 6" = CodDim[i] then
                                            ContabNom."Valor Dim 6" := cConceptoSal;
                end;
            end;
        end;
        //Para las Dim del perfil de salario (linea del concepto salarial)
        //Para las Dim por Grupo contable
        DefDim.Reset;
        DefDim.SetFilter("Table ID", '%1|%2|%3', 76053, 76062, 76061);
        if Empleado."Posting Group" <> '' then
            DefDim.SetFilter("No.", Empleado."Posting Group" + '*' + cConceptoSal + '*')
        else
            DefDim.SetFilter("No.", '*' + cConceptoSal + '*');
        if DefDim.FindSet then
            repeat
                if CodDim[1] = DefDim."Dimension Code" then begin
                    ContabNom."Cod. Dim 1" := DefDim."Dimension Code";
                    ContabNom."Valor Dim 1" := DefDim."Dimension Value Code";
                end
                else
                    if CodDim[2] = DefDim."Dimension Code" then begin
                        ContabNom."Cod. Dim 2" := DefDim."Dimension Code";
                        ContabNom."Valor Dim 2" := DefDim."Dimension Value Code";
                    end
                    else
                        if CodDim[3] = DefDim."Dimension Code" then begin
                            ContabNom."Cod. Dim 3" := DefDim."Dimension Code";
                            ContabNom."Valor Dim 3" := DefDim."Dimension Value Code";
                        end
                        else
                            if CodDim[4] = DefDim."Dimension Code" then begin
                                ContabNom."Cod. Dim 4" := DefDim."Dimension Code";
                                ContabNom."Valor Dim 4" := DefDim."Dimension Value Code";
                            end
                            else
                                if CodDim[5] = DefDim."Dimension Code" then begin
                                    ContabNom."Cod. Dim 5" := DefDim."Dimension Code";
                                    ContabNom."Valor Dim 5" := DefDim."Dimension Value Code";
                                end
                                else
                                    if CodDim[6] = DefDim."Dimension Code" then begin
                                        ContabNom."Cod. Dim 6" := DefDim."Dimension Code";
                                        ContabNom."Valor Dim 6" := DefDim."Dimension Value Code";
                                    end;
            until DefDim.Next = 0;

        if not ContabNom.Insert then
            ContabNom.Modify;
    end;


    procedure InsertaContrapartidaCOJob(TmpContNomCont: Record "Temp Contabilizacion Nom.")
    begin
        // GRN Graba contrapartida por el neto para pagos transferencias
        TmpContNomCont."Importe Db" := Round(TmpContNomCont."Importe Db", Divisa."Amount Rounding Precision");
        TmpContNomCont."Importe Cr" := Round(TmpContNomCont."Importe Cr", Divisa."Amount Rounding Precision");
        TmpContNomCont."Importe Db CK" := Round(TmpContNomCont."Importe Db CK", Divisa."Amount Rounding Precision");
        TmpContNomCont."Importe Cr CK" := Round(TmpContNomCont."Importe Cr CK", Divisa."Amount Rounding Precision");

        if (TmpContNomCont."Importe Db" <> 0) or (TmpContNomCont."Importe Cr" <> 0) then begin
            ConfNomina.TestField("Cód. Cta. Nominas Pago Transf.");
            NumLin += 1000;

            JobJNL.Init;
            JobJNL.Validate("Journal Template Name", ConfNomina."Job Journal Template Name");
            JobJNL.Validate("Journal Batch Name", ConfNomina."Job Journal Batch Name");
            JobJNL."Line No." := NumLin;
            JobJNL.Validate("Posting Date", FechaRegistro);
            JobJNL."Document No." := NumDoc;
            JobJNL."Account Type" := JobJNL."Account Type"::"G/L Account";
            JobJNL.Validate("Account No.", ConfNomina."Cód. Cta. Nominas Pago Transf.");

            //    JobJNL.VALIDATE(Quantity,1);
            JobJNL."Credit Amount" := Round(TmpContNomCont."Importe Db" - TmpContNomCont."Importe Cr",
                                                        Divisa."Amount Rounding Precision");
            JobJNL.Validate("Credit Amount");
            //    IF JobJNL.INSERT(TRUE) THEN;
            JobJNL.Insert(true);

        end;

        //ERROR('a%1 b%2 c%3 d%4',TmpContNomCont."Importe Db", TmpContNomCont."Importe Cr",TmpContNomCont."Importe Db ck", TmpContNomCont."Importe Cr ck");
        // GRN Graba contrapartida por el neto para pagos diferentes transferencias
        GenJnlLine.Init;
        if (TmpContNomCont."Importe Db CK" <> 0) or (TmpContNomCont."Importe Cr CK" <> 0) then begin
            ConfNomina.TestField(ConfNomina."Cta. Nominas Otros Pagos");
            NumLin += 1000;
            JobJNL.Init;
            JobJNL.Validate("Journal Template Name", ConfNomina."Job Journal Template Name");
            JobJNL.Validate("Journal Batch Name", ConfNomina."Job Journal Batch Name");
            JobJNL."Line No." := NumLin;
            JobJNL.Validate("Posting Date", FechaRegistro);
            JobJNL."Account Type" := JobJNL."Account Type"::"G/L Account";
            JobJNL."Document No." := NumDoc;
            JobJNL.Validate("Account No.", ConfNomina."Cta. Nominas Otros Pagos");
            JobJNL.Description := Text001;
            JobJNL."Credit Amount" := Round(TmpContNomCont."Importe Db CK" - TmpContNomCont."Importe Cr CK",
                                                        Divisa."Amount Rounding Precision");

            JobJNL.Validate("Credit Amount");
            JobJNL.Insert(true);
        end;
    end;


    procedure InsertaContrapartidaCPJob(TmpContNomCont: Record "Temp Contabilizacion Nom.")
    begin
        // GRN Graba contrapartida por el neto para pagos transferencias
        /*
            error('dbck %1   crck %2   db %3   cr %4',TmpContNomCont."Importe Db",TmpContNomCont."Importe Cr",
            TmpContNomCont."Importe Db CK",TmpContNomCont."Importe Cr CK");
        */
        TmpContNomCont."Importe Db" := Round(TmpContNomCont."Importe Db", Divisa."Amount Rounding Precision");
        TmpContNomCont."Importe Cr" := Round(TmpContNomCont."Importe Cr", Divisa."Amount Rounding Precision");
        TmpContNomCont."Importe Db CK" := Round(TmpContNomCont."Importe Db CK", Divisa."Amount Rounding Precision");
        TmpContNomCont."Importe Cr CK" := Round(TmpContNomCont."Importe Cr CK", Divisa."Amount Rounding Precision");

        JobJNL.Init;
        if ((TmpContNomCont."Importe Db" <> 0) or (TmpContNomCont."Importe Cr" <> 0)) and
            (TmpContNomCont."Importe Db" <> TmpContNomCont."Importe Cr") then begin
            ConfNomina.TestField("Cód. Cta. Nominas Pago Transf.");
            NumLin += 1000;
            JobJNL."Journal Template Name" := ConfNomina."Job Journal Template Name";
            JobJNL."Journal Batch Name" := ConfNomina."Job Journal Batch Name";
            JobJNL."Posting Date" := FechaRegistro;
            JobJNL."Document No." := NumDoc;
            JobJNL."Line No." := NumLin;
            JobJNL.Description := Text001;
            JobJNL."Account Type" := JobJNL."Account Type"::"G/L Account";
            JobJNL.Validate("Account No.", ConfNomina."Cód. Cta. Nominas Pago Transf.");
            JobJNL."Debit Amount" := Round(TmpContNomCont."Importe Cr", Divisa."Amount Rounding Precision");
            JobJNL.Validate("Debit Amount");
            JobJNL.Insert;
        end;

        // GRN Graba contrapartida por el neto para pagos diferentes transferencias
        JobJNL.Init;
        if ((TmpContNomCont."Importe Db CK" <> 0) or (TmpContNomCont."Importe Cr CK" <> 0)) and
            (TmpContNomCont."Importe Db CK" <> TmpContNomCont."Importe Cr CK") then begin
            ConfNomina.TestField(ConfNomina."Cta. Nominas Otros Pagos");
            NumLin += 1000;
            JobJNL."Journal Template Name" := ConfNomina."Job Journal Template Name";
            JobJNL."Journal Batch Name" := ConfNomina."Job Journal Batch Name";
            JobJNL."Posting Date" := FechaRegistro;
            JobJNL."Document No." := NumDoc;
            JobJNL."Line No." := NumLin;
            JobJNL.Description := Text001;
            JobJNL."Account Type" := JobJNL."Account Type"::"G/L Account";
            JobJNL.Validate("Account No.", ConfNomina."Cta. Nominas Otros Pagos");
            JobJNL."Debit Amount" := Round(TmpContNomCont."Importe Cr CK", Divisa."Amount Rounding Precision");
            JobJNL.Validate("Debit Amount");
            JobJNL.Insert;
        end;

    end;


    procedure CalcularDtosCOTSSJob(Ano: Integer; CodEmp: Code[20])
    var
        LinNominasES: Record "Historico Lin. nomina";
        DeduccGob: Record "Tipos de Cotización";
        CabAportesEmpresa: Record "Cab. Aportes Empresas";
        LinAportesEmpresa: Record "Lin. Aportes Empresas";
        LinAportesEmpresa2: Record "Lin. Aportes Empresas";
        Puestos: Record "Puestos laborales";
        TmpDCA: Record "Temp Contabilizacion Nom." temporary;
        NoLin: Integer;
        MontoAplicar: Decimal;
        IndSkip: Boolean;
        ImporteCotizacion2: Decimal;
        ImporteImpuestos: Decimal;
        ImporteImpuestosemp: Decimal;
        ImporteCotizacionEmp: Decimal;
        ImporteCotizacion: Decimal;
        Importecotizacionmes: Decimal;
        SFSMes: Decimal;
        AFPMes: Decimal;
        ImporteTotal: Decimal;
        "%Cot": Decimal;
        Lintabla: Decimal;
        NoCuenta: Code[20];
        ImporteIngreso: Decimal;
        ImporteDto: Decimal;
        ImporteTarea: Decimal;
    begin
        //Las retenciones legales solo van al Diario, no se distribuyen
        TiposCotizacion.Reset;
        TiposCotizacion.SetRange(Ano, Date2DMY(final, 3));
        TiposCotizacion.SetFilter("Porciento Empleado", '<>%1', 0);
        if TiposCotizacion.FindSet then
            repeat
                ImporteIngreso := 0;
                ImporteDto := 0;
                //Envio los importes descontados integros al Diario y sin distribuir
                if (TiposCotizacion.Código = ConfNomina."Concepto AFP") or (TiposCotizacion.Código = ConfNomina."Concepto SFS") then begin
                    LinNominasES.Reset;
                    LinNominasES.SetRange(Período, inicial, final);
                    LinNominasES.SetRange("No. empleado", CodEmp);
                    LinNominasES.SetRange("Concepto salarial", TiposCotizacion.Código);
                    LinNominasES.SetRange("Tipo Nómina", LinNominasES."Tipo Nómina");
                    LinNominasES.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
                    if LinNominasES.FindSet then
                        repeat
                            ImporteDto += LinNominasES.Total;
                        until LinNominasES.Next = 0;

                    //Busco la cuenta que se debe afectar
                    ConceptosSalariales.Get(TiposCotizacion.Código);
                    if GpoContEmpl.Get(Empleado."Posting Group") then begin
                        ConfGpoContEmpl.Reset;
                        ConfGpoContEmpl.SetRange(Código, GpoContEmpl.Código);
                        ConfGpoContEmpl.SetRange("Código Concepto Salarial", TiposCotizacion.Código);
                        if ConfGpoContEmpl.FindFirst then begin
                            ConfGpoContEmpl.TestField("No. Cuenta Cuota Obrera");
                            NoCuenta := ConfGpoContEmpl."No. Cuenta Cuota Obrera";
                            case ConfGpoContEmpl."Tipo Cuenta Cuota Obrera" of
                                0:
                                    TipoCta := 0;
                                else
                                    TipoCta := 2;
                            end;

                            if ConceptosSalariales."Validar Contrapartida CO" then begin
                                ConfGpoContEmpl.TestField("No. Cuenta Contrapartida CO");
                                case ConfGpoContEmpl."Tipo Cuenta Contrapartida CO" of
                                    0:
                                        TipoContrapartida := 0;
                                    else
                                        TipoContrapartida := 2;
                                end;

                                NoCuentaContrapartida := ConfGpoContEmpl."No. Cuenta Contrapartida CO";
                            end;
                        end;
                    end
                    else begin
                        case ConceptosSalariales."Tipo Cuenta Cuota Obrera" of
                            0:
                                TipoCta := 0;
                            1:
                                TipoCta := 2;
                            else
                                TipoCta := 1;
                        end;

                        if TipoCta <> 1 then  //Cliente
                           begin
                            ConceptosSalariales.TestField("No. Cuenta Cuota Obrera");
                            NoCuenta := ConceptosSalariales."No. Cuenta Cuota Obrera";
                        end;

                        if ConceptosSalariales."Validar Contrapartida CO" then begin
                            ConceptosSalariales.TestField("No. Cuenta Contrapartida CO");
                            case ConceptosSalariales."Tipo Cuenta Contrapartida CO" of
                                0:
                                    TipoContrapartida := 0;
                                else
                                    TipoContrapartida := 2;
                            end;

                            NoCuentaContrapartida := ConceptosSalariales."No. Cuenta Contrapartida CO";
                        end;
                    end;

                    LlenaDatosDescJob(TiposCotizacion.Código, TipoCta, NoCuenta, ImporteDto, false,
                                      LinNominasES."No. empleado", '', '', 3, LinNominasES."Dimension Set ID");
                    if ConceptosSalariales."Validar Contrapartida CO" then
                        LlenaDatosDescJob(TiposCotizacion.Código, TipoContrapartida, NoCuentaContrapartida, ImporteDto * -1, true,
                                LinNominasES."No. empleado", '', '', 3, LinNominasES."Dimension Set ID");
                end;
            until TiposCotizacion.Next = 0;


        /*No se distribuyen las retenciones a empleados
        //En base al descuento, busco los ingresos que le aplican
        //limpiar valores de las variables de los ingresos globales
        TiposCotizacion.RESET;
        TiposCotizacion.SETRANGE(Ano,DATE2DMY(final,3));
        TiposCotizacion.SETFILTER("Porciento Empleado",'<>%1',0);
        IF TiposCotizacion.FINDSET THEN
           REPEAT
            ImporteIngreso := 0;
            ImporteDto := 0;
            //Busco el total de los ingresos que aplican
            LinNominasES.RESET;
            IF ConfNomina."Concepto AFP" = TiposCotizacion.Código THEN
                LinNominasES.SETRANGE("Cotiza AFP",TRUE)
            ELSE
            IF ConfNomina."Concepto SFS" = TiposCotizacion.Código THEN
                LinNominasES.SETRANGE("Cotiza SFS",TRUE);
        
            LinNominasES.SETRANGE(Período,inicial,final);
            LinNominasES.SETRANGE("No. empleado",CodEmp);
            LinNominasES.SETRANGE("Tipo concepto",LinNominasES."Tipo concepto"::Ingresos);
            LinNominasES.SETRANGE("Tipo Nómina",LinNominasES."Tipo Nómina");
            IF LinNominasES.FINDSET THEN
              REPEAT
                ImporteIngreso += LinNominasES.Total;
              UNTIL LinNominasES.NEXT = 0;
        
            //Busco el total del descuento
            LinNominasES.RESET;
            LinNominasES.SETRANGE(Período,inicial,final);
            LinNominasES.SETRANGE("No. empleado",CodEmp);
            LinNominasES.SETRANGE("Concepto salarial",TiposCotizacion.Código);
            LinNominasES.SETRANGE("Tipo Nómina",LinNominasES."Tipo Nómina");
            IF LinNominasES.FINDFIRST THEN
              ImporteDto += LinNominasES.Total;
        
        
            //Busco todas las combinaciones de proyectos y tareas para el empleado
            TmpDCA.DELETEALL;
            DCA.RESET;
            DCA.SETRANGE("Fecha registro",inicial,final);
            DCA.SETRANGE("Cod. Empleado",CodEmp);
            IF DCA.FINDSET THEN
              REPEAT
                TmpDCA.INIT;
                TmpDCA."Cod. Empleado" := DCA."Cod. Empleado";
                TmpDCA."Valor Dim 2" := DCA."Job No.";
                TmpDCA."Valor Dim 3" := DCA."Job Task No.";
                IF TmpDCA.INSERT THEN;
              UNTIL DCA.NEXT = 0;
        
              //Para distribuir TSS
               TmpDCA.FIND('-');
               REPEAT
                ImporteTarea := 0;
                DCA.RESET;
                DCA.SETRANGE("Fecha registro",inicial,final);
                DCA.SETRANGE("Cod. Empleado",CodEmp);
                DCA.SETRANGE("Job No.",TmpDCA."Valor Dim 2");
                DCA.SETRANGE("Job Task No.",TmpDCA."Valor Dim 3");
                IF DCA.FINDSET THEN
                  REPEAT
                    //Busco importe a distribuir por los ingresos que aplican al impuesto
                    LinNominasES.RESET;
                    IF ConfNomina."Concepto AFP" = TiposCotizacion.Código THEN
                       LinNominasES.SETRANGE("Cotiza AFP",TRUE)
                    ELSE
                    IF ConfNomina."Concepto SFS" = TiposCotizacion.Código THEN
                       LinNominasES.SETRANGE("Cotiza SFS",TRUE);
        
                    LinNominasES.SETRANGE(Período,inicial,final);
                    LinNominasES.SETRANGE("No. empleado",CodEmp);
                    LinNominasES.SETRANGE("Tipo concepto",LinNominasES."Tipo concepto"::Ingresos);
                    LinNominasES.SETRANGE("Tipo Nómina",LinNominasES."Tipo Nómina");
                    IF LinNominasES.FINDSET THEN
                      REPEAT
                        IF LinNominasES."Concepto salarial" = ConfNomina."Concepto Sal. Base" THEN
                           ImporteTarea += DCA."Horas regulares" * LinNominasES."Importe Base";
                        //ELSE
        
                      UNTIL LinNominasES.NEXT = 0;
                  UNTIL DCA.NEXT = 0;
                ImporteTarea := ImporteTarea/ImporteIngreso; //Represento el % sobre el ingreso total de la base de impuesto
                ImporteTarea := ImporteDto * ImporteTarea; //Calculo la proporcion que toca a este impuesto
        
                //Busco la cuenta que se debe afectar
                ConceptosSalariales.GET(TiposCotizacion.Código);
                IF GpoContEmpl.GET(Empleado."Posting Group") THEN
                    BEGIN
                    ConfGpoContEmpl.RESET;
                    ConfGpoContEmpl.SETRANGE(Código,GpoContEmpl.Código);
                    ConfGpoContEmpl.SETRANGE("Código Concepto Salarial",TiposCotizacion.Código);
                    IF ConfGpoContEmpl.FINDFIRST THEN
                        BEGIN
                        ConfGpoContEmpl.TESTFIELD("No. Cuenta Cuota Obrera");
                        NoCuenta                  := ConfGpoContEmpl."No. Cuenta Cuota Obrera";
                        CASE ConfGpoContEmpl."Tipo Cuenta Cuota Obrera" OF
                          0:
                          TipoCta := 0;
                          ELSE
                          TipoCta := 2;
                        END;
        
                        IF ConceptosSalariales."Validar Contrapartida CO" THEN
                            BEGIN
                            ConfGpoContEmpl.TESTFIELD("No. Cuenta Contrapartida CO");
                            CASE ConfGpoContEmpl."Tipo Cuenta Contrapartida CO" OF
                              0:
                              TipoContrapartida   := 0;
                              ELSE
                              TipoContrapartida   := 2;
                            END;
        
                            NoCuentaContrapartida := ConfGpoContEmpl."No. Cuenta Contrapartida CO";
                            END;
                        END;
                    END
                ELSE
                   BEGIN
                    CASE ConceptosSalariales."Tipo Cuenta Cuota Obrera" OF
                     0:
                      TipoCta := 0;
                     1:
                      TipoCta := 2;
                     ELSE
                      TipoCta := 1;
                    END;
        
                    IF TipoCta <> 1 THEN  //Cliente
                       BEGIN
                        ConceptosSalariales.TESTFIELD("No. Cuenta Cuota Obrera");
                        NoCuenta := ConceptosSalariales."No. Cuenta Cuota Obrera";
                       END;
        
                    IF ConceptosSalariales."Validar Contrapartida CO" THEN
                       BEGIN
                        ConceptosSalariales.TESTFIELD("No. Cuenta Contrapartida CO");
                        CASE ConceptosSalariales."Tipo Cuenta Contrapartida CO" OF
                         0:
                          TipoContrapartida       := 0;
                         ELSE
                          TipoContrapartida       := 2;
                         END;
        
                        NoCuentaContrapartida     := ConceptosSalariales."No. Cuenta Contrapartida CO";
                      END;
                   END;
        
                LlenaDatosDescJob(TiposCotizacion.Código,TipoCta,NoCuenta,ImporteTarea,LinNominasES."No. Documento" + LinNominasES."No. empleado",FALSE,
                                  LinNominasES."No. empleado",DCA."Job No.",DCA."Job Task No.",3,LinNominasES."Dimension Set ID");
                IF ConceptosSalariales."Validar Contrapartida CO" THEN
                   LlenaDatosDescJob(TiposCotizacion.Código,TipoContrapartida,NoCuentaContrapartida,ImporteTarea*-1,LinNominasES."No. Documento" + LinNominasES."No. empleado",TRUE,
                            LinNominasES."No. empleado",'','',3,LinNominasES."Dimension Set ID");
        
               UNTIL TmpDCA.NEXT = 0;
           UNTIL TiposCotizacion.NEXT = 0;
        */

    end;


    procedure CalcularDtosCPTSSJob(Ano: Integer; CodEmp: Code[20])
    var
        LinNominasES: Record "Historico Lin. nomina";
        DeduccGob: Record "Tipos de Cotización";
        CabAportesEmpresa: Record "Cab. Aportes Empresas";
        LinAportesEmpresa: Record "Lin. Aportes Empresas";
        Puestos: Record "Puestos laborales";
        TmpDCA: Record "Temp Contabilizacion Nom." temporary;
        NoLin: Integer;
        MontoAplicar: Decimal;
        IndSkip: Boolean;
        ImporteCotizacion2: Decimal;
        ImporteImpuestos: Decimal;
        ImporteImpuestosemp: Decimal;
        ImporteCotizacionEmp: Decimal;
        ImporteCotizacion: Decimal;
        Importecotizacionmes: Decimal;
        SFSMes: Decimal;
        AFPMes: Decimal;
        ImporteTotal: Decimal;
        "%Cot": Decimal;
        Lintabla: Decimal;
        NoCuenta: Code[20];
        ImporteIngreso: Decimal;
        ImporteDto: Decimal;
        ImporteTarea: Decimal;
        TotHorasReg: Decimal;
    begin
        //En base al descuento, busco los ingresos que le aplican       AQUI
        //limpiar valores de las variables de los ingresos globales
        TiposCotizacion.Reset;
        TiposCotizacion.SetRange(Ano, Date2DMY(inicial, 3));
        TiposCotizacion.SetFilter("Porciento Empresa", '<>%1', 0);
        if TiposCotizacion.FindSet then
            repeat
                ImporteIngreso := 0;
                ImporteDto := 0;
                TotHorasReg := 0;
                //Busco la cuenta que se debe afectar
                ConceptosSalariales.Get(TiposCotizacion.Código);
                if GpoContEmpl.Get(Empleado."Posting Group") then begin
                    ConfGpoContEmpl.Reset;
                    ConfGpoContEmpl.SetRange(Código, GpoContEmpl.Código);
                    ConfGpoContEmpl.SetRange("Código Concepto Salarial", TiposCotizacion.Código);
                    if ConfGpoContEmpl.FindFirst then begin
                        ConfGpoContEmpl.TestField("No. Cuenta Cuota Patronal");
                        NoCuenta := ConfGpoContEmpl."No. Cuenta Cuota Patronal";
                        case ConfGpoContEmpl."Tipo Cuenta Cuota Patronal" of
                            0:
                                TipoCta := 0;
                            else
                                TipoCta := 2;
                        end;
                        //            ERROR('%1',ConceptosSalariales."Validar Contrapartida CP");
                        if ConceptosSalariales."Validar Contrapartida CP" then begin
                            ConfGpoContEmpl.TestField("No. Cuenta Contrapartida CP");
                            case ConfGpoContEmpl."Tipo Cuenta Contrapartida CP" of
                                0:
                                    TipoContrapartida := 0;
                                else
                                    TipoContrapartida := 2;
                            end;

                            NoCuentaContrapartida := ConfGpoContEmpl."No. Cuenta Contrapartida CP";
                        end;
                    end;
                end
                else begin
                    case ConceptosSalariales."Tipo Cuenta Cuota Patronal" of
                        0:
                            TipoCta := 0;
                        1:
                            TipoCta := 2;
                        else
                            TipoCta := 1;
                    end;

                    if TipoCta <> 1 then  //Cliente
                        begin
                        ConceptosSalariales.TestField("No. Cuenta Cuota Patronal");
                        NoCuenta := ConceptosSalariales."No. Cuenta Cuota Patronal";
                    end;

                    if ConceptosSalariales."Validar Contrapartida CP" then begin
                        ConceptosSalariales.TestField("No. Cuenta Contrapartida CP");
                        case ConceptosSalariales."Tipo Cuenta Contrapartida CP" of
                            0:
                                TipoContrapartida := 0;
                            else
                                TipoContrapartida := 2;
                        end;

                        NoCuentaContrapartida := ConceptosSalariales."No. Cuenta Contrapartida CP";
                    end;
                end;

                //Busco el total del descuento
                LinAportesEmpresa.Reset;
                LinAportesEmpresa.SetRange(Período, inicial, final);
                LinAportesEmpresa.SetRange("No. Empleado", CodEmp);
                LinAportesEmpresa.SetRange("Concepto Salarial", TiposCotizacion.Código);
                LinAportesEmpresa.SetRange("Tipo Nomina", LinNominasES."Tipo Nómina");
                LinAportesEmpresa.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
                if LinAportesEmpresa.FindFirst then begin
                    ImporteDto := LinAportesEmpresa.Importe;
                    ImporteIngreso := LinAportesEmpresa."Base Imponible";
                end;

                //Si no tiene aporte del empleado, no lo considero para distribuirlo
                //    IF TiposCotizacion."Porciento Empleado" <> 0 THEN
                begin
                    //Busco todas las combinaciones de proyectos y tareas para el empleado

                    TmpDCA.DeleteAll;
                    DCA.Reset;
                    DCA.SetRange("Fecha registro", inicial, final);
                    DCA.SetRange("Cod. Empleado", CodEmp);
                    DCA.SetFilter("Job No.", "Cab. nómina".GetFilter("Job No."));
                    if DCA.FindSet then
                        repeat
                            TmpDCA.Init;
                            TmpDCA."Cod. Empleado" := DCA."Cod. Empleado";
                            TmpDCA."Valor Dim 2" := DCA."Job No.";
                            TmpDCA."Valor Dim 3" := DCA."Job Task No.";
                            TmpDCA."Valor Dim 4" := Format(DCA."Fecha registro");
                            TmpDCA.Importe := DCA."Horas regulares";
                            TotHorasReg += DCA."Horas regulares";
                            if TmpDCA.Insert then;
                        until DCA.Next = 0;

                    ImporteDto := ImporteDto / TotHorasReg;

                    //Para distribuir Aporte del patron
                    TmpDCA.Find('-');
                    repeat
                        ImporteTarea := 0;
                        /*
                                    DCA.RESET;
                                    DCA.SETRANGE("Fecha registro",inicial,final);
                                    DCA.SETRANGE("Cod. Empleado",CodEmp);
                                    DCA.SETRANGE("Job No.",TmpDCA."Valor Dim 2");
                                    DCA.SETRANGE("Job Task No.",TmpDCA."Valor Dim 3");
                            //        IF DCA.FINDSET THEN
                                    DCA.FINDSET;
                                      REPEAT
                                        //Busco importe a distribuir por los ingresos que aplican al impuesto
                                        LinNominasES.RESET;
                                        IF ConfNomina."Concepto AFP" = TiposCotizacion.Código THEN
                                           LinNominasES.SETRANGE("Cotiza AFP",TRUE)
                                        ELSE
                                        IF ConfNomina."Concepto SFS" = TiposCotizacion.Código THEN
                                           LinNominasES.SETRANGE("Cotiza SFS",TRUE)
                                        ELSE
                                        IF ConfNomina."Concepto INFOTEP" = TiposCotizacion.Código THEN
                                            LinNominasES.SETRANGE("Cotiza Infotep",TRUE)
                                        ELSE
                                        IF ConfNomina."Concepto SRL" = TiposCotizacion.Código THEN
                                            LinNominasES.SETRANGE("Cotiza SRL",TRUE);

                                        LinNominasES.SETRANGE(Período,inicial,final);
                                        LinNominasES.SETRANGE("No. empleado",CodEmp);
                                        LinNominasES.SETRANGE("Tipo concepto",LinNominasES."Tipo concepto"::Ingresos);
                                        LinNominasES.SETRANGE("Tipo Nómina",LinNominasES."Tipo Nómina");
                                        LinNominasES.SETRANGE("Job No.",DCA."Job No.");
                                        IF LinNominasES.FINDSET THEN
                                          REPEAT
                            //                IF LinNominasES."Concepto salarial" = ConfNomina."Concepto Sal. Base" THEN
                                               ImporteTarea += DCA."Horas regulares" * LinNominasES."Importe Base";
                        //                       IF TiposCotizacion.Código = '203' THEN
                        //   MESSAGE('%1 %2 %3 %4 %5',ImporteTarea,DCA."Horas regulares",LinNominasES."Importe Base");

                                            //ELSE

                                          UNTIL LinNominasES.NEXT = 0;
                                      UNTIL DCA.NEXT = 0;
                        //IF TiposCotizacion.Código = '203' THEN
                           //ERROR('%1 %2 %3 %4 %5',ImporteTarea,ImporteIngreso,ImporteTarea,ImporteDto);
                                      ImporteTarea := ImporteTarea/ImporteIngreso; //Represento el % sobre el ingreso total de la base de impuesto
                                      ImporteTarea := ImporteDto * ImporteTarea; //Calculo la proporcion que toca a este impuesto
                        */


                        ImporteTarea := ImporteDto * TmpDCA.Importe; //Calculo la proporcion que toca a este impuesto


                        LlenaDatosDescJob(TiposCotizacion.Código, TipoCta, NoCuenta, ImporteTarea, false, CodEmp,
                                          '', '', 4, LinAportesEmpresa."Dimension Set ID");
                        if ConceptosSalariales."Validar Contrapartida CP" then
                            LlenaDatosDescJob(TiposCotizacion.Código, TipoContrapartida, NoCuentaContrapartida, ImporteTarea * -1, true,
                                     CodEmp, TmpDCA."Valor Dim 2", TmpDCA."Valor Dim 3", 4, LinAportesEmpresa."Dimension Set ID");

                    until TmpDCA.Next = 0;
                end;
            /*
                  ELSE
                      BEGIN
                        LinNominasES.RESET;
                        LinNominasES.SETRANGE(Período,inicial,final);
                        LinNominasES.SETRANGE("No. empleado",CodEmp);
                        LinNominasES.SETRANGE("Tipo concepto",LinNominasES."Tipo concepto"::Ingresos);
                        LinNominasES.SETRANGE("Tipo Nómina",LinNominasES."Tipo Nómina");
                        LinNominasES.FINDFIRST;
                        ImporteTarea := ImporteDto;
                        DCA."Job No." := '';
                        DCA."Job Task No." := '';
                        LlenaDatosDescJob(TiposCotizacion.Código,TipoCta,NoCuenta,ImporteTarea,FALSE,LinNominasES."No. empleado",
                                          DCA."Job No.",DCA."Job Task No.",4,LinAportesEmpresa."Dimension Set ID");
                        IF ConceptosSalariales."Validar Contrapartida CP" THEN
                           LlenaDatosDescJob(TiposCotizacion.Código,TipoContrapartida,NoCuentaContrapartida,ImporteTarea*-1,TRUE,
                                    LinNominasES."No. empleado",'','',4,LinAportesEmpresa."Dimension Set ID");

                      END;
            */
            until TiposCotizacion.Next = 0;

    end;


    procedure CalcularISRJob(Ano: Integer; CodEmp: Code[20])
    var
        LinNominasES: Record "Historico Lin. nomina";
        TmpDCA: Record "Temp Contabilizacion Nom." temporary;
        NoCuenta: Code[20];
        ImporteIngreso: Decimal;
        ImporteDto: Decimal;
        ImporteTarea: Decimal;
    begin
        //Las retenciones legales solo van al Diario, no se distribuyen
        ImporteDto := 0;


        LinNominasES.Reset;
        LinNominasES.SetRange(Período, inicial, final);
        LinNominasES.SetRange("No. empleado", CodEmp);
        LinNominasES.SetRange("Concepto salarial", ConfNomina."Concepto ISR");
        LinNominasES.SetRange("Tipo Nómina", LinNominasES."Tipo Nómina");
        if LinNominasES.FindSet then
            repeat
                ImporteDto += LinNominasES.Total;
            until LinNominasES.Next = 0;

        if ImporteDto = 0 then
            exit;

        //Busco la cuenta que se debe afectar
        ConceptosSalariales.Get(ConfNomina."Concepto ISR");
        if GpoContEmpl.Get(Empleado."Posting Group") then begin
            ConfGpoContEmpl.Reset;
            ConfGpoContEmpl.SetRange(Código, GpoContEmpl.Código);
            ConfGpoContEmpl.SetRange("Código Concepto Salarial", ConfNomina."Concepto ISR");
            if ConfGpoContEmpl.FindFirst then begin
                ConfGpoContEmpl.TestField("No. Cuenta Cuota Obrera");
                NoCuenta := ConfGpoContEmpl."No. Cuenta Cuota Obrera";
                case ConfGpoContEmpl."Tipo Cuenta Cuota Obrera" of
                    0:
                        TipoCta := 0;
                    else
                        TipoCta := 2;
                end;

                if ConceptosSalariales."Validar Contrapartida CO" then begin
                    ConfGpoContEmpl.TestField("No. Cuenta Contrapartida CO");
                    case ConfGpoContEmpl."Tipo Cuenta Contrapartida CO" of
                        0:
                            TipoContrapartida := 0;
                        else
                            TipoContrapartida := 2;
                    end;

                    NoCuentaContrapartida := ConfGpoContEmpl."No. Cuenta Contrapartida CO";
                end;
            end;
        end
        else begin
            case ConceptosSalariales."Tipo Cuenta Cuota Obrera" of
                0:
                    TipoCta := 0;
                1:
                    TipoCta := 2;
                else
                    TipoCta := 1;
            end;

            if TipoCta <> 1 then  //Cliente
                begin
                ConceptosSalariales.TestField("No. Cuenta Cuota Obrera");
                NoCuenta := ConceptosSalariales."No. Cuenta Cuota Obrera";
            end;

            if ConceptosSalariales."Validar Contrapartida CO" then begin
                ConceptosSalariales.TestField("No. Cuenta Contrapartida CO");
                case ConceptosSalariales."Tipo Cuenta Contrapartida CO" of
                    0:
                        TipoContrapartida := 0;
                    else
                        TipoContrapartida := 2;
                end;

                NoCuentaContrapartida := ConceptosSalariales."No. Cuenta Contrapartida CO";
            end;
        end;


        LlenaDatosDescJob(LinNominasES."Concepto salarial", TipoCta, NoCuenta, ImporteDto, false,
                          LinNominasES."No. empleado", '', '', 3, LinNominasES."Dimension Set ID");
        if ConceptosSalariales."Validar Contrapartida CO" then
            LlenaDatosDescJob(LinNominasES."Concepto salarial", TipoContrapartida, NoCuentaContrapartida, ImporteDto * -1, true,
                    LinNominasES."No. empleado", '', '', 3, LinNominasES."Dimension Set ID");




        /*Las retenciones a empleados no se distribuyen
        //En base al descuento, busco los ingresos que le aplican
        //limpiar valores de las variables de los ingresos globales
        ImporteIngreso := 0;
        ImporteDto := 0;
        //Busco el importe total de la base de calculo del ISR OJO OJO OJO, para cuando es un importe manual solo asi funcionaria
        {LinNominasES.RESET;
        LinNominasES.SETRANGE(Período,inicial,final);
        LinNominasES.SETRANGE("No. empleado",CodEmp);
        LinNominasES.SETRANGE("Tipo concepto",LinNominasES."Tipo concepto"::Ingresos);
        LinNominasES.SETRANGE("Tipo Nómina",LinNominasES."Tipo Nómina");
        LinNominasES.SETRANGE("Cotiza ISR",TRUE);
        }
        ConfNomina.TESTFIELD("Concepto ISR");
        LinNominasES.RESET;
        LinNominasES.SETRANGE(Período,inicial,final);
        LinNominasES.SETRANGE("No. empleado",CodEmp);
        LinNominasES.SETRANGE("Tipo concepto",LinNominasES."Tipo concepto"::Deducciones);
        LinNominasES.SETRANGE("Tipo Nómina",LinNominasES."Tipo Nómina");
        LinNominasES.SETRANGE("Concepto salarial",ConfNomina."Concepto ISR");
        IF LinNominasES.FINDSET THEN
          REPEAT
            ImporteIngreso += LinNominasES."Importe Base";
          UNTIL LinNominasES.NEXT = 0;
        
        //Busco el total del descuento
        LinNominasES.RESET;
        LinNominasES.SETRANGE(Período,inicial,final);
        LinNominasES.SETRANGE("No. empleado",CodEmp);
        LinNominasES.SETRANGE("Concepto salarial",ConfNomina."Concepto ISR");
        LinNominasES.SETRANGE("Tipo Nómina",LinNominasES."Tipo Nómina");
        IF LinNominasES.FINDFIRST THEN
          ImporteDto += LinNominasES.Total;
        
        
        //Busco todas las combinaciones de proyectos y tareas para el empleado
        TmpDCA.DELETEALL;
        DCA.RESET;
        DCA.SETRANGE("Fecha registro",inicial,final);
        DCA.SETRANGE("Cod. Empleado",CodEmp);
        IF DCA.FINDSET THEN
          REPEAT
            TmpDCA.INIT;
            TmpDCA."Cod. Empleado" := DCA."Cod. Empleado";
            TmpDCA."Valor Dim 2" := DCA."Job No.";
            TmpDCA."Valor Dim 3" := DCA."Job Task No.";
            IF TmpDCA.INSERT THEN;
          UNTIL DCA.NEXT = 0;
        
        //Para distribuir ISR
        TmpDCA.FIND('-');
        REPEAT
          ImporteTarea := 0;
          DCA.RESET;
          DCA.SETRANGE("Fecha registro",inicial,final);
          DCA.SETRANGE("Cod. Empleado",CodEmp);
          DCA.SETRANGE("Job No.",TmpDCA."Valor Dim 2");
          DCA.SETRANGE("Job Task No.",TmpDCA."Valor Dim 3");
          IF DCA.FINDSET THEN
            REPEAT
              //Busco importe a distribuir por los ingresos que aplican al impuesto
              LinNominasES.RESET;
              LinNominasES.SETRANGE(Período,inicial,final);
              LinNominasES.SETRANGE("No. empleado",CodEmp);
              LinNominasES.SETRANGE("Tipo concepto",LinNominasES."Tipo concepto"::Ingresos);
              LinNominasES.SETRANGE("Tipo Nómina",LinNominasES."Tipo Nómina");
              LinNominasES.SETRANGE("Cotiza ISR",TRUE);
              IF LinNominasES.FINDSET THEN
                REPEAT
                  IF LinNominasES."Concepto salarial" = ConfNomina."Concepto Horas Ext. 100%" THEN
                     ImporteTarea += DCA."Horas extras al 100" * LinNominasES."Importe Base"
                  ELSE
                  IF LinNominasES."Concepto salarial" = ConfNomina."Concepto Horas Ext. 35%" THEN
                     ImporteTarea += DCA."Horas extras al 35" * LinNominasES."Importe Base"
                  ELSE
                  IF LinNominasES."Concepto salarial" = ConfNomina."Concepto Dias feriados" THEN
                     ImporteTarea += DCA."Horas feriadas" * LinNominasES."Importe Base"
                  ELSE
                  IF LinNominasES."Concepto salarial" = ConfNomina."Concepto Sal. Base" THEN
                     ImporteTarea += DCA."Horas regulares" * LinNominasES."Importe Base";
        //          MESSAGE('%1 %2',ImporteTarea);
                UNTIL LinNominasES.NEXT = 0;
            UNTIL DCA.NEXT = 0;
        
          ImporteTarea := ImporteTarea/ImporteIngreso; //Represento el % sobre el ingreso total de la base de impuesto
          ImporteTarea := ImporteDto * ImporteTarea; //Calculo la proporcion que toca a este impuesto
        
          //Busco la cuenta que se debe afectar
          ConceptosSalariales.GET(ConfNomina."Concepto ISR");
          IF GpoContEmpl.GET(Empleado."Posting Group") THEN
              BEGIN
              ConfGpoContEmpl.RESET;
              ConfGpoContEmpl.SETRANGE(Código,GpoContEmpl.Código);
              ConfGpoContEmpl.SETRANGE("Código Concepto Salarial",ConfNomina."Concepto ISR");
              IF ConfGpoContEmpl.FINDFIRST THEN
                  BEGIN
                  ConfGpoContEmpl.TESTFIELD("No. Cuenta Cuota Obrera");
                  NoCuenta                  := ConfGpoContEmpl."No. Cuenta Cuota Obrera";
                  CASE ConfGpoContEmpl."Tipo Cuenta Cuota Obrera" OF
                    0:
                    TipoCta := 0;
                    ELSE
                    TipoCta := 2;
                  END;
        
                  IF ConceptosSalariales."Validar Contrapartida CO" THEN
                      BEGIN
                      ConfGpoContEmpl.TESTFIELD("No. Cuenta Contrapartida CO");
                      CASE ConfGpoContEmpl."Tipo Cuenta Contrapartida CO" OF
                        0:
                        TipoContrapartida   := 0;
                        ELSE
                        TipoContrapartida   := 2;
                      END;
        
                      NoCuentaContrapartida := ConfGpoContEmpl."No. Cuenta Contrapartida CO";
                      END;
                  END;
              END
          ELSE
              BEGIN
              CASE ConceptosSalariales."Tipo Cuenta Cuota Obrera" OF
                0:
                TipoCta := 0;
                1:
                TipoCta := 2;
                ELSE
                TipoCta := 1;
              END;
        
              IF TipoCta <> 1 THEN  //Cliente
                  BEGIN
                  ConceptosSalariales.TESTFIELD("No. Cuenta Cuota Obrera");
                  NoCuenta := ConceptosSalariales."No. Cuenta Cuota Obrera";
                  END;
        
              IF ConceptosSalariales."Validar Contrapartida CO" THEN
                  BEGIN
                  ConceptosSalariales.TESTFIELD("No. Cuenta Contrapartida CO");
                  CASE ConceptosSalariales."Tipo Cuenta Contrapartida CO" OF
                    0:
                    TipoContrapartida       := 0;
                    ELSE
                    TipoContrapartida       := 2;
                    END;
        
                  NoCuentaContrapartida     := ConceptosSalariales."No. Cuenta Contrapartida CO";
                END;
              END;
          IF ImporteTarea <> 0 THEN
             BEGIN
              LlenaDatosDescJob(ConfNomina."Concepto ISR",TipoCta,NoCuenta,ImporteTarea,LinNominasES."No. Documento" + LinNominasES."No. empleado",FALSE,
                                LinNominasES."No. empleado",DCA."Job No.",DCA."Job Task No.",3,LinNominasES."Dimension Set ID");
              IF ConceptosSalariales."Validar Contrapartida CO" THEN
                  LlenaDatosDescJob(ConfNomina."Concepto ISR",TipoContrapartida,NoCuentaContrapartida,ImporteTarea*-1,LinNominasES."No. Documento" + LinNominasES."No. empleado",TRUE,
                          LinNominasES."No. empleado",DCA."Job No.",DCA."Job Task No.",3,LinNominasES."Dimension Set ID");
             END;
        UNTIL TmpDCA.NEXT = 0;
        */

    end;

    local procedure FiltraDimSet(DimSet1: Integer; Dimset2: Integer; CodEmpleado: Code[20])
    begin
        recDimSet.Reset;
        recDimSet.SetFilter("Dimension Set ID", '%1|%2', DimSet1, Dimset2);
        if recDimSet.FindSet() then
            repeat
                if ConceptosSalariales."Contabilizacion x Dimension" then begin
                    if recDimSet."Dimension Code" = CodDim[1] then begin
                        ContabNom.SetRange("Cod. Dim 1", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 1", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[2] then begin
                        ContabNom.SetRange("Cod. Dim 2", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 2", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[3] then begin
                        ContabNom.SetRange("Cod. Dim 3", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 3", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[4] then begin
                        ContabNom.SetRange("Cod. Dim 4", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 4", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[5] then begin
                        ContabNom.SetRange("Cod. Dim 5", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 5", recDimSet."Dimension Value Code");
                    end;

                    if recDimSet."Dimension Code" = CodDim[6] then begin
                        ContabNom.SetRange("Cod. Dim 6", recDimSet."Dimension Code");
                        ContabNom.SetRange("Valor Dim 6", recDimSet."Dimension Value Code");
                    end;

                    if not ConceptosSalariales."Contabilizacion Resumida" then
                        ContabNom.SetRange("Cod. Empleado", CodEmpleado);
                end;
            until recDimSet.Next = 0;
    end;

    local procedure LlenaDimSet(DimSet1: Integer; Dimset2: Integer)
    begin
        recDimSet.Reset;
        recDimSet.SetFilter("Dimension Set ID", '%1|%2', "Cab. nómina"."Dimension Set ID", "Lín. nómina"."Dimension Set ID");
        if recDimSet.FindSet() then
            repeat
                if ConceptosSalariales."Contabilizacion x Dimension" then begin
                    if recDimSet."Dimension Code" = CodDim[1] then //Siempre llevara la primera DIM
                        begin
                        ContabNom."Cod. Dim 1" := recDimSet."Dimension Code";
                        ContabNom."Valor Dim 1" := recDimSet."Dimension Value Code";
                    end
                    else
                        if recDimSet."Dimension Code" = CodDim[2] then //Siempre llevara la segunda DIM
                            begin
                            ContabNom."Cod. Dim 2" := recDimSet."Dimension Code";
                            ContabNom."Valor Dim 2" := recDimSet."Dimension Value Code";
                        end
                        else
                            if recDimSet."Dimension Code" = CodDim[3] then begin
                                ContabNom."Cod. Dim 3" := recDimSet."Dimension Code";
                                ContabNom."Valor Dim 3" := recDimSet."Dimension Value Code";
                            end
                            else
                                if recDimSet."Dimension Code" = CodDim[4] then begin
                                    ContabNom."Cod. Dim 4" := recDimSet."Dimension Code";
                                    ContabNom."Valor Dim 4" := recDimSet."Dimension Value Code";
                                end
                                else
                                    if recDimSet."Dimension Code" = CodDim[5] then begin
                                        ContabNom."Cod. Dim 5" := recDimSet."Dimension Code";
                                        ContabNom."Valor Dim 5" := recDimSet."Dimension Value Code";
                                    end
                                    else
                                        if recDimSet."Dimension Code" = CodDim[6] then begin
                                            ContabNom."Cod. Dim 6" := recDimSet."Dimension Code";
                                            ContabNom."Valor Dim 6" := recDimSet."Dimension Value Code";
                                        end;
                    ContabNom."Dimension Set ID" := recDimSet."Dimension Set ID";
                end;
            until recDimSet.Next = 0
    end;

    local procedure LlenaTempExiste(Contrapartida: Boolean; dImporte: Decimal)
    begin
        if not Contrapartida then begin
            if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                if dImporte > 0 then
                    ContabNom."Importe Db CK" += dImporte
                else
                    ContabNom."Importe Cr CK" += Abs(dImporte);
            end
            else begin
                if dImporte > 0 then
                    ContabNom."Importe Db" += dImporte
                else
                    ContabNom."Importe Cr" += Abs(dImporte);
            end;
        end
        else
            if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                if dImporte > 0 then
                    ContabNom."Importe Cr CK" += dImporte
                else
                    ContabNom."Importe Db CK" += Abs(dImporte);
            end
            else
                if dImporte > 0 then
                    ContabNom."Importe Cr" += dImporte
                else
                    ContabNom."Importe Db" += Abs(dImporte);

        ContabNom.Modify;
    end;

    local procedure LlenaTempNOExiste(iTipoCuenta: Integer; cCodCuenta: Code[20]; CodEmpleado: Code[20]; Contrapartida: Boolean; dImporte: Decimal; cConceptoSal: Code[20]; Paso: Integer)
    begin
        NoLin += 100;

        Clear("Temp Contabilizacion Nom.");
        ContabNom."Tipo Cuenta" := iTipoCuenta;
        ContabNom."No. Cuenta" := cCodCuenta;
        ContabNom."No. Linea" := NoLin;
        ContabNom."Cod. Empleado" := CodEmpleado;
        ContabNom.Contrapartida := Contrapartida;
        ContabNom.Step := Paso;

        if not ConceptosSalariales."Contabilizacion Resumida" then
            ContabNom.Descripcion := CopyStr(Empleado."No." + ' ' + Empleado."Full Name", 1, 50)
        else
            ContabNom.Descripcion := ConceptosSalariales.Descripcion;

        if not Contrapartida then begin
            if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                if dImporte > 0 then
                    ContabNom."Importe Db CK" := dImporte
                else
                    ContabNom."Importe Cr CK" := Abs(dImporte);
            end
            else begin
                if dImporte > 0 then
                    ContabNom."Importe Db" := dImporte
                else
                    ContabNom."Importe Cr" := Abs(dImporte);
            end;
        end
        else begin
            if "Cab. nómina"."Forma de Cobro" <> "Cab. nómina"."Forma de Cobro"::"Transferencia Banc." then begin
                if dImporte > 0 then
                    ContabNom."Importe Db CK" := dImporte
                else
                    ContabNom."Importe Cr CK" := Abs(dImporte);

            end
            else begin
                if dImporte > 0 then
                    ContabNom."Importe Db" := dImporte
                else
                    ContabNom."Importe Cr" := Abs(dImporte);
            end;
        end;
        LlenaDimSet("Cab. nómina"."Dimension Set ID", "Lín. nómina"."Dimension Set ID");
        if ConceptosSalariales.Provisionar then begin
            for i := 1 to 6 do begin
                if ConfNomina."Dimension Conceptos Salariales" = CodDim[i] then begin
                    if ContabNom."Cod. Dim 1" = CodDim[i] then
                        ContabNom."Valor Dim 1" := cConceptoSal
                    else
                        if ContabNom."Cod. Dim 2" = CodDim[i] then
                            ContabNom."Valor Dim 2" := cConceptoSal
                        else
                            if ContabNom."Cod. Dim 3" = CodDim[i] then
                                ContabNom."Valor Dim 3" := cConceptoSal
                            else
                                if ContabNom."Cod. Dim 4" = CodDim[i] then
                                    ContabNom."Valor Dim 4" := cConceptoSal
                                else
                                    if ContabNom."Cod. Dim 5" = CodDim[i] then
                                        ContabNom."Valor Dim 5" := cConceptoSal
                                    else
                                        if ContabNom."Cod. Dim 6" = CodDim[i] then
                                            ContabNom."Valor Dim 6" := cConceptoSal;
                end;
            end;
        end;

        //Para las Dim del perfil de salario (linea del concepto salarial)
        //Para las Dim por Grupo contable
        DefDim.Reset;
        DefDim.SetFilter("Table ID", '%1|%2|%3', 76053, 76062, 76061);
        if Empleado."Posting Group" <> '' then
            DefDim.SetFilter("No.", Empleado."Posting Group" + '*' + cConceptoSal + '*')
        else
            DefDim.SetFilter("No.", '*' + cConceptoSal + '*');

        if DefDim.FindSet then
            repeat
                if CodDim[1] = DefDim."Dimension Code" then begin
                    ContabNom."Cod. Dim 1" := DefDim."Dimension Code";
                    ContabNom."Valor Dim 1" := DefDim."Dimension Value Code";
                end
                else
                    if CodDim[2] = DefDim."Dimension Code" then begin
                        ContabNom."Cod. Dim 2" := DefDim."Dimension Code";
                        ContabNom."Valor Dim 2" := DefDim."Dimension Value Code";
                    end
                    else
                        if CodDim[3] = DefDim."Dimension Code" then begin
                            ContabNom."Cod. Dim 3" := DefDim."Dimension Code";
                            ContabNom."Valor Dim 3" := DefDim."Dimension Value Code";
                        end
                        else
                            if CodDim[4] = DefDim."Dimension Code" then begin
                                ContabNom."Cod. Dim 4" := DefDim."Dimension Code";
                                ContabNom."Valor Dim 4" := DefDim."Dimension Value Code";
                            end
                            else
                                if CodDim[5] = DefDim."Dimension Code" then begin
                                    ContabNom."Cod. Dim 5" := DefDim."Dimension Code";
                                    ContabNom."Valor Dim 5" := DefDim."Dimension Value Code";
                                end
                                else
                                    if CodDim[6] = DefDim."Dimension Code" then begin
                                        ContabNom."Cod. Dim 6" := DefDim."Dimension Code";
                                        ContabNom."Valor Dim 6" := DefDim."Dimension Value Code";
                                    end;
            until DefDim.Next = 0;

        ContabNom."Forma de Cobro" := "Cab. nómina"."Forma de Cobro";
        ContabNom.Insert;
        //IF NOT contabnom.INSERT THEN
        //contabnom.MODIFY;
    end;

    local procedure InsertaAporteCooperativa(LinNomCoop: Record "Historico Lin. nomina")
    var
        Movcooperativa: Record "Mov. cooperativa";
        Movcooperativa2: Record "Mov. cooperativa";
        Miembroscooperativa: Record "Miembros cooperativa";
    begin
        if not ConfNomina."Mod. cooperativa activo" then
            exit;
        if (LinNomCoop."Concepto salarial" <> ConfNomina."Concepto Cuota cooperativa") then
            exit;

        if not Movcooperativa2.FindLast then
            Movcooperativa2.Init;

        Miembroscooperativa.Get(LinNomCoop."No. empleado");

        Movcooperativa."No. Movimiento" := Movcooperativa2."No. Movimiento" + 1;
        Movcooperativa."Tipo miembro" := Miembroscooperativa."Tipo de miembro";
        Movcooperativa."Employee No." := LinNomCoop."No. empleado";
        Movcooperativa."Fecha registro" := LinNomCoop.Período;
        Movcooperativa."No. documento" := "Cab. nómina"."No. Documento";
        Movcooperativa."Tipo transaccion" := Movcooperativa."Tipo transaccion"::Aporte;
        Movcooperativa.Importe := Abs(LinNomCoop.Total);
        Movcooperativa."Concepto salarial" := LinNomCoop."Concepto salarial";
        Movcooperativa.Insert;
    end;

    local procedure InsertaDescCooperativa(LinNomCoop: Record "Historico Lin. nomina")
    var
        Movcooperativa: Record "Mov. cooperativa";
        Movcooperativa2: Record "Mov. cooperativa";
        Miembroscooperativa: Record "Miembros cooperativa";
        HistCabPrestcooperativa: Record "Hist. Cab. Prest. cooperativa";
    begin
        if not ConfNomina."Mod. cooperativa activo" then
            exit;

        HistCabPrestcooperativa.Reset;
        HistCabPrestcooperativa.SetRange("Employee No.", LinNomCoop."No. empleado");
        HistCabPrestcooperativa.SetRange(Status, HistCabPrestcooperativa.Status::Activo);
        HistCabPrestcooperativa.SetRange("Concepto Salarial", LinNomCoop."Concepto salarial");
        if not HistCabPrestcooperativa.FindFirst then
            exit;

        if not Movcooperativa2.FindLast then
            Movcooperativa2.Init;

        Miembroscooperativa.Get(LinNomCoop."No. empleado");

        Movcooperativa."No. Movimiento" := Movcooperativa2."No. Movimiento" + 1;
        Movcooperativa."Tipo miembro" := Miembroscooperativa."Tipo de miembro";
        Movcooperativa."Employee No." := LinNomCoop."No. empleado";
        Movcooperativa."Fecha registro" := LinNomCoop.Período;
        Movcooperativa."No. documento" := HistCabPrestcooperativa."No. Prestamo";
        Movcooperativa."Tipo transaccion" := Movcooperativa."Tipo transaccion"::Cuota;
        Movcooperativa.Importe := LinNomCoop.Total;
        Movcooperativa."Concepto salarial" := LinNomCoop."Concepto salarial";
        Movcooperativa.Insert;
    end;


    procedure GuardaProvision(CodEmpl: Code[20]; ConceptoSal: Code[20]; PeriodoNom: Date; ImporteProvis: Decimal)
    var
        ProvisionNom: Record "Provisiones nominas11";
    begin
        ProvisionNom.Init;
        ProvisionNom."Cod. Empleado" := CodEmpl;
        ProvisionNom.Periodo := PeriodoNom;
        ProvisionNom."Concepto Salarial" := ConceptoSal;
        ProvisionNom."Importe provisionado" := ImporteProvis;
        if not ProvisionNom.Insert then
            ProvisionNom.Modify;
    end;
}

