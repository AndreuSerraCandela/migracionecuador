report 76035 "Valida Diario Nom. - Proyectos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ValidaDiarioNomProyectos.rdlc';
    Caption = 'Test Job payroll journal';

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
            dataitem("Payroll - Job Journal Line"; "Payroll - Job Journal Line")
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
                    //DecimalPlaces = 0 : 0;
                }
                column(Concepto_Sal_Desc; ConceptoSalDesc)
                {
                }
                column(Precio_TarifaCaption; FieldCaption("Precio Costo"))
                {
                }
                column(Precio_Tarifa; "Precio Costo")
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

                    ConceptoSal.Get("Concepto salarial");
                    ConceptoSalDesc := ConceptoSal.Descripcion;

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

                    if ApplytoJobJnl then begin
                        Res.Get("Payroll - Job Journal Line"."Resource No.");

                        if Res."Use Time Sheet" then begin
                            Date.Reset;
                            Date.SetRange(Date."Period Type", Date."Period Type"::Date);
                            Date.SetRange(Date."Period Start", "Payroll - Job Journal Line"."Posting Date");
                            Date.FindFirst;
                            case Date."Period No." of
                                1:
                                    begin
                                        Date.Reset;
                                        Date.SetRange("Period Type", Date."Period Type"::Week);
                                        Date.SetRange("Period Start", "Payroll - Job Journal Line"."Posting Date");
                                        Date.FindFirst;

                                        TSH.Init;
                                        TSH."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.", Today, true);
                                        TSH."Starting Date" := Date."Period Start";
                                        TSH."Ending Date" := NormalDate(Date."Period End");
                                        TSH.Validate("Resource No.", "Resource No.");
                                        if TSH.Insert then;
                                    end;
                                else begin
                                    Date2.Reset;
                                    Date2.SetRange("Period Type", Date2."Period Type"::Week);
                                    Date2.SetRange("Period Start", CalcDate('-' + Format(Date."Period No." - 1) + 'D', "Payroll - Job Journal Line"."Posting Date"));
                                    Date2.FindFirst;

                                    TSH.Reset;
                                    TSH.SetRange("Starting Date", Date2."Period Start");
                                    TSH.SetRange("Ending Date", NormalDate(Date2."Period End"));
                                    TSH.SetRange("Resource No.", "Resource No.");
                                    if not TSH.FindFirst then begin
                                        TSH.Init;
                                        TSH."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.", Today, true);
                                        TSH."Starting Date" := Date2."Period Start";
                                        TSH."Ending Date" := NormalDate(Date2."Period End");
                                        TSH.Validate("Resource No.", "Resource No.");
                                        if TSH.Insert then;
                                    end;

                                    TSL.Init;
                                    NoLin += 1000;
                                    TSL.Validate("Time Sheet No.", TSH."No.");
                                    TSL."Line No." := NoLin;
                                    TSL.Validate("Time Sheet Starting Date", TSH."Starting Date");
                                    TSL.Type := TSL.Type::Job;
                                    TSL.Validate("Job No.", "Payroll - Job Journal Line"."Job No.");
                                    TSL.Validate("Job Task No.", "Payroll - Job Journal Line"."Job Task No.");
                                    TSL.Validate("Work Type Code", "Payroll - Job Journal Line"."Work Type Code");
                                    //        TSL.validate("Total Quantity","Payroll - Job Journal Line".Quantity);
                                    if TSL.Insert(true) then;

                                    TSD.Init;
                                    TSD.CopyFromTimeSheetLine(TSL);
                                    TSD.Validate(Date, "Payroll - Job Journal Line"."Posting Date");
                                    TSD.Quantity := "Payroll - Job Journal Line".Quantity;
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
                            JobJNL.Validate("Job No.", "Payroll - Job Journal Line"."Job No.");
                            JobJNL.Validate("Job Task No.", "Payroll - Job Journal Line"."Job Task No.");
                            JobJNL.Validate("Posting Date", "Payroll - Job Journal Line"."Posting Date");
                            JobJNL.Type := JobJNL.Type::Resource;
                            JobJNL.Validate("No.", "Payroll - Job Journal Line"."Resource No.");
                            JobJNL.Validate("Work Type Code", "Payroll - Job Journal Line"."Work Type Code");
                            JobJNL.Validate(Quantity, "Payroll - Job Journal Line".Quantity);
                            //      JobJNL.VALIDATE("Direct Unit Cost (LCY)", "Payroll - Job Journal Line"."Precio Tarifa";
                            if JobJNL.Insert(true) then;
                        end;
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
                MA.SetFilter(MA."Posting Date", "Payroll - Job Journal Line".GetFilter("Posting Date"));
                if not MA.FindFirst then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                ConfNominas.Get();
                ResourcesSetup.Get();

                ResourcesSetup.TestField("Time Sheet Nos.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
        ApplytoJobJnl := false;
        ApplyPayroll := false;
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        Emp: Record Employee;
        Fecha: Record Date;
        TrabajosEmpl_por_proyectosCaptionLbl: Label 'Test Job payroll journal';
        Total_Para_CaptionLbl: Label 'Total for ';
        Total_Gral_CaptionLbl: Label 'Grand total';
        MA: Record "Mov. actividades OJO";
        PS: Record "Perfil Salarial";
        ConceptoSal: Record "Conceptos salariales";
        TSH: Record "Time Sheet Header";
        TSL: Record "Time Sheet Line";
        TSD: Record "Time Sheet Detail";
        JobJNL: Record "Job Journal Line";
        Res: Record Resource;
        Date: Record Date;
        Date2: Record Date;
        ResourcesSetup: Record "Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        ConceptoSalDesc: Text[1024];
        ApplytoJobJnl: Boolean;
        ApplyPayroll: Boolean;
        LastWedge: Code[20];
        LastEmp: Code[20];
        FirstTime: Boolean;
        TotalQty: Decimal;
        TotalAmt: Decimal;
        Amt: Decimal;
        LineNo: Integer;
        NoLin: Integer;
}

