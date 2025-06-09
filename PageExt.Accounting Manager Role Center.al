// pageextension 50131 pageextension50131 extends "Accounting Manager Role Center"
// {
//     actions
//     {
//         modify("&G/L Trial Balance")
//         {
//             ToolTip = 'View, print, or send a report that shows the balances for the general ledger accounts, including the debits and credits. You can use this report to ensure accurate accounting practices.';
//         }
//         modify(Budget)
//         {
//             ToolTip = 'View or edit estimated amounts for a range of accounting periods.';
//         }
//         modify("Trial Bala&nce/Budget")
//         {
//             ToolTip = 'View a trial balance in comparison to a budget. You can choose to see a trial balance for selected dimensions. You can use the report at the close of an accounting period or fiscal year.';
//         }
//         modify("Trial Bala&nce, Spread Periods")
//         {
//             Caption = 'Trial Bala&nce, Spread Periods';
//         }
//         modify("Trial Balance Detail/Summary")
//         {
//             ToolTip = 'View general ledger account balances and activities for all the selected accounts, one transaction per line. You can include general ledger accounts which have a balance and including the closing entries within the period.';
//         }
//         modify("&Fiscal Year Balance")
//         {
//             ToolTip = 'View, print, or send a report that shows balance sheet movements for selected periods. The report shows the closing balance by the end of the previous fiscal year for the selected ledger accounts. It also shows the fiscal year until this date, the fiscal year by the end of the selected period, and the balance by the end of the selected period, excluding the closing entries. The report can be used at the close of an accounting period or fiscal year.';
//         }
//         modify("Balance Comp. - Prev. Y&ear")
//         {
//             ToolTip = 'View a report that shows your company''s assets, liabilities, and equity compared to the previous year.';
//         }
//         modify("Cash Flow Date List")
//         {
//             ToolTip = 'View forecast entries for a period of time that you specify. The registered cash flow forecast entries are organized by source types, such as receivables, sales orders, payables, and purchase orders. You specify the number of periods and their length.';
//         }
//         modify("Aged Accounts &Receivable")
//         {
//             ToolTip = 'View an overview of when your receivables from customers are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
//         }
//         modify("Aged Accounts Pa&yable")
//         {
//             ToolTip = 'View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
//         }
//         modify("Projected Cash Receipts")
//         {
//             ToolTip = 'View projections about cash receipts for up to four periods. You can specify the start date as well as the type of periods, such as days, weeks, months, or years.';
//         }
//         modify("Cash Requirem. by Due Date")
//         {
//             ToolTip = 'View cash requirements for a specific due date. The report includes open entries that are not on hold. Based on these entries, the report calculates the values for the remaining amount and remaining amount in the local currency.';
//         }
//         modify("Projected Cash Payments")
//         {
//             ToolTip = 'View projections about what future payments to vendors will be. Current orders are used to generate a chart, using the specified time period and start date, to break down future payments. The report also includes a total balance column.';
//         }
//         modify("Reconcile Cust. and Vend. Accs")
//         {
//             Caption = 'Reconcile Cust. and Vend. Accs';
//         }
//         modify("Bank Account - Reconcile")
//         {
//             ToolTip = 'Reconcile bank transactions with bank account ledger entries to ensure that your bank account in Dynamics NAV reflects your actual liquidity.';
//         }
//         modify("Sales Tax Jurisdictions")
//         {
//             Caption = 'Sales Tax Jurisdictions';
//             ToolTip = 'View a list of sales tax jurisdictions that you can use to identify tax authorities for sales and purchases tax calculations. This report shows the codes that are associated with a report-to jurisdiction area. Each sales tax area is assigned a tax account for sales and a tax account for purchases. These accounts define the sales tax rates for each sales tax jurisdiction.';
//         }
//         modify("Sales Tax Areas")
//         {
//             Caption = 'Sales Tax Areas';
//             ToolTip = 'View a complete or partial list of sales tax areas.';
//         }
//         modify("Sales Tax Detail by Area")
//         {
//             ToolTip = 'Verify that each sales tax area is set up correctly. Each sales tax area includes all of its jurisdictions. For each jurisdiction, all tax groups are listed with their tax types and effective dates. Note that the same sales tax jurisdiction, along with all of its details, may appear more than once since the jurisdiction may be used in more than one area.';
//         }
//         modify("Sales Taxes Collected")
//         {
//             ToolTip = 'View a report that shows the sales taxes that have been collected on behalf of the authorities.';
//         }
//         /*modify("VAT Statement") Nueva acción
//         {
//             ToolTip = 'View a statement of posted tax and calculate the duty liable to the customs authorities for the selected period.';
//         }*/
//         modify("VAT - VIES Declaration Tax Aut&h")
//         {
//             ToolTip = 'View information to the customs and tax authorities for sales to other EU countries/regions. If the information must be printed to a file, you can use the VAT- VIES Declaration Disk report.';
//         }
//         modify("VAT - VIES Declaration Dis&k")
//         {
//             ToolTip = 'Report your sales to other EU countries or regions to the customs and tax authorities. If the information must be printed out on a printer, you can use the Tax- VIES Declaration Tax Auth report. The information is shown in the same format as in the declaration list from the customs and tax authorities.';
//         }
//         modify("EC Sales &List")
//         {
//             ToolTip = 'Calculate Tax amounts from sales, and submit the amounts to a tax authority.';
//         }
//         /*         modify("&Intrastat - Checklist")
//                 {
//                     ToolTip = 'View a checklist that you can use to find possible errors before printing and also as documentation for what is printed. You can use the report to check the Intrastat journal before you use the Intrastat - Make Disk Tax Auth batch job.';
//                 } */
//         modify("Outstanding Purch. Order Aging")
//         {
//             Caption = 'Outstanding Purch. Order Aging';
//         }
//         modify("Item Turnover")
//         {
//             ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
//         }
//         modify(Action2)
//         {
//             ToolTip = 'View the chart of accounts.';
//         }
//         modify(Budgets)
//         {
//             ToolTip = 'View or edit estimated amounts for a range of accounting periods.';
//         }
//         modify("Sales Orders")
//         {
//             ToolTip = 'Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.';
//         }
//         modify("Incoming Documents")
//         {
//             ToolTip = 'Handle incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.';
//         }
//         modify(CashReceiptJournals)
//         {
//             ToolTip = 'Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.';
//         }
//         modify(Action17)
//         {
//             ToolTip = 'Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.';
//         }
//         modify(Insurance)
//         {
//             ToolTip = 'Manage insurance policies for fixed assets and monitor insurance coverage.';
//         }
//         modify("Fixed Assets G/L Journals")
//         {
//             ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation, in integration with the general ledger. The FA G/L Journal is a general journal, which is integrated into the general ledger.';
//         }
//         modify("<Action3>")
//         {
//             ToolTip = 'Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, or fixed asset accounts';
//         }
//         modify("Recurring Fixed Asset Journals")
//         {
//             Caption = 'Recurring Fixed Asset Journals';
//         }
//         modify("Cash Flow Manual Revenues")
//         {
//             Caption = 'Cash Flow Manual Revenues';
//         }
//         modify("Cash Flow Manual Expenses")
//         {
//             Caption = 'Cash Flow Manual Expenses';
//         }
//         modify("Posted Sales Invoices")
//         {
//             ToolTip = 'Open the list of posted sales invoices.';
//         }
//         modify("Posted Sales Credit Memos")
//         {
//             Caption = 'Posted Sales Credit Memos';
//         }
//         modify("Posted Purchase Credit Memos")
//         {
//             Caption = 'Posted Purchase Credit Memos';
//         }
//         modify("Issued Fin. Charge Memos")
//         {
//             Caption = 'Issued Fin. Charge Memos';
//         }
//         modify("G/L Registers")
//         {
//             ToolTip = 'View posted G/L entries.';
//         }
//         modify("Cost Accounting Budget Registers")
//         {
//             Caption = 'Cost Accounting Budget Registers';
//         }
//         modify("Number Series")
//         {
//             ToolTip = 'View or edit the number series that are used to organize transactions';
//         }
//         modify("Bank Account Posting Groups")
//         {
//             Caption = 'Bank Account Posting Groups';
//         }
//         modify("Tax Areas")
//         {
//             ToolTip = 'View a complete or partial list of sales tax areas.';
//         }
//         modify("Tax Jurisdictions")
//         {
//             ToolTip = 'View a list of sales tax jurisdictions that you can use to identify tax authorities for sales and purchases tax calculations. This report shows the codes that are associated with a report-to jurisdiction area. Each sales tax area is assigned a tax account for sales and a tax account for purchases. These accounts define the sales tax rates for each sales tax jurisdiction.';
//         }
//         modify(Deposit)
//         {
//             ToolTip = 'Create a new deposit. ';
//         }
//         modify("Bank Account Reconciliation")
//         {
//             ToolTip = 'Reconcile bank transactions with bank account ledger entries to ensure that your bank account in Dynamics NAV reflects your actual liquidity.';
//         }
//         modify("Pa&yment Journal")
//         {
//             ToolTip = 'Make payments to vendors.';
//         }
//         modify("Purchase Journal")
//         {
//             ToolTip = 'Open the list of purchase journals where you can batch post purchase transactions to G/L, bank, customer, vendor and fixed assets accounts.';
//         }
//         modify(Action1480100)
//         {
//             ToolTip = 'Create a new deposit. ';
//         }
//         modify("Bank Account R&econciliation")
//         {
//             ToolTip = 'View the entries and the balance on your bank accounts against a statement from the bank.';
//         }
//         modify("Adjust E&xchange Rates")
//         {
//             ToolTip = 'Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.';
//         }
//         modify("P&ost Inventory Cost to G/L")
//         {
//             ToolTip = 'Record the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.';
//         }
//         modify("Create Finance Charge &Memos")
//         {
//             ToolTip = 'Create finance charge memos for one or more customers with overdue payments.';
//         }
//         /*         modify("Intrastat &Journal")
//                 {
//                     ToolTip = 'Report your trade with other EU countries/regions for Intrastat reporting.';
//                 } */
//         modify("&Purchases && Payables Setup")
//         {
//             ToolTip = 'Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.';
//         }
//         modify("Cash Flow Setup")
//         {
//             ToolTip = 'Set up the accounts where cash flow figures for sales, purchase, and fixed-asset transactions are stored.';
//         }
//         modify("Cost Accounting Setup")
//         {
//             ToolTip = 'Specify how you transfer general ledger entries to cost accounting, how you link dimensions to cost centers and cost objects, and how you handle the allocation ID and allocation document number.';
//         }
//         modify("Navi&gate")
//         {
//             ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
//         }
//         modify("Export GIFI Info. to Excel")
//         {
//             Caption = 'Export GIFI Info. to Excel';
//         }
//         addafter("Purchase Orders")
//         {
//             action("Invoice Refund")
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'Invoice Refund';
//                 RunObject = Page "Facturas Reembolso";
//             }
//         }
//         addafter("Tax Product Posting Groups")
//         {
//             action("Tipo Contribuyente - Retencion")
//             {
//                 ApplicationArea = All;
//                 Image = ListPage;
//                 RunObject = Page "Tipo Contribuyente - Retencion";
//             }
//         }
//         addafter("Export GIFI Info. to Excel")
//         {
//             group("DS Localization")
//             {
//                 Caption = 'DS Localization';
//                 action("Conf. Retencion Proveedores")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Vendor Retention Setup';
//                     Image = CalculateCost;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Config. Retencion Proveedores";
//                     RunPageView = SORTING("Código Retención")
//                                   ORDER(Ascending);
//                 }
//                 action("Razones Anulacion")
//                 {
//                     ApplicationArea = All;

