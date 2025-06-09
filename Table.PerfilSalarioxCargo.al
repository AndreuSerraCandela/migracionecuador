table 76065 "Perfil Salario x Cargo"
{
    Caption = 'Salary profile by Job type';

    fields
    {
        field(1; "Puesto de Trabajo"; Code[15])
        {
            Caption = 'Job code';
            TableRelation = "Puestos laborales".Codigo;

            trigger OnValidate()
            begin
                if "Puesto de Trabajo" <> '' then begin
                    Cargos.Get("Puesto de Trabajo");
                end;
            end;
        }
        field(2; "Concepto salarial"; Code[20])
        {
            Caption = 'Wege ';
            TableRelation = "Conceptos salariales".Codigo;

            trigger OnValidate()
            begin
                ConfNominas.Get();
                Conceptos.Get("Concepto salarial");
                Descripcion := Conceptos.Descripcion;
                "Tipo concepto" := Conceptos."Tipo concepto";
            end;
        }
        field(3; "No. de Orden"; Integer)
        {
            Caption = 'Order no.';
            Editable = false;
        }
        field(4; Descripcion; Text[50])
        {
            Caption = 'Description';
        }
        field(7; "Tipo concepto"; Option)
        {
            Caption = 'Wage type';
            Description = 'Ingresos,Deducciones';
            OptionMembers = Ingresos,Deducciones;
        }
        field(12; "1ra Quincena"; Boolean)
        {
            Caption = '1st fortnight';
        }
        field(13; "2da Quincena"; Boolean)
        {
            Caption = '2nd fortnight';
        }
    }

    keys
    {
        key(Key1; "Puesto de Trabajo", "Concepto salarial")
        {
            Clustered = true;
        }
        key(KeyReports; "No. de Orden")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Conceptos: Record "Conceptos salariales";
        Cargos: Record "Puestos laborales";
        RegFormula: Record Polaca;
        Regconceptos: Record "Conceptos formula";
        Regpolaca: Record Polaca;
        Percept: Record Employee;
        RegLinConvenio: Record "Perfil Salario x Cargo";
        LinConvFormula: Record "Perfil Salario x Cargo";
        Scanner: Codeunit Scanner;
        Parser: Codeunit Parser;
        Calculadora: Codeunit Calculadora;
        ConfNominas: Record "Configuracion nominas";
        ok: Boolean;
        Msg001: Label 'The Concept %1 was not found in the table %2, please verify';
        FormConcSalariales: Page "Conceptos salariales";
}

