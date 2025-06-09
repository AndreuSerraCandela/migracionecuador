#pragma implicitwith disable
page 76031 "Ficha Empleados"
{
    ApplicationArea = all;
    Caption = 'Normal Employee Information';
    DataCaptionFields = "No.", "Full Name";
    PageType = Card;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(Personales)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    AssistEdit = true;
                    Importance = Promoted;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update;
                    end;
                }
                field("First Name"; rec."First Name")
                {
                    Editable = InfoMdeEditable;
                    Importance = Promoted;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Middle Name"; rec."Middle Name")
                {
                    Editable = true;
                    StyleExpr = TRUE;
                }
                field("Last Name"; rec."Last Name")
                {
                    Editable = InfoMdeEditable;
                    Importance = Promoted;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Second Last Name"; rec."Second Last Name")
                {
                    Editable = InfoMdeEditable;
                }
                field("Document Type"; rec."Document Type")
                {
                    Caption = 'Tipo + Documento';
                    Editable = InfoMdeEditable;
                }
                field("Document ID"; rec."Document ID")
                {
                    Editable = InfoMdeEditable;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field(Salario; rec.Salario)
                {
                    Editable = false;
                    Visible = SueldoVisible;
                }
                field(Address; rec.Address)
                {
                    Caption = 'Dirección';
                    Editable = InfoMdeEditable;
                }
                field("Address 2"; rec."Address 2")
                {
                }
                field(City; rec.City)
                {
                    Editable = InfoMdeEditable;
                }
                field(County; rec.County)
                {
                    Caption = 'State/ZIP Code';
                    Editable = InfoMdeEditable;
                }
                field("Post Code"; rec."Post Code")
                {
                    Editable = InfoMdeEditable;
                }
                field(Nacionalidad; rec.Nacionalidad)
                {
                }
                field("GenPhoneNo."; rec."Phone No.")
                {
                    Editable = InfoMdeEditable;
                }
                field("Contacto en caso de Emergencia"; rec."Contacto en caso de Emergencia")
                {
                }
                field("Telefono contacto Emergencia"; rec."Telefono contacto Emergencia")
                {
                }
                field("Parentesco caso de Emergencia"; rec."Parentesco caso de Emergencia")
                {
                }
                field("Codigo Cliente"; rec."Codigo Cliente")
                {
                }
                field("Salespers./Purch. Code"; rec."Salespers./Purch. Code")
                {
                    Importance = Additional;
                }
                field("Resource No."; rec."Resource No.")
                {
                    Importance = Additional;
                }
                field(Departamento; rec.Departamento)
                {
                    Editable = BloqueaCamposAccP;
                    ShowMandatory = true;
                }
                field("Desc. Departamento"; rec."Desc. Departamento")
                {
                }
                field("Sub-Departamento"; rec."Sub-Departamento")
                {
                }
                field("Calcular Nomina"; rec."Calcular Nomina")
                {
                    Visible = CalcNomVisible;
                }
                field(Categoria; rec.Categoria)
                {
                    Editable = InfoMdeEditable;
                }
                field("Tipo Empleado"; rec."Tipo Empleado")
                {
                    Editable = false;
                }
                field("Tipo pago"; rec."Tipo pago")
                {
                }
                field(Status; rec.Status)
                {
                }
                field("Employee Level"; rec."Employee Level")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field(Pensionado; rec.Pensionado)
                {
                    Importance = Additional;
                    Visible = DatosBol;
                }
                field("Gastos Proyectados Anualmente"; rec."Gastos Proyectados Anualmente")
                {
                    Importance = Additional;
                    Visible = DatosBol;
                }
                field("Incentivos/Puntos"; rec."Incentivos/Puntos")
                {
                    Importance = Additional;
                }
                field("Importe de Anticipo"; rec."Importe de Anticipo")
                {
                    Importance = Additional;
                    Visible = DatosBol;
                }
                field("Dias Vacaciones"; rec."Dias Vacaciones")
                {
                }
                field("Distribuir salario en proyecto"; rec."Distribuir salario en proyecto")
                {
                }
            }
            part(PerfSal; "Lin. conceptos salariales Emp.")
            {
                SubPageLink = "No. empleado" = FIELD("No.");
            }
            group(Control1900776401)
            {
                Caption = 'Contract';
                field("Employment Date"; rec."Employment Date")
                {
                    Caption = 'Fecha de Ingreso';
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field(Company; rec.Company)
                {
                    ShowMandatory = true;
                }
                field("Working Center"; rec."Working Center")
                {
                }
                field("Working Center Name"; rec."Working Center Name")
                {
                }
                field("Job Type Code"; rec."Job Type Code")
                {
                    Editable = BloqueaCamposAccP;
                    ShowMandatory = true;
                }
                field("Job Title"; rec."Job Title")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Cod. Supervisor"; rec."Cod. Supervisor")
                {
                }
                field("Nombre Supervisor"; rec."Nombre Supervisor")
                {
                }
                field("ID Control de asistencia"; rec."ID Control de asistencia")
                {
                }
                field(Shift; rec.Shift)
                {
                }
                field("Posting Group"; rec."Posting Group")
                {
                    Importance = Additional;
                }
                field("Emplymt. Contract Code"; rec."Emplymt. Contract Code")
                {
                    Editable = BloqueaCamposAccP;
                    ShowMandatory = true;
                }
                field("Alta contrato"; rec."Alta contrato")
                {
                }
                field("Fin contrato"; rec."Fin contrato")
                {
                }
                field("Grounds for Term. Code"; rec."Grounds for Term. Code")
                {
                    Importance = Additional;
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                }
                field("Acumula decimo tercero"; rec."Acumula decimo tercero")
                {
                }
                field("Acumula decimo cuarto"; rec."Acumula decimo cuarto")
                {
                }
                field("Fecha despues quinquenios"; rec."Fecha despues quinquenios")
                {
                    Importance = Additional;
                    Visible = DatosBol;
                }
                field("Excluir Calc. Imp. en Comision"; rec."Excluir Calc. Imp. en Comision")
                {
                }
                field("Acumula Fondo Reserva"; rec."Acumula Fondo Reserva")
                {
                }
            }
            group(Complements)
            {
                Caption = 'Complements';
                field(Gender; rec.Gender)
                {
                    Importance = Promoted;
                }
                field("Birth Date"; rec."Birth Date")
                {
                    Importance = Promoted;
                }
                field("Tipo de Sangre"; rec."Tipo de Sangre")
                {
                }
                field("Lugar nacimiento"; rec."Lugar nacimiento")
                {
                }
                field("Mes Nacimiento"; rec."Mes Nacimiento")
                {
                }
                field("Estado civil"; rec."Estado civil")
                {
                    Importance = Promoted;
                }
                field("E-Mail"; rec."E-Mail")
                {
                    ExtendedDatatype = EMail;
                }
                field("Company E-Mail"; rec."Company E-Mail")
                {
                    ExtendedDatatype = EMail;
                }
                field("Fax No."; rec."Fax No.")
                {
                    ExtendedDatatype = PhoneNo;
                    Importance = Additional;
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                    ExtendedDatatype = PhoneNo;
                }
                field("Phone No."; rec."Phone No.")
                {
                    ExtendedDatatype = PhoneNo;
                }
                field(Pager; rec.Pager)
                {
                }
                field("No. Pasaporte"; rec."No. Pasaporte")
                {
                }
                field("Visa americana"; rec."Visa americana")
                {
                }
                field("Salario Empresas Externas"; rec."Salario Empresas Externas")
                {
                    Importance = Additional;
                }
                field("Language Code"; rec."Language Code")
                {
                    Importance = Additional;
                }
            }
            group("Bank/Enroll")
            {
                Caption = 'Bank/Enroll';
                group(BANCO)
                {
                    Caption = 'BANCO';
                    field("Forma de Cobro"; rec."Forma de Cobro")
                    {
                        Importance = Promoted;
                    }
                    field(Cuenta; rec.Cuenta)
                    {
                        Caption = 'Nº  Cuenta';
                        Importance = Promoted;
                    }
                }
                group("Social Security")
                {
                    Caption = 'Social Security';
                    field("Social Security No."; rec."Social Security No.")
                    {
                    }
                    field("Cod. AFP"; rec."Cod. AFP")
                    {
                    }
                    field("Cod. ARS"; rec."Cod. ARS")
                    {
                    }
                    field("Agente de Retencion ISR"; rec."Agente de Retencion ISR")
                    {
                        Importance = Additional;
                    }
                    field("RNC Agente de Retencion ISR"; rec."RNC Agente de Retencion ISR")
                    {
                        Editable = false;
                        Importance = Additional;
                    }
                    field("Excluído Cotización TSS"; rec."Excluído Cotización TSS")
                    {
                        Importance = Additional;
                    }
                    field("Excluído Cotización ISR"; rec."Excluído Cotización ISR")
                    {
                        Importance = Additional;
                    }
                }
            }
            group("MT Data")
            {
                Caption = 'MT Data';
                field("Permiso Trabajo MT"; rec."Permiso Trabajo MT")
                {
                }
                field("Lugar Nacimiento MT"; rec."Lugar Nacimiento MT")
                {
                }
                field("Etnia MT"; rec."Etnia MT")
                {
                }
                field("Idioma MT"; rec."Idioma MT")
                {
                }
                field("Numero de Hijos MT"; rec."Numero de Hijos MT")
                {
                }
                field("Nivel Academico MT"; rec."Nivel Academico MT")
                {
                }
                field(Profesion; rec.Profesion)
                {
                }
                field("Cod. Puesto MT"; rec."Cod. Puesto MT")
                {
                }
                field("Puesto Segun MT"; rec."Puesto Segun MT")
                {
                }
                field("Cod. Nacionalidad MT"; rec."Cod. Nacionalidad MT")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000068; "Employee Picture")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("No.");
            }
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5200),
                              "No." = FIELD("No.");
            }
            part(Control1000000012; "Employee Info FactBox")
            {
                SubPageLink = "No." = FIELD("No.");
            }
            part(Control1000000014; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Codigo Cliente");
                Visible = CteVisible;
            }
            part(Control1000000018; "Payroll Information FactBox")
            {
                SubPageLink = "No." = FIELD("No.");
            }
            systempart(Control1000000087; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                action("Historial MdE")
                {
                    Caption = 'Historial MdE';
                    Image = History;
                    RunObject = Page "Lista Historial MdE";
                    RunPageLink = "No." = FIELD("No.");
                    Visible = NOT InfoMdeEditable;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Employee),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(5200),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("&Picture")
                {
                    ApplicationArea = BasicHR;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = FIELD("No.");
                    ToolTip = 'View or add a picture of the employee or, for example, the company''s logo.';
                }
                action("&Alternative Addresses")
                {
                    Caption = '&Alternative Addresses';
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Relati&ves")
                {
                    Caption = 'Relati&ves';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Mi&sc. Article Information")
                {
                    Caption = 'Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Con&fidential Information")
                {
                    Caption = 'Con&fidential Information';
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Q&ualifications")
                {
                    Caption = 'Q&ualifications';
                    Image = Certificate;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("A&bsences")
                {
                    Caption = 'A&bsences';
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action(beneficios)
                {
                    Caption = 'Benefits plan';
                    Image = ContractPayment;
                    RunObject = Page "Beneficios empleados";
                    RunPageLink = "Cod. Empleado" = FIELD("No.");
                }
                separator(Action1000000053)
                {
                }
                action(CrearRecurso)
                {
                    Caption = 'Create as Resource';
                    Image = NewResource;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin

                    end;
                }
                action(CrearCliente)
                {
                    Caption = 'Create as Customer';
                    Image = NewCustomer;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin

                    end;
                }
                action(CrearVendedor)
                {
                    Caption = 'Create as Salesperson';
                    Image = SalesPerson;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin

                    end;
                }
                separator(Action1000000055)
                {
                }
                action("&Salary History")
                {
                    Caption = '&Salary History';
                    Image = History;
                    RunObject = Page "Histórico de Salarios";
                    RunPageLink = "No. empleado" = FIELD("No.");
                }
                action("&ISR On favor Balance")
                {
                    Caption = '&ISR On favor Balance';
                    Image = Balance;
                    RunObject = Page "Saldos a favor ISR";
                    RunPageLink = "Cód. Empleado" = FIELD("No.");
                }
                action("&Related Companies")
                {
                    Caption = '&Related Companies';
                    Image = Zones;
                    RunObject = Page "Relacion Empresas Empleados";
                    RunPageLink = "Cod. Empleado" = FIELD("No.");
                }
                separator(Action1000000062)
                {
                }
                action("Absences by Categories")
                {
                    Caption = 'Absences by Categories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No."),
                                  "Employee No. Filter" = FIELD("No.");
                }
                action("Misc. Articles &Overview")
                {
                    Caption = 'Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = Page "Misc. Articles Overview";
                }
                action("Confidential Info. Overvie&w")
                {
                    Caption = 'Confidential Info. Overvie&w';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                }
                separator(Action1000000059)
                {
                }
                action("Online Map")
                {
                    Caption = 'Online Map';
                    Image = Map;

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                        /*
                        IF ISCLEAR(AGP_GeoLocator) THEN
                           CREATE(AGP_GeoLocator,FALSE,TRUE);
                        
                        Result := AGP_GeoLocator.AddressToGeoPosition(Address, "Address 2", "Post Code", City, "Country/Region Code", Latitud, Longitud, TRUE, ErrorMSG, 1, '');
                        
                        CLEAR(AGP_GeoLocator);
                        */

                    end;
                }
            }
            group("&Payroll")
            {
                Caption = '&Payroll';
                action(Contract)
                {
                    Caption = 'Contract';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page Contratos;
                    RunPageLink = "No. empleado" = FIELD("No.");
                }
                action("Income Tax Parameters")
                {
                    Caption = 'Income Tax Parameters';
                    Image = TaxSetup;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Param. Income tax - Empleado";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Electronic Payment Information")
                {
                    Caption = 'Electronic Payment Information';
                    Image = AmountByPeriod;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Pagos Electronicos";
                    RunPageLink = "No. empleado" = FIELD("No.");
                }
                separator(Action1100036)
                {
                }
                action("View &Payroll")
                {
                    Caption = 'View &Payroll';
                    Image = History;
                    RunObject = Page "Lista historico nóminas";
                    RunPageLink = "No. empleado" = FIELD("No.");
                }
                separator(Action1100020)
                {
                }
                action("&Copiar Perfil Salarial")
                {
                    Caption = '&Copiar Perfil Salarial';
                    Image = CopyDocument;

                    trigger OnAction()
                    var
                        CopySalaryProfile: Report "Copia Esq. Salarios";
                        Empl: Record Employee;
                    begin
                        CurrPage.SetSelectionFilter(Empl);
                        REPORT.RunModal(REPORT::"Copia Esq. Salarios", true, false, Empl);
                    end;
                }
                separator(Action1000000100)
                {
                }
                action("&Statistics")
                {
                    Caption = '&Statistics';
                    Image = PayrollStatistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Estadisticas Empleados";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter");
                    ShortCutKey = 'F7';
                }
            }
            group("&Job")
            {
                Caption = '&Job';
                Image = Job;
                action("Job Task Relation")
                {
                    Caption = 'Job Task Relation';
                    Image = Task;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Employee - Job Relation";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
            }
        }
        area(processing)
        {
            action("Tax balance")
            {
                Caption = 'Tax balance';
                Image = Balance;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
            action(Payroll)
            {
                Caption = 'Payroll';
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
            action(Balance)
            {
                Caption = 'Balance';
                Image = Balance;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
            action("Customer Card")
            {
                Caption = 'Customer Card';
                Image = CustomerLedger;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    Cte: Record Customer;
                    frmCte: Page "Customer Card";
                begin
                    if Rec."Codigo Cliente" <> '' then begin
                        Cte.Get(Rec."Codigo Cliente");
                        frmCte.SetRecord(Cte);

                        frmCte.RunModal;
                        Clear(frmCte);
                    end;
                end;
            }
            action("Resource Card")
            {
                Caption = 'Resource Card';
                Image = ResourceLedger;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    Res: Record Resource;
                    frmRes: Page "Resource Card";
                begin
                    if Rec."Resource No." <> '' then begin
                        Res.Get(Rec."Resource No.");
                        frmRes.SetRecord(Res);

                        frmRes.RunModal;
                        Clear(frmRes);
                    end;
                end;
            }
            action("Salary History")
            {
                Caption = 'Salary History';
                Image = History;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
            action(Action1000000034)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
            action(Qualifications)
            {
                Caption = 'Qualifications';
                Image = Certificate;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
            action(Absenses)
            {
                Caption = 'Absenses';
                Image = Absence;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CteVisible := Rec."Codigo Cliente" <> '';
    end;

    trigger OnOpenPage()
    begin
        if Rec.GetFilter("Date Filter") = '' then
            Rec.SetRange("Date Filter", 0D, DMY2Date(31, 12, Date2DMY(Today, 3)));

        FechaIni := Rec.GetRangeMin("Date Filter");
        FechaFin := Rec.GetRangeMax("Date Filter");

        //+MdE
        ConfSant.Get;
        ConfCont.Get;
        InfoMdeEditable := not ConfSant."MdE Activo";
        InfoMdEDepEditable := not (ConfSant."MdE Activo" and (ConfSant."Departamento MdE"::Division in [ConfSant."Departamento MdE", ConfSant."Division MdE", ConfSant."Area funcional MdE"]));
        InfoMdEDim1Editable := not (ConfSant."MdE Activo" and (ConfCont."Global Dimension 1 Code" in [ConfSant."Dimension Departamento", ConfSant."Dimension Division", ConfSant."Dimension Area funcional"]));
        InfoMdEDim2Editable := not (ConfSant."MdE Activo" and (ConfCont."Global Dimension 2 Code" in [ConfSant."Dimension Departamento", ConfSant."Dimension Division", ConfSant."Dimension Area funcional"]));
        InfoMdECargoEditable := not (ConfSant."MdE Activo" and (ConfSant."Posicion MdE" = ConfSant."Posicion MdE"::"Puesto laboral"));
        //-MdE

        HabilitarControles;
    end;

    var
        ConfNom: Record "Configuracion nominas";
        RegPerceptores: Record Employee;
        SeguridadUsrRH: Record "Seguridad Usuarios RH";
        fecha: Date;
        Mail: Codeunit Mail;

        FechaIni: Date;
        FechaFin: Date;

        BloqueaCamposAccP: Boolean;

        DatosBol: Boolean;

        CteVisible: Boolean;

        CalcNomVisible: Boolean;

        SueldoVisible: Boolean;
        InfoMdeEditable: Boolean;
        InfoMdEDepEditable: Boolean;
        InfoMdEDim1Editable: Boolean;
        InfoMdEDim2Editable: Boolean;
        InfoMdECargoEditable: Boolean;
        ConfSant: Record "Config. Empresa";
        ConfCont: Record "General Ledger Setup";

        DatosBO: Boolean;

        DatosEC: Boolean;

        DatosGT: Boolean;

        DatosSV: Boolean;

        DatosRD: Boolean;

        DatosHN: Boolean;

        DatosCR: Boolean;

        DatosPR: Boolean;

        DatosPA: Boolean;

        DatosPY: Boolean;

    local procedure HabilitarControles()
    begin
        ConfNom.Get();
        if SeguridadUsrRH.Get(UserId) then begin
            CalcNomVisible := SeguridadUsrRH."Visualiza Calc. Nomina";
            SueldoVisible := SeguridadUsrRH."Visualiza salario";
        end;

        BloqueaCamposAccP := not ConfNom."Usar Acciones de personal";
    end;
}

#pragma implicitwith restore

