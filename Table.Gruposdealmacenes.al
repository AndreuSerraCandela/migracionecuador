table 56058 "Grupos de almacenes"
{
    // 001 RRT 02.06.2014

    DrillDownPageID = "Grupos de almacenes";
    LookupPageID = "Grupos de almacenes";

    fields
    {
        field(1; Grupo; Code[10])
        {
        }
        field(2; "Descripción"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; Grupo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        TextL001: Label 'No podemos eliminar el grupo ya que está definido en la tabla de almacenes x grupo';
        lrAxG: Record "Almacenes x Grupo";
    begin
        lrAxG.Reset;
        lrAxG.SetRange(Grupo, Grupo);
        if lrAxG.Count > 0 then
            Error(TextL001);
    end;
}

