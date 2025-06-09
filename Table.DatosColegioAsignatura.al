table 76287 "Datos Colegio - Asignatura"
{

    fields
    {
        field(1; "Codigo Colegio"; Code[20])
        {
            TableRelation = Contact;
        }
        field(2; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Nivel Educativo";
        }
        field(3; "Cod. local"; Code[20])
        {
            TableRelation = "Talleres y Eventos - Grados" WHERE ("No. Solicitud" = FIELD ("Codigo Colegio"));
        }
        field(4; "Cod. Docente"; Code[20])
        {
            TableRelation = Docentes;
        }
        field(5; "Descripcion Colegio"; Text[100])
        {
        }
        field(6; "Nombre docente"; Text[100])
        {
        }
        field(7; "Cod. especialidad"; Code[20])
        {
        }
        field(8; "Pertenece al CDS"; Boolean)
        {
        }
        field(9; "Fecha inscripcion CDS"; Date)
        {
        }
        field(10; "Cod. nivel de decision"; Code[20])
        {
        }
        field(11; "Cod. Cargo"; Code[20])
        {
            TableRelation = "Colegio - Adopciones compet." WHERE ("Cod. Editorial" = FIELD ("Codigo Colegio"));
        }
        field(12; "Descripcion puesto"; Text[100])
        {
        }
        field(13; Observacion; Text[150])
        {
        }
        field(14; Status; Option)
        {
            OptionCaption = 'Active,Bocked';
            OptionMembers = Activo,Bloqueado;
        }
    }

    keys
    {
        key(Key1; "Codigo Colegio", "Cod. Nivel", "Cod. Docente")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

