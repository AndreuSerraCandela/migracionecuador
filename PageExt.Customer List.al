pageextension 50030 pageextension50030 extends "Customer List"
{
    layout
    {
        modify(Name)
        {
            ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.';
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Customer Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
            Visible = true;
        }
        modify("Customer Price Group")
        {
            Visible = true;
        }
        modify("Customer Disc. Group")
        {
            ToolTip = 'Specifies the customer discount group code, which you can use as a criterion to set up special discounts in the Sales Line Discounts window.';
            Visible = true;
        }
        modify("Payment Terms Code")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            Visible = true;
        }
        modify("Credit Limit (LCY)")
        {
            Visible = true;
        }
        modify("Application Method")
        {
            ToolTip = 'Specifies how to apply payments to entries for this customer.';
        }
        moveafter(Name; Blocked)
        addafter(Name)
        {
            field(Priority; rec.Priority)
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
            }
        }
        moveafter("Location Code"; "Last Date Modified")

        addafter("Post Code")
        {
            field(Address; rec.Address)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Address 2"; rec."Address 2")
            {
                ApplicationArea = Basic, Suite;
            }
            field(City; rec.City)
            {
                ApplicationArea = Basic, Suite;
            }
            field(County; rec.County)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Phone No.")
        {
            field("E-Mail"; rec."E-Mail")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Home Page"; '')
            {
                ApplicationArea = Basic, Suite;
            }
            // field("Tax Identification Type"; rec."Tax Identification Type")
            // {
            //     ApplicationArea = Basic, Suite;
            //}
        }
        addafter(Contact)
        {
            field("Primary Contact No."; rec."Primary Contact No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Credit Limit (LCY)")
        {
            field(Balance; rec.Balance)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Balance en Consignacion Act."; rec."Balance en Consignacion Act.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Inventario en Consignacion Act"; rec."Inventario en Consignacion Act")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Almacen Consignacion"; rec."Cod. Almacen Consignacion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Prioridad entrega consignacion"; rec."Prioridad entrega consignacion")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        moveafter(Balance; "Balance (LCY)") //Agrega el campo despues del de balance
        addafter("Shipping Advice")
        {
            field("Packing requerido"; rec."Packing requerido")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Service Zone Code"; rec."Service Zone Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Shipping Agent Code")
        {
            field("Shipping Agent Service Code"; rec."Shipping Agent Service Code")
            {
                ApplicationArea = All;
            }
            field("Tipo Documento"; rec."Tipo Documento")
            {
                ApplicationArea = All;
            }
            field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
            {
                ApplicationArea = All;
            }
            field("VAT Registration No.2"; rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
            field("Shipment Method Code"; rec."Shipment Method Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Base Calendar Code")
        {
            field("<TIPO_CLIENTE>"; dimTIPO_CLIENTE)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'TIPO CLIENTE';
            }
            field("<CAMPDELEGADO"; dimCAMDELEGADO)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'CAMPDELEGADO';
            }
            field("Fecha inicio relacion"; rec."Fecha inicio relacion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Calificacion de cliente"; rec."Calificacion de cliente")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        // addafter("CFDI Relation")
        // {
        //     field("Collector Code"; rec."Collector Code")
        //     {
        //     ApplicationArea = All;
        //     }
        // }
    }
    actions
    {
        modify(DimensionsMultiple)
        {
            ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';
        }
        modify(Statistics)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        modify("Issued &Reminders")
        {
            ToolTip = 'View the reminders that you have sent to the customer.';
        }
        modify("Issued &Finance Charge Memos")
        {
            ToolTip = 'View the finance charge memos that you have sent to the customer.';
        }
        modify(NewSalesQuote)
        {
            ToolTip = 'Offer items or services to a customer.';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }
        modify(ReportCustomerSalesList)
        {
            ToolTip = 'View customer sales for a period, for example, to report sales activity to customs and tax authorities. You can choose to include only customers with total sales that exceed a minimum amount. You can also specify whether you want the report to show address details for each customer.';
        }
        modify(ReportSalesStatistics)
        {
            ToolTip = 'View customers'' total costs, sales, and profits over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted costs, sales, profits, invoice discounts, payment discounts, and profit percentage in three adjustable periods.';
        }
        modify(Statement)
        {
            ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';
        }
        modify(ReportCustomerBalanceToDate)
        {
            Caption = 'Customer - Balance to Date';
            ToolTip = 'View a list with customers'' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.';
        }
        modify(ReportCustomerTrialBalance)
        {
            ToolTip = 'View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.';
        }
        modify(ReportCustomerDetailTrial)
        {
            ToolTip = 'View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.';
        }
        modify(ReportCustomerSummaryAging)
        {
            ToolTip = 'View, print, or save a summary of each customer''s total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer''s creditworthiness, or to prepare liquidity analyses.';
        }
        modify(ReportCustomerPaymentReceipt)
        {
            ToolTip = 'View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.';
        }
        modify("Customer - Top 10 List")
        {
            Caption = 'Customer - Top 10 List';
            ToolTip = 'View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.';
        }
        modify("Customer - Sales List")
        {
            ToolTip = 'View customer sales for a period, for example, to report sales activity to customs and tax authorities. You can choose to include only customers with total sales that exceed a minimum amount. You can also specify whether you want the report to show address details for each customer.';
        }
        modify("Sales Statistics")
        {
            ToolTip = 'View customers'' total costs, sales, and profits over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted costs, sales, profits, invoice discounts, payment discounts, and profit percentage in three adjustable periods.';
        }
        // modify("Back Order Fill by Customer")
        // {
        //     Caption = 'Back Order Fill by Customer';
        //     ToolTip = 'List all customers for which a back order exists. The report lists each customer that is waiting for items temporarily out of stock and the involved items.';
        // }
        // addafter("Back Order Fill by Customer")
        // {
        //     action("Customer/Item Statistics Devol")
        //     {
        //         ApplicationArea = Basic, Suite;
        //         Caption = 'Customer/Item Statistics Devol';
        //         Image = "Report";
        //         RunObject = Report "Customer/Item Stat. Dev 2.0";

        //         trigger OnAction()
        //         begin
        //             //001+- Botón para nuevo reporte.
        //         end;
        //     }
        // }
        addafter("&Customer")
        {
            action(Desbloquear)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    Customer.Reset();
                    Customer.ModifyAll("Blocked", Customer."Blocked"::" ");
                end;
            }
        }
    }

    var
        GrupoDimension: Record "Default Dimension";
        dimTIPO_CLIENTE: Text;
        dimCAMDELEGADO: Text;
        GrupoDimensionValue: Record "Dimension Value";

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        GrupoDimension.SetRange("No.", Rec."No.");
        GrupoDimension.SetRange("Dimension Code", 'TIPO_CLIENTE');
        if GrupoDimension.FindFirst then
            dimTIPO_CLIENTE := Format(GrupoDimension."Dimension Value Code")
        else
            dimTIPO_CLIENTE := '';

        GrupoDimension.Reset;
        GrupoDimension.SetRange("No.", Rec."No.");
        GrupoDimension.SetRange("Dimension Code", 'CAMPDELEGADO');
        if GrupoDimension.FindFirst then
            dimCAMDELEGADO := Format(GrupoDimension."Dimension Value Code")
        else
            dimCAMDELEGADO := '';
    end;
}

