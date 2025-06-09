report 55000 "Historico Retenciones Validas"
{
    // .
    DefaultLayout = RDLC;
    RDLCLayout = './HistoricoRetencionesValidas.rdlc';


    dataset
    {
        dataitem("Historico Retencion Prov."; "Historico Retencion Prov.")
        {
            DataItemTableView = SORTING("Tipo documento", "No. documento", "Código Retención") WHERE(Anulada = FILTER(false));
            RequestFilterFields = "Fecha Registro";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column("Historico_Retencion_Prov___Cód__Proveedor_"; "Cód. Proveedor")
            {
            }
            column("Historico_Retencion_Prov___Código_Retención_"; "Código Retención")
            {
            }
            column("Historico_Retencion_Prov___Base_Cálculo_"; "Base Cálculo")
            {
            }
            column("Historico_Retencion_Prov___Importe_Retención_"; "Importe Retención")
            {
            }
            column("Historico_Retencion_Prov___Tipo_Retención_"; "Tipo Retención")
            {
            }
            column(Historico_Retencion_Prov___Retencion_IVA_; "Retencion IVA")
            {
            }
            column(Historico_Retencion_Prov___No__documento_; "No. documento")
            {
            }
            column(Historico_Retencion_Prov___Importe_Retenido_; "Importe Retenido")
            {
            }
            column(Historico_Retencion_Prov___Fecha_Registro_; "Fecha Registro")
            {
            }
            column(Historico_Retencion_Prov__NCF; NCF)
            {
            }
            column(Historico_Retencion_Prov___Importe_Base_Retencion_; "Importe Base Retencion")
            {
            }
            column(Historico_Retencion_Prov__Anulada; Anulada)
            {
            }
            column(Historico_Retencion_Prov___Fecha_Impresion_; "Fecha Impresion")
            {
            }
            column(Historico_Retencion_Prov___No__autorizacion_NCF_; "No. autorizacion NCF")
            {
            }
            column(Historico_Retencion_Prov___Punto_Emision_; "Punto Emision")
            {
            }
            column(Historico_Retencion_Prov__Establecimiento; Establecimiento)
            {
            }
            column(Posted_Vendor_RententionCaption; Posted_Vendor_RententionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Historico_Retencion_Prov___Cód__Proveedor_Caption"; FieldCaption("Cód. Proveedor"))
            {
            }
            column("Historico_Retencion_Prov___Código_Retención_Caption"; FieldCaption("Código Retención"))
            {
            }
            column("Historico_Retencion_Prov___Base_Cálculo_Caption"; FieldCaption("Base Cálculo"))
            {
            }
            column(RetencionCaption; RetencionCaptionLbl)
            {
            }
            column("Historico_Retencion_Prov___Tipo_Retención_Caption"; FieldCaption("Tipo Retención"))
            {
            }
            column(Historico_Retencion_Prov___Retencion_IVA_Caption; FieldCaption("Retencion IVA"))
            {
            }
            column(Historico_Retencion_Prov___No__documento_Caption; FieldCaption("No. documento"))
            {
            }
            column(Historico_Retencion_Prov___Importe_Retenido_Caption; FieldCaption("Importe Retenido"))
            {
            }
            column(Historico_Retencion_Prov___Fecha_Registro_Caption; FieldCaption("Fecha Registro"))
            {
            }
            column(No__ComprobanteCaption; No__ComprobanteCaptionLbl)
            {
            }
            column(Historico_Retencion_Prov___Importe_Base_Retencion_Caption; FieldCaption("Importe Base Retencion"))
            {
            }
            column(Historico_Retencion_Prov__AnuladaCaption; FieldCaption(Anulada))
            {
            }
            column(Historico_Retencion_Prov___Fecha_Impresion_Caption; FieldCaption("Fecha Impresion"))
            {
            }
            column(Historico_Retencion_Prov___No__autorizacion_NCF_Caption; FieldCaption("No. autorizacion NCF"))
            {
            }
            column(Historico_Retencion_Prov___Punto_Emision_Caption; FieldCaption("Punto Emision"))
            {
            }
            column(Historico_Retencion_Prov__EstablecimientoCaption; FieldCaption(Establecimiento))
            {
            }
            column(Historico_Retencion_Prov__Tipo_documento; "Tipo documento")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Tipo documento" = "Tipo documento"::"Credit Memo" then begin
                    PCMH.Get("No. Documento Mov. Proveedor");
                    if PCMH.Correction then
                        CurrReport.Skip;
                end
                else begin
                    PIH.Get("No. Documento Mov. Proveedor");
                    //Facturas que han sido liquidades con con Notas de credito de correccion
                    VLE.Reset;
                    VLE.SetCurrentKey("Document Type", "Vendor No.", "Posting Date", "Currency Code");
                    VLE.SetRange("Document Type", VLE."Document Type"::Invoice);
                    VLE.SetRange("Vendor No.", PIH."Pay-to Vendor No.");
                    VLE.SetRange("Posting Date", PIH."Posting Date");
                    VLE.SetRange("Document No.", PIH."No.");
                    if VLE.FindFirst then begin
                        //Si la factura esta cerrada
                        if VLE."Closed by Entry No." <> 0 then begin
                            VLE1.Get(VLE."Closed by Entry No.");
                            if VLE1."Document Type" = VLE1."Document Type"::"Credit Memo" then begin
                                PCMH.Get(VLE1."Document No.");
                                if PCMH.Correction then
                                    CurrReport.Skip;
                            end;
                        end
                        else begin
                            VLE1.Reset;
                            VLE1.SetCurrentKey("Closed by Entry No.");
                            VLE1.SetRange("Closed by Entry No.", VLE."Entry No.");
                            VLE1.SetRange("Document Type", VLE1."Document Type"::"Credit Memo");
                            if VLE1.FindFirst then begin
                                PCMH.Get(VLE1."Document No.");
                                if PCMH.Correction then
                                    CurrReport.Skip;
                            end;
                        end;
                    end;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PCMH: Record "Purch. Cr. Memo Hdr.";
        VLE: Record "Vendor Ledger Entry";
        VLE1: Record "Vendor Ledger Entry";
        PIH: Record "Purch. Inv. Header";
        Posted_Vendor_RententionCaptionLbl: Label 'Posted Vendor Rentention';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        RetencionCaptionLbl: Label '% Retencion';
        No__ComprobanteCaptionLbl: Label 'No. Comprobante';
}

