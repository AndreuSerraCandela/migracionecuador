page 76088 "Resumen Facturas de Consumo"
{
    ApplicationArea = all;
    Caption = 'Resumen General de Facturas de Consumo (F.C)';
    DataCaptionFields = "Codigo reporte";
    Description = 'Resumen General de Facturas de Consumo (F.C)';
    Editable = false;
    PageType = Card;
    SourceTable = "Archivo Transferencia ITBIS";
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(GENERAL)
            {
                field(CantidadNCF; rec.CantidadNCF)
                {
                }
                field(TotalMontoFacturado; rec.TotalMontoFacturado)
                {
                }
                field(TotalITBISFacturado; rec.TotalITBISFacturado)
                {
                }
                field(ImpuestoSelectivoAlConsumo; rec.ImpuestoSelectivoAlConsumo)
                {
                }
                field(TotalOtrosImpuestosTasas; rec.TotalOtrosImpuestosTasas)
                {
                }
                field(TotalMontoPropinaLegal; rec.TotalMontoPropinaLegal)
                {
                }
            }
            group("TIPO DE VENTAS")
            {
                field(MontoEfectivo; rec.MontoEfectivo)
                {
                }
                field(MontoChequeTransDeposito; rec.MontoChequeTransDeposito)
                {
                }
                field(MontoTarjeta; rec.MontoTarjeta)
                {
                }
                field(MontoCredito; rec.MontoCredito)
                {
                }
                field(MontoBonosCertificados; rec.MontoBonosCertificados)
                {
                }
                field(MontoPermuta; rec.MontoPermuta)
                {
                }
                field(MontoOtrasFormaVentas; rec.MontoOtrasFormaVentas)
                {
                }
            }
        }
    }

    actions
    {
    }
}

