table 76328 "Detalle Pago Expositores"
{

    fields
    {
        field(1; "ID Pago"; Integer)
        {
        }
        field(2; Linea; Integer)
        {
        }
        field(3; "Cod. Expositor"; Code[20])
        {
        }
        field(5; "Num. Solicitud"; Code[20])
        {
            Editable = false;
        }
        field(6; "Cod. Evento"; Code[20])
        {

            trigger OnLookup()
            var
                recCabPlanif: Record "Cab. Planif. Evento";
                pgCabPlanif: Page "Sel. Eventos Planif. - Expo";
                recCabPago: Record "Pago a Expositores";
            begin
                recCabPago.Reset;
                recCabPago.SetRange("ID Pago", "ID Pago");
                recCabPago.FindFirst;
                recCabPlanif.Reset;
                recCabPlanif.SetRange(recCabPlanif.Expositor, recCabPago."Cod. Expositor");
                pgCabPlanif.SetTableView(recCabPlanif);
                pgCabPlanif.LookupMode(true);
                if pgCabPlanif.RunModal = ACTION::LookupOK then begin
                    pgCabPlanif.GetRecord(recCabPlanif);
                    "Cod. Expositor" := recCabPago."Cod. Expositor";
                    "Num. Solicitud" := recCabPlanif."No. Solicitud";
                    "Cod. Evento" := recCabPlanif."Cod. Taller - Evento";
                    "Descripción Evento" := recCabPlanif."Description Taller";
                    Secuencia := recCabPlanif.Secuencia;
                    "Tipo Evento" := recCabPlanif."Tipo Evento";
                    "Monto a Pagar" := recCabPlanif.CalculaMonto();
                end;
            end;
        }
        field(7; Secuencia; Integer)
        {
            Editable = false;
        }
        field(8; "Monto a Pagar"; Decimal)
        {
        }
        field(9; "Descripción Evento"; Text[60])
        {
            Editable = false;
        }
        field(10; "Tipo Evento"; Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "ID Pago", Linea)
        {
            Clustered = true;
            SumIndexFields = "Monto a Pagar";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        recCabPago: Record "Pago a Expositores";
        rDet: Record "Detalle Pago Expositores";
    begin
        if recCabPago.Get("ID Pago") then
            "Cod. Expositor" := recCabPago."Cod. Expositor";

        rDet.SetRange(rDet."ID Pago", "ID Pago");
        if rDet.FindLast then
            Linea := rDet.Linea + 1
        else
            Linea := 1;
    end;
}

