tableextension 50096 tableextension50096 extends Employee
{
    fields
    {
        field(50000; "Job Title 2"; Text[60])
        {
            Caption = 'Job Title';
            DataClassification = ToBeClassified;
        }
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify(Pager)
        {
            Caption = 'Fleet no.';
        }
        modify("First Name")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                Validate("Full Name");
            end;
        }
        modify("Middle Name")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                Validate("Full Name");
            end;
        }
        modify("Last Name")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                Validate("Full Name");
            end;
        }
        modify("Birth Date")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                if (("Birth Date" <> 0D) and (("Mes Nacimiento" = 0) or ("Dia nacimiento" = 0))) or
                           (("Birth Date" <> xRec."Birth Date") and ("Birth Date" <> 0D)) then begin
                    "Mes Nacimiento" := Date2DMY("Birth Date", 2);
                    "Dia nacimiento" := Date2DMY("Birth Date", 1);
                    if not Modify then;
                end;
            end;
        }
        modify("Emplymt. Contract Code")
        {
            trigger OnBeforeValidate()
            var
                Contratos: Record Contratos;
            begin
                TestField(Company);
                Empresa.Get(Company);
                Contratos.Validate("No. empleado", "No.");
                Contratos."No. Orden" := 100;
                Contratos.Validate("Empresa cotización", Company);
                Contratos.Validate("Cód. contrato", "Emplymt. Contract Code");
                Contratos."Frecuencia de pago" := Empresa."Tipo Pago Nomina";
                if not Contratos.Insert() then
                    Contratos.Modify();
            end;
        }
        modify(Status)
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                //Estas dos líneas estan en el standar pero no en el código de Santillana
                //son de la última versión de BC o se eliminaron?
                /*if Employe.Get(Rec."No.") then
                    Rec.Modify();*/

                //DSPayroll 1.03
                if Status = Status::Inactive then
                    "Inactive Date" := Today
                else
                    "Inactive Date" := 0D;
                Modify;
            end;
        }
        field(50001; Tiempo; Decimal)
        {
            Caption = 'Time';
            DataClassification = ToBeClassified;
            Description = 'Grupo Santillana';
        }
        field(50002; "Numero de persona"; Text[32])
        {
            Caption = 'Número de persona';
            DataClassification = ToBeClassified;
            Description = 'Santillana,MDE';
        }
        field(50003; "Working Center Name"; Text[60])
        {
            CalcFormula = Lookup("Centros de Trabajo".Nombre WHERE("Centro de trabajo" = FIELD("Working Center")));
            Caption = 'Working Center Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Tipo pago"; Option)
        {
            Caption = 'Payment type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Fix salary,By hour';
            OptionMembers = "Sueldo fijo","Por hora";
        }
        field(50050; "Calcular dieta por dia"; Boolean)
        {
            Caption = 'Calculate meals by day';
            DataClassification = ToBeClassified;
            Description = 'Constructoras';
        }
        field(50051; "Incluir pago transporte"; Boolean)
        {
            Caption = 'Incluide transportation payment';
            DataClassification = ToBeClassified;
            Description = 'Constructoras';
        }
        field(51000; "Permiso Trabajo MT"; Text[30])
        {
            Caption = 'Work permit to Foreign according to MT';
            DataClassification = ToBeClassified;
        }
        field(51001; "Lugar Nacimiento MT"; Text[30])
        {
            Caption = 'Place of Birth according to MT';
            DataClassification = ToBeClassified;
        }
        field(51002; "Etnia MT"; Text[30])
        {
            Caption = 'Ethnicity According to MT';
            DataClassification = ToBeClassified;
        }
        field(51003; "Idioma MT"; Text[30])
        {
            Caption = 'Language according to MT';
            DataClassification = ToBeClassified;
        }
        field(51004; "Numero de Hijos MT"; Integer)
        {
            Caption = 'Number of children';
            DataClassification = ToBeClassified;
        }
        field(51005; "Nivel Academico MT"; Text[30])
        {
            Caption = 'Academic Level';
            DataClassification = ToBeClassified;
        }
        field(51006; Profesion; Text[80])
        {
            Caption = 'Profession';
            DataClassification = ToBeClassified;
        }
        field(51007; "Puesto Segun MT"; Text[50])
        {
            Caption = 'Job position according to MT';
            DataClassification = ToBeClassified;
        }
        field(51008; "Cod. Puesto MT"; Code[10])
        {
            Caption = 'Job code MT';
            DataClassification = ToBeClassified;
        }
        field(51009; "Cod. Nacionalidad MT"; Code[10])
        {
            Caption = 'Nationality code MT';
            DataClassification = ToBeClassified;
        }
        field(54000; "Importe Facturas"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Nomina BO';
        }
        field(54001; "Fecha despues quinquenios"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Nomina BO';
        }
        field(55000; "Gastos Proyectados Anualmente"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Nomina Ecuador';
        }
        field(55001; "Acumula Fondo Reserva"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Nomina Ecuador';
        }
        field(55002; "Importe de Anticipo"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Nomina Ecuador';
        }
        field(55003; "Acumula decimo tercero"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Nomina Ecuador';
        }
        field(55004; "Acumula decimo cuarto"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Nomina Ecuador';
        }
        field(76200; Company; Code[10])
        {
            Caption = 'Company';
            DataClassification = ToBeClassified;
            TableRelation = "Empresas Cotizacion";
        }
        field(76060; "Second Last Name"; Text[30])
        {
            Caption = 'Second Last Name';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(76000; "Working Center"; Code[10])
        {
            Caption = 'Working Center';
            DataClassification = ToBeClassified;
            TableRelation = "Centros de Trabajo"."Centro de trabajo" WHERE("Empresa cotización" = FIELD(Company));
        }
        field(76049; "Full Name"; Text[50])
        {
            Caption = 'Full Name';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name" + ' ' + "Second Last Name";
            end;
        }
        field(76031; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'SS,Passport,Green card,Work Permission';
            OptionMembers = "Cédula",Pasaporte,"Tarj.residen.comunitario","Perm.Trabajo",,"N.I.Extranjero","N.I.F.";

            trigger OnValidate()
            begin
                ConfNominas.Get();
                if ConfNominas."Act. Excluido TSS automatico" then begin
                    if "Document Type" <> 0 then
                        "Excluído Cotización TSS" := true
                    else
                        "Excluído Cotización TSS" := false;
                end;
            end;
        }
        field(76053; "Document ID"; Text[15])
        {
            Caption = 'Document ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Employee.Reset;
                Employee.SetFilter("No.", '<>%1', "No.");
                Employee.SetRange("Document ID", "Document ID");
                if Employee.FindFirst then
                    Error(StrSubstNo(Err003, FieldCaption("Document Type"), Employee."No.", Employee."Full Name"));

                ConfNominas.Get();

                if ("Document Type" = "Document Type"::"Cédula") and (ConfNominas."Nomina de Pais" = 'DO') then;
                /*                 if not FuncNominas.ValidarCedula(DelChr("Document ID", '=', '-')) then
                                    Error(StrSubstNo(Err004, "Document Type"));
             */
            end;
        }
        field(76075; "Employee Level"; Code[10])
        {
            Caption = 'Employee Level';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Nivel Cargo"."Cod. Nivel";
        }
        field(76001; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Grupos Contables Empleados";
        }
        field(76044; "Job Type Code"; Code[15])
        {
            Caption = 'Cod. Cargo';
            DataClassification = ToBeClassified;
            TableRelation = "Puestos laborales".Codigo WHERE("Cod. departamento" = FIELD(Departamento));

            trigger OnValidate()
            var
                Contract: Record Contratos;
            begin
                TestField(Departamento);
                if Cargo.Get(Departamento, "Job Type Code") then begin
                    "Job Title" := Cargo.Descripcion;
                    "Employee Level" := Cargo."Cod. nivel";
                    //     "Cod. Supervisor" := Cargo."Cod. Supervisor";
                end;

                if Cargo."Global Dimension 1 Code" <> '' then
                    Validate("Global Dimension 1 Code", Cargo."Global Dimension 1 Code");
                if Cargo."Global Dimension 2 Code" <> '' then
                    Validate("Global Dimension 2 Code", Cargo."Global Dimension 2 Code");


                //Llenamos las lineas del Perfil de salarios.
                LinPerfil.Reset;
                LinPerfil.SetRange("No. empleado", "No.");
                if not LinPerfil.Find('-') then begin
                    LinPerfil.Reset;
                    LinPerfil."No. empleado" := "No.";
                    TestField("Job Type Code");
                    PerfilPuesto.SetRange("Puesto de Trabajo", "Job Type Code");
                    if PerfilPuesto.FindSet then
                        repeat
                            Conceptossalariales.Get(PerfilPuesto."Concepto salarial");
                            LinPerfil.Validate("Empresa cotizacion", Company);
                            LinPerfil.Validate("No. empleado", "No.");
                            LinPerfil.Validate("Concepto salarial", PerfilPuesto."Concepto salarial");
                            LinPerfil."1ra Quincena" := PerfilPuesto."1ra Quincena";
                            LinPerfil."2da Quincena" := PerfilPuesto."2da Quincena";
                            LinPerfil."No. Linea" += 1;
                            LinPerfil.Insert;
                        until PerfilPuesto.Next = 0;
                end;

                Contract.SetRange("No. empleado", "No.");
                //Contract.SETRANGE(Disponible,Disponible);
                Contract.SetRange(Activo, true);
                if Contract.FindFirst then begin
                    Contract."Empresa cotización" := Company;
                    Contract.Cargo := "Job Type Code";
                    Contract."Centro trabajo" := "Working Center";
                    Contract.Modify;
                end;
            end;
        }
        field(76069; "Alta contrato"; Date)
        {
            Caption = 'Enroll date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(76013; "Fin contrato"; Date)
        {
            Caption = 'Ending date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(76062; "Estado Contrato"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Sin contrato,Indefinido,Finalizado,No finalizado';
            Editable = false;
            OptionMembers = "Sin contrato",Indefinido,Finalizado,"No finalizado";
        }
        field(76068; Pensionado; Boolean)
        {
            Caption = 'Retired';
            DataClassification = ToBeClassified;
        }
        field(76065; "Calcular Nomina"; Boolean)
        {
            Caption = 'Calculate Payroll';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(76067; "Fecha salida empresa"; Date)
        {
            Caption = 'Departure date';
            DataClassification = ToBeClassified;
        }
        field(76061; "Telefono caso emergencia"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(76063; Nacionalidad; Code[10])
        {
            Caption = 'Nationality';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(76070; "Incentivos/Puntos"; Decimal)
        {
            Caption = 'Incentives/Points';
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if ("Incentivos/Puntos" <> xRec."Incentivos/Puntos") and (xRec."Incentivos/Puntos" <> 0) then begin
                    HistPtosProp."No. Empleado" := "No.";
                    HistPtosProp."Fecha Aplicacion" := Today;
                    HistPtosProp.Punto := xRec."Incentivos/Puntos";
                    if not HistPtosProp.Insert then
                        HistPtosProp.Modify;
                end;
            end;
        }
        field(76071; "Lugar nacimiento"; Text[30])
        {
            Caption = 'Place of birth';
            DataClassification = ToBeClassified;
        }
        field(76072; "Estado civil"; Option)
        {
            Caption = 'Marital status';
            DataClassification = ToBeClassified;
            Description = 'Soltero/a,Casado/a,Viudo/a,Separado/a,Divorciado/a';
            OptionCaption = 'Single, Married, Widowed, Separated, Divorced, Free Union';
            OptionMembers = "Soltero/a","Casado/a","Viudo/a","Separado/a","Divorciado/a","Unión libre";
        }
        field(76054; "Disponible 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'DISPONIBLE';
            TableRelation = Bancos;
        }
        field(76050; "Disponible 2"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'DISPONIBLE';
            OptionCaption = ' ,Ahorro,Corriente';
            OptionMembers = " ",Ahorro,Corriente;
        }
        field(76059; Cuenta; Code[22])
        {
            CalcFormula = Lookup("Distrib. Ingreso Pagos Elect."."Numero Cuenta" WHERE("No. empleado" = FIELD("No.")));
            Caption = 'Bank accout no.';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                if Cuenta <> '' then begin
                    Employee.Reset;
                    Employee.SetCurrentKey(Cuenta);
                    Employee.SetRange(Cuenta, Cuenta);
                    if Employee.Find('-') and (Employee."No." <> "No.") then
                        Error(Err001, Employee."No.");
                end;
            end;
        }
        field(76010; "Forma de Cobro"; Option)
        {
            DataClassification = ToBeClassified;
            Description = ' ,Efectivo,Cheque,Transferencia Banc.';
            OptionMembers = " ",Efectivo,Cheque,"Transferencia Banc.";
        }
        field(76032; "Total ingresos"; Decimal)
        {
            CalcFormula = Sum("Historico Lin. nomina".Total WHERE("No. empleado" = FIELD("No."),
                                                                   "Período" = FIELD("Date Filter"),
                                                                   "Tipo concepto" = CONST(Ingresos)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(76040; "Total deducciones"; Decimal)
        {
            CalcFormula = Sum("Historico Lin. nomina".Total WHERE("No. empleado" = FIELD("No."),
                                                                   "Período" = FIELD("Date Filter"),
                                                                   "Tipo concepto" = CONST(Deducciones)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(76038; "Mes Nacimiento"; Integer)
        {
            Caption = 'Birthday month';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(76251; "Total ISR"; Decimal)
        {
            CalcFormula = Sum("Historico Lin. nomina".Total WHERE("No. empleado" = FIELD("No."),
                                                                   "Período" = FIELD("Date Filter"),
                                                                   "Concepto salarial" = CONST('ISR')));
            FieldClass = FlowField;
        }
        field(76254; "Tipo Empleado"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Fijo,Temporal,Otro';
            OptionCaption = 'Employ,Temporary,Other';
            OptionMembers = Fijo,Temporal,Otro;
        }
        field(76271; Salario; Decimal)
        {
            CalcFormula = Lookup("Perfil Salarial".Importe WHERE("No. empleado" = FIELD("No."),
                                                                  "Salario Base" = CONST(true)));
            Caption = 'Salary';
            FieldClass = FlowField;
        }
        field(76037; "Acumulado Salario"; Decimal)
        {
            CalcFormula = Sum("Historico Lin. nomina".Total WHERE("No. empleado" = FIELD("No."),
                                                                   "Período" = FIELD("Date Filter"),
                                                                   "Salario Base" = CONST(true)));
            FieldClass = FlowField;
        }
        field(76039; "Codigo Cliente"; Code[20])
        {
            Caption = 'Customer no.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(76036; "Excluído Cotización TSS"; Boolean)
        {
            Caption = 'Excluído Cotización TSS';
            DataClassification = ToBeClassified;
            InitValue = false;
        }
        field(76164; "Excluído Cotización ISR"; Boolean)
        {
            Caption = 'Excluído Cotización ISR';
            DataClassification = ToBeClassified;
        }
        field(76255; "Dia nacimiento"; Integer)
        {
            Caption = 'Birthday';
            DataClassification = ToBeClassified;
        }
        field(76035; "Cod. ARS"; Code[10])
        {
            Caption = 'ARS Code';
            DataClassification = ToBeClassified;
            TableRelation = ARS;
        }
        field(76172; "Cod. AFP"; Code[10])
        {
            Caption = 'AFP Code';
            DataClassification = ToBeClassified;
            TableRelation = AFP;
        }
        field(76253; Departamento; Code[20])
        {
            CaptionClass = '4,1,1';
            Caption = 'Department';
            DataClassification = ToBeClassified;
            TableRelation = Departamentos WHERE(Inactivo = CONST(false));
        }
        field(76301; "Sub-Departamento"; Code[20])
        {
            CaptionClass = '4,2,1';
            Caption = 'Sub-Department';
            DataClassification = ToBeClassified;
            TableRelation = "Sub-Departamentos".Codigo WHERE("Cod. Departamento" = FIELD(Departamento));
        }
        field(76279; "Agente de Retencion ISR"; Text[30])
        {
            Caption = 'TAX Retention Agent';
            DataClassification = ToBeClassified;
            TableRelation = Company;

            trigger OnValidate()
            var
                Empresa: Record "Company Information";
            begin
                Empresa.Reset;
                Empresa.ChangeCompany("Agente de Retencion ISR");
                if "Agente de Retencion ISR" <> '' then begin
                    if Empresa.Get() then
                        "RNC Agente de Retencion ISR" := Empresa."VAT Registration No."
                end
                else
                    "RNC Agente de Retencion ISR" := '';
            end;
        }
        field(76055; "RNC Agente de Retencion ISR"; Text[30])
        {
            Caption = 'VRN TAX Retention Agent';
            DataClassification = ToBeClassified;
        }
        field(76002; "Cod. Supervisor"; Code[20])
        {
            Caption = 'Supervisor Code';
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(76081; "Nombre Supervisor"; Text[150])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Cod. Supervisor")));
            Caption = 'Supervisor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76150; Shift; Code[10])
        {
            Caption = 'Shift';
            DataClassification = ToBeClassified;
            TableRelation = Shift;
        }
        field(76173; "Salario Empresas Externas"; Decimal)
        {
            Caption = 'External company salary';
            DataClassification = ToBeClassified;
        }
        field(76028; "Aporte Voluntario Income Tax"; Decimal)
        {
            Caption = 'Incometax Voluntary extra payment';
            DataClassification = ToBeClassified;
        }
        field(76043; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = ToBeClassified;
            TableRelation = Language;
        }
        field(76412; "Desc. Departamento"; Text[70])
        {
            CalcFormula = Lookup(Departamentos.Descripcion WHERE(Codigo = FIELD(Departamento)));
            Caption = 'Descripción Departamento';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76381; "Dias Vacaciones"; Decimal)
        {
            CalcFormula = Sum("Historico Vacaciones".Dias WHERE("No. empleado" = FIELD("No.")));
            Caption = 'Days of vacations';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76338; "Contacto en caso de Emergencia"; Text[60])
        {
            Caption = 'Emergency Contact name';
            DataClassification = ToBeClassified;
        }
        field(76005; "Telefono contacto Emergencia"; Text[30])
        {
            Caption = 'Emergency Contact''s Phone no.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(76154; "Parentesco caso de Emergencia"; Text[30])
        {
            Caption = 'Relationship Emergency';
            DataClassification = ToBeClassified;
        }
        field(76112; "Distribuir salario en proyecto"; Boolean)
        {
            Caption = 'Distribute salary in jobs';
            DataClassification = ToBeClassified;
        }
        field(76257; "Tipo de Sangre"; Code[3])
        {
            Caption = 'Blood type';
            DataClassification = ToBeClassified;
            TableRelation = "Datos adicionales RRHH".Code WHERE("Tipo registro" = CONST("Tipo de Sangre"));
        }
        field(76414; "Nivel de riesgo"; Option)
        {
            Caption = 'Risk level';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Critic,Non critic';
            OptionMembers = " ","Crítico","No crítico";
        }
        field(76409; "ID Control de asistencia"; Code[6])
        {
            Caption = 'Punch clock ID';
            DataClassification = ToBeClassified;
        }
        field(76149; "Cod. empleado a quien sustituy"; Code[20])
        {
            Caption = 'Employee no. to whom replace';
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(76375; "Nombre a quien sustituye"; Text[150])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Cod. empleado a quien sustituy")));
            Caption = 'Employee name to whom replace';
            FieldClass = FlowField;
        }
        field(76418; "No. Pasaporte"; Code[15])
        {
            Caption = 'Passport No.';
            DataClassification = ToBeClassified;
        }
        field(76114; "Visa americana"; Boolean)
        {
            Caption = 'US Visa';
            DataClassification = ToBeClassified;
        }
        field(76064; "ID TSS"; Code[10])
        {
            Caption = 'ID TSS';
            DataClassification = ToBeClassified;
        }
        field(76385; "Fecha reactivacion"; Date)
        {
            Caption = 'Reactivation date';
            DataClassification = ToBeClassified;
        }
        field(76124; Hobby; Code[20])
        {
            Caption = 'Hobby';
            DataClassification = ToBeClassified;
        }
        field(76174; "Excluir Calc. Imp. en Comision"; Boolean)
        {
            Caption = 'Exclude Taxes cacl. from Comission';
            DataClassification = ToBeClassified;
        }
        field(76066; Categoria; Code[20])
        {
            Caption = 'Category';
            DataClassification = ToBeClassified;
            TableRelation = "Datos adicionales RRHH".Code WHERE("Tipo registro" = CONST("Categoría"));
        }
    }
    keys
    {
        key(Key1; "Mes Nacimiento", "Dia nacimiento")
        {
        }
    }


    //Se agrego este campo a los field groups, pero no se ocultan los campos "First Name", "Last Name", Initials
    //Checar si se ocultan modificando la pagina 
    fieldgroups
    {
        addlast(DropDown; "Full Name")
        {
        }
        addlast(Brick; "Full Name")
        {
        }
    }



    trigger OnBeforeDelete()
    var
        myInt: Integer;
    begin
        //DSNom1.02
        HistNom.SetRange("No. empleado", "No.");
        if HistNom.FindFirst then
            Error(Err002);

        //DSNom1.02
        Contrato.Reset;
        Contrato.SetRange("No. empleado", "No.");
        if Contrato.FindSet(true) then
            Contrato.DeleteAll;

        PerfilSal.Reset;
        PerfilSal.SetRange("No. empleado", "No.");
        if PerfilSal.FindSet(true) then
            PerfilSal.DeleteAll;

        DistribPE.Reset;
        DistribPE.SetRange("No. empleado", "No.");
        if DistribPE.FindSet(true) then
            DistribPE.DeleteAll;
    end;

    trigger OnAfterModify()
    var
        myInt: Integer;
    begin
        //Para el control de asistencia
        ConfNominas.Get();
        if ConfNominas."Integracion ponche activa" then begin
            ConfNominas.TestField("CU Procesa datos ponchador");
            CODEUNIT.Run(ConfNominas."CU Procesa datos ponchador", Rec);
        end;
    end;

    procedure SetFromMde(New_FromMdE: Boolean)
    begin
        FromMdE := New_FromMdE;
    end;






    var
        Contrato: Record Contratos;
        PerfilSal: Record "Perfil Salarial";
        HistNom: Record "Historico Cab. nomina";
        DistribPE: Record "Distrib. Ingreso Pagos Elect.";

    var
        "******* DSPayroll ******": Integer;
        ConfNominas: Record "Configuracion nominas";
        Empresa: Record "Empresas Cotizacion";
        LinPerfil: Record "Perfil Salarial";
        Cargo: Record "Puestos laborales";
        PerfilPuesto: Record "Perfil Salario x Cargo";
        HistPtosProp: Record "Histórico Puntos Propina";
        Employee: Record Employee;
        Conceptossalariales: Record "Conceptos salariales";
        Departamentos: Record Departamentos;
        /*       FuncNominas: Codeunit "Funciones Nomina"; */
        Err001: Label 'This Account No. already exist for employee %1';
        Err002: Label 'This employee has posted payroll, you can not delete it';
        Err003: Label 'This %1 already exist for the employee %2 %3';
        "******* MdE******": Integer;
        FromMdE: Boolean;
        MdeMgnt: Codeunit "MdE Management";
}

