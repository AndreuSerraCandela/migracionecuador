table 76339 "Lin. entrenamientos"
{
    Caption = 'Traininglines';

    fields
    {
        field(1; "No. entrenamiento"; Code[20])
        {
            Caption = 'Training no.';
            DataClassification = ToBeClassified;
        }
        field(2; "Tipo entrenamiento"; Code[20])
        {
            Caption = 'Training type';
            DataClassification = ToBeClassified;
            TableRelation = "Datos adicionales RRHH".Code WHERE("Tipo registro" = CONST("Tipo Entrenamiento"));
        }
        field(3; Disponible; Code[20])
        {
            Caption = 'Training code';
            DataClassification = ToBeClassified;
            Enabled = false;
            TableRelation = "ent - aaa - Disponible";

            trigger OnValidate()
            begin
                /*
                Entrenamiento.GET(Disponible);
                
                "Tipo entrenamiento" := Entrenamiento."Tipo entrenamiento";
                "Area Curricular" := Entrenamiento."Area Curricular";
                Tipo := Entrenamiento.Tipo;
                */

            end;
        }
        field(5; "Tipo de Instructor"; Option)
        {
            Caption = 'Trainer type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Employee,Vendor';
            OptionMembers = Empleado,Proveedor;
        }
        field(6; "Cod. Instructor"; Code[20])
        {
            Caption = 'Trainger code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Tipo de Instructor" = CONST(Empleado)) Employee
            ELSE
            IF ("Tipo de Instructor" = CONST(Proveedor)) Vendor;

            trigger OnValidate()
            begin
                case "Tipo de Instructor" of
                    0: // Empleado
                        begin
                            Employee.Get("Cod. Instructor");
                            "Nombre Instructor" := Employee."Full Name";
                        end;
                    else begin
                        Vendor.Get("Cod. Instructor");
                        "Nombre Instructor" := Vendor.Name;
                    end;
                end;
            end;
        }
        field(7; "Nombre Instructor"; Text[60])
        {
            Caption = 'Trainer name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; Avisado; Boolean)
        {
            Caption = 'Notified';
            DataClassification = ToBeClassified;
        }
        field(13; "Fecha inscripcion"; Date)
        {
            Caption = 'Enrollment date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Fecha programacion"; Date)
        {
            Caption = 'Programming date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //IF ("Fecha inscripcion" <> 0D) AND ("Fecha inscripcion" >)
            end;
        }
        field(17; "Nro. De asistentes reales"; Integer)
        {
            Caption = 'Real Attendees';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(20; Observacion; Text[150])
        {
            Caption = 'Observation';
            DataClassification = ToBeClassified;
        }
        field(22; Objetivo; Code[20])
        {
            Caption = 'Objective';
            DataClassification = ToBeClassified;
        }
        field(23; "Descripcion observacion"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24; Secuencia; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(25; Estado; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Done,Cancelled';
            OptionMembers = " ",Realizado,Anulado;

            trigger OnValidate()
            begin
                CabPlanifEnt.Get("No. entrenamiento", "Fecha programacion");
                if (CabPlanifEnt.Estado <> Estado) and (CabPlanifEnt.Estado > 0) then
                    Error(StrSubstNo(Err001, FieldCaption(Estado)));
            end;
        }
        field(26; "Hora de Inicio"; Time)
        {
            Caption = 'Starting date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                AsistEnt.Reset;
                AsistEnt.SetRange("No. entrenamiento", "No. entrenamiento");
                if AsistEnt.FindSet(true) then
                    repeat
                        AsistEnt."Hora de Inicio" := "Hora de Inicio";
                        AsistEnt."Hora Final" := "Hora Final";
                        AsistEnt.Modify;
                    until AsistEnt.Next = 0;
            end;
        }
        field(27; "Hora Final"; Time)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                AsistEnt.Reset;
                AsistEnt.SetRange("No. entrenamiento", "No. entrenamiento");
                if AsistEnt.FindSet(true) then
                    repeat
                        AsistEnt."Hora de Inicio" := "Hora de Inicio";
                        AsistEnt."Hora Final" := "Hora Final";
                        AsistEnt.Modify;
                    until AsistEnt.Next = 0;
            end;
        }
        field(28; "No. Linea"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Fecha propuesta"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Hora Inicio Propuesta"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31; "Hora Fin Propuesta"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(33; "Cab. Planif"; Boolean)
        {
            Editable = false;
        }
        field(34; "No. Solicitud"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Area Curricular"; Code[20])
        {
            Caption = 'Knowledge area code';
            DataClassification = ToBeClassified;
            TableRelation = "Datos adicionales RRHH".Code WHERE("Tipo registro" = CONST("Area curricular"));
        }
        field(36; Sala; Code[20])
        {
            Caption = 'Classroom';
            DataClassification = ToBeClassified;
            TableRelation = "Datos adicionales RRHH".Code WHERE("Tipo registro" = CONST("Salón"));
        }
        field(37; Tipo; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Internal, External';
            OptionMembers = Interno,Externo;
        }
    }

    keys
    {
        key(Key1; "No. entrenamiento", "Fecha programacion")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        AsistEnt.Reset;
        AsistEnt.SetRange("No. entrenamiento", "No. entrenamiento");
        AsistEnt.SetRange("Fecha programacion", "Fecha programacion");
        AsistEnt.SetRange(Asistio, true);
        if AsistEnt.FindFirst then
            Error(Err002);

        AsistEnt.Reset;
        AsistEnt.SetRange("No. entrenamiento", "No. entrenamiento");
        AsistEnt.SetRange("Fecha programacion", "Fecha programacion");
        if AsistEnt.FindSet(true) then
            AsistEnt.DeleteAll
    end;

    trigger OnInsert()
    begin
        CabPlanifEnt.Get("No. entrenamiento");
        CabPlanifEnt.TestField("Hora de Inicio");
        CabPlanifEnt.TestField("Hora Final");

        "Tipo entrenamiento" := CabPlanifEnt."Tipo entrenamiento";
        "Area Curricular" := CabPlanifEnt."Area Curricular";
        Tipo := CabPlanifEnt.Tipo;
    end;

    trigger OnModify()
    begin
        AsistEnt.Reset;
        AsistEnt.SetRange("No. entrenamiento", "No. entrenamiento");
        AsistEnt.SetRange("Fecha programacion", "Fecha programacion");
        if AsistEnt.FindSet(true) then
            repeat
                AsistEnt."Hora de Inicio" := "Hora de Inicio";
                AsistEnt."Hora Final" := "Hora Final";
                AsistEnt.Modify;
            until AsistEnt.Next = 0;
    end;

    var
        CabPlanifEnt: Record "Cab. Entrenamiento";
        Employee: Record Employee;
        Vendor: Record Vendor;
        AsistEnt: Record "Asistentes entrenamientos";
        Err001: Label 'You must change the %1 to '' '' in the Header to modify this line';
        Err002: Label 'This session contains employees whose attendance has been confirmed. The line cannot be deleted while there are confirmed employees for the same.';
}

