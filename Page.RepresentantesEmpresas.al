page 76000 "Representantes Empresas"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'Company representatives';
    PageType = List;
    SourceTable = "Representantes Empresa";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Figurar; rec.Figurar)
                {
                }
                field("RNC/CED"; rec."RNC/CED")
                {
                }
                field(Nombre; rec.Nombre)
                {
                }
                field(Address; rec.Address)
                {
                }
                field("C.P."; rec."C.P.")
                {
                }
                field("Población"; rec.Población)
                {
                }
                field(County; rec.County)
                {
                }
                field("Teléfono"; rec.Teléfono)
                {
                }
                field("Job Title"; rec."Job Title")
                {
                }
            }
        }
    }

    actions
    {
    }
}

