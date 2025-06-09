// pageextension 50135 pageextension50135 extends "Accountant Role Center"
// {
//     actions
//     {
//         modify("Trial Balance Detail/Summary")
//         {
//             ToolTip = 'View general ledger account balances and activities for all the selected accounts, one transaction per line. You can include general ledger accounts which have a balance and including the closing entries within the period.';
//         }
//         modify("Trial Bala&nce, Spread Periods")
//         {
//             Caption = 'Trial Bala&nce, Spread Periods';
//         }
//         modify("Sales Taxes Collected")
//         {
//             ToolTip = 'View a report that shows the sales taxes that have been collected on behalf of the authorities.';
//         }
//         modify("Sales Tax Details")
//         {
//             ToolTip = 'View a complete or partial list of all sales tax details. For each jurisdiction, all tax groups with their tax types and effective dates are listed.';
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
//         modify("Item Turnover")
//         {
//             ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
//         }
//         modify("Incoming Documents")
//         {
//             ToolTip = 'Handle incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.';
//         }
//         modify(Budgets)
//         {
//             ToolTip = 'View or edit estimated amounts for a range of accounting periods.';
//         }
//         modify("G/L Account Categories")
//         {
//             ToolTip = 'Personalize the structure of your financial statements by mapping general ledger accounts to account categories. You can create category groups by indenting subcategories under them. Each grouping shows a total balance. When you choose the Generate Account Schedules action, the account schedules for the underlying financial reports are updated. The next time you run one of these reports, such as the balance statement, new totals and subentries are added, based on your changes.';
//         }
//         modify("Number Series")
//         {
//             ToolTip = 'View or edit the number series that are used to organize transactions';
//         }
//         /*modify(Action116) //G/L Account Categories No se encuentra esta acción y el tooltip que 
//         {
//             ToolTip = 'Personalize the structure of your financial statements by mapping general ledger accounts to account categories. You can create category groups by indenting subcategories under them. Each grouping shows a total balance. When you choose the Generate Account Schedules action, the account schedules for the underlying financial reports are updated. The next time you run one of these reports, such as the balance statement, new totals and subentries are added, based on your changes.';
//         }*/
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
//         modify("Tax Details")
//         {
//             ToolTip = 'View a complete or partial list of all sales tax details. For each jurisdiction, all tax groups with their tax types and effective dates are listed.';
//         }
//         modify("<Action3>")
//         {
//             ToolTip = 'Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, or fixed asset accounts';
//         }
//         modify(Action164)
//         {
//             ToolTip = 'View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.';
//         }
//         modify(Deposit)
//         {
//             ToolTip = 'Create a new deposit. ';
//         }
//         modify("Chart of Cash Flow Accounts")
//         {
//             Caption = 'Chart of Cash Flow Accounts';
//         }
//         modify(Action17)
//         {
//             ToolTip = 'Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.';
//         }
//         modify("Fixed Assets G/L Journals")
//         {
//             ToolTip = 'Post fixed asset transactions, such as acquisition and depreciation, in integration with the general ledger. The FA G/L Journal is a general journal, which is integrated into the general ledger.';
//         }
//         modify("Fixed Assets Reclass. Journals")
//         {
//             ToolTip = 'Transfer, split, or combine fixed assets by preparing reclassification entries to be posted in the fixed asset journal.';
//         }
//         modify("Recurring Fixed Asset Journals")
//         {
//             Caption = 'Recurring Fixed Asset Journals';
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
//             ToolTip = 'Open the list of posted purchase credit memos.';
//         }
//         modify("Issued Fin. Charge Memos")
//         {
//             Caption = 'Issued Fin. Charge Memos';
//         }
//         modify("Posted Deposits")
//         {
//             ToolTip = 'View the posted deposit header, deposit header lines, deposit comments, and deposit dimensions.';
//         }
//         modify("Posted Bank Recs.")
//         {
//             ToolTip = 'View the entries and the balance on your bank accounts against a statement from the bank.';
//         }
//         /*modify(SetupAndExtensions) //nuevo grupo y botones? validar y traer funcionalidad de nav
//         {
//             ToolTip = 'Overview and change system and application settings, and manage extensions and services';
//         }
//         modify("Assisted Setup")
//         {
//             ToolTip = 'Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.';
//         }
//         modify(Finance)
//         {
//             ToolTip = 'Collect and make payments, prepare statements, and reconcile bank accounts.';
//         }
//         modify(Purchasing)
//         {
//             ToolTip = 'Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.';
//         }
//         modify(Jobs)
//         {
//             ToolTip = 'Define a project activity by creating a job card with integrated job tasks and job planning lines, structured in two layers. The job task enables you to set up job planning lines and to post consumption to the job. The job planning lines specify the detailed use of resources, items, and various general ledger expenses.';
//         }
//         modify("Fixed Assets")
//         {
//             ToolTip = 'Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.';
//         }*/
//         modify(Action1020012)
//         {
//             ToolTip = 'Create a new deposit. ';
//         }
//         modify("General Journal")
//         {
//             ToolTip = 'Prepare to post any transaction to the company books.';
//         }
//         modify("Payment Journals")
//         {
//             ToolTip = 'Open the list of payment journals where you can register payments to vendors.';
//         }
//         modify("Purchase Journals")
//         {
//             ToolTip = 'Open the list of purchase journals where you can batch post purchase transactions to G/L, bank, customer, vendor and fixed assets accounts.';
//         }
//         modify("Statement of Retained Earnings")
//         {
//             Caption = 'Statement of Retained Earnings';
//             ToolTip = 'View a report that shows your company''s changes in retained earnings for a specified period by reconciling the beginning and ending retained earnings for the period, using information such as net income from the other financial statements.';
//         }
//         /*modify(Action112) Nuevos botones?
//         {
//             ToolTip = 'Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.';
//         }
//         modify("Accounting /Periods")
//         {
//             ToolTip = 'Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.';
//         }
//         modify("&Purchases && Payables Setup")
//         {
//             ToolTip = 'Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.';
//         }
//         modify("Cost Accounting Setup")
//         {
//             ToolTip = 'Specify how you transfer general ledger entries to cost accounting, how you link dimensions to cost centers and cost objects, and how you handle the allocation ID and allocation document number.';
//         }*/
//         modify("Navi&gate")
//         {
//             ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
//         }
//         addafter(History)
//         {
//             group("DS Localization")
//             {
//                 Caption = 'DS Localization';
//                 action("Conf. Retencion Proveedores")
//                 {
//                 ApplicationArea = All;
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
//                 ApplicationArea = All;
//                     Caption = 'Void Reasons';
//                     Image = AllLines;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Razones de anulacion";
//                 }
//                 action("Clasificacion de Gastos")
//                 {
//                 ApplicationArea = All;
//                     Caption = 'Expenses Class';
//                     Image = AllLines;
//                     //Promoted = true;
//                     RunObject = Page "Clasificacion Gastos";
//                 }
//                 action("Listado RNC DGII")
//                 {
//                 ApplicationArea = All;
//                     Caption = 'DGII RNC List';
//                     Image = List;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Listado RNC DGII";
//                 }
//                 action("Campos requeridos")
//                 {
//                 ApplicationArea = All;
//                     Caption = 'Required Fields';
//                     Image = List;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Lista Campos Requeridos";
//                 }
//                 action("Dimensiones Requeridas")
//                 {
//                 ApplicationArea = All;
//                     Caption = 'Required Dimensions';
//                     Image = List;
//                     //Promoted = true;
//                     //PromotedIsBig = true;
//                     RunObject = Page "Lista Dimensiones Requeridas";
//                 }
//                 group("Periodic Activities")
//                 {
//                     Caption = 'Periodic Activities';
//                     Image = Alerts;
//                     action("Archivo Transferencia ITBIS")
//                     {
//                     ApplicationArea = All;
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Historico de Retencion";
//                     }
//                     action("Archivo Transferencia ITBIS 606")
//                     {
//                     ApplicationArea = All;
//                         Caption = 'Archivo Transferencia ITBIS 606';
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Archivo Transf. ITBIS 606";
//                     }
//                     action("Archivo Transferenci ITBIS 607 ")
//                     {
//                     ApplicationArea = All;
//                         Caption = 'Archivo Transferencia ITBIS 607';
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Archivo Transf. ITBIS 607";
//                     }
//                     action("Archivo Transfer ITBIS 607-A")
//                     {
//                     ApplicationArea = All;
//                         Caption = 'Archivo Transferencia ITBIS 607-A';
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Archivo Transf. ITBIS 607-A";
//                     }
//                     action("Archivo TransfeITBIS 608")
//                     {
//                     ApplicationArea = All;
//                         Caption = 'Archivo Transferencia ITBIS 608';
//                         Image = "Report";
//                         //Promoted = true;
//                         //PromotedIsBig = true;
//                         RunObject = Page "Pre Sales List";
//                     }
//                     action("Compra B-S 2018 (606)")
//                     {
//                     ApplicationArea = All;
//                         RunObject = Report "Compra B-S 2018 (606)";
//                     }
//                     action("ITBIS Ventas 2018 (607)")
//                     {
//                     ApplicationArea = All;
//                         RunObject = Report "ITBIS Ventas 2018 (607)";
//                     }
//                     action("Facturas de Consumo (607-A)")
//                     {
//                     ApplicationArea = All;
//                         Caption = 'Facturas de Consumo (607-A)';
//                         RunObject = Report "Facturas de Consumo (607-A)";
//                     }
//                     action("NCF Anulados (608)")
//                     {
//                     ApplicationArea = All;
//                         RunObject = Report "NCF Anulados (608)";
//                     }
//                     action("Pagos al Exterior (609)")
//                     {
//                     ApplicationArea = All;
//                         RunObject = Report "Pagos al Exterior (609)";
//                     }
//                     action("Reporte Compra Divisas (612)")
//                     {
//                     ApplicationArea = All;
//                         RunObject = Report "Reporte Compra Divisas (612)";
//                     }
//                 }
//             }
//         }
//     }
// }

