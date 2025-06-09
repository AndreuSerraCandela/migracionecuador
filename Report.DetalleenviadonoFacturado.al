report 56101 "Detalle enviado no Facturado"
{
    DefaultLayout = RDLC;
    RDLCLayout = './DetalleenviadonoFacturado.rdlc';

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING ("Document Type", "Bill-to Customer No.", "Currency Code");
            RequestFilterFields = "Document Type", "Bill-to Customer No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Sales_Line__Document_Type_; "Document Type")
            {
            }
            column(Sales_Line__Bill_to_Customer_No__; "Bill-to Customer No.")
            {
            }
            column(Sales_Line__Document_Type__Control1000000014; "Document Type")
            {
            }
            column(Sales_Line__Sell_to_Customer_No__; "Sell-to Customer No.")
            {
            }
            column(Sales_Line__Document_No__; "Document No.")
            {
            }
            column(Sales_Line__No__; "No.")
            {
            }
            column(Sales_Line__Location_Code_; "Location Code")
            {
            }
            column(Sales_Line__Shipment_Date_; "Shipment Date")
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
            column(Sales_Line__Quantity_Invoiced_; "Quantity Invoiced")
            {
            }
            column(TotalFor___FIELDCAPTION__Bill_to_Customer_No___; TotalFor + FieldCaption("Bill-to Customer No."))
            {
            }
            column(Sales_Line_Quantity_Control1000000044; Quantity)
            {
            }
            column(Sales_Line__Quantity_Shipped__Control1000000045; "Quantity Shipped")
            {
            }
            column(Sales_Line__Quantity_Invoiced__Control1000000046; "Quantity Invoiced")
            {
            }
            column(TotalFor___FIELDCAPTION__Document_Type__; TotalFor + FieldCaption("Document Type"))
            {
            }
            column(Sales_Line_Quantity_Control1000000048; Quantity)
            {
            }
            column(Sales_Line__Quantity_Shipped__Control1000000049; "Quantity Shipped")
            {
            }
            column(Sales_Line__Quantity_Invoiced__Control1000000050; "Quantity Invoiced")
            {
            }
            column(Sales_LineCaption; Sales_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Line__Document_Type__Control1000000014Caption; FieldCaption("Document Type"))
            {
            }
            column(Sales_Line__Sell_to_Customer_No__Caption; FieldCaption("Sell-to Customer No."))
            {
            }
            column(Sales_Line__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Sales_Line__No__Caption; FieldCaption("No."))
            {
            }
            column(Sales_Line__Location_Code_Caption; FieldCaption("Location Code"))
            {
            }
            column(Sales_Line__Shipment_Date_Caption; FieldCaption("Shipment Date"))
            {
            }
            column(Sales_Line_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Sales_Line_QuantityCaption; FieldCaption(Quantity))
            {
            }
            column(Sales_Line__Quantity_Shipped_Caption; FieldCaption("Quantity Shipped"))
            {
            }
            column(Sales_Line__Quantity_Invoiced_Caption; FieldCaption("Quantity Invoiced"))
            {
            }
            column(Sales_Line__Document_Type_Caption; FieldCaption("Document Type"))
            {
            }
            column(Sales_Line__Bill_to_Customer_No__Caption; FieldCaption("Bill-to Customer No."))
            {
            }
            column(Sales_Line_Line_No_; "Line No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Bill-to Customer No.");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total para ';
        Sales_LineCaptionLbl: Label 'Sales Line';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
}

