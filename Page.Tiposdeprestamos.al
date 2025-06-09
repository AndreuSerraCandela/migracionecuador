page 76419 "Tipos de prestamos"
{
    ApplicationArea = all;
    Caption = 'Loan types';
    DataCaptionFields = "Tipo registro";
    PageType = List;
    SourceTable = "Datos adicionales RRHH";
    SourceTableView = WHERE ("Tipo registro" = CONST ("Tipo de préstamo"));

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

