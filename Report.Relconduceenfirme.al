report 56097 "Rel. conduce en firme"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Relconduceenfirme.rdlc';

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.", "Posting Date", "Shipping Agent Service Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }

            column(USERID; UserId)
            {
            }
            column(Sales_Shipment_Header__No__; "No.")
            {
            }
            column(Sales_Shipment_Header__Posting_Date_; "Posting Date")
            {
            }
            column(Sales_Shipment_Header__Order_No__; "Order No.")
            {
            }
            column(Sales_Shipment_Header__Bill_to_Customer_No__; "Bill-to Customer No.")
            {
            }
            column(Sales_Shipment_Header__Bill_to_Name_; "Bill-to Name")
            {
            }
            column(Sales_Shipment_Header__Salesperson_Code_; "Salesperson Code")
            {
            }
            column(Sales_Shipment_Header__Sales_Shipment_Header___Shipping_Agent_Service_Code_; "Sales Shipment Header"."Shipping Agent Service Code")
            {
            }
            column(Sales_Shipment_HeaderCaption; Sales_Shipment_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Shipment_Header__No__Caption; FieldCaption("No."))
            {
            }
            column(Sales_Shipment_Header__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(Sales_Shipment_Header__Order_No__Caption; FieldCaption("Order No."))
            {
            }
            column(Sales_Shipment_Header__Bill_to_Customer_No__Caption; FieldCaption("Bill-to Customer No."))
            {
            }
            column(Sales_Shipment_Header__Bill_to_Name_Caption; FieldCaption("Bill-to Name"))
            {
            }
            column(Sales_Shipment_Header__Salesperson_Code_Caption; FieldCaption("Salesperson Code"))
            {
            }
            column("Estatus_EnvíoCaption"; Estatus_EnvíoCaptionLbl)
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
        Sales_Shipment_HeaderCaptionLbl: Label 'Sales Shipment Header';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        "Estatus_EnvíoCaptionLbl": Label 'Estatus Envío';
}

