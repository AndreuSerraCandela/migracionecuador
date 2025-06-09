#pragma implicitwith disable
page 76207 "Estado Pago Expo. Eve. Planif."
{
    ApplicationArea = all;

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Cab. Planif. Evento";
    UsageCategory = Lists;

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
                field(wImporte; wImporte)
                {
                    Caption = 'Importe estimado s/ tarifa';
                    Editable = false;
                }
                field(Pagado; rec.Pagado)
                {
                    Editable = false;
                }
                field("Tipo Documento Pago"; rec."Tipo Documento Pago")
                {
                    Editable = false;
                }
                field("No. Documento Pago"; rec."No. Documento Pago")
                {
                    Editable = false;
                }
                field("Importe pago"; rec."Importe pago")
                {
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
        if Rec."No. Solicitud" <> '' then begin
            recCostos.SetRange("No. Solicitud", Rec."No. Solicitud");
        end
        else begin
            recCostos.SetRange("Cod. Taller - Evento", Rec."Cod. Taller - Evento");
            recCostos.SetRange("Tipo Evento", Rec."Tipo Evento");
            recCostos.SetRange(Expositor, Rec.Expositor);
            recCostos.SetRange(Secuencia, Rec.Secuencia);
        end;
        if recCostos.FindSet then
            repeat
                if recCostos.Porcentaje <> 0 then
                    wTextCostos := wTextCostos + recCostos.Código + ' (' + Format(recCostos.Porcentaje) + '%) ';
            until recCostos.Next = 0;

        wImporte := 0;
        wImporte := Rec.CalculaMonto();
    end;

    var
        wTextCostos: Text[150];
        wImporte: Decimal;
}

#pragma implicitwith restore

