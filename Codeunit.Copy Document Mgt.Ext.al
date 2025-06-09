codeunit 55048 "Copy Document Mgt. Ext"
{
    var
        NCCorrectiva: Boolean;

    // Detecta que la NC es correctiva (por valores únicos de la llamada desde SetPropertiesForCreditMemoCorrection)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterSetProperties', '', false, false)]
    local procedure OnAfterSetPropertiesHandler(var IncludeHeader: Boolean; var RecalculateLines: Boolean; var MoveNegLines: Boolean; var CreateToHeader: Boolean; var HideDialog: Boolean; var ExactCostRevMandatory: Boolean; var ApplyFully: Boolean)
    begin
        if IncludeHeader and HideDialog and ExactCostRevMandatory then
            NCCorrectiva := TRUE;//DSLoc1.04 creacion nc correctiva desde historial Factura
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopySalesDocOnAfterCopySalesDocLines', '', false, false)]
    local procedure ClearUpdateRetentionSalesLines(
        FromDocType: Option;
        FromDocNo: Code[20];
        FromDocOccurrenceNo: Integer;
        FromDocVersionNo: Integer;
        FromSalesHeader: Record "Sales Header";
        IncludeHeader: Boolean;
        var ToSalesHeader: Record "Sales Header";
        HideDialog: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", ToSalesHeader."Document Type");
        SalesLine.SetRange("Document No.", ToSalesHeader."No.");
        //SalesLine.SetFilter("Retention Attached to Line No.", '<>0');

        if SalesLine.FindSet() then
            repeat
                //SalesLine."Retention Attached to Line No." := 0;
                SalesLine.Modify();
            until SalesLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Copy Sales Document", 'OnValidateDocNoOnAfterTransferFieldsFromSalesCrMemoHeader', '', false, false)]
    local procedure OnBeforeUpdateSalesCreditMemoHeaderHandler(FromSalesHeader: Record "Sales Header")
    begin
        if NCCorrectiva then
            FromSalesHeader.Correction := NCCorrectiva;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeUpdatePurchCreditMemoHeader', '', false, false)]
    local procedure OnBeforeUpdatePurchCreditMemoHeaderHandler(var PurchaseHeader: Record "Purchase Header")
    begin
        if NCCorrectiva then
            PurchaseHeader.Correction := NCCorrectiva;
    end;

    procedure CopiarRetenciones(DocNo: Code[20]; DocType: Enum "Purchase Document Type"; DocNoOrigen: Code[20]; DocTypeOrigen: Enum "Purchase Document Type")
    var
        HistoricoRetencionProv: Record "Historico Retencion Prov.";
        RetencionDocProveedores: Record "Retencion Doc. Proveedores";
        DoctypeOption: Option;
    begin
        RetencionDocProveedores.Reset();
        RetencionDocProveedores.SetRange("Tipo documento", DocType);
        RetencionDocProveedores.SetRange("No. documento", DocNo);
        RetencionDocProveedores.DeleteAll();

        HistoricoRetencionProv.Reset();
        HistoricoRetencionProv.SetRange("Tipo documento", DocTypeOrigen);
        HistoricoRetencionProv.SetRange("No. documento", DocNoOrigen);
        if HistoricoRetencionProv.FindSet() then
            repeat
                Clear(RetencionDocProveedores);
                RetencionDocProveedores.TransferFields(HistoricoRetencionProv);
                RetencionDocProveedores."No. documento" := DocNo;
                RetencionDocProveedores."Tipo documento" := DocType;
                RetencionDocProveedores.Insert();
            until HistoricoRetencionProv.Next() = 0;
    end;



}
