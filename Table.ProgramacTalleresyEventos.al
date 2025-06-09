table 76359 "Programac. Talleres y Eventos"
{
    // 0009 CAT Se modifica el campo Horas dictadas por Horas Pedagógicas

    DrillDownPageID = "Programac. Talleres y Eventos";
    LookupPageID = "Programac. Talleres y Eventos";

    fields
    {
        field(1; "Cod. Taller - Evento"; Code[20])
        {
            TableRelation = Eventos."No.";

            trigger OnValidate()
            begin
                TyE.SetRange("No.", "Cod. Taller - Evento");
                TyE.FindFirst;
                Validate("Tipo Evento", TyE."Tipo de Evento");
                //"Fecha de realizacion" := TyE."Horas programadas";
                //"Horas programadas":= TyE."Fecha invitacion";
            end;
        }
        field(2; "Tipo Evento"; Code[20])
        {
            TableRelation = "Tipos de Eventos";
        }
        field(3; "Cod. Colegio"; Code[20])
        {
            TableRelation = Contact WHERE(Type = CONST(Company));

            trigger OnValidate()
            begin
                if Col.Get("Cod. Colegio") then
                    "Nombre Colegio" := Col.Name;
            end;
        }
        field(4; "Cod. Promotor"; Code[20])
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
        field(5; "Description Tipo evento"; Text[100])
        {
            CalcFormula = Lookup("Tipos de Eventos".Descripcion WHERE(Codigo = FIELD("Tipo Evento")));
            FieldClass = FlowField;
        }
        field(6; "Description Taller"; Text[100])
        {
        }
        field(7; "Nombre Colegio"; Text[60])
        {
        }
        field(8; "Nombre Promotor"; Text[60])
        {
        }
        field(9; "Tipo de Expositor"; Option)
        {
            OptionCaption = 'Teacher,Vendor';
            OptionMembers = Docente,Proveedor;
        }
        field(10; Expositor; Code[20])
        {
            TableRelation = IF ("Tipo de Expositor" = CONST(Docente)) Docentes WHERE(Expositor = CONST(true))
            ELSE
            IF ("Tipo de Expositor" = CONST(Proveedor)) Vendor;
        }
        field(11; "Nombre Expositor"; Text[60])
        {
        }
        field(12; Avisado; Boolean)
        {
        }
        field(13; "Fecha inscripcion"; Date)
        {
            Editable = false;
        }
        field(14; "Fecha programacion"; Date)
        {
        }
        field(15; "Fecha de realizacion"; Date)
        {

            trigger OnValidate()
            var
                Err001: Label 'La fecha de realización no puede ser menor que la fecha de programación.';
            begin
                if "Fecha programacion" <> 0D then
                    if "Fecha de realizacion" < "Fecha programacion" then
                        Error(Err001);
            end;
        }
        field(16; "Asistentes esperados"; Integer)
        {
            Caption = 'Expected Attendees';
        }
        field(17; "Nro. De asistentes reales"; Integer)
        {
            Caption = 'Real Attendees';
            Editable = true;
            FieldClass = Normal;
        }
        field(18; "Horas dictadas"; Decimal)
        {

            trigger OnValidate()
            begin
                //TESTFIELD("Hora de Inicio");
                //"Hora Final" := "Hora de Inicio" + ("Horas dictadas" * 60000 * 60);
                "Horas Pedagógicas" := Round("Horas dictadas" * 60 / 40, 1);
            end;
        }
        field(19; "Horas Pedagógicas"; Decimal)
        {
            Editable = false;
        }
        field(20; Observacion; Text[150])
        {
        }
        field(21; "Fecha Solicitud"; Date)
        {
        }
        field(22; Objetivo; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Objetivos));
        }
        field(23; "Descripcion observacion"; Text[100])
        {
        }
        field(24; Secuencia; Integer)
        {
        }
        field(25; Estado; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Done,Cancelled';
            OptionMembers = " ",Realizado,Anulado;

            trigger OnValidate()
            begin
                CabPEvento.Get("Cod. Taller - Evento", Expositor, Secuencia);
                if (CabPEvento.Estado <> Estado) and (CabPEvento.Estado > 0) then
                    Error(StrSubstNo(Err001, FieldCaption(Estado)));
            end;
        }
        field(26; "Hora de Inicio"; Time)
        {
            Caption = 'Starting date';

            trigger OnValidate()
            begin
                //TESTFIELD("Hora de Inicio");
                //"Hora Final" := "Hora de Inicio" + ("Horas dictadas" * 60000 * 60);
                Horas;
            end;
        }
        field(27; "Hora Final"; Time)
        {

            trigger OnValidate()
            begin
                Horas;
            end;
        }
        field(28; "No. Linea"; Integer)
        {
        }
        field(29; "Fecha propuesta"; Date)
        {
        }
        field(30; "Hora Inicio Propuesta"; Time)
        {
            Editable = false;
        }
        field(31; "Hora Fin Propuesta"; Time)
        {
            Editable = false;
        }
        field(32; "Cod. Grado"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Grados));
        }
    }

    keys
    {
        key(Key1; "Cod. Taller - Evento", "Tipo Evento", "Tipo de Expositor", Expositor, Secuencia, "No. Linea")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Colegio", "Fecha inscripcion")
        {
        }
        key(Key3; "Fecha programacion", "Cod. Colegio", "Hora de Inicio")
        {
        }
        key(Key4; Expositor, "Fecha programacion")
        {
        }
        key(Key5; "Fecha programacion", "Nombre Colegio", "Hora de Inicio")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rRec: Record "Programac. Talleres y Eventos";
        rAsist: Record "Asistentes Talleres y Eventos";
        rAsist2: Record "Asistentes Talleres y Eventos";
    begin
        "Fecha inscripcion" := Today;
        "Fecha Solicitud" := Today;

        rRec.SetRange(rRec."Cod. Taller - Evento", "Cod. Taller - Evento");
        rRec.SetRange(rRec."Tipo Evento", "Tipo Evento");
        rRec.SetRange(rRec."Tipo de Expositor", "Tipo de Expositor");
        rRec.SetRange(rRec.Expositor, Expositor);
        rRec.SetRange(rRec.Secuencia, Secuencia);
        if rRec.FindLast then
            "No. Linea" := rRec."No. Linea" + 1
        else
            "No. Linea" := 1;


        CabPEvento.Reset;
        CabPEvento.SetRange("Cod. Taller - Evento", "Cod. Taller - Evento");
        CabPEvento.SetRange(Expositor, Expositor);
        if CabPEvento.FindLast then
            "Description Taller" := CabPEvento."Description Taller";


        if "No. Linea" > 1 then begin
            //Si la anterior programacion ya tiene asistentes inscritos, los incluimos en la programacion actual
            //Solo ocurrirá cuando se añade una programación y ya se inscribieron a los asistentes.
            rAsist.SetRange(rAsist."Cod. Taller - Evento", rRec."Cod. Taller - Evento");
            rAsist.SetRange(rAsist."Cod. Expositor", rRec.Expositor);
            rAsist.SetRange(rAsist.Secuencia, rRec.Secuencia);
            rAsist.SetRange(rAsist."Tipo de Expositor", rRec."Tipo de Expositor");
            rAsist.SetRange(rAsist."Tipo Evento", rRec."Tipo Evento");
            rAsist.SetRange("No Linea Programac.", rRec."No. Linea");
            if rAsist.FindSet then
                repeat
                    rAsist2 := rAsist;
                    rAsist2."No Linea Programac." := "No. Linea";
                    rAsist2.Confirmado := false;
                    rAsist2.Asistio := false;
                    rAsist2.Insert;
                until rAsist.Next = 0;
        end;
    end;

    var
        Col: Record Contact;
        Prom: Record "Salesperson/Purchaser";
        TyE: Record Eventos;
        CabPEvento: Record "Cab. Planif. Evento";
        Err001: Label 'You must change the %1 to '' '' in the Header to modify this line';


    procedure Horas()
    var
        Err001: Label 'La hora de inicio no puede ser superior a la hora final.';
    begin

        if "Hora de Inicio" > "Hora Final" then
            if ("Hora de Inicio" <> 0T) and ("Hora Final" <> 0T) then
                Error(Err001);

        if ("Hora de Inicio" <> 0T) and ("Hora Final" <> 0T) then
            Validate("Horas dictadas", Round(("Hora Final" - "Hora de Inicio") / 3600000, 0.01))
        else
            Validate("Horas dictadas", 0);
    end;
}

