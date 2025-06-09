report 76172 "Genera Diario de  proyectos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './GeneraDiariodeproyectos.rdlc';
    Caption = 'Generate Job Journal';

    dataset
    {
        dataitem(Employee; Employee)
        {
            CalcFields = Salario;
            DataItemTableView = SORTING("No.");
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
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Full_Name_; "Full Name")
            {
            }
            column(Resource_No_Caption; FieldCaption("Resource No."))
            {
            }
            column(Resource_No_; "Resource No.")
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
            dataitem("Mov. actividades OJO"; "Mov. actividades OJO")
            {
                DataItemLink = "No. empleado" = FIELD("No.");
                DataItemTableView = SORTING("No. empleado", "Concepto salarial", "Posting Date");
                RequestFilterFields = "Posting Date";
                column(Posting_DateCaption; FieldCaption("Posting Date"))
                {
                }
                column(Posting_Date; "Posting Date")
                {
                    AutoFormatType = 1;
                }
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
                column(Unit_of_Measure_CodeCaption; FieldCaption("Unit of Measure Code"))
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {
                    AutoFormatType = 1;
                }
                column(Work_Type_CodeCaption; FieldCaption("Work Type Code"))
                {
                }
                column(Work_Type_Code; "Work Type Code")
                {
                    AutoFormatType = 1;
                }
                column(Concepto_salarialCaption; FieldCaption("Concepto salarial"))
                {
                }
                column(Concepto_salarial; "Concepto salarial")
                {
                    //ComentadoDecimalPlaces = 0 : 0;
                }
                column(Precio_TarifaCaption; FieldCaption("Precio Tarifa"))
                {
                }
                column(Precio_Tarifa; "Precio Tarifa")
                {
                }
                column(qtyCaption; FieldCaption(Quantity))
                {
                }
                column(qty; Quantity)
                {
                }
                column(amtCaption; FieldCaption(Amount))
                {
                }
                column(amt; Amount)
                {
                }
                column(TotalParaCaptionLbl; Total_Para_CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TestField("Concepto salarial");

                    TotalQty += Quantity;
                    TotalAmt += Amount;
                    if FirstTime then begin
                        LastWedge := "Concepto salarial";
                        LastEmp := "No. empleado";
                        FirstTime := false;
                    end;

                    if ApplyPayroll then begin
                        if (LastWedge <> "Concepto salarial") or
                           (LastEmp <> "No. empleado") then begin
                            PS.Reset;
                            PS.SetRange("No. empleado", "No. empleado");
                            PS.SetRange("Concepto salarial", LastWedge);
                            PS.FindFirst;
                            PS.Validate(Importe, Amt);
                            PS.Validate(Cantidad, 1);
                            PS.Modify;
                            LastWedge := "Concepto salarial";
                            LastEmp := "No. empleado";
                            Amt := 0;
                        end;
                        Amt += Amount;
                    end;

                    if CreateJobJournal then begin
                        CreateJournal
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if ApplyPayroll then begin
                        PS.Reset;
                        PS.SetRange("No. empleado", "No. empleado");
                        PS.SetRange("Concepto salarial", LastWedge);
                        PS.FindFirst;
                        PS.Validate(Importe, Amt);
                        PS.Validate(Cantidad, 1);
                        PS.Modify;
                    end;
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
                MA.Reset;
                MA.SetRange("No. empleado", "No.");
                MA.SetFilter(MA."Posting Date", "Mov. actividades OJO".GetFilter("Posting Date"));
                if not MA.FindFirst then
                    CurrReport.Skip;
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
        Res.Get("Mov. actividades OJO"."No. empleado");

        if Res."Use Time Sheet" then begin
            Date.Reset;
            Date.SetRange(Date."Period Type", Date."Period Type"::Date);
            Date.SetRange(Date."Period Start", "Mov. actividades OJO"."Posting Date");
            Date.FindFirst;
            case Date."Period No." of
                1:
                    begin
                        Date.Reset;
                        Date.SetRange("Period Type", Date."Period Type"::Week);
                        Date.SetRange("Period Start", "Mov. actividades OJO"."Posting Date");
                        Date.FindFirst;

                        TSH.Init;
                        TSH."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.", Today, true);
                        TSH."Starting Date" := Date2."Period Start";
                        TSH."Ending Date" := NormalDate(Date2."Period End");
                        TSH.Validate("Resource No.", "Mov. actividades OJO"."Resource No.");
                        if TSH.Insert then;
                    end;
                else begin
                    Date2.Reset;
                    Date2.SetRange("Period Type", Date2."Period Type"::Week);
                    Date2.SetRange("Period Start", CalcDate('-' + Format(Date."Period No." - 1) + 'D', "Mov. actividades OJO"."Posting Date"));
                    Date2.FindFirst;

                    TSH.Reset;
                    TSH.SetRange("Starting Date", Date2."Period Start");
                    TSH.SetRange("Ending Date", NormalDate(Date2."Period End"));
                    TSH.SetRange("Resource No.", "Mov. actividades OJO"."Resource No.");
                    if not TSH.FindFirst then begin
                        TSH.Init;
                        TSH."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.", Today, true);
                        TSH."Starting Date" := Date2."Period Start";
                        TSH."Ending Date" := NormalDate(Date2."Period End");
                        TSH.Validate("Resource No.", "Mov. actividades OJO"."Resource No.");
                        if TSH.Insert then;
                    end;

                    TSL.Init;
                    NoLin += 1000;
                    TSL.Validate("Time Sheet No.", TSH."No.");
                    TSL."Line No." := NoLin;
                    TSL.Validate("Time Sheet Starting Date", TSH."Starting Date");
                    TSL.Type := TSL.Type::Job;
                    TSL.Validate("Job No.", "Mov. actividades OJO"."Job No.");
                    TSL.Validate("Job Task No.", "Mov. actividades OJO"."Job Task No.");
                    TSL.Validate("Work Type Code", "Mov. actividades OJO"."Work Type Code");
                    //        TSL.validate("Total Quantity","Mov. actividades".Quantity);
                    if TSL.Insert(true) then;

                    TSD.Init;
                    TSD.CopyFromTimeSheetLine(TSL);
                    TSD.Validate(Date, "Mov. actividades OJO"."Posting Date");
                    TSD.Quantity := "Mov. actividades OJO".Quantity;
                    if TSD.Insert(true) then;

                end;
            end;
        end
        else begin
            NoLin += 1000;
            JobJNL.Init;
            JobJNL.Validate("Journal Template Name", ConfNominas."Job Journal Template Name");
            JobJNL.Validate("Journal Batch Name", ConfNominas."Job Journal Batch Name");
            JobJNL."Line No." := NoLin;
            JobJNL."Line Type" := JobJNL."Line Type"::Budget;
            JobJNL.Validate("Job No.", "Mov. actividades OJO"."Job No.");
            JobJNL.Validate("Job Task No.", "Mov. actividades OJO"."Job Task No.");
            JobJNL.Validate("Posting Date", "Mov. actividades OJO"."Posting Date");
            JobJNL.Type := JobJNL.Type::Resource;
            JobJNL.Validate("No.", "Mov. actividades OJO"."Resource No.");
            JobJNL.Validate("Work Type Code", "Mov. actividades OJO"."Work Type Code");
            JobJNL.Validate(Quantity, "Mov. actividades OJO".Quantity);
            if JobJNL.Insert(true) then;
        end;
    end;
}