//                     Caption = 'Void Reasons';
//                     Image = AllLines;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Razones de anulacion";
//                 }
//                 action("Clasificacion de Gastos")
//                 {
//                     ApplicationArea = All;

//                     Caption = 'Expenses Class';
//                     Image = AllLines;
//                     //Promoted = true;
//                     RunObject = Page "Clasificacion Gastos";
//                 }
//                 action("Listado RNC DGII")
//                 {
//                     ApplicationArea = All;

//                     Caption = 'DGII RNC List';
//                     Image = List;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Listado RNC DGII";
//                 }
//                 action("Campos requeridos")
//                 {
//                     ApplicationArea = All;

//                     Caption = 'Required Fields';
//                     Image = List;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Lista Campos Requeridos";
//                 }
//                 action("Dimensiones Requeridas")
//                 {
//                     ApplicationArea = All;

//                     Caption = 'Required Dimensions';
//                     Image = List;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Lista Dimensiones Requeridas";
//                 }
//                 action("Proveedor - Retencion")
//                 {
//                     Caption = 'Proveedor - Retención';
//                     Image = List;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     ApplicationArea = All;
//                     RunObject = Page "Proveedor - Retencion";
//                 }
//                 action("Histórico Retención Prov.")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Histórico Retención Prov.';
//                     Image = List;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Historico Retencion Prov.";
//                 }
//                 group("Periodic Activities")
//                 {
//                     Caption = 'Periodic Activities';
//                     Image = Alerts;
//                     action("Archivo Transferencia ITBIS")
//                     {
//                         ApplicationArea = All;
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Historico de Retencion";
//                     }
//                     action("Archivo Transferencia ITBIS 606")
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Archivo Transferencia ITBIS 606';
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Archivo Transf. ITBIS 606";
//                     }
//                     action("Archivo Transferenci ITBIS 607 ")
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Archivo Transferencia ITBIS 607';
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Archivo Transf. ITBIS 607";
//                     }
//                     action("Archivo Transfer ITBIS 607-A")
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Archivo Transferencia ITBIS 607-A';
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Archivo Transf. ITBIS 607-A";
//                     }
//                     action("Archivo TransfeITBIS 608")
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Archivo Transferencia ITBIS 608';
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Pre Sales List";
//                     }
//                     action("Compra B-S 2018 (606)")
//                     {
//                         ApplicationArea = All;
//                         RunObject = Report "Compra B-S 2018 (606)";
//                     }
//                     action("ITBIS Ventas 2018 (607)")
//                     {
//                         ApplicationArea = All;
//                         RunObject = Report "ITBIS Ventas 2018 (607)";
//                     }
//                     action("Facturas de Consumo (607-A)")
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Facturas de Consumo (607-A)';
//                         RunObject = Report "Facturas de Consumo (607-A)";
//                     }
//                     action("NCF Anulados (608)")
//                     {
//                         ApplicationArea = All;
//                         RunObject = Report "NCF Anulados (608)";
//                     }
//                     action("Pagos al Exterior (609)")
//                     {
//                         ApplicationArea = All;
//                         RunObject = Report "Pagos al Exterior (609)";
//                     }
//                     action("Reporte Compra Divisas (612)")
//                     {
//                         ApplicationArea = All;
//                         RunObject = Report "Reporte Compra Divisas (612)";
//                     }
//                 }
//             }
//         }
//     }
// }

