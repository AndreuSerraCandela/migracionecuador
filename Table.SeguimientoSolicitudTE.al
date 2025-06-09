table 76364 "Seguimiento Solicitud TE"
{

    fields
    {
        field(1; "No. Solicitud"; Code[20])
        {
        }
        field(2; "No. Cambio"; Integer)
        {
            Caption = 'No.';
        }
        field(3; Status; Option)
        {
            OptionCaption = ' ,Enviada por promotor,Aprobada,Programada,Cancelada,Rechazada,Realizada';
            OptionMembers = " ","Enviada por promotor",Aprobada,Programada,Cancelada,Rechazada,Realizada;
        }
        field(4; Fecha; Date)
        {
        }
        field(5; Usuario; Code[20])
        {
        }
        field(6; Hora; Time)
        {
        }
    }

    keys
    {
        key(Key1; "No. Solicitud", "No. Cambio")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        SegSol: Record "Seguimiento Solicitud TE";
    begin
        SegSol.SetRange("No. Solicitud", "No. Solicitud");
        if SegSol.FindLast then
            "No. Cambio" := SegSol."No. Cambio" + 1
        else
            "No. Cambio" := 1;
    end;


    procedure InsertarSeguimiento(parSolicitud: Record "Solicitud de Taller - Evento")
    begin
        "No. Solicitud" := parSolicitud."No. Solicitud";
        Status := parSolicitud.Status;
        Fecha := WorkDate;
        Hora := Time;
        Usuario := UserId;
        Insert(true);
    end;
}

