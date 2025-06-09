page 53001 "InicializaTablas Movs."
{
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(group)
            {
                Caption = 'group';
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000003>")
            {
                Caption = 'Initialize Entries';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Inic. Concepto Salarial";
            }
        }
    }
}

