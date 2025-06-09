report 56121 "Listado de Ventas Ped."
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListadodeVentasPed.rdlc';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("Sell-to Customer No.", "Order Date");
            RequestFilterFields = "No.", "Order Date", "Order No.", "Sell-to Customer No.", "Salesperson Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(Sales_Invoice_Header__No__; "No.")
            {
            }
            column(Sales_Invoice_Header__Order_Date_; "Order Date")
            {
            }
            column(Sales_Invoice_Header__Order_No__; "Order No.")
            {
            }
            column(Sales_Invoice_Header__Bill_to_Customer_No__; "Bill-to Customer No.")
            {
            }
            column(Sales_Invoice_Header__Bill_to_Name_; "Bill-to Name")
            {
            }
            column(Sales_Invoice_Header__Salesperson_Code_; "Salesperson Code")
            {
            }
            column(rMovCte__Remaining_Amount_; rMovCte."Remaining Amount")
            {
            }
            column(rMovCte__Remaining_Amount__Control1000000000; rMovCte."Remaining Amount")
            {
            }
            column(Listado_de_Ventas_Pedidos_a_ConsignacionCaption; Listado_de_Ventas_Pedidos_a_ConsignacionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Invoice_Header__Order_Date_Caption; FieldCaption("Order Date"))
            {
            }
            column(Sales_Invoice_Header__Order_No__Caption; FieldCaption("Order No."))
            {
            }
            column(Sales_Invoice_Header__Bill_to_Customer_No__Caption; FieldCaption("Bill-to Customer No."))
            {
            }
            column(Sales_Invoice_Header__Bill_to_Name_Caption; FieldCaption("Bill-to Name"))
            {
            }
            column(Sales_Invoice_Header__Salesperson_Code_Caption; FieldCaption("Salesperson Code"))
            {
            }
            column(rMovCte__Remaining_Amount_Caption; rMovCte__Remaining_Amount_CaptionLbl)
            {
            }
            column(Sales_Invoice_Header__No__Caption; FieldCaption("No."))
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                rMovCte.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                rMovCte.SetRange("Document No.", "No.");
                rMovCte.SetRange("Document Type", rMovCte."Document Type"::Invoice);
                rMovCte.SetRange("Customer No.", "Sell-to Customer No.");
                rMovCte.SetRange("Posting Date", "Posting Date");
                if rMovCte.Find('-') then
                    rMovCte.CalcFields("Remaining Amount");
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
                //CurrReport.CreateTotals(Amount, rMovCte."Remaining Amount");
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

    var
        rMovCte: Record "Cust. Ledger Entry";
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Listado_de_Ventas_Pedidos_a_ConsignacionCaptionLbl: Label 'Listado de Ventas Pedidos a Consignacion';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        rMovCte__Remaining_Amount_CaptionLbl: Label 'Remaining Amount';
        TotalCaptionLbl: Label 'Total';
}

