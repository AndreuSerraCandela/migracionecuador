table 76049 "Configuracion nominas"
{

    fields
    {
        field(1; Codigo; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "No. serie nominas"; Code[10])
        {
            Caption = 'Payroll serial no.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3; "No. serie CxC"; Code[10])
        {
            Caption = 'Payroll AR serial no.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(4; "No. serie reg. CxC"; Code[10])
        {
            Caption = 'Posted payroll AR serial no.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(6; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = ToBeClassified;
        }
        field(7; "Dimension Conceptos Salariales"; Code[20])
        {
            Caption = 'Payroll Dimension for concepts';
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
        }
        field(9; "Incidencias Ausencia Propinas"; Code[10])
        {
            Caption = 'Tipping absences code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }
        field(10; "Incidencias Dto. Nomina"; Code[10])
        {
            Caption = 'Absence cause code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }
        field(11; "Concepto Incentivos"; Code[20])
        {
            Caption = 'Incentive concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(12; "Impuestos manuales"; Boolean)
        {
            Caption = 'Manual taxes';
            DataClassification = ToBeClassified;
        }
        field(13; "Concepto CxC Empl."; Code[20])
        {
            Caption = 'Employee AR concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(14; "Concepto Dto. pago exceso"; Code[20])
        {
            Caption = 'Exceeded Payment Discount Wage';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(15; "Concepto Sal. Base"; Code[20])
        {
            Caption = 'Concepto Sal. fijo';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(16; "Concepto ISR"; Code[20])
        {
            CaptionClass = '4,3,1';
            Caption = 'Incometax concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(17; "Concepto Retroactivo"; Code[20])
        {
            Caption = 'Concepto Retroactivo';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(18; "Concepto Inasistencia"; Code[20])
        {
            Caption = 'Abscense concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(19; "Concepto AFP"; Code[20])
        {
            CaptionClass = '4,4,1';
            Caption = 'Pension fund concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(20; "Concepto SFS"; Code[20])
        {
            CaptionClass = '4,5,1';
            Caption = 'Family health insurance concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(21; "Concepto Regalia"; Code[20])
        {
            Caption = 'Christmas salary';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(22; "Concepto Bonificacion"; Code[20])
        {
            Caption = 'Bonus concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(23; "Concepto Vacaciones"; Code[20])
        {
            Caption = 'Vacation concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(24; "Concepto Horas Ext. 100%"; Code[20])
        {
            Caption = '100% overtime concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(25; "Concepto Horas Ext. 35%"; Code[20])
        {
            Caption = '35% overtime concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(26; "Concepto Sal. hora"; Code[20])
        {
            Caption = 'Concepto Sal. por hora';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(27; "Concepto SRL"; Code[20])
        {
            CaptionClass = '4,7,1';
            Caption = 'Occupational risk insurance concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(28; "Concepto INFOTEP"; Code[20])
        {
            CaptionClass = '4,6,1';
            Caption = ' INFOTEP concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(29; "Concepto Dias feriados"; Code[20])
        {
            Caption = 'Holiday concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(30; "Concepto Horas nocturnas"; Code[20])
        {
            Caption = 'Night hours concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(31; "Job Journal Template Name"; Code[10])
        {
            Caption = 'Job Journal Template Name';
            DataClassification = ToBeClassified;
            Description = 'Proyectos';
            TableRelation = "Gen. Journal Template";
        }
        field(32; "Job Journal Batch Name"; Code[10])
        {
            Caption = 'Job Journal Batch Name';
            DataClassification = ToBeClassified;
            Description = 'Proyectos';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Job Journal Template Name"));
        }
        field(33; "Concepto Dieta"; Code[20])
        {
            Caption = 'Diet income';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(34; "Concepto Transporte"; Code[20])
        {
            Caption = 'Transportation code';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(35; "Salario Minimo"; Decimal)
        {
            Caption = 'Lowest Salary';
            DataClassification = ToBeClassified;
        }
        field(36; "Secuencia de archivo Batch"; Code[10])
        {
            Caption = 'Batch file sequence';
            DataClassification = ToBeClassified;
        }
        field(37; "No. Proyecto Generico"; Code[20])
        {
            Caption = 'Generic Job code';
            DataClassification = ToBeClassified;
            Description = 'Proyectos';
            TableRelation = Job;
        }
        field(38; "Concepto Preaviso"; Code[20])
        {
            Caption = 'Notice concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(39; "Concepto Cesantia"; Code[20])
        {
            Caption = 'Unemployment concept';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(40; "Fecha secuencia"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //IF ("Fecha secuencia" > 31) OR ("Fecha secuencia" < 27) THEN
                //   ERROR('Día inválido, favor verificar');
            end;
        }
        field(41; "Método cálculo ausencias"; Code[10])
        {
            Caption = 'Absences calculation method';
            DataClassification = ToBeClassified;
            TableRelation = "Parametros Calculo Dias";
        }
        field(42; "Registro de provision"; Option)
        {
            Caption = 'Apportionment record';
            DataClassification = ToBeClassified;
            OptionCaption = 'Monthly,Half month,Bi weekly,Wekly,Daily';
            OptionMembers = Mensual,Quincenal,"Bi-Semanal",Semanal,Diaria;
        }
        field(43; "Concepto devolucion ISR"; Code[20])
        {
            Caption = 'Concepto devolución ISR';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(44; "Tasa Cambio Calculo Divisa"; Decimal)
        {
            Caption = 'Exchange Rate Calculation Currency';
            DataClassification = ToBeClassified;
        }
        field(45; "Metodo calculo Ingresos"; Code[10])
        {
            Caption = 'Income calculation method';
            DataClassification = ToBeClassified;
            TableRelation = "Parametros Calculo Dias";
        }
        field(46; "Metodo calculo Salidas"; Code[10])
        {
            Caption = 'Exits calculation method';
            DataClassification = ToBeClassified;
            TableRelation = "Parametros Calculo Dias";
        }
        field(47; "Cód. Cta. Nominas Pago Transf."; Code[20])
        {
            Caption = 'Account for transfer payments';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Tipo cuenta" = CONST(Cuenta)) "G/L Account"
            ELSE
            IF ("Tipo cuenta" = CONST(Banco)) "Bank Account";
        }
        field(48; "Cta. Nominas Otros Pagos"; Code[20])
        {
            Caption = 'G/L account for other payments';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Tipo Cta. Otros Pagos" = CONST(Cuenta)) "G/L Account"."No."
            ELSE
            IF ("Tipo Cta. Otros Pagos" = CONST(Banco)) "Bank Account"."No."
            ELSE
            IF ("Tipo Cta. Otros Pagos" = CONST(Proveedor)) Vendor."No.";
        }
        field(49; "Web Page TSS"; Text[150])
        {
            Caption = 'Web Page TSS';
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(50; "Web Page DGII"; Text[150])
        {
            Caption = 'Web Page DGII';
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(51; "Path Archivos Electronicos"; Text[250])
        {
            Caption = 'Path electronic files';
            DataClassification = ToBeClassified;
        }
        field(52; "Importe Anual IHSS Base ISR"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Honduras';
        }
        field(53; "% dif. Ingresos y descuentos"; Decimal)
        {
            Caption = '% Difference allowed between Revenue and Discounts';
            DataClassification = ToBeClassified;
        }
        field(54; "Tipo cuenta"; Option)
        {
            Caption = 'G/L Account type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/l Account/Bank account';
            OptionMembers = Cuenta,Banco;
        }
        field(55; "Vacaciones colectivas"; Boolean)
        {
            Caption = 'Collective vacations';
            DataClassification = ToBeClassified;
        }
        field(56; "Texto email recibos"; Text[250])
        {
            Caption = 'Receipts email text';
            DataClassification = ToBeClassified;
        }
        field(57; "Tiempo espera Envio email"; Integer)
        {
            Caption = 'Waiting time to send email';
            DataClassification = ToBeClassified;
        }
        field(58; "Journal Template Name CK"; Code[20])
        {
            Caption = 'Check''s Journal Template Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(59; "Journal Batch Name CK"; Code[20])
        {
            Caption = 'Check''s Journal Batch Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name CK"));
        }
        field(60; "Tipo Cta. Otros Pagos"; Option)
        {
            Caption = 'Other payment account type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Bank Account,Vendor';
            OptionMembers = Cuenta,Banco,Proveedor;
        }
        field(61; "Codeunit calculo nomina"; Integer)
        {
            Caption = 'Payroll calculation codeunit';
            DataClassification = ToBeClassified;
            /*           TableRelation = Object.ID WHERE (Type = CONST (Codeunit)); */
        }
        field(62; "Nomina de Pais"; Code[10])
        {
            Caption = 'Country of Payroll';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(63; "No. serie Sol. Prest. Coop."; Code[20])
        {
            Caption = 'Cooperative Loan Appl. Serial No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(64; "No. serie Hist. Prest. Coop."; Code[20])
        {
            Caption = 'Posted Coop. Loans serie';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(65; "Concepto Cuota cooperativa"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(66; "Mod. cooperativa activo"; Boolean)
        {
            Caption = 'Cooperative module active';
            DataClassification = ToBeClassified;
        }
        field(67; "Codeunit Archivos Electronicos"; Integer)
        {
            Caption = 'Codeunit Electronic files';
            DataClassification = ToBeClassified;
            /*     TableRelation = Object.ID WHERE (Type = CONST (Codeunit)); */
        }
        field(68; "Dimension Empleado"; Code[20])
        {
            Caption = 'Employee Dimension';
            DataClassification = ToBeClassified;
            Description = 'OJO, verificar su uso en algun pais';
            TableRelation = Dimension;
        }
        field(69; "Metodo Calculo SS"; Option)
        {
            Caption = 'Social Security Calc Method';
            DataClassification = ToBeClassified;
            OptionCaption = 'Period Income,Balanced';
            OptionMembers = "Ingresos del Período",Balanceado;
        }
        field(70; "Cta. Lin. Planif. Proyectos"; Code[20])
        {
            Caption = 'Project planning lines G/L account';
            DataClassification = ToBeClassified;
            Description = 'Proyectos';

            trigger OnLookup()
            begin
                JPL.Reset;
                JPL.SetRange(Type, JPL.Type::"G/L Account");
                if PAGE.RunModal(0, JPL) = ACTION::LookupOK then begin
                    Validate("Cta. Lin. Planif. Proyectos", JPL."No.");
                end;
            end;

            trigger OnValidate()
            begin
                if "Cta. Lin. Planif. Proyectos" <> '' then begin
                    JPL.Reset;
                    JPL.SetRange(Type, JPL.Type::"G/L Account");
                    JPL.SetRange("No.", "Cta. Lin. Planif. Proyectos");
                    JPL.FindFirst;
                end;
            end;
        }
        field(71; "ID Informe de nomina"; Integer)
        {
            Caption = 'Payroll report ID';
            DataClassification = ToBeClassified;
            /*      TableRelation = Object.ID WHERE (Type = CONST (Report)); */
        }
        field(72; "Proceso recalculo ISR automat."; Boolean)
        {
            Caption = 'Automatic ISR recalculation process';
            DataClassification = ToBeClassified;
        }
        field(80; "Importe gastos medicos"; Decimal)
        {
            Caption = 'Medical expenses amount';
            DataClassification = ToBeClassified;
            Description = 'Honduras';
        }
        field(81; "Calcular horas reg. asistencia"; Boolean)
        {
            Caption = 'Calculate hours attendance record';
            DataClassification = ToBeClassified;
        }
        field(82; "Divisa para Entrada de Diario"; Code[10])
        {
            Caption = 'General Journal Currency';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(83; "Usar Acciones de personal"; Boolean)
        {
            Caption = 'Use personnel actions';
            DataClassification = ToBeClassified;
        }
        field(84; "Dias para corte nominas"; DateFormula)
        {
            Caption = 'Days for cut calculations';
            DataClassification = ToBeClassified;
        }
        field(85; "Habilitar numeradores globales"; Boolean)
        {
            Caption = 'Activate global numbering';
            DataClassification = ToBeClassified;
        }
        field(86; "Días vacaciones adicionales"; Integer)
        {
            Caption = 'Additional vacation days';
            DataClassification = ToBeClassified;
        }
        field(87; "Multiempresa activo"; Boolean)
        {
            Caption = 'Multicompany enabled';
            DataClassification = ToBeClassified;
        }
        field(88; "XML importa datos ponchador"; Integer)
        {
            Caption = 'ID Xmlport to import time attendance';
            DataClassification = ToBeClassified;
            /*     TableRelation = Object.ID WHERE (Type = CONST (XMLport)); */
        }
        field(89; "Tiempo minimo prest. coop."; DateFormula)
        {
            Caption = 'Minimun time for Coop. Loans';
            DataClassification = ToBeClassified;
        }
        field(90; "Concepto Dependiente Adicional"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(91; "Caption Depto"; Text[30])
        {
            Caption = 'Caption Depto';
            DataClassification = ToBeClassified;
        }
        field(92; "Caption Sub Depto"; Text[30])
        {
            Caption = 'Caption Sub Depto';
            DataClassification = ToBeClassified;
        }
        field(93; "Caption ISR"; Text[30])
        {
            Caption = 'Caption ISR';
            DataClassification = ToBeClassified;
        }
        field(94; "Caption INFOTEP"; Text[30])
        {
            Caption = 'Caption INFOTEP';
            DataClassification = ToBeClassified;
        }
        field(95; "Caption AFP"; Text[30])
        {
            Caption = 'Caption AFP';
            DataClassification = ToBeClassified;
        }
        field(96; "Caption SFS"; Text[30])
        {
            Caption = 'Caption SFS';
            DataClassification = ToBeClassified;
        }
        field(97; "Caption SRL"; Text[30])
        {
            Caption = 'Caption SRL';
            DataClassification = ToBeClassified;
        }
        field(98; "CU Procesa datos ponchador"; Integer)
        {
            Caption = 'Time attendance Process CU';
            DataClassification = ToBeClassified;
            /*       TableRelation = Object.ID WHERE (Type = CONST (Codeunit)); */
        }
        field(99; "Completar horas ponchador"; Boolean)
        {
            Caption = 'Complete attendance hours';
            DataClassification = ToBeClassified;
        }
        field(100; "Horas de almuerzo"; Decimal)
        {
            Caption = 'Lunch hours';
            DataClassification = ToBeClassified;
        }
        field(101; "Adelantar salario vacaciones"; Boolean)
        {
            Caption = 'Advance vacation salary';
            DataClassification = ToBeClassified;
        }
        field(102; "Integracion ponche activa"; Boolean)
        {
            Caption = 'Time attendance integration active';
            DataClassification = ToBeClassified;
        }
        field(103; "Prioridad correos"; Option)
        {
            Caption = 'E-mail priority';
            DataClassification = ToBeClassified;
            OptionCaption = 'Personal email,Company email';
            OptionMembers = "Correo personal","Correo empresarial";
        }
        field(104; "Act. Excluido TSS automatico"; Boolean)
        {
            Caption = 'Update exclude from SS automatically';
            DataClassification = ToBeClassified;
        }
        field(109; "Concepto Decimo Tercero"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'EC';
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(110; "Concepto Decimo Cuarto"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'EC';
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(50000; "Concepto Reembolso gtos."; Code[20])
        {
            Caption = 'Concepto Reembolso gtos.';
            DataClassification = ToBeClassified;
            Description = 'NOVAL';
            TableRelation = "Conceptos salariales".Codigo;
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        JPL: Record "Job Planning Line";
}

