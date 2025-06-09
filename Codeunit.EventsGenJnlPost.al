codeunit 55022 "Events Gen. Jnl.-Post"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnCodeOnBeforeConfirmPostJournalLinesResponse', '', false, false)]
    local procedure OnCodeOnBeforeConfirmPostJournalLinesResponse(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
        //003
        IF GenJournalLine."Caja Chica" THEN BEGIN
            IF UserSetUp.GET(USERID) THEN BEGIN
                IF NOT UserSetUp."Registra Diario Caja Chica" THEN
                    ERROR(Error004);
            END
            ELSE
                ERROR(Error004);

            //+43088
            GenJournalLine.TESTFIELD("Tipo de Identificador");
            GenJournalLine.TESTFIELD("Pago a");
            //+43088

            SRIParam.RESET;
            SRIParam.GET(1, GenJournalLine."Tipo de Comprobante");
            IF NOT SRIParam."No Aplica SRI" THEN BEGIN
                GenJournalLine.TESTFIELD("RUC/Cedula");
                GenJournalLine.TESTFIELD("Tipo de Comprobante");
                GenJournalLine.TESTFIELD("Sustento del Comprobante");
                GenJournalLine.TESTFIELD("No. Autorizacion Comprobante");
                GenJournalLine.TESTFIELD(Establecimiento);
                GenJournalLine.TESTFIELD("Punto de Emision");
                GenJournalLine.TESTFIELD("Fecha Caducidad");
                GenJournalLine.TESTFIELD("Cod. Retencion");
            END;
        END;
        //003

        //001
        rGenJoBatch.RESET;
        rGenJoBatch.SETRANGE(rGenJoBatch."Journal Template Name", GenJournalLine."Journal Template Name");
        rGenJoBatch.SETRANGE(rGenJoBatch.Name, GenJournalLine."Journal Batch Name");
        IF rGenJoBatch.FIND('-') THEN
            IF rGenJoBatch."Seccion POS" THEN
                IsHandled := true;
        //001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeShowPostResultMessage', '', false, false)]
    local procedure OnBeforeShowPostResultMessage(var GenJnlLine: Record "Gen. Journal Line"; TempJnlBatchName: Code[10]; var IsHandled: Boolean)
    var
        Text002: Label 'There is nothing to post.';//ESM=No hay nada que registrar.;FRC=Il n''y a rien … reporter.;ENC=There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';//ESM=Se han registrado correctamente las l¡neas del diario.;FRC=Les lignes de journal ont ‚t‚ report‚es avec succŠs.;ENC=The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. You are now in the %1 journal.';//ESM=Se registraron correctamente las l¡neas diario. Se encuentra en el diario %1.;FRC=Les lignes du journal ont ‚t‚ report‚es correctement. Vous ˆtes maintenant dans le journal %1.;ENC=The journal lines were successfully posted. You are now in the %1 journal.';
    begin
        IF GenJnlLine."Line No." = 0 THEN
            MESSAGE(Text002)
        ELSE BEGIN //001
            //001
            IF NOT rGenJoBatch."Seccion POS" THEN
                //001
                IF TempJnlBatchName = GenJnlLine."Journal Batch Name" THEN
                    MESSAGE(Text003)
                ELSE
                    MESSAGE(
                      Text004,
                      GenJnlLine."Journal Batch Name");
        END; //001

        IsHandled := true;
    end;



    var
        //Traducción Frances Label Text002
        rGenJoBatch: Record "Gen. Journal Batch";
        SRIParam: Record "SRI - Tabla Parametros";
        UserSetUp: Record "User Setup";
        Error004: Label 'User cannot insert Pretty Cash Section';//ESM=Usuario no tiene permiso para Registrar l¡neas de diario en una Seccion de Caja chica';

    /*

  AMS     : Agustin Mendez
  --------------------------------------------------------------------------
  No.     Fecha           Firma         Descripcion
  ---------------------------------------------------------------------------------
  001     11-Mayo-11      AMS           En caso de que el registro se haga desde una seccion POS
                                        el sistema obvia la confirmacion de registro.
  002     11-Mayo-11      AMS           En caso de que el registro se haga desde una seccion POS
                                        el sistema obvia la confirmacion de registro.
  003     08-Marz-13      AMS           Controles Caja Chica

  004     26/01/2016      CAT           Se controla el ingreso de los campos "Tipo de Identificador" y "Pago a" para Caja Chica
    */
}