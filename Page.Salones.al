page 76382 Salones
{
    ApplicationArea = all;
    Caption = 'Classroom';
    DataCaptionFields = "Tipo registro";
    PageType = List;
    SourceTable = "Datos adicionales RRHH";
    SourceTableView = WHERE ("Tipo registro" = CONST ("Salón"));

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

