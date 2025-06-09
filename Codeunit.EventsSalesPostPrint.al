codeunit 55018 "Events Sales-Post + Print"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRun()
    begin
        //005
        ConfigSantillana.GET; //Originalmente esta línea no existía solo la comentada pero creo que debe ir afuera del if
        IF ConfigSantillana."Funcionalidad FE Activa" THEN BEGIN
            //ConfigSantillana.GET;
            ConfigSantillana.TESTFIELD("Reporte Factura Resguardo");
            ConfigSantillana.TESTFIELD("Reporte Factura Fact. Elect.");
            ConfigSantillana.TESTFIELD("Reporte NC Resguardo");
            ConfigSantillana.TESTFIELD("Reporte NC Elect.");
        END;
        //005
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforeGetReport', '', false, false)]
    local procedure OnBeforeGetReport(var SalesHeader: Record "Sales Header")
    begin
        //005
        ConfigSantillana.GET;
        IF ConfigSantillana."Funcionalidad FE Activa" THEN
            FE(SalesHeader);
        //005
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforePrintInvoice', '', false, false)]
    local procedure OnBeforePrintInvoice(var SalesHeader: Record "Sales Header"; SendReportAsEmail: Boolean; var IsHandled: Boolean)
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        if SalesHeader."Last Posting No." = '' then
            SalesInvHeader."No." := SalesHeader."No."
        else
            SalesInvHeader."No." := SalesHeader."Last Posting No.";
        SalesInvHeader.Find();
        SalesInvHeader.SetRecFilter();

        if SendReportAsEmail then
            SalesInvHeader.EmailRecords(true)
        else
        //+
        begin
            ConfigSantillana.GET;
            IF ConfigSantillana."Funcionalidad Imp. Fiscal Act." THEN begin
                SalesInvHeader.CALCFIELDS("Amount Including VAT");
                IF SalesInvHeader."Amount Including VAT" = 0 THEN begin
                    ConfigSantillana.TESTFIELD("Impresion Muestras");
                    REPORT.RUN(ConfigSantillana."Impresion Muestras", FALSE, FALSE, SalesInvHeader);
                end ELSE
                    SalesInvHeader.PrintRecords(FALSE);
            end;
        end;
        //-

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforePrintShip', '', false, false)]
    local procedure OnBeforePrintShip(var SalesHeader: Record "Sales Header"; SendReportAsEmail: Boolean; var IsHandled: Boolean)
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        SalesShptHeader."No." := SalesHeader."Last Shipping No.";
        if SalesShptHeader.Find() then;
        SalesShptHeader.SetRecFilter();

        if SendReportAsEmail then
            SalesShptHeader.EmailRecords(true)
        else
        //004+
        BEGIN
            ConfigSantillana.GET();
            rConfTPV.GET;
            IF (NOT SalesHeader."Pedido Consignacion") THEN
              //004
              BEGIN
                ConfigSantillana.GET;
                IF ConfigSantillana."Imprimir Remision Venta" THEN
                    SalesShptHeader.PrintRecords(FALSE);
            END;
        END;
        //004-

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforePrintCrMemo', '', false, false)]
    local procedure OnBeforePrintCrMemo(var SalesHeader: Record "Sales Header"; SendReportAsEmail: Boolean; var IsHandled: Boolean)
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if SalesHeader."Last Posting No." = '' then
            SalesCrMemoHeader."No." := SalesHeader."No."
        else
            SalesCrMemoHeader."No." := SalesHeader."Last Posting No.";
        SalesCrMemoHeader.Find();
        SalesCrMemoHeader.SetRecFilter();

        if SendReportAsEmail then
            SalesCrMemoHeader.EmailRecords(true)
        else
        //005 El tipo de resolucion es que decide que formato impreso se va a utilizar
        BEGIN
            ConfigSantillana.GET;
            IF ConfigSantillana."Funcionalidad FE Activa" THEN BEGIN
                IF SalesCrMemoHeader.CAE <> '' THEN
                    REPORT.RUN(ConfigSantillana."Reporte NC Elect.", FALSE, FALSE, SalesCrMemoHeader);
                IF SalesCrMemoHeader.CAEC <> '' THEN
                    REPORT.RUN(ConfigSantillana."Reporte NC Resguardo", FALSE, FALSE, SalesCrMemoHeader);
                IF (SalesCrMemoHeader.CAE = '') AND (SalesCrMemoHeader.CAEC = '') AND (SalesCrMemoHeader."Posting Date" < 20030112D) THEN //Pendiente validar la fecha valor original 030112D
                    REPORT.RUN(ConfigSantillana."Reporte NC Resguardo", FALSE, FALSE, SalesCrMemoHeader);
            END
            ELSE
                SalesCrMemoHeader.PrintRecords(FALSE);
        END;
        //005 El tipo de resolucion es que decide que formato impreso se va a utilizar

        IsHandled := true;
    end;

    PROCEDURE FE(SalesHeader: Record "Sales Header");
    VAR
        cuFE: Codeunit "Factura Electronica";
        txtResp: ARRAY[7] OF Text[1024];
        rSIH: Record "Sales Invoice Header";
        NoFactReg: Code[20];
        rSCMH: Record "Sales Cr.Memo Header";
    BEGIN
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN BEGIN
            IF rSIH.GET(SalesHeader."Last Posting No.") THEN
                cuFE.Factura(rSIH);
        END;

        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") OR
          (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") AND (NOT SalesHeader.Correction) THEN BEGIN
            IF rSCMH.GET(SalesHeader."Last Posting No.") THEN
                cuFE.NotaCR(rSCMH);
        END;
    END;

    var
        //Traducción PostAndEmailQst en frances
        ConfigSantillana: Record "Config. Empresa";
        rTPV: Record Tiendas;
        I: Integer;
        rConfTPV: Record "Configuracion General DsPOS";
        rNoSeriesLine: Record "No. Series Line";
        rSIH: Record "Sales Invoice Header";
        rSCMH: Record "Sales Cr.Memo Header";

    /*    
  DSLoc1.01   GRN     09/01/2009    Para adicionar funcionalidad de Retenciones y NCF

  //004       AMS     29/07/2011    Para evitar la impresion de conduce de envio en caso de que sea un pedido consignacion.

  //005       AMS     27/02/2012    Factura Electronica Gautemala

  //006       AMS     07/08/12      Funcionalidad impresora Fiscal
    */

}