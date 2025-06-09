page 76383 "Seguimiento Solicitud TE"
{
    ApplicationArea = all;
    // ,

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Seguimiento Solicitud TE";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Cambio"; rec."No. Cambio")
                {
                }
                field(Status; rec.Status)
                {
                }
                field(Fecha; rec.Fecha)
                {
                }
                field(Hora; rec.Hora)
                {
                }
                field(Usuario; rec.Usuario)
                {
                }
                field(wComentario; wComentario)
                {
                    Caption = 'Comentario';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        rSolicitud: Record "Solicitud de Taller - Evento";
    begin

        Clear(wComentario);
        rSolicitud.Get(rec."No. Solicitud");
        case rec.Status of
            rec.Status::"Enviada por promotor":
                wComentario := rSolicitud.Observaciones;
            rec.Status::Aprobada:
                wComentario := rSolicitud."Comentario Aprobado";
            rec.Status::Programada:
                wComentario := rSolicitud."Comentario Programado";
            rec.Status::Cancelada:
                wComentario := rSolicitud."Comentario Cancelado";
            rec.Status::Rechazada:
                wComentario := rSolicitud."Comentario Rechazado";
        end;
    end;

    var
        wComentario: Text[150];
}

