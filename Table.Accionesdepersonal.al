table 76164 "Acciones de personal"
{
    Caption = 'Personnel activities';
    DrillDownPageID = "Hist. acciones de personal";
    LookupPageID = "Hist. acciones de personal";

    fields
    {
        field(1; "Tipo de accion"; Option)
        {
            Caption = 'Action type';
            OptionCaption = ' ,Ingreso,Cambio,Salida';
            OptionMembers = " ",Ingreso,Cambio,Salida;

            trigger OnValidate()
            begin
                if (xRec."Tipo de accion" <> "Tipo de accion") then
                    "Cod. accion" := '';
            end;
        }
        field(2; "Cod. accion"; Code[20])
        {
            Caption = 'Action code';
            DataClassification = ToBeClassified;
            TableRelation = "Tipos de acciones personal".Codigo WHERE("Tipo de accion" = FIELD("Tipo de accion"));

            trigger OnValidate()
            begin
                AccP.Get("Tipo de accion", "Cod. accion");
                "Descripcion accion" := AccP.Descripcion;
            end;
        }
        field(3; "No. empleado"; Code[20])
        {
            Caption = 'Employee no.';
            TableRelation = IF ("Tipo de accion" = CONST(Ingreso)) Elegibles WHERE(Status = CONST(Elegible))
            ELSE
            IF ("Tipo de accion" = FILTER(<> Ingreso)) Employee;

            trigger OnValidate()
            begin
                if "Tipo de accion" <> "Tipo de accion"::Ingreso then begin
                    Emp.Get("No. empleado");
                    Validate("First Name", Emp."First Name");
                    Validate("Middle Name", Emp."Middle Name");
                    Validate("Last Name", Emp."Last Name");
                    Validate("Second Last Name", Emp."Second Last Name");

                    "ID Documento" := Emp."Document ID";
                    "Cargo actual" := Emp."Job Type Code";
                    "Nuevo cargo" := "Cargo actual";
                    "Descripcion cargo actual" := Emp."Job Title";
                    Emp.CalcFields(Salario);
                    "Sueldo actual" := Emp.Salario;
                    Emp.CalcFields("Desc. Departamento");
                    Validate("Departamento actual", Emp.Departamento);
                    "Departamento nuevo" := "Departamento actual";
                    "Ubicacion actual" := Emp."Working Center";
                    Emp.CalcFields(Cuenta);
                    "Numero cuenta actual" := Emp.Cuenta;
                    "Nivel actual" := Emp."Employee Level";
                    "Tipo de contrato" := Emp."Emplymt. Contract Code";
                    "Document Type" := Emp."Document Type";
                    Address := Emp.Address;
                    "Address 2" := Emp."Address 2";
                    City := Emp.City;
                    "Post Code" := Emp."Post Code";
                    County := Emp.County;
                    "Country/Region Code" := Emp."Country/Region Code";
                    //"URL Linkedin" :=
                    //"URL Facebook" :=
                    Gender := Emp.Gender;
                    "Lugar nacimiento" := Emp."Lugar nacimiento";
                    "Estado civil" := Emp."Estado civil";
                end
                else begin
                    Cand.Get("No. empleado");
                    "Cod. elegible" := Cand."No.";
                    Validate("First Name", Cand."First Name");
                    Validate("Middle Name", Cand."Middle Name");
                    Validate("Last Name", Cand."Last Name");
                    Validate("Second Last Name", Cand."Second Last Name");
                    "Document Type" := Cand."Document Type";
                    Validate("ID Documento", Cand."Document ID");
                    Address := Cand.Address;
                    "Address 2" := Cand."Address 2";
                    City := Cand.City;
                    "Post Code" := Cand."Post Code";
                    County := Cand.County;
                    "Country/Region Code" := Cand."Country/Region Code";
                    //"URL Linkedin" :=  Emp.u
                    //"URL Facebook" :=
                    Gender := Cand.Gender;
                    "Lugar nacimiento" := Cand."Lugar nacimiento";
                    "Estado civil" := Cand."Estado civil";
                end;

                Beneficiospuestoslaborales.Reset;
                //Beneficiospuestoslaborales.SETRANGE("Cod. cargo","Nuevo cargo");
                if Beneficiospuestoslaborales.FindSet then
                    repeat
                        Seleccionbeneficios.Init;
                        Seleccionbeneficios."No. documento" := "No.";
                        Seleccionbeneficios."Cod. Empleado" := "No. empleado";
                        Seleccionbeneficios."Tipo Beneficio" := Beneficiospuestoslaborales."Tipo Beneficio";
                        Seleccionbeneficios.Codigo := Beneficiospuestoslaborales.Codigo;
                        Seleccionbeneficios.Descripcion := Beneficiospuestoslaborales.Descripcion;
                        if not Seleccionbeneficios.Insert then
                            Seleccionbeneficios.Modify;
                    until Beneficiospuestoslaborales.Next = 0;
            end;
        }
        field(4; "Nombre completo"; Text[60])
        {
            Caption = 'Name';
            Editable = false;

            trigger OnValidate()
            begin
                "Nombre completo" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name" + ' ' + "Second Last Name";
            end;
        }
        field(5; "ID Documento"; Code[15])
        {
            Caption = 'Document ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Empresas: Record Company;
            begin
                if "Document Type" = "Document Type"::"Cédula" then
                    /*   if not FuncNominas.ValidarCedula(DelChr("ID Documento", '=', '-')) then
                          Error(StrSubstNo(Err004, "Document Type"));
   */
                if "Tipo de accion" = "Tipo de accion"::Ingreso then begin
                        if ConfNominas."Multiempresa activo" then
                            Empresas.SetRange(Name, CompanyName);
                        Empresas.Find('-');
                        repeat
                            Clear(Emp);
                            if ConfNominas."Multiempresa activo" then
                                Emp.ChangeCompany(Empresas.Name);
                            Emp.SetRange("Document ID", "ID Documento");
                            if Emp.FindFirst then
                                Error(StrSubstNo(Err003, FieldCaption("ID Documento"), Emp.TableCaption, Emp."No.", Empresas.TableCaption, Empresas.Name));
                        until Empresas.Next = 0;
                    end;
            end;
        }
        field(6; "Descripcion accion"; Text[60])
        {
            Caption = 'Action description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Fecha accion"; Date)
        {
            Caption = 'Action date';
            Editable = false;
        }
        field(8; "Fecha efectividad"; Date)
        {
            Caption = 'Efectivity date';
        }
        field(9; Comentario; Text[250])
        {
            Caption = 'Comments';
        }
        field(10; "Cargo actual"; Code[20])
        {
            Caption = 'Actual job position';
            TableRelation = "Puestos laborales".Codigo WHERE("Cod. departamento" = FIELD("Departamento actual"));
        }
        field(11; "Descripcion cargo actual"; Text[60])
        {
            Caption = 'Actual job description';
            Editable = false;
        }
        field(12; "Nuevo cargo"; Code[20])
        {
            Caption = 'New job code';
            DataClassification = ToBeClassified;
            TableRelation = "Puestos laborales".Codigo WHERE("Cod. departamento" = FIELD("Departamento nuevo"));

            trigger OnValidate()
            begin
                if "Nuevo cargo" <> '' then begin
                    Cargos.Get("Departamento nuevo", "Nuevo cargo");
                    "Descripcion cargo nuevo" := Cargos.Descripcion;
                    NivelesCargos.Reset;
                    NivelesCargos.SetRange("Cod. Nivel", Cargos."Cod. nivel");
                    NivelesCargos.FindSet;
                    if NivelesCargos.Count > 1 then begin
                        NivelCargo.SetTableView(NivelesCargos);
                        NivelCargo.LookupMode(true);
                        if PAGE.RunModal(0, NivelesCargos) = ACTION::LookupOK then
                            "Nivel nuevo" := NivelesCargos."Cod. Nivel";
                    end
                    else
                        "Nivel nuevo" := NivelesCargos."Cod. Nivel";

                    Cargos.CalcFields("Total Empleados");
                    if (Cargos."Total Empleados" >= Cargos."Maximo de posiciones") and (Cargos."Maximo de posiciones" <> 0) then
                        Error(Err006);
                end;

                /*
                IF (xRec."Nuevo cargo" <> "Nuevo cargo") AND (xRec."Nuevo cargo" <> '') THEN
                   BEGIN
                     IF CONFIRM(STRSUBSTNO(Msg002,FIELDCAPTION( "Nuevo cargo"))) THEN
                        BEGIN
                          Seleccionbeneficios.RESET;
                          Seleccionbeneficios.SETRANGE("Cod. Empleado","No. empleado");
                          IF Seleccionbeneficios.FINDSET THEN
                            Seleccionbeneficios.DELETEALL;
                        END;
                  END;
                */

            end;
        }
        field(13; "Descripcion cargo nuevo"; Text[60])
        {
            Caption = 'New job description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Sueldo actual"; Decimal)
        {
            Caption = 'Actual salary';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Sueldo Nuevo"; Decimal)
        {
            Caption = 'New salary';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Cargos.Reset;
                if ("Cargo actual" <> "Nuevo cargo") and ("Nuevo cargo" <> '') then
                    Cargos.Get("Departamento nuevo", "Nuevo cargo")
                else
                    Cargos.Get("Departamento actual", "Cargo actual");

                NivelesCargos.Reset;
                NivelesCargos.SetRange("Cod. Nivel", Cargos."Cod. nivel");
                NivelesCargos.FindFirst;
                if ("Sueldo Nuevo" < NivelesCargos."Importe mínimo") or
                   ("Sueldo Nuevo" > NivelesCargos."Importe máximo") then
                    if not Confirm(StrSubstNo(Err005, FieldCaption("Sueldo Nuevo"), NivelesCargos.FieldCaption("Importe mínimo"), NivelesCargos."Importe mínimo", NivelesCargos.FieldCaption("Importe máximo"), NivelesCargos."Importe máximo")) then
                        Error('');
            end;
        }
        field(16; "Departamento actual"; Code[20])
        {
            Caption = 'Actual departament code';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                if Depto.Get("Departamento actual") then
                    "Nombre  depto. actual" := Depto.Descripcion;
            end;
        }
        field(17; "Nombre  depto. actual"; Text[60])
        {
            Caption = 'Actual department name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Departamento nuevo"; Code[20])
        {
            Caption = 'New department';
            DataClassification = ToBeClassified;
            TableRelation = Departamentos WHERE(Inactivo = CONST(false));

            trigger OnValidate()
            begin
                if Depto.Get("Departamento nuevo") then
                    "Nombre depto. nuevo" := Depto.Descripcion;

                if "Departamento nuevo" <> xRec."Departamento nuevo" then begin
                    "Nuevo cargo" := '';
                    "Descripcion cargo nuevo" := '';
                end;
            end;
        }
        field(19; "Nombre depto. nuevo"; Text[60])
        {
            Caption = 'New department name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Ubicacion actual"; Code[20])
        {
            Caption = 'Actual office';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Centros de Trabajo"."Centro de trabajo";
        }
        field(21; "Ubicacion nueva"; Code[20])
        {
            Caption = 'New office';
            DataClassification = ToBeClassified;
            TableRelation = "Centros de Trabajo"."Centro de trabajo";
        }
        field(22; "Empresa nueva"; Text[30])
        {
            Caption = 'New company';
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(23; "Numero cuenta actual"; Code[15])
        {
            Caption = 'Actual account no.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Numero cuenta nueva"; Code[15])
        {
            Caption = 'New account no.';
            DataClassification = ToBeClassified;
        }
        field(25; "Nivel actual"; Code[20])
        {
            Caption = 'Actual level';
            DataClassification = ToBeClassified;
        }
        field(26; "Nivel nuevo"; Code[20])
        {
            Caption = 'New level';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(27; "Tipo de contrato"; Code[20])
        {
            Caption = 'Contract type code';
            DataClassification = ToBeClassified;
            TableRelation = "Employment Contract";

            trigger OnValidate()
            begin
                if EmpContract.Get("Tipo de contrato") then
                    "Duracion contrato" := EmpContract.Duracion;
            end;
        }
        field(28; "Preparado por"; Code[50])
        {
            Caption = 'Prepared by';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(29; "Revisado por"; Code[50])
        {
            Caption = 'Reviewed by';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(30; "Autorizado por"; Code[50])
        {
            Caption = 'Authorized by';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(31; "No. serie"; Code[20])
        {
            Caption = 'Serial no.';
            DataClassification = ToBeClassified;
        }
        field(32; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(33; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'SS,Passport,Residence ID,Work Permission';
            OptionMembers = "Cédula",Pasaporte,"Tarj.residen.comunitario","Perm.Trabajo",,"N.I.Extranjero","N.I.F.";
        }
        field(34; Preaviso; Boolean)
        {
            Caption = 'Notice';
            DataClassification = ToBeClassified;
        }
        field(35; Cesantia; Boolean)
        {
            Caption = 'Unemployment';
            DataClassification = ToBeClassified;
        }
        field(36; Regalia; Boolean)
        {
            Caption = 'Christmas salary';
            DataClassification = ToBeClassified;
        }
        field(37; "Duracion contrato"; DateFormula)
        {
            Caption = 'Contract''s duration';
            DataClassification = ToBeClassified;
        }
        field(38; "First Name"; Text[30])
        {
            Caption = 'First Name';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Nombre completo");
            end;
        }
        field(39; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Nombre completo");
            end;
        }
        field(40; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Nombre completo");
            end;
        }
        field(41; "Second Last Name"; Text[30])
        {
            Caption = 'Second Last Name';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Nombre completo");
            end;
        }
        field(42; "Cod. elegible"; Code[20])
        {
            Caption = 'Eligible code';
            DataClassification = ToBeClassified;
        }
        field(43; Address; Text[60])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(44; "Address 2"; Text[60])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(45; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", true);
                //GRN PostCode.ValidateCity(City,"Post Code");
            end;
        }
        field(46; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", true);
                //GRN PostCode.ValidatePostCode(City,"Post Code");
            end;
        }
        field(47; County; Text[30])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(48; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(49; "URL Linkedin"; Text[80])
        {
            Caption = 'Linkedin URL';
            DataClassification = ToBeClassified;
        }
        field(50; "URL Facebook"; Text[80])
        {
            Caption = 'Facebook URL';
            DataClassification = ToBeClassified;
        }
        field(51; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';
            DataClassification = ToBeClassified;
            //OptionCaption = ' ,Female,Male';
            //OptionMembers = " ",Female,Male;
        }
        field(52; "Lugar nacimiento"; Text[30])
        {
            Caption = 'Birth place';
            DataClassification = ToBeClassified;
        }
        field(53; "Estado civil"; Option)
        {
            Caption = 'Civil status';
            DataClassification = ToBeClassified;
            Description = 'Soltero/a,Casado/a,Viudo/a,Separado/a,Divorciado/a';
            OptionMembers = "Soltero/a","Casado/a","Viudo/a","Separado/a","Divorciado/a";
        }
        field(54; "Comentario 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(56; "Cod. Banco"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bancos ACH Nomina";
        }
        field(57; "Fecha expiracion"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(58; "Numero tarjeta"; Code[16])
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Importe tarjeta"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Banco tarjeta"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bancos ACH Nomina";
        }
        field(61; "Cod. Supervisor"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Emp.Get("Cod. Supervisor") then
                    "Nombre Supervisor" := Emp."Full Name";
            end;
        }
        field(62; "Nombre Supervisor"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(63; "Fecha de inicio"; Date)
        {
            Caption = 'Starting date';
            DataClassification = ToBeClassified;
        }
        field(64; "Fecha final"; Date)
        {
            Caption = 'Ending date';
            DataClassification = ToBeClassified;
        }
        field(65; "Cause of Inactivity Code"; Code[10])
        {
            Caption = 'Cause of Inactivity Code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Inactivity";
        }
        field(66; "Tipo de miembro"; Option)
        {
            Caption = 'Member type';
            DataClassification = ToBeClassified;
            Description = 'Cooperativa';
            OptionCaption = 'Member, Partner';
            OptionMembers = Miembro,Socio;
        }
        field(67; "1ra Quincena"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Cooperativa';
        }
        field(68; "2da Quincena"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Cooperativa';
        }
        field(69; "Fecha inscripcion"; Date)
        {
            Caption = 'Enrollment date';
            DataClassification = ToBeClassified;
            Description = 'Cooperativa';
        }
        field(70; "Tipo de aporte"; Option)
        {
            Caption = 'Contribution type';
            DataClassification = ToBeClassified;
            Description = 'Cooperativa';
            OptionCaption = 'Fix,Percentage';
            OptionMembers = Fijo,Porcentual;
        }
        field(71; Importe; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Description = 'Cooperativa';
        }
        field(72; "Proximo no. empleado"; Code[20])
        {
            Caption = 'Next Employee no.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Tipo de accion", "Cod. accion")
        {
        }
    }

    trigger OnDelete()
    begin

        if Confirm(StrSubstNo(Msg001, TableCaption), false) then
            Delete;
    end;

    trigger OnInsert()
    begin
        "Preparado por" := UserId;
        "Fecha accion" := Today;
        //Para cuando el numerador de empleados es comun a las empresas
        ConfNominas.Get();
        if (ConfNominas."Habilitar numeradores globales") and ("No." = '') then begin
            Numeradorescomunes.FindFirst;
            Numeradorescomunes.TestField("No. serie acciones");
            "No." := IncStr(Numeradorescomunes."No. serie acciones");
            Numeradorescomunes."No. serie acciones" := "No.";
            Numeradorescomunes.Modify;
        end
        else
            if "No." = '' then begin
                HumanResSetup.Get;
                HumanResSetup.TestField("No. serie acciones personal");
                //NoSeriesMgt.InitSeries(HumanResSetup."No. serie acciones personal", xRec."No. serie", 0D, "No.", "No. serie");
                Rec."No. serie" := HumanResSetup."No. serie acciones personal";
                if NoSeriesMgt.AreRelated(HumanResSetup."No. serie acciones personal", xRec."No. Serie") then
                    Rec."No. Serie" := xRec."No. Serie";
                Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Serie");
            end;


        Beneficiospuestoslaborales.Reset;
        //Beneficiospuestoslaborales.SETRANGE("Cod. cargo","Nuevo cargo");
        if Beneficiospuestoslaborales.FindSet then
            repeat
                Seleccionbeneficios.Init;
                Seleccionbeneficios."No. documento" := "No.";
                Seleccionbeneficios."Cod. Empleado" := "No. empleado";
                Seleccionbeneficios."Tipo Beneficio" := Beneficiospuestoslaborales."Tipo Beneficio";
                Seleccionbeneficios.Codigo := Beneficiospuestoslaborales.Codigo;
                Seleccionbeneficios.Descripcion := Beneficiospuestoslaborales.Descripcion;
                if Seleccionbeneficios.Insert then;
            until Beneficiospuestoslaborales.Next = 0;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        Contrato: Record Contratos;
        Err001: Label 'You can''t void/delete a type of contract assigned to an employee';
        Emp: Record Employee;
        Cand: Record Elegibles;
        AccP: Record "Tipos de acciones personal";
        Cargos: Record "Puestos laborales";
        NivelesCargos: Record "Nivel Cargo";
        Depto: Record Departamentos;
        EmpContract: Record "Employment Contract";
        Empresas: Record Company;
        Autorizacion: Record "Seguridad Usuarios RH";
        Err002: Label 'Document can not be deleted';
        PostCode: Record "Post Code";
        ConfNominas: Record "Configuracion nominas";
        Numeradorescomunes: Record "Numeradores globales";
        Beneficiospuestoslaborales: Record "Beneficios laborales";
        Seleccionbeneficios: Record "Seleccion beneficios";
        NivelCargo: Page "Niveles puestos laborales";
        NoSeriesMgt: Codeunit "No. Series";
        Err003: Label 'The %1 already exist for the %2 %3 in %4 %5';
        Err005: Label 'The %1 is out of the limits for this level. %2 %3, %4 %5, do you want to continue?';
        Err006: Label 'The maximum number of vacancies for this position has already been reached. No more people can be assigned to this position.';
        Msg001: Label 'Are you sure you want to delete the %1?';
        Msg002: Label 'The selection of %1 has been changed, the selected benefits will be eliminated and new values will be re-used, do you want to continue?';
}

