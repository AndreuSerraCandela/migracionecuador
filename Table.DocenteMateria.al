table 76216 "Docente - Materia"
{

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            TableRelation = Contact;
        }
        field(2; "Cod. Docente"; Code[20])
        {
            TableRelation = Docentes;
        }
        field(3; "Cod. Materia"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Materia));
        }
        field(4; "Descripcion Nivel"; Text[100])
        {
        }
        field(5; "Descripcion Grado"; Text[100])
        {
        }
        field(6; "Descripcion Materia"; Text[100])
        {
        }
        field(8; "Nombre Colegio"; Text[60])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Colegio", "Cod. Docente", "Cod. Materia")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

