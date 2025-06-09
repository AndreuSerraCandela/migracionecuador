report 76271 "Listado Nomina Proyectos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListadoNominaProyectos.rdlc';
    Caption = 'Job Payroll Report';

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
                    //Comentado DecimalPlaces = 0 : 0;
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
        GenerateJobJournal: Boolean;
        LastWedge: Code[20];
        LastEmp: Code[20];
        FirstTime: Boolean;
        TotalQty: Decimal;
        TotalAmt: Decimal;
        ApplyPayroll: Boolean;
        Amt: Decimal;
}

