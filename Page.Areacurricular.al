page 76094 "Area curricular"
{
    ApplicationArea = all;
    Caption = 'Knowledge area';
    DataCaptionFields = "Tipo registro";
    PageType = List;
    SourceTable = "Datos adicionales RRHH";
    SourceTableView = WHERE ("Tipo registro" = CONST ("Area curricular"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; rec.Code)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }
}

