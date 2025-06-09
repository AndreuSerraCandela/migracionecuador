page 75010 "Conf. Campos Relacionados"
{
    ApplicationArea = all;
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'Conf. Related Fields';
    PageType = List;
    SourceTable = "Conf. Campos Relacionados";
    SourceTableView = SORTING("Id Fld Origen", "Valor Origen");
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; rec.Id)
                {
                    Visible = false;
                }
                field("Id Fld Origen"; rec."Id Fld Origen")
                {
                }
                field("GetNomCampo(0)"; rec.GetNomCampo(0))
                {
                    Caption = 'Nombre Campo Origen';
                }
                field("Valor Origen"; rec."Valor Origen")
                {
                }
                field("Id Fld Destino"; rec."Id Fld Destino")
                {
                }
                field("GetNomCampo(1)"; rec.GetNomCampo(1))
                {
                    Caption = 'Nombre Campo Destino';
                }
                field("Valor Destino"; rec."Valor Destino")
                {
                }
            }
        }
    }

    actions
    {
    }
}

