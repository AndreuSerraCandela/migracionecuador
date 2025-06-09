codeunit 76028 "Funciones entrenamientos"
{
    TableNo = "Historico Cab. nomina";

    trigger OnRun()
    begin
    end;

    var
        SMTP: Codeunit Email;
        GlobalRec: Record "Historico Cab. nomina";
        Historico: Record "Historico Cab. nomina";
        Emp: Record Employee;
        ConfNominas: Record "Configuracion nominas";
        UserSetup: Record "User Setup";
        RepresentantesEmpresa: Record "Representantes Empresa";
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
        Notificacion: Label 'Notification of registration to training %1';
        TextoBody: Text[1024];
        Pagado_Periodo: Label 'Dear contribuort %1, by means of this email you are notified that you have made the payment of your number corresponding to the period between %2 and %3. Attached is the receipt or proof of payment. If you have any questions, please contact the person in charge of the payroll.';
        El_Importe: Label 'The net amount of your payment has already been transferred to your bank account.If you have any questions about your payment, please contact the person in charge of payroll.';
        Estimado: Label 'Dear %1, you have been ';
        Invitado: Label 'Invited';
        Invitada: Label 'Invited';
        Participar: Label 'to participate in training %1. The date of this training will be %2, starting at %3.';
        Info: Label 'For additional information, please contact %1, %2';
        Esperamos: Label 'We count on your presence';
        CarriageReturn: Char;
        Msg001: Label 'Notifications have been sent';


    procedure "Code"()
    var
        UserSetup: Record "User Setup";
        CarriageReturn: Char;
    begin
    end;


    procedure GetReport(_ReportID: Integer; NombreArchivo: Text[250])
    begin
        IDReporte := _ReportID;
        _ArchivoPDF := NombreArchivo + '.pdf';
    end;


    procedure EnviarNotificacion(AsistEnt: Record "Asistentes entrenamientos")
    var
        CabEnt: Record "Cab. Entrenamiento";
        Asistentesentrenamientos: Record "Asistentes entrenamientos";
    begin
        UserSetup.Get(UserId);
        ConfNominas.Get();
        CarriageReturn := 13;
        RepresentantesEmpresa.FindFirst;

        Asistentesentrenamientos.Reset;
        Asistentesentrenamientos.SetRange("No. entrenamiento", AsistEnt."No. entrenamiento");
        Asistentesentrenamientos.SetRange("Fecha programacion", AsistEnt."Fecha programacion");
        Asistentesentrenamientos.SetRange(Notificado, false);
        Asistentesentrenamientos.FindSet;
        repeat
            Clear(Asunto);

            Emp.Get(Asistentesentrenamientos."No. empleado");
            CabEnt.Get(Asistentesentrenamientos."No. entrenamiento");
            Asunto := StrSubstNo(Notificacion, CabEnt."Titulo entrenamiento");

            TextoBody := StrSubstNo(Estimado, Emp."Full Name");
            // if Emp.Gender = 2 then
            //     TextoBody += Invitado
            // else
            //     TextoBody += Invitada;

            TextoBody += StrSubstNo(Participar, CabEnt."Titulo entrenamiento", Asistentesentrenamientos."Fecha programacion", Asistentesentrenamientos."Hora de Inicio");
            TextoBody += Format(CarriageReturn);
            TextoBody += StrSubstNo(Info, RepresentantesEmpresa.Nombre, RepresentantesEmpresa."Job Title");

            Sleep(ConfNominas."Tiempo espera Envio email");
            // if Emp."Company E-Mail" <> '' then
            //     //SMTP.CreateMessage(CompanyName, UserSetup."E-Mail", Emp."Company E-Mail", Asunto, TextoBody, false)
            // else
            //     if Emp."E-Mail" <> '' then
            //       //  SMTP.CreateMessage(CompanyName, UserSetup."E-Mail", Emp."E-Mail", Asunto, TextoBody, false);
            // SMTP.Send;
            Asistentesentrenamientos.Notificado := true;
            Asistentesentrenamientos.Modify;
        until Asistentesentrenamientos.Next = 0;
        ClearAll;

        Message(Msg001);
    end;

    local procedure RegistraEntrenamiento()
    begin
    end;
}

