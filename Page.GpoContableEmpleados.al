page 76055 "Gpo. Contable Empleados"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Grupos Contables Empleados";

    layout
    {
        area(content)
        {
            repeater(Control1100000)
            {
                ShowCaption = false;
                field("Código"; rec.Código)
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
        area(processing)
        {
            action("&Setup")
            {
                Caption = '&Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Dist. Ctas. Gpo. Cont. Empl.";
                RunPageLink = "Código" = FIELD ("Código");
            }
        }
    }
}

