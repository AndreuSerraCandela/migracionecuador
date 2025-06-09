codeunit 56006 "SMTP Mail 4.X"
{
    Subtype = Normal;

    procedure SendEmail(
        FromAddress: Text;
        ToAddresses: List of [Text];
        Subject: Text;
        Body: Text;
        IsBodyHtml: Boolean;
        AttachmentFileName: Text; // nombre archivo adjunto
        AttachmentContent: InStream) // contenido adjunto
    var
        EmailMessage: Codeunit "Email Message";
        SMTPMail: Codeunit "Email";
    begin
        // Crear email, con parámetros: Destinatarios, Asunto, Remitente, y html?
        EmailMessage.Create(ToAddresses, Subject, FromAddress, IsBodyHtml);

        // Agregar cuerpo (solo 1 argumento, texto o html según IsBodyHtml)
        EmailMessage.SetBody(Body);

        // Agregar adjunto (nombre archivo y contenido InStream)
        if AttachmentFileName <> '' then
            EmailMessage.AddAttachment(AttachmentFileName, '', AttachmentContent);

        // Enviar email
        SMTPMail.Send(EmailMessage);
    end;
}
