report 76096 "Pedidos por cliente"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Pedidosporcliente.rdlc';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "Sell-to Customer No.", "No.") WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Sell-to Customer No.", "Salesperson Code", "Order Date";
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
            column(Sales_Header__Sell_to_Customer_No__; "Sell-to Customer No.")
            {
            }
            column(Sales_Header__Sell_to_Customer_Name_; "Sell-to Customer Name")
            {
            }
            column(Sales_Header__No__; "No.")
            {
            }
            column(Sales_Header__Order_Date_; "Order Date")
            {
            }
            column(Sales_Header__Salesperson_Code_; "Salesperson Code")
            {
            }
            column(Sales_Header__Payment_Terms_Code_; "Payment Terms Code")
            {
            }
            column(Sales_Header__Payment_Method_Code_; "Payment Method Code")
            {
            }
            column(TraerNombreVendedor; TraerNombreVendedor)
            {
            }
            column(Pedidos_por_clienteCaption; Pedidos_por_clienteCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Header__Sell_to_Customer_No__Caption; Sales_Header__Sell_to_Customer_No__CaptionLbl)
            {
            }
            column(Sales_Header__Payment_Terms_Code_Caption; FieldCaption("Payment Terms Code"))
            {
            }
            column(Sales_Header__Payment_Method_Code_Caption; FieldCaption("Payment Method Code"))
            {
            }
            column(Nombre_vendedorCaption; Nombre_vendedorCaptionLbl)
            {
            }
            column(Sales_Header__Salesperson_Code_Caption; FieldCaption("Salesperson Code"))
            {
            }
            column(Sales_Header__Order_Date_Caption; FieldCaption("Order Date"))
            {
            }
            column(Sales_Header__No__Caption; Sales_Header__No__CaptionLbl)
            {
            }
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(Sales_Line__No__; "No.")
                {
                }
                column(Sales_Line_Description; Description)
                {
                }
                column(Sales_Line_Quantity; Quantity)
                {
                }
                column(Sales_Line__Quantity_Shipped_; "Quantity Shipped")
                {
                }
                column(Sales_Line__Cantidad_Aprobada_; "Cantidad Aprobada")
                {
                    DecimalPlaces = 0 : 2;
                }
                column(Sales_Line__No__Caption; Sales_Line__No__CaptionLbl)
                {
                }
                column(Sales_Line_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(Sales_Line_QuantityCaption; FieldCaption(Quantity))
                {
                }
                column(Sales_Line__Cantidad_Aprobada_Caption; FieldCaption("Cantidad Aprobada"))
                {
                }
                column(Sales_Line__Quantity_Shipped_Caption; FieldCaption("Quantity Shipped"))
                {
                }
                column(Sales_Line_Document_Type; "Document Type")
                {
                }
                column(Sales_Line_Document_No_; "Document No.")
                {
                }
                column(Sales_Line_Line_No_; "Line No.")
                {
                }
            }
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Pedidos_por_clienteCaptionLbl: Label 'Pedidos por cliente';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        Sales_Header__Sell_to_Customer_No__CaptionLbl: Label 'Sell-to Customer No.';
        Nombre_vendedorCaptionLbl: Label 'Nombre vendedor';
        Sales_Header__No__CaptionLbl: Label 'No.';
        Sales_Line__No__CaptionLbl: Label 'No.';


    procedure TraerNombreVendedor(): Text[50]
    var
        recVendedor: Record "Salesperson/Purchaser";
    begin
        if recVendedor.Get("Sales Header"."Salesperson Code") then
            exit(recVendedor.Name);
    end;
}

