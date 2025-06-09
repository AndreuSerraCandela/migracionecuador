table 76298 "Perfil Salarial2013"
{
    Caption = 'Wage Profile';

    fields
    {
        field(1; "Empresa cotización"; Code[10])
        {
        }
        field(2; "No. empleado"; Code[15])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(3; "Perfil salarial"; Code[10])
        {
            Editable = false;
        }
        field(4; "No. Linea"; Integer)
        {
        }
        field(5; Cargo; Code[10])
        {
            TableRelation = "Puestos laborales";
        }
        field(6; "Concepto salarial"; Code[20])
        {
            Caption = 'Wage Code';
            TableRelation = "Conceptos salariales".Codigo;

            trigger OnValidate()
            begin
                ConcepSalar.SetRange(Codigo, "Concepto salarial");
                ConcepSalar.FindFirst;

                Empleado.Get("No. empleado");
                "Empresa cotización" := Empleado.Company;
                Descripción := ConcepSalar.Descripcion;
                "Tipo concepto" := ConcepSalar."Tipo concepto";
                "Cotiza ISR" := ConcepSalar."Cotiza ISR";
                Prorratear := ConcepSalar.Provisionar;
                "Salario Base" := ConcepSalar."Salario Base";
                "Cotiza AFP" := ConcepSalar."Cotiza ISR";
                "Cotiza SFS" := ConcepSalar."Cotiza SFS";
                "Cotiza INFOTEP" := ConcepSalar."Cotiza INFOTEP";
                "Cotiza SRL" := ConcepSalar."Cotiza SRL";
                "Excluir de listados" := ConcepSalar."Excluir de listados";
            end;
        }
        field(7; "Descripción"; Text[50])
        {
        }
        field(8; Cantidad; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                TiposCot.SetRange(Ano, Date2DMY(WorkDate, 3));
                TiposCot.SetRange(Código, "Concepto salarial");
                if TiposCot.FindFirst then
                    Error(Err002, FieldCaption(Cantidad));
            end;
        }
        field(9; Importe; Decimal)
        {
            DecimalPlaces = 2 : 2;

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
                    NovAuto."Codigo"      := "No. empleado";
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
            Description = 'Ingresos,Deducciones';
            OptionMembers = Ingresos,Deducciones;
        }
        field(11; "Sujeto Cotización"; Boolean)
        {

            trigger OnValidate()
            begin
                if ("Tipo concepto" = 1) and ("Sujeto Cotización") then
                    Error(Err001);
            end;
        }
        field(12; "Cotiza ISR"; Boolean)
        {
            CaptionClass = '4,3,1';
            InitValue = false;

            trigger OnValidate()
            begin
                //IF ("Cotiza ISR") AND ("Tipo concepto" = 1 ) THEN
                //   ERROR(Err001);
            end;
        }
        field(13; "Texto Informativo"; Boolean)
        {
        }
        field(14; Prorratear; Boolean)
        {
        }
        field(15; "Fórmula cálculo"; Text[80])
        {

            trigger OnLookup()
            begin
                FormConcSalariales.LookupMode(true);
                if FormConcSalariales.RunModal = ACTION::LookupOK then begin
                    FormConcSalariales.GetRecord(ConcepSalar);
                    "Fórmula cálculo" := "Fórmula cálculo" + ConcepSalar.Codigo;
                    Clear(FormConcSalariales);
                end;
            end;

            trigger OnValidate()
            begin
                "Fórmula cálculo" := UpperCase("Fórmula cálculo");

                if "Fórmula cálculo" <> '' then begin
                    Regconceptos.Formula := DelChr(Rec."Fórmula cálculo", '=', ' ');
                    RegFormula.SetRange(Formula, Regconceptos.Formula);
                    if RegFormula.Count = 0 then begin
                        Regconceptos.Formula := Rec."Fórmula cálculo";
                        Scanner.Run(Regconceptos);
                        Parser.Run(Regconceptos);
                    end;

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
                    Importe := Regconceptos.Valor;
                end;
            end;
        }
        field(16; "Período generac."; Code[8])
        {
        }
        field(17; Imprimir; Boolean)
        {
        }
        field(18; "Inicio Período"; Date)
        {

            trigger OnValidate()
            begin
                if "Inicio Período" <> 0D then
                    "Fin Período" := CalcDate(Text001, "Inicio Período");
            end;
        }
        field(19; "Fin Período"; Date)
        {
        }
        field(20; Mes; Integer)
        {
        }
        field(21; "Mes Inicio"; Date)
        {
        }
        field(22; "Mes Fin"; Date)
        {
        }
        field(23; "Deducir dias"; Boolean)
        {
        }
        field(24; "1ra Quincena"; Boolean)
        {
        }
        field(25; "2da Quincena"; Boolean)
        {
        }
        field(26; Status; Option)
        {
            OptionMembers = Activo,Baja;
        }
        field(27; "Tipo Nómina"; Option)
        {
            OptionMembers = Normal,"Regalía","Bonificación";
        }
        field(28; "Cotiza AFP"; Boolean)
        {
            CaptionClass = '4,4,1';
        }
        field(29; "Cotiza SFS"; Boolean)
        {
            CaptionClass = '4,5,1';
        }
        field(30; "Salario Base"; Boolean)
        {
            Editable = false;
        }
        field(31; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(32; "% ISR Pago Empleado"; Decimal)
        {
        }
        field(33; "Cotiza INFOTEP"; Boolean)
        {
            CaptionClass = '4,6,1';
        }
        field(34; "% Retencion Ingreso Salario"; Decimal)
        {
        }
        field(35; "Importe Acumulado"; Decimal)
        {
            CalcFormula = Sum("Historico Lin. nomina".Total WHERE("No. empleado" = FIELD("No. empleado"),
                                                                   "Período" = FIELD("Filtro Fecha"),
                                                                   "Concepto salarial" = FIELD("Concepto salarial")));
            FieldClass = FlowField;
        }
        field(36; "Filtro Fecha"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(37; "Cotiza SRL"; Boolean)
        {
            CaptionClass = '4,7,1';
        }
        field(38; "Aplica para Regalia"; Boolean)
        {
            Caption = 'Apply for EOY Salary';
        }
        field(39; "Cotiza SUTA"; Boolean)
        {
        }
        field(40; "Cotiza FUTA"; Boolean)
        {
        }
        field(41; "Cotiza MEDICARE"; Boolean)
        {
        }
        field(42; "Cotiza FICA"; Boolean)
        {
        }
        field(43; "Cotiza SINOT"; Boolean)
        {
        }
        field(44; "Cotiza CHOFERIL"; Boolean)
        {
        }
        field(45; "Cotiza INCOMETAX"; Boolean)
        {
        }
        field(46; "Excluir de listados"; Boolean)
        {
            Description = 'Bolivia';
        }
    }

    keys
    {
        key(Key1; "No. empleado", "Perfil salarial", "Concepto salarial", Cargo)
        {
            Clustered = true;
        }
        key(Key2; "Perfil salarial", "No. empleado")
        {
        }
        key(Key3; "Perfil salarial", "Sujeto Cotización", "No. empleado")
        {
        }
        key(Key4; "No. empleado", "Sujeto Cotización")
        {
        }
        key(Key5; "Sujeto Cotización", "Salario Base")
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
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Empleado.Get("No. empleado");
        Cargo := Empleado."Job Type Code";
        "Empresa cotización" := Empleado.Company;

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

