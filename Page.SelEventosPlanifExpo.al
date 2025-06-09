page 76390 "Sel. Eventos Planif. - Expo"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Cab. Planif. Evento";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Expositor; rec.Expositor)
                {
                    Editable = false;
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                    Editable = false;
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                    Editable = false;
                }
                field("Cod. Taller - Evento"; rec."Cod. Taller - Evento")
                {
                    Editable = false;
                }
                field("Description Taller"; rec."Description Taller")
                {
                    Editable = false;
                }
                field(Secuencia; rec.Secuencia)
                {
                    Editable = false;
                }
                field(wTextCostos; wTextCostos)
                {
                    Caption = 'Centro Costos';
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part("Programación"; "Consulta Progr. Taller y Eve.")
            {
                Caption = 'Programación';
                Editable = false;
                SubPageLink = "Cod. Taller - Evento" = FIELD("Cod. Taller - Evento"),
                              "Tipo Evento" = FIELD("Tipo Evento"),
                              "Tipo de Expositor" = FIELD("Tipo de Expositor"),
                              Expositor = FIELD(Expositor),
                              Secuencia = FIELD(Secuencia);
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        recCostos: Record "Dis. Centros Costo";
    begin
        wTextCostos := '';
        if rec."No. Solicitud" <> '' then begin
            recCostos.SetRange("No. Solicitud", rec."No. Solicitud");
        end
        else begin
            recCostos.SetRange("Cod. Taller - Evento", rec."Cod. Taller - Evento");
            recCostos.SetRange("Tipo Evento", rec."Tipo Evento");
            recCostos.SetRange(Expositor, rec.Expositor);
            recCostos.SetRange(Secuencia, rec.Secuencia);
        end;
        if recCostos.FindSet then
            repeat
                if recCostos.Porcentaje <> 0 then
                    wTextCostos := wTextCostos + recCostos.Código + ' (' + Format(recCostos.Porcentaje) + '%) ';
            until recCostos.Next = 0;
    end;

    trigger OnOpenPage()
    begin
        rec.SetFilter(Estado, '<>%1', rec.Estado::Anulado);
        rec.SetRange(Pagado, false);
    end;

    var
        wTextCostos: Text[150];
}

