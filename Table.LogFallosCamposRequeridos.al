table 58001 "Log Fallos Campos Requeridos"
{

    fields
    {
        field(2; Linea; Integer)
        {
        }
        field(3; Tabla; Option)
        {
            OptionMembers = Clientes,Proveedores,Activos,Productos,"Cuentas Banco",Zona,"Ubicación","Almacén";
        }
        field(4; Fallo; Text[250])
        {
        }
        field(5; "Nombe Activo"; Text[100])
        {
        }
        field(6; "Id Activo"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; Linea)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rLog: Record "Log Fallos Campos Requeridos";
    begin

        rLog.Reset;
        if rLog.FindLast then
            Linea := rLog.Linea + 1
        else
            Linea := 1;
    end;
}

