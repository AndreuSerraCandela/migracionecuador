report 56129 "Seguimiento pedido en firme"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Seguimientopedidoenfirme.rdlc';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING ("Document Type", "Sell-to Customer No.", "No.");
            RequestFilterFields = "Document Type", "Sell-to Customer No.", "No.", "Order Date", "Shipment Date", Status, "Estado distribucion", "Completely Shipped";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }

            column(USERID; UserId)
            {
            }
            column(Yes; Yes)
            {
            }
            column(No; No)
            {
            }
            column(Sales_Header__No__; "No.")
            {
            }
            column(Sales_Header__Order_Date_; "Order Date")
            {
            }
            column(Sales_Header__Shipment_Date_; "Shipment Date")
            {
            }
            column(Sales_Header_Status; Status)
            {
            }
            column(Sales_Header_Ship; Ship)
            {
            }
            column(Sales_Header_Invoice; Invoice)
            {
            }
            column(Sales_Header__Completely_Shipped_; "Completely Shipped")
            {
            }
            column(Sales_Header__Sell_to_Customer_No__; "Sell-to Customer No.")
            {
            }
            column(Sales_Header__Sell_to_Customer_Name_; "Sell-to Customer Name")
            {
            }
            column(Sales_HeaderCaption; Sales_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Header__No__Caption; FieldCaption("No."))
            {
            }
            column(Sales_Header__Order_Date_Caption; FieldCaption("Order Date"))
            {
            }
            column(Fecha_RegistroCaption; Fecha_RegistroCaptionLbl)
            {
            }
            column(Sales_Header_StatusCaption; FieldCaption(Status))
            {
            }
            column(Sales_Header_ShipCaption; FieldCaption(Ship))
            {
            }
            column(Sales_Header_InvoiceCaption; FieldCaption(Invoice))
            {
            }
            column(Sales_Header__Completely_Shipped_Caption; FieldCaption("Completely Shipped"))
            {
            }
            column(Sales_Header__Sell_to_Customer_No__Caption; FieldCaption("Sell-to Customer No."))
            {
            }
            column(Sales_Header__Sell_to_Customer_Name_Caption; FieldCaption("Sell-to Customer Name"))
            {
            }
            column(Sales_Header_Document_Type; "Document Type")
            {
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
        Yes: Label 'Yes';
        No: Label 'No';
        Sales_HeaderCaptionLbl: Label 'Sales Header';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Fecha_RegistroCaptionLbl: Label 'Fecha Registro';
}

