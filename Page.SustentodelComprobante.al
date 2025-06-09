page 55001 "Sustento del Comprobante"
{
    ApplicationArea = all;
    Caption = 'Vouchers Sustentations';
    PageType = List;
    SourceTable = "SRI - Tabla Parametros";
    SourceTableView = SORTING ("Tipo Registro", Code)
                      ORDER(Ascending)
                      WHERE ("Tipo Registro" = FILTER ("SUSTENTO DEL COMPROBANTE"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; rec.Code)
                {
                }
                field(Description; rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

