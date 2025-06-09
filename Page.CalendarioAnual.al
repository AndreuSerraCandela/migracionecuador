page 76124 "Calendario Anual"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = Calendario;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = true;
                ShowCaption = false;
                field(Fecha; rec.Fecha)
                {
                }
                field(Texto; rec.Texto)
                {
                }
                field("No laborable"; rec."No laborable")
                {
                }
                field(Semana; rec.Semana)
                {
                }
                field("Período"; rec.Período)
                {
                }
                field(Ano; rec.Ano)
                {
                }
                field(Mes; rec.Mes)
                {
                }
                field("Día de la semana"; rec."Día de la semana")
                {
                }
                field(Generado; rec.Generado)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Calendar")
            {
                Caption = '&Calendar';
                action("Generate calendar")
                {
                    Caption = 'Generate calendar';
                    Image = CalculateCalendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Copia-Mueve empleado Empresa";
                }
                action(Hollydays)
                {
                    Caption = 'Hollydays';
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Dias Fiestas";
                }
            }
        }
    }
}

