table 76021 Acciones
{
    Caption = 'Actions';

    fields
    {
        field(76046; "ID Accion"; Code[20])
        {
            Caption = 'Action ID';
            Description = 'DsPOS Standar';
            Editable = true;
            NotBlank = true;
        }
        field(76029; Descripcion; Text[250])
        {
            Caption = 'Description';
            Description = 'DsPOS Standar';
            Editable = true;
        }
        field(76011; "Tipo Accion"; Option)
        {
            Description = 'DsPOS Standar';
            Editable = true;
            OptionCaption = 'Action,Mandatory,Line Action';
            OptionMembers = "Acción",Obligatoria,"Acción Línea";
        }
        field(76016; "Necesita Datos"; Boolean)
        {
            Description = 'DsPOS Standar';
            Editable = true;
        }
        field(76018; "Tipo Datos"; Option)
        {
            Description = 'DsPOS Standar';
            Editable = true;
            OptionMembers = ,Numerico,Texto;
        }
        field(76015; "Literal Pedir Datos"; Text[75])
        {
            Description = 'DsPOS Standar';
            Editable = true;

            trigger OnValidate()
            begin
                if "Necesita Datos" and ("Literal Pedir Datos" = '') then
                    Error(Error002);
            end;
        }
    }

    keys
    {
        key(Key1; "ID Accion")
        {
            Clustered = true;
        }
        key(Key2; "Tipo Accion")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "ID Accion", Descripcion)
        {
        }
    }

    trigger OnDelete()
    begin
        Error(Error001);
    end;

    var
        Error001: Label 'Imposible Borrar Acciones';
        Error002: Label 'Debe Especificar un Literal para la ventana de petición de datos';
}

