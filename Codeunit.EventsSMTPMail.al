codeunit 55028 "Events SMTP Mail"
{
    trigger OnRun()
    begin

    end;

    //Pendiente Validar que se mantenga la funcionalidad 
    //El cu 400 ya no existe 
    PROCEDURE CreateMessageBigBody(SenderName: Text[100]; SenderAddress: Text[50]; Recipients: Text[1024]; Subject: Text[200]; Body: BigText; HtmlFormatted: Boolean);
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        RecipientsList: List of [Text];
    BEGIN

        //+#842
        IF Recipients <> '' THEN
            SMTPMail.CheckValidEmailAddresses(Recipients);
        SMTPMail.CheckValidEmailAddresses(SenderAddress);
        /*SMTPMailSetup.GET;
        SMTPMailSetup.TESTFIELD("SMTP Server");
        IF NOT ISNULL(Mail) THEN BEGIN
            Mail.Dispose;
            CLEAR(Mail);
        END;
        SendResult := '';
        Mail := Mail.SmtpMessage;
        Mail.FromName := SenderName;
        Mail.FromAddress := SenderAddress;
        Mail."To" := Recipients;
        Mail.Subject := Subject;
        Mail.Body := FORMAT(Body);
        Mail.HtmlFormatted := HtmlFormatted;*/
        RecipientsList.Add(Recipients);
        EmailMessage.Create(RecipientsList, Subject, Format(Body), true);
        //Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    END;

    var
        SMTPMail: Codeunit "Mail Management";
}