page 76423 "Visita A/C - Descr. Asistentes"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Visitas A/C - Descr. Asistente";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Codigo; rec.Codigo)
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        wVisita: Code[20];
        Err001: Label 'No se ha definido la visita.';
        rVisita: Record "Cab. Visita Asesor/Consultor";
    begin
        case rec.GetFilter(Tipo) of
            'Nivel':
                CurrPage.Caption := CaptionNivel;
            'Grado':
                CurrPage.Caption := CaptionGrado;
            'Especialidad':
                CurrPage.Caption := CaptionEspec;
        end;

        wVisita := rec.GetFilter("No. Visita");

        if wVisita = '' then
            Error(Err001);

        CurrPage.Editable := false;
        if rVisita.Get(wVisita) then
            if rVisita.Estado = rVisita.Estado::Programada then
                CurrPage.Editable := true;
    end;

    var
        CaptionNivel: Label 'Nivel Asistentes';
        CaptionGrado: Label 'Grado Asistentes';
        CaptionEspec: Label 'Especialidad Asistentes';
}

