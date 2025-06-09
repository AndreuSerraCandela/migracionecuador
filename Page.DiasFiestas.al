page 76174 "Dias Fiestas"
{
    ApplicationArea = all;
    AdditionalSearchTerms = 'Holidays';
    //ApplicationArea = Basic, Suite, BasicHR;
    Caption = 'Holidays';
    PageType = List;
    SourceTable = "Dias Festivos";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Fecha; rec.Fecha)
                {
                }
                field("Dia Semana"; rec."Dia Semana")
                {
                }
                field(Texto; rec.Texto)
                {
                }
                field(Mes; rec.Mes)
                {
                }
                field("Fecha original"; rec."Fecha original")
                {
                }
            }
        }
    }

    actions
    {
    }
}

