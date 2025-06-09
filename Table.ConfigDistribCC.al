table 76006 "Config. Distrib. CC"
{

    fields
    {
        field(1; "Cta. Contable"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(2; "Descripcion Cta. Contable"; Text[150])
        {
            CalcFormula = Lookup ("G/L Account".Name WHERE ("No." = FIELD ("Cta. Contable")));
            FieldClass = FlowField;
        }
        field(3; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(4; Codigo; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code"));
        }
        field(5; Descripcion; Text[50])
        {
        }
        field(6; "% a distribuir"; Decimal)
        {

            trigger OnValidate()
            var
                ConfCC: Record "Config. Distrib. CC";
                "%Total": Decimal;
            begin
                "%Total" := "% a distribuir";
                ConfCC.SetRange("Cta. Contable", "Cta. Contable");
                ConfCC.SetFilter(Codigo, '<>%1', Codigo);
                if ConfCC.FindSet then
                    repeat
                        "%Total" += ConfCC."% a distribuir";
                    until ConfCC.Next = 0;

                if "%Total" > 100 then
                    Error(Err001);
            end;
        }
    }

    keys
    {
        key(Key1; "Cta. Contable", Codigo)
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

