report 76039 "Llena Plantilla TSS Autodet."
{
    // Tipo de novedad
    //   IN = Ingreso
    //   SA = Salida
    //   VC = Vacaciones 1
    //   LV = Licencia Voluntaria
    //   LM = Licencia x Maternidad
    //   LD = Licencia x Discapacidad.
    //   AD = Actualización de Datos del trabajador (Ej. Salario)

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");
            dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
            {
                DataItemLink = "No. empleado" = FIELD("No.");
                DataItemTableView = SORTING("No. empleado");
                RequestFilterFields = "No. empleado", "Período";

                trigger OnAfterGetRecord()
                begin
                    HayNomina := true;
                    CalcFields("Total Ingresos");
                    if ("Total Ingresos" = 0) then begin
                        HayNomina := false;
                        CurrReport.Skip;
                    end;

                    Clear(LinNomina);
                    LinNomina.SetRange("No. empleado", "No. empleado");
                    LinNomina.SetRange("Tipo Nómina", "Tipo Nomina");
                    LinNomina.SetRange(Período, Período);
                    LinNomina.SetRange("No. Documento", "No. Documento");
                    LinNomina.SetRange("Sujeto Cotización", true);
                    LinNomina.SetRange("Tipo concepto", LinNomina."Tipo concepto"::Ingresos);
                    if LinNomina.FindSet() then
                        repeat
                            if not Employee."Excluído Cotización TSS" then
                                SalarioCotizable += LinNomina.Total;
                        until LinNomina.Next = 0;

                    //ISR
                    Tiposdenominas.Reset;
                    Tiposdenominas.SetRange("Tipo de nomina", Tiposdenominas."Tipo de nomina"::Prestaciones);
                    Tiposdenominas.FindFirst;

                    Clear(LinNomina);
                    LinNomina.SetRange("No. empleado", "No. empleado");
                    LinNomina.SetRange("Tipo de nomina", "Tipo de nomina");
                    LinNomina.SetRange(Período, Período);
                    LinNomina.SetRange("Cotiza ISR", true);
                    //LinNomina.SETRANGE("Salario Base",TRUE);
                    LinNomina.SetRange("Tipo concepto", LinNomina."Tipo concepto"::Ingresos);
                    if LinNomina.FindSet() then
                        repeat
                            if ((not Empl."Excluído Cotización ISR") and (LinNomina."Cotiza ISR") and (LinNomina."Salario Base")) then
                                SalarioISR += Round(LinNomina.Total, 0.01)
                            else
                                if (ConfNominas."Concepto Vacaciones" = LinNomina."Concepto salarial") and
                                   (Tiposdenominas.Codigo = LinNomina."Tipo de nomina") then
                                    SalarioISR += Round(LinNomina.Total, 0.01)
                        until LinNomina.Next = 0;

                    Clear(LinNomina);
                    LinNomina.SetRange("No. empleado", "No. empleado");
                    LinNomina.SetRange("Tipo Nómina", "Tipo Nomina");
                    LinNomina.SetRange(Período, Período);
                    LinNomina.SetRange("Cotiza ISR", true);
                    LinNomina.SetRange("Salario Base", false);
                    LinNomina.SetRange("Sujeto Cotización", false);
                    LinNomina.SetRange("Tipo concepto", LinNomina."Tipo concepto"::Ingresos);
                    if LinNomina.FindSet() then
                        repeat
                            if (LinNomina."Cotiza ISR" and (not LinNomina."Salario Base") and (ConfNominas."Concepto Vacaciones" <> LinNomina."Concepto salarial")) then
                                OtrasRemuneraciones += Round(LinNomina.Total, 0.01)
                        /*
                        ELSE
                        IF (ConfNominas."Concepto Vacaciones" = LinNomina."Concepto salarial") and
                           (Tiposdenominas.Codigo = LinNomina."Tipo de nomina") THEN
                           OtrasRemuneraciones += LinNomina.Total;
                           */
                        until LinNomina.Next = 0;

                    EmpRel.SetRange("Cod. Empleado", "No. empleado");
                    if EmpRel.FindSet() then
                        repeat
                            Clear(LinNomina);
                            LinNomina.ChangeCompany(EmpRel.Empresa);
                            LinNomina.SetRange("No. empleado", EmpRel."Cod. Empleado en empresa");
                            LinNomina.SetRange("Tipo Nómina", "Tipo Nomina");
                            LinNomina.SetRange(Período, Período);
                            LinNomina.SetRange("Tipo concepto", LinNomina."Tipo concepto"::Ingresos);
                            if LinNomina.FindSet() then
                                repeat
                                    RemOtrosAgentes += LinNomina.Total;
                                until LinNomina.Next = 0;
                        until EmpRel.Next = 0;

                    //Ingresos exentos
                    Clear(LinNomina);
                    LinNomina.SetRange("No. empleado", "No. empleado");
                    LinNomina.SetRange("Tipo de nomina", "Tipo de nomina");
                    LinNomina.SetRange(Período, Período);
                    LinNomina.SetRange("Cotiza ISR", false);
                    LinNomina.SetRange("Sujeto Cotización", false);
                    LinNomina.SetRange("Tipo concepto", LinNomina."Tipo concepto"::Ingresos);
                    LinNomina.SetFilter("Concepto salarial", '<>%1&<>%2&<>%3&<>%4', ConfNominas."Concepto Regalia", ConfNominas."Concepto Cesantia", ConfNominas."Concepto Preaviso", ConfNominas."Concepto Dieta");
                    if LinNomina.FindSet() then
                        repeat
                            IngresosExentos += Round(LinNomina.Total, 0.01);
                        until LinNomina.Next = 0;

                    //Regalia
                    Clear(LinNomina);
                    LinNomina.SetRange("No. empleado", "No. empleado");
                    LinNomina.SetRange("Tipo de nomina", "Tipo de nomina");
                    LinNomina.SetRange(Período, Período);
                    LinNomina.SetRange("Concepto salarial", ConfNominas."Concepto Regalia");
                    LinNomina.SetRange("Tipo concepto", LinNomina."Tipo concepto"::Ingresos);
                    if LinNomina.FindSet() then
                        repeat
                            Regalia += Round(LinNomina.Total, 0.01);
                        until LinNomina.Next = 0;

                    //Preaviso, cesantia,viaticos, indemnizaciones
                    Clear(LinNomina);
                    LinNomina.SetRange("No. empleado", "No. empleado");
                    LinNomina.SetRange(Período, Período);
                    LinNomina.SetRange("Tipo concepto", LinNomina."Tipo concepto"::Ingresos);
                    LinNomina.SetFilter("Concepto salarial", '%1|%2|%3', ConfNominas."Concepto Cesantia", ConfNominas."Concepto Preaviso", ConfNominas."Concepto Dieta");
                    if LinNomina.FindSet() then
                        repeat
                            Preaviso_Cesantia += Round(LinNomina.Total, 0.01);
                        until LinNomina.Next = 0;

                    //INFOTEP
                    Tiposdenominas.Reset;
                    Tiposdenominas.SetRange("Tipo de nomina", Tiposdenominas."Tipo de nomina"::Bonificacion);
                    Tiposdenominas.FindFirst;

                    Clear(LinNomina);
                    LinNomina.SetRange("No. empleado", "No. empleado");
                    LinNomina.SetFilter("Tipo de nomina", '<>%1', Tiposdenominas.Codigo);
                    LinNomina.SetRange(Período, Período);
                    //LinNomina.SETRANGE("No. Documento","No. Documento");
                    //LinNomina.SETRANGE("Cotiza Infotep",TRUE);
                    LinNomina.SetRange("Tipo concepto", LinNomina."Tipo concepto"::Ingresos);
                    if LinNomina.FindSet() then
                        repeat
                            if (LinNomina."Cotiza Infotep" and (ConfNominas."Concepto Bonificacion" <> LinNomina."Concepto salarial")) or
                                (ConfNominas."Concepto Vacaciones" = LinNomina."Concepto salarial") then
                                SalarioInfotep += LinNomina.Total;
                        until LinNomina.Next = 0;

                end;

                trigger OnPostDataItem()
                begin
                    if TipoSalida = 1 then begin
                        if HayNomina then begin
                            //GRN Busco el saldo a favor

                            LinNomina.Reset;
                            LinNomina.SetRange(Período, Período);
                            LinNomina.SetRange("Tipo de nomina", "Tipo de nomina");
                            LinNomina.SetRange("No. empleado", "No. empleado");
                            LinNomina.SetRange("Concepto salarial", ConfNominas."Concepto ISR");

                            if LinNomina.FindFirst then
                                SaldoFavorISR := Abs(LinNomina.Total);
                            /*
                            BKSaldosFavor.RESET;
                            BKSaldosFavor.SETRANGE("Full name","Historico Cab. nomina".Ano);
                            BKSaldosFavor.SETRANGE("Cod. Empleado","Historico Cab. nomina"."No. empleado");
                            IF BKSaldosFavor.FINDFIRST THEN
                               SaldoFavorISR += BKSaldosFavor."Document ID"
                            ELSE
                               BEGIN
                                SaldosFavor.RESET;
                                SaldosFavor.SETRANGE(Ano,"Historico Cab. nomina".Ano);
                                SaldosFavor.SETRANGE("Cód. Empleado","Historico Cab. nomina"."No. empleado");
                                IF SaldosFavor.FINDFIRST THEN
                                   SaldoFavorISR += SaldosFavor."Importe Pendiente"
                               END;
                            */
                            EnterCell(RowNo, 2, '001', false, false, '', ExcelBuf."Cell Type"::Text);

                            case Employee."Document Type" of
                                0:
                                    EnterCell(RowNo, 3, 'C', false, false, '', ExcelBuf."Cell Type"::Text);
                                else
                                    EnterCell(RowNo, 3, 'P', false, false, '', ExcelBuf."Cell Type"::Text);
                            end;

                            EnterCell(RowNo, 4, DelChr(Employee."Document ID", '=', '-'), false, false, '', ExcelBuf."Cell Type"::Text);
                            EnterCell(RowNo, 5, Employee."First Name", false, false, '', ExcelBuf."Cell Type"::Text);
                            EnterCell(RowNo, 6, Employee."Last Name", false, false, '', ExcelBuf."Cell Type"::Text);
                            EnterCell(RowNo, 7, Employee."Second Last Name", false, false, '', ExcelBuf."Cell Type"::Text);

                            if Employee."Salario Empresas Externas" <> 0 then
                                RemOtrosAgentes += Employee."Salario Empresas Externas";

                            case Employee.Gender of
                                "Employee Gender"::Female:
                                    EnterCell(RowNo, 8, 'F', false, false, '', ExcelBuf."Cell Type"::Text);
                                else
                                    EnterCell(RowNo, 8, 'M', false, false, '', ExcelBuf."Cell Type"::Text);
                            end;

                            EnterCell(RowNo, 9, Format(Employee."Birth Date", 2, '<DAY,2>') + Format(Employee."Birth Date", 2, '<MONTH,2>') + Format(Employee."Birth Date", 4, '<YEAR4>'),
                                      false, false, '', ExcelBuf."Cell Type"::Text);
                            EnterCell(RowNo, 10, Format(Round(SalarioCotizable, 0.01), 15, '<Integer><Decimals,3>'), false, false, '', ExcelBuf."Cell Type"::Number);
                            EnterCell(RowNo, 11, Format(0), false, false, '', ExcelBuf."Cell Type"::Number);
                            EnterCell(RowNo, 12, Format(Round(SalarioISR + RemOtrosAgentes, 0.01), 15, '<Integer><Decimals,3>'), false, false, '', ExcelBuf."Cell Type"::Number);
                            //Para los tipos de ingresos
                            if (Empl."Employment Date" > Fecha."Period Start") or
                               (Empl."Termination Date" <> 0D) or (Empl."Fin contrato" <> 0D) then
                                EnterCell(RowNo, 13, 'No laboró mes completo por razones varias', false, false, '', ExcelBuf."Cell Type"::Text)
                            else
                                if Empl."Tipo pago" = Empl."Tipo pago"::"Por hora" then
                                    EnterCell(RowNo, 13, 'Asalariado por hora o labora tiempo parcial', false, false, '', ExcelBuf."Cell Type"::Text)
                                else
                                    if Empl."Tipo Empleado" = Empl."Tipo Empleado"::Temporal then
                                        EnterCell(RowNo, 13, 'Trabajador ocasional (no fijo)', false, false, '', ExcelBuf."Cell Type"::Text)
                                    else
                                        EnterCell(RowNo, 13, 'Normal', false, false, '', ExcelBuf."Cell Type"::Text);

                            EnterCell(RowNo, 14, Format(Round(OtrasRemuneraciones, 0.01), 15, '<Integer><Decimals,3>'), false, false, '', ExcelBuf."Cell Type"::Number);
                            EnterCell(RowNo, 15, Employee."RNC Agente de Retencion ISR", false, false, '', ExcelBuf."Cell Type"::Text);
                            EnterCell(RowNo, 16, Format(RemOtrosAgentes, 15, '<Integer><Decimals,3>'), false, false, '', ExcelBuf."Cell Type"::Number);
                            EnterCell(RowNo, 17, Format(Round(SaldoFavorISR, 0.01), 15, '<Integer><Decimals,3>'), false, false, '', ExcelBuf."Cell Type"::Number);
                            EnterCell(RowNo, 18, Format(Round(Regalia, 0.01), 15, '<Integer><Decimals,3>'), false, false, '', ExcelBuf."Cell Type"::Number);
                            EnterCell(RowNo, 19, Format(Round(Preaviso_Cesantia, 0.01), 15, '<Integer><Decimals,3>'), false, false, '', ExcelBuf."Cell Type"::Number);
                            EnterCell(RowNo, 20, Format(0), false, false, '', ExcelBuf."Cell Type"::Number);
                            //EnterCell(RowNo,17,FORMAT(ROUND(IngresosExentos,0.01),15,'<Integer><Decimals,3>'),FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                            EnterCell(RowNo, 21, Format(Round(SalarioInfotep, 0.01), 15, '<Integer><Decimals,3>'), false, false, '', ExcelBuf."Cell Type"::Number);
                            RowNo += 1;
                        end;
                    end;

                end;

                trigger OnPreDataItem()
                begin
                    SalarioCotizable := 0;
                    SalarioISR := 0;
                    SalarioInfotep := 0;
                    OtrasRemuneraciones := 0;
                    RemOtrosAgentes := 0;
                    IngresosExentos := 0;
                    SaldoFavorISR := 0;
                    Preaviso_Cesantia := 0;
                    Regalia := 0;
                    HayNomina := false;
                    SetRange(Período, FechaIni, FechaFin);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if TipoSalida = 0 then
                    exit;

                Counter += 1;
                Window.Update(1, Round(Counter / CounterTotal * 10000, 1));
            end;

            trigger OnPostDataItem()
            begin
                if TipoSalida = 1 then begin
                    ExcelBuf.CloseBook;
                    /*
                    ExcelBuf.UpdateBook(ServerFileName,SheetName);
                    ExcelBuf.WriteSheet('',COMPANYNAME,USERID);
                    ExcelBuf.CloseBook;
                    ExcelBuf.DownloadAndOpenExcel;
                    ExcelBuf.UpdateBookStream(ExcelBuf,SheetName,true);
                    */
                    /*    ExcelBuf.UpdateBook(ServerFileName, SheetName);
                       ExcelBuf.WriteSheet('', CompanyName, UserId);
                       ExcelBuf.CloseBook; */
                    /*if FileMgt.IsWindowsClient then //Comentado
                        FileMgt.DownloadToFile(ServerFileName, FileName)
                    else
                        ExcelBuf.DownloadAndOpenExcel;*/
                end;


                /*
                Window.CLOSE;
                Counter := 0;
                IF HayNomina THEN
                   BEGIN
                     CounterTotal := ExcelBuf.COUNT;
                     Window.OPEN(Text003);
                     ExcelBuf.FIND('-');
                     REPEAT
                      Counter += 1;
                      Window.UPDATE(1,ROUND(Counter / CounterTotal * 10000,1));
                
                       EnterCell(RowNo,2,'100',FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                
                      CASE Employee."Document Type" OF
                        0:
                         EnterCell(RowNo,3,'C',FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                        ELSE
                         EnterCell(RowNo,3,'P',FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                      END;
                
                      EnterCell(RowNo,4,DELCHR(Employee."Document ID",'=','-'),FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                      EnterCell(RowNo,5,Employee."First Name",FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                      EnterCell(RowNo,6,Employee."Last Name",FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                      EnterCell(RowNo,7,Employee."Second Last Name",FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                
                      CASE Employee.Gender OF
                       1:
                         EnterCell(RowNo,8,'F',FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                       ELSE
                        EnterCell(RowNo,8,'M',FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                      END;
                      EnterCell(RowNo,9,FORMAT(Employee."Birth Date",2,'<DAY,2>')+FORMAT(Employee."Birth Date",2,'<MONTH,2>') + FORMAT(Employee."Birth Date",4,'<YEAR4>'),
                                FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                      EnterCell(RowNo,10,FORMAT(ROUND(SalarioCotizable,0.01),15,'<Integer><Decimals,3>'),FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                      EnterCell(RowNo,11,FORMAT(0),FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                      EnterCell(RowNo,12,FORMAT(ROUND(SalarioISR,0.01),15,'<Integer><Decimals,3>'),FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                      EnterCell(RowNo,13,FORMAT(ROUND(OtrasRemuneraciones,0.01),15,'<Integer><Decimals,3>'),FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                      EnterCell(RowNo,14,Employee."RNC Agente de Retencion ISR",FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                      EnterCell(RowNo,15,FORMAT(RemOtrosAgentes,15,'<Integer><Decimals,3>'),FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                      EnterCell(RowNo,16,FORMAT(ROU0ND(IngresosExentos,0.01),15,'<Integer><Decimals,3>'),FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                      EnterCell(RowNo,17,FORMAT(ROUND(SalarioInfotep,0.01),15,'<Integer><Decimals,3>'),FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                      EnterCell(RowNo,18,'Normal',FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                
                      RowNo += 1;
                      UNTIL ExcelBuf.NEXT = 0;
                   END;
                   */

            end;

            trigger OnPreDataItem()
            begin

                if TipoSalida = 0 then begin

                    //Comentado FormatosLegales.RDAutodeterminacion("Historico Cab. nomina", Ano, ClaveNomina);

                    CurrReport.Break;
                end;
                CounterTotal := Count;
                Window.Open(Text001);
                HayNomina := false;
                //Empresa.GET("Empresa cotización");
                Empresa.FindFirst;

                if TipoSalida = 1 then begin
                    //if IsServiceTier then
                    if UploadedFileName = '' then
                        UploadFile
                    else
                        FileName := UploadedFileName;
                    /*
                      IF ServerFileName = '' THEN
                        ServerFileName := FileMgt.UploadFile(Text002,ExcelFileExtensionTok);
                      IF ServerFileName = '' THEN
                        EXIT;
                    */

                    /* 
                                        if SheetName = '' then
                                            SheetName := ExcelBuf.SelectSheetsName(ServerFileName);

                                        if SheetName = '' then
                                            exit;

                                        ExcelBuf.OpenBook(FileName, SheetName); */
                    //ExcelBuf.SelectSheetsName(SheetName);

                    //Busco el numero de empleados que van a ser procesados
                    PrimeraVez := true;
                    NoLineas := 0;
                    CabNomina.CopyFilters("Historico Cab. nomina");
                    CabNomina.FindSet;
                    repeat
                        if PrimeraVez then begin
                            PrimeraVez := false;
                            CodEmpAnt := CabNomina."No. empleado";
                            NoLineas += 1;
                        end;

                        if CodEmpAnt <> CabNomina."No. empleado" then begin
                            CodEmpAnt := CabNomina."No. empleado";
                            NoLineas += 1;
                        end;
                    until CabNomina.Next = 0;

                    //Llena encabezado
                    EnterCell(6, 4, 'AM', false, false, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(7, 4, Empresa."RNC/CED", false, false, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(8, 4, Format((FechaFin), 0, '<Month,2>') + Format(Ano), false, false, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(10, 5, Format(NoLineas), false, false, '', ExcelBuf."Cell Type"::Text);

                    //Fin Encabezado

                    RowNo := 14;
                end;

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
                field("Año"; Ano)
                {
                ApplicationArea = All;
                }
                field(Mes; Mes)
                {
                ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                        Fecha.SetRange("Period Start", DMY2Date(1, Mes + 1, Ano));
                        Fecha.FindFirst;

                        FechaIni := Fecha."Period Start";
                        FechaFin := NormalDate(Fecha."Period End");
                    end;
                }
                field(ClaveNomina; ClaveNomina)
                {
                ApplicationArea = All;
                    Caption = 'Payroll ID TSS';
                }
                field(TipoSalida; TipoSalida)
                {
                ApplicationArea = All;
                    Caption = 'File format';
                    OptionCaption = 'Txt,Excel';

                    trigger OnValidate()
                    begin
                        EditaDatos := false;
                        if TipoSalida = TipoSalida::Excel then
                            EditaDatos := true;
                    end;
                }
                field("Nombre fichero libro"; FileName)
                {
                ApplicationArea = All;
                    Editable = EditaDatos;

                    trigger OnAssistEdit()
                    begin
                        UploadFile;
                    end;
                }
                field("Nombre Hoja"; SheetName)
                {
                ApplicationArea = All;
                    Editable = EditaDatos;

                    trigger OnAssistEdit()
                    begin
                        /*                 if IsServiceTier then
                                            SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                                        else
                                            SheetName := ExcelBuf.SelectSheetsName(FileName); */
                    end;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            EditaDatos := false;
            if TipoSalida = TipoSalida::Excel then
                EditaDatos := true;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Employee.SetFilter("No.", "Historico Cab. nomina".GetFilter("No. empleado"));
    end;

    trigger OnPreReport()
    begin
        ConfNominas.Get();
        if Ano = 0 then
            Ano := Date2DMY(Today, 3);

        if "Historico Cab. nomina".GetFilter(Período) = '' then
            Error(Err001);

        Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
        Fecha.SetFilter("Period Start", "Historico Cab. nomina".GetFilter(Período));
        Fecha.FindFirst;

        FechaIni := "Historico Cab. nomina".GetRangeMin(Período);
        FechaFin := "Historico Cab. nomina".GetRangeMax(Período);

        ExcelBuf.DeleteAll;
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        Empl: Record Employee;
        Empresa: Record "Empresas Cotizacion";
        CabNomina: Record "Historico Cab. nomina";
        LinNomina: Record "Historico Lin. nomina";
        EmpRel: Record "Relacion Empresas Empleados";
        Fecha: Record Date;
        ExcelBuf: Record "Excel Buffer" temporary;
        BKSaldosFavor: Record "Prestaciones masivas";
        SaldosFavor: Record "Saldos a favor ISR";
        CauseofAbsence: Record "Cause of Absence";
        Conceptossalariales: Record "Conceptos salariales";
        Tiposdenominas: Record "Tipos de nominas";
        FileMgt: Codeunit "File Management";
        //Comentado FormatosLegales: Codeunit "Genera formatos elect. legales";
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        CounterTotal: Integer;
        Window: Dialog;
        Counter: Integer;
        CantLin: Integer;
        SalarioCotizable: Decimal;
        SalarioISR: Decimal;
        SalarioInfotep: Decimal;
        OtrasRemuneraciones: Decimal;
        RemOtrosAgentes: Decimal;
        IngresosExentos: Decimal;
        SaldoFavorISR: Decimal;
        Fila: Text[10];
        RowNo: Integer;
        NoRec: Integer;
        Option: Option "Create Workbook","Update Workbook";
        FileNameEnable: Boolean;
        SheetNameEnable: Boolean;
        PathArchivo: Text[150];
        Fichero: File;
        "Product Cell": Text[30];
        Text001: Label 'Exporting @1@@@@@@@@@@@@@';
        Text002: Label 'Update Workbook';
        GenerarArchivo: Boolean;
        Mes: Option Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
        Ano: Integer;
        FechaIni: Date;
        FechaFin: Date;
        Text003: Label 'Filling document @1@@@@@@@@@@@@@';
        Text006: Label 'Import Excel File';
        HayNomina: Boolean;
        Err001: Label 'Please select a payroll period';
        ServerFileName: Text;
        ExcelFileExtensionTok: Label '.xlsx', Locked = true;
        TipoSalida: Option Txt,Excel;
        EditaDatos: Boolean;
        ClaveNomina: Code[3];
        PrimeraVez: Boolean;
        CodEmpAnt: Code[20];
        NoLineas: Integer;
        Preaviso_Cesantia: Decimal;
        Regalia: Decimal;


    procedure UploadFile()
    var
        ClientFileName: Text[1024];
    begin
        /*  UploadedFileName := FileMgt.UploadFile(Text006, ExcelFileExtensionTok); */
        FileName := UploadedFileName;
        ServerFileName := FileName;
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; UnderLine: Boolean; NumberFormat: Text[30]; CellType: Option)
    begin
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf."Cell Type" := CellType;
        ExcelBuf.Insert;
    end;


    procedure SetFileNameSilent(NewFileName: Text)
    begin
        ServerFileName := NewFileName;
    end;
}

