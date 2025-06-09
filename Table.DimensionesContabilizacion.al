table 76036 "Dimensiones Contabilizacion"
{

    fields
    {
        field(1; "Cod. Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(2; Orden; Integer)
        {
        }
        field(3; Descripcion; Text[100])
        {
            CalcFormula = Lookup(Dimension.Description WHERE(Code = FIELD("Cod. Dimension")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Requerida; Boolean)
        {
            Caption = 'Requested';
        }
        field(5; "Validar en"; Option)
        {
            OptionCaption = ' ,Empleados,Conceptos';
            OptionMembers = " ",Empleados,Conceptos;
        }
    }

    keys
    {
        key(Key1; "Cod. Dimension")
        {
            Clustered = true;
        }
        key(Key2; Orden)
        {
        }
    }

    fieldgroups
    {
    }
}

