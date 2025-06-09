report 76056 "Reporte Compra Divisas (612)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReporteCompraDivisas612.rdlc';

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = SORTING ("Bank Account No.", "Posting Date") ORDER(Ascending);
            RequestFilterFields = "Bank Account No.", "Posting Date", "Document No.", "Currency Code", "Reason Code";
            column(BankAccountNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Bank Account No.")
            {
            }
            column(PostingDate_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Posting Date")
            {
            }
            column(Description_BankAccountLedgerEntry; "Bank Account Ledger Entry".Description)
            {
            }
            column(DocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Document No.")
            {
            }
            column(CurrencyCode_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Currency Code")
            {
            }
            column(Amount_BankAccountLedgerEntry; "Bank Account Ledger Entry".Amount)
            {
            }
            column(AmountLCY_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Amount (LCY)")
            {
            }
            column(NombreBanco; Bank.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ArchITBIS);
                Bank.Get("Bank Account No.");
                if (StrPos(Description, 'US') <> 0) or
                   (StrPos(Description, 'U$') <> 0) then
                    ArchITBIS."Número Documento" := "Document No.";
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                         Format("Posting Date", 0, '<day,2>');

                ArchITBIS.Apellidos := '01'; //Divisa Origen
                ArchITBIS.Nombres := '02'; //Divisa Destino
                ArchITBIS."Razón Social" := DelChr(Bank.Name, '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                //RNCTxt                                 := DELCHR(Bank."VAT Registration No.",'=','- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);
                Clear(Tasa);
                if StrPos(UpperCase(Description), 'TASA DE') <> 0 then begin
                    Tasa := CopyStr(Description, (StrPos(UpperCase(Description), 'TASA DE')), 10);
                    Tasa := DelChr(Tasa, '=', ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%$#@!~^&*()/');
                end;
                if Tasa = '' then
                    Tasa := '0';
                Evaluate(ArchITBIS."Total Documento", Tasa);
                ArchITBIS."ITBIS Pagado" := "Amount (LCY)";
                ArchITBIS."Codigo reporte" := '612';
                if not ArchITBIS.Insert then
                    ArchITBIS.Modify;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        //IF "Bank Account Ledger Entry".GETFILTER("Reason Code") = '' THEN
        //  ERROR(Error001);

        ArchITBIS.Reset;
        ArchITBIS.SetRange("Codigo reporte", '612');
        ArchITBIS.DeleteAll;
    end;

    var
        Bank: Record "Bank Account";
        ArchITBIS: Record "Archivo Transferencia ITBIS";
        RNCTxt: Text[100];
        Tasa: Text[30];
        Error001: Label 'Debe especificar cod. auditoria para divisas';
}

