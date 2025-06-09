table 76301 "Dist. Ctas. Gpo. Cont. x Dim."
{
    Caption = 'Posting group G/L Account distrib. by Dim.';

    fields
    {
        field(1; Codigo; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Descripcion; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Shortcut Dimension"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = Dimension.Code;
        }
        field(4; "Concepto Salarial"; Code[20])
        {
            Caption = 'Wage code';
            TableRelation = "Conceptos salariales".Codigo;

            trigger OnValidate()
            begin
                /*ConfNom.GET();
                ConceptosSal.SETRANGE("Shortcut Dimension",ConfNom."Dimension Conceptos Salariales");
                ConceptosSal.SETRANGE(Código,"Código Concepto Salarial");
                ConceptosSal.FINDFIRST;
                "Shortcut Dimension"         := ConceptosSal."Shortcut Dimension";
                Descripción                  := ConceptosSal.Descripción;
                "Tipo Cuenta Cuota Obrera"   := ConceptosSal."Tipo Cuenta Cuota Obrera";
                "Tipo Cuenta Cuota Patronal" := ConceptosSal."Tipo Cuenta Cuota Patronal";
                "No. Cuenta Cuota Patronal"  := ConceptosSal."No. Cuenta Cuota Patronal";
                */

            end;
        }
        field(5; Importe; Decimal)
        {
            Caption = 'Amount';
            InitValue = 100;
            MaxValue = 100;
        }
        field(6; "No. tarjeta"; Code[10])
        {
            Caption = 'Card no.';
            TableRelation = "G/L Entry";
        }
        field(7; "Tipo de nomina"; Code[20])
        {
            Caption = 'Payroll type';
            DataClassification = ToBeClassified;
            TableRelation = "Tipos de nominas";
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
        ConfNom: Record "Configuracion nominas";
        ConceptosSal: Record "Conceptos salariales";
}

