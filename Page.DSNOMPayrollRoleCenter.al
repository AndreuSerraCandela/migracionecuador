page 76190 "DSNOM Payroll Role Center"
{
    ApplicationArea = all;
    Caption = 'Home';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part("Headline RC Payroll"; "Headline RC Payroll")
            {
                ApplicationArea = Basic, Suite;
            }
            group(Control1000000011)
            {
                ShowCaption = false;
                part(Control1000000016; "DSNOM HR Activities")
                {
                }
                part(Control1000000013; "DSNOM Employees Activities")
                {
                }
            }
            group(Control1000000004)
            {
                ShowCaption = false;
                part(Control1000000017; "DSNOM Vacaciones Activities")
                {
                }
                part(Control1000000018; "DSNOM Nomina Activities")
                {
                }
            }
            group(Control1000000000)
            {
                ShowCaption = false;
                part(Control1000000020; "DSNOM Cooperativa Activities")
                {
                }
            }
            group(Control1000000063)
            {
                ShowCaption = false;
                // chartpart("DSNOM-1001"; "DSNOM-1001")
                // {
                // }
                systempart(Control1000000021; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            ToolTip = 'Manage human resource processes, view';
            action(Empleados)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employees';
                Image = Item;
                RunObject = Page "Employee List";
                ToolTip = 'View or edit detailed information for the emplolyees.';
            }
            action(EmpActivos)
            {
                Caption = 'Active Employees';
                RunObject = Page "Employee List";
                RunPageView = WHERE(Status = CONST(Active));
            }
            action(EmpTerminados)
            {
                Caption = 'Terminated Employees';
                RunObject = Page "Employee List";
                RunPageView = WHERE(Status = CONST(Terminated));
            }
            action(EmpInActivos)
            {
                Caption = 'Inactive Employees';
                RunObject = Page "Employee List";
                RunPageView = WHERE(Status = CONST(Inactive));
            }
            action(EmpMasculino)
            {
                Caption = 'Male Employees';
                RunObject = Page "Employee List";
                RunPageView = WHERE(Gender = CONST(Male));
            }
            action(EmpFemenino)
            {
                Caption = 'Female Employees';
                RunObject = Page "Employee List";
                RunPageView = WHERE(Gender = CONST(Female));
            }
            action(regAus)
            {
                Caption = 'Absence Registration';
                RunObject = Page "Absence Registration";
            }
            action(CxCEmp)
            {
                Caption = 'Create employee loan';
                RunObject = Page "Lista Cxc Empleados";
            }
            action(Elegibles)
            {
                Caption = 'List of eligible';
                RunObject = Page "Lista de elegibles";
            }
            action(ElegiblesEle)
            {
                Caption = 'Elegibles';
                RunObject = Page "Lista de elegibles";
                RunPageView = WHERE(Status = CONST(Elegible));
            }
            action(ElegiblesCont)
            {
                Caption = 'Enrolled';
                RunObject = Page "Lista de elegibles";
                RunPageView = WHERE(Status = CONST(Contratado));
            }
            action(ElegiblesDes)
            {
                Caption = 'Discarded';
                RunObject = Page "Lista de elegibles";
                RunPageView = WHERE(Status = CONST(Descartado));
            }
            action(ListaAccPers)
            {
                Caption = 'Personnel activities list';
                RunObject = Page "Lista Acciones de personal";
            }
        }
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                group(Payroll)
                {
                    Caption = 'Payroll';
                    Image = SuggestCustomerPayments;
                    action(DiaNom)
                    {
                        Caption = 'Payroll process';
                        Image = CalculateBalanceAccount;
                        RunObject = Page "Diario Nominas";
                    }
                    action(CtrolAsist)
                    {
                        Caption = 'Time and attendance';
                        Image = Timesheet;
                        RunObject = Page "Control de asistencia";
                    }
                    action(Turnos)
                    {
                        Caption = 'Shift administration';
                        Image = ProfileCalendar;
                        RunObject = Page "Employee Capacity";
                    }
                    action("Post Payroll")
                    {
                        Caption = 'Post Payroll';
                        Image = Post;
                        RunObject = Report "Registrar nóminas por lotes";
                    }
                    action("Send Payroll slip")
                    {
                        Caption = 'Send Payroll slip';
                        Image = SendTo;
                        RunObject = Report "Envia Volantes Nominas";
                    }
                    action("Generate Bank's file")
                    {
                        Caption = 'Generate Bank''s file';
                        Image = TransferFunds;
                        RunObject = Report "Genera Nomina Electronica-New";
                    }
                    action("Post Payroll to G/L")
                    {
                        Caption = 'Post Payroll to G/L';
                        Image = PostInventoryToGL;
                        RunObject = Report "Contabilizar Nominas - new";
                    }
                }
                group(Trainings)
                {
                    Caption = 'Trainings';
                    Image = Planning;
                    action(Entrenam)
                    {
                        Caption = 'Training schedule list';
                        Image = CalculatePlan;
                        RunObject = Page "Lista Cab. planific.  entrenam";
                    }
                    action(InscEntrenam)
                    {
                        Caption = 'Registration for training';
                        Image = Planning;
                        RunObject = Page "Lista Inscripcion Entrenamient";
                    }
                }
                group(Cooperative)
                {
                    Caption = 'Cooperative';
                    Image = Bank;
                    action(CoopMemb)
                    {
                        Caption = 'Cooperative member list';
                        Image = SubcontractingWorksheet;
                        RunObject = Page "Lista Miembros Cooperativa";
                    }
                    action(Loans)
                    {
                        Caption = 'Cooperative loans list';
                        Image = Loaners;
                        RunObject = Page "Lista prestamos cooperativa";
                    }
                }
                group(OtrasAcciones)
                {
                    Caption = 'Other actions';
                    Image = HumanResources;
                    action(PantallaPropina)
                    {
                        Caption = 'Distrib. amount tips/incentive';
                        Image = CalculateCost;
                        RunObject = Page Incentivos;
                    }
                    action(CalcPropina)
                    {
                        Image = CalculateRemainingUsage;
                        RunObject = Report "Calculo Incentivos/propinas";
                    }
                    action(SaldosISR)
                    {
                        Caption = 'Employee''s Tax Balance';
                        Image = TaxDetail;
                        RunObject = Page "Saldos a favor ISR";
                    }
                    action(AsignarFormula)
                    {
                        Caption = 'Assign formula to wages';
                        Image = MapSetup;
                        RunObject = Report "Asigna Formula a Conceptos Sal";
                    }
                    action(PromoSal)
                    {
                        Caption = 'General raises';
                        Image = PaymentForecast;
                        RunObject = Page "Diario aumentos generales";
                    }
                    action(Cheques)
                    {
                        Caption = 'Payroll check''s report';
                        Image = Payment;
                        RunObject = Report "Listado de Cheques Nominas";
                    }
                    action(cierraprest)
                    {
                        Caption = 'Finish loans';
                        Image = Loaner;
                        RunObject = Report "Cierra Prestamos";
                    }
                    action(PrestMasivas)
                    {
                        Caption = 'Batch Emp. benefits';
                        Image = CalculateRemainingUsage;
                        RunObject = Page "Prestaciones masivas";
                    }
                    action(PlanifVac)
                    {
                        Caption = 'Vacation''s plan';
                        Image = Workdays;
                        RunObject = Page "Planificacion de vacaciones";
                    }
                }
                action("Envio IRM")
                {
                    RunObject = Report "Enviar IRM";
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                group(Action1000000050)
                {
                    Caption = 'Payroll';
                    Image = HumanResources;
                    action(ListadoNom)
                    {
                        Caption = 'Payroll report';
                        Image = Print;
                        //Promoted = true;
                        //PromotedCategory = "Report";
                        RunObject = Report "Listado de Nominas";
                    }
                    action(ListadoNomxDepto)
                    {
                        Caption = 'Payroll by department';
                        Image = Print;
                        //Promoted = true;
                        //PromotedCategory = "Report";
                        RunObject = Report "Nominas por departamentos";
                    }
                    action(ValidaNom)
                    {
                        Caption = 'Validate payroll by wage';
                        Image = Print;
                        RunObject = Report "Validar nomina por conceptos";
                    }
                    action(exporttoexcel)
                    {
                        Caption = 'Export Payroll To Excel';
                        Image = Excel;
                        RunObject = Report "DSN-Export Payroll To Excel";
                    }
                    action(LlenaAutodet)
                    {
                        Caption = 'Fill SS template';
                        Image = Excel;
                        RunObject = Report "Llena Plantilla TSS Autodet.";
                    }
                    action(LlenaDGT)
                    {
                        Caption = 'Fill DGT3-4 template';
                        Image = Excel;
                        RunObject = Report "Llena Plantilla DGT3-4";
                    }
                    action(Prestaciones)
                    {
                        Caption = 'Employment benefits';
                        Image = Print;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = "Report";
                        RunObject = Report "Calculo Prestaciones laborales";
                    }
                    group(Yearly)
                    {
                        Caption = 'Yearly';
                        Image = History;
                        action(Regalia)
                        {
                            Caption = 'Christmas salary report';
                            Image = "Report";
                            RunObject = Report "Lista acumulado Regalía";
                        }
                        action(ListaBonif)
                        {
                            Caption = 'Bonus report';
                            Image = "Report";
                            RunObject = Report "Listado de Bonificaciones pers";
                        }
                    }
                }
                group("Human Resources")
                {
                    Caption = 'Human Resources';
                    Image = HumanResources;
                    action("Employee - Labels")
                    {
                        Caption = 'Employee - Labels';
                        RunObject = Report "Employee - Labels";
                        ToolTip = 'View a list of employees'' mailing labels.';
                    }
                    action("Employee - List")
                    {
                        Caption = 'Employee - List';
                        RunObject = Report "Employee - List";
                        ToolTip = 'View a list of all employees.';
                    }
                    action("Employee - Misc. Article Info.")
                    {
                        Caption = 'Employee - Misc. Article Info.';
                        RunObject = Report "Employee - Misc. Article Info.";
                        ToolTip = 'View a list of employees'' miscellaneous articles.';
                    }
                    action("Employee - Confidential Info.")
                    {
                        Caption = 'Employee - Confidential Info.';
                        RunObject = Report "Employee - Confidential Info.";
                        ToolTip = 'View a list of employees'' confidential information.';
                    }
                    action("Employee - Staff Absences")
                    {
                        Caption = 'Employee - Staff Absences';
                        RunObject = Report "Employee - Staff Absences";
                        ToolTip = 'View a list of employee absences by date. The list includes the cause of each employee absence.';
                    }
                    action("Employee - Absences by Causes")
                    {
                        Caption = 'Employee - Absences by Causes';
                        RunObject = Report "Employee - Absences by Causes";
                        ToolTip = 'View a list of all employees'' absences categorized by absence code.';
                    }
                    action("Employee - Qualifications")
                    {
                        Caption = 'Employee - Qualifications';
                        RunObject = Report "Employee - Qualifications";
                        ToolTip = 'View a list of employees'' qualifications.';
                    }
                    action("Employee - Addresses")
                    {
                        Caption = 'Employee - Addresses';
                        RunObject = Report "Employee - Addresses";
                        ToolTip = 'View a list of employees'' addresses.';
                    }
                    action("Employee - Relatives")
                    {
                        Caption = 'Employee - Relatives';
                        RunObject = Report "Employee - Relatives";
                        ToolTip = 'View a list of employees'' relatives.';
                    }
                    action("Employee - Birthdays")
                    {
                        Caption = 'Employee - Birthdays';
                        RunObject = Report "Employee - Birthdays";
                        ToolTip = 'View a list of employees'' birthdays.';
                    }
                    action("Employee - Phone Nos.")
                    {
                        Caption = 'Employee - Phone Nos.';
                        RunObject = Report "Employee - Phone Nos.";
                        ToolTip = 'View a list of employees'' phone numbers.';
                    }
                    action("Employee - Unions")
                    {
                        Caption = 'Employee - Unions';
                        RunObject = Report "Employee - Unions";
                        ToolTip = 'View a list of employees'' union memberships.';
                    }
                    action("Employee - Contracts")
                    {
                        Caption = 'Employee - Contracts';
                        RunObject = Report "Employee - Contracts";
                        ToolTip = 'View all employee contracts.';
                    }
                    action("Employee - Alt. Addresses")
                    {
                        Caption = 'Employee - Alt. Addresses';
                        RunObject = Report "Employee - Alt. Addresses";
                        ToolTip = 'View a list of employees'' alternate addresses.';
                    }
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action(ConfRH)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Human Resources Setup';
                    RunObject = Page "Human Resources Setup";
                }
                action(ConfNom)
                {
                    Caption = 'Payroll Setup';
                    RunObject = Page "Configuracion nominas";
                }
                action(EmpCot)
                {
                    Caption = 'Company Setup';
                    RunObject = Page "Empresas de cotización";
                }
            }
        }
        area(sections)
        {
            group("Administration HR")
            {
                Caption = 'Administration HR';
                Image = HumanResources;
                action("Human Resources Unit of Measure")
                {
                    Caption = 'Human Resources Unit of Measure';
                    RunObject = Page "Human Res. Units of Measure";
                    ToolTip = 'View or edit the Units in which you measure human resources'' work, such as Hours.';
                }
                action("Vend. Causes of Absence")
                {
                    Caption = 'Vend. Causes of Absence';
                    RunObject = Page "Causes of Absence";
                    ToolTip = 'View or edit causes of absence for your vendor resources. These codes can be used to indicate various reasons for employee absences: sickness, vacation, personal days, personal emergencies, and so on.';
                }
                action("Causes of Inactivity")
                {
                    Caption = 'Causes of Inactivity';
                    RunObject = Page "Causes of Inactivity";
                    ToolTip = 'Register causes of inactivity codes for your employees. These codes can be used for various reasons causing employee inactiveness: maternity leave, long-term illness, sabbatical, and so on.';
                }
                action("Grounds for Termination")
                {
                    Caption = 'Grounds for Termination';
                    RunObject = Page "Grounds for Termination";
                    ToolTip = 'View or edit grounds for termination codes for your employees. These codes can be used for various reasons for employee termination: dismissal, retirement, resignation, and so on.';
                }
                action(Unions)
                {
                    Caption = 'Unions';
                    RunObject = Page Unions;
                    ToolTip = 'View a list of labor and trade unions. For each union, the report shows the employees who are members of the union.';
                }
                action("Employment Contracts")
                {
                    Caption = 'Employment Contracts';
                    RunObject = Page "Employment Contracts";
                    ToolTip = 'View or edit employment contracts.';
                }
                action(Relatives)
                {
                    Caption = 'Relatives';
                    Image = Relatives;
                    RunObject = Page Relatives;
                    ToolTip = 'View a list of employees'' relatives for selected employees. For each employee, the report shows basic information about the employee''s relatives such as name and date of birth.';
                }
                action("Misc. Articles")
                {
                    Caption = 'Misc. Articles';
                    RunObject = Page "Misc. Articles";
                    ToolTip = 'View the benefits that your employees receive and other articles that are in your employees'' possession, such as keys, computers, company cars, and memberships in company clubs.';
                }
                action(Confidential)
                {
                    Caption = 'Confidential';
                    RunObject = Page Confidential;
                    ToolTip = 'Register confidential information related to your employees such as salaries, stock option plans, pensions, and so on.';
                }
                action(Qualifications)
                {
                    Caption = 'Qualifications';
                    Image = Certificate;
                    RunObject = Page Qualifications;
                    ToolTip = 'View or register qualification codes for your employees. These codes can be used for various employee qualifications: job titles, employee computer skills, education, courses, and so on.';
                }
                action("Employee Statistics Groups")
                {
                    Caption = 'Employee Statistics Groups';
                    RunObject = Page "Employee Statistics Groups";
                    ToolTip = 'View or edit the grouping of employees for statistical purposes.';
                }
                action("Dias Feriados")
                {
                    Caption = 'Hollydays';
                    RunObject = Page "Dias Fiestas";
                }
                action(Departamento)
                {
                    Caption = 'Department';
                    RunObject = Page Departamentos;
                }
                action(Puestos)
                {
                    Caption = 'Job Positions';
                    RunObject = Page "Puestos laborares";
                }
                action(TiposSangre)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Blood types';
                    RunObject = Page "Tipos de sangre";
                }
                action(AccPers)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Reason personnel action';
                    RunObject = Page "Config. acciones personal";
                }
                action(Shift)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Shifts';
                    Image = ProfileCalendar;
                    RunObject = Page Shift;
                }
                action(Beneficios)
                {
                    Caption = 'Benefits list';
                    RunObject = Page "Beneficios puestos laborales";
                }
                action(Vacaciones)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Vacation parameters';
                    RunObject = Page "Parametros vacaciones";
                }
                action(Cartas)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Letter designs';
                    RunObject = Page "Payroll Letters";
                }
                action(Seguridad)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'PAR User authorization';
                    RunObject = Page "Seguridad Usuarios RH";
                }
                action(Dispacidades)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Disabilities';
                    RunObject = Page "Horas Extras(Disponible)";
                }
            }
            group("<Action100000016>")
            {
                Caption = 'Administration Training';
                Image = HumanResources;
                action("Tipos de entrenamientos")
                {
                    Caption = 'Training types';
                    Image = Setup;
                    RunObject = Page "Tipos de entrenamientos";
                }
                action("Area curricular")
                {
                    Caption = 'Knowledge area';
                    Image = Setup;
                    RunObject = Page "Area curricular";
                }
                action("Salones de entrenamientos")
                {
                    Caption = 'Classroom';
                    Image = Setup;
                    RunObject = Page Salones;
                }
            }
            group("<Action100000008>")
            {
                Caption = 'Payroll Administration';
                Image = HumanResources;
                action("Tipos de nominas")
                {
                    Caption = 'Payroll types';
                    Image = Setup;
                    RunObject = Page "Tipos de nominas";
                }
                action(Deptos)
                {
                    Caption = 'Department';
                    Image = Setup;
                    RunObject = Page Departamentos;
                }
                action("Puestos laborares")
                {
                    Caption = 'Job Positions';
                    Image = Setup;
                    RunObject = Page "Puestos laborares";
                }
                action(GposCont)
                {
                    Caption = 'Employee Posting Group';
                    RunObject = Page "Gpo. Contable Empleados";
                }
                action("Conceptos salariales")
                {
                    Caption = 'Wage''s Concepts';
                    Image = Setup;
                    RunObject = Page "Conceptos salariales";
                }
                action(ConfListados)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Reports Configuration';
                    RunObject = Page "Configuracion Listados";
                }
                action(DimContab)
                {
                    Caption = 'Posting Dimensions';
                    RunObject = Page "Dimensiones Contabilizacion";
                }
                action(Iinicializa)
                {
                    Caption = 'Init wage concepts';
                    RunObject = Page "Param. Inic. Concepto Sal.";
                }
                action(ControlAsistencia)
                {
                    Caption = 'Time and attendance clock setup';
                    RunObject = Page "Config. reloj control asist.";
                }
                action("Tabla retenc. ISR")
                {
                    Caption = 'ISR Tax';
                    Image = Setup;
                    RunObject = Page "Tabla retenc. ISR";
                }
                action("Enviar IRM")
                {
                    Image = "Report";
                    RunObject = Report "Enviar IRM";
                }
                action("Tipos de Cotización")
                {
                    Caption = 'Tipos de Cotización';
                    Image = Setup;
                    RunObject = Page "Tipos de Cotizacion";
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action(PostedPAyroll)
                {
                    Caption = 'Posted Payroll';
                    RunObject = Page "Lista historico nóminas";
                    RunPageMode = View;
                }
                action(HNRegular)
                {
                    Caption = 'Regular';
                    RunObject = Page "Lista historico nóminas";
                    RunPageMode = View;
                    RunPageView = WHERE("Tipo Nomina" = CONST(Normal));
                }
                action(HNPrestaciones)
                {
                    Caption = 'Labour benefits';
                    RunObject = Page "Lista historico nóminas";
                    RunPageMode = View;
                    RunPageView = WHERE("Tipo Nomina" = CONST(Renta));
                }
                action(HNComisiones)
                {
                    Caption = 'Commissions';
                    RunObject = Page "Lista historico nóminas";
                    RunPageMode = View;
                    //RunPageView = WHERE ("Tipo Nomina" = CONST (5));
                }
                action(HNVacaciones)
                {
                    Caption = 'Vacations';
                    RunObject = Page "Lista historico nóminas";
                    RunPageMode = View;
                    //RunPageView = WHERE ("Tipo Nomina" = CONST ("6"));
                }
                action(HNRegalia)
                {
                    Caption = 'Chritsmas';
                    RunObject = Page "Lista historico nóminas";
                    RunPageMode = View;
                    RunPageView = WHERE("Tipo Nomina" = CONST("Regalía"));
                }
                action(HNBonificacion)
                {
                    Caption = 'Bonus';
                    RunObject = Page "Lista historico nóminas";
                    RunPageMode = View;
                    RunPageView = WHERE("Tipo Nomina" = CONST("Bonificación"));
                }
                action(HNExtra)
                {
                    Caption = 'Extra';
                    RunObject = Page "Lista historico nóminas";
                    RunPageMode = View;
                    RunPageView = WHERE("Tipo Nomina" = CONST(Propina));
                }
                action(PostedSS)
                {
                    Caption = 'Posted Employer''s Taxes ';
                    RunObject = Page "Lista Cab Impuestos";
                }
                action(PostedLoans)
                {
                    Caption = 'History of Loans';
                    RunObject = Page "Lista Mov. CxC Empleados";
                }
                action(PostedPA)
                {
                    Caption = 'Posted personnel actions';
                    RunObject = Page "Hist. acciones de personal";
                }
                action(PostedCooperative)
                {
                    Caption = 'Posted Cooperative Loans List';
                    RunObject = Page "Lista Hist. Prest. Cooperativa";
                }
            }
        }
    }
}

