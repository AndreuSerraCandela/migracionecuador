report 50047 "Formato DPP v2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './FormatoDPPv2.rdlc';
    Caption = 'Report Credit Memo (Discount Soon Payment)';
    Permissions = TableData "Detailed Cust. Ledg. Entry" = r;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Closed by Entry No.") ORDER(Descending) WHERE (Open = CONST (false), "Pmt. Disc. Given (LCY)" = FILTER (> 0), "No. Comprobante Fiscal DPP" = FILTER (<> ''));
            RequestFilterFields = "Document No.", "Entry No.", "No. Comprobante Fiscal DPP";
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING (Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                    column(Picture; CompanyInfo.Picture)
                    {
                    }
                    column(Company; CompanyInfo.Name)
                    {
                    }
                    column(Desc_Pronto_Pago__Desc_Pronto_Pago___Sell_to_Country_Region_Code_; rCliente."Country/Region Code")
                    {
                    }
                    column(Desc_Pronto_Pago__Desc_Pronto_Pago___Sell_to_County_; rCliente.County)
                    {
                    }
                    column(Desc_Pronto_Pago__Desc_Pronto_Pago___Sell_to_City_; rCliente.City)
                    {
                    }
                    column(Desc_Pronto_Pago__Desc_Pronto_Pago___Sell_to_Address_; rCliente.Address)
                    {
                    }
                    column(Desc_Pronto_Pago__Desc_Pronto_Pago___Customer_Name_; rCliente.Name)
                    {
                    }
                    column(Desc_Pronto_Pago__Desc_Pronto_Pago___Sell_to_Customer_No__; "Cust. Ledger Entry"."Customer No.")
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfo__E_Mail_; CompanyInfo."E-Mail")
                    {
                    }
                    column(Desc_Pronto_Pago__Desc_Pronto_Pago___NCF_Afectado_; NCFAFECTA)
                    {
                    }
                    column(CompanyInfo__Phone_No__2_; CompanyInfo."Phone No. 2")
                    {
                    }
                    column(Desc_Pronto_Pago__Desc_Pronto_Pago__NCF; "Cust. Ledger Entry"."No. Comprobante Fiscal DPP")
                    {
                    }
                    column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                    {
                    }
                    column(Desc_Pronto_Pago__Posting_Date_; rDetailedMovCliente."Posting Date")
                    {
                    }
                    column(Desc_Pronto_Pago__Document_No__; rDetailedMovCliente."Document No.")
                    {
                    }
                    column(CompanyAddr_3_; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_2_; CompanyAddr[2])
                    {
                    }
                    column(Desc_Pronto_Pago__Salesperson_Code_; rCliente."Salesperson Code")
                    {
                    }
                    column(Desc_Pronto_Pago_Description; DescripcionDPP)
                    {
                    }
                    column(Desc_Pronto_Pago_Amount; "Cust. Ledger Entry"."Pmt. Disc. Given (LCY)")
                    {
                    }
                    column(rCliente__VAT_Registration_No__; rCliente."VAT Registration No.")
                    {
                    }
                    column(USERID; UserId)
                    {
                    }
                    column(Desc_Pronto_Pago_Line_No_; 10000)
                    {
                    }
                    column(FDocumentNo; "Cust. Ledger Entry"."Document No.")
                    {
                    }
                    column(FPostingDate; "Cust. Ledger Entry"."Posting Date")
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    //CurrReport.PageNo := 1;
                    if CopyNo = NoLoops then begin
                        CurrReport.Break;
                    end;
                    CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                        Clear(CopyTxt)
                    else
                        CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies);
                    if NoLoops <= 0 then
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if rCliente.Get("Customer No.") then
                    rDetailedMovCliente.Reset;
                rDetailedMovCliente.SetRange("Cust. Ledger Entry No.", "Cust. Ledger Entry"."Closed by Entry No.");
                rDetailedMovCliente.SetRange("Entry Type", rDetailedMovCliente."Entry Type"::"Payment Discount");
                if rDetailedMovCliente.FindFirst then;

                DescripcionDPP := 'Descuento Pronto Pago Factura ' + ' ' + "Cust. Ledger Entry"."Document No.";
                NCFAFECTA := "Cust. Ledger Entry"."No. Comprobante Fiscal";

                if NCFAFECTA = '' then begin
                    rSalesInvHeader.Reset;
                    rSalesInvHeader.SetRange("No.", "Cust. Ledger Entry"."Document No.");
                    if rSalesInvHeader.Find('-') then begin
                        NCFAFECTA := rSalesInvHeader."No. Comprobante Fiscal";
                    end;
                end;

                //Totalexc := Totalexc + ("Amount (LCY)" * -1);
                //Totalinc := Totalinc + 0;
            end;

            trigger OnPreDataItem()
            begin

                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                Clear(Totalexc);
                Clear(Totalinc);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(NumberOfCopies; NoCopies)
                {
                ApplicationArea = All;
                    Caption = 'Number of Copies';
                }
            }
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
        rCliente: Record Customer;
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        FormatAddr: Codeunit "Format Address";
        Totalexc: Decimal;
        Totalinc: Decimal;
        Informacion_ClienteCaptionLbl: Label 'Informacion Cliente';
        RNCCaptionLbl: Label 'RNC';
        NCF_AfectadoCaptionLbl: Label 'NCF Afectado';
        "Teléfono_Gratis_desde_el_Interior_CaptionLbl": Label 'Teléfono Gratis desde el Interior:';
        NCFCaptionLbl: Label 'NCF';
        Fax_CaptionLbl: Label 'Fax:';
        "Teléfono_CaptionLbl": Label 'Teléfono:';
        Posting_DateCaptionLbl: Label 'Posting Date';
        Nota_de_Credito_VentasCaptionLbl: Label 'Nota de Credito Ventas';
        Datos_DocumentosCaptionLbl: Label 'Datos Documentos';
        ConceptoCaptionLbl: Label 'Concepto';
        CantidadCaptionLbl: Label 'Cantidad';
        AmountCaptionLbl: Label 'Amount';
        TotalCaptionLbl: Label 'Total';
        V1CaptionLbl: Label '1';
        RNC_CaptionLbl: Label 'RNC:';
        Total_RD__CaptionLbl: Label 'Total RD$ ';
        Preparado_por_CaptionLbl: Label 'Preparado por:';
        VendedorCaptionLbl: Label 'Vendedor';
        ClienteCaptionLbl: Label 'Cliente';
        rSalesInvHeader: Record "Sales Invoice Header";
        rDetailedMovCliente: Record "Detailed Cust. Ledg. Entry";
        NCFAFECTA: Text[19];
        DescripcionDPP: Text[250];
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        CopyTxt: Text[10];
        Text000: Label 'COPY';
}

