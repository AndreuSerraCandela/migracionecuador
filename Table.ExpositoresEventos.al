table 76367 "Expositores - Eventos"
{
    Caption = 'Exhibitors - Events';

    fields
    {
        field(1; "Cod. Expositor"; Code[20])
        {
            TableRelation = IF ("Tipo de Expositor" = CONST (Docente)) Docentes WHERE (Expositor = CONST (true))
            ELSE
            IF ("Tipo de Expositor" = CONST (Proveedor)) Vendor;

            trigger OnValidate()
            begin
                if "Tipo de Expositor" = 0 then begin
                    Expos.Get("Cod. Expositor");
                    "Nombre Expositor" := Expos."Full Name";
                end
                else begin
                    Vend.Get("Cod. Expositor");
                    "Nombre Expositor" := Vend.Name;
                end;

                Evento.Reset;
                Evento.SetRange("No.", "Cod. Evento");
                Evento.FindFirst;
                "Descripcion Evento" := Evento.Descripcion;
                Delegacion := Evento.Delegacion;
                "Tipo de Evento" := Evento."Tipo de Evento";
            end;
        }
        field(2; "Cod. Evento"; Code[20])
        {
            TableRelation = Eventos."No.";
        }
        field(3; "Nombre Expositor"; Text[100])
        {
            Editable = false;
        }
        field(4; "Descripcion Evento"; Text[100])
        {
            Editable = false;
        }
        field(5; "Cod. Docente"; Code[20])
        {
        }
        field(6; Delegacion; Code[20])
        {

            trigger OnValidate()
            begin
                ConfAPS.Get();
                ConfAPS.TestField(ConfAPS."Cod. Dimension Delegacion");

                if Delegacion <> '' then begin
                    DimVal.Reset;
                    DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                    DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                    DimVal.SetRange(Code, Delegacion);
                    DimVal.FindFirst;
                end;
            end;
        }
        field(7; "Tipo de Expositor"; Option)
        {
            OptionCaption = 'Teacher,Vendor';
            OptionMembers = Docente,Proveedor;
        }
        field(8; "Tipo de Evento"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Expositor", "Cod. Evento")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CabPlanifEven.Reset;
        CabPlanifEven.SetRange(Expositor, "Cod. Expositor");
        if CabPlanifEven.FindFirst then
            Error(Err001);
    end;

    trigger OnInsert()
    begin
        TestField("Cod. Expositor")
    end;

    var
        ConfAPS: Record "Commercial Setup";
        Expos: Record Docentes;
        Vend: Record Vendor;
        Evento: Record Eventos;
        DimVal: Record "Dimension Value";
        CabPlanifEven: Record "Cab. Planif. Evento";
        Err001: Label 'Can not delete the Exhibitor because it has associated events.';
}

