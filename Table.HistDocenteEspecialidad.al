table 76118 "Hist. Docente - Especialidad"
{
    Caption = 'Teacher - Speciality';

    fields
    {
        field(1; "Cod. Docente"; Code[20])
        {
            NotBlank = true;
            TableRelation = Docentes;
        }
        field(2; "Cod. Nivel"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Nivel Educativo APS";
        }
        field(3; "Cod. grado"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Grados));
        }
        field(4; "Cod. Especialidad"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Especialidades));
        }
        field(5; "Nombre Docente"; Text[70])
        {
            CalcFormula = Lookup(Docentes."Full Name" WHERE("No." = FIELD("Cod. Docente")));
            FieldClass = FlowField;
        }
        field(6; "Descripcion especialidad"; Text[100])
        {
        }
        field(7; Campana; Integer)
        {
            Caption = 'Campaign';
        }
    }

    keys
    {
        key(Key1; Campana, "Cod. Docente", "Cod. Nivel", "Cod. grado", "Cod. Especialidad")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DA: Record "Datos auxiliares";
}

