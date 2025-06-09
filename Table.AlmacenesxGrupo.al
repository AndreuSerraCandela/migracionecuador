table 56059 "Almacenes x Grupo"
{
    // 001 RRT 02.06.2014


    fields
    {
        field(1; Grupo; Code[10])
        {
            NotBlank = true;
            TableRelation = "Grupos de almacenes".Grupo;
        }
        field(2; Almacen; Code[10])
        {
            NotBlank = true;
            TableRelation = Location.Code;
        }
        field(10; "Nombre Grupo"; Text[50])
        {
            CalcFormula = Lookup ("Grupos de almacenes"."Descripción" WHERE (Grupo = FIELD (Grupo)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Nombre Almacen"; Text[100])
        {
            CalcFormula = Lookup (Location.Name WHERE (Code = FIELD (Almacen)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Grupo, Almacen)
        {
            Clustered = true;
        }
        key(Key2; Almacen, Grupo)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        TextL001: Label 'Un grupo no puede tener mas de %2 almacenes relacionados.';
        lrAxG: Record "Almacenes x Grupo";
    begin
        lrAxG.SetRange(Grupo, Grupo);
        if lrAxG.Count >= (32 + 1) then
            Error(TextL001, Grupo, 32);
    end;
}

