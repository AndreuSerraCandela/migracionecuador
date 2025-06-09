table 76071 "Historico Lin. nomina"
{
    DrillDownPageID = "Lista Lin.nominas";
    LookupPageID = "Lista Lin.nominas";

    fields
    {
        field(1; "No. Documento"; Code[20])
        {
        }
        field(2; "No. empleado"; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; "Tipo Nómina"; Option)
        {
            Description = 'Normal,Regalía,Bonificación';
            OptionCaption = 'Regular,Christmas,Bonus,Tip,Rent';
            OptionMembers = Normal,"Regalía","Bonificación",Propina,Renta;
        }
        field(4; "Período"; Date)
        {
        }
        field(5; "No. Orden"; Integer)
        {
        }
        field(6; Ano; Integer)
        {
            Caption = 'Year';
        }
        field(7; Nombre; Text[80])
        {
            CalcFormula = Lookup("Historico Cab. nomina"."Full name" WHERE("No. Documento" = FIELD("No. Documento"),
                                                                            "No. empleado" = FIELD("No. empleado")));
            FieldClass = FlowField;
        }
        field(8; "Empresa cotización"; Code[10])
        {
            TableRelation = "Empresas Cotizacion";
        }
        field(9; "Concepto salarial"; Code[20])
        {
            TableRelation = "Conceptos salariales".Codigo;

            trigger OnValidate()
            var
                ConceptosSal: Record "Conceptos salariales";
            begin
                ConceptosSal.SetRange(Codigo, "Concepto salarial");
                if ConceptosSal.FindFirst then
                    Descripción := ConceptosSal.Descripcion;
            end;
        }
        field(10; "Descripción"; Text[50])
        {
        }
        field(11; Cantidad; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(12; "Importe Base"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
        }
        field(13; Total; Decimal)
        {
            AutoFormatExpression = "Currency Code";
        }
        field(14; "% Cotizable"; Decimal)
        {
        }
        field(15; "Tipo concepto"; Option)
        {
            Description = 'Ingresos,Deducciones';
            OptionMembers = Ingresos,Deducciones;
        }
        field(16; "Salario Base"; Boolean)
        {
        }
        field(17; "Parcial divisa-adicional"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(18; "Sujeto Cotización"; Boolean)
        {
            InitValue = true;
        }
        field(19; "Cotiza ISR"; Boolean)
        {
            CaptionClass = '4,3,1';
            InitValue = false;
        }
        field(20; "Cotiza SFS"; Boolean)
        {
            CaptionClass = '4,5,1';
            InitValue = false;
        }
        field(21; "Cotiza AFP"; Boolean)
        {
            CaptionClass = '4,4,1';
        }
        field(22; "Fórmula"; Text[80])
        {

            trigger OnValidate()
            begin
                Fórmula := UpperCase(Fórmula);

                if Fórmula <> '' then begin
                    Regconceptos.Formula := DelChr(Rec.Fórmula, '=', ' ');
                    RegFormula.SetRange(Formula, Regconceptos.Formula);
                    if RegFormula.Count = 0 then begin
                        Regconceptos.Formula := Rec.Fórmula;
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
                                RegLinPerSal.SetRange("Concepto salarial", Regpolaca.Token);
                                RegLinPerSal.SetRange("No. empleado", "No. empleado");
                                RegLinPerSal.SetRange(Período, Período);
                                if RegLinPerSal.FindFirst then begin
                                    Regconceptos.Concepto := Regpolaca.Token;
                                    Regconceptos.Valor := RegLinPerSal.Total;
                                    if not Regconceptos.Insert then
                                        Regconceptos.Modify;
                                end;
                            end;
                        until Regpolaca.Next = 0;

                    Calculadora.Run;
                    Regconceptos.Get('resultado');
                    Total := Regconceptos.Valor;
                end;
            end;
        }
        field(23; Imprimir; Boolean)
        {
        }
        field(24; "Inicio período"; Date)
        {
        }
        field(25; "Fin período"; Date)
        {
        }
        field(26; "Texto Informativo"; Boolean)
        {
        }
        field(27; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(28; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(30; "% Pago Empleado"; Decimal)
        {
        }
        field(31; "Cotiza SRL"; Boolean)
        {
            CaptionClass = '4,7,1';
            Caption = 'Cotiza SRL';
        }
        field(32; "Cotiza Infotep"; Boolean)
        {
            CaptionClass = '4,6,1';
        }
        field(33; Departamento; Code[20])
        {
            CaptionClass = '4,1,1';
            Caption = 'Department';
            TableRelation = Departamentos;
        }
        field(34; "Sub-Departamento"; Code[20])
        {
            CaptionClass = '4,2,1';
            Caption = 'Sub-Department';
            TableRelation = "Sub-Departamentos".Codigo WHERE("Cod. Departamento" = FIELD(Departamento));
        }
        field(35; "Aplica para Regalia"; Boolean)
        {
            Caption = 'Apply for EOY Salary';
        }
        field(39; "Cotiza FICA"; Boolean)
        {
            CaptionClass = '4,8,1';
        }
        field(40; "ISR compensado"; Decimal)
        {
        }
        field(43; "Aporte Voluntario"; Decimal)
        {
        }
        field(44; "Excluir de listados"; Boolean)
        {
        }
        field(45; Comentario; Text[100])
        {
            Caption = 'Comment';
        }
        field(46; "Tipo de nomina"; Code[20])
        {
            Caption = 'Payroll type';
            DataClassification = ToBeClassified;
            TableRelation = "Tipos de nominas";
        }
        field(50; "Job No."; Code[20])
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
        field(155; "Frecuencia de pago"; Option)
        {
            Caption = 'Payment frequency';
            DataClassification = ToBeClassified;
            OptionCaption = 'Daily,Weekly,Bi-Weekly,Half Month,Monthly,Yearly';
            OptionMembers = Diaria,Semanal,"Bi-Semanal",Quincenal,Mensual,Anual;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
    }

    keys
    {
        key(Key1; "No. empleado", "Tipo de nomina", "Período", "No. Orden")
        {
            Clustered = true;
            SumIndexFields = "Importe Base", Total, "Parcial divisa-adicional";
        }
        key(Key2; "No. empleado", "Período", "Tipo Nómina", "Cotiza ISR", "Texto Informativo")
        {
            SumIndexFields = "Importe Base", Total, "Parcial divisa-adicional";
        }
        key(Key3; "No. empleado", "Tipo concepto", "Período", "Concepto salarial")
        {
            SumIndexFields = Total, "Parcial divisa-adicional";
        }
        key(Key4; "No. empleado", "Período", "Salario Base", "No. Documento")
        {
            SumIndexFields = "Importe Base", Total, "Parcial divisa-adicional";
        }
        key(Key5; "No. Documento", "No. empleado", "Período", Cantidad)
        {
            SumIndexFields = "Importe Base", Total, "Parcial divisa-adicional";
        }
        key(Key6; "No. empleado", "Tipo concepto", "Período", "Texto Informativo", Total)
        {
            SumIndexFields = "Importe Base", Total, "Parcial divisa-adicional";
        }
        key(Key7; "Concepto salarial", "Período")
        {
        }
        key(Key8; Departamento, "Sub-Departamento", "No. empleado", "Período")
        {
        }
        key(Key9; "No. empleado", "Tipo Nómina", "Período", "Tipo concepto", "Concepto salarial")
        {
        }
        key(Key10; "Período", Departamento, "Sub-Departamento", "Concepto salarial")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        RecalculaAportePatronal;
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        RegFormula: Record Polaca;
        Regconceptos: Record "Conceptos formula";
        Regpolaca: Record Polaca;
        RegLinPerSal: Record "Historico Lin. nomina";
        DimMgt: Codeunit DimensionManagement;
        Scanner: Codeunit Scanner;
        Parser: Codeunit Parser;
        Calculadora: Codeunit Calculadora;


    procedure ShowDimensions()
    begin
        TestField("No. Orden");
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "No. Documento", "No. Orden"));
    end;

    local procedure RecalculaAportePatronal()
    var
        LinAporteEmp: Record "Lin. Aportes Empresas";
        BaseCalculo: Decimal;
    begin
        LinAporteEmp.Reset;
        LinAporteEmp.SetRange("No. Empleado");
        LinAporteEmp.SetRange("Tipo de nomina", "Tipo de nomina");
        LinAporteEmp.SetRange("Concepto Salarial", "Concepto salarial");
        if LinAporteEmp.FindFirst then begin
            BaseCalculo := Round("Importe Base" * LinAporteEmp."% Cotizable" / 100, 0.01);
            LinAporteEmp.Importe := BaseCalculo;
            LinAporteEmp.Modify;
        end;
    end;
}

