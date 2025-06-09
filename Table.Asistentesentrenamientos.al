table 76269 "Asistentes entrenamientos"
{
    Caption = 'Training assistants';

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
            TableRelation = "Datos adicionales RRHH".Code WHERE ("Tipo registro" = CONST ("Tipo Entrenamiento"));
        }
        field(3; "Cod. entrenamiento"; Code[20])
        {
            Caption = 'Training code';
            DataClassification = ToBeClassified;
            TableRelation = "ent - aaa - Disponible";

            trigger OnValidate()
            begin
                CabPlanifEnt.Get("No. entrenamiento");

                "Tipo entrenamiento" := CabPlanifEnt."Tipo entrenamiento";
                "Titulo entrenamiento" := CabPlanifEnt."Titulo entrenamiento";
                //"Area Curricular" := CabPlanifEnt."Area Curricular";
                "Tipo entrenamiento" := CabPlanifEnt."Tipo entrenamiento";
                "Tipo de Instructor" := CabPlanifEnt."Tipo de Instructor";
                "Cod. Instructor" := CabPlanifEnt."Cod. Instructor"
            end;
        }
        field(4; "Fecha programacion"; Date)
        {
            Caption = 'Schedule date';
        }
        field(5; "Titulo entrenamiento"; Text[100])
        {
            Caption = 'Training title';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Tipo de Instructor"; Option)
        {
            Caption = 'Trainer type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Employee,Vendor';
            OptionMembers = Empleado,Proveedor;
        }
        field(7; "Cod. Instructor"; Code[20])
        {
            Caption = 'Trainger code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Tipo de Instructor" = CONST (Empleado)) Employee
            ELSE
            IF ("Tipo de Instructor" = CONST (Proveedor)) Vendor;

            trigger OnValidate()
            begin
                case "Tipo de Instructor" of
                    0: // Empleado
                        begin
                            Emp.Get("Cod. Instructor");
                            "Nombre Instructor" := Emp."Full Name";
                        end;
                    else begin
                            Vendor.Get("Cod. Instructor");
                            "Nombre Instructor" := Vendor.Name;
                        end;
                end;
            end;
        }
        field(8; "Nombre Instructor"; Text[60])
        {
            Caption = 'Trainer name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "No. empleado"; Code[20])
        {
            Caption = 'Employee no.';
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "No. empleado" <> '' then begin
                    Emp.Get("No. empleado");
                    "Nombre completo" := Emp."Full Name";
                    "Document ID" := Emp."Document ID";
                end;
            end;
        }
        field(10; "Nombre completo"; Text[60])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Document ID"; Text[20])
        {
            Caption = 'Document ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(12; "Fecha inscripcion"; Date)
        {
            Caption = 'Enrollment date';
            DataClassification = ToBeClassified;
        }
        field(13; Inscrito; Boolean)
        {
            Caption = 'Enrolled';
            DataClassification = ToBeClassified;
        }
        field(14; Notificado; Boolean)
        {
            Caption = 'Notified';
            DataClassification = ToBeClassified;
        }
        field(15; Confirmado; Boolean)
        {
            Caption = 'Confirmed';
            DataClassification = ToBeClassified;
        }
        field(16; Asistio; Boolean)
        {
            Caption = 'Attended';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Asistio then begin
                    Inscrito := Asistio;
                    Confirmado := Asistio;
                end;
            end;
        }
        field(17; Calificacion; Decimal)
        {
            Caption = 'Score';
            DataClassification = ToBeClassified;
        }
        field(18; "Hora de Inicio"; Time)
        {
            Caption = 'Starting date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //TESTFIELD("Hora de Inicio");
                //"Hora Final" := "Hora de Inicio" + ("Horas dictadas" * 60000 * 60);
                //Horas;
            end;
        }
        field(19; "Hora Final"; Time)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Horas;
            end;
        }
    }

    keys
    {
        key(Key1; "No. entrenamiento", "Fecha programacion", "No. empleado")
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
    begin
        "Fecha inscripcion" := Today;
        Inscrito := true;
        CabPlanifEnt.Get("No. entrenamiento");
        "Hora de Inicio" := CabPlanifEnt."Hora de Inicio";
        "Hora Final" := CabPlanifEnt."Hora Final";
    end;

    var
        Emp: Record Employee;
        Err001: Label 'Total Attendees exceeds the capacity for Training';
        Err002: Label 'Cannot delete line because it is already marked with %1 %2';
        Vendor: Record Vendor;
        CabPlanifEnt: Record "Cab. Entrenamiento";
}

