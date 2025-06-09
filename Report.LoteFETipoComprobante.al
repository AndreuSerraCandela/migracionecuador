report 55043 "Lote FE Tipo Comprobante"
{
    // LDP         : Luis Jose De La Cruz
    // ------------------------------------------------------------------------
    // No.         Firma     Fecha            Descripcion
    // ------------------------------------------------------------------------
    // 001         LDP      03/08/2024      SANTINAV-6369: Autorizaciones automáticas - Separar

    ApplicationArea = Basic, Suite;
    Caption = 'Procesa Lote FE Por Tipo Comprobante';
    ProcessingOnly = true;
    UsageCategory = Administration;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Lote FE Tipos Comprobantes")
                {
                    field("Tipo de comprobante a procesar"; TipoComprobate)
                    {
                    ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin

        lrParLoteFE.Reset;
        lrParLoteFE.SetRange("Tipo comprobante", lrParLoteFE."Tipo comprobante"::" ");
        lrParLoteFE.SetRange("No. comprobante", '');
        lrParLoteFE.SetFilter("Tipo comprobante Manual", '<>%1', lrParLoteFE."Tipo comprobante Manual"::" ");
        if lrParLoteFE.FindSet then
            lrParLoteFE.DeleteAll;


        // Mensaje de confirmación

        // Mostrar confirmación al usuario
        Confirmacion := Confirm(Mensaje, false);

        if Confirmacion then begin

            //Procesa los documentos
            //MESSAGE('Procesando los documentos...');
            lrParLoteFE.Reset;
            lrParLoteFE."Tipo comprobante Manual" := TipoComprobate;
            lrParLoteFE.Insert;
            ProcesaloteFExComprobantes.Run(lrParLoteFE);
            //Procesa los documentos
            Message('El proceso ha finalizado.');
        end else begin
            Message('El proceso ha sido cancelado.');
        end;
    end;

    var
        TipoComprobate: Option " ","Factura Venta","Nota Credito","Remision Venta","Remision Transferencia","Retencion Factura","Retencion Nota Credito";
        ProcesaloteFExComprobantes: Codeunit "Procesa lote FE x Comprobantes";
        lrParLoteFE: Record "Parametros lote FE";
        Confirmacion: Boolean;
        Mensaje: Label 'All documents of the receipt type %1 will be processed. Do you want to continue?';
}

