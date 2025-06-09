table 76134 "Cab. Planif. Evento"
{
    DrillDownPageID = Aficiones;
    LookupPageID = Aficiones;

    fields
    {
        field(1; "Cod. Taller - Evento"; Code[20])
        {
            TableRelation = Eventos."No.";

            trigger OnValidate()
            begin
                TyE.Reset;
                TyE.SetRange("No.", "Cod. Taller - Evento");
                TyE.SetRange("Tipo de Evento", "Tipo Evento");
                if TyE.FindFirst then begin
                    "Description Taller" := TyE.Descripcion;
                    "Asistentes esperados" := TyE."Capacidad de vacantes";
                    Delegacion := TyE.Delegacion;
                    "Descripcion Delegacion" := TyE."Descripcion Delegacion";
                end;
            end;
        }
        field(2; "Tipo Evento"; Code[20])
        {
            TableRelation = "Tipos de Eventos";

            trigger OnValidate()
            begin
                if TipoEvent.Get("Tipo Evento") then
                    "Description Tipo evento" := TipoEvent.Descripcion;
            end;
        }
        field(3; Expositor; Code[20])
        {
            TableRelation = IF ("Tipo de Expositor" = CONST(Docente)) Docentes WHERE(Expositor = CONST(true))
            ELSE
            IF ("Tipo de Expositor" = CONST(Proveedor)) Vendor;

            trigger OnValidate()
            begin
                if Expositor <> '' then begin
                    if "Tipo de Expositor" = 0 then begin
                        Exposit.Get(Expositor);
                        "Nombre Expositor" := Exposit."Full Name";
                    end
                    else begin
                        Vend.Get(Expositor);
                        "Nombre Expositor" := Vend.Name;
                    end;
                end;
            end;
        }
        field(4; Secuencia; Integer)
        {
        }
        field(5; "Description Tipo evento"; Text[100])
        {
            CalcFormula = Lookup("Tipos de Eventos".Descripcion WHERE(Codigo = FIELD("Tipo Evento")));
            FieldClass = FlowField;
        }
        field(6; "Description Taller"; Text[100])
        {
        }
        field(7; "Nombre Expositor"; Text[60])
        {
        }
        field(8; "Tipo de Expositor"; Option)
        {
            OptionCaption = 'Teacher,Vendor';
            OptionMembers = Docente,Proveedor;
        }
        field(9; "Numero de sesiones"; Integer)
        {
            Caption = 'Sessions number';
        }
        field(10; "Fecha Inicio"; Date)
        {
        }
        field(11; Lunes; Boolean)
        {
            Caption = 'Monday';
        }
        field(12; Martes; Boolean)
        {
            Caption = 'Tuesday';
        }
        field(13; Miercoles; Boolean)
        {
            Caption = 'Wednesday';
        }
        field(14; Jueves; Boolean)
        {
            Caption = 'Thursday';
        }
        field(15; Viernes; Boolean)
        {
            Caption = 'Friday';
        }
        field(16; Sabados; Boolean)
        {
            Caption = 'Saturday';
        }
        field(17; Domingos; Boolean)
        {
            Caption = 'Sunday';
        }
        field(18; "Asistentes esperados"; Integer)
        {
        }
        field(19; "Total registrados"; Integer)
        {
            CalcFormula = Count("Asistentes Talleres y Eventos" WHERE("Cod. Taller - Evento" = FIELD("Cod. Taller - Evento"),
                                                                       "Tipo Evento" = FIELD("Tipo Evento"),
                                                                       "Cod. Expositor" = FIELD(Expositor),
                                                                       Secuencia = FIELD(Secuencia)));
            FieldClass = FlowField;
        }
        field(20; Estado; Option)
        {
            OptionCaption = ' ,Done,Cancelled';
            OptionMembers = " ",Realizado,Anulado;

            trigger OnValidate()
            var
                ProgEvent: Record "Programac. Talleres y Eventos";
            begin
                ProgEvent.Reset;
                ProgEvent.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
                ProgEvent.SetRange("Tipo Evento", "Tipo Evento");
                ProgEvent.SetRange(Expositor, Expositor);
                ProgEvent.SetRange(Secuencia, Secuencia);
                if ProgEvent.Count > 1 then begin
                    if ProgEvent.FindSet then
                        repeat
                            ProgEvent.TestField(Estado);
                        until ProgEvent.Next = 0;
                end
                else begin
                    if ProgEvent.FindFirst then begin
                        if Estado > 0 then
                            ProgEvent.TestField(Estado, Estado);
                    end;
                end;
            end;
        }
        field(21; "No. Solicitud"; Code[20])
        {
        }
        field(22; "Cod. Colegio"; Code[20])
        {
            TableRelation = Contact;
        }
        field(23; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(24; "Fecha Programada"; Date)
        {
        }
        field(25; "Fecha Realizada"; Date)
        {
        }
        field(26; "Cod. Nivel"; Code[20])
        {
        }
        field(27; Delegacion; Code[20])
        {

            trigger OnLookup()
            begin
                ConfAPS.Get();
                ConfAPS.TestField(ConfAPS."Cod. Dimension Delegacion");

                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimForm.SetTableView(DimVal);
                DimForm.SetRecord(DimVal);
                DimForm.LookupMode(true);
                if DimForm.RunModal = ACTION::LookupOK then begin
                    DimForm.GetRecord(DimVal);
                    Validate(Delegacion, DimVal.Code);
                end;

                Clear(DimForm);
            end;

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
                    "Descripcion Delegacion" := DimVal.Name;
                end;
            end;
        }
        field(28; "Descripcion Delegacion"; Text[60])
        {
            Caption = 'Descripción Delegación';
        }
        field(29; "Asistentes reales"; Integer)
        {
        }
        field(30; Pagado; Boolean)
        {
        }
        field(31; "Importe pago"; Decimal)
        {
        }
        field(32; "No. Documento Pago"; Code[20])
        {
        }
        field(33; "Tipo Documento Pago"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Documentos));
        }
        field(34; "Fecha Pago"; Date)
        {
        }
        field(35; "Nombre Colegio"; Text[100])
        {
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Cod. Colegio")));
            FieldClass = FlowField;
        }
        field(36; "Distrito Colegio"; Text[30])
        {
            CalcFormula = Lookup(Contact.Distritos WHERE("No." = FIELD("Cod. Colegio")));
            FieldClass = FlowField;
        }
        field(37; "Estado Solicitud"; Option)
        {
            CalcFormula = Lookup("Solicitud de Taller - Evento".Status WHERE("No. Solicitud" = FIELD("No. Solicitud")));
            FieldClass = FlowField;
            OptionCaption = ' ,Sent by salesperson,Approved,Programmed,Voided,Rejected,Done';
            OptionMembers = " ","Enviada por promotor",Aprobada,Programada,Cancelada,Rechazada,Realizada;
        }
        field(38; "Grupo Negocio"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Taller - Evento", Expositor, Secuencia)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Asistentes.Reset;
        Asistentes.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
        //Asistentes.SETRANGE("Tipo Evento","Tipo Evento");
        Asistentes.SetRange("Cod. Expositor", Expositor);
        Asistentes.SetRange(Secuencia, Secuencia);
        if Asistentes.FindSet(true) then
            repeat
                Asistentes.TestField(Asistio, false);
                Asistentes.Delete;
            until Asistentes.Next = 0;

        MatTallerEvento.Reset;
        MatTallerEvento.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
        //MatTallerEvento.SETRANGE("Tipo Evento","Tipo Evento");
        MatTallerEvento.SetRange(Expositor, Expositor);
        MatTallerEvento.SetRange(Secuencia, Secuencia);
        if MatTallerEvento.FindSet(true) then
            MatTallerEvento.DeleteAll;

        ProgTallerEvento.Reset;
        ProgTallerEvento.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
        //ProgTallerEvento.SETRANGE("Tipo Evento","Tipo Evento");
        ProgTallerEvento.SetRange(Expositor, Expositor);
        ProgTallerEvento.SetRange(Secuencia, Secuencia);
        if ProgTallerEvento.FindSet(true) then
            ProgTallerEvento.DeleteAll;
    end;

    trigger OnInsert()
    begin
        CabPlanEvent.Reset;
        CabPlanEvent.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
        CabPlanEvent.SetRange(Expositor, Expositor);
        if not CabPlanEvent.FindLast then
            CabPlanEvent.Init;

        Secuencia := CabPlanEvent.Secuencia + 1;
    end;

    var
        Exposit: Record Docentes;
        Vend: Record Vendor;
        TyE: Record Eventos;
        TipoEvent: Record "Tipos de Eventos";
        CabPlanEvent: Record "Cab. Planif. Evento";
        ConfAPS: Record "Commercial Setup";
        DimVal: Record "Dimension Value";
        MatTallerEvento: Record "Materiales Talleres y Eventos";
        ProgTallerEvento: Record "Programac. Talleres y Eventos";
        Asistentes: Record "Asistentes Talleres y Eventos";
        DimForm: Page "Dimension Value List";


    procedure CalculaMonto() rtnImporte: Decimal
    var
        rTar: Record "Tarifas - Tipos de Eventos";
        rSol: Record "Solicitud de Taller - Evento";
        rCol: Record Contact;
    begin
        rtnImporte := 0;

        rTar.Reset;
        rTar.SetRange("Tipo Evento", "Tipo Evento");
        if "No. Solicitud" <> '' then begin
            rSol.Get("No. Solicitud");
            if rCol.Get("Cod. Colegio") then begin
                rTar.SetRange("Post Code", rCol."Post Code");
                rTar.SetRange(County, rCol.County);
                rTar.SetRange(City, rCol.City);
                if not rTar.FindFirst then begin
                    rTar.SetRange("Post Code");
                    rTar.SetRange(County);
                    rTar.SetRange(City);
                end;
            end;
        end;
        if rTar.FindSet then
            case rTar."Tipo Pago" of
                rTar."Tipo Pago"::"Por Hora":
                    rtnImporte := rTar.Monto * GetHoras;
                rTar."Tipo Pago"::"Por Unidad":
                    rtnImporte := rTar.Monto;
                rTar."Tipo Pago"::"Por Grupo":
                    rtnImporte := rTar.Monto * GetGrupos;
            end;
    end;


    procedure GetHoras() rtnHoras: Decimal
    var
        rProg: Record "Programac. Talleres y Eventos";
    begin

        rtnHoras := 0;
        rProg.Reset;
        rProg.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
        rProg.SetRange("Tipo Evento", "Tipo Evento");
        rProg.SetRange("Tipo de Expositor", "Tipo de Expositor");
        rProg.SetRange(Expositor, Expositor);
        rProg.SetRange(Secuencia, Secuencia);
        if rProg.FindSet then
            repeat
                rtnHoras += rProg."Horas dictadas";
            until rProg.Next = 0;
    end;


    procedure GetGrupos() rtnGrupos: Integer
    var
        rProg: Record "Programac. Talleres y Eventos";
    begin

        rtnGrupos := 0;
        rProg.Reset;
        rProg.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
        rProg.SetRange("Tipo Evento", "Tipo Evento");
        rProg.SetRange("Tipo de Expositor", "Tipo de Expositor");
        rProg.SetRange(Expositor, Expositor);
        rProg.SetRange(Secuencia, Secuencia);
        if rProg.FindSet then
            rtnGrupos := rProg.Count;
    end;
}

