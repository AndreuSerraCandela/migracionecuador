table 76038 "Incentivos/Propinas"
{

    fields
    {
        field(1; "Concepto Salarial"; Code[10])
        {
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(2; "Fecha de Corte"; Date)
        {
        }
        field(3; "Monto a Distribuir"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(4; "Fecha Ult. Corte"; Date)
        {
        }
        field(5; Delegacion; Code[20])
        {
            TableRelation = "Centros de Trabajo";
        }
    }

    keys
    {
        key(Key1; "Concepto Salarial", "Fecha de Corte")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Incentivo.SetRange("Concepto Salarial", "Concepto Salarial");
        if Incentivo.FindLast then
            "Fecha Ult. Corte" := xRec."Fecha de Corte";
    end;

    var
        Incentivo: Record "Incentivos/Propinas";
}

