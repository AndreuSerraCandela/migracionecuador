table 76106 "Asistentes Talleres y Eventos"
{

    fields
    {
        field(1; "No. Solicitud"; Code[20])
        {
        }
        field(2; "Cod. Taller - Evento"; Code[20])
        {
            TableRelation = Eventos."No.";

            trigger OnValidate()
            begin
                TyE.Get("Tipo Evento", "Cod. Taller - Evento");
                "Description Taller" := TyE.Descripcion;
                Validate("Cod. Colegio", ProgTyE."Cod. Colegio");
                Validate("Cod. Promotor", ProgTyE."Cod. Promotor");
            end;
        }
        field(3; "Tipo Evento"; Code[20])
        {
        }
        field(4; "Cod. Colegio"; Code[20])
        {
            TableRelation = Contact WHERE(Type = CONST(Company));

            trigger OnValidate()
            begin
                if Col.Get("Cod. Colegio") then
                    "Nombre Colegio" := Col.Name;
            end;
        }
        field(5; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = CONST(Vendedor));

            trigger OnValidate()
            begin
                if "Cod. Promotor" <> '' then begin
                    Prom.Get("Cod. Promotor");
                    "Nombre Promotor" := Prom.Name;
                end;
            end;
        }
        field(6; "Description Tipo evento"; Text[100])
        {
        }
        field(7; "Description Taller"; Text[100])
        {
        }
        field(8; "Nombre Colegio"; Text[100])
        {
        }
        field(9; "Nombre Promotor"; Text[60])
        {
        }
        field(10; Secuencia; Integer)
        {
        }
        field(11; "Cod. Expositor"; Code[20])
        {
            TableRelation = IF ("Tipo de Expositor" = CONST(Docente)) Docentes WHERE(Expositor = CONST(true))
            ELSE
            IF ("Tipo de Expositor" = CONST(Proveedor)) Vendor;

            trigger OnValidate()
            begin
                if "Tipo de Expositor" = 0 then begin
                    Expos.Get("Cod. Expositor");
                    "Nombre Expositor" := Expos."Full Name";
                end
                else begin
                    Vend.Get("Cod. Expositor");
                    "Nombre Expositor" := Vend.Name;
                end
            end;
        }
        field(12; "Nombre Expositor"; Text[60])
        {
        }
        field(13; Confirmado; Boolean)
        {
        }
        field(14; "Fecha inscripcion"; Date)
        {
        }
        field(15; "Fecha del Evento"; Date)
        {
        }
        field(16; "Fecha de realizacion"; Date)
        {
        }
        field(17; "Cod. Docente"; Code[20])
        {
            TableRelation = Docentes;

            trigger OnValidate()
            begin
                if "Cod. Docente" <> '' then begin
                    Prof.Get("Cod. Docente");
                    "Nombre Docente" := Prof."Full Name";
                    "Document ID" := Prof."Document ID";
                    Inscrito := true;
                end;
            end;
        }
        field(18; "Nombre Docente"; Text[60])
        {
        }
        field(19; Asistio; Boolean)
        {
            Caption = 'Attended';

            trigger OnValidate()
            begin
                if (not Confirmado) and (Asistio) then
                    Confirmado := Asistio;

                if (Asistio) and ("No. Solicitud" <> '') then begin
                    Inscrito := Asistio;
                    Confirmado := Asistio;
                end;
            end;
        }
        field(20; "Tipo de Expositor"; Option)
        {
            OptionCaption = 'Teacher,Vendor';
            OptionMembers = Docente,Proveedor;
        }
        field(21; Inscrito; Boolean)
        {
        }
        field(22; "Fecha programacion"; Date)
        {
            CalcFormula = Lookup("Programac. Talleres y Eventos"."Fecha programacion" WHERE("Cod. Taller - Evento" = FIELD("Cod. Taller - Evento"),
                                                                                             "Tipo Evento" = FIELD("Tipo Evento"),
                                                                                             "Tipo de Expositor" = FIELD("Tipo de Expositor"),
                                                                                             Secuencia = FIELD(Secuencia),
                                                                                             "No. Linea" = FIELD("No Linea Programac.")));
            FieldClass = FlowField;
        }
        field(23; "Document ID"; Text[20])
        {
            Caption = 'Document ID';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(24; "No Linea Programac."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No. Solicitud", "Cod. Taller - Evento", "Cod. Expositor", Secuencia, "No Linea Programac.", "Cod. Docente")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Asistio then
            Error(StrSubstNo(Err002, FieldCaption(Asistio), Asistio));
    end;

    trigger OnInsert()
    var
        wAsistentesEsp: Integer;
        rSol: Record "Solicitud de Taller - Evento";
    begin
        CabPlanEvent.Reset;
        CabPlanEvent.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
        CabPlanEvent.SetRange(Expositor, "Cod. Expositor");
        CabPlanEvent.SetRange(Secuencia, Secuencia);
        CabPlanEvent.SetRange("Tipo Evento", "Tipo Evento");
        CabPlanEvent.FindFirst;


        "Fecha del Evento" := CabPlanEvent."Fecha Inicio";
        "Fecha inscripcion" := Today;
        Validate("Cod. Colegio", CabPlanEvent."Cod. Colegio");
        Validate("Cod. Promotor", CabPlanEvent."Cod. Promotor");


        rProgEv.SetRange(rProgEv."Cod. Taller - Evento", "Cod. Taller - Evento");
        rProgEv.SetRange(rProgEv.Expositor, "Cod. Expositor");
        rProgEv.SetRange(rProgEv.Secuencia, Secuencia);
        rProgEv.SetRange(rProgEv."Tipo Evento", "Tipo Evento");
        //rProgEv.SETRANGE(rProgEv."Fecha programacion",  "Fecha programacion");
        rProgEv.SetRange("No. Linea", "No Linea Programac.");
        rProgEv.FindFirst;

        if CabPlanEvent."No. Solicitud" <> '' then begin
            rSol.Get(CabPlanEvent."No. Solicitud");
            wAsistentesEsp := rSol."Asistentes Esperados";
        end
        else
            wAsistentesEsp := CabPlanEvent."Asistentes esperados";

        Asist.Reset;
        Asist.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
        Asist.SetRange("Tipo Evento", "Tipo Evento");
        Asist.SetRange("Cod. Expositor", "Cod. Expositor");
        Asist.SetRange(Secuencia, Secuencia);
        //Asist.SETRANGE("Fecha programacion","Fecha programacion");
        Asist.SetRange("No Linea Programac.", "No Linea Programac.");
        //IF CabPlanEvent."Asistentes esperados" < Asist.COUNT +1 THEN
        if wAsistentesEsp < Asist.Count + 1 then
            Error(Err001);
    end;

    var
        CabPlanEvent: Record "Cab. Planif. Evento";
        Col: Record Contact;
        Prom: Record "Salesperson/Purchaser";
        TyE: Record Eventos;
        Prof: Record Docentes;
        ProgTyE: Record "Programac. Talleres y Eventos";
        Expos: Record Docentes;
        Vend: Record Vendor;
        Asist: Record "Asistentes Talleres y Eventos";
        Err001: Label 'Teachers Total exceeds the capacity for the Event';
        Err002: Label 'Line can not be deleted because it is marked with %1 %2';
        rProgEv: Record "Programac. Talleres y Eventos";
}

