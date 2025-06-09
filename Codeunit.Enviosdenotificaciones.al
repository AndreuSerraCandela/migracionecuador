/*codeunit 76006 "Envios de notificaciones"
{

    trigger OnRun()
    begin
    end;

    var
        CompanyInfo: Record "Company Information";
        UserSetup: Record "User Setup";
        User: Record User;
        FromAddress: Text;
        ReplyAddress: Text;
        MailAttachments: Codeunit AttachmentManagement;
        //MailAttachment: array[20] of DotNet Attachment;
        DotNetExceptionHandler: Codeunit "DotNet Exception Handler";
        MailMessage: Codeunit "Email Message";
        Asunto: Text[250];
        TextoBody: Text;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Archivo: File;
        NombreArchivo: Text;
        AsciiStr: Text[250];
        AnsiStr: Text[250];
        CharVar: array[32] of Char;
        Msg001: Label 'Se han enviado los correos de forma satisfactoria';
        Err001: Label 'Mail msg was not created';


    procedure EnviaEmailEstCta(var Cust: Record Customer)
    var
        ServiceOrderType: Record "Service Order Type";
        OpenServHeader: Record "Service Header";
        ProdServicio: Record "Service Item";
        SSIL: Record "Service Item Line";
        Cust2: Record Customer;
        CLE: Record "Cust. Ledger Entry";
        Divisa: Record Currency;
        Text001: Label '%1 - Statement of Balance Balance with %2';
        Text002: Label 'Mr.: %1';
        Text003: Label 'Attached the Aging Balance status with %1, with the following summary:';
        Text004: Label 'Best regards,';
        Text005: Label 'Note: Your company has the following additional open service orders:';
        Text006: Label 'Balance at date:  RD$ %1, %2 %3';
        Text007: Label 'Balance due: RD$ %1, %2 %3';
        Text008: Label 'Please proceed with the payment of to due balance update your account.';
        PaymentTerms: Record "Payment Terms";
        Empresa: Text[65];
        Text009: Label 'Last payment date: %1';
        BalTotal: Decimal;
        Text010: Label 'Sending  @1@@@@@@@@@@@@@ \Customer  #2##############################';
        BalVencido: Decimal;
        FechaUltPago: Text;
        Email: Codeunit Email;
    begin
        Cust.FindSet;
        //Cust.TESTFIELD("E-mails notificacion CxP");
        Cust.TestField("E-Mail");
        Empresa := CopyStr(CompanyName, StrPos(CompanyName, '-') + 1, StrLen(CompanyName));

        /*ConfEmpGE.GET();
        ConfEmpGE.TESTFIELD("E-Mail CxC");
        *//*
        UserSetup.Get(UserId);
        UserSetup.TestField("E-Mail");
        User.Reset;
        User.SetRange("User Name", UserId);
        User.FindFirst;
        CounterTotal := Cust.Count;
        Window.Open(Text010);
        repeat
            Counter := Counter + 1;
            Window.Update(2, Cust.Name);
            Window.Update(1, Round(Counter / CounterTotal * 10000, 1));
            Cust2.Reset;
            Cust2.SetRange("No.", Cust."No.");
            Cust2.SetRange("Date Filter", 0D, WorkDate);
            Cust2.FindFirst;
            Cust2.CalcFields("Balance Due (LCY)", "Balance (LCY)");

            //Busco ultimo pago
            CLE.Reset;
            CLE.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
            CLE.SetRange("Customer No.", Cust."No.");
            CLE.SetFilter("Document Type", '<>%1', CLE."Document Type"::"Credit Memo");
            CLE.SetRange(Positive, false);
            CLE.SetFilter("Original Amount", '<%1', 0);
            if not CLE.FindLast then
                CLE.Init
            else
                FechaUltPago := Format(CLE."Posting Date", 0, '<Day,2> <Month Text> <Year4>');
            /*GRN Aqui va la llamada del reporte
              EstadCta.RecibeParametros(TRUE);
              EstadCta.SETTABLEVIEW(Cust2);
              NombreArchivo := 'c:\temp\' + Cust."No." + '.pdf';
              EstadCta.SAVEASPDF(NombreArchivo);
              CLEAR(EstadCta);
              //REPORT.SAVEASPDF(50003,'c:\temp\' + Cust."No." + '.pdf',Cust2);
            *//*
            //FromAddress := FromAddress.MailAddress(UserSetup."E-Mail", User."Full Name");
            FromAddress := UserSetup."E-Mail";

            Asunto := StrSubstNo(Text001, Cust."No.", Empresa);

            TextoBody := '<br>' + StrSubstNo(Text002, Cust.Name) + '<br>' + '<br>' + StrSubstNo(Text003, Empresa) + '<br>' + '<br>';

            //Para llenado de tabla con detalle Deuda cliente
            TextoBody += '<table border="1"><background-color:gold;>' + '<tr>' + StrSubstNo('<td><b>%1<b></td>', 'Divisa') + StrSubstNo('<td><b>%1<b></td>', 'Balance al corte') +
                          StrSubstNo('<td align="right"><b>%1<b></td>', 'Balance vencido') + '</tr>';
            BalTotal := 0;
            BalVencido := 0;
            CLE.Reset;
            CLE.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
            CLE.SetRange("Customer No.", Cust."No.");
            CLE.SetRange(Open, true);
            CLE.SetRange("Currency Code", '');
            if CLE.FindSet then
                repeat
                    CLE.CalcFields("Remaining Amount");
                    BalTotal += CLE."Remaining Amount";
                    if CLE."Due Date" < Today then
                        BalVencido += CLE."Remaining Amount";
                until CLE.Next = 0;

            if BalTotal <> 0 then begin
                TextoBody += '<tr>';
                TextoBody += StrSubstNo('<td align="left">%1</td>', 'RD$ ');
                TextoBody += StrSubstNo('<td align="right">%1</td>', BalTotal);
                TextoBody += StrSubstNo('<td align="right">%1</td>', BalVencido);
                TextoBody += '</tr>';
            end;

            //Busco balance en Divisas
            BalTotal := 0;
            BalVencido := 0;
            Divisa.Find('-');
            repeat
                BalTotal := 0;
                BalVencido := 0;
                CLE.Reset;
                CLE.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
                CLE.SetRange("Customer No.", Cust."No.");
                CLE.SetRange(Open, true);
                CLE.SetRange("Currency Code", Divisa.Code);
                if CLE.FindSet then
                    repeat
                        CLE.CalcFields("Remaining Amount");
                        BalTotal += CLE."Remaining Amount";
                        if CLE."Due Date" < Today then
                            BalVencido += CLE."Remaining Amount";
                    until CLE.Next = 0;
                if BalTotal <> 0 then begin
                    TextoBody += '<tr>';
                    TextoBody += StrSubstNo('<td align="left">%1</td>', Divisa.Symbol);
                    TextoBody += StrSubstNo('<td align="right">%1</td>', BalTotal);
                    TextoBody += StrSubstNo('<td align="right">%1</td>', BalVencido);
                    TextoBody += '</tr>';
                end;

            until Divisa.Next = 0;
            TextoBody += '</table>';
            TextoBody += '<br><br>';

            TextoBody += StrSubstNo(Text009, FechaUltPago) + '<br>' + '<br>' + Text008 + '<br>' + '<br>' + UserId + '<br>' + '<br>';

            TextoBody += '</table>';
            TextoBody += '<br><br>';
            // create mail message
            /*if not IsNull(MailMessage) then
                Clear(MailMessage);
            MailMessage := MailMessage.MailMessage;
            MailMessage.From := FromAddress;
            MailMessage.Subject := Asunto;
            MailMessage.Body := TextoBody;
            MailMessage."To".Clear;
            MailAttachments := MailMessage.Attachments;
            MailAttachment[1] := MailAttachment[1].Attachment(NombreArchivo);//FilenameL is different for every report
            MailAttachments.Add(MailAttachment[1]);//Adding atttachements
            MailMessage.IsBodyHtml := true;*//*
            Clear(MailMessage);
            MailMessage.Create(FromAddress, Asunto, TextoBody, true);
            //MailMessage.AddAttachment(NombreArchivo); //Pendiente que nombre de deja añarir typo archivo y base64
            //Cust.TESTFIELD("E-mails notificacion CxP");
            Cust.TestField("E-Mail");
            //Cust."E-mails notificacion CxP" := CONVERTSTR(Cust."E-mails notificacion CxP",';',',');
            //MailMessage."To".Add(Cust."E-mails notificacion CxP");
            //MailMessage."CC".Add('servicios@scadom.com');
            //MailMessage.CC.Add(ConfEmpGE."E-Mail CxC");
            //ReplyAddress := ReplyAddress.MailAddress(ConfEmpGE."E-Mail CxC", 'Servicios');
            //ReplyAddress := ReplyAddress.MailAddress(UserSetup."E-Mail", 'Ventas y CxC');
            ReplyAddress := UserSetup."E-Mail";

            // create and add reply-to-address
            //MailMessage.ReplyTo := ReplyAddress;
            MailMessage.AddRecipient(Enum::"Email Recipient Type"::"To", UserSetup."E-Mail");

            //if not SendSmtpMail then begin
            if not Email.Send(MailMessage, Enum::"Email Scenario"::Default) then begin
                DotNetExceptionHandler.Collect;
                DotNetExceptionHandler.Rethrow;
            end;

        until Cust.Next = 0;
        Window.Close;
        Message(Msg001);
        if Exists(NombreArchivo) then
            Erase(NombreArchivo);

    end;


    procedure EnviaEmailFactura(var NoDoc: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ReportSelection: Record "Report Selections";
        Cust: Record Customer;
        Divisa: Record Currency;
        Text001: Label 'Invoice %1';
        Text002: Label 'Mr.: %1';
        Text003: Label 'Attached is our Invoice No. %1, dated %2, NCF %3, corresponding to your Purchase Order %4';
        Text004: Label 'Best regards,';
        Text005: Label 'Amount: %1';
        Text006: Label 'Payment terms %1';
        Text007: Label 'Due date: %1';
        Text008: Label 'If you have any questions or disagreements regarding our bill, we request that you immediately respond to this email with your concern.';
        Text009: Label 'Please confirm receipt of this email.';
        Text010: Label 'Sending E-mail\Customer  #2##############################';
        PaymentTerms: Record "Payment Terms";
        FechaDoc: Text[60];
        Text011: Label 'The client %1 does not have email configured in the field %2, if you want to send the electronic documents, you must add an e-mail in the field';
        NCF: Text[19];
        NoOrden: Text[30];
        Moneda: Text[30];
        Importe: Text[30];
        TermPago: Text[30];
        FechaVenc: Text[60];
    begin
        /*
        CLEAR(SalesInvoiceHeader);
        CLEAR(ServiceInvoiceHeader);
        NCF := '';
        NoOrden := '';
        FechaDoc := '';
        Moneda := '';
        Importe := '';
        TermPago := '';
        FechaVenc := '';
        NombreArchivo := 'c:\temp\' + NoDoc + '.pdf';
        
        IF SalesInvoiceHeader.GET(NoDoc) THEN
           Cust.GET(SalesInvoiceHeader."Sell-to Customer No.")
        ELSE
        IF ServiceInvoiceHeader.GET(NoDoc) THEN
            Cust.GET(ServiceInvoiceHeader."Bill-to Customer No.")
        ELSE
          EXIT;
        
        IF Cust."E-mails notificacion Fact." = '' THEN
          BEGIN
            MESSAGE(STRSUBSTNO(Text011,Cust.Name,Cust.FIELDCAPTION("E-mails notificacion Fact.")));
          END;
        
        ConfEmpresa.GET();
        CompanyInfo.GET();
        ConfEmpresa.TESTFIELD("E-Mail Facturacion");
        
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("E-Mail");
        
        User.RESET;
        User.SETRANGE("User Name",USERID);
        User.FINDFIRST;
        
        CounterTotal := Cust.COUNT;
        Window.OPEN(Text010);
        //  Counter := Counter + 1;
          Window.UPDATE(2,Cust.Name);
         // Window.UPDATE(1,ROUND(Counter / CounterTotal * 10000,1));
        
          IF SalesInvoiceHeader."No." <> '' THEN
             BEGIN
               SalesInvoiceHeader.SETRANGE("No.",NoDoc);
               FechaDoc := FORMAT(SalesInvoiceHeader."Posting Date",0,'<Day,2> de <Month Text> del <Year4>');
               NCF := SalesInvoiceHeader."No. Comprobante Fiscal";
               NoOrden := SalesInvoiceHeader."External Document No.";
               IF SalesInvoiceHeader."Currency Code" = '' THEN
                  Moneda := 'RD$'
               ELSE
                  Moneda := SalesInvoiceHeader."Currency Code";
               SalesInvoiceHeader.CALCFIELDS("Amount Including VAT");
               Importe := FORMAT(SalesInvoiceHeader."Amount Including VAT");
               PaymentTerms.GET(SalesInvoiceHeader."Payment Terms Code");
        
               TermPago := PaymentTerms.Description;
               FechaVenc := FORMAT(SalesInvoiceHeader."Due Date",0,'<Day,2> de <Month Text> del <Year4>');
               ReportSelection.RESET;
               ReportSelection.SETRANGE(Usage,ReportSelection.Usage::"S.Invoice");
               ReportSelection.SETFILTER("Report ID",'<>0');
               ReportSelection.FIND('-');
               REPEAT
                 REPORT.SAVEASPDF(ReportSelection."Report ID",'c:\temp\' + NoDoc + '.pdf',SalesInvoiceHeader);
               UNTIL ReportSelection.NEXT = 0;
             END;
        
          FromAddress := FromAddress.MailAddress(UserSetup."E-Mail", User."Full Name");
        
          IF NCF = '' THEN
            Asunto := NoDoc
          ELSE
            Asunto := NCF + DELCHR(CompanyInfo."VAT Registration No.",'=','-'); //STRSUBSTNO(Text001,NoDoc);
        
          TextoBody := '<br>' + STRSUBSTNO(Text002,Cust.Name) +  '<br>' + '<br>' + STRSUBSTNO(Text003,NoDoc,FechaDoc,NCF,NoOrden) + '<br>' + '<br>';
        
          TextoBody += STRSUBSTNO(Text005,Moneda + Importe) +  '<br>' + '<br>' ;
          TextoBody += STRSUBSTNO(Text006,SalesInvoiceHeader."Payment Terms Code") +  '<br>' + '<br>' ;
          TextoBody += STRSUBSTNO(Text007,FechaVenc) +  '<br>' + '<br>' ;
          TextoBody += Text008 + '<br>' + '<br>';
          TextoBody += Text009 + '<br>' + '<br>';
          TextoBody += Text004 + '<br>' + '<br>';
          TextoBody += USERID  + '<br>';
        
          // create mail message
          IF NOT ISNULL(MailMessage) THEN
            CLEAR(MailMessage);
          MailMessage := MailMessage.MailMessage;
          MailMessage.From := FromAddress;
          MailMessage.Subject := Asunto;
          MailMessage.Body := TextoBody;
          MailMessage."To".Clear;
          MailAttachments := MailMessage.Attachments;
          MailAttachment[1] := MailAttachment[1].Attachment(NombreArchivo);//FilenameL is different for every report
          MailAttachments.Add(MailAttachment[1]);//Adding atttachements
          MailMessage.IsBodyHtml := TRUE;
          Cust."E-mails notificacion Fact." := CONVERTSTR(Cust."E-mails notificacion Fact.",';',',');
          MailMessage."To".Add(Cust."E-mails notificacion Fact.");
          //MailMessage."CC".Add('servicios@scadom.com');
          MailMessage.CC.Add(ConfEmpresa."E-Mail Facturacion");
          ReplyAddress := ReplyAddress.MailAddress(ConfEmpresa."E-Mail Facturacion", 'Servicios');
        
          // create and add reply-to-address
          MailMessage.ReplyTo := ReplyAddress;
        
          SendSmtpMail;
        
        Window.CLOSE;
        
        IF EXISTS(NombreArchivo) THEN
          ERASE(NombreArchivo);
        //MESSAGE(Msg001);
        *//*

    end;


    procedure EnviaEmailPagosMovProv(var par_VLE: Record "Vendor Ledger Entry")
    var
        Vend: Record Vendor;
        VLE: Record "Vendor Ledger Entry";
        VLE2: Record "Vendor Ledger Entry";
        DVLE: Record "Detailed Vendor Ledg. Entry";
        DVLE2: Record "Detailed Vendor Ledg. Entry";
        Divisa: Record Currency;
        HistRet: Record "Historico Retencion Prov.";
        CKEntry: Record "Check Ledger Entry";
        PaymentMethod: Record "Payment Method";
        Empresa: Text[65];
        BalTotal: Decimal;
        BalVencido: Decimal;
        ImporteRetenciones: Decimal;
        FechaUltPago: Text;
        NombreArch1: Text[1024];
        NombreArch2: Text[1024];
        Primeravez: Boolean;
        Primeravez2: Boolean;
        MonedaPago: Code[10];
        MonedaDoc: Code[10];
        MonedaAplicado: Code[10];
        ExisteAttachment: Boolean;
        ListaDoc: Text[1024];
        TotalFact: Decimal;
        TotalRet: Decimal;
        TotalNeto: Decimal;
        TotalPagado: Decimal;
        ImportePte: Decimal;
        TotalPte: Decimal;
        TieneDetalle: Boolean;
        Text001: Label '%1 %2 | Payment notification from %3';
        Text002: Label 'Mr.: %1';
        Text003: Label 'Cortésmente les informamos que emitiremos próximamente a su favor un(a) %1, por la suma de %2 %3 correspondiente al pago de la(s) siguiente(s) factura(s) y/o documento(s):';
        Text003_b: Label 'Cortésmente les informamos que emitiremos próximamente a su favor un(a) %1, por la suma de %2 %3 correspondiente a pago adelantado';
        Text004: Label 'Issue date';
        Text005: Label 'No. NCF';
        Text006: Label 'Invoice amount';
        Text007: Label 'Amount of retention';
        Text008: Label 'Net amount';
        Text009: Label 'If you have any observations, please reply to this email,';
        Text010: Label 'Sending  @1@@@@@@@@@@@@@ \Customer  #2##############################';
        Text011: Label 'Invoice No.';
        Text012: Label 'Grand total';
        Text013: Label 'Kind regards,';
        Text014: Label 'Dear Sir/Madam, we kindly inform you that we will issue a %1 in your favor in the amount of %2 %3 corresponding to the payment of the following invoice (s) and / or document (s):';
        Text014_b: Label 'Dear Sir/Madam, we kindly inform you that we will issue a %1 in your favor in the amount of %2 %3 corresponding to the payment in advance';
        Text015: Label 'Notification sent';
        Text016: Label 'Amount applied';
        Text017: Label 'Remaining amount';
        Err001: Label 'There''s not %1 as beneficiary in the %2 %3';
        Err002: Label 'Sólo se pueden notificar %1 pago';
        Email: Codeunit Email;
    begin
        CompanyInfo.Get();
        //CompanyInfo.TESTFIELD("Path archivos electronico");

        UserSetup.Get(UserId);
        UserSetup.TestField("E-Mail");

        User.Reset;
        User.SetRange("User Name", UserId);
        User.FindFirst;

        //Creo email
        //Clear(MailAttachment);
        Clear(MailMessage);
        Clear(MailAttachments);

        Primeravez := true;
        Primeravez2 := true;
        TieneDetalle := false;
        ExisteAttachment := false;
        TotalPagado := 0;
        TotalFact := 0;
        TotalRet := 0;
        TotalNeto := 0;
        TotalPte := 0;
        MonedaAplicado := '';
        MonedaDoc := '';
        MonedaPago := '';

        VLE2.Reset;
        VLE2.CopyFilters(par_VLE);

        VLE.Reset;
        VLE.CopyFilters(par_VLE);

        VLE2.FindFirst;
        Vend.Get(VLE2."Vendor No.");
        //Vend.TESTFIELD("E-mails Notif. Pagos y Estados");
        Vend.TestField("E-Mail");

        //if not IsNull(MailMessage) then
        Clear(MailMessage);

        //FromAddress := FromAddress.MailAddress(UserSetup."E-Mail", User."Full Name");
        FromAddress := UserSetup."E-Mail";

        Asunto := StrSubstNo(Text001, Vend."No.", Vend.Name, CompanyInfo.Name);

        if VLE.FindSet then
            repeat
                if VLE."Document Type" <> VLE."Document Type"::Payment then
                    Error(StrSubstNo(Err002, VLE.FieldCaption("Document Type")));

                if not PaymentMethod.Get(VLE."Payment Method Code") then
                    PaymentMethod.Init;

                VLE.CalcFields("Original Amount");
                DVLE.Reset;
                DVLE.SetCurrentKey("Vendor Ledger Entry No.", "Posting Date");
                DVLE.SetFilter("Vendor Ledger Entry No.", '<>%1', VLE."Entry No.");
                DVLE.SetRange("Document No.", VLE."Document No.");
                DVLE.SetRange("Entry Type", DVLE."Entry Type"::Application);
                DVLE.SetFilter(Amount, '<>%1', 0);
                DVLE.SetRange("Vendor No.", VLE."Vendor No.");
                if DVLE.FindSet then
                    repeat
                        TieneDetalle := true;
                        VLE2.Get(DVLE."Vendor Ledger Entry No.");
                        ImporteRetenciones := 0;
                        HistRet.Reset;
                        HistRet.SetRange("No. documento", VLE2."Document No.");
                        if HistRet.FindSet then
                            repeat
                                ExisteAttachment := true;
                                ImporteRetenciones += HistRet."Importe Retenido";
                                if Primeravez2 then begin
                                    Primeravez2 := false;
                                    ListaDoc := HistRet."No. documento";
                                end
                                else
                                    ListaDoc += '|' + HistRet."No. documento";
                            until HistRet.Next = 0;

                        VLE2.CalcFields("Original Amount");

                        TotalPagado += DVLE.Amount;
                        TotalFact += VLE2."Original Amount";
                        TotalRet += ImporteRetenciones;

                        //Para buscar pendiente antes de pago
                        ImportePte := 0;
                        DVLE2.Reset;
                        DVLE2.SetCurrentKey("Vendor Ledger Entry No.", "Posting Date");
                        DVLE2.SetRange("Vendor Ledger Entry No.", VLE2."Entry No.");
                        DVLE2.SetFilter("Document No.", '<>%1', VLE."Document No.");
                        if DVLE2.FindSet then
                            repeat
                                ImportePte += DVLE2.Amount;
                            until DVLE2.Next = 0;

                        TotalPte += ImportePte;
                        if ImporteRetenciones <> 0 then
                            TotalNeto += VLE2."Original Amount" + ImporteRetenciones
                        else
                            TotalNeto += ImportePte;

                        //Divisa del pago
                        if VLE."Currency Code" = '' then
                            MonedaPago := 'RD$ '
                        else
                            MonedaPago := VLE."Currency Code" + ' ';

                        //Divisa del documento
                        if VLE2."Currency Code" = '' then
                            MonedaDoc := 'RD$ '
                        else
                            MonedaDoc := VLE2."Currency Code" + ' ';

                        //Divisa aplicada
                        if DVLE."Currency Code" = '' then
                            MonedaAplicado := 'RD$ '
                        else
                            MonedaAplicado := DVLE."Currency Code" + ' ';

                        if Primeravez then begin
                            TextoBody := '<br><td>' + StrSubstNo(Text003, PaymentMethod.Description, MonedaPago,
                                Format(VLE."Original Amount", 0, '<Integer Thousand><Decimals,3>')) + '</td>';
                            TextoBody += '<br><br><td>' + StrSubstNo(Text014, PaymentMethod.Description, MonedaPago,
                                Format(VLE."Original Amount", 0, '<Integer Thousand><Decimals,3>')) + '</td>';

                            Primeravez := false;
                            //Construyo tabla con el detalle de los documentos liquidados
                            TextoBody += '<br><br>' + '<table border="5" bordercolorlight="blue" bordercolordark="#b9dcff">' + '<tr>' + StrSubstNo('<td><b>%1<b></td>', Text004) +
                                        StrSubstNo('<td><b>%1<b></td>', Text005) + StrSubstNo('<td><b>%1<b></td>', Text011) +
                                        StrSubstNo('<td align="right"><b>%1<b></td>', Text006) +
                                        StrSubstNo('<td align="right"><b>%1<b></td>', Text017) +
                                        StrSubstNo('<td align="right"><b>%1<b></td>', Text007) +
                                        StrSubstNo('<td align="right"><b>%1<b></td>', Text008) +
                                        StrSubstNo('<td align="right"><b>%1<b></td>', Text016) + '</tr>';
                        end;
                        //TextoBody += '<table border="5">';
                        TextoBody += StrSubstNo('<td align="right">%1</td>', Format(VLE2."Document Date"));
                        TextoBody += StrSubstNo('<td>%1</td>', VLE2."No. Comprobante Fiscal");
                        TextoBody += StrSubstNo('<td>%1</td>', VLE2."External Document No.");
                        TextoBody += StrSubstNo('<td align="right">%1</td>', MonedaDoc + Format(VLE2."Original Amount", 0, '<Integer thousand><Decimals,3>'));
                        TextoBody += StrSubstNo('<td align="right">%1</td>', MonedaDoc + Format(Abs(ImportePte) + Abs(ImporteRetenciones), 0, '<Integer thousand><Decimals,3>'));
                        TextoBody += StrSubstNo('<td align="right">%1</td>', MonedaDoc + Format(ImporteRetenciones, 0, '<Integer thousand><Decimals,3>'));
                        if ImporteRetenciones <> 0 then
                            TextoBody += StrSubstNo('<td align="right">%1</td>', MonedaDoc + Format(VLE2."Original Amount" + ImporteRetenciones, 0, '<Integer thousand><Decimals,3>'))
                        else
                            TextoBody += StrSubstNo('<td align="right">%1</td>', MonedaDoc + Format(ImportePte, 0, '<Integer thousand><Decimals,3>'));
                        TextoBody += StrSubstNo('<td align="right">%1</td>', MonedaAplicado + Format(DVLE.Amount, 0, '<Integer thousand><Decimals,3>'));
                        TextoBody += '<tr>';
                    until DVLE.Next = 0
                else begin
                    if Primeravez then begin
                        TextoBody := '<br><td>' + StrSubstNo(Text003_b, PaymentMethod.Description, MonedaPago,
                            Format(VLE."Original Amount", 0, '<Integer Thousand><Decimals,3>')) + '</td>';
                        TextoBody += '<br><br><td>' + StrSubstNo(Text014_b, PaymentMethod.Description, MonedaPago,
                            Format(VLE."Original Amount", 0, '<Integer Thousand><Decimals,3>')) + '</td>';

                        Primeravez := false;
                    end;
                end;
            until VLE.Next = 0;

        //Para la impresion de la carta de retencion
        if ExisteAttachment then begin
            VLE.Reset;
            VLE.SetFilter("Document No.", ListaDoc);

            if VLE.FindSet then begin
                NombreArchivo := 'c:\temp\C-Ret-' + VLE."Vendor No." + '.pdf';
                REPORT.SaveAsPdf(76007, NombreArchivo, VLE);
                ExisteAttachment := true;
            end;
        end;

        if TieneDetalle then begin
            TextoBody += StrSubstNo('<td align="right"><b>%1<b></td>', Text012);
            TextoBody += StrSubstNo('<td><td><td align="right">%1</td>', '<b>' + MonedaDoc + Format(TotalFact, 0, '<Integer thousand><Decimals,3>'));
            TextoBody += StrSubstNo('<td align="right">%1</td>', '<b>' + MonedaDoc + Format(Abs(TotalPte) + Abs(TotalRet), 0, '<Integer thousand><Decimals,3>'));
            TextoBody += StrSubstNo('<td align="right">%1</td>', '<b>' + MonedaDoc + Format(TotalRet, 0, '<Integer thousand><Decimals,3>'));
            TextoBody += StrSubstNo('<td align="right">%1</td>', '<b>' + MonedaDoc + Format(TotalNeto, 0, '<Integer thousand><Decimals,3>'));
            TextoBody += StrSubstNo('<td align="right">%1</td>', '<b>' + MonedaAplicado + Format(TotalPagado, 0, '<Integer thousand><Decimals,3>') + '</b>');
            TextoBody += '</tr></table><br><br><br><br>';
            TextoBody += StrSubstNo('<td>%1</td><br><br>', Text009);
            TextoBody += StrSubstNo('<td><b>%1<b></td><br><br>', Text013);
            TextoBody += StrSubstNo('<td><b>%1<b></td><br><br>', User."Full Name");
        end;

        /*
        CASE COMPANYNAME OF
          'B.1 -   VEHIC. COMERC. SCADOM','B.2 -   EUROTRUCK SERVICES LTD':
            ReplyAddress := ReplyAddress.MailAddress('cxp@scadom.com','CxC');
          'E.1 - MINECON', 'E.2 - MINING & CONSTRUCTION':
            ReplyAddress := ReplyAddress.MailAddress('cxp@minecon.com.do','CxC');
          'B.3 -   BANSIN, SRL':
            ReplyAddress := ReplyAddress.MailAddress('cxp@bansin.do','CxC');
          'C.1 -   ELMUFDI CONSTRUCCIONES', 'C.2 -   EMP CONST. BELLA VISTA', 'C.3 -   ECBV ARENA DEL MAR SRL':
            ReplyAddress := ReplyAddress.MailAddress('cxp@ecbv.net','CxC');
          'D.1 -   TEJIDOS DEL SOL, SRL', 'D.2 -   3MT ENTERPRISES, INC':
            ReplyAddress := ReplyAddress.MailAddress('cxp@grupo3mt.com','CxC');
          'F -  SOFPORT, S.A.':
            ReplyAddress := ReplyAddress.MailAddress('cxp@softport.do','CxC');
        END;
        */
          // create mail message
          /*MailMessage := MailMessage.MailMessage;
          MailMessage.From := FromAddress;
          MailMessage.Subject := Asunto;
          MailMessage.Body := TextoBody;
          MailMessage."To".Clear;
          MailAttachments := MailMessage.Attachments;

          if ExisteAttachment then begin
              MailAttachment[1] := MailAttachment[1].Attachment(NombreArchivo);//FilenameL is different for every report
              MailAttachments.Add(MailAttachment[1]);//Adding atttachements
          end;

          MailMessage.IsBodyHtml := true;*//*

          Clear(MailMessage);
          MailMessage.Create(FromAddress, Asunto, TextoBody, true);
          //MailMessage.AddAttachment(NombreArchivo); //Pendiente que nombre de deja añarir typo archivo y base64

          //IF Vend."E-mails Notif. Pagos y Estados" <> '' THEN
          if Vend."E-Mail" <> '' then begin
              Vend."E-Mail" := DelChr(Vend."E-Mail", '=', ' ');
              //MailMessage."To".Add(Vend."E-Mail");
              MailMessage.AddRecipient(Enum::"Email Recipient Type"::"To", Vend."E-Mail");
              Vend."E-Mail" := ConvertStr(Vend."E-Mail", ';', ',');
              //Vend."E-mails Notif. Pagos y Estados" := DELCHR(Vend."E-mails Notif. Pagos y Estados",'=',' ');
              //Vend."E-mails Notif. Pagos y Estados" := CONVERTSTR(Vend."E-mails Notif. Pagos y Estados",';',',');
              //MailMessage."To".Add(Vend."E-mails Notif. Pagos y Estados");
          end;

          //MailMessage.CC.Add(ReplyAddress);
          //MailMessage.CC.Add(UserSetup."E-Mail");
          MailMessage.AddRecipient(Enum::"Email Recipient Type"::"Cc", UserSetup."E-Mail");

          // Create and add reply-to-address
          //MailMessage.ReplyTo := ReplyAddress;

          if not Email.Send(MailMessage, Enum::"Email Scenario"::Default) then begin
              DotNetExceptionHandler.Collect;
              DotNetExceptionHandler.Rethrow;
          end;
          if Exists(NombreArchivo) then
              Erase(NombreArchivo);

          ClearAll;
          //MESSAGE(Text015);

      end;

      /*[TryFunction]
      local procedure SendSmtpMail()
      var
          SMTPMailSetup: Record "SMTP Mail Setup";
          NetworkCred: DotNet NetworkCredential;
      begin
          // local variables
          SMTPMailSetup.Get;
          with SMTPMailSetup do begin
              SmtpClient := SmtpClient.SmtpClient("SMTP Server", "SMTP Server Port");
              SmtpClient.EnableSsl := "Secure Connection";

              SmtpClient.UseDefaultCredentials := false;
              //NetworkCred := NetworkCred.NetworkCredential.[1]("User ID","Password Key");
              NetworkCred := NetworkCred.NetworkCredential("User ID", SMTPMailSetup.GetPassword);
              SmtpClient.Credentials := NetworkCred;

              if IsNull(MailMessage) then
                  Error(Err001);

              SmtpClient.Send(MailMessage);

              MailMessage.Dispose;
              SmtpClient.Dispose;
              MailAttachments.Dispose;
              Clear(MailMessage);
              Clear(SmtpClient);
          end;
      end;*//*


      procedure Ansi2Ascii(_Text: Text[250]): Text[250]
      begin
          MakeVars;
          exit(ConvertStr(_Text, AnsiStr, AsciiStr));
      end;


      procedure Ascii2Ansi(_Text: Text[250]): Text[250]
      begin
          MakeVars;
          exit(ConvertStr(_Text, AsciiStr, AnsiStr));
      end;

      local procedure MakeVars()
      begin
          AsciiStr := 'áéíóúñÑAÉIOUü''||-*//*<><=~!^"';
          AnsiStr := 'aeiounNAEIOUU              ';
          /*AsciiStr := 'ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜ¢£¥ƒáíóúñÑªº¿¬½¼¡«»¦¦¦¦¦…†‡ˆ¦¦++Ž++--+-+–—++--¦-+A';
          AsciiStr := AsciiStr +'Ÿ¨©­®¯i´¸¹++¦_¦ÃØÊßËÌÍÎµÏÐÒÓÔÕ×ØÙÚ±=ÝÞã÷ð°õ·øý²¦ ';
          CharVar[1] := 196;
          CharVar[2] := 197;
          CharVar[3] := 201;
          CharVar[4] := 242;
          CharVar[5] := 220;
          CharVar[6] := 186;
          CharVar[7] := 191;
          CharVar[8] := 188;
          CharVar[9] := 187;
          CharVar[10] := 193;
          CharVar[11] := 194;
          CharVar[12] := 192;
          CharVar[13] := 195;
          CharVar[14] := 202;
          CharVar[15] := 203;
          CharVar[16] := 200;
          CharVar[17] := 205;
          CharVar[18] := 206;
          CharVar[19] := 204;
          CharVar[20] := 175;
          CharVar[21] := 223;
          CharVar[22] := 213;
          CharVar[23] := 254;
          CharVar[24] := 218;
          CharVar[25] := 219;
          CharVar[26] := 217;
          CharVar[27] := 180;
          CharVar[28] := 177;
          CharVar[29] := 176;
          CharVar[30] := 185;
          CharVar[31] := 179;
          CharVar[32] := 178;
          AnsiStr  := '—ýÒËÍÊÎÏÓÔÐÙØÕ'+FORMAT(CharVar[1])+FORMAT(CharVar[2])+FORMAT(CharVar[3])+ 'µ–Þ÷'+FORMAT(CharVar[4]);
          AnsiStr := AnsiStr + 'øõ ´'+FORMAT(CharVar[5])+'°ú¹¸âß×Ý·±©¬'+FORMAT(CharVar[6])+FORMAT(CharVar[7]);
          AnsiStr := AnsiStr + '«¼'+FORMAT(CharVar[8])+'í½'+FORMAT(CharVar[9])+'___ªª' + FORMAT(CharVar[10])+FORMAT(CharVar[11]);
          AnsiStr := AnsiStr + FORMAT(CharVar[12]) + 'ªª++óÑ++--+-+Ì' + FORMAT(CharVar[13]) + '++--ª-+ñÚ¨';
          AnsiStr  :=  AnsiStr +FORMAT(CharVar[14])+FORMAT(CharVar[15])+FORMAT(CharVar[16])+'i'+FORMAT(CharVar[17])+FORMAT(CharVar[18]);
          AnsiStr  :=  AnsiStr + 'Ÿ++__ª' + FORMAT(CharVar[19])+FORMAT(CharVar[20])+'®'+FORMAT(CharVar[21])+'¯­ã';
          AnsiStr  :=  AnsiStr + FORMAT(CharVar[22]) + '…' + FORMAT(CharVar[23]) + 'Ã' + FORMAT(CharVar[24])+ FORMAT(CharVar[25]);
          AnsiStr  :=  AnsiStr + FORMAT(CharVar[26]) + '²¦»' + FORMAT(CharVar[27]) + '¡' + FORMAT(CharVar[28]) +'=Ž†ºðˆ'+ FORMAT(CharVar[29]);
          AnsiStr  :=  AnsiStr + '¿‡' + FORMAT(CharVar[30]) +FORMAT(CharVar[31]) +FORMAT(CharVar[32]) +'_ A';
          *//*

      end;

      /*trigger SmtpClient::SendCompleted(sender: Variant; e: DotNet AsyncCompletedEventArgs)
      begin
      end;*/
            /*
        }*/

