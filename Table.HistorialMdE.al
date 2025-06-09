table 56202 "Historial MdE"
{
    // #81969 27/01/2018 PLB: Nueva tabla para el MdE
    // #269159 14.10.2019, RRT: Control de registros pendientes de aplicación.
    // 
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // FES   : Fausto Serrata
    // ------------------------------------------------------------------------------
    // No.       Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // 001       FES             21-02-2024    Ajuste códiga para que el departamento no se borre

    Caption = 'Employee';
    DataCaptionFields = "No.", "First Name", "Last Name";
    DrillDownPageID = "Employee List";
    LookupPageID = "Employee List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "First Name"; Text[50])
        {
            Caption = 'First Name';

            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';

            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(5; Initials; Text[30])
        {
            Caption = 'Initials';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Initials)) or ("Search Name" = '') then
                    "Search Name" := Initials;
            end;
        }
        field(6; "Job Title"; Text[50])
        {
            Caption = 'Job Title';
        }
        field(7; "Search Name"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(8; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(10; City; Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(11; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(12; County; Text[30])
        {
            Caption = 'State';
        }
        field(13; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(14; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(15; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(20; "Birth Date"; Date)
        {
            Caption = 'Birth Date';

            trigger OnValidate()
            begin
                if "Birth Date" <> 0D then
                    "Mes Nacimiento" := Date2DMY("Birth Date", 2);
            end;
        }
        field(21; "Social Security No."; Text[30])
        {
            Caption = 'Social Security No.';
        }
        field(24; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';
            //OptionCaption = ' ,Female,Male';
            //OptionMembers = " ",Female,Male;
        }
        field(25; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(26; "Manager No."; Code[20])
        {
            Caption = 'Manager No.';
            TableRelation = Employee;
        }
        field(27; "Emplymt. Contract Code"; Code[10])
        {
            Caption = 'Emplymt. Contract Code';
            TableRelation = "Employment Contract";

            trigger OnValidate()
            var
                Contratos: Record Contratos;
            begin
                TestField(Company);
                Empresa.Get(Company);
                TipoContrato.Get("Emplymt. Contract Code");
            end;
        }
        field(28; "Statistics Group Code"; Code[10])
        {
            Caption = 'Statistics Group Code';
            TableRelation = "Employee Statistics Group";
        }
        field(29; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
        }
        field(31; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(32; "Inactive Date"; Date)
        {
            Caption = 'Inactive Date';
        }
        field(33; "Cause of Inactivity Code"; Code[10])
        {
            Caption = 'Cause of Inactivity Code';
            TableRelation = "Cause of Inactivity";
        }
        field(34; "Termination Date"; Date)
        {
            Caption = 'Termination Date';
        }
        field(35; "Grounds for Term. Code"; Code[10])
        {
            Caption = 'Grounds for Term. Code';
            TableRelation = "Grounds for Termination";
        }
        field(36; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(37; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(38; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource WHERE(Type = CONST(Person));
        }
        field(40; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(50000; _Categoria; Option)
        {
            Caption = 'Category';
            Description = 'Grupo Santillana';
            OptionCaption = ' ,01-PD,02-MI,03-PTC,04-OP';
            OptionMembers = " ","01-PD","02-MI","03-PTC","04-OP";
        }
        field(50002; "Numero de persona"; Text[32])
        {
            Caption = 'Número de persona';
            Description = 'Santillana,MDE';
        }
        field(56200; "No. Mov."; Integer)
        {
        }
        field(56201; "Fecha y hora recepcion"; DateTime)
        {
        }
        field(56202; "Fecha efectiva"; Date)
        {
        }
        field(56203; Aplicado; Boolean)
        {
        }
        field(56204; "Tipo envio"; Option)
        {
            OptionMembers = INSERT,CHANGE,DELETE;
        }
        field(56205; "M nombre"; Boolean)
        {
        }
        field(56206; "M primer apellido"; Boolean)
        {
        }
        field(56207; "M segundo apellido"; Boolean)
        {
        }
        field(56208; "M fecha antiguedad reconoci"; Boolean)
        {
        }
        field(56209; "M tipo documento"; Boolean)
        {
        }
        field(56210; "M numero documento"; Boolean)
        {
        }
        field(56211; "M genero"; Boolean)
        {
        }
        field(56212; "M estado civil"; Boolean)
        {
        }
        field(56213; "M fecha nacimiento"; Boolean)
        {
        }
        field(56214; "M provincia nacimiento"; Boolean)
        {
        }
        field(56215; "M pais nacimiento"; Boolean)
        {
        }
        field(56216; "M nacionalidad"; Boolean)
        {
        }
        field(56217; "M pais"; Boolean)
        {
        }
        field(56218; "M nombre calle"; Boolean)
        {
        }
        field(56219; "M ciudad"; Boolean)
        {
        }
        field(56220; "M codigo postal"; Boolean)
        {
        }
        field(56221; "M provincia"; Boolean)
        {
        }
        field(56222; "M direccion"; Boolean)
        {
        }
        field(56223; "M numero telefono"; Boolean)
        {
        }
        field(56224; "M posicion"; Boolean)
        {
        }
        field(56225; "M centro trabajo"; Boolean)
        {
        }
        field(56226; "M Categoria grupo"; Boolean)
        {
        }
        field(56227; "M tipo contrato grupo"; Boolean)
        {
        }
        field(56228; "M departamento"; Boolean)
        {
        }
        field(56229; "M division"; Boolean)
        {
        }
        field(56230; "M area funcional grupo"; Boolean)
        {
        }
        field(56231; "M fecha inicio contrato"; Boolean)
        {
        }
        field(56232; "M fecha fin contrato"; Boolean)
        {
        }
        field(56233; "M tipo baja"; Boolean)
        {
        }
        field(56234; "Cod. Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(56235; "Valor Dimension"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Cod. Dimension"));
        }
        field(56236; "Fecha y hora aplicado"; DateTime)
        {
        }
        field(56237; "Aplicado por usuario"; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(56238; "Nombre completo"; Text[150])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(56260; "Error proceso"; Boolean)
        {
        }
        field(56261; "Descripcion error"; Text[150])
        {
        }
        field(56270; "Desactivacion forzada"; Option)
        {
            Description = ' #269159';
            OptionMembers = No,Si;
        }
        field(76200; Company; Code[10])
        {
            Caption = 'Company';
            TableRelation = "Empresas Cotizacion";
        }
        field(76060; "Second Last Name"; Text[30])
        {
            Caption = 'Second Last Name';

            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(76000; "Working Center"; Code[10])
        {
            Caption = 'Working Center';
            TableRelation = "Centros de Trabajo"."Centro de trabajo" WHERE("Empresa cotización" = FIELD(Company));
        }
        field(76049; "Full Name"; Text[150])
        {
            Caption = 'Full Name';

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Last Name" + ' ' + "Second Last Name";
            end;
        }
        field(76031; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'SS,Passport,Residence ID,Work Permission';
            OptionMembers = "Cédula",Pasaporte,"Tarj.residen.comunitario","Perm.Trabajo",,"N.I.Extranjero","N.I.F.";
        }
        field(76053; "Document ID"; Text[20])
        {
            Caption = 'Document ID';
        }
        field(76044; "Job Type Code"; Code[15])
        {
            Caption = 'Cod. Cargo';
            TableRelation = "Puestos laborales";

            trigger OnValidate()
            begin
                Cargo.Get("Job Type Code");
            end;
        }
        field(76069; "Alta contrato"; Date)
        {
            Caption = 'Enroll date';
        }
        field(76013; "Fin contrato"; Date)
        {
            Caption = 'Ending date';
        }
        field(76063; _Nacionalidad; Code[10])
        {
            Caption = 'Nacionality';
            TableRelation = "Country/Region";
        }
        field(76071; "Lugar nacimiento"; Text[30])
        {
        }
        field(76072; "Estado civil"; Option)
        {
            Description = 'Soltero/a,Casado/a,Viudo/a,Separado/a,Divorciado/a';
            OptionCaption = 'Single, Married, Widowed, Separated, Divorced, Free Union';
            OptionMembers = "Soltero/a","Casado/a","Viudo/a","Separado/a","Divorciado/a","Unión libre";
        }
        field(76038; "Mes Nacimiento"; Integer)
        {
            Editable = false;
        }
        field(76253; _Departamento; Code[20])
        {
            CaptionClass = '4,1,1';
            Caption = 'Department';
            TableRelation = Departamentos;
        }
    }

    keys
    {
        key(Key1; "No.", "No. Mov.")
        {
            Clustered = true;
        }
        key(Key2; Aplicado, "Fecha efectiva")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "First Name", "Last Name", "Second Last Name", _Departamento)
        {
        }
    }

    trigger OnDelete()
    var
        Contrato: Record Contratos;
        PerfilSal: Record "Perfil Salarial";
        HistNom: Record "Historico Cab. nomina";
    begin
    end;

    trigger OnInsert()
    var
        MdEemployee: Record "Historial MdE";
    begin
        MdEemployee.SetRange("No.", "No.");
        if MdEemployee.FindLast then
            "No. Mov." := MdEemployee."No. Mov." + 1
        else
            "No. Mov." := 1;


        ControlPendientes;  //+#269159
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        PostCode: Record "Post Code";
        Empresa: Record "Empresas Cotizacion";
        Cargo: Record "Puestos laborales";
        TipoContrato: Record "Employment Contract";
        Contrato: Record Contratos;
        ErrorTipoDatos: Label 'Error de datos';
        ErrorInsert: Label 'No se puede crear el %1 para el empleado %2.';
        ErrorInsertEmployee: Label ' Revise que, si está enviando un alta nueva, el número de serie asignado a recursos humanos en Dynamics NAV esté correctamente configurado.';
        ErrorModify: Label 'No se puede modificar el %1 para el empleado %2.';
        IsOk: Boolean;
        DescErrorArray: array[10] of Text;
        TipoErrorArray: array[10] of Text;
        ErrorContractDoNotExist: Label 'El contrato para el empleado %1 %2 no existe.';


    procedure ApplyToEmployee()
    var
        Employee: Record Employee;
    begin
        Employee.Get("No.");

        case "Tipo envio" of
            "Tipo envio"::INSERT:
                InsertEmployee(Employee);
            "Tipo envio"::CHANGE:
                ModifyEmployee(Employee);
            "Tipo envio"::DELETE:
                DeleteEmployee(Employee);
        end;
    end;


    procedure InsertEmployee(var Employee: Record Employee)
    var
        NoOrden: Integer;
    begin
        IsOk := true;

        // Campos tabla 5200 "Employee"
        //Employee.TRANSFERFIELDS(Rec);
        Employee."Numero de persona" := "Numero de persona";
        Employee."First Name" := "First Name";
        Employee."Last Name" := "Last Name";
        Employee."Second Last Name" := "Second Last Name";
        Employee."Employment Date" := "Employment Date";
        Employee."Document Type" := "Document Type";
        Employee."Document ID" := "Document ID";
        Employee.Gender := Gender;
        Employee."Estado civil" := "Estado civil";
        Employee."Birth Date" := "Birth Date";
        Employee."Lugar nacimiento" := "Lugar nacimiento";
        Employee.Nacionalidad := _Nacionalidad;
        Employee."Country/Region Code" := "Country/Region Code";
        Employee.Address := Address;
        Employee.City := City;
        Employee."Post Code" := "Post Code";
        Employee.County := County;
        Employee."E-Mail" := "E-Mail";
        Employee."Phone No." := "Phone No.";
        Employee."Job Type Code" := "Job Type Code";
        Employee."Working Center" := "Working Center";
        //fes mig Employee.Categoria := _Categoria;
        Employee."Emplymt. Contract Code" := "Emplymt. Contract Code";
        Employee.Departamento := _Departamento;

        Employee.Validate("Full Name");
        Employee.Validate("Birth Date");
        Employee."Calcular Nomina" := true;
        Employee.SetFromMde(true);
        if Employee."No." = '' then begin
            if not Employee.Insert(true) then begin
                AddError(StrSubstNo(ErrorInsert + ErrorInsertEmployee, Employee.TableCaption, "Numero de persona"), ErrorTipoDatos);
                exit;
            end;
        end
        else begin
            if not Employee.Modify(true) then begin
                AddError(StrSubstNo(ErrorModify, Employee.TableCaption, "Numero de persona"), ErrorTipoDatos);
                exit;
            end;
        end;

        if Employee."Job Type Code" <> '' then begin
            Employee.Validate("Job Type Code");
            if not Employee.Modify(true) then begin
                AddError(StrSubstNo(ErrorModify, Employee.TableCaption, "Numero de persona"), ErrorTipoDatos);
                exit;
            end;
        end;

        // Campos configurables (dimension)
        if "Valor Dimension" <> '' then begin
            UpdateDimension(Employee."No.", "Cod. Dimension", "Valor Dimension");
            Employee.Find; // refrescamos empleado, puede haberse actualizado con una dimensión global
        end;

        // Campos tabla 76069 "Contratos"
        Contrato.SetRange("No. empleado", Employee."No.");
        if Contrato.FindLast then
            NoOrden := Contrato."No. Orden" + 100
        else
            NoOrden := 100;

        Empresa.FindFirst;

        Contrato.Init;
        Contrato."No. empleado" := Employee."No.";
        Contrato."No. Orden" := NoOrden;
        Contrato.Validate("Cód. contrato", Employee."Emplymt. Contract Code");
        Contrato."Frecuencia de pago" := Empresa."Tipo Pago Nomina";
        Contrato.SetFromMde(true);
        if not Contrato.Insert(true) then begin
            AddError(StrSubstNo(ErrorInsert, Contrato.TableCaption, "Numero de persona"), ErrorTipoDatos);
            exit;
        end;

        Contrato.Validate("Fecha inicio", "Alta contrato");
        Contrato.Validate("Fecha finalización", "Fin contrato");
        Contrato.SetFromMde(true);
        if not Contrato.Modify(true) then begin
            AddError(StrSubstNo(ErrorModify, Contrato.TableCaption, "Numero de persona"), ErrorTipoDatos);
            exit;
        end;

        UpdateApplied(Employee."No.");

        //+#269159
        //... Ante la duda, sólo realizamos control de contratos si no se ha detectado ningún error.
        if IsOk then
            ControlContratos(Contrato);
        //-#269159
    end;


    procedure ModifyEmployee(var Employee: Record Employee)
    begin
        IsOk := true;

        // Campos tabla 5200 "Employee"
        if Employee."Numero de persona" <> "Numero de persona" then
            Employee."Numero de persona" := "Numero de persona";
        if "M nombre" then
            Employee."First Name" := "First Name";
        if "M primer apellido" then
            Employee."Last Name" := "Last Name";
        if "M segundo apellido" then
            Employee."Second Last Name" := "Second Last Name";
        Employee.Validate("Full Name");

        if "M fecha antiguedad reconoci" then
            Employee."Employment Date" := "Employment Date";

        if "M tipo documento" then
            Employee."Document Type" := "Document Type";
        if "M numero documento" then
            Employee."Document ID" := "Document ID";

        if "M genero" then
            Employee.Gender := Gender;
        if "M estado civil" then
            Employee."Estado civil" := "Estado civil";
        if "M fecha nacimiento" then
            Employee."Birth Date" := "Birth Date";
        if "M provincia nacimiento" or "M pais nacimiento" then
            Employee."Lugar nacimiento" := "Lugar nacimiento";

        if "M nacionalidad" then
            Employee.Nacionalidad := _Nacionalidad;
        if "M pais" then
            Employee."Country/Region Code" := "Country/Region Code";
        if "M nombre calle" then
            Employee.Address := Address;
        if "M ciudad" then
            Employee.City := City;
        if "M codigo postal" then
            Employee."Post Code" := "Post Code";
        if "M provincia" then
            Employee.County := County;

        if "M direccion" then
            Employee."E-Mail" := "E-Mail";
        if "M numero telefono" then
            Employee."Phone No." := "Phone No.";

        if "M posicion" and ("Job Type Code" <> '') then
            Employee.Validate("Job Type Code", "Job Type Code");

        if "M centro trabajo" then
            Employee."Working Center" := "Working Center";

        //fes mig IF "M Categoria grupo" THEN
        //fes mig Employee.Categoria := _Categoria;

        if "M tipo contrato grupo" then
            Employee."Emplymt. Contract Code" := "Emplymt. Contract Code";

        if "M departamento" then //001+-
            Employee.Departamento := _Departamento;

        Employee.SetFromMde(true);
        if not Employee.Modify(true) then begin
            AddError(StrSubstNo(ErrorModify, Employee.TableCaption, "Numero de persona"), ErrorTipoDatos);
            exit;
        end;

        // Campos configurables (dimension)
        if "Valor Dimension" <> '' then begin
            UpdateDimension(Employee."No.", "Cod. Dimension", "Valor Dimension");
            Employee.Find; // refrescamos empleado, puede haberse actualizado con una dimensión global
        end;

        // Campos tabla 76069 "Contratos"
        Contrato.SetRange("No. empleado", Employee."No.");
        if not Contrato.Find('+') then begin
            AddError(StrSubstNo(ErrorContractDoNotExist, 'Numero_persona', "Numero de persona"), ErrorTipoDatos);
            exit;
        end;

        if "M fecha inicio contrato" then
            Contrato."Fecha inicio" := "Alta contrato";
        if "M fecha fin contrato" then
            Contrato."Fecha finalización" := "Fin contrato";
        if "M tipo baja" then
            Contrato."Motivo baja" := "Grounds for Term. Code";

        if "M tipo contrato grupo" then
            Contrato.Validate("Cód. contrato", Employee."Emplymt. Contract Code");

        if "M fecha inicio contrato" then
            Contrato.Validate("Fecha inicio");
        if "M fecha fin contrato" then
            Contrato.Validate("Fecha finalización");
        Contrato.SetFromMde(true);
        if not Contrato.Modify(true) then begin
            AddError(StrSubstNo(ErrorModify, Contrato.TableCaption, "Numero de persona"), ErrorTipoDatos);
            exit;
        end;

        UpdateApplied(Employee."No.");
    end;


    procedure DeleteEmployee(var Employee: Record Employee)
    var
        NoOrden: Integer;
    begin
        IsOk := true;

        Contrato.SetRange("No. empleado", Employee."No.");
        if not Contrato.Find('+') then begin
            AddError(StrSubstNo(ErrorContractDoNotExist, 'Numero_persona', "Numero de persona"), ErrorTipoDatos);
            exit;
        end;

        if "M fecha fin contrato" then begin
            Contrato."Fecha finalización" := "Fin contrato";
            Contrato.Validate("Fecha finalización");
        end;
        if "M tipo baja" then
            Contrato."Motivo baja" := "Grounds for Term. Code";

        //Contrato.Activo := FALSE; // el usuario lo manipulará manualmente
        Contrato.Validate(Finalizado, true);
        Contrato.SetFromMde(true);
        if not Contrato.Modify(true) then begin
            AddError(StrSubstNo(ErrorModify, Contrato.TableCaption, "Numero de persona"), ErrorTipoDatos);
            exit;
        end;

        UpdateApplied(Employee."No.");
    end;

    local procedure UpdateApplied(var EmployeeNo: Code[20])
    begin
        Aplicado := true;
        "Error proceso" := false;
        "Descripcion error" := '';
        "Fecha y hora aplicado" := CurrentDateTime;
        "Aplicado por usuario" := UserId;

        if "No." = '' then begin
            "No." := EmployeeNo;
            if not Insert(true) then
                AddError(StrSubstNo(ErrorInsert, TableCaption, "Numero de persona"), ErrorTipoDatos);
        end
        else
            if not Modify(true) then
                AddError(StrSubstNo(ErrorModify, TableCaption, "Numero de persona"), ErrorTipoDatos);
    end;


    procedure GetErrors(var NewDescErrorArray: array[10] of Text; var NewTipoErrorArray: array[10] of Text): Boolean
    begin
        if not IsOk then begin
            CopyArray(NewDescErrorArray, DescErrorArray, 1);
            CopyArray(NewTipoErrorArray, TipoErrorArray, 1);
        end;

        exit(IsOk);
    end;

    local procedure AddError(ErrorText: Text; ErrorType: Text)
    var
        i: Integer;
        added: Boolean;
    begin
        if IsOk then
            IsOk := false;

        added := false;
        i := 0;
        repeat
            i += 1;
            if DescErrorArray[i] = '' then begin
                DescErrorArray[i] := ErrorText;
                TipoErrorArray[i] := ErrorType;
                added := true;
            end;
        until (i = ArrayLen(DescErrorArray)) or added;
    end;

    local procedure UpdateDimension(EmployeeNo: Code[20]; DimensionCode: Code[20]; DimensionValue: Code[20])
    var
        DefaultDim: Record "Default Dimension";
    begin
        if DefaultDim.Get(DATABASE::Employee, EmployeeNo, DimensionCode) then begin
            DefaultDim."Dimension Value Code" := DimensionValue;
            if not DefaultDim.Modify(true) then begin // (TRUE) --> Si son dimensiones globales, tienen que actualizar la ficha
                AddError(StrSubstNo(ErrorModify, DefaultDim.TableCaption, "Numero de persona"), ErrorTipoDatos);
                exit;
            end;
        end
        else begin
            DefaultDim."Table ID" := DATABASE::Employee;
            DefaultDim."No." := EmployeeNo;
            DefaultDim."Dimension Code" := DimensionCode;
            DefaultDim."Dimension Value Code" := DimensionValue;
            if not DefaultDim.Insert(true) then begin // (TRUE) --> Si son dimensiones globales, tienen que actualizar la ficha
                AddError(StrSubstNo(ErrorInsert, DefaultDim.TableCaption, "Numero de persona"), ErrorTipoDatos);
                exit;
            end;
        end;
    end;


    procedure ApplyManualy()
    begin
        ApplyToEmployee;
        if not IsOk then
            Error(DescErrorArray[1]);
    end;


    procedure ControlPendientes()
    var
        lrHistorial: Record "Historial MdE";
        lrHistorialAux: Record "Historial MdE";
    begin
        //+#269159
        //... Si para el nuevo contrato no está definida la fecha de finalización, investigaremos si hay alguna duplicidad:
        //...    No puede haber 2 contratos simultáneos vigentes sin fecha de finalización.
        //...
        //... Esta función irá modificándose en función de las anomalías detectadas.

        //... Si el tipo de envio no es INSERT, asumimos que no supone un problema.
        if "Tipo envio" <> "Tipo envio"::INSERT then
            exit;

        //... Si está asignado el fin de contrato, asumimos (al menos de momento) que el contrato está bien delimitado
        if "Fin contrato" <> 0D then
            exit;

        //... Debe haber una fecha de inicio. No se sabe como interpretarlo. Salimos también de la funciónl.
        if "Alta contrato" = 0D then
            exit;


        lrHistorial.Reset;
        lrHistorial.SetCurrentKey("No.", "No. Mov.");
        lrHistorial.SetRange("No.", "No.");
        lrHistorial.SetFilter("No. Mov.", '<%1', "No. Mov.");
        lrHistorial.SetRange(Aplicado, false);
        lrHistorial.SetRange("Fin contrato", 0D);
        if lrHistorial.FindFirst then
            repeat
                //... Si la fecha de inicio es cercana (en 20 días maximo) al contrato que estamos insertando,
                if ("Alta contrato" <> 0D) and (lrHistorial."Alta contrato" <> 0D) then begin
                    if Abs("Alta contrato" - lrHistorial."Alta contrato") > 5 then begin
                        lrHistorialAux := lrHistorial;
                        lrHistorialAux.Validate("Desactivacion forzada", lrHistorialAux."Desactivacion forzada"::Si);
                        //... Asignando el valor de TRUE al campo <Aplicado>, ya no se ejecutará en el proceso en cola de proyectos.
                        lrHistorialAux.Validate(Aplicado, true);
                        lrHistorialAux.Modify(true);
                    end;
                end;

            until lrHistorial.Next = 0;
    end;


    procedure ControlContratos(lrContratoRef: Record Contratos)
    var
        lrContratos: Record Contratos;
        lrContratosAux: Record Contratos;
        lrContratosBck: Record "Contratos Bck1";
    begin
        //+#269159
        //... Si para el nuevo contrato no está definida la fecha de finalización, investigaremos si hay alguna duplicidad:
        //...    No puede haber 2 contratos simultáneos vigentes sin fecha de finalización.
        //...
        //... Esta función irá modificándose en función de las anomalías detectadas.

        //... Si está asignado el fin de contrato, asumimos (al menos de momento) que el contrato está bien delimitado
        if lrContratoRef."Fecha finalización" <> 0D then
            exit;

        //... Debe haber una fecha de inicio. No se sabe como interpretarlo. Salimos también de la funciónl.
        if lrContratoRef."Fecha inicio" = 0D then
            exit;

        //... Quiero destacar  que si el contrato que se ha creado tiene un error detectado (variable IsOk), no se llegará a entrar en esta función.

        lrContratos.Reset;
        lrContratos.SetCurrentKey("No. empleado");
        lrContratos.SetRange("No. empleado", lrContratoRef."No. empleado");
        lrContratos.SetFilter("No. Orden", '<%1', lrContratoRef."No. Orden");
        lrContratos.SetRange("Fecha finalización", 0D);
        if lrContratos.FindFirst then
            repeat
                //... Si la fecha de inicio es cercana (en 5 días maximo) al contrato que estamos insertando, asumiremos que se trata de una duplicidad
                if (lrContratoRef."Fecha inicio" <> 0D) and (lrContratos."Fecha inicio" <> 0D) then begin
                    if Abs(lrContratoRef."Fecha inicio" - lrContratos."Fecha inicio") < 5 then begin
                        lrContratosBck.Init;
                        lrContratosBck.TransferFields(lrContratos);
                        lrContratosBck."Fecha eliminación" := Today;
                        lrContratosBck."Usuario eliminación" := CopyStr(UserId, 1, MaxStrLen(lrContratosBck."Usuario eliminación"));
                        if lrContratosBck.Insert then begin
                            lrContratosAux := lrContratos;
                            lrContratosAux.Delete;
                        end;
                    end;
                end;

            until lrContratos.Next = 0;
    end;
}

