table 76149 "Seleccion beneficios"
{
    Caption = 'Benefits selection';

    fields
    {
        field(1; "No. documento"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Cod. Empleado"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Tipo Beneficio"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Income,Others';
            OptionMembers = Ingresos,Otro;
        }
        field(4; Codigo; Code[16])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            TableRelation = "Beneficios laborales".Codigo;

            trigger OnValidate()
            begin
                BeneficiosLab.Reset;
                BeneficiosLab.SetRange(Codigo, Codigo);
                BeneficiosLab.FindFirst;
                Descripcion := BeneficiosLab.Descripcion;
                "Tipo Beneficio" := BeneficiosLab."Tipo Beneficio";
            end;
        }
        field(5; Descripcion; Text[60])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; Importe; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Seleccionar; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No. documento", "Tipo Beneficio", Codigo)
        {
            Clustered = true;
        }
        key(Key2; "Cod. Empleado")
        {
        }
    }

    fieldgroups
    {
    }

    var
        BeneficiosLab: Record "Beneficios laborales";
}

