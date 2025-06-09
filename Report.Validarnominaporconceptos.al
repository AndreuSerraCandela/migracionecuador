report 76175 "Validar nomina por conceptos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Validarnominaporconceptos.rdlc';
    Caption = 'Validate payroll by wage';

    dataset
    {
        dataitem("Historico Lin. nomina"; "Historico Lin. nomina")
        {
            DataItemTableView = SORTING ("Concepto salarial");
            RequestFilterFields = "Concepto salarial", "Tipo de nomina", "Período";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(GETFILTERS; GetFilters)
            {
            }
            column(TIME; Time)
            {
            }
            column("Histórico_Lín__nómina__Concepto_salarial_"; "Concepto salarial")
            {
            }
            column("Histórico_Lín__nómina_Descripción"; Descripción)
            {
            }
            column("Histórico_Lín__nómina__Concepto_salarial__Control14"; "Concepto salarial")
            {
            }
            column("Histórico_Lín__nómina_Descripción_Control17"; Descripción)
            {
            }
            column("Histórico_Lín__nómina_Cantidad"; Cantidad)
            {
            }
            column("Histórico_Lín__nómina_Total"; Total)
            {
            }
            column(rEmpleado__Full_Name_; rEmpleado."Full Name")
            {
            }
            column("Histórico_Lín__nómina__No__empleado_"; "No. empleado")
            {
            }
            column("Histórico_Lín__nómina_Total_Control7"; Abs(Total))
            {
            }
            column("Histórico_Lín__nómina_Cantidad_Control1000000000"; Cantidad)
            {
            }
            column("Histórico_Lín__nómina_Total_Control10"; Abs(Total))
            {
            }
            column(TotalEmpl; TotalEmpl)
            {
            }
            column("Histórico_Lín__nómina_Cantidad_Control1000000001"; Cantidad)
            {
            }
            column(Resumen_Importes_PagadosCaption; Resumen_Importes_PagadosCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Full_nameCaption; Full_nameCaptionLbl)
            {
            }
            column("Histórico_Lín__nómina_CantidadCaption"; FieldCaption(Cantidad))
            {
            }
            column("Histórico_Lín__nómina_TotalCaption"; FieldCaption(Total))
            {
            }
            column("Histórico_Lín__nómina__No__empleado_Caption"; FieldCaption("No. empleado"))
            {
            }
            column(Total_empleadoCaption; Total_empleadoCaptionLbl)
            {
            }
            column(Total_generalCaption; Total_generalCaptionLbl)
            {
            }
            column("Histórico_Lín__nómina_Tipo_Nómina"; "Tipo Nómina")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //IF InicPer = 0D THEN
                //   ERROR('Se debe introducir una fecha inicio de proceso');

                rEmpleado.Get("No. empleado");

                /*
                //Para las deducciones sobre los ingresos diferentes del sueldo base
                IF "Deducir dias" THEN
                   BEGIN
                     ConfNominas.FIND('-');
                     DiasAusencia     := 0;
                     FechaIniAusencia := 0D;
                     FechafinAusencia := 0D;
                     rAusencia.RESET;
                     rAusencia.SETRANGE("no. empleado", "no. empleado");
                     rAusencia.SETRANGE("Acredita carencia", TRUE);
                     //GRN rAusencia.SETFILTER("Fecha finalización", '>=%1',InicPer);
                     rAusencia.SETFILTER("Fecha inicio", '>%1',DMY2DATE(ConfNominas."Día Corte Incidencias",
                                     DATE2DMY(CALCDATE('-1M',InicPer),2),DATE2DMY(CALCDATE('-1M',InicPer),3)));
                
                     IF rAusencia.FIND('-') THEN
                        BEGIN
                          IF (rAusencia."Fecha finalización" <= DMY2DATE(ConfNominas."Día Corte Incidencias",DATE2DMY(FinPer,2),
                                                                DATE2DMY(FinPer,3))) AND
                             (rAusencia."Fecha inicio"      >= DMY2DATE(ConfNominas."Día Corte Incidencias",
                              DATE2DMY(CALCDATE('-1M',InicPer),2),DATE2DMY(CALCDATE('-1M',InicPer),3))) THEN
                              DiasAusencia := (rAusencia."Fecha finalización" - rAusencia."Fecha inicio" + 1) * (rAusencia."% Jornada"/100)
                          ELSE
                          IF (rAusencia."Fecha finalización" > DMY2DATE(ConfNominas."Día Corte Incidencias",DATE2DMY(FinPer,2),
                                                                        DATE2DMY(FinPer,3))) AND
                             (rAusencia."Fecha inicio"       >= DMY2DATE(ConfNominas."Día Corte Incidencias",
                              DATE2DMY(CALCDATE('-1M',InicPer),2),DATE2DMY(CALCDATE('-1M',InicPer),3))) THEN
                              DiasAusencia := (DMY2DATE(ConfNominas."Día Corte Incidencias",DATE2DMY(FinPer,2),DATE2DMY(FinPer,3))
                                              - rAusencia."Fecha inicio" + 1) * (rAusencia."% Jornada"/100);
                        END;
                
                     IF Contrato."Tipo jornada" = Contrato."Tipo jornada"::Quincenales THEN
                        BEGIN
                          CantidadDias := 15;
                          IF DiasAusencia > 15 THEN
                             DiasAusencia := 15;
                        END
                     ELSE
                     IF Contrato."Tipo jornada" = Contrato."Tipo jornada"::Mensuales THEN
                        BEGIN
                          CantidadDias := 30;
                          IF DiasAusencia >  30 THEN
                             DiasAusencia := 30;
                
                          IF rEmpleado."Antigüedad empresa" >= InicPer THEN
                             BEGIN
                               IF DATE2DMY(FinPer,1) > 30 THEN
                                  CantidadDias    := DMY2DATE(30,DATE2DMY(FinPer,2),DATE2DMY(FinPer,3)) - rEmpleado."Antigüedad empresa" + 1
                               ELSE
                                  CantidadDias    := FinPer - rEmpleado."Antigüedad empresa" + 1;
                             END;
                
                        END;
                
                //GRN MESSAGE('%1 %2 %3 %4',"Deducir dias",CantidadDias, DiasAusencia,ImptLín);
                
                     DiasCotizadosPago := CantidadDias - DiasAusencia;
                     IF CantidadDias <= 0 THEN
                        CantidadDias := 1;
                
                     Importe    := Importe / 30 * DiasCotizadosPago;
                
                   END;
                */

                if "No. empleado" <> EmplAnt then begin
                    EmplAnt := "No. empleado";
                    TotalEmpl += 1;
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

    var
        rFecha: Record Date;
        rEmpleado: Record Employee;
        ConfNominas: Record "Configuracion nominas";
        DiasAusencia: Decimal;
        FechaIniAusencia: Date;
        FechafinAusencia: Date;
        InicPer: Date;
        FinPer: Date;
        CantidadDias: Integer;
        DiasCotizadosPago: Decimal;
        TotalEmpl: Decimal;
        Dia: Integer;
        Mes: Integer;
        "Año": Integer;
        FechaInicio: Date;
        EmplAnt: Code[20];
        Resumen_Importes_PagadosCaptionLbl: Label 'Resumen Importes Pagados';
        CurrReport_PAGENOCaptionLbl: Label 'página';
        Full_nameCaptionLbl: Label 'Full name';
        Total_empleadoCaptionLbl: Label 'Total empleado';
        Total_generalCaptionLbl: Label 'Total general';
}

