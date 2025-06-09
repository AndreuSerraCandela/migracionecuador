report 55017 "Cheques Posfechados Pendientes"
{
    // .
    DefaultLayout = RDLC;
    RDLCLayout = './ChequesPosfechadosPendientes.rdlc';


    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Entry No.") ORDER(Ascending) WHERE ("Cheque Posfechado" = FILTER (true));
            RequestFilterFields = "Entry No.";
            column(rCompanyInf__E_Mail_; CompanyInf."E-Mail")
            {
            }
            column(RUC____rCompanyInf__VAT_Registration_No__; 'RUC: ' + CompanyInf."VAT Registration No.")
            {
            }
            column(Fax____rCompanyInf__Fax_No__; 'Fax: ' + CompanyInf."Fax No.")
            {
            }
            column("Teléfono____rCompanyInf__Phone_No__"; 'Teléfono: ' + CompanyInf."Phone No.")
            {
            }
            column(rCompanyInf__Home_Page_; CompanyInf."Home Page")
            {
            }
            column(rCompanyInf_Picture; CompanyInf.Picture)
            {
            }
            column(rCompanyInf_County_______rPais_Name; CompanyInf.County + ', ' + Pais.Name)
            {
            }
            column(rCompanyInf_Address________rCompanyInf__Address_2_; CompanyInf.Address + ', ' + CompanyInf."Address 2")
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(Cust__Ledger_Entry__Customer_No__; "Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Document_Type_; "Document Type")
            {
            }
            column(Cust__Ledger_Entry__Document_No__; "Document No.")
            {
            }
            column(Cust__Ledger_Entry__External_Document_No__; "External Document No.")
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amount_; "Remaining Amount")
            {
            }
            column(Cust__Ledger_Entry__Due_Date_; "Due Date")
            {
            }
            column(Customer_Name; Customer.Name)
            {
            }
            column(Cust__Ledger_Entry__Salesperson_Code_; "Salesperson Code")
            {
            }
            column(NombreVendedor; NombreVendedor)
            {
            }
            column(COMPROBANTE_INGRESO_BANCOSCaption; COMPROBANTE_INGRESO_BANCOSCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption; FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_Type_Caption; FieldCaption("Document Type"))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry__External_Document_No__Caption; FieldCaption("External Document No."))
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amount_Caption; FieldCaption("Remaining Amount"))
            {
            }
            column(Cust__Ledger_Entry__Due_Date_Caption; FieldCaption("Due Date"))
            {
            }
            column(Cod__Vend_Caption; Cod__Vend_CaptionLbl)
            {
            }
            column(Nombre_DelegadoCaption; Nombre_DelegadoCaptionLbl)
            {
            }
            column(Nombre_ClienteCaption; Nombre_ClienteCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Customer.Get("Customer No.");
                if SalesPers.Get("Salesperson Code") then
                    NombreVendedor := SalesPers.Name
                else
                    NombreVendedor := '';
            end;

            trigger OnPreDataItem()
            begin
                GLSetUp.Get;
                CompanyInf.Get;
                CompanyInf.CalcFields(Picture);
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
        CompanyInf: Record "Company Information";
        Pais: Record "Country/Region";
        GLSetUp: Record "General Ledger Setup";
        Customer: Record Customer;
        SalesPers: Record "Salesperson/Purchaser";
        NombreVendedor: Text[250];
        COMPROBANTE_INGRESO_BANCOSCaptionLbl: Label 'FUTURE CHECKS PENDING';
        Cod__Vend_CaptionLbl: Label 'Cod. Vend.';
        Nombre_DelegadoCaptionLbl: Label 'Nombre Delegado';
        Nombre_ClienteCaptionLbl: Label 'Nombre Cliente';
}

