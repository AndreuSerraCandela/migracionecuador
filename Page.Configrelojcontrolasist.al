page 76153 "Config. reloj control asist."
{
    ApplicationArea = all;
    Caption = 'Time and attendance clock setup';
    CardPageID = "Reloj control asist. Card";
    Editable = false;
    PageType = List;
    SourceTable = "Parametros Reloj Control Asist";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Clock ID"; rec."Clock ID")
                {
                }
                field(Description; rec.Description)
                {
                }
                field(Provider; rec.Provider)
                {
                }
                field("Data Source"; rec."Data Source")
                {
                }
                field("Initial Catalog"; rec."Initial Catalog")
                {
                }
                field(User; rec.User)
                {
                }
                field(Password; rec.Password)
                {
                    ExtendedDatatype = Masked;
                }
            }
        }
    }

    actions
    {
    }
}

