report 56096 "Rel. Conduce en Consignación"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RelConduceenConsignación.rdlc';

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.", "Transfer-to Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }

            column(USERID; UserId)
            {
            }
            column(Transfer_Shipment_Header__Transfer_Order_No__; "Transfer Order No.")
            {
            }
            column(Transfer_Shipment_Header__No__; "No.")
            {
            }
            column(Transfer_Shipment_Header__Posting_Date_; "Posting Date")
            {
            }
            column(Transfer_Shipment_Header__Transfer_to_Code_; "Transfer-to Code")
            {
            }
            column(Transfer_Shipment_Header__Transfer_to_Name_; "Transfer-to Name")
            {
            }
            column(Transfer_Shipment_Header__Importe_Consignacion_; "Importe Consignacion")
            {
            }
            column(Transfer_Shipment_HeaderCaption; Transfer_Shipment_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Transfer_Shipment_Header__Transfer_Order_No__Caption; FieldCaption("Transfer Order No."))
            {
            }
            column(Transfer_Shipment_Header__No__Caption; FieldCaption("No."))
            {
            }
            column(Transfer_Shipment_Header__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(Transfer_Shipment_Header__Transfer_to_Code_Caption; FieldCaption("Transfer-to Code"))
            {
            }
            column(Transfer_Shipment_Header__Transfer_to_Name_Caption; FieldCaption("Transfer-to Name"))
            {
            }
            column(Transfer_Shipment_Header__Importe_Consignacion_Caption; FieldCaption("Importe Consignacion"))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        Transfer_Shipment_HeaderCaptionLbl: Label 'Transfer Shipment Header';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
}

