table 76144 "Seguim.Visita Asesor/Consultor"
{

    fields
    {
        field(1; "Visita Asesor/Consultor"; Code[20])
        {
        }
        field(2; "No. Cambio"; Integer)
        {
        }
        field(3; Estado; Option)
        {
            OptionMembers = Programada,Ejecutada;
        }
        field(4; Fecha; Date)
        {
        }
        field(5; Usuario; Code[50])
        {
        }
        field(6; Hora; Time)
        {
        }
    }

    keys
    {
        key(Key1; "Visita Asesor/Consultor", "No. Cambio")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure InsertarSeguimiento(parVisita: Record "Cab. Visita Asesor/Consultor")
    begin
        "Visita Asesor/Consultor" := parVisita."No. Visita Asesor/Consultor";
        Estado := parVisita.Estado;
        Fecha := WorkDate;
        Hora := Time;
        Usuario := UserId;
        Insert(true);
    end;
}

