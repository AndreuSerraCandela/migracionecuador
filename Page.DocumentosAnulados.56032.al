#pragma implicitwith disable
page 56032 "Documentos Anulados"
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

                    trigger OnValidate()
                    var
                        Err001: Label 'La fecha a digitar está fuera del periodo.';
                    begin
                        //+#45047
                        if (wFechaDesde <> 0D) and (wFechaHasta <> 0D) then
                            if (Rec."Fecha anulación" < wFechaDesde) or (Rec."Fecha anulación" > wFechaHasta) then
                                Error(Err001);
                        //-#45047
                    end;
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

    trigger OnOpenPage()
    var
        pgDialgo: Page "Seleccion periodo";
    begin

        //+#45047
        Rec.SetRange("Fecha anulación");
        Clear(pgDialgo);
        wFechaDesde := 0D;
        wFechaHasta := 0D;
        pgDialgo.LookupMode(true);
        if pgDialgo.RunModal = ACTION::LookupOK then begin
            pgDialgo.EnviaDatos(wFiltMes, wFiltAno);
            if (wFiltMes <> 0) and (wFiltAno <> 0) then begin
                wFechaDesde := DMY2Date(1, wFiltMes, wFiltAno);
                wFechaHasta := CalcDate('1M-1D', DMY2Date(1, wFiltMes, wFiltAno));
                Rec.FilterGroup(2);
                Rec.SetRange("Fecha anulación", wFechaDesde, wFechaHasta);
                Rec.FilterGroup(0);
            end;
        end;
        //-#45047
    end;

    var
        wFiltMes: Integer;
        wFiltAno: Integer;
        wFechaDesde: Date;
        wFechaHasta: Date;
}

#pragma implicitwith restore

