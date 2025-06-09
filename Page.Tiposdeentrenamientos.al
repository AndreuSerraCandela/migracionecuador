page 76416 "Tipos de entrenamientos"
{
    ApplicationArea = all;
    Caption = 'Training types';
    DataCaptionFields = "Tipo registro";
    PageType = List;
    SourceTable = "Datos adicionales RRHH";
    SourceTableView = WHERE ("Tipo registro" = CONST ("Tipo Entrenamiento"));

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

