codeunit 55047 "Serv-Documents Mgt.Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Serv-Documents Mgt.", 'OnBeforeModifyServiceDocNoSeries', '', false, false)]
    local procedure OnBeforeModifyServiceDocNoSeries(var ServHeader: Record "Service Header"; PServHeader: Record "Service Header"; ModifyHeader: Boolean)
    var
        NoSeriesMgt: Codeunit "No. Series";
        CustPostingGr: Record "Customer Posting Group";
        LinSerie: Record "No. Series Line";
        cuLocalizacion: Codeunit "Validaciones Localizacion";
        Err0016: Label '%1 no puede ser posterior a %2 del numerador de NCF, los valores correspondientes son %3 y %4', Comment = 'DSLoc';
    begin
        // DSLoc1.01 To assign the NCF Number
        if ((ServHeader."Document Type" = ServHeader."Document Type"::Invoice) and (ServHeader."Posting No." = '')) then begin
            if (ServHeader."No. Series" <> ServHeader."Posting No. Series") or (ServHeader."Document Type" = ServHeader."Document Type"::Order) then begin

                CustPostingGr.Get(ServHeader."Customer Posting Group");
                if CustPostingGr."Permite emitir NCF" then begin
                    ServHeader.TestField("VAT Registration No."); // DSLoc1.01 This is a requested field for the NCF

                    ServHeader.TestField("Payment Method Code");
                    ServHeader.TestField("Transaction Type");

                    if ServHeader."No. Comprobante Fiscal" = '' then begin
                        if ServHeader."Document Type" in [ServHeader."Document Type"::Order, ServHeader."Document Type"::Invoice] then
                            ServHeader.TestField("No. Serie NCF Facturas")
                        else
                            if ServHeader."Document Type" = ServHeader."Document Type"::"Credit Memo" then
                                ServHeader.TestField("No. Serie NCF Abonos");

                        // DSLoc1.04 ++
                        if ServHeader."Tipo de ingreso" = '' then
                            ServHeader."Tipo de ingreso" := '01';

                        LinSerie.Reset();
                        if ServHeader."Document Type" in [ServHeader."Document Type"::Order, ServHeader."Document Type"::Invoice] then
                            LinSerie.SetRange("Series Code", ServHeader."No. Serie NCF Facturas")
                        else
                            if ServHeader."Document Type" = ServHeader."Document Type"::"Credit Memo" then
                                LinSerie.SetRange("Series Code", ServHeader."No. Serie NCF Abonos");

                        LinSerie.SetFilter("Starting Date", '>=%1', DMY2Date(1, 5, 2018));
                        LinSerie.SetRange(Open, true);
                        LinSerie.FindFirst();

                        if (ServHeader."Posting Date" > LinSerie."Expiration date") and (LinSerie."Expiration date" <> 0D) then
                            Error(Err0016, ServHeader.FieldCaption("Posting Date"), LinSerie.FieldCaption("Expiration date"),
                                ServHeader."Posting Date", LinSerie."Expiration date");

                        if ServHeader."No. Comprobante Fiscal" = '' then
                            ServHeader."Fecha vencimiento NCF" := LinSerie."Expiration date";

                        if (ServHeader."Document Type" in [ServHeader."Document Type"::Order, ServHeader."Document Type"::Invoice]) and (ServHeader."No. Comprobante Fiscal" = '') then
                            ServHeader."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(ServHeader."No. Serie NCF Facturas", ServHeader."Posting Date", true)
                        else
                            if ServHeader."No. Comprobante Fiscal" = '' then
                                ServHeader."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(ServHeader."No. Serie NCF Abonos", ServHeader."Posting Date", true);

                        if (CopyStr(ServHeader."No. Comprobante Fiscal", 2, 2) <> '02') and (CopyStr(ServHeader."No. Comprobante Fiscal", 2, 2) <> '04') then
                            ServHeader.TestField("Fecha vencimiento NCF");

                        if ServHeader."No. Comprobante Fiscal" <> '' then
                            cuLocalizacion.ValidaExisteServ(ServHeader, ServHeader."No. Comprobante Fiscal");
                    end;
                end;

                ModifyHeader := true;
            end;
        end;
        // DSLoc1.01 For the NCF Number--
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Serv-Documents Mgt.", 'OnAfterPostDocumentLines', '', false, false)]
    local procedure OnAfterPostDocumentLinesHandler(var ServHeader: Record "Service Header"; var ServInvHeader: Record "Service Invoice Header"; var ServInvLine: Record "Service Invoice Line"; var ServCrMemoHeader: Record "Service Cr.Memo Header"; var ServCrMemoLine: Record "Service Cr.Memo Line"; GenJnlLineDocNo: Code[20]);
    begin
        if ServHeader."Document Type" = ServHeader."Document Type"::Invoice then begin
            ServHeader."No. Comprobante Fiscal" := '';//DSLoc1.01
            ServHeader."Fecha vencimiento NCF" := 0D;//DSLoc1.01
            ServHeader.Modify();
        end;
    end;
}
