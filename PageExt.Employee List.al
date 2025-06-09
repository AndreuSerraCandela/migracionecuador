pageextension 50081 pageextension50081 extends "Employee List"
{
    layout
    {
        /*modify(Control1900000001) //No existe el campo
        {
            Visible = false;
        }*/
        modify(Control1)
        {
            Visible = false;
        }
        modify(FullName)
        {
            Visible = false;
        }
        // modify("First Name")
        // {
        //     Visible = false;
        // }
        // modify("Middle Name")
        // {
        //     Visible = false;
        // }
        // modify("Last Name")
        // {
        //     Visible = false;
        // }
        modify(Initials)
        {
            Visible = false;
        }
        modify("Post Code")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify(Extension)
        {
            Visible = false;
        }
        modify("Statistics Group Code")
        {
            Visible = false;
        }
        modify("Resource No.")
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        modify(Comment)
        {
            Visible = false;
        }
        /*modify(Control1900000007) //No existe el campo
        {
            Visible = false;
        }*/
        modify(Control1900383207)
        {
            Visible = false;
        }
        modify(Control1905767507)
        {
            Visible = false;
        }
        addfirst(content)
        {
            repeater(Control1000000100)
            {
                ShowCaption = false;
            }
            field("Full Name"; rec."Full Name")
            {
                ApplicationArea = All;
            }
            //Se agregan con Modify para dejarlos no visibles "First Name", "Middle Name", "Last Name"; "Last Name"
            field("Second Last Name"; rec."Second Last Name")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Document Type"; rec."Document Type")
            {
                ApplicationArea = All;
            }
            field("Document ID"; rec."Document ID")
            {
                ApplicationArea = All;
            }
            //Se agregan con Modify para dejarlos no visibles Iniitals
            field("Job Type Code"; rec."Job Type Code")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field(Address; rec.Address)
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Address 2"; rec."Address 2")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field(City; rec.City)
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            //Se agregan con Modify para dejarlos no visibles "Search Name", "Post Code"
            field(County; rec.County)
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Alt. Address Code"; rec."Alt. Address Code")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Birth Date"; rec."Birth Date")
            {
                ApplicationArea = All;
            }
            /*field(Edad; Edad) No existe el Campo
            {
                Caption = 'Age';
                Editable = false;
                Style = Attention;
                StyleExpr = TRUE;
            }*/
            field("Social Security No."; rec."Social Security No.")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field(Gender; rec.Gender)
            {
                ApplicationArea = All;
            }
            //Se agregan con Modify para dejarlos no visibles "Country/Region Code"
            field("Manager No."; rec."Manager No.")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Emplymt. Contract Code"; rec."Emplymt. Contract Code")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Employment Date"; rec."Employment Date")
            {
                ApplicationArea = All;
            }
            /*field(AntiguedadTxt; AntiguedadTxt) //No Existe el campo
            {
                Caption = 'Seniority';
                Style = Favorable;
                StyleExpr = TRUE;
            }*/
            field(Status; rec.Status)
            {
                ApplicationArea = All;
            }
            field("Inactive Date"; rec."Inactive Date")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Cause of Inactivity Code"; rec."Cause of Inactivity Code")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Termination Date"; rec."Termination Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Grounds for Term. Code"; rec."Grounds for Term. Code")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("Last Date Modified"; rec."Last Date Modified")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Total Absence (Base)"; rec."Total Absence (Base)")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            //Se agregan con Modify para dejarlos no visibles Extension
            field("Company E-Mail"; rec."Company E-Mail")
            {
                ApplicationArea = All;
            }
            field(Title; rec.Title)
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Salespers./Purch. Code"; rec."Salespers./Purch. Code")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field(Categoria; rec.Categoria)
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field(Tiempo; rec.Tiempo)
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Working Center Name"; rec."Working Center Name")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Tipo pago"; rec."Tipo pago")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Permiso Trabajo MT"; rec."Permiso Trabajo MT")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Lugar Nacimiento MT"; rec."Lugar Nacimiento MT")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Numero de Hijos MT"; rec."Numero de Hijos MT")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Nivel Academico MT"; rec."Nivel Academico MT")
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field(Profesion; rec.Profesion)
            {
                ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field("Puesto Segun MT"; rec."Puesto Segun MT")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Working Center"; rec."Working Center")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Employee Level"; rec."Employee Level")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Alta contrato"; rec."Alta contrato")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Fin contrato"; rec."Fin contrato")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Estado Contrato"; rec."Estado Contrato")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Fecha salida empresa"; rec."Fecha salida empresa")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Telefono caso emergencia"; rec."Telefono caso emergencia")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(Nacionalidad; rec.Nacionalidad)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Lugar nacimiento"; rec."Lugar nacimiento")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Estado civil"; rec."Estado civil")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(Cuenta; rec.Cuenta)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Forma de Cobro"; rec."Forma de Cobro")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Mes Nacimiento"; rec."Mes Nacimiento")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Tipo Empleado"; rec."Tipo Empleado")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(Salario; rec.Salario)
            {
                ApplicationArea = All;
                Visible = SueldoVisible;
            }
            field("Codigo Cliente"; rec."Codigo Cliente")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Excluído Cotización TSS"; rec."Excluído Cotización TSS")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Excluído Cotización ISR"; rec."Excluído Cotización ISR")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Dia nacimiento"; rec."Dia nacimiento")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Cod. ARS"; rec."Cod. ARS")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Cod. AFP"; rec."Cod. AFP")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(Departamento; rec.Departamento)
            {
                ApplicationArea = All;
                Visible = true;
            }
            field("Desc. Departamento"; rec."Desc. Departamento")
            {
                ApplicationArea = All;
            }
            field("Sub-Departamento"; rec."Sub-Departamento")
            {
                ApplicationArea = All;
            }
            field("Employee Posting Group"; rec."Employee Posting Group")
            {
                ApplicationArea = All;
            }
            field("Posting Group"; rec."Posting Group")
            {
                ApplicationArea = All;
            }
            field("Agente de Retencion ISR"; rec."Agente de Retencion ISR")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("RNC Agente de Retencion ISR"; rec."RNC Agente de Retencion ISR")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Cod. Supervisor"; rec."Cod. Supervisor")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Nombre Supervisor"; rec."Nombre Supervisor")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(Shift; rec.Shift)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Salario Empresas Externas"; rec."Salario Empresas Externas")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Aporte Voluntario Income Tax"; rec."Aporte Voluntario Income Tax")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Language Code"; rec."Language Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Dias Vacaciones"; rec."Dias Vacaciones")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Contacto en caso de Emergencia"; rec."Contacto en caso de Emergencia")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Telefono contacto Emergencia"; rec."Telefono contacto Emergencia")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Parentesco caso de Emergencia"; rec."Parentesco caso de Emergencia")
            {
                ApplicationArea = All;
            }
            field("Distribuir salario en proyecto"; rec."Distribuir salario en proyecto")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Tipo de Sangre"; rec."Tipo de Sangre")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Nivel de riesgo"; rec."Nivel de riesgo")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("ID Control de asistencia"; rec."ID Control de asistencia")
            {
                ApplicationArea = All;
                Visible = false;
            }
            part(Control1000000004; "Employee Info FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD(FILTER("Date Filter"));
                applicationArea = Basic, Suite;
            }
            part(Control1000000002; "Payroll Information FactBox")
            {
                SubPageLink = "No." = FIELD("No.");
                applicationArea = all;

            }
            systempart(Control1000000104; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1000000103; Notes)
            {
                ApplicationArea = Notes;
            }
        }
        moveafter(Control1000000100; "No.")
        moveafter("Job Type Code"; "Job Title")
        moveafter(County; "Phone No.", "Mobile Phone No.", "E-Mail")
    }
    actions
    {
        modify("Dimensions-&Multiple")
        {
            ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';
        }
        addafter("Co&mments")
        {
            action(docedit)
            {
                ApplicationArea = All;
                Caption = 'Letters';
                Image = DocumentEdit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Documents: Page "Payroll Letters";
                begin
                    Documents.Editable := false;
                    Documents.LookupMode;
                    Documents.ReceiveParams(rec."No.");
                    //Documents.RUNMODAL;
                    Documents.Run;
                end;
            }
        }
    }

    var
        SeguridadUsrRH: Record "Seguridad Usuarios RH";
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        AntiguedadTxt: Text;

        Msg001: Label '%1 %2 does not have department associated, please assign one.';
        //[InDataSet]
        DatosBol: Boolean;
        //[InDataSet]
        CteVisible: Boolean;
        //[InDataSet]
        SueldoVisible: Boolean;
        Txt001: Label '%1 year(s), %2 month, %3 day(s)';
        Edad: Integer;

    trigger OnAfterGetRecord()
    begin
        Validadatos;
        Calculaantiguedad;
    end;

    trigger OnOpenPage()
    begin
        HabilitaCampos;
    end;

    local procedure Validadatos()
    var
        Empl: Record Employee;
    begin
        /*
        IF ("Employee Level" = '') THEN
          BEGIN
            IF (Departamento<> '') THEN
               BEGIN
                 VALIDATE("Job Type Code");
                MODIFY
               END
            ELSE
             MESSAGE('%1',STRSUBSTNO(Msg001,TABLECAPTION, "No." + ' ' + "Full Name"));
          END;
        */
        rec.Validate("Birth Date");

    end;

    local procedure Calculaantiguedad()
    var
        FechaIniDT: DateTime;
        FechaFinDT: DateTime;
        lDate: Date;
    begin
        AntiguedadTxt := '';
        if rec."Employment Date" = 0D then
            exit;

        if rec."Employment Date" > rec."Termination Date" then
            exit;

        lDate := Today;
        if rec."Termination Date" <> 0D then
            lDate := rec."Termination Date";

        /*FuncionesNom.CalculoEntreFechas("Employment Date", lDate, Anos, Meses, Dias);*/ //Nomina
        AntiguedadTxt := StrSubstNo(Txt001, Anos, Meses, Dias);

        if rec."Birth Date" = 0D then
            exit;
        Edad := 0;
        //if "Birth Date" <> 0D then
        /*FuncionesNom.CalculoEntreFechas("Birth Date", lDate, Anos, Meses, Dias);*/ //Nomina
        Edad := Anos;
    end;

    local procedure HabilitaCampos()
    begin
        if SeguridadUsrRH.Get(UserId) then begin
            SueldoVisible := SeguridadUsrRH."Visualiza salario";
        end;
    end;
}