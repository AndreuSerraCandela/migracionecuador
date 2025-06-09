table 76404 "Historico Colegio - Grados"
{
    DrillDownPageID = "Colegio - Grados";
    LookupPageID = "Colegio - Grados";

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            TableRelation = Contact WHERE(Type = CONST(Company));
        }
        field(2; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE("Contact No." = FIELD("Cod. Colegio"));
        }
        field(3; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Nivel Educativo APS";
        }
        field(4; "Cod. Turno"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Turnos));
        }
        field(5; "Cod. Grado"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Grados));
        }
        field(6; Seccion; Code[10])
        {
        }
        field(7; "Cantidad Secciones"; Integer)
        {
        }
        field(8; "Cantidad Alumnos"; Integer)
        {

            trigger OnValidate()
            begin
                ColAdopcionD.Reset;
                ColAdopcionD.SetRange("Cod. Colegio", "Cod. Colegio");
                ColAdopcionD.SetRange("Cod. Nivel", "Cod. Nivel");
                ColAdopcionD.SetRange("Cod. Grado", "Cod. Grado");
                ColAdopcionD.SetRange("Cod. Turno", "Cod. Turno");
                ColAdopcionD.SetRange(Seccion, Seccion);
                if ColAdopcionD.FindSet(true) then
                    repeat
                        ColAdopcionD."Cantidad Alumnos" := "Cantidad Alumnos";
                        ColAdopcionD.Modify;
                    until ColAdopcionD.Next = 0;
            end;
        }
        field(9; "Cantidad Docentes"; Integer)
        {
        }
        field(10; "Lista Utiles"; Boolean)
        {
        }
        field(11; "Lista Competencia"; Boolean)
        {
        }
        field(12; "Horas Ingles"; Decimal)
        {
        }
        field(13; "Fecha Decision"; Date)
        {
            Caption = 'Decision Date';
        }
        field(20; Campana; Code[4])
        {
            Caption = 'Campaña';
            TableRelation = Campaign;
        }
    }

    keys
    {
        key(Key1; Campana, "Cod. Colegio", "Cod. Nivel", "Cod. Turno", "Cod. Grado", Seccion)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Nivel", "Cod. Grado")
        {
        }
    }

    trigger OnDelete()
    begin
        ColAdopcionD.Reset;
        ColAdopcionD.SetRange("Cod. Colegio", "Cod. Colegio");
        ColAdopcionD.SetRange("Cod. Nivel", "Cod. Nivel");
        ColAdopcionD.SetRange("Cod. Grado", "Cod. Grado");
        ColAdopcionD.SetRange("Cod. Turno", "Cod. Turno");
        ColAdopcionD.SetRange(Seccion, Seccion);
        ColAdopcionD.SetRange(Adopcion, 1, 5);
        if ColAdopcionD.FindFirst then
            Error(Err001);
    end;

    var
        DA: Record "Datos auxiliares";
        ColAdopcionD: Record "Colegio - Adopciones Detalle";
        Err001: Label 'This School = Grade already has Adopctions registered. You can''t delete it';
}

