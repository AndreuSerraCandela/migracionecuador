pageextension 50034 pageextension50034 extends "Payment Journal"
{
    AdditionalSearchTerms = 'print check,payment file export,electronic payment';
    layout
    {
        modify("Document No.")
        {
            ToolTip = 'Specifies a document number for the journal line.';
        }
        modify("External Document No.")
        {
            ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
        }
        modify("Account Type")
        {
            ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';
        }
        modify("Salespers./Purch. Code")
        {
            ToolTip = 'Specifies the salesperson or purchaser who is linked to the journal line.';
        }
        modify("Gen. Bus. Posting Group")
        {
            ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
        }
        modify("VAT Bus. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
        }
        modify("VAT Prod. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
        }
        modify("Amount (LCY)")
        {
            ToolTip = 'Specifies the total amount in local currency (including Tax) that the journal line consists of.';
        }
        modify("Debit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent debits.';
        }
        modify("Credit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent credits.';
        }
        modify("Bal. VAT Difference")
        {
            ToolTip = 'Specifies the difference between the calculate tax amount and the tax amount that you have entered manually.';
        }
        modify("Applies-to Doc. Type")
        {
            ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
        }
        modify(AppliesToDocNo)
        {
            ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
        }
        modify("Applies-to ID")
        {
            ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            HideValue = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            HideValue = false;
        }
        modify(ShortcutDimCode3)
        {
            HideValue = false;
        }
        modify(ShortcutDimCode4)
        {
            HideValue = false;
        }
        modify(ShortcutDimCode5)
        {
            HideValue = false;
        }
        modify(ShortcutDimCode6)
        {
            HideValue = false;
        }
        modify(ShortcutDimCode7)
        {
            HideValue = false;
        }
        modify(ShortcutDimCode8)
        {
            HideValue = false;
        }
        modify(BalAccName)
        {
            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.';
        }
        addafter(Description)
        {
            field(Beneficiario; rec.Beneficiario)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field("RUC/Cedula"; rec."RUC/Cedula")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Sustento del Comprobante"; rec."Sustento del Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(Establecimiento; rec.Establecimiento)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Punto de Emision"; rec."Punto de Emision")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Caducidad"; rec."Fecha Caducidad")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Cod. Retencion"; rec."Cod. Retencion")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("VAT Bus. Posting Group")
        {
            field("Collector Code"; rec."Collector Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Has Payment Export Error")
        {
            field("Tipo de Identificador"; rec."Tipo de Identificador")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Pago a"; rec."Pago a")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Excluir Informe ATS"; rec."Excluir Informe ATS")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(ShortcutDimCode8)
        {
            field("FA Posting Type"; rec."FA Posting Type")
            {
                ApplicationArea = Basic, Suite;
            }
            field("FA Posting Date"; rec."FA Posting Date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify(IncomingDoc)
        {
            ToolTip = 'View or create an incoming document record that is linked to the entry or document.';
        }
        modify(ExportPaymentsToFile)
        {
            Caption = 'E&xport2';
            Visible = false;

        }
        moveafter(CreditTransferRegisters; Approvals)

        modify("Insert Conv. LCY Rndg. Lines")
        {
            ToolTip = 'Insert a rounding correction line in the journal. This rounding correction line will balance in $ when amounts in the foreign currency also balance. You can then post the journal.';
        }
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify("Post and &Print")
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
        /*         modify(CreateFlow)
                {
                    ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
                } */
        modify(Approve)
        {
            ToolTip = 'Approve the requested changes.';
        }
        modify(Comment)
        {
            ToolTip = 'View or add comments for the record.';
        }
        addfirst("Electronic Payments")
        {
            action("E&xport")
            {
                Caption = 'E&xport';
                Ellipsis = true;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    BankAccount: Record "Bank Account";
                    GenJnlLine: Record "Gen. Journal Line";
                    ExportAgainQst: Label 'Do you want to export the payment file again?';
                begin

                    GenJnlLine.RESET;
                    GenJnlLine := Rec;
                    GenJnlLine.SETRANGE("Journal Template Name", rec."Journal Template Name");
                    GenJnlLine.SETRANGE("Journal Batch Name", rec."Journal Batch Name");

                    IF ((rec."Bal. Account Type" = rec."Bal. Account Type"::"Bank Account") AND
                      BankAccount.GET(rec."Bal. Account No.") AND (BankAccount."Payment Export Format" <> ''))
                    THEN
                        CODEUNIT.RUN(CODEUNIT::"Export Payment File (Yes/No)", GenJnlLine)
                    ELSE BEGIN
                        IF GenJnlLine.IsExportedToPaymentFile THEN
                            IF NOT CONFIRM(ExportAgainQst) THEN
                                EXIT;

                        REPORT.RUNMODAL(REPORT::"Export Electronic Payments", TRUE, FALSE, GenJnlLine);
                    END;



                end;
            }
        }
        addafter(TransmitPayments)
        {
            action("Send notification's payment email")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send notification''s payment email';
                Image = SendTo;

                trigger OnAction()
                begin
                    //PagosElectronicos.EnviaMailPagos("Journal Template Name", "Journal Batch Name")
                end;
            }
        }
        addfirst("A&ccount")
        {
            group("Automatics Payroll Process")
            {
                Caption = 'Automatics Payroll Process';
                action("&Create file")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Create file';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //  PagosElectronicos.FormatoBancoDiario("Journal Template Name", "Journal Batch Name");
                    end;
                }
                action("&Generate Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Generate Journal';
                    Image = EntriesList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ProcesoEDNomina: Report "Proceso Gtos. Nomina";
                    begin
                        ProcesoEDNomina.RecibeParametros(rec."Journal Template Name", rec."Journal Batch Name");
                        ProcesoEDNomina.RunModal;
                    end;
                }
                action("Generate Journal from Excel")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Generate Journal from Excel';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        EDExcel: Report "Crea ED Empleados";
                    begin

                        EDExcel.RecibeParametros(rec."Journal Template Name", rec."Journal Batch Name");
                        EDExcel.RunModal;
                    end;
                }
            }
        }
    }

    var
        BinVisible: Boolean;
        GJB: Record "Gen. Journal Batch";


    procedure ActivaCampos()
    begin
    end;
}

