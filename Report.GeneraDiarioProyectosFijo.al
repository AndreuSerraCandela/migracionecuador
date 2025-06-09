report 76301 "Genera Diario Proyectos - Fijo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './GeneraDiarioProyectosFijo.rdlc';
    Caption = 'Generate Job Journal from employees distribution';

    dataset
    {
        dataitem(Employee; Employee)
        {
            CalcFields = Salario;
            DataItemTableView = SORTING("No.") WHERE("Calcular Nomina" = CONST(true));
            RequestFilterFields = "No.";
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
            dataitem("Relacion Empleados - Proyectos"; "Relacion Empleados - Proyectos")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = SORTING("Employee No.", "Job No.", "Job Task No.");
                RequestFilterFields = "Job No.";
                column(Job_No_Caption; FieldCaption("Job No."))
                {
                }
                column(JobNo_; "Job No.")
                {
                }
                column(Job_Task_No_Caption; FieldCaption("Job Task No."))
                {
                }
                column(JobTaskNo_; "Job Task No.")
                {
                }
                column(JobLineType_Caption; FieldCaption("Job Line Type"))
                {
                }
                column(JobLineType_; "Job Line Type")
                {
                }
                column(JobUnitPrice_Caption; FieldCaption("Job Unit Price"))
                {
                }
                column(JobUnitPrice_; "Job Unit Price")
                {
                }
                column(JobDescription_Caption; FieldCaption("Job Description"))
                {
                }
                column(JobDescription_; "Job Description")
                {
                }
                column(JobTaskName_Caption; FieldCaption("Job Task Name"))
                {
                }
                column(JobTaskName_; "Job Task Name")
                {
                }
                column(todistribute_Caption; FieldCaption("% to distribute"))
                {
                }
                column(todistribute_; "% to distribute")
                {
                }
                column(Employee_Salario_Caption; Employee.FieldCaption(Salario))
                {
                }
                column(Employee_Salario; Employee.Salario)
                {
                }
                column(Importe_Caption; Text001)
                {
                }
                column(Amount_; Amt)
                {
                }
                column(TotalParaCaptionLbl; Total_Para_CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Amt := Round("% to distribute" / 100 * Employee.Salario, 0.01);

                    if GenerateJournal then begin
                        NoLin += 1000;
                        JobJNL.Init;
                        JobJNL.Validate("Journal Template Name", ConfNom."Job Journal Template Name");
                        JobJNL.Validate("Journal Batch Name", ConfNom."Job Journal Batch Name");
                        JobJNL."Line No." := NoLin;


                        JobJNL.Validate("Job No.", "Job No.");
                        JobJNL.Validate("Job Task No.", "Job Task No.");
                        JobJNL.Validate("No.", Employee."Resource No.");
                        JobJNL.Validate("Posting Date", WorkDate);
                        JobJNL.Type := JobJNL.Type::Resource;
                        /*
                              JobJNL.VALIDATE("Work Type Code",ConfIDC."Def. Work Type Code");
                              JobJNL.VALIDATE("Gen. Bus. Posting Group",ConfIDC."Def. Gen. Bus. Posting Group");
                              JobJNL.VALIDATE("Gen. Prod. Posting Group",ConfIDC."Def. Gen. Prod. Posting Group");
                        */
                        JobJNL.Validate(Quantity, 1);
                        JobJNL."Document No." := DocNo;
                        JobJNL.Validate("Direct Unit Cost (LCY)", Amt);
                        if JobJNL.Insert(true) then;

                    end;

                end;

                trigger OnPreDataItem()
                begin
                    Amt := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Relacion Empleados - Proyectos".Reset;
                "Relacion Empleados - Proyectos".SetRange("Employee No.", "No.");
                if not "Relacion Empleados - Proyectos".FindFirst then
                    CurrReport.Skip;

                Employee.TestField("Resource No.");
            end;

            trigger OnPreDataItem()
            begin
                ConfNom.Get();
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
                field(GenerarDiario; GenerateJournal)
                {
                ApplicationArea = All;
                    Caption = 'Generate Journal';
                }
                field(NoDocumento; DocNo)
                {
                ApplicationArea = All;
                    Caption = 'Document no.';
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
        ConfNom: Record "Configuracion nominas";
        Fecha: Record Date;
        TrabajosEmpl_por_proyectosCaptionLbl: Label 'Generate Job Journal from employees distribution';
        Total_Para_CaptionLbl: Label 'Total for ';
        Total_Gral_CaptionLbl: Label 'Grand total';
        JobJNL: Record "Job Journal Line";
        TotalQty: Decimal;
        TotalAmt: Decimal;
        GenerateJournal: Boolean;
        Amt: Decimal;
        Text001: Label 'Amount';
        NoLin: Integer;
        DocNo: Code[20];
}

