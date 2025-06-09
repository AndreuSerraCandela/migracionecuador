table 76061 "Perfil Salarial"
{
    Caption = 'Wage Profile';

    fields
    {
        field(1; "Empresa cotizacion"; Code[10])
        {
            Caption = 'Company';
        }
        field(2; "No. empleado"; Code[15])
        {
            Caption = 'Employee no.';
            TableRelation = Employee;
        }
        field(3; "Perfil salarial"; Code[10])
        {
            Caption = 'Wage profile';
            Editable = false;
        }
        field(4; "No. Linea"; Integer)
        {
            Caption = 'Line no.';
        }
        field(5; Cargo; Code[10])
        {
            Caption = 'Job type code';
            TableRelation = "Puestos laborales";
        }
        field(6; "Concepto salarial"; Code[20])
        {
            Caption = 'Wage Code';
            NotBlank = true;
            TableRelation = "Conceptos salariales".Codigo;

            trigger OnValidate()
            begin
                ConcepSalar.Get("Concepto salarial");

                //Empleado.GET("No. empleado");
                //"Empresa cotización"  := Empleado.Company;
                Descripcion := ConcepSalar.Descripcion;
                "Tipo concepto" := ConcepSalar."Tipo concepto";
                "Cotiza ISR" := ConcepSalar."Cotiza ISR";
                Provisionar := ConcepSalar.Provisionar;
                "Salario Base" := ConcepSalar."Salario Base";
                "Cotiza AFP" := ConcepSalar."Cotiza ISR";
                "Cotiza SFS" := ConcepSalar."Cotiza SFS";
                "Cotiza INFOTEP" := ConcepSalar."Cotiza INFOTEP";
                "Cotiza SRL" := ConcepSalar."Cotiza SRL";
                "Excluir de listados" := ConcepSalar."Excluir de listados";
                "Sujeto Cotizacion" := ConcepSalar."Sujeto Cotizacion";
                "Aplica para Regalia" := ConcepSalar."Aplica para Regalia";
                "Tipo de nomina" := ConcepSalar."Tipo de nomina";
                if ConcepSalar."Formula calculo" <> '' then
                    Validate("Formula calculo", ConcepSalar."Formula calculo")
                else
                    Validate("Formula calculo", '');
            end;
        }
        field(7; Descripcion; Text[50])
        {
            Caption = 'Description';
        }
        field(8; Cantidad; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                ConfNominas.Get();
                if ConfNominas."Impuestos manuales" then
                    exit;

                if Cantidad <> 0 then begin
                    TiposCot.SetRange(Ano, Date2DMY(WorkDate, 3));
                    TiposCot.SetRange(Código, "Concepto salarial");
                    if TiposCot.FindFirst then
                        Error(Err002, FieldCaption(Cantidad));
                end;
            end;
        }
        field(9; Importe; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 6;

            trigger OnValidate()
            var
                NovAuto: Record "Tipos de acciones personal";
                AcumuladoSalarios: Record "Acumulado Salarios";
                Selection: Integer;
                Text000: Label '&Correction,C&hange';
            begin
                Empleado.Get("No. empleado");

                if Importe <> xRec.Importe then begin
                    if not Insert then
                        Modify;
                    MiraSiFormula;
                end;

                TiposCot.SetRange(Ano, Date2DMY(WorkDate, 3));
                TiposCot.SetRange(Código, "Concepto salarial");
                if TiposCot.FindFirst then
                    Error(Err002, FieldCaption(Importe));

                /*
                IF ("Salario Base") AND (Importe <> 0) AND (xRec.Importe <>0) THEN
                   BEGIN
                //nav2009    Selection := STRMENU(Text000,1,Text002);
                    Selection := STRMENU(Text000,1);
                    //message('%1',selection);
                    CASE Selection OF
                     0:
                      ERROR('');
                     1:
                      EXIT ;
                    END;
                
                    NovAuto.INIT;
                    NovAuto."Cod. Empleado"      := "No. empleado";
                    NovAuto."Empresa cotización" := "Empresa cotización";
                    NovAuto.Periodo              := FORMAT(TODAY,0,'<Month,2>') + FORMAT(TODAY,0,'<Year4>');
                    NovAuto."Tipo Novedad"       := 6; //Cambio de datos
                    NovAuto."Fecha Inicio"       := TODAY;
                    NovAuto."Fecha Fin"          := TODAY;
                    NovAuto."Salario SS"         := Importe;
                    NovAuto."Salario ISR"        := Importe;
                    IF NOT NovAuto.INSERT THEN
                       NovAuto.MODIFY;
                
                    AcumuladoSalarios.RESET;
                    AcumuladoSalarios.SETRANGE("No. empleado","No. empleado");
                    IF NOT AcumuladoSalarios.FINDLAST THEN
                       BEGIN
                        AcumuladoSalarios."No. empleado"        := "No. empleado";
                        AcumuladoSalarios."Fecha Desde"         := Empleado."Employment Date";
                        AcumuladoSalarios."Fecha Hasta"         := CALCDATE('-1D', TODAY);
                        AcumuladoSalarios.Importe               := xRec.Importe;
                        IF NOT AcumuladoSalarios.INSERT THEN
                           AcumuladoSalarios.MODIFY;
                       END
                    ELSE
                       BEGIN
                        AcumuladoSalarios."No. empleado"        := "No. empleado";
                        AcumuladoSalarios."Fecha Desde"         := CALCDATE('+1D',AcumuladoSalarios."Fecha Hasta");
                        AcumuladoSalarios."Fecha Hasta"         := CALCDATE('-1D', TODAY);
                        AcumuladoSalarios.Importe               := xRec.Importe;
                        IF NOT AcumuladoSalarios.INSERT THEN
                           AcumuladoSalarios.MODIFY;
                       END;
                   END;
                */

            end;
        }
        field(10; "Tipo concepto"; Option)
        {
            Caption = 'Wage type';
            Description = 'Ingresos,Deducciones';
            OptionMembers = Ingresos,Deducciones;
        }
        field(11; "Sujeto Cotizacion"; Boolean)
        {
            Caption = 'SS salary';

            trigger OnValidate()
            begin
                if ("Tipo concepto" = 1) and ("Sujeto Cotizacion") then
                    Error(Err001);
            end;
        }
        field(12; "Cotiza ISR"; Boolean)
        {
            CaptionClass = '4,3,1';
            Caption = 'Apply for Income Tax';
            InitValue = false;

            trigger OnValidate()
            begin
                //IF ("Cotiza ISR") AND ("Tipo concepto" = 1 ) THEN
                //   ERROR(Err001);
            end;
        }
        field(13; "Texto Informativo"; Boolean)
        {
            Caption = 'Informative text';
        }
        field(14; Provisionar; Boolean)
        {
            Caption = 'Provision';
        }
        field(15; "Formula calculo"; Text[80])
        {
            Caption = 'Calculation formula';

            trigger OnLookup()
            begin
                FormConcSalariales.LookupMode(true);
                if FormConcSalariales.RunModal = ACTION::LookupOK then begin
                    FormConcSalariales.GetRecord(ConcepSalar);
                    "Formula calculo" := "Formula calculo" + ConcepSalar.Codigo;
                    Clear(FormConcSalariales);
                end;
            end;

            trigger OnValidate()
            begin
                "Formula calculo" := UpperCase("Formula calculo");

                if "Formula calculo" <> '' then begin
                    Regconceptos.Formula := DelChr(Rec."Formula calculo", '=', ' ');
                    RegFormula.SetRange(Formula, Regconceptos.Formula);
                    if RegFormula.Count = 0 then begin
                        Regconceptos.Formula := Rec."Formula calculo";
                        Scanner.Run(Regconceptos);
                        Parser.Run(Regconceptos);
                    end;

                    //    RegLinPerSal.SETCURRENTKEY("Perfil salarial","Concepto salarial","No. empleado");
                    Regconceptos.Concepto := 'resultado';
                    if not Regconceptos.Insert then
                        Regconceptos.Modify;

                    Regpolaca.SetRange(Formula, Regconceptos.Formula);
                    if Regpolaca.Find('-') then
                        repeat
                            if CopyStr(Regpolaca.Token, 1, 1) = '#' then begin
                                case Regpolaca.Token of
                                    '#1':
                                        begin
                                            ConfNominas.Get;
                                            Regconceptos.Concepto := Regpolaca.Token;
                                        end;
                                end;
                                if not Regconceptos.Insert then
                                    Regconceptos.Modify;
                            end
                            else begin
                                RegLinPerSal.Reset;
                                RegLinPerSal.SetCurrentKey("Perfil salarial", "Concepto salarial", "No. empleado");
                                RegLinPerSal.SetRange("Perfil salarial", Rec."Perfil salarial");
                                RegLinPerSal.SetRange("Concepto salarial", Regpolaca.Token);
                                RegLinPerSal.SetRange("No. empleado", Rec."No. empleado");
                                if RegLinPerSal.FindFirst then begin
                                    Regconceptos.Concepto := Regpolaca.Token;
                                    if RegLinPerSal.Cantidad <> 0 then
                                        Regconceptos.Valor := RegLinPerSal.Cantidad * RegLinPerSal.Importe
                                    else
                                        Regconceptos.Valor := RegLinPerSal.Importe;
                                    if not Regconceptos.Insert then
                                        Regconceptos.Modify;
                                end;
                            end;
                        until Regpolaca.Next = 0;

                    Calculadora.Run;
                    Regconceptos.Get('resultado');
                    Importe := Round(Regconceptos.Valor, 0.01);
                end;
            end;
        }
        field(16; "Periodo generac."; Code[8])
        {
            Caption = 'Calculation period';
        }
        field(17; Imprimir; Boolean)
        {
            Caption = 'Print';
        }
        field(18; "Inicio Periodo"; Date)
        {
            Caption = 'Print period';

            trigger OnValidate()
            begin
                if "Inicio Periodo" <> 0D then
                    "Fin Período" := CalcDate(Text001, "Inicio Periodo");
            end;
        }
        field(19; "Fin Período"; Date)
        {
            Caption = 'Period ending';
        }
        field(20; Mes; Integer)
        {
            Caption = 'Month';
        }
        field(21; "Mes Inicio"; Date)
        {
            Caption = 'Starting month';
        }
        field(22; "Mes Fin"; Date)
        {
            Caption = 'Ending month';
        }
        field(23; "Deducir dias"; Boolean)
        {
            Caption = 'Deduct days';
        }
        field(24; "1ra Quincena"; Boolean)
        {
            Caption = 'First half';
        }
        field(25; "2da Quincena"; Boolean)
        {
            Caption = '2nd half';
        }
        field(26; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Active,Inactive';
            OptionMembers = Activo,Baja;
        }
        field(27; "Tipo Nomina"; Option)
        {
            Caption = 'Payroll type';
            OptionCaption = 'Regular,Christmas,Bonus,Tip,Rent';
            OptionMembers = Normal,"Regalía","Bonificación",Propina,Renta;
        }
        field(28; "Cotiza AFP"; Boolean)
        {
            CaptionClass = '4,4,1';
            Caption = 'Apply for AFP';
        }
        field(29; "Cotiza SFS"; Boolean)
        {
            CaptionClass = '4,5,1';
            Caption = 'Apply for SFS';
        }
        field(30; "Salario Base"; Boolean)
        {
            Caption = 'Base salary';
            Editable = false;
        }
        field(31; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(32; "% ISR Pago Empleado"; Decimal)
        {
            Caption = '% Incometax paid by employee';
        }
        field(33; "Cotiza INFOTEP"; Boolean)
        {
            CaptionClass = '4,6,1';
            Caption = 'Apply for INFOTEP';
        }
        field(34; "% Retencion Ingreso Salario"; Decimal)
        {
            Caption = '% Retention Salary income';
        }
        field(35; "Importe Acumulado"; Decimal)
        {
            CalcFormula = Sum("Historico Lin. nomina".Total WHERE("No. empleado" = FIELD("No. empleado"),
                                                                   "Período" = FIELD("Filtro Fecha"),
                                                                   "Concepto salarial" = FIELD("Concepto salarial")));
            Caption = 'Accumulated Amount';
            FieldClass = FlowField;
        }
        field(36; "Filtro Fecha"; Date)
        {
            Caption = 'Date filter';
            FieldClass = FlowFilter;
        }
        field(37; "Cotiza SRL"; Boolean)
        {
            CaptionClass = '4,7,1';
            Caption = 'Apply for SRL';
        }
        field(38; "Aplica para Regalia"; Boolean)
        {
            Caption = 'Apply for Christmas Salary';
        }
        field(40; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            var
                Job: Record Job;
                Cust: Record Customer;
            begin
            end;
        }
        field(42; "Cotiza FICA"; Boolean)
        {
            CaptionClass = '4,8,1';
            Caption = 'Apply for FICA';
        }
        field(46; "Excluir de listados"; Boolean)
        {
            Caption = 'Exclude from reports';
            Description = 'Bolivia';
        }
        field(47; "Tipo de nomina"; Code[20])
        {
            Caption = 'Payroll type';
            DataClassification = ToBeClassified;
            TableRelation = "Tipos de nominas";
        }
        field(48; Comentario; Text[100])
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No. empleado", "Perfil salarial", "Concepto salarial")
        {
            Clustered = true;
        }
        key(Key2; "Perfil salarial", "No. empleado")
        {
        }
        key(Key3; "Perfil salarial", "Sujeto Cotizacion", "No. empleado")
        {
        }
        key(Key4; "No. empleado", "Sujeto Cotizacion")
        {
        }
        key(Key5; "Sujeto Cotizacion", "Salario Base")
        {
        }
        key(Key6; "Perfil salarial", "Concepto salarial", "No. empleado")
        {
        }
        key(Key7; "No. empleado", "Concepto salarial")
        {
        }
        key(Key8; "Concepto salarial")
        {
        }
        key(KeyReports; Cargo)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", "No. empleado");
        HistLinNom.SetRange("Concepto salarial", "Concepto salarial");
        if HistLinNom.FindFirst then
            Error(StrSubstNo(Err004, "Concepto salarial"));
    end;

    trigger OnInsert()
    begin
        Empleado.Get("No. empleado");
        Cargo := Empleado."Job Type Code";
        "Empresa cotizacion" := Empleado.Company;

        RegLinPerSal.Reset;
        RegLinPerSal.SetRange("No. empleado", "No. empleado");
        RegLinPerSal.SetRange("Concepto salarial", "Concepto salarial");
        if RegLinPerSal.FindFirst then
            Error(Err003, "Concepto salarial");
    end;

    trigger OnModify()
    begin
        MiraSiFormula;
    end;

    var
        RegFormula: Record Polaca;
        Regconceptos: Record "Conceptos formula";
        Regpolaca: Record Polaca;
        "Indemnización": Record Employee;
        HistLinNom: Record "Historico Lin. nomina";
        RegLinPerSal: Record "Perfil Salarial";
        ConcepSalar: Record "Conceptos salariales";
        Empleado: Record Employee;
        Percept: Record Employee;
        TiposCot: Record "Tipos de Cotización";
        FormConcSalariales: Page "Conceptos salariales";
        Scanner: Codeunit Scanner;
        Parser: Codeunit Parser;
        Calculadora: Codeunit Calculadora;
        ConfNominas: Record "Configuracion nominas";
        ok: Boolean;
        Text001: Label 'CM';
        Text002: Label 'Yo had change the amount for the Base Salary, is this a Salary change or correction?';
        Err001: Label 'This field only applies to Incomes';
        Err002: Label '%1 must be cero, this is a System concept';
        Err003: Label '%1 is already assigned to this employee';
        Err004: Label '%1 can not be deleted because is in use';


    procedure "CálculoCantidad"(LinEsq: Record "Perfil Salarial") "Factor cantidad": Decimal
    var
        "Horas semanales": Decimal;
        RegUdadCotiz: Record "Empresas Cotizacion";
        RegPerceptores: Record Employee;
        RegContratos: Record Contratos;
    begin
        /*"Horas semanales" := 0;
        RegContratos.SETRANGE("No. empleado","No. empleado");
        IF RegContratos.FIND('+') THEN BEGIN
          IF RegContratos."Horas semana" <> 0 THEN
             "Horas semanales" := RegContratos."Horas semana"
          ELSE
            "Horas semanales" := RegContratos."Horas dia" * 5;
        END;
        */

    end;


    procedure MiraSiFormula()
    var
        LinEsqPerFormula: Record "Perfil Salarial";
    begin
        LinEsqPerFormula.SetRange("No. empleado", "No. empleado");
        LinEsqPerFormula.SetRange("Perfil salarial", "Perfil salarial");
        LinEsqPerFormula.SetFilter("Formula calculo", '<>%1', '');
        LinEsqPerFormula.SetFilter("Concepto salarial", '<>%1', "Concepto salarial");
        if LinEsqPerFormula.Find('-') then
            repeat
                LinEsqPerFormula.Validate("Formula calculo");
                LinEsqPerFormula.Importe := Round(LinEsqPerFormula.Importe, 0.01);
                LinEsqPerFormula.Modify;
            until LinEsqPerFormula.Next = 0;
    end;
}

