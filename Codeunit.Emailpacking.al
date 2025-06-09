codeunit 56300 "Email packing"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        Texto: BigText;
    begin
        //REPORT.SAVEASHTML(50700,'C:/TEMP/PRUEBA.HTML');
        EnvioMailPacking(Rec);
    end;

    var
        Body: BigText;
        SMTPmail: Codeunit Email;


    procedure generaBody(parSalesHeader: Record "Sales Header")
    var
        rTextoConfig: Record "Texto Configurable";
        rPick: Record "Registered Whse. Activity Line";
        rPack: Record "Lin. Packing Registrada";
        nCajas: Integer;
        nPalets: Integer;
        rTempPack: Record "Lin. Packing Registrada" temporary;
        TextoCajas: Label '%1 Caja(s) ';
        TextoPalets: Label '%1 Palet(s)';
        conj: Label 'y';
        TextoBultos: Text[30];
        antPalet: Code[20];
    begin

        rTempPack.DeleteAll;
        rPick.SetRange("Source Type", 37);
        rPick.SetRange("Source No.", parSalesHeader."No.");
        if rPick.FindSet then begin
            Clear(antPalet);
            rPack.SetRange(rPack."No. Picking", rPick."No.");
            if rPack.FindSet then
                repeat
                    if rPack."No. Palet" = '' then begin
                        nCajas += 1;
                        rTempPack := rPack;
                        rTempPack.Insert;
                    end
                    else begin
                        if antPalet <> rPack."No. Palet" then begin
                            nPalets += 1;
                            rTempPack := rPack;
                            rTempPack.Insert;
                            antPalet := rPack."No. Palet";
                        end;
                    end;
                until rPack.Next = 0;
        end;
        if nPalets > 0 then
            TextoBultos := StrSubstNo(TextoPalets, nPalets);
        if nCajas > 0 then begin
            if TextoBultos <> '' then TextoBultos := TextoBultos + conj;
            TextoBultos := TextoBultos + StrSubstNo(TextoPalets, nPalets);
        end;

        rTextoConfig.SetRange("Id. Tabla", 56030);
        rTextoConfig.SetRange(Sección, rTextoConfig.Sección::Cabecera);
        if rTextoConfig.FindSet then
            repeat
                Body.AddText(StrSubstNo(rTextoConfig.Texto, parSalesHeader."No.", TextoBultos, parSalesHeader."Amount Including VAT",
                                        rTempPack."No. Caja", rTempPack."No. Palet", rTempPack."Cod. seguimiento"));
            until rTextoConfig.Next = 0;

        if rTempPack.FindSet then
            repeat
                rTextoConfig.SetRange(Sección, rTextoConfig.Sección::Detalle);
                if rTextoConfig.FindSet then
                    repeat
                        Body.AddText(StrSubstNo(rTextoConfig.Texto, parSalesHeader."No.", TextoBultos, parSalesHeader."Amount Including VAT",
                                            rTempPack."No. Caja", rTempPack."No. Palet", rTempPack."Cod. seguimiento"));
                    until rTextoConfig.Next = 0;
            until rTempPack.Next = 0;

        rTextoConfig.SetRange(Sección, rTextoConfig.Sección::Pie);
        if rTextoConfig.FindSet then
            repeat
                Body.AddText(StrSubstNo(rTextoConfig.Texto, parSalesHeader."No.", TextoBultos, parSalesHeader."Amount Including VAT",
                                        rTempPack."No. Caja", rTempPack."No. Palet", rTempPack."Cod. seguimiento"));
            until rTextoConfig.Next = 0;
    end;


    procedure EnvioMailPacking(parSalesHeader: Record "Sales Header")
    var
        rCust: Record Customer;
        Subject: Label 'Santillana-Prueba de envío';
        rConf: Record "Config. Empresa";
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
    begin


        rCust.Get(parSalesHeader."Sell-to Customer No.");
        if rCust."E-Mail" = '' then exit;

        generaBody(parSalesHeader);

        rConf.Get();
        rConf.TestField("E-mail notificación envio ped.");

        Recipients.Add(rConf."E-mail notificación envio ped.");
        Recipients.Add(rCust."E-Mail");

        //SMTPmail.CreateMessageBigBody('Santillana', rConf."E-mail notificación envio ped.", rCust."E-Mail", Subject, Body, true);
        EmailMessage.Create(Recipients, Subject, Format(Body), true);


        SMTPmail.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;
}

