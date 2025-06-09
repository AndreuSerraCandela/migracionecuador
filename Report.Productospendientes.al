report 56085 "Productos pendientes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Productospendientes.rdlc';

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
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
            column(Sales_Line__Document_No__; "Document No.")
            {
            }
            column(Sales_Line__No__; "No.")
            {
            }
            column(Sales_Line_Description; Description)
            {
            }
            column(Sales_Line_Quantity; Quantity)
            {
            }
            column(Sales_Line__Outstanding_Quantity_; "Outstanding Quantity")
            {
            }
            column(Sales_Line__Quantity_Shipped_; "Quantity Shipped")
            {
            }
            column(Sales_LineCaption; Sales_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Line__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Sales_Line__No__Caption; FieldCaption("No."))
            {
            }
            column(Sales_Line_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Sales_Line_QuantityCaption; FieldCaption(Quantity))
            {
            }
            column(Sales_Line__Outstanding_Quantity_Caption; FieldCaption("Outstanding Quantity"))
            {
            }
            column(Sales_Line__Quantity_Shipped_Caption; FieldCaption("Quantity Shipped"))
            {
            }
            column(Sales_Line_Document_Type; "Document Type")
            {
            }
            column(Sales_Line_Line_No_; "Line No.")
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
        Sales_LineCaptionLbl: Label 'Sales Line';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
}

