page 76420 "Tipos de sangre"
{
    ApplicationArea = all;
    Caption = 'Blood types';
    DataCaptionFields = "Tipo registro";
    PageType = List;
    SourceTable = "Datos adicionales RRHH";
    SourceTableView = WHERE ("Tipo registro" = CONST ("Tipo de Sangre"));

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

