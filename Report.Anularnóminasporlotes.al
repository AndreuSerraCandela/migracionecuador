report 76010 "Anular nóminas por lotes"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
            RequestFilterFields = "No. empleado", "Período", "Tipo de nomina";

            trigger OnAfterGetRecord()
            begin
                TipoNom.Get("Tipo de nomina");

                //Anular;

                Borradas := Borradas + 1;
                Ventana.Update(1, Round(Borradas / ABorrar, 1));

                FechaInicio := DMY2Date(1, Date2DMY(Período, 2), Date2DMY(Período, 3));
                Fecha.Reset;
                Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                Fecha.SetRange("Period Start", FechaInicio);
                if Fecha.FindFirst then
                    FechaFin := NormalDate(Fecha."Period End");

                //Se retornan los valores de los saldos de ISR a favor del empleado
                SaldoFavor.SetFilter(Ano, '%1|%2', 0, Date2DMY(FechaInicio, 3));
                SaldoFavor.SetRange("Cód. Empleado", "No. empleado");
                if SaldoFavor.FindFirst then begin
                    HistoricoLinnomina.Reset;
                    HistoricoLinnomina.SetRange("No. empleado", "No. empleado");
                    HistoricoLinnomina.SetRange(Período, Período);
                    HistoricoLinnomina.SetRange("Tipo de nomina", "Tipo de nomina");
                    HistoricoLinnomina.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
                    if HistoricoLinnomina.FindFirst then begin
                        SaldoFavor."Importe Pendiente" += HistoricoLinnomina."ISR compensado";
                        SaldoFavor.Modify;
                    end;
                end;


                HistLinPrestamos.Reset;
                HistLinPrestamos.SetRange("Código Empleado", "No. empleado");
                HistLinPrestamos.SetRange("Fecha Transacción", FechaInicio, FechaFin);
                HistLinPrestamos.SetFilter("No. Cuota", '>0');
                if HistLinPrestamos.FindSet() then
                    repeat
                        HistCabPrestamos.Get(HistLinPrestamos."No. Préstamo");

                        HistoricoLinnomina.Reset;
                        HistoricoLinnomina.SetRange("No. empleado", "No. empleado");
                        HistoricoLinnomina.SetRange(Período, Período);
                        HistoricoLinnomina.SetRange("Tipo de nomina", "Tipo de nomina");
                        HistoricoLinnomina.SetRange("Concepto salarial", HistCabPrestamos."Concepto Salarial");
                        if HistoricoLinnomina.FindFirst then begin
                            HistLinPrestamos2.Reset;
                            HistLinPrestamos2.CopyFilters(HistLinPrestamos);
                            if HistLinPrestamos2.FindFirst then
                                HistLinPrestamos2.Delete;

                            if HistCabPrestamos.Pendiente = false then begin
                                HistCabPrestamos.Pendiente := true;
                                HistCabPrestamos.Modify;
                            end;
                        end;
                    until HistLinPrestamos.Next = 0;

                Incidencias.SetRange("Employee No.", "No. empleado");
                Incidencias.SetFilter("From Date", '>=%1', GetRangeMin(Período));
                if Incidencias.FindSet() then
                    repeat
                        Incidencias.Closed := false;
                        Incidencias.Modify;
                    until Incidencias.Next = 0;

                if (TipoNom."Tipo de nomina" <> TipoNom."Tipo de nomina"::Prestaciones) and
                    (not ConfNominas."Usar Acciones de personal") then begin
                    Empl.Get("No. empleado");
                    if not Empl."Calcular Nomina" then begin
                        Empl."Calcular Nomina" := true;
                        Empl."Fin contrato" := 0D;
                        Empl.Modify;
                    end;

                    Cont.Reset;
                    Cont.SetRange("Cód. contrato", Empl."Emplymt. Contract Code");
                    Cont.SetRange("No. empleado", "No. empleado");
                    Cont.SetRange(Finalizado, true);
                    if Cont.FindLast then begin
                        Cont2.Reset;
                        Cont2.SetRange("Cód. contrato", Empl."Emplymt. Contract Code");
                        Cont2.SetRange("No. empleado", "No. empleado");
                        Cont2.SetRange(Activo, true);
                        if not Cont.FindFirst then begin
                            //            Cont."Fecha finalización" := 0D;
                            Cont.Validate(Activo, true);
                            Cont.Modify;
                        end;
                    end;
                end;

                CabHistAEmpresa.Reset;
                CabHistAEmpresa.SetFilter(Período, GetFilter(Período));
                CabHistAEmpresa.SetRange("Tipo de nomina", "Tipo de nomina");
                if CabHistAEmpresa.FindFirst then begin
                    if "Historico Cab. nomina".GetFilter("No. empleado") <> '' then
                        CabHistAEmpresa.FiltroEmp("Historico Cab. nomina".GetFilter("No. empleado"));
                    CabHistAEmpresa.Anular;
                end;



                Anular;

                Clear(TotalImporte);
            end;

            trigger OnPostDataItem()
            var
                LinNomina: Record "Historico Lin. nomina";
            begin
                /*
                LinNomina.RESET;
                //LinNomina.SETRANGE("No. empleado","No. empleado");
                LinNomina.SETRANGE(Período,Período);
                LinNomina.SETRANGE("Tipo Nómina","Tipo Nomina");
                IF LinNomina.FINDSET(TRUE,FALSE) THEN
                REPEAT
                 LinNomina.DELETE();
                UNTIL LinNomina.NEXT = 0;
                */

            end;

            trigger OnPreDataItem()
            begin
                if not AnulaContabilizados then
                    SetRange("No. Contabilización", '');
                ABorrar := Count;

                if not Confirm(StrSubstNo(Text001, ABorrar)) then
                    CurrReport.Break;

                Ventana.Open(Text002 + '   @1@@@@@@@@@@@@@    \');

                ABorrar := ABorrar / 10000;
                Borradas := 0;

                ConfNominas.FindFirst;
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
                field("Anular los ya contabilizados"; AnulaContabilizados)
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

    var
        CabHistAEmpresa: Record "Cab. Aportes Empresas";
        LinHistAEmpresa: Record "Lin. Aportes Empresas";
        Incidencias: Record "Employee Absence";
        Fecha: Record Date;
        HistCabPrestamos: Record "Histórico Cab. Préstamo";
        HistLinPrestamos: Record "Histórico Lín. Préstamo";
        HistLinPrestamos2: Record "Histórico Lín. Préstamo";
        ConfNominas: Record "Configuracion nominas";
        SaldoFavor: Record "Saldos a favor ISR";
        Empl: Record Employee;
        Cont: Record Contratos;
        Cont2: Record Contratos;
        TipoNom: Record "Tipos de nominas";
        HistoricoLinnomina: Record "Historico Lin. nomina";
        Ventana: Dialog;
        AnulaContabilizados: Boolean;
        ABorrar: Decimal;
        Borradas: Decimal;
        FechaInicio: Date;
        FechaFin: Date;
        TotalImporte: Decimal;
        Text001: Label 'Do you confirm you want to void %1 entries?';
        Text002: Label 'Voiding ...              \\';
}

