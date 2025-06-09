codeunit 76044 "Imprime en PDF"
{
    TableNo = "Historico Cab. nomina";

    trigger OnRun()
    begin
        ConfNominas.Get();
        GlobalRec := Rec;
        /* Code(); */
    end;

    var
        /*  SMTPSetup: Record "SMTP Mail Setup";
         SMTP: Codeunit "SMTP Mail"; */
        GlobalRec: Record "Historico Cab. nomina";
        Historico: Record "Historico Cab. nomina";
        Emp: Record Employee;
        ConfNominas: Record "Configuracion nominas";
        cuMail: Codeunit Mail;
        Counter: Integer;
        Path: Text[250];
        UseAttachment: Boolean;
        _ArchivoPDF: Text[150];
        _Directorio: Text[150];
        IDReporte: Integer;
        DefPrinter: Text[250];
        Asunto: Text[250];
        AttachmentFile: Text[250];
        MailSent: Boolean;
        Text001: Label 'period %1 to %2.';
        Dia_Pago: Label 'It''s Payday!';
        TextoBody: Text[1024];
        Pagado_Periodo: Label 'Dear contribuort %1, by means of this email you are notified that you have made the payment of your number corresponding to the period between %2 and %3. Attached is the receipt or proof of payment. If you have any questions, please contact the person in charge of the payroll.';
        El_Importe: Label 'The net amount of your payment has already been transferred to your bank account.If you have any questions about your payment, please contact the person in charge of payroll.';

    [Scope('OnPrem')]
    procedure "Code"()
    var
        UserSetup: Record "User Setup";
        CarriageReturn: Char;
    begin
        //UserSetup.GET(USERID);
        _Directorio := ConfNominas."Path Archivos Electronicos";
        CarriageReturn := 13;
        /*         SMTPSetup.Get();
                SMTPSetup.TestField("User ID"); */

        Emp.Get(GlobalRec."No. empleado");
        Historico.SetRange("No. empleado", GlobalRec."No. empleado");
        Historico.SetRange(Período, GlobalRec.Período);
        Historico.SetRange("Tipo de nomina", GlobalRec."Tipo de nomina");
        Historico.FindFirst;

        TextoBody := Dia_Pago + Format(CarriageReturn) + Format(CarriageReturn) + StrSubstNo(Pagado_Periodo, Historico."Full name", Historico.Inicio, Historico.Fin);// +

        Asunto := ConfNominas."Texto email recibos" + ', ' + Historico."Full name" + ', ' + StrSubstNo(Text001, Historico.Inicio, Historico.Fin);
        /*  REPORT.SaveAsPdf(IDReporte, _Directorio + _ArchivoPDF, Historico); */
        Sleep(ConfNominas."Tiempo espera Envio email");
        AttachmentFile := _Directorio + _ArchivoPDF;
        /*  if Emp."Company E-Mail" <> '' then
             SMTP.CreateMessage(CompanyName, SMTPSetup."User ID", Emp."Company E-Mail", Asunto, TextoBody, false)
         else
             if Emp."E-Mail" <> '' then
                 SMTP.CreateMessage(CompanyName, SMTPSetup."User ID", Emp."E-Mail", Asunto, TextoBody, false);
         SMTP.AddAttachment(AttachmentFile, _ArchivoPDF);
         SMTP.Send;
  */
        /*    Erase(_Directorio + _ArchivoPDF); */
        ClearAll;
    end;

    procedure GetReport(_ReportID: Integer; NombreArchivo: Text[250])
    begin
        IDReporte := _ReportID;
        _ArchivoPDF := NombreArchivo + '.pdf';
    end;
}

