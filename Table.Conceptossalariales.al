table 76062 "Conceptos salariales"
{
    DrillDownPageID = "Conceptos salariales";
    LookupPageID = "Conceptos salariales";

    fields
    {
        field(1; "Dimension Nomina"; Code[20])
        {
            Caption = 'Payroll Dimension Code';
            TableRelation = Dimension.Code;
        }
        field(2; Codigo; Code[20])
        {
            Caption = 'Code';

            trigger OnLookup()
            var
                PageDefDim: Page "Dimension Value List";
            begin
                ConfNominas.Get();
                ConfNominas.TestField("Dimension Conceptos Salariales");
                DimValue.Reset;
                DimValue.SetRange("Dimension Code", ConfNominas."Dimension Conceptos Salariales");
                DimValue.FindSet;
                PageDefDim.SetTableView(DimValue);
                PageDefDim.LookupMode(true);
                PageDefDim.RunModal;
                PageDefDim.GetRecord(DimValue);
                Validate(Codigo, DimValue.Code);
                Clear(PageDefDim);
            end;

            trigger OnValidate()
            begin
                ConfNominas.Get();
                ConfNominas.TestField("Dimension Conceptos Salariales");
                "Dimension Nomina" := ConfNominas."Dimension Conceptos Salariales";

                DimValue.Get("Dimension Nomina", Codigo);
                Descripcion := DimValue.Name;
            end;
        }
        field(3; Descripcion; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Tipo concepto"; Option)
        {
            Caption = 'Wage type';
            Description = 'Ingresos,Deducciones';
            OptionCaption = 'Incomes,Deductions';
            OptionMembers = Ingresos,Deducciones;
        }
        field(5; "Salario Base"; Boolean)
        {
            Caption = 'Base salary';

            trigger OnValidate()
            begin
                ValidaPerfiles(11);
                ValidaHistorico(11);
            end;
        }
        field(6; "Sujeto Cotizacion"; Boolean)
        {
            Caption = 'SS salary';

            trigger OnValidate()
            begin
                ValidaPerfiles(7);
                ValidaHistorico(7);
            end;
        }
        field(7; "Texto Informativo"; Boolean)
        {
            Caption = 'Informative text';
            InitValue = false;

            trigger OnValidate()
            begin
                ValidaPerfiles(8);
            end;
        }
        field(8; "Fila Impresion Nomina"; Integer)
        {
            Caption = 'Payroll Print Row';
        }
        field(9; "Col. Impresion Nomina"; Integer)
        {
            Caption = 'Col. Print Payroll';
        }
        field(10; "Imprimir descripcion"; Boolean)
        {
            Caption = 'Print description';
        }
        field(11; Provisionar; Boolean)
        {
            Caption = 'Provision';

            trigger OnValidate()
            begin
                ValidaPerfiles(6);

                DistCtaGpoCont.SetRange("Código Concepto Salarial", Codigo);
                if DistCtaGpoCont.Find('-') then
                    repeat
                        DistCtaGpoCont.Provisionar := Provisionar;
                        DistCtaGpoCont.Modify;
                    until DistCtaGpoCont.Next = 0;
            end;
        }
        field(12; "No. Cuenta Cuota Obrera"; Text[20])
        {
            Caption = 'Employee contribution G/L account';
            TableRelation = IF ("Tipo Cuenta Cuota Obrera" = CONST(Cuenta)) "G/L Account"."No."
            ELSE
            IF ("Tipo Cuenta Cuota Obrera" = CONST(Proveedor)) Vendor."No.";

            trigger OnValidate()
            begin
                if "Tipo Cuenta Cuota Obrera" = "Tipo Cuenta Cuota Obrera"::Cliente then
                    Error(Err002, FieldCaption("Tipo Cuenta Cuota Obrera"), "Tipo Cuenta Cuota Obrera");
            end;
        }
        field(13; "Contabilizacion Resumida"; Boolean)
        {
            Caption = 'Summary journal entry';
        }
        field(14; "Contabilizacion x Dimension"; Boolean)
        {
            Caption = 'Journal entry by Dimension';
        }
        field(15; "Sumar/Restar a cuenta salarios"; Boolean)
        {
            Caption = 'Add / Subtract from salaries account';
        }
        field(16; "Cotiza AFP"; Boolean)
        {
            CaptionClass = '4,4,1';
            Caption = 'Cotiza AFP';

            trigger OnValidate()
            begin
                ValidaHistorico(1);
                ValidaPerfiles(1);
            end;
        }
        field(17; "Cotiza SRL"; Boolean)
        {
            CaptionClass = '4,7,1';
            Caption = 'Apply for SRL';

            trigger OnValidate()
            begin
                ValidaHistorico(2);
                ValidaPerfiles(2);
            end;
        }
        field(18; "Cotiza INFOTEP"; Boolean)
        {
            CaptionClass = '4,6,1';
            Caption = 'Apply for INFOTEP';

            trigger OnValidate()
            begin
                ValidaHistorico(3);
                ValidaPerfiles(3);
            end;
        }
        field(19; "Cotiza ISR"; Boolean)
        {
            CaptionClass = '4,3,1';
            Caption = 'Apply for Income Tax';

            trigger OnValidate()
            begin
                ValidaHistorico(4);
                ValidaPerfiles(4);
            end;
        }
        field(20; "Cotiza SFS"; Boolean)
        {
            CaptionClass = '4,5,1';
            Caption = 'Apply for SFS';

            trigger OnValidate()
            begin
                ValidaHistorico(5);
                ValidaPerfiles(5);
            end;
        }
        field(21; "Tipo Cuenta Cuota Obrera"; Option)
        {
            Caption = 'Employee contribution Account Type';
            OptionCaption = 'G/L Account,Vendor,Customer';
            OptionMembers = Cuenta,Proveedor,Cliente;

            trigger OnValidate()
            begin
                if "Tipo Cuenta Cuota Obrera" = "Tipo Cuenta Cuota Obrera"::Cliente then
                    "No. Cuenta Cuota Obrera" := '';
            end;
        }
        field(22; "Tipo Cuenta Cuota Patronal"; Option)
        {
            Caption = 'Employer contribution Account Type';
            OptionCaption = 'G/L Account,Vendor';
            OptionMembers = Cuenta,Proveedor;
        }
        field(23; "No. Cuenta Cuota Patronal"; Code[20])
        {
            Caption = 'Employer contribution G/L account';
            TableRelation = IF ("Tipo Cuenta Cuota Patronal" = CONST(Cuenta)) "G/L Account"."No."
            ELSE
            IF ("Tipo Cuenta Cuota Patronal" = CONST(Proveedor)) Vendor."No.";
        }
        field(24; "Tipo Cuenta Contrapartida CO"; Option)
        {
            Caption = 'Employee contribution Bal. Account Type';
            OptionCaption = 'G/L Account,Vendor';
            OptionMembers = Cuenta,Proveedor;
        }
        field(25; "No. Cuenta Contrapartida CO"; Code[20])
        {
            Caption = 'Employee contribution Bal. G/L account';
            TableRelation = IF ("Tipo Cuenta Contrapartida CO" = CONST(Cuenta)) "G/L Account"."No."
            ELSE
            IF ("Tipo Cuenta Contrapartida CO" = CONST(Proveedor)) Vendor."No.";

            trigger OnValidate()
            begin
                if "No. Cuenta Contrapartida CO" <> '' then
                    "Validar Contrapartida CO" := true
                else
                    "Validar Contrapartida CO" := false;
            end;
        }
        field(26; "Tipo Cuenta Contrapartida CP"; Option)
        {
            Caption = 'Employer contribution Bal. Account Type';
            OptionCaption = 'G/L Account,Vendor';
            OptionMembers = Cuenta,Proveedor;
        }
        field(27; "No. Cuenta Contrapartida CP"; Code[20])
        {
            Caption = 'Employer contribution Bal.  G/L account';
            TableRelation = IF ("Tipo Cuenta Contrapartida CP" = CONST(Cuenta)) "G/L Account"."No."
            ELSE
            IF ("Tipo Cuenta Contrapartida CP" = CONST(Proveedor)) Vendor."No.";

            trigger OnValidate()
            begin
                if "No. Cuenta Contrapartida CP" <> '' then
                    "Validar Contrapartida CP" := true
                else
                    "Validar Contrapartida CP" := false;
            end;
        }
        field(28; "Validar Contrapartida CO"; Boolean)
        {
            Caption = 'Validate Bal. G/L Account CO';
        }
        field(29; "Validar Contrapartida CP"; Boolean)
        {
            Caption = 'Validate Bal. G/L Account CP';
        }
        field(30; "Aplica para Regalia"; Boolean)
        {
            Caption = 'Apply for Christmas salary';

            trigger OnValidate()
            begin
                ValidaHistorico(10);
                ValidaPerfiles(10);
            end;
        }
        field(31; "Cotiza SUTA"; Boolean)
        {
            Caption = 'Apply for SUTA';
        }
        field(32; "Cotiza FUTA"; Boolean)
        {
            Caption = 'Appply for FUTA';
        }
        field(33; "Cotiza MEDICARE"; Boolean)
        {
            Caption = 'Apply for MEDICARE';
        }
        field(34; "Cotiza FICA"; Boolean)
        {
            Caption = 'Apply for FICA';
        }
        field(35; "Cotiza SINOT"; Boolean)
        {
            Caption = 'Apply for SINOT';
        }
        field(36; "Cotiza CHOFERIL"; Boolean)
        {
            Caption = 'Applu for CHORERIL';
        }
        field(37; "Cotiza INCOMETAX"; Boolean)
        {
            Caption = 'Apply for INCOMETAX';
        }
        field(38; "Excluir de listados"; Boolean)
        {
            Caption = 'Exclude from reports';
            Description = 'Bolivia';

            trigger OnValidate()
            begin
                ValidaHistorico(9);
                ValidaPerfiles(9);
            end;
        }
        field(39; "No distribuir en proyectos"; Boolean)
        {
            Caption = 'No distribuir en proyectos';
            DataClassification = ToBeClassified;
        }
        field(40; "Tipo de nomina"; Code[20])
        {
            Caption = 'Payroll type';
            DataClassification = ToBeClassified;
            TableRelation = "Tipos de nominas";

            trigger OnValidate()
            begin
                if "Tipo de nomina" <> '' then begin
                    PS.Reset;
                    PS.SetRange("Concepto salarial", Codigo);
                    if PS.FindSet(true) then
                        repeat
                            PS."Tipo de nomina" := "Tipo de nomina";
                            PS.Modify;
                        until PS.Next = 0;
                end;
            end;
        }
        field(41; "Formula calculo"; Text[80])
        {
            Caption = 'Calculation formula';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
        key(Key2; Descripcion)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }

    trigger OnDelete()
    begin
        Utilizado := false;

        HLN.Reset;
        HLN.SetRange("Concepto salarial", Codigo);
        if HLN.FindFirst then
            Error(Err003);

        PS.Reset;
        PS.SetRange("Concepto salarial", Codigo);
        if PS.FindFirst then
            Utilizado := true;

        if Utilizado then begin
            if Confirm(Text003, false) then begin
                PS.Reset;
                PS.SetRange("Concepto salarial", Codigo);
                PS.FindSet(true);
                PS.DeleteAll;
            end
            else
                Error(Text004);
        end;
    end;

    trigger OnInsert()
    begin
        ConfNominas.Get();
        ConfNominas.TestField("Dimension Conceptos Salariales");
        "Dimension Nomina" := ConfNominas."Dimension Conceptos Salariales";
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        DimValue: Record "Dimension Value";
        ConceptosSal: Record "Conceptos salariales";
        Err001: Label 'This value it''s only allowed once';
        Err002: Label 'This account is selected direct from the employee''s card for %1 %2';
        Err003: Label 'Thsi Wedge has been use in payrolls, it can not be deleted';
        Text000: Label 'There are Posted Payroll with this Wedge, do you want to update the parameters?';
        Text001: Label 'Do you want to update the parameter for the Wedges schemas?';
        Text002: Label 'Updating  #1########## @2@@@@@@@@@@@@@';
        DistCtaGpoCont: Record "Dist. Ctas. Gpo. Cont. Empl.";
        PS: Record "Perfil Salarial";
        HLN: Record "Historico Lin. nomina";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text003: Label 'If you delete this wedge it will be deleted from all the employees, do you want to continue?';
        Utilizado: Boolean;
        Text004: Label 'Aborted process';


    procedure SpecialRelation("Nº de campo": Integer)
    begin
    end;


    procedure ValidaHistorico(Procedencia: Integer)
    var
        HLN: Record "Historico Lin. nomina";
    begin
        HLN.Reset;
        HLN.SetRange("Concepto salarial", Codigo);
        if HLN.FindFirst then begin
            if Confirm(Text000, true) then begin
                HLN.Reset;
                HLN.SetRange("Concepto salarial", Codigo);
                CounterTotal := HLN.Count;
                Window.Open(Text002);
                HLN.FindSet(true);
                repeat
                    Counter += 1;
                    Window.Update(1, Codigo);
                    Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                    case Procedencia of
                        1:
                            HLN."Cotiza AFP" := "Cotiza AFP";
                        2:
                            HLN."Cotiza SRL" := "Cotiza SRL";
                        3:
                            HLN."Cotiza Infotep" := "Cotiza INFOTEP";
                        4:
                            HLN."Cotiza ISR" := "Cotiza ISR";
                        5:
                            HLN."Cotiza SFS" := "Cotiza SFS";
                        7:
                            HLN."Sujeto Cotización" := "Sujeto Cotizacion";
                        8:
                            HLN."Texto Informativo" := "Texto Informativo";
                        9:
                            HLN."Excluir de listados" := "Excluir de listados";
                        10:
                            HLN."Aplica para Regalia" := "Aplica para Regalia";
                        11:
                            HLN."Salario Base" := "Salario Base";
                    end;
                    HLN.Modify;
                until HLN.Next = 0;
                Window.Close;
            end;
        end;
    end;


    procedure ValidaPerfiles(Procedencia: Integer)
    var
        PSxC: Record "Perfil Salario x Cargo";
        LPS: Record "Perfil Salarial";
    begin
        /*
        PSxC.RESET;
        PSxC.SETRANGE("Concepto salarial",Código);
        IF PSxC.FINDFIRST THEN
           BEGIN
        //    if CONFIRM(Text000,true) then
        //       begin
                PSxC.RESET;
                PSxC.SETRANGE("Concepto salarial",Código);
                CounterTotal := PSxC.COUNT;
                Window.OPEN(Text002);
                PSxC.FINDSET(TRUE,FALSE);
                REPEAT
                 Counter += 1;
                 Window.UPDATE(1,Código);
                 Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                 CASE Procedencia OF
                  1:
                   PSxC."Cotiza AFP" := "Cotiza AFP";
                  2:
                   PSxC."Aplica SRL" := "Cotiza SRL";
                  3:
                   PSxC."Cotiza INFOTEP" := "Cotiza INFOTEP";
                  4:
                   PSxC."Cotiza ISR" := "Cotiza ISR";
                  5:
                   PSxC."Cotiza SFS" := "Cotiza SFS";
                  6:
                   PSxC.Prorratear   := Provisionar;
                  8:
                   PSxC."Texto Informativo" := "Texto Informativo";
                 10:
                   PSxC."Aplica para Regalia" := "Aplica para Regalia";
                 END;
                 PSxC.MODIFY;
                UNTIL PSxC.NEXT = 0;
                Window.CLOSE;
         //      end;
           END;
        */
        LPS.Reset;
        LPS.SetRange("Concepto salarial", Codigo);
        if LPS.FindFirst then begin
            //    if CONFIRM(Text000,true) then
            //       begin
            LPS.Reset;
            LPS.SetRange("Concepto salarial", Codigo);
            CounterTotal := LPS.Count;
            Window.Open(Text002);
            LPS.FindSet(true);
            repeat
                Counter += 1;
                Window.Update(1, Codigo);
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                case Procedencia of
                    1:
                        LPS."Cotiza AFP" := "Cotiza AFP";
                    2:
                        LPS."Cotiza SRL" := "Cotiza SRL";
                    3:
                        LPS."Cotiza INFOTEP" := "Cotiza INFOTEP";
                    4:
                        LPS."Cotiza ISR" := "Cotiza ISR";
                    5:
                        LPS."Cotiza SFS" := "Cotiza SFS";
                    6:
                        LPS.Provisionar := Provisionar;
                    7:
                        LPS."Sujeto Cotizacion" := "Sujeto Cotizacion";
                    8:
                        LPS."Texto Informativo" := "Texto Informativo";
                    9:
                        LPS."Excluir de listados" := "Excluir de listados";
                    10:
                        LPS."Aplica para Regalia" := "Aplica para Regalia";
                    11:
                        LPS."Salario Base" := "Salario Base";

                end;
                LPS.Modify;
            until LPS.Next = 0;
            Window.Close;
            //       end;
        end;

    end;
}

