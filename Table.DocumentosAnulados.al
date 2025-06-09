table 56074 "Documentos Anulados"
{
    // #42986  Almacenamiento de los documentos anulados


    fields
    {
        field(1; "Codigo Documento"; Code[2])
        {
            NotBlank = true;

            trigger OnValidate()
            var
                Error001: Label 'Codigo no válido. Los codigos permitidos son:  1 (Factura),  3 (Liquidación de compras),  4 (Nota de crédito),  7 (retención).';
            begin
                if "Codigo Documento" <> '' then
                    if not ("Codigo Documento" in ['1', '3', '4', '7']) then
                        Error(Error001);
            end;
        }
        field(2; "Número Establecimiento"; Code[3])
        {
            NotBlank = true;
        }
        field(3; "Número Punto Emisión"; Code[3])
        {
            NotBlank = true;
        }
        field(4; "Número Comprobante"; Code[9])
        {
            NotBlank = true;
        }
        field(5; "Número Autorización"; Code[49])
        {
            NotBlank = true;
        }
        field(6; "Fecha anulación"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Número Establecimiento", "Número Punto Emisión", "Número Comprobante")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

