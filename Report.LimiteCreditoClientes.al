report 56080 "Limite Credito Clientes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LimiteCreditoClientes.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            CalcFields = "Balance (LCY)";
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer_Balance; Balance)
            {
            }
            column(Customer__Credit_Limit__LCY__; "Credit Limit (LCY)")
            {
            }
            column(CustomerCaption; CustomerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption; FieldCaption("No."))
            {
            }
            column(Customer_NameCaption; FieldCaption(Name))
            {
            }
            column(Customer_BalanceCaption; FieldCaption(Balance))
            {
            }
            column(Customer__Credit_Limit__LCY__Caption; FieldCaption("Credit Limit (LCY)"))
            {
            }

            trigger OnAfterGetRecord()
            var
                wNuevoLimiteCredito: Decimal;
            begin
                //+#139
                if "Credit Limit (LCY)" = 0 then
                    CurrReport.Skip
                else
                    if rConfSantillana."Notificacion de Credito %" <> 0 then
                        wNuevoLimiteCredito := "Credit Limit (LCY)" - (("Credit Limit (LCY)" * rConfSantillana."Notificacion de Credito %") / 100)
                    else
                        wNuevoLimiteCredito := "Credit Limit (LCY)";
                if "Balance (LCY)" < wNuevoLimiteCredito then
                    CurrReport.Skip
                //-#139
            end;

            trigger OnPreDataItem()
            begin
                rConfSantillana.Get;
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
        rConfSantillana: Record "Config. Empresa";
        CustomerCaptionLbl: Label 'Customer';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
}

