table 76244 "Arch. Acciones de personal"
{
    Caption = 'Personnel activities';
    DrillDownPageID = "Hist. acciones de personal";
    LookupPageID = "Hist. acciones de personal";

    fields
    {
        field(1; "Tipo de accion"; Option)
        {
            Caption = 'Action type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Ingreso,Cambio,Salida';
            OptionMembers = " ",Ingreso,Cambio,Salida;
        }
        field(2; "Cod. accion"; Code[20])
        {
            Caption = 'Action code';
            DataClassification = ToBeClassified;
            TableRelation = "Tipos de acciones personal".Codigo WHERE("Tipo de accion" = FIELD("Tipo de accion"));
        }
        field(3; "No. empleado"; Code[20])
        {
            Caption = 'Employee no.';
            DataClassification = ToBeClassified;
        }
        field(4; "Nombre completo"; Text[60])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "ID Documento"; Code[15])
        {
            Caption = 'Document ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Empresas: Record Company;
            begin
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
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Fecha efectividad"; Date)
        {
            Caption = 'Efectivity date';
            DataClassification = ToBeClassified;
        }
        field(9; Comentario; Text[250])
        {
            Caption = 'Comments';
            DataClassification = ToBeClassified;
        }
        field(10; "Cargo actual"; Code[20])
        {
            Caption = 'Actual job position';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Puestos laborales".Codigo WHERE("Cod. departamento" = FIELD("Departamento actual"));
        }
        field(11; "Descripcion cargo actual"; Text[60])
        {
            Caption = 'Actual job description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Nuevo cargo"; Code[20])
        {
            Caption = 'New job code';
            DataClassification = ToBeClassified;
            TableRelation = "Puestos laborales".Codigo WHERE("Cod. departamento" = FIELD("Departamento nuevo"));
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
        }
        field(16; "Departamento actual"; Code[20])
        {
            Caption = 'Actual departament code';
            DataClassification = ToBeClassified;
            Editable = false;
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
            Editable = false;
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
        }
        field(39; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
            DataClassification = ToBeClassified;
        }
        field(40; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
            DataClassification = ToBeClassified;
        }
        field(41; "Second Last Name"; Text[30])
        {
            Caption = 'Second Last Name';
            DataClassification = ToBeClassified;
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
        }
        field(46; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
        field(51; Gender; Option)
        {
            Caption = 'Gender';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
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
        Err003: Label 'The %1 already exist for the %2 %3 in %4 %5';
        /*   FuncNominas: Codeunit "Funciones Nomina"; */
        Err005: Label 'The %1 is out of the limits for this level. %2 %3, %4 %5, do you want to continue?';
        Err006: Label 'The maximum number of vacancies for this position has already been reached. No more people can be assigned to this position.';
        Msg001: Label 'Are you sure you want to delete the %1?';
        Msg002: Label 'The selection of %1 has been changed, the selected benefits will be eliminated and new values will be re-used, do you want to continue?';
}

