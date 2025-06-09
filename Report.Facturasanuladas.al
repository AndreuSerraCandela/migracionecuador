report 56081 "Facturas anuladas"
{
    // ------------------------------------------------------------------------
    // No.         Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 139         20/11/2013      RRT           Adaptación informes a RTC.
    DefaultLayout = RDLC;
    RDLCLayout = './Facturasanuladas.rdlc';


    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            CalcFields = Amount;
            DataItemTableView = SORTING ("Document No.", "Document Type", "Customer No.") WHERE (Open = FILTER (false));
            RequestFilterFields = "Document No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Cust__Ledger_Entry__Document_No__; "Document No.")
            {
            }
            column(Cust__Ledger_Entry__Customer_No__; "Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(rCliente_Name; rCliente.Name)
            {
            }
            column(Cust__Ledger_Entry_Amount; Amount)
            {
            }
            column(FechaAnulacion; FechaAnulacion)
            {
            }
            column(Cust__Ledger_Entry_Amount_Control1000000018; Amount)
            {
            }
            column(Cust__Ledger_EntryCaption; Cust__Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption; FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(NombreCaption; NombreCaptionLbl)
            {
            }
            column(Fecha_AnulacionCaption; Fecha_AnulacionCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_AmountCaption; FieldCaption(Amount))
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            var
                lMostrar: Boolean;
            begin
                rCliente.Get("Customer No.");

                //+139.
                //... Adaptación del código existente en el trigger Body del mismo DataItem en el apartado Section.
                lMostrar := false;
                FechaAnulacion := 0D;

                //En caso de que el campo "Cerrado por" lo tenga la factura
                if "Closed by Entry No." <> 0 then begin
                    rCustLedgerEntry.Get("Closed by Entry No.");
                    if rCustLedgerEntry."Document Type" = rCustLedgerEntry."Document Type"::"Credit Memo" then begin
                        rCustLedgerEntry.CalcFields(Amount);
                        if Abs(rCustLedgerEntry.Amount) = Abs("Closed by Amount") then begin
                            lMostrar := true;
                            FechaAnulacion := rCustLedgerEntry."Posting Date";
                        end;
                    end;
                end
                else
                //En caso de que el campo "Cerrado por" lo tenga la Nota de credito
                  begin
                    rCustLedgerEntry.Reset;
                    rCustLedgerEntry.SetRange("Closed by Entry No.", "Entry No.");
                    if rCustLedgerEntry.FindFirst then
                        if rCustLedgerEntry."Document Type" = rCustLedgerEntry."Document Type"::"Credit Memo" then
                            if Abs(rCustLedgerEntry."Closed by Amount") = Abs(Amount) then begin
                                lMostrar := true;
                                FechaAnulacion := rCustLedgerEntry."Posting Date";
                            end;
                end;

                if not lMostrar then
                    CurrReport.Skip;

                //-139
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
        rCustLedgerEntry: Record "Cust. Ledger Entry";
        FechaAnulacion: Date;
        Cust__Ledger_EntryCaptionLbl: Label 'Cust. Ledger Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        NombreCaptionLbl: Label 'Nombre';
        Fecha_AnulacionCaptionLbl: Label 'Fecha Anulacion';
        TotalCaptionLbl: Label 'Total';
}

