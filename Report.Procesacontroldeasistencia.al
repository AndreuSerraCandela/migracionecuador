report 76173 "Procesa control de asistencia"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Procesacontroldeasistencia.rdlc';
    Caption = 'Generate Job Journal';

    dataset
    {
        dataitem("Control de asistencia"; "Control de asistencia")
        {
            DataItemTableView = SORTING("Cod. Empleado", "Fecha registro") WHERE(Procesado = CONST(false));
            RequestFilterFields = "Fecha registro";
            column(TrabajosEmplporproyectosCaptionLbl; TrabajosEmpl_por_proyectosCaptionLbl)
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
            column(Cod__Empleado; "Cod. Empleado")
            {
            }
            column(Full_Name_; "Full name")
            {
            }
            column(Job_Title; "Job Title")
            {
            }
            column(Primera_Entrada; "1ra entrada")
            {
            }
            column(Primera_Salida; "1ra salida")
            {
            }
            column(Segunda_Entrada; "2da entrada")
            {
            }
            column(Segunda_Salida; "2da salida")
            {
            }
            column(Total_Horas; "Total Horas")
            {
            }
            column(Horas_receso; "Horas receso")
            {
            }
            column(Horas_laboradas2; "Horas laboradas")
            {
            }
            column(TotalGralCaptionLbl; Total_Gral_CaptionLbl)
            {
            }
            column(Total_Qty; TotalQty)
            {
            }
            column(Total_Amt; TotalAmt)
            {
            }
            dataitem("Distrib. Control de asis. Proy"; "Distrib. Control de asis. Proy")
            {
                DataItemLink = "Cod. Empleado" = FIELD("Cod. Empleado"), "Fecha registro" = FIELD("Fecha registro");
                DataItemTableView = SORTING("Cod. Empleado", "Fecha registro", "Hora registro", "No. Linea");
                column(Job_No_Caption; FieldCaption("Job No."))
                {
                }
                column(Job_No_; "Job No.")
                {
                    AutoFormatType = 1;
                }
                column(Job_Task_No_Caption; FieldCaption("Job Task No."))
                {
                }
                column(Job_Task_No_; "Job Task No.")
                {
                    AutoFormatType = 1;
                }
                column(Horas_laboradasCaption; FieldCaption("Horas laboradas"))
                {
                }
                column(Horas_laboradas; "Horas laboradas")
                {
                    AutoFormatType = 1;
                }
                column(Horas_regularesCaption; FieldCaption("Horas regulares"))
                {
                }
                column(Horas_regulares; "Horas regulares")
                {
                    AutoFormatType = 1;
                }
                column(Horas_extras35Caption; FieldCaption("Horas extras al 35"))
                {
                }
                column(Horas_extras35; "Horas extras al 35")
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Horas_extras100Caption; FieldCaption("Horas extras al 100"))
                {
                }
                column(Horas_extras100; "Horas extras al 100")
                {
                }
                column(Horas_nocturnasCaption; FieldCaption("Horas nocturnas"))
                {
                }
                column(Horas_nocturnas; "Horas nocturnas")
                {
                }
                column(Horas_feriadasCaption; FieldCaption("Horas feriadas"))
                {
                }
                column(Horas_feriadas; "Horas feriadas")
                {
                }
                column(TotalimputadasCaption; FieldCaption("Total Horas imputadas"))
                {
                }
                column(Totalimputadas; "Total Horas imputadas")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //MESSAGE('%1 %2 %3 %4 %5',"horas laboradas","Horas regulares");

                    /*
                    TESTFIELD("Concepto salarial");
                    
                    TotalQty += Quantity;
                    TotalAmt += Amount;
                    IF FirstTime THEN
                       BEGIN
                        LastWedge := "Concepto salarial";
                        LastEmp   := "No. empleado";
                        FirstTime := FALSE;
                       END;
                    
                    IF ApplyPayroll THEN
                       BEGIN
                        IF (LastWedge <> "Concepto salarial") OR
                           (LastEmp <> "No. empleado") THEN
                           BEGIN
                            PS.RESET;
                            PS.SETRANGE("No. empleado","No. empleado");
                            PS.SETRANGE("Concepto salarial",LastWedge);
                            PS.FINDFIRST;
                            PS.VALIDATE(Importe,Amt);
                            PS.VALIDATE(Cantidad,1);
                            PS.MODIFY;
                            LastWedge := "Concepto salarial";
                            LastEmp   := "No. empleado";
                            Amt       := 0;
                           END;
                        Amt += Amount;
                       END;
                    
                    IF CreateJobJournal THEN
                       BEGIN
                        CreateJournal
                       END;
                    */

                end;

                trigger OnPostDataItem()
                begin
                    /*
                    IF ApplyPayroll THEN
                       BEGIN
                        PS.RESET;
                        PS.SETRANGE("No. empleado","No. empleado");
                        PS.SETRANGE("Concepto salarial",LastWedge);
                        PS.FINDFIRST;
                        PS.VALIDATE(Importe,Amt);
                        PS.VALIDATE(Cantidad,1);
                        PS.MODIFY;
                       END;
                    */

                end;

                trigger OnPreDataItem()
                begin
                    Clear(LastWedge);
                    Amt := 0;

                    FirstTime := true;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                /*
                MA.RESET;
                MA.SETRANGE("No. empleado","No.");
                MA.SETFILTER(MA."Posting Date","Mov. actividades".GETFILTER("Posting Date"));
                IF NOT MA.FINDFIRST THEN
                   CurrReport.SKIP;
                */

            end;

            trigger OnPreDataItem()
            begin
                ConfNominas.Get();
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
                field("Aplicar a nómina"; ApplyPayroll)
                {
                ApplicationArea = All;
                    Caption = 'Apply to payroll';
                }
                field(CreateJobJournal; CreateJobJournal)
                {
                ApplicationArea = All;
                    Caption = 'Create Job Journal';
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
        Emp: Record Employee;
        Fecha: Record Date;
        TrabajosEmpl_por_proyectosCaptionLbl: Label 'List Employees work Projects';
        Total_Para_CaptionLbl: Label 'Total for ';
        Total_Gral_CaptionLbl: Label 'Grand total';
        MA: Record "Mov. actividades OJO";
        PS: Record "Perfil Salarial";
        LastWedge: Code[20];
        LastEmp: Code[20];
        FirstTime: Boolean;
        TotalQty: Decimal;
        TotalAmt: Decimal;
        ApplyPayroll: Boolean;
        CreateJobJournal: Boolean;
        Amt: Decimal;
        "Mov. actividades": Record "Control de asistencia";


    procedure CreateJournal()
    var
        ResourcesSetup: Record "Resources Setup";
        Res: Record Resource;
        TSH: Record "Time Sheet Header";
        TSL: Record "Time Sheet Line";
        TSD: Record "Time Sheet Detail";
        JobJNL: Record "Job Journal Line";
        Date: Record Date;
        Date2: Record Date;
        NoSeriesMgt: Codeunit "No. Series";
        NoLin: Integer;
    begin
        /*Res.GET("Mov. actividades"."No. empleado");
        
        IF Res."Use Time Sheet" THEN
           BEGIN
            Date.RESET;
            Date.SETRANGE(Date."Period Type",Date."Period Type"::Date);
            Date.SETRANGE(Date."Period Start","Mov. actividades"."Posting Date");
            Date.FINDFIRST;
            CASE Date."Period No." OF
             1:
              BEGIN
               Date.RESET;
               Date.SETRANGE("Period Type",Date."Period Type"::Week);
               Date.SETRANGE("Period Start","Mov. actividades"."Posting Date");
               Date.FINDFIRST;
        
               TSH.INIT;
               TSH."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.",TODAY,TRUE);
               TSH."Starting Date" := Date2."Period Start";
               TSH."Ending Date" := NORMALDATE(Date2."Period End");
               TSH.VALIDATE("Resource No.","Mov. actividades"."Resource No.");
               IF TSH.INSERT THEN;
              END;
            ELSE
               BEGIN
                Date2.RESET;
                Date2.SETRANGE("Period Type",Date2."Period Type"::Week);
                Date2.SETRANGE("Period Start",CALCDATE('-' + FORMAT(Date."Period No." -1) + 'D',"Mov. actividades"."Posting Date"));
                Date2.FINDFIRST;
        
                TSH.RESET;
                TSH.SETRANGE("Starting Date",Date2."Period Start");
                TSH.SETRANGE("Ending Date",NORMALDATE(Date2."Period End"));
                TSH.SETRANGE("Resource No.","Mov. actividades"."Resource No.");
                IF NOT TSH.FINDFIRST THEN
                   BEGIN
                     TSH.INIT;
                     TSH."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.",TODAY,TRUE);
                     TSH."Starting Date" := Date2."Period Start";
                     TSH."Ending Date" := NORMALDATE(Date2."Period End");
                     TSH.VALIDATE("Resource No.","Mov. actividades"."Resource No.");
                     IF TSH.INSERT THEN;
                   END;
        
                TSL.INIT;
                NoLin += 1000;
                TSL.VALIDATE("Time Sheet No.",TSH."No.");
                TSL."Line No." := NoLin;
                TSL.VALIDATE("Time Sheet Starting Date",TSH."Starting Date");
                TSL.Type := TSL.Type::Job;
                TSL.VALIDATE("Job No.","Mov. actividades"."Job No.");
                TSL.VALIDATE("Job Task No.","Mov. actividades"."Job Task No.");
                TSL.VALIDATE("Work Type Code","Mov. actividades"."Work Type Code");
        //        TSL.validate("Total Quantity","Mov. actividades".Quantity);
                IF TSL.INSERT(TRUE) THEN;
        
                TSD.INIT;
                TSD.CopyFromTimeSheetLine(TSL);
                TSD.VALIDATE(Date,"Mov. actividades"."Posting Date");
                TSD.Quantity := "Mov. actividades".Quantity;
                IF TSD.INSERT(TRUE) THEN;
        
               END;
             END;
            END
         ELSE
            BEGIN
             NoLin += 1000;
             JobJNL.INIT;
             JobJNL.VALIDATE("Journal Template Name",ConfNominas."Job Journal Template Name");
             JobJNL.VALIDATE("Journal Batch Name",ConfNominas."Job Journal Batch Name");
             JobJNL."Line No."     := NoLin;
             JobJNL."Line Type"    := 1;
             JobJNL.VALIDATE("Job No.","Mov. actividades"."Job No.");
             JobJNL.VALIDATE("Job Task No.","Mov. actividades"."Job Task No.");
             JobJNL.VALIDATE("Posting Date","Mov. actividades"."Posting Date");
             JobJNL.Type           := 0;
             JobJNL.VALIDATE("No.","Mov. actividades"."Resource No.");
             JobJNL.VALIDATE("Work Type Code","Mov. actividades"."Work Type Code");
             JobJNL.VALIDATE(Quantity,"Mov. actividades".Quantity);
             IF JobJNL.INSERT(TRUE) THEN;
            END;
        */

    end;
}

