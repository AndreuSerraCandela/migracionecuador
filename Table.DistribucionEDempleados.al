table 76205 "Distribucion ED empleados"
{
    Caption = 'Employee JE distribution';

    fields
    {
        field(1; "Employee no."; Code[20])
        {
            Caption = 'Employee no.';
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(2; "Concepto salarial"; Code[20])
        {
            Caption = 'Wage Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(3; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(4; Codigo; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code"));
        }
        field(5; Descripcion; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; "% a distribuir"; Decimal)
        {
            Caption = '% to distribute';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                DistribED: Record "Distribucion ED empleados";
                "%Total": Decimal;
            begin
                "%Total" := "% a distribuir";
                DistribED.SetRange("Employee no.", "Employee no.");
                DistribED.SetRange("Concepto salarial", "Concepto salarial");
                DistribED.SetFilter(Codigo, '<>%1', Codigo);
                if DistribED.FindSet then
                    repeat
                        "%Total" += DistribED."% a distribuir";
                    until DistribED.Next = 0;

                if "%Total" > 100 then
                    Error(Err001);
            end;
        }
    }

    keys
    {
        key(Key1; "Employee no.", "Concepto salarial", Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Err001: Label 'The percent total is higher than 100%';
}

