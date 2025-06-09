table 76162 "Hist. Docente - Materia"
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
        field(9; Campana; Integer)
        {
            Caption = 'Campaign';
        }
    }

    keys
    {
        key(Key1; Campana, "Cod. Colegio", "Cod. Docente", "Cod. Materia")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

