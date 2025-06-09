// pageextension 50046 pageextension50046 extends "Bank Account Card"
// {
//     layout
//     {
//         modify("Check Date Format")
//         {
//             ToolTip = 'Specifies how the date will appear on the printed check image for this bank account.';
//         }
//         modify("Address 2")
//         {
//             ToolTip = 'Specifies additional address information.';
//         }
//         modify("Currency Code")
//         {
//             ToolTip = 'Specifies the relevant currency code for the bank account.';
//         }
//         addafter("Check Date Separator")
//         {
//             field("Identificador Empresa"; rec."Identificador Empresa")
//             {
//             ApplicationArea = All;
//             }
//             field(Formato; rec.Formato)
//             {
//             ApplicationArea = All;
//             }
//             field(Secuencia; rec.Secuencia)
//             {
//             ApplicationArea = All;
//             }
//             field("Tipo Cuenta"; rec."Tipo Cuenta")
//             {
//             ApplicationArea = All;
//             }
//         }
//     }
//     actions
//     {
//         modify(Statements)
//         {
//             ToolTip = 'View posted bank statements and reconciliations.';
//         }
//         modify(PostedReconciliations)
//         {
//             ToolTip = 'View the entries and the balance on your bank accounts against a statement from the bank.';
//         }
//         modify("Chec&k Ledger Entries")
//         {
//             ToolTip = 'View check ledger entries that result from posting transactions in a payment journal for the relevant bank account.';
//         }
//         modify(BankAccountReconciliations)
//         {
//             ToolTip = 'Reconcile your bank account by importing transactions and applying them, automatically or manually, to open customer ledger entries, open vendor ledger entries, or open bank account ledger entries.';
//         }
//         modify("Receivables-Payables")
//         {
//             ToolTip = 'View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.';
//         }
//         modify(Action1906306806)
//         {
//             ToolTip = 'View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.';
//         }
//         modify("Bank Account - Reconcile")
//         {
//             ToolTip = 'Reconcile bank transactions with bank account ledger entries to ensure that your bank account in Dynamics NAV reflects your actual liquidity.';
//         }
//         modify("Projected Cash Receipts")
//         {
//             ToolTip = 'View projections about cash receipts for up to four periods. You can specify the start date as well as the type of periods, such as days, weeks, months, or years.';
//         }
//         modify("Projected Cash Payments")
//         {
//             ToolTip = 'View projections about what future payments to vendors will be. Current orders are used to generate a chart, using the specified time period and start date, to break down future payments. The report also includes a total balance column.';
//         }
//     }
// }

