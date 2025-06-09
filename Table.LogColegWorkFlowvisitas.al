table 76324 "Log Coleg. - Work Flow visitas"
{

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            TableRelation = "Contact Alt. Addr. Date Range";
        }
        field(2; Secuencia; Integer)
        {
        }
        field(3; Resultado; Boolean)
        {
        }
        field(4; Programado; Boolean)
        {
        }
        field(5; Paso; Boolean)
        {
        }
        field(6; Detalle; Text[60])
        {
        }
        field(7; Mantenimiento; Boolean)
        {
        }
        field(8; Conquista; Boolean)
        {
        }
        field(9; "Area"; Boolean)
        {
        }
        field(10; Fecha; Date)
        {
        }
        field(11; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE (Tipo = CONST (Vendedor));
        }
    }

    keys
    {
        key(Key1; Fecha, "Cod. Promotor", "Cod. Colegio", Secuencia)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    var
        CWF: Record "Colegio - Work Flow visitas";
    begin
    end;
}

