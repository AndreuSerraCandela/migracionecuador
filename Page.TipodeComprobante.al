page 55002 "Tipo de Comprobante"
{
    ApplicationArea = all;
    Caption = 'Voucher Type';
    PageType = List;
    SourceTable = "SRI - Tabla Parametros";
    SourceTableView = SORTING ("Tipo Registro", Code)
                      ORDER(Ascending)
                      WHERE ("Tipo Registro" = FILTER ("TIPOS COMPROBANTES AUTORIZADOS"));

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

