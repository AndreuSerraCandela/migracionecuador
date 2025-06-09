table 76311 "Grupo - Colegios"
{

    fields
    {
        field(1; "Cod. grupo"; Code[20])
        {
            TableRelation = "Grupo de Colegios"."Cod. Grupo";

            trigger OnValidate()
            var
                rGrupo: Record "Grupo de Colegios";
            begin
                if rGrupo.Get("Cod. grupo") then
                    "Nombre Grupo" := rGrupo.Descripción;
            end;
        }
        field(3; "Nombre Grupo"; Text[80])
        {
        }
        field(4; "Cod. Colegio"; Code[20])
        {
            TableRelation = Contact."No.";

            trigger OnValidate()
            var
                rCol: Record Contact;
            begin
                if rCol.Get("Cod. Colegio") then
                    "Nombre Colegio" := rCol.Name;
            end;
        }
        field(5; "Nombre Colegio"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. grupo", "Cod. Colegio")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rRec: Record "Grupo - Colegios";
    begin
        TestField("Cod. grupo");
        TestField("Cod. Colegio");
    end;
}

