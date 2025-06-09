page 55000 "SRI - Tabla Parametros"
{
    ApplicationArea = all;
    Caption = 'SRI - Parameters';
    PageType = List;
    SourceTable = "SRI - Tabla Parametros";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo Registro"; rec."Tipo Registro")
                {
                }
                field("Code"; rec.Code)
                {
                }
                field(Description; rec.Description)
                {
                }
                field("Tipo Documento"; rec."Tipo Documento")
                {
                }
                field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
                {
                }
                field("No Aplica SRI"; rec."No Aplica SRI")
                {
                }
            }
        }
    }

    actions
    {
    }
}

