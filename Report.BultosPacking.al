report 56019 "Bultos Packing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './BultosPacking.rdlc';

    dataset
    {
        dataitem("Lin. Packing"; "Lin. Packing")
        {
            DataItemTableView = SORTING ("No.", "No. Caja");
            RequestFilterFields = "No.", "No. Caja";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Lin__Packing__No__; "No.")
            {
            }
            column(Lin__Packing__No__Caja_; "No. Caja")
            {
            }
            column(Lin__Packing__Fecha_Apertura_Caja_; "Fecha Apertura Caja")
            {
            }
            column(Lin__Packing__Fecha_Cierre_Caja_; "Fecha Cierre Caja")
            {
            }
            column(Lin__Packing__Estado_Caja_; "Estado Caja")
            {
            }
            column(Lin__Packing__No__Picking_; "No. Picking")
            {
            }
            column(N; N)
            {
            }
            column(CantCajas; CantCajas)
            {
            }
            column(Packing_LineCaption; Packing_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Lin__Packing__No__Caption; FieldCaption("No."))
            {
            }
            column(Lin__Packing__No__Caja_Caption; FieldCaption("No. Caja"))
            {
            }
            column(Lin__Packing__Fecha_Apertura_Caja_Caption; FieldCaption("Fecha Apertura Caja"))
            {
            }
            column(Lin__Packing__Fecha_Cierre_Caja_Caption; FieldCaption("Fecha Cierre Caja"))
            {
            }
            column(Lin__Packing__Estado_Caja_Caption; FieldCaption("Estado Caja"))
            {
            }
            column(Lin__Packing__No__Picking_Caption; FieldCaption("No. Picking"))
            {
            }
            column(BULTOCaption; BULTOCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
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
        LP: Record "Lin. Packing";
        CantCajas: Integer;
        I: Integer;
        N: Integer;
        Packing_LineCaptionLbl: Label 'Packing Line';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        BULTOCaptionLbl: Label 'BULTO';
        EmptyStringCaptionLbl: Label '/';
}

