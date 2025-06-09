codeunit 50300 "Notificar Errores Colas"
{
    // ---------------------------------
    // YFC     : Yefrecis Francisco Cruz
    // ------------------------------------------------------------------------
    // No.         Firma     Fecha            Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC      06/22/2020       SANTINAV-1458

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        ConfEmpresa.Get;

        ConfEmpresa.TestField("Email GD Local");
        ConfEmpresa.TestField("Email Soporte Funcional");
        ConfEmpresa.TestField("Email Encargado Proyecto");
        Rec.CalcFields("Object Caption to Run");
        /*   SendEmail(ConfEmpresa."Email GD Local", Error01 + ' ' + Rec."Object Caption to Run", Error02 + ' ' + Rec."Error Message");
          SendEmail(ConfEmpresa."Email Soporte Funcional", Error01 + ' ' + Rec."Object Caption to Run", Error02 + ' ' + Rec."Error Message");
          SendEmail(ConfEmpresa."Email Encargado Proyecto", Error01 + ' ' + Rec."Object Caption to Run", Error02 + ' ' + Rec."Error Message"); */
    end;

    var
        Doc: InStream;
        ConfEmpresa: Record "Config. Empresa";
        Error01: Label 'Error Cola Proyecto -';
        Error02: Label 'Error: ';
        CompanyInfo: Record "Company Information";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;

    [Scope('OnPrem')]
    procedure SendEmail(SendToAddress: Text[1024]; Subject: Text[200]; MessageBody: Text[1024])
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        CompanyInfo: Record "Company Information";
        RecipientType: Enum "Email Recipient Type";
    begin
        CompanyInfo.Get;

        EmailMessage.Create('', CompanyInfo.Name, Subject, false);
        EmailMessage.SetBody(MessageBody);
        EmailMessage.AddRecipient(RecipientType::"To", SendToAddress);

        Email.Send(EmailMessage);
    end;
}