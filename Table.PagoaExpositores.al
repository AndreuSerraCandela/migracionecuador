table 76304 "Pago a Expositores"
{

    fields
    {
        field(1; "ID Pago"; Integer)
        {
        }
        field(2; "Cod. Expositor"; Code[20])
        {
            TableRelation = "Expositores APS";

            trigger OnLookup()
            var
                recExp: Record "Expositores APS";
                Err001: Label 'No puede modificar el Expositor ya que el pago contiene lineas que no pertenecen a este Expositor. ';
                rDetalle: Record "Detalle Pago Expositores";
            begin

                if PAGE.RunModal(0, recExp) = ACTION::LookupOK then begin
                    "Cod. Expositor" := recExp."No.";
                    "Nombre Expositor" := recExp.Name;
                    if "Cod. Expositor" <> '' then begin
                        rDetalle.SetRange("ID Pago", "ID Pago");
                        rDetalle.SetFilter("Cod. Expositor", '<>%1', "Cod. Expositor");
                        if rDetalle.FindFirst then
                            Error(Err001);
                    end;
                end;
            end;

            trigger OnValidate()
            var
                Err001: Label 'No puede modificar el Expositor ya que el pago contiene lineas que no pertenecen a este Expositor. ';
                rDetalle: Record "Detalle Pago Expositores";
                rExp: Record "Expositores APS";
            begin

                "Nombre Expositor" := '';
                if "Cod. Expositor" <> '' then begin
                    rDetalle.SetRange("ID Pago", "ID Pago");
                    rDetalle.SetFilter("Cod. Expositor", '<>%1', "Cod. Expositor");
                    if rDetalle.FindFirst then
                        Error(Err001);
                    if rExp.Get("Cod. Expositor") then
                        "Nombre Expositor" := rExp.Name;

                end;
            end;
        }
        field(3; Fecha; Date)
        {
        }
        field(4; "No. Documento"; Code[20])
        {
        }
        field(5; Importe; Decimal)
        {
            CalcFormula = Sum("Detalle Pago Expositores"."Monto a Pagar" WHERE("ID Pago" = FIELD("ID Pago")));
            FieldClass = FlowField;
        }
        field(6; "Nombre Expositor"; Text[80])
        {
        }
        field(7; "Estado Pago"; Option)
        {
            OptionCaption = 'Pendiente,Pagado';
            OptionMembers = Pendiente,Pagado;
        }
        field(8; "Numero Eventos"; Integer)
        {
            CalcFormula = Count("Detalle Pago Expositores" WHERE("ID Pago" = FIELD("ID Pago")));
            FieldClass = FlowField;
        }
        field(9; "Tipo Documento"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Documentos));
        }
    }

    keys
    {
        key(Key1; "ID Pago")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        rDetalle: Record "Detalle Pago Expositores";
        Err001: Label 'No se permite eliminar pagos realizados.';
    begin

        if "Estado Pago" = "Estado Pago"::Pagado then
            Error(Err001);

        rDetalle.SetRange(rDetalle."ID Pago", "ID Pago");
        rDetalle.DeleteAll;
    end;

    trigger OnInsert()
    var
        recPagos: Record "Pago a Expositores";
    begin

        Fecha := WorkDate;

        if recPagos.FindLast then
            "ID Pago" := recPagos."ID Pago" + 1
        else
            "ID Pago" := 1;
    end;


    procedure PagoEventos()
    var
        rDet: Record "Detalle Pago Expositores";
        rPlanEv: Record "Cab. Planif. Evento";
        Error001: Label 'El evento %1 con secuencia %2 ya fue pagado anteriormente.';
    begin

        rDet.SetRange("ID Pago", "ID Pago");
        if rDet.FindSet then
            repeat
                rPlanEv.Get(rDet."Cod. Evento", rDet."Cod. Expositor", rDet.Secuencia);
                if rPlanEv.Pagado then
                    Error(StrSubstNo(Error001, rDet."Cod. Evento", rDet.Secuencia));
                rPlanEv.Pagado := true;
                rPlanEv."Importe pago" := rDet."Monto a Pagar";
                rPlanEv."No. Documento Pago" := "No. Documento";
                rPlanEv.Modify;
            until rDet.Next = 0;
    end;


    procedure RetrocederPagoEventos()
    var
        rDet: Record "Detalle Pago Expositores";
        rPlanEv: Record "Cab. Planif. Evento";
    begin

        rDet.SetRange("ID Pago", "ID Pago");
        if rDet.FindSet then
            repeat
                rPlanEv.Get(rDet."Cod. Evento", rDet."Cod. Expositor", rDet.Secuencia);
                rPlanEv.Pagado := false;
                rPlanEv."Importe pago" := 0;
                rPlanEv."No. Documento Pago" := '';
                rPlanEv.Modify;
            until rDet.Next = 0;
    end;
}

