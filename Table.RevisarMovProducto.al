table 56039 "Revisar Mov. Producto"
{
    // MOI - 10/03/2015 (#13548): Se crea la tabla para tenerla de temporal


    fields
    {
        field(1; "Item Code"; Code[20])
        {
        }
        field(2; "Location Code"; Code[10])
        {
        }
        field(3; Quantity; Decimal)
        {
        }
        field(4; "Remaining Quantity"; Decimal)
        {
        }
        field(5; Diferencia; Decimal)
        {
        }
        field(6; "Cantidad Entrada"; Decimal)
        {
        }
        field(7; "Cantidad Salida"; Decimal)
        {
        }
        field(8; "Cantidad Pendiente Entrada"; Decimal)
        {
        }
        field(9; "Cantidad Pendiente Salida"; Decimal)
        {
        }
        field(10; ID; Integer)
        {
        }
        field(11; "No. Mov"; Integer)
        {
        }
        field(12; "Cantidad Saldo IAE"; Decimal)
        {
        }
        field(13; "Cantidad Inicial IAE"; Decimal)
        {
        }
        field(14; "Cantidad Liq IAE"; Decimal)
        {
        }
        field(15; Fecha; Date)
        {
        }
        field(16; Documento; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rRec: Record "Revisar Mov. Producto";
    begin
        if rRec.FindLast then
            ID := ID + 1
        else
            ID := 1;
    end;
}

