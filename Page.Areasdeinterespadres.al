page 76097 "Areas de interes padres"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Areas de interes padres";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("DNI Padre"; rec."DNI Padre")
                {
                    Visible = false;
                }
                field("Cod. Area Interes"; rec."Cod. Area Interes")
                {
                }
                field("Nombre Padre"; rec."Nombre Padre")
                {
                    Editable = false;
                }
                field("Descripcion Area Interes"; rec."Descripcion Area Interes")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

