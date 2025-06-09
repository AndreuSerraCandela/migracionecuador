table 76206 "Historico Plan Lector Det."
{

    fields
    {
        field(1; "Cod. Colegio"; Code[10])
        {
            Editable = false;
        }
        field(2; "Cod. Local"; Code[10])
        {
            Editable = false;
        }
        field(3; "Cod. Turno"; Code[10])
        {
            Editable = false;
        }
        field(4; "Cod. Nivel"; Code[10])
        {
            Editable = false;
        }
        field(5; "Cod. Grado"; Code[10])
        {
            Editable = false;
        }
        field(6; "Cantidad Secciones"; Integer)
        {
        }
        field(7; "Cantidad Alumnos"; Integer)
        {
        }
        field(8; "Cantidad Docentes"; Integer)
        {
        }
        field(9; "Edit. 1"; Code[10])
        {
        }
        field(10; "Cant. x Alum 1"; Integer)
        {
        }
        field(11; "Edit. 2"; Code[10])
        {
        }
        field(12; "Cant. x Alum 2"; Integer)
        {
        }
        field(13; "Tipo Lectura 1"; Option)
        {
            OptionCaption = ' ,Colectiva,Libre';
            OptionMembers = " ",Colectiva,Libre;
        }
        field(14; "Modalidad Lectura 1"; Code[10])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Modalidad Lectura"));
        }
        field(17; "Total Obras Compradas x Alumno"; Integer)
        {
            Editable = false;
        }
        field(19; "Universo de Títulos u Obras"; Integer)
        {
            Editable = false;
        }
        field(20; "Adopción real"; Integer)
        {
            Editable = false;
        }
        field(22; "Porc. Afinidad"; Integer)
        {
            Editable = false;
        }
        field(23; "Edit. 3"; Code[10])
        {
            TableRelation = Editoras.Code;
            ValidateTableRelation = false;
        }
        field(24; "Cant. x Alum 3"; Integer)
        {
        }
        field(25; "Edit. 4"; Code[10])
        {
            TableRelation = Editoras.Code;
            ValidateTableRelation = false;
        }
        field(26; "Cant. x Alum 4"; Integer)
        {
        }
        field(50; "Campaña"; Code[4])
        {
        }
    }

    keys
    {
        key(Key1; "Campaña", "Cod. Colegio", "Cod. Local", "Cod. Turno", "Cod. Nivel", "Cod. Grado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

