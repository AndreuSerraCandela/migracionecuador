table 76237 "ent - aaa - Disponible"
{
    Caption = 'Training';

    fields
    {
        field(1; "Tipo entrenamiento"; Code[20])
        {
            Caption = 'Training type';
            DataClassification = ToBeClassified;
            TableRelation = "Datos adicionales RRHH".Code WHERE("Tipo registro" = CONST("Tipo Entrenamiento"));

            trigger OnValidate()
            begin
                if "Tipo entrenamiento" <> '' then begin
                    TiposEntrenamientos.Reset;
                    TiposEntrenamientos.SetRange("Tipo registro", TiposEntrenamientos."Tipo registro"::"Tipo Entrenamiento");
                    TiposEntrenamientos.SetRange(Code, "Tipo entrenamiento");
                    TiposEntrenamientos.FindFirst;
                    Descripcion := TiposEntrenamientos.Descripcion;
                end;
            end;
        }
        field(2; Codigo; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(3; Descripcion; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(4; "Area Curricular"; Code[20])
        {
            Caption = 'Trainer code';
            DataClassification = ToBeClassified;
            TableRelation = "Datos adicionales RRHH".Code WHERE("Tipo registro" = CONST("Area curricular"));
        }
        field(6; "Fecha creacion"; Date)
        {
            Caption = 'Date of creation';
            DataClassification = ToBeClassified;
        }
        field(7; "Horas estimadas"; Decimal)
        {
            Caption = 'Estimated hours';
            DataClassification = ToBeClassified;
        }
        field(8; "Capacidad de asistentes"; Integer)
        {
            Caption = 'Attendee capacity';
            DataClassification = ToBeClassified;
        }
        field(14; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; Tipo; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Internal, External';
            OptionMembers = Interno,Externo;
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
        key(Key2; "Tipo entrenamiento", Codigo)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Descripcion, "Area Curricular", "Horas estimadas")
        {
        }
        fieldgroup(Brick; Descripcion, "Area Curricular", "Horas estimadas")
        {
        }
    }

    trigger OnInsert()
    begin
        if Codigo = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("No. serie entrenamientos");
            //NoSeriesMgt.InitSeries(HumanResSetup."No. serie entrenamientos", xRec."No. Series", 0D, Codigo, "No. Series");
            Rec."No. series" := HumanResSetup."No. serie entrenamientos";
            if NoSeriesMgt.AreRelated(HumanResSetup."No. serie entrenamientos", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec.Codigo := NoSeriesMgt.GetNextNo(Rec."No. Series");
        end;
    end;

    var
        TiposEntrenamientos: Record "Datos adicionales RRHH";
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";

    procedure AssistEdit(): Boolean
    begin
        HumanResSetup.Get;
        HumanResSetup.TestField("No. serie entrenamientos");
        if NoSeriesMgt.LookupRelatedNoSeries(HumanResSetup."No. serie entrenamientos", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.GetNextNo(Codigo);
            exit(true);
        end;
    end;
}

