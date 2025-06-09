report 56094 "Enviado NO Facturado en Firme"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EnviadoNOFacturadoenFirme.rdlc';

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING ("Document No.") ORDER(Ascending);
            RequestFilterFields = "Sell-to Customer No.", "Document No.", "Qty. Shipped Not Invoiced", "Shipment Date";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Sales_Line__Shipped_Not_Invoiced_; "Shipped Not Invoiced")
            {
            }
            column(Sales_Line__Qty__Shipped_Not_Invoiced_; "Qty. Shipped Not Invoiced")
            {
            }
            column(rCliente_Name; rCliente.Name)
            {
            }
            column(Sales_Line__Sell_to_Customer_No__; "Sell-to Customer No.")
            {
            }
            column(Sales_Line__Shipment_Date_; "Shipment Date")
            {
            }
            column(Sales_Line__Document_No__; "Document No.")
            {
            }
            column(Sales_Line__Shipped_Not_Invoiced_2; "Shipped Not Invoiced")
            {
            }
            column(Sales_Line__Qty__Shipped_Not_Invoiced_t; "Qty. Shipped Not Invoiced")
            {
            }
            column(Sales_LineCaption; Sales_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Line__Document_No__Caption; Sales_Line__Document_No__CaptionLbl)
            {
            }
            column(Sales_Line__Shipment_Date_Caption; Sales_Line__Shipment_Date_CaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(Sales_Line__Qty__Shipped_Not_Invoiced_Caption; Sales_Line__Qty__Shipped_Not_Invoiced_CaptionLbl)
            {
            }
            column(Sales_Line__Shipped_Not_Invoiced_Caption; Sales_Line__Shipped_Not_Invoiced_CaptionLbl)
            {
            }
            column(NombreCaption; NombreCaptionLbl)
            {
            }
            column(Sales_LineCaptionT; Sales_LineCaptionTLbl)
            {
            }
            column(Sales_Line_Document_Type; "Document Type")
            {
            }
            column(Sales_Line_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                rCliente.Get("Sell-to Customer No.");
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
        rCliente: Record Customer;
        Sales_LineCaptionLbl: Label 'Sales Line';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Sales_Line__Document_No__CaptionLbl: Label 'No Documento';
        Sales_Line__Shipment_Date_CaptionLbl: Label 'Fecha Envío';
        No_CaptionLbl: Label 'No.';
        Sales_Line__Qty__Shipped_Not_Invoiced_CaptionLbl: Label 'Cantidad';
        Sales_Line__Shipped_Not_Invoiced_CaptionLbl: Label 'Importe';
        NombreCaptionLbl: Label 'Nombre';
        Sales_LineCaptionTLbl: Label 'Sales Line';
}

