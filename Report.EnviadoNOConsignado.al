report 56095 "Enviado NO Consignado"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EnviadoNOConsignado.rdlc';

    dataset
    {
        dataitem("Transfer Line"; "Transfer Line")
        {
            DataItemTableView = SORTING ("Document No.", "Line No.");
            RequestFilterFields = "Document No.", "Transfer-to Code", "Qty. in Transit", "Shipment Date";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Transfer_Line__Qty__in_Transit_; "Qty. in Transit")
            {
            }
            column(rCliente_Name; rCliente.Name)
            {
            }
            column(Transfer_Line__Transfer_to_Code_; "Transfer-to Code")
            {
            }
            column(Transfer_Line__Shipment_Date_; "Shipment Date")
            {
            }
            column(Transfer_Line__Document_No__; "Document No.")
            {
            }
            column(rImporte; rImporte)
            {
            }
            column(Transfer_Line__Qty__in_Transit__Control1000000016; "Qty. in Transit")
            {
            }
            column(rImporte_Control1000000019; rImporte)
            {
            }
            column(Transfer_LineCaption; Transfer_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Transfer_Line__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Transfer_Line__Shipment_Date_Caption; FieldCaption("Shipment Date"))
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(NombreCaption; NombreCaptionLbl)
            {
            }
            column(CantidadCaption; CantidadCaptionLbl)
            {
            }
            column(ImporteCaption; ImporteCaptionLbl)
            {
            }
            column(TOTALCaption; TOTALCaptionLbl)
            {
            }
            column(Transfer_Line_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                rCliente.Get("Transfer-to Code");

                //+#139
                rVtaneta := "Qty. in Transit" * "Precio Venta Consignacion";
                rDescuento := rVtaneta * ("Descuento % Consignacion" / 100);
                rvtaliq := rVtaneta - rDescuento
                //-#139
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
        rvtaliq: Decimal;
        rVtaneta: Decimal;
        rDescuento: Decimal;
        rImporte: Decimal;
        Transfer_LineCaptionLbl: Label 'Transfer Line';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        No_CaptionLbl: Label 'No.';
        NombreCaptionLbl: Label 'Nombre';
        CantidadCaptionLbl: Label 'Cantidad';
        ImporteCaptionLbl: Label 'Importe';
        TOTALCaptionLbl: Label 'TOTAL';
}

