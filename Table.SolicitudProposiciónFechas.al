table 76108 "Solicitud - Proposición Fechas"
{

    fields
    {
        field(1; "No. Solicitud"; Code[20])
        {
        }
        field(2; "No. Linea"; Integer)
        {
        }
        field(3; "Fecha propuesta"; Date)
        {
        }
        field(4; "Hora Inicio"; Time)
        {
        }
        field(5; "Hora Fin"; Time)
        {
        }
        field(6; "Cod. Grado"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Grados));

            trigger OnValidate()
            var
                rSol: Record "Solicitud de Taller - Evento";
                rColGrados: Record "Colegio - Grados";
            begin

                "No. asistentes" := 0;
                if ("No. Solicitud" <> '') and ("Cod. Grado" <> '') then begin
                    rSol.Get("No. Solicitud");
                    rColGrados.SetRange(rColGrados."Cod. Colegio", rSol."Cod. Colegio");
                    //rColGrados.SETRANGE(rColGrados."Cod. Nivel", rSol."Cod. Nivel");
                    //rColGrados.SETRANGE(rColGrados."Cod. Turno",  rSol."Cod. Turno");
                    rColGrados.SetRange(rColGrados."Cod. Grado", "Cod. Grado");
                    if rColGrados.FindFirst then
                        repeat
                            "No. asistentes" := "No. asistentes" + rColGrados."Cantidad Alumnos";
                        until rColGrados.Next = 0;
                end;
            end;
        }
        field(8; "No. asistentes"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No. Solicitud", "No. Linea")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        rProp: Record "Solicitud - Proposición Fechas";
        rSol: Record "Solicitud de Taller - Evento";
    begin

        if ("No. Solicitud" <> '') and ("No. Linea" <> 0) then begin
            rProp.SetRange("No. Solicitud", "No. Solicitud");
            rProp.SetFilter("No. Linea", '<>%1', "No. Linea");
            if not rProp.FindSet then begin
                if rSol.Get("No. Solicitud") then begin
                    rSol."Fecha Propuesta" := 0D;
                    rSol.Modify;
                end;
            end;
        end;
    end;

    trigger OnInsert()
    var
        rRec: Record "Solicitud - Proposición Fechas";
        rProp: Record "Solicitud - Proposición Fechas";
        rSol: Record "Solicitud de Taller - Evento";
        Error001: Label 'La fecha propuesta (%1) es inferior a la fecha de solicitud (%2).';
    begin

        TestField("Fecha propuesta");
        TestField("Hora Inicio");
        TestField("Hora Fin");

        rRec.SetRange(rRec."No. Solicitud", "No. Solicitud");
        if rRec.FindLast then
            "No. Linea" := rRec."No. Linea" + 1
        else
            "No. Linea" := 1;

        if "Fecha propuesta" <> 0D then begin
            if rSol.Get("No. Solicitud") then begin
                if "Fecha propuesta" < rSol."Fecha Solicitud" then
                    Error(StrSubstNo(Error001, "Fecha propuesta", rSol."Fecha Solicitud"));
                rSol."Fecha Propuesta" := "Fecha propuesta";
                rSol.Modify;
            end;
        end;
    end;

    trigger OnModify()
    var
        rProp: Record "Solicitud - Proposición Fechas";
        rSol: Record "Solicitud de Taller - Evento";
        Error001: Label 'La fecha propuesta (%1) es inferior a la fecha de solicitud (%2).';
    begin

        TestField("Fecha propuesta");
        TestField("Hora Inicio");
        TestField("Hora Fin");

        if "Fecha propuesta" <> 0D then begin
            if rSol.Get("No. Solicitud") then begin
                if "Fecha propuesta" < rSol."Fecha Solicitud" then
                    Error(StrSubstNo(Error001, "Fecha propuesta", rSol."Fecha Solicitud"));
                rSol."Fecha Propuesta" := "Fecha propuesta";
                rSol.Modify;
            end;
        end;
    end;
}

