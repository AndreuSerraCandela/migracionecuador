table 76125 "Cab. Dimensiones Requeridas"
{
    Caption = 'Required fields Header';

    fields
    {
        field(1; "No. Tabla"; Integer)
        {
            Caption = 'Table No.';
            NotBlank = true;
            /*          TableRelation = Object.ID WHERE (Type = FILTER (Table)); */
        }
        field(2; Nombre; Text[100])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table),
                                                                        "Object ID" = FIELD("No. Tabla")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; Activo; Boolean)
        {
            Caption = 'Active';
        }
    }

    keys
    {
        key(Key1; "No. Tabla")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        LinCampReq.Reset;
        LinCampReq.SetRange("No. Tabla", "No. Tabla");
        LinCampReq.DeleteAll;
    end;

    var
        LinCampReq: Record "Lin. Campos Req. Maestros";
}

