table 59999 "Operaciones CardNet"
{

    fields
    {
        field(1; "Nº Mov"; Integer)
        {
        }
        field(2; Host; Text[2])
        {
        }
        field(3; Tarjeta; Text[2])
        {
        }
        field(4; Fecha; Date)
        {
        }
        field(5; Hora; Time)
        {
        }
        field(6; Titular; Text[19])
        {
        }
        field(7; Aprobacion; Text[6])
        {
        }
        field(8; "Num POS"; Text[8])
        {
        }
        field(9; Referencia; Text[3])
        {
        }
        field(10; "Codigo Unico"; Text[12])
        {
        }
        field(11; "Identificador Trans"; Text[15])
        {
        }
        field(12; "Id Comercio"; Text[15])
        {
        }
        field(13; "Tipo Tarjeta"; Text[8])
        {
        }
        field(14; Importe; Decimal)
        {
        }
        field(15; "Nº Cuotas"; Integer)
        {
        }
        field(16; "Dif Leal Quick Pay"; Text[4])
        {
        }
        field(17; Reservado; Text[64])
        {
        }
        field(18; "Monto Propina"; Decimal)
        {
        }
        field(19; "Monto Total"; Decimal)
        {
        }
        field(20; "Lote Abierto"; Integer)
        {
        }
        field(22; AID; Text[16])
        {
        }
    }

    keys
    {
        key(Key1; "Nº Mov")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        rOper.Reset;
        if rOper.FindLast then
            "Nº Mov" := rOper."Nº Mov" + 1
        else
            "Nº Mov" := 1;
    end;

    var
        rOper: Record "Operaciones CardNet";
}

