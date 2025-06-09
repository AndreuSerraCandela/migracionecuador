pageextension 50132 pageextension50132 extends "Order Processor Role Center"
{
    actions
    {
        modify(SalesOrders)
        {
            ToolTip = 'Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.';
        }
        modify(CashReceiptJournals)
        {
            ToolTip = 'Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.';
        }
        modify(Action61)
        {
            ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
        }
        modify("Sales Quotes")
        {
            ToolTip = 'Make offers to customers to sell certain products on certain delivery and payment terms. While you negotiate with a customer, you can change and resend the sales quote as much as needed. When the customer accepts the offer, you convert the sales quote to a sales invoice or a sales order in which you process the sale.';
        }
        modify("Blanket Sales Orders")
        {
            ToolTip = 'Use blanket sales orders as a framework for a long-term agreement between you and your customers to sell large quantities that are to be delivered in several smaller shipments over a certain period of time. Blanket orders often cover only one item with predetermined delivery dates. The main reason for using a blanket order rather than a sales order is that quantities entered on a blanket order do not affect item availability and thus can be used as a worksheet for monitoring, forecasting, and planning purposes..';
        }
        modify("Sales Credit Memos")
        {
            ToolTip = 'Revert the financial transactions involved when your customers want to cancel a purchase or return incorrect or damaged items that you sent to them and received payment for. To include the correct information, you can create the sales credit memo from the related posted sales invoice or you can create a new sales credit memo with copied invoice information. If you need more control of the sales return process, such as warehouse documents for the physical handling, use sales return orders, in which sales credit memos are integrated. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.';
        }
        modify("Blanket Purchase Orders")
        {
            Caption = 'Blanket Purchase Orders';
            ToolTip = 'Use blanket purchase orders as a framework for a long-term agreement between you and your vendors to buy large quantities that are to be delivered in several smaller shipments over a certain period of time. Blanket orders often cover only one item with predetermined delivery dates. The main reason for using a blanket order rather than a purchase order is that quantities entered on a blanket order do not affect item availability and thus can be used as a worksheet for monitoring, forecasting, and planning purposes.';
        }
        modify("Purchase Credit Memos")
        {
            ToolTip = 'Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.';
        }
        modify("Posted Purchase Credit Memos")
        {
            Caption = 'Posted Purchase Credit Memos';
        }
        modify("Posted Purchase Receipts")
        {
            ToolTip = 'Open the list of posted purchase receipts.';
        }
        modify(Action62)
        {
            ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
        }
        modify("Item Charges")
        {
            ToolTip = 'View or edit the codes for item charges that you can assign to purchase and sales transactions to include any added costs, such as freight, physical handling, and insurance that you incur when purchasing or selling items. This is important to ensure correct inventory valuation. For purchases, the landed cost of a purchased item consists of the vendor''s purchase price and all additional direct item charges that can be assigned to individual receipts or return shipments. For sales, knowing the cost of shipping sold items can be as vital to your company as knowing the landed cost of purchased items.';
        }
        modify(Action32)
        {
            ToolTip = 'Open the list of posted sales invoices.';
        }
        modify(Action34)
        {
            Caption = 'Posted Sales Credit Memos';
        }
        modify(Action40)
        {
            ToolTip = 'Open the list of posted sales shipments.';
        }
        modify(Action86)
        {
            Caption = 'Posted Purchase Credit Memos';
        }
        modify("Issued Finance Charge Memos")
        {
            Caption = 'Issued Finance Charge Memos';
            ToolTip = 'Opens the list of issued finance charge memos.';
        }
        // modify("Customer Statements")
        // {
        //     Visible = false;
        // }
        /*         modify(SetupAndExtensions)
                {
                    ToolTip = 'Overview and change system and application settings, and manage extensions and services';
                }
                modify("Assisted Setup")
                {
                    ToolTip = 'Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.';
                }
                modify(Purchasing)
                {
                    ToolTip = 'Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.';
                }
                modify(Jobs)
                {
                    ToolTip = 'Define a project activity by creating a job card with integrated job tasks and job planning lines, structured in two layers. The job task enables you to set up job planning lines and to post consumption to the job. The job planning lines specify the detailed use of resources, items, and various general ledger expenses.';
                }
                modify("Fixed Assets")
                {
                    ToolTip = 'Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.';
                }
                modify(HR)
                {
                    ToolTip = 'Set up number series for creating new employee cards and define if employment time is measured by days or hours.';
                }
                modify(Inventory)
                {
                    ToolTip = 'Define your general inventory policies, such as whether to allow negative inventory and how to post and adjust item costs. Set up your number series for creating new inventory items or services.';
                }
                modify("Relationship Management")
                {
                    ToolTip = 'Set up business relations, configure sales cycles, campaigns, and interactions, and define codes for various marketing communication.';
                } */
        modify("Sales &Invoice")
        {
            ToolTip = 'Create a new invoice for the sales of items or services. Invoice quantities cannot be posted partially.';
        }
        modify("Sales &Return Order")
        {
            ToolTip = 'Compensate your customers for incorrect or damaged items that you sent to them and received payment for. Sales return orders enable you to receive items from multiple sales documents with one sales return, automatically create related sales credit memos or other return-related documents, such as a replacement sales order, and support warehouse documents for the item handling. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.';
        }
        modify("Sales &Credit Memo")
        {
            ToolTip = 'Create a new sales credit memo to revert a posted sales invoice.';
        }
        modify("Customer - &Order Summary")
        {
            ToolTip = 'View the quantity not yet shipped for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company''s expected sales volume.';
        }
        // modify("Customer/Item Statistics")
        // {
        //     ToolTip = 'View a list of item sales for each customer during a selected time period. The report contains information on quantity, sales amount, profit, and possible discounts. It can be used, for example, to analyze a company''s customer groups.';
        // }
        // modify("Cust./Item Stat. by Salespers.")
        // {
        //     ToolTip = 'View amounts for sales, profit, invoice discount, and payment discount, as well as profit percentage, for each salesperson for a selected period. The report also shows the adjusted profit and adjusted profit percentage, which reflect any changes to the original costs of the items in the sales.';
        // }
        // modify("List Price Sheet")
        // {
        //     ToolTip = 'View a list of your items and their prices, for example, to send to customers. You can create the list for specific customers, campaigns, currencies, or other criteria.';
        //}
        modify("Inventory - Sales &Back Orders")
        {
            ToolTip = 'View a list with the order lines whose shipment date has been exceeded. The following information is shown for the individual orders for each item: number, customer name, customer''s telephone number, shipment date, order quantity and quantity on back order. The report also shows whether there are other items for the customer on back order.';
        }
        modify("Navi&gate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        addfirst(Embedding)
        {
            action("<Page Pre Sales List>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pre Sales Orders';
                Image = "Order";
                RunObject = Page "PreSales Order List";
            }
        }
        addafter("Sales Quotes")
        {
            action("<Page Pre Sales List2>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pre Sales Orders';
                Image = "Order";

                RunObject = Page "PreSales Order List";
            }
        }
        addafter("Posted Documents")
        {
            group("DS-POS")
            {
                Caption = 'DS-POS';
                Image = History;

                action("Facturas Venta Regis POS")
                {
                    RunObject = Page "Facturas Venta Regis POS";
                    ApplicationArea = Basic, Suite;
                }
                action("Notas Credito Venta Regis POS")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Notas Credito Venta Regis POS";
                }
                action("Lista Pagos TPV")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Pagos TPV";
                }
                action("Facturas Pendientes POS")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Facturas Pendientes POS";
                }
                action("Notas Crédito Pdtes POS")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Notas Credito Pdtes POS";
                }
                action("Lista Registro Ventas DsPOS")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Registro Ventas DsPOS";
                }
                action(Tiendas)
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Tiendas";
                }
                action(TPVs)
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista TPVs";
                }
                action("Grupos Cajero")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Grupo Cajeros";
                }
                action(Cajeros)
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Cajeros";
                }
                action(Vendedores)
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Vendedores";
                }
                action(Almacenes)
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Almacenes TPV";
                }
                action(Acciones)
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Acciones";
                }
                action("Dimensiones POS")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Dimensiones POS";
                }
                action("Menus TPV")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Menus TPV";
                }
                action("Tipos de Tarjeta")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Tipos de Tarjeta";
                }
                action("Forma de Pago")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lista Formas de Pago";
                }
                action("Billetes y Monedas Divisa")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Config. arqueo de caja";
                }
                action("List Cab Vtas SIC")
                {
                    Image = ListPage;
                    RunObject = Page "List Cab Vtas SIC";
                    ApplicationArea = Basic, Suite;
                }
                action("Lista Lineas Ventas SIC")
                {
                    Image = ListPage;
                    RunObject = Page "Lista Lineas Ventas SIC";
                    ApplicationArea = Basic, Suite;
                }
                action("Lista Medios de Pagos SIC")
                {
                    Image = ListPage;
                    RunObject = Page "Lista Medios de Pagos SIC";
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        addafter(Action42)
        {
            group("Call Center")
            {
                Caption = 'Call Center';
                action("Sales Orders Call Center")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Orders Call Center';
                    Image = "Order";
                    RunObject = Page "Sales Order Call Center  List";
                }
                action("Import Call Center Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Call Center Orders';
                    Image = Import;
                    RunObject = Report "Importar Pedido Call Center";
                }
                action("Cancel reservations Call Center")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel reservations Call Center';
                    Image = Cancel;
                    RunObject = Codeunit "Cancelar reservas Call Center";
                }
            }
            group(Mobility)
            {
                Caption = 'Mobility';
                action("Calculate Mobile Inventory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Calculate Mobile Inventory';
                    Image = InventoryJournal;
                    RunObject = Report "Calcula Inventario Movil.";
                }
            }
            group(Consignment)
            {
                Caption = 'Consignment';
                action("Pre Consignment Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pre Consignment Order';
                    Image = List;

                    RunObject = Page "Lista Pre-Pedidos Consignacion";
                    RunPageMode = View;
                }
                action("Order Transfer Consignment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Order Transfer Consignment';
                    Image = List;


                    RunObject = Page "Lista Pedidos Consignacion";
                }
                action("Return Orders Consignment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Return Orders Consignment';
                    Image = List;

                    RunObject = Page "Lista Dev. Pedidos Consig.";
                }
                group("Reports ")
                {
                    Caption = 'Reports';
                    Image = LotInfo;
                    action("Consignment sale x title")
                    {
                        ApplicationArea = Suite, Basic;
                        Caption = 'Consignment sale x title';
                        Image = Report2;
                        RunObject = Report "Venta a consignacion x título";
                    }
                    action("Informe Detalle Consignacion")
                    {
                        ApplicationArea = Suite, Basic;
                        Caption = 'Consignment Detail Report';
                        Image = Report2;
                        RunObject = Report "Informe Detalle Consignación";
                    }
                    action("Reporte Consignación x cliente")
                    {
                        ApplicationArea = Suite, Basic;
                        Caption = 'Consignment x client report';
                        Image = Report2;
                        RunObject = Report "Reporte Consignación x cliente";
                        RunPageMode = Edit;
                    }
                    action("Antiguedad Consignacion")
                    {
                        ApplicationArea = Suite, Basic;
                        Caption = 'Age Consignment';
                        Image = Report2;
                        RunObject = Report "Antiguedad Consignacion";
                    }
                    action("Antiguedad Importe Consig")
                    {
                        ApplicationArea = Suite, Basic;
                        Caption = 'Age Amount Consignment';
                        Image = Report2;
                        RunObject = Report "Antiguedad Importe Consig.";
                        RunPageMode = Edit;
                    }
                    action("Consignacion por categoria")
                    {
                        ApplicationArea = Suite, Basic;
                        Caption = 'Consignment by category';
                        Image = Report2;
                        RunObject = Report "Consignacion por categoria";
                    }
                    action("Consignacion por Almacen")
                    {
                        ApplicationArea = Suite, Basic;
                        Caption = 'Consignment by Warehouse';
                        Image = Report2;
                        RunObject = Report "Consignacion por Almacen";
                    }
                    action("Venta a Consignacion por item")
                    {
                        ApplicationArea = Suite, Basic;
                        Caption = 'Consignment sale per item';
                        Image = Report2;
                        RunObject = Report "Venta a Consignacion por item";
                        RunPageMode = Edit;
                    }
                    action("Consignacion Producto/Cliente")
                    {
                        ApplicationArea = Suite, Basic;
                        Caption = 'Consignment Product/Customer';
                        Image = Report2;
                        RunObject = Report "Consignacion Producto/Cliente";
                        RunPageMode = Edit;
                    }
                }
            }
            group("Back Order Management")
            {
                Caption = 'Back Order Management';
                action("BackOrder Management Sales line")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'BackOrder Management Sales line';
                    Image = OrderTracking;
                    RunObject = Page "Gestion BackOrder - SL";
                }
                action("Management BackOrder Line Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Management BackOrder Line Transfer';
                    Image = OrderTracking;
                    RunObject = Page "Gestion BackOrder - TL";
                }
                action("BackOrder No Availability Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'BackOrder No Availability Sales Order';
                    Image = OrderPromising;
                    RunObject = Page "BackOrders Sin Disp. Ped. Vta";
                }
                action("BackOrder Without Availability Order Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'BackOrder Without Availability Order Transfer';
                    Image = OrderReminder;
                    RunObject = Page "BackOrders Sin Disp. Transfer.";
                }
            }
            group("Classification Returns")
            {
                Caption = 'Classification Returns';
                action(Action1000000011)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Classification Returns';
                    Image = ReturnOrder;

                    RunObject = Page "Lista clas. devoluciones";
                }
                action("Classification Closed Returns")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Classification Closed Returns';
                    Image = ReturnOrder;

                    RunObject = Page "Lista clas. devoluciones cer.";
                }
                action("Classify Returns")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Classify Returns';
                    Image = ReturnOrder;

                    RunObject = Report "Clasifica devoluciones";
                }
                action("Delete Returns classification")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delete Returns classification';
                    Image = ReturnOrder;

                    RunObject = Report "Borrar devolu. procesadas";
                }
            }
            group(Packing)
            {
                Caption = 'Packing';
                action("Packing list header")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Packing list header';
                    Image = List;
                    RunObject = Page "Cab. Packing List";
                }
                action("Packing Position")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Packing Position';
                    Image = List;
                    RunObject = Page "Puestos de Packing";
                }
                action("Posted Packing Header")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Packing Header';
                    Image = Post;
                    RunObject = Page "Cab. Packing Reg. List";
                }
            }
            group("Route sheet")
            {
                Caption = 'Route sheet';
                action("Route Sheet list")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Route Sheet list';
                    Image = List;
                    RunObject = Page "Cab. Hoja de Ruta List";
                }
                action("Posted Route sheet list")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Route sheet list';
                    Image = Post;
                    RunObject = Page "Cab. Hoja de Ruta Reg. List";
                }
            }
            group(MdM)
            {
                Caption = 'MdM';
                group(Setting)
                {
                    Caption = 'Setting';
                    Image = Setup;
                    action("MdM Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'MdM Setup';
                        Image = Setup;
                        RunObject = Page "Configuracion MDM";
                    }
                    action("MdM Data")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'MdM Data';
                        Image = Setup;
                        RunObject = Page "Datos MDM";
                    }
                    action("Analytical Structure")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Analytical Structure';
                        Image = Setup;
                        RunObject = Page "Estructura Analitica";
                    }
                    action("Conf. Tipologias MdM")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Conf. Tipologias MdM';
                        Image = Setup;
                        RunObject = Page "Conf. Tipologias MdM";
                    }
                    action("MdM Conversion")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'MdM Conversion';
                        Image = Setup;
                        RunObject = Page "Conversion NAV MdM";
                    }
                    action("Analytical Structure Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Analytical Structure Setup';
                        Image = Setup;
                        RunObject = Page "Conf. Estructura Analitica";
                    }
                    action("Conf. Related Fields")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Conf. Related Fields';
                        Image = Setup;
                        RunObject = Page "Conf. Campos Relacionados";
                    }
                }
                group(Action1000000044)
                {
                    Caption = 'Tasks';
                    Image = Administration;
                    action("MdM Imports")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'MdM Imports';
                        Image = Import;
                        RunObject = Page "Importaciones MdM";
                    }
                    action("Update Dimensions Docs")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Update Dimensions Docs';
                        Image = "Report";
                        RunObject = Report "Actualiza Dimensiones Docs";
                    }
                }
                group(Action1000000041)
                {
                    Caption = 'Reports';
                    Image = LotInfo;
                    action("MdM Articles")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'MdM Articles';
                        Image = "Report";
                        RunObject = Report "Artículos MdM";
                    }
                }
            }
            group(MdE)
            {
                Caption = 'MdE';
                action("Equiv. NAV-MdE concepts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Equiv. NAV-MdE concepts';
                    Image = Setup;
                    RunObject = Page "Equiv. conceptos NAV-MdE";
                }
                action("Async NAV WS Process Queue")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Async NAV WS Process Queue';
                    Image = Web;
                    RunObject = Page "Async NAV WS Process Queue";
                }
            }
        }
        addafter(History)
        {
            group(Action1000000078)
            {
                Caption = 'DS-POS';
                action("Log Registro Ventas DsPOS")
                {
                    ApplicationArea = Suite, Basic;
                    RunObject = Page "Log Registro Ventas DsPOS";
                }
                action("Configuracion General DSPoS")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Configuracion General DSPoS";
                }
                /*  action("Log Trans Elect. Pend. GT")
                 {
                     ApplicationArea = Suite, Basic;
                     RunObject = Page GT;
                 } */
            }
        }
    }
}

