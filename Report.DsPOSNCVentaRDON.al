report 76228 "DsPOS - NC Venta RD ON"
{
    DefaultLayout = RDLC;
    RDLCLayout = './DsPOSNCVentaRDON.rdlc';

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.";
            column(Fax______rEmpresa__Fax_No__; 'Fax. ' + recEmpresa."Fax No.")
            {
            }
            column(rEmpresa_Name; recEmpresa.Name)
            {
            }
            column(rEmpresa_Address; recEmpresa.Address)
            {
            }
            column(rEmpresa_County; recEmpresa.County)
            {
            }
            column("Página_Web_______rEmpresa__Home_Page_"; 'Página Web : ' + recEmpresa."Home Page")
            {
            }
            column(E_Mail_______rEmpresa__E_Mail_; 'E-Mail : ' + recEmpresa."E-Mail")
            {
            }
            column(RNC_______rEmpresa__VAT_Registration_No__; 'RNC : ' + recEmpresa."VAT Registration No.")
            {
            }
            column(Tels______rEmpresa__Phone_No__; 'Tels. ' + recEmpresa."Phone No.")
            {
            }
            column(Sales_Invoice_Header__Sell_to_Customer_Name_; "Sell-to Customer Name")
            {
            }
            column(Sales_Invoice_Header__Sell_to_Address_; "Sell-to Address")
            {
            }
            column(Sales_Invoice_Header__Sell_to_Address_2_; "Sell-to Address 2")
            {
            }
            column(Sales_Invoice_Header__Salesperson_Code_; "Salesperson Code")
            {
            }
            column(rCliente__Phone_No__; recCliente."Phone No.")
            {
            }
            column(Sales_Invoice_Header__Sell_to_City_; "Sell-to City")
            {
            }
            column(IDCajero; "ID Cajero")
            {
            }
            column(Terminal; TPV)
            {
            }
            column(Sales_Invoice_Header__Posting_Date_; "Posting Date")
            {
            }
            column(Sales_Invoice_Header__No__; "No.")
            {
            }
            column(Sales_Invoice_Header__VAT_Registration_No__; "VAT Registration No.")
            {
            }
            column(Vendido_a__Caption; Vendido_a__CaptionLbl)
            {
            }
            column("Pág_Caption"; Pág_CaptionLbl)
            {
            }
            column(CajeroCaption; CajeroCaptionLbl)
            {
            }
            column(TerminalCaption; TerminalCaptionLbl)
            {
            }
            column(Fecha_Caption; Fecha_CaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(FACTURACaption; FACTURACaptionLbl)
            {
            }
            column(RNC_Cliente_Caption; RNC_Cliente_CaptionLbl)
            {
            }
            column("CódigoCaption"; CódigoCaptionLbl)
            {
            }
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(CantidadCaption; CantidadCaptionLbl)
            {
            }
            column(PrecioCaption; PrecioCaptionLbl)
            {
            }
            column(Desc_Caption; Desc_CaptionLbl)
            {
            }
            column(ImporteCaption; ImporteCaptionLbl)
            {
            }
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                column(Sales_Invoice_Line__No__; "No.")
                {
                }
                column(Sales_Invoice_Line_Description; Description)
                {
                }
                column(Sales_Invoice_Line_Quantity; Quantity)
                {
                }
                column(Sales_Invoice_Line__Unit_Price_; "Unit Price")
                {
                }
                column(Sales_Invoice_Line__Line_Discount___; "Line Discount %")
                {
                }
                column(Sales_Invoice_Line__Line_Amount_; "Line Amount")
                {
                }
                column(Sales_Invoice_Line_Quantity_Control1000000040; Quantity)
                {
                }
                column(Sales_Invoice_Line__Line_Discount_Amount_; "Line Discount Amount")
                {
                }
                column(Subtotal; decSubtotal)
                {
                }
                column(Sales_Invoice_Line__Amount_Including_VAT_; "Amount Including VAT")
                {
                }
                column(wDiv; codDiv)
                {
                }
                column(IMPORTE_VTAS_Caption; IMPORTE_VTAS_CaptionLbl)
                {
                }
                column(Total_productosCaption; Total_productosCaptionLbl)
                {
                }
                column(DESC_Caption_Control1000000042; DESC_Caption_Control1000000042Lbl)
                {
                }
                column(NO_ACEPTAMOS_DEVOLUCIONES____Caption; NO_ACEPTAMOS_DEVOLUCIONES____CaptionLbl)
                {
                }
                column(TOTALCaption; TOTALCaptionLbl)
                {
                }
                column(Sales_Invoice_Line_Document_No_; "Document No.")
                {
                }
                column(Sales_Invoice_Line_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    decITBIS := (((Amount) * "VAT %") / 100);
                    decSubtotal := "Unit Price" * Quantity;
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CreateTotals(Amount, decITBIS, decSubtotal, "Line Discount Amount");
                end;
            }
            dataitem("<Pagos TPV>"; "Pagos TPV")
            {
                DataItemLink = "No. Borrador" = FIELD ("No.");
            }

            trigger OnAfterGetRecord()
            begin
                recCliente.Get("Sell-to Customer No.");

                if "Currency Code" <> '' then
                    codDiv := "Currency Code"
                else
                    codDiv := CodDivisa;
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

    trigger OnPreReport()
    begin
        recEmpresa.Get;
    end;

    var
        _recTPV: Record "Configuracion TPV";
        _recTienda: Record Tiendas;
        recEmpresa: Record "Company Information";
        recCliente: Record Customer;
        _recNoSeries: Record "No. Series";
        NCF_Final: Label 'Factura a consumidor final';
        NCF_Fiscal: Label 'Factura valida para credito fiscal';
        decTotalVenta: Decimal;
        decITBIS: Decimal;
        codDiv: Code[10];
        Text1: Text[300];
        Text2: Text[300];
        Text3: Text[300];
        Text4: Text[300];
        Text005: Label 'Pág. %1';
        CodDivisa: Label 'RD$';
        Vendido_a__CaptionLbl: Label 'Vendido a: ';
        "Pág_CaptionLbl": Label 'Pág.:';
        CajeroCaptionLbl: Label 'Cajero:';
        TerminalCaptionLbl: Label 'Terminal:';
        Fecha_CaptionLbl: Label 'Fecha:';
        No_CaptionLbl: Label 'No.';
        FACTURACaptionLbl: Label 'FACTURA';
        RNC_Cliente_CaptionLbl: Label 'RNC Cliente:';
        "CódigoCaptionLbl": Label 'Código';
        "DescripciónCaptionLbl": Label 'Descripción';
        CantidadCaptionLbl: Label 'Cantidad';
        PrecioCaptionLbl: Label 'Precio';
        Desc_CaptionLbl: Label 'Desc.';
        ImporteCaptionLbl: Label 'Importe';
        IMPORTE_VTAS_CaptionLbl: Label 'IMPORTE VTAS.';
        Total_productosCaptionLbl: Label 'Total productos';
        DESC_Caption_Control1000000042Lbl: Label 'DESC.';
        NO_ACEPTAMOS_DEVOLUCIONES____CaptionLbl: Label '*** NO ACEPTAMOS DEVOLUCIONES ***';
        TOTALCaptionLbl: Label 'TOTAL';
        decSubtotal: Decimal;
}

