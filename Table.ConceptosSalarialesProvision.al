table 76072 "Conceptos Salariales Provision"
{

    fields
    {
        field(1; "Código"; Code[20])
        {
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(2; Disponible; Code[20])
        {
            TableRelation = "Conceptos salariales".Codigo;

            trigger OnValidate()
            begin
                //IF Código = Disponible THEN
                //   ERROR(Err001);
            end;
        }
        field(3; "Tipo provision"; Option)
        {
            Caption = 'Provition type';
            OptionCaption = 'Variable,Fix,Formula';
            OptionMembers = Variable,Fix,Formula;
        }
        field(4; "Gpo. Contable Empleado"; Code[20])
        {
            TableRelation = "Grupos Contables Empleados";
        }
        field(6; "No. Cuenta"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(7; "No. Cuenta Contrapartida"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Validar Contrapartida"; Boolean)
        {
        }
        field(11; "Fórmula cálculo"; Text[150])
        {
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                ConcepSalar: Record "Conceptos salariales";
            begin
                FormConcSalariales.LookupMode(true);
                if FormConcSalariales.RunModal = ACTION::LookupOK then begin
                    Clear(ConcepSalar);
                    FormConcSalariales.GetRecord(ConcepSalar);
                    "Fórmula cálculo" := "Fórmula cálculo" + ConcepSalar.Codigo;
                    Clear(FormConcSalariales);
                end;
            end;

            trigger OnValidate()
            begin
                "Fórmula cálculo" := UpperCase("Fórmula cálculo");
                if "Fórmula cálculo" <> '' then begin
                    Regpolaca.DeleteAll;
                    RegFormula.DeleteAll;
                    Regconceptos.DeleteAll;

                    Regconceptos.Formula := DelChr("Fórmula cálculo", '=', ' ');
                    RegFormula.SetRange(Formula, Regconceptos.Formula);
                    if RegFormula.Count = 0 then begin
                        Regconceptos.Formula := "Fórmula cálculo";
                        Scanner.Run(Regconceptos);
                        Parser.Run(Regconceptos);
                    end;

                    Regconceptos.Concepto := 'resultado';
                    if not Regconceptos.Insert then
                        Regconceptos.Modify;

                    Regpolaca.Reset;
                    Regpolaca.SetRange(Formula, Regconceptos.Formula);
                    if Regpolaca.FindSet then
                        repeat
                            if CopyStr(Regpolaca.Token, 1, 1) = '#' then
                                case Regpolaca.Token of
                                    '#1':
                                        Regconceptos.Concepto := Regpolaca.Token;
                                end;

                            if not Regconceptos.Insert then
                                Regconceptos.Modify;
                        until Regpolaca.Next = 0;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Código", "Gpo. Contable Empleado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Err001: Label 'Wedge Salary code can''t be equal to Wedge base salary code';
        RegFormula: Record Polaca temporary;
        Regconceptos: Record "Conceptos formula";
        Regpolaca: Record Polaca temporary;
        Scanner: Codeunit Scanner;
        Parser: Codeunit Parser;
        FormConcSalariales: Page "Conceptos salariales";
}

