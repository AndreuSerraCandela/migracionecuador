page 76360 "Prog. Visitas Asesor/Consultor"
{
    ApplicationArea = all;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Prog. Visitas Asesor/Consultor";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fecha Programada"; rec."Fecha Programada")
                {
                }
                field("Hora Inicio Programada"; rec."Hora Inicio Programada")
                {
                }
                field("Hora Fin Programada"; rec."Hora Fin Programada")
                {
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("Programación")
            {
                Caption = 'Programación';
                action(Asistencia)
                {
                    Caption = 'Asistencia';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Asis. Visitas Consultor/Asesor";
                    RunPageLink = "No. Visita" = FIELD("No. Visita"),
                                  "No. Linea Progr." = FIELD("No. Linea");
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

        wVisita := rec.GetFilter("No. Visita");

        if wVisita = '' then
            Error(Err001);

        CurrPage.Editable := false;
        if rVisita.Get(wVisita) then
            if rVisita.Estado = rVisita.Estado::Programada then
                CurrPage.Editable := true;
    end;

    var
        wVisita: Code[20];
        rVisita: Record "Cab. Visita Asesor/Consultor";
        Err001: Label 'No se ha definido la visita.';
}

