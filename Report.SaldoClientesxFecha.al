report 56077 "Saldo Clientes x Fecha"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SaldoClientesxFecha.rdlc';

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
        {
            DataItemTableView = SORTING ("Customer No.", "Initial Entry Due Date", "Posting Date", "Currency Code");
            RequestFilterFields = "Customer No.", "Posting Date";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Detailed_Cust__Ledg__Entry__Customer_No__; "Customer No.")
            {
            }
            column(Detailed_Cust__Ledg__Entry__Amount__LCY__; "Amount (LCY)")
            {
            }
            column(nombrecliente; nombrecliente)
            {
            }
            column(Detailed_Cust__Ledg__Entry__Amount__LCY___Control1000000007; "Amount (LCY)")
            {
            }
            column(Detailed_Cust__Ledg__EntryCaption; Detailed_Cust__Ledg__EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(No__ClienteCaption; No__ClienteCaptionLbl)
            {
            }
            column(Nombre_ClienteCaption; Nombre_ClienteCaptionLbl)
            {
            }
            column(SaldoCaption; SaldoCaptionLbl)
            {
            }
            column(Total_GeneralCaption; Total_GeneralCaptionLbl)
            {
            }
            column(Detailed_Cust__Ledg__Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //+#139
                if "Customer No." <> rclientes."No." then
                    if rclientes.Get("Customer No.") then
                        nombrecliente := rclientes.Name;
                //-#139
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Customer No.");
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
        rclientes: Record Customer;
        nombrecliente: Text[200];
        Detailed_Cust__Ledg__EntryCaptionLbl: Label 'Detailed Cust. Ledg. Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        No__ClienteCaptionLbl: Label 'No. Cliente';
        Nombre_ClienteCaptionLbl: Label 'Nombre Cliente';
        SaldoCaptionLbl: Label 'Saldo';
        Total_GeneralCaptionLbl: Label 'Total General';
}

