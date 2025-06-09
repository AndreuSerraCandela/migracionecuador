table 76369 "Promotor - Planif. Visita"
{
    // $001 02/05/14   JML   Añado la delegación del colegio para informes
    //                       Traigo el año según la semana


    fields
    {
        field(1; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = CONST(Vendedor));
        }
        field(2; "Cod. Colegio"; Code[20])
        {
            TableRelation = "Promotor - Lista de Colegios"."Cod. Colegio" WHERE("Cod. Promotor" = FIELD("Cod. Promotor"));

            trigger OnValidate()
            begin
                BuscaCabecera;
                CabPlanif.TestField(Semana);
                Semana := CabPlanif.Semana;
                if "Cod. Colegio" <> '' then begin
                    Col.Get("Cod. Colegio");
                    "Nombre Colegio" := Col.Name;
                    Delegacion := Col.Región;   //$001
                end;
            end;
        }
        field(3; Fecha; Date)
        {
        }
        field(4; "Nombre Colegio"; Text[100])
        {
        }
        field(5; Estado; Option)
        {
            OptionCaption = ' ,Planned,Completed';
            OptionMembers = " ",Planificado,Completado;

            trigger OnValidate()
            begin

                TestField("Fecha Proxima Visita");

                Fecha1.Reset;
                Fecha1.SetRange("Period Type", 0);
                Fecha1.SetRange("Period Start", "Fecha Proxima Visita");
                Fecha1.FindFirst;

                Fecha2.Reset;
                Fecha2.SetRange("Period Type", 1);
                Fecha2.SetRange("Period Start", CalcDate('-' + Format(Fecha1."Period No." - 1) + 'D', Fecha1."Period Start"));
                Fecha2.FindFirst;

                Clear(CabPlanif);
                CabPlanif.Validate("Cod. Promotor", "Cod. Promotor");
                CabPlanif.Validate(Fecha, Fecha2."Period Start");
                CabPlanif.Validate(Ano, Date2DMY("Fecha Proxima Visita", 3));
                CabPlanif.Validate(Semana, Fecha2."Period No.");
                if CabPlanif.Insert(true) then;

                Clear(PromPlanVisit);
                PromPlanVisit.Validate("Cod. Promotor", "Cod. Promotor");
                PromPlanVisit.Ano := CabPlanif.Ano;
                PromPlanVisit.Semana := CabPlanif.Semana;
                PromPlanVisit.Fecha := CabPlanif.Fecha;
                PromPlanVisit.Validate("Cod. Colegio", "Cod. Colegio");
                PromPlanVisit.Validate("Fecha Visita", "Fecha Proxima Visita");
                PromPlanVisit.Insert(true);
            end;
        }
        field(6; "Fecha Visita"; Date)
        {

            trigger OnValidate()
            var
                recFechas: Record Date;
            begin

                BuscaCabecera;
                if ("Fecha Visita" < CabPlanif."Fecha Inicial") or
                   ("Fecha Visita" > CabPlanif."Fecha Final") then
                    Error(Err001, "Fecha Visita", CabPlanif.Semana);

                //$001 - Busca en la tabla fechas para evitar que la primera semana del año aparezca como el año anterior
                recFechas.Reset;
                recFechas.SetRange("Period Type", recFechas."Period Type"::Week);
                recFechas.SetFilter("Period Start", '<=%1', "Fecha Visita");
                //recFechas.SETFILTER("Period End", '>=%1', "Fecha Visita");
                //recFechas.SETRANGE("Period No.", Semana);
                //IF recFechas.FINDFIRST THEN
                if recFechas.FindLast then
                    Ano := Date2DMY(recFechas."Period End", 3);
                //$001
            end;
        }
        field(7; "Hora Inicial Visita"; Time)
        {
        }
        field(8; "Hora Final Visita"; Time)
        {
        }
        field(9; "Fecha Proxima Visita"; Date)
        {
        }
        field(10; Comentario; Text[150])
        {
        }
        field(11; "Nombre Promotor"; Text[60])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Cod. Promotor")));
            FieldClass = FlowField;
        }
        field(12; Ano; Integer)
        {
            Caption = 'Year';
            Editable = false;
        }
        field(13; Semana; Integer)
        {
        }
        field(14; "Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE("Contact No." = FIELD("Cod. Colegio"));
        }
        field(15; Turno; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Turnos));
        }
        field(16; Nivel; Code[20])
        {
            TableRelation = "Nivel Educativo APS";
        }
        field(17; "Persona atendio"; Code[20])
        {
            TableRelation = "Colegio - Lin. Jerarquia puest"."Cod. Empleado" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"));

            trigger OnValidate()
            begin
                PersCol.Reset;
                PersCol.SetRange("Cod. Colegio", "Cod. Colegio");
                PersCol.SetRange("Cod. Empleado", "Persona atendio");
                PersCol.FindFirst;
                "Nombre persona atendio" := PersCol."Nombre Empleado";
                Cargo := PersCol."Cod. Cargo";

                Docente.Get("Persona atendio");
                if not Docente."Pertenece al CDS" then
                    Tipo := 1;
            end;
        }
        field(18; Tipo; Option)
        {
            OptionCaption = ' ,CDS,Other';
            OptionMembers = " ",CDS,Otro;
        }
        field(19; Cargo; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Puestos de trabajo"));

            trigger OnValidate()
            begin
                if Cargo <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Puestos de trabajo");
                    DA.SetRange(Codigo, Cargo);
                    DA.FindFirst;

                    "Descripcion Cargo" := DA.Descripcion;
                end
            end;
        }
        field(20; "Nombre persona atendio"; Text[100])
        {
        }
        field(21; "Descripcion Cargo"; Text[100])
        {
        }
        field(22; Tarea; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Tareas));

            trigger OnValidate()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::Tareas);
                DA.SetRange(Codigo, Tarea);
                DA.FindFirst;
                "Descripcion Tarea" := DA.Descripcion;
            end;
        }
        field(23; "Descripcion Tarea"; Text[100])
        {
        }
        field(24; Objetivo; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Objetivos));

            trigger OnValidate()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::Objetivos);
                DA.SetRange(Codigo, Objetivo);
                DA.FindFirst;
                "Descripcion Objetivo" := DA.Descripcion;
            end;
        }
        field(25; "Descripcion Objetivo"; Text[100])
        {
        }
        field(26; Delegacion; Code[20])
        {
            Caption = 'Delegación';
        }
        field(27; Calificacion; Option)
        {
            Caption = 'Qualification';
            OptionCaption = ' ,Done,Not Done';
            OptionMembers = " ","Se Cumplio","No se Cumplio";
        }
    }

    keys
    {
        key(Key1; "Cod. Promotor", "Cod. Colegio", Semana, "Fecha Visita")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Promotor", "Cod. Colegio", Fecha)
        {
        }
        key(Key3; Delegacion, Nivel, "Cod. Promotor", Ano, Semana, "Fecha Visita")
        {
        }
        key(Key4; Fecha)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Estado > 1 then
            Error(Err002);
    end;

    trigger OnInsert()
    begin
        Fecha := Today;
        Ano := Date2DMY(Today, 3);
    end;

    var
        Col: Record Contact;
        CabPlanif: Record "Cab. Planificacion";
        Err001: Label 'The date %1 is out of range allowed for the week %2';
        PersCol: Record "Colegio - Lin. Jerarquia puest";
        DA: Record "Datos auxiliares";
        Docente: Record Docentes;
        Err002: Label 'You can''t delete lines with School with completed dates';
        Fecha1: Record Date;
        Fecha2: Record Date;
        PromPlanVisit: Record "Promotor - Planif. Visita";


    procedure BuscaCabecera()
    begin
        CabPlanif.Get("Cod. Promotor", Ano, Semana);
    end;
}

