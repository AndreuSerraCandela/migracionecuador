#pragma implicitwith disable
page 55029 "Documentos Anulados_"
{
    ApplicationArea = all;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Documentos Anulados";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fecha anulación"; rec."Fecha anulación")
                {
                    NotBlank = true;
                }
                field("Codigo Documento"; rec."Codigo Documento")
                {

                    trigger OnValidate()
                    var
                        Error001: Label 'Codigo no válido. Los codigos permitidos son:\  1 (Factura)\  3 (Liquidación de compras)\  4 (Nota de crédito)\  7 (retención)';
                    begin
                        if Rec."Codigo Documento" <> '' then
                            if not (Rec."Codigo Documento" in ['1', '3', '4', '7']) then
                                Error(Error001);
                    end;
                }
                field("Número Establecimiento"; rec."Número Establecimiento")
                {
                }
                field("Número Punto Emisión"; rec."Número Punto Emisión")
                {
                }
                field("Número Comprobante"; rec."Número Comprobante")
                {
                }
                field("Número Autorización"; rec."Número Autorización")
                {
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

