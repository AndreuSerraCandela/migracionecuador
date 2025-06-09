report 56186 "Provisión de insolvencias"
{
    // #29271  CAT Los clientes bloqueados entrarán en este proceso.
    DefaultLayout = RDLC;
    RDLCLayout = './Provisióndeinsolvencias.rdlc';


    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.") WHERE("Exento Provision" = CONST(false));
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemTableView = SORTING("Customer No.", "Posting Date", Open, "Provisionado por insolvencia");

                    trigger OnAfterGetRecord()
                    begin

                        Clear(GenJnlLine);
                        wLine += 10000;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := JournalTemplate;
                        GenJnlLine."Journal Batch Name" := BatchName;
                        GenJnlLine."Line No." := wLine;
                        GenJnlLine.Validate("Posting Date", PostingDate);
                        if Reversion then begin
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Cancelar Prov. Insol.";
                        end
                        else begin
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Provisión Insolvencias";
                        end;
                        GenJnlLine."Document No." := 'INSOLV' + Format(PostingDate);
                        GenJnlLine.Validate("Account No.", "Cust. Ledger Entry"."Customer No.");
                        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine.Validate("Applies-to Doc. No.", "Cust. Ledger Entry"."Document No.");
                        if GenJnlLine.Amount = 0 then
                            CurrReport.Skip;
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.", CtaGastos);
                        GenJnlLine.Insert(true);
                        if (Reversion) and (FechaInicioPeriodo <> 0D) then begin
                            SetFilter("Date Filter", '<%1', FechaInicioPeriodo);
                            CalcFields("Importe provisionado");
                            ImporteProvisionAnterior := "Importe provisionado";
                            SetRange("Date Filter");
                            if ImporteProvisionAnterior = GenJnlLine.Amount then begin
                                GenJnlLine.Validate(GenJnlLine."Bal. Account No.", CtaIngresos);
                                GenJnlLine.Modify;
                            end
                            else
                                if ImporteProvisionAnterior <> 0 then begin
                                    GenJnlLine.Validate(Amount, GenJnlLine.Amount - ImporteProvisionAnterior);
                                    GenJnlLine.Modify;
                                    wLine += 10000;
                                    Clear(GenJnlLine2);
                                    GenJnlLine2 := GenJnlLine;
                                    GenJnlLine2."Document Date" := FechaInicioPeriodo - 1;
                                    GenJnlLine2."Line No." := wLine;
                                    GenJnlLine2.Validate(Amount, ImporteProvisionAnterior);
                                    GenJnlLine2.Validate("Bal. Account No.", CtaIngresos);
                                    GenJnlLine2.Insert;
                                end;
                        end;
                        if (not Reversion) and (FechaInicioPeriodo <> 0D) and (GenJnlLine.Amount > 0) then begin
                            SetFilter("Date Filter", '>=%1', FechaInicioPeriodo);
                            CalcFields("Importe provisionado");
                            ImpProvPeriodoActual := "Importe provisionado";
                            if ImpProvPeriodoActual < GenJnlLine.Amount then begin
                                if ImpProvPeriodoActual > 0 then begin
                                    ImporteProvisionAnterior := GenJnlLine.Amount - ImpProvPeriodoActual;
                                    GenJnlLine.Validate(Amount, ImpProvPeriodoActual);
                                    GenJnlLine.Modify;
                                    wLine += 10000;
                                    Clear(GenJnlLine2);
                                    GenJnlLine2 := GenJnlLine;
                                    GenJnlLine2."Line No." := wLine;
                                    GenJnlLine2."Document Date" := FechaInicioPeriodo - 1;
                                    GenJnlLine2.Validate(Amount, ImporteProvisionAnterior);
                                    GenJnlLine2.Validate("Bal. Account No.", CtaIngresos);
                                    GenJnlLine2.Insert;
                                end;
                                if ImpProvPeriodoActual = 0 then begin
                                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.", CtaIngresos);
                                    GenJnlLine.Modify;
                                end;
                            end;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin

                        SetRange("Customer No.", Customer."No.");
                        SetRange("Document Type", "Document Type"::Invoice);
                        if Reversion then begin
                            SetRange(Open, false);
                            SetRange("Cust. Ledger Entry"."Provisionado por insolvencia", true);
                        end else begin
                            SetRange(Open, true);
                            SetRange("Provisionado por insolvencia");
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin

                    if Number = 1 then
                        Reversion := false
                    else
                        Reversion := true;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Integer.Number, 1, 2);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                wcont += 1;
                Ventana.Update(1, Customer."No.");
                Ventana.Update(3, wcont);
            end;

            trigger OnPostDataItem()
            begin
                Ventana.Close;
            end;

            trigger OnPreDataItem()
            begin

                if PostingDate = 0D then Error(Text004, Text005);
                if BatchName = '' then Error(Text004, Text006);
                if JournalTemplate = '' then Error(Text004, Text007);


                rConf.Get;
                rConf.TestField("Cta. Ingresos Prov. Insolv.");
                rConf.TestField("Cta. Gastos Prov. Insolv.");
                CtaGastos := rConf."Cta. Gastos Prov. Insolv.";
                CtaIngresos := rConf."Cta. Ingresos Prov. Insolv.";


                Clear(wcont);
                Periodo;
                GetLastLine;
                TotalCli := Customer.Count;
                Ventana.Open(Text001 +
                             Text002);
                Ventana.Update(4, TotalCli);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                    }
                    field(JournalTemplate; JournalTemplate)
                    {
                        Caption = 'Journal Template';
                        TableRelation = "Gen. Journal Batch".Name;
                        ApplicationArea = Basic, Suite; // Se agrega ApplicationArea

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            GenJnlTemplates: Page "General Journal Templates";
                            GenJnlTemplate: Record "Gen. Journal Template";
                        begin
                            GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::"Cash Receipts");
                            GenJnlTemplate.SetRange(Recurring, false);
                            GenJnlTemplates.SetTableView(GenJnlTemplate);

                            GenJnlTemplates.LookupMode := true;
                            GenJnlTemplates.Editable := false;
                            if GenJnlTemplates.RunModal = ACTION::LookupOK then begin
                                GenJnlTemplates.GetRecord(GenJnlTemplate);
                                JournalTemplate := GenJnlTemplate.Name;
                            end;
                        end;
                    }
                    field(BatchName; BatchName)
                    {
                        Caption = 'Batch Name';
                        TableRelation = "Gen. Journal Batch".Name;
                        ApplicationArea = Basic, Suite; // Se agrega ApplicationArea

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            GenJnlBatches: Page "General Journal Batches";
                        begin
                            if JournalTemplate <> '' then begin
                                GenJnlBatch.SetRange("Journal Template Name", JournalTemplate);
                                GenJnlBatches.SetTableView(GenJnlBatch);
                            end;

                            GenJnlBatches.LookupMode := true;
                            GenJnlBatches.Editable := false;
                            if GenJnlBatches.RunModal = ACTION::LookupOK then begin
                                GenJnlBatches.GetRecord(GenJnlBatch);
                                BatchName := GenJnlBatch.Name;
                            end;
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        PostingDate: Date;
        BatchName: Code[20];
        JournalTemplate: Text[10];
        Reversion: Boolean;
        CtaGastos: Code[20];
        CtaIngresos: Code[20];
        PorcProvision: Decimal;
        ImporteProvision: Decimal;
        FechaInicioPeriodo: Date;
        ImporteProvisionAnterior: Decimal;
        GenJnlLine2: Record "Gen. Journal Line";
        wLine: Integer;
        Ventana: Dialog;
        TotalCli: Integer;
        wcont: Integer;
        rConf: Record "Config. Empresa";
        ImpProvPeriodoActual: Decimal;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Procesando #3######### de #4#########\\';
        Text002: Label 'Cliente #1#################\\';
        Text003: Label 'Factura #2#################\\';
        Text004: Label 'Se requiere introducir %1.';
        Text005: Label 'la fecha de registro';
        Text006: Label 'el libro dario';
        Text007: Label 'el nombre de la sección';
        Text008: Label 'la cuenta de gastos';
        Text009: Label 'la cuenta de ingresos';


    procedure Periodo()
    var
        AccountPeriod: Record "Accounting Period";
    begin
        FechaInicioPeriodo := 0D;
        AccountPeriod.SetFilter("Starting Date", '<=%1', PostingDate);
        if AccountPeriod.FindLast then
            FechaInicioPeriodo := AccountPeriod."Starting Date";
    end;


    procedure ImporteProvAnterior()
    var
        CustLedEntry: Record "Cust. Ledger Entry";
    begin
    end;


    procedure GetLastLine()
    begin

        Clear(wLine);
        GenJnlLine.LockTable;
        GenJnlLine.SetRange("Journal Template Name", JournalTemplate);
        GenJnlLine.SetRange("Journal Batch Name", BatchName);
        if GenJnlLine.FindLast then
            wLine := GenJnlLine."Line No.";
        GenJnlLine.Reset;
    end;
}

