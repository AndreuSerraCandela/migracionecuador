codeunit 55027 "Events FinChrgMemo-Issue"
{

    //Pendiente cambiar el filtro en línea 82-83 por 
    //IF (FinChrgMemoLine.Amount <> 0) AND "Post Additional Fee" THEN BEGIN

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FinChrgMemo-Issue", 'OnBeforeGenJnlPostLineRunWithCheck', '', false, false)]
    local procedure OnBeforeGenJnlPostLineRunWithCheck(var GenJournalLine: Record "Gen. Journal Line"; FinanceChargeMemoHeader: Record "Finance Charge Memo Header")
    var
        CustPostingGr: Record "Customer Posting Group";
        cuLocalizacion: Codeunit "Validaciones Localizacion";
        LinSerie: Record "No. Series Line";
        Err0016: Label '%1 can not be after %2 of the NCF serial no., corresponding values are %3 and %4';//ESP=%1 no puede ser posterior a %2 del numerador de NCF, los valores correspondientes son %3 y %4;ESM=%1 no puede ser posterior a %2 del numerador de NCF, los valores correspondientes son %3 y %4';
        Err0017: Label 'The %1 could not be generated, please retry Register Order.';//ESP=No se pudo generar el %1 favor volver a intentar Registrar Pedido.;ESM=No se pudo generar el %1 favor volver a intentar Registrar Pedido.';
    begin
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then begin //Pendiente validar que mantenga la misma funcionalidad
            // DSLoc1.04 ++
            CustPostingGr.GET(FinanceChargeMemoHeader."Customer Posting Group");
            IF CustPostingGr."Permite emitir NCF" THEN BEGIN

                FinanceChargeMemoHeader.TESTFIELD("No. Serie NCF Facturas");

                IF FinanceChargeMemoHeader."Tipo de ingreso" = '' THEN
                    FinanceChargeMemoHeader."Tipo de ingreso" := '01';
                LinSerie.RESET;
                LinSerie.SETCURRENTKEY("Starting Date");
                LinSerie.SETRANGE("Series Code", FinanceChargeMemoHeader."No. Serie NCF Facturas");
                LinSerie.SETFILTER("Expiration date", '>=%1|=%2', FinanceChargeMemoHeader."Posting Date", 0D); //05/08/2021 jpg para no seleccionar serie vencidas al dia de "Posting Date" o sin fecha
                LinSerie.SETFILTER("Starting Date", '>=%1', DMY2DATE(1, 5, 2018));
                LinSerie.SETRANGE(Open, TRUE);
                LinSerie.FINDFIRST;

                IF (FinanceChargeMemoHeader."Posting Date" > LinSerie."Expiration date") AND (LinSerie."Expiration date" <> 0D) THEN
                    ERROR(STRSUBSTNO(Err0016, FinanceChargeMemoHeader.FIELDCAPTION("Posting Date"), LinSerie.FIELDCAPTION("Expiration date"), FinanceChargeMemoHeader."Posting Date",
                    LinSerie."Expiration date"));

                IF FinanceChargeMemoHeader."No. Comprobante Fiscal" = '' THEN //jpg 03-06-2020 para que no tome otra fecha de otra secuencia si ya se asigno ncf anteriormente
                    FinanceChargeMemoHeader."Fecha vencimiento NCF" := LinSerie."Expiration date";

                IF (FinanceChargeMemoHeader."No. Comprobante Fiscal" = '') THEN
                    FinanceChargeMemoHeader."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(FinanceChargeMemoHeader."No. Serie NCF Facturas", FinanceChargeMemoHeader."Posting Date", TRUE);

                IF (COPYSTR(FinanceChargeMemoHeader."No. Comprobante Fiscal", 2, 2) <> '02') AND (COPYSTR(FinanceChargeMemoHeader."No. Comprobante Fiscal", 2, 2) <> '04')
                      AND (COPYSTR(FinanceChargeMemoHeader."No. Comprobante Fiscal", 2, 2) <> '12') THEN //05/08/2021 jpg
                    FinanceChargeMemoHeader.TESTFIELD("Fecha vencimiento NCF");

                IF (FinanceChargeMemoHeader."No. Comprobante Fiscal" = '') THEN //jpg 03-09-2020 validar ncf antes de asignar "Posting No." por si no genera el ncf
                    ERROR(STRSUBSTNO(Err0017, FinanceChargeMemoHeader.FIELDCAPTION("No. Comprobante Fiscal")));
            END;
            GenJournalLine."No. Comprobante Fiscal" := FinanceChargeMemoHeader."No. Comprobante Fiscal";
            GenJournalLine."Fecha vencimiento NCF" := FinanceChargeMemoHeader."Fecha vencimiento NCF";
            GenJournalLine."Tipo de ingreso" := FinanceChargeMemoHeader."Tipo de ingreso";
            GenJournalLine.Modify();
            // DSLoc1.04 --
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";

    /*
    //jpg DSLoc1.04  generar comprobante
    */
}