report 76060 "Plantilla Horas Extras"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PlantillaHorasExtras.rdlc';
    Caption = 'Template Over Time';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(GETFILTERS; GetFilters)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Full_Name_; "Full Name")
            {
            }
            column(Employee_Salario; Salario)
            {
            }
            column(Template_Over_TimeCaption; Template_Over_TimeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(Employee__Full_Name_Caption; FieldCaption("Full Name"))
            {
            }
            column(Employee_SalarioCaption; FieldCaption(Salario))
            {
            }
            column(V1Caption; V1CaptionLbl)
            {
            }
            column(V2Caption; V2CaptionLbl)
            {
            }
            column(V3Caption; V3CaptionLbl)
            {
            }
            column(V4Caption; V4CaptionLbl)
            {
            }
            column(V5Caption; V5CaptionLbl)
            {
            }
            column(V6Caption; V6CaptionLbl)
            {
            }
            column(V7Caption; V7CaptionLbl)
            {
            }
            column(V8Caption; V8CaptionLbl)
            {
            }
            column(V9Caption; V9CaptionLbl)
            {
            }
            column(V10Caption; V10CaptionLbl)
            {
            }
            column(V11Caption; V11CaptionLbl)
            {
            }
            column(V12Caption; V12CaptionLbl)
            {
            }
            column(V13Caption; V13CaptionLbl)
            {
            }
            column(V14Caption; V14CaptionLbl)
            {
            }
            column(V15Caption; V15CaptionLbl)
            {
            }
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
        Template_Over_TimeCaptionLbl: Label 'Template Over Time';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        V1CaptionLbl: Label '1';
        V2CaptionLbl: Label '2';
        V3CaptionLbl: Label '3';
        V4CaptionLbl: Label '4';
        V5CaptionLbl: Label '5';
        V6CaptionLbl: Label '6';
        V7CaptionLbl: Label '7';
        V8CaptionLbl: Label '8';
        V9CaptionLbl: Label '9';
        V10CaptionLbl: Label '10';
        V11CaptionLbl: Label '11';
        V12CaptionLbl: Label '12';
        V13CaptionLbl: Label '13';
        V14CaptionLbl: Label '14';
        V15CaptionLbl: Label '15';
}

