table 76101 Asignaturas
{
    DrillDownPageID = Asignaturas;
    LookupPageID = Asignaturas;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; Nivel; Code[20])
        {
            NotBlank = true;
            TableRelation = "Nivel Educativo APS";
        }
        field(4; Turno; Code[20])
        {
            NotBlank = true;
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Turnos));
        }
        field(5; Grado; Code[20])
        {
            NotBlank = true;
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Grados));
        }
        field(6; "Carga horaria"; Code[20])
        {
            TableRelation = "Carga Horaria";
        }
        field(7; "Tipo Ingles"; Option)
        {
            OptionCaption = 'USA,England';
            OptionMembers = USA,England;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

