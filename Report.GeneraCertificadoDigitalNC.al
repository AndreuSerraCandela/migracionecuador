report 56010 "Genera Certificado Digital NC"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                if CAE <> '' then
                    CurrReport.Skip;

                if CAEC <> '' then
                    CurrReport.Skip;


                cuFE.NotaCR("Sales Cr.Memo Header");
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
        if "Sales Cr.Memo Header".GetFilter("No.") = '' then
            Error(Error001);
    end;

    var
        Error001: Label 'Invoice No. Must be specified';
        Error002: Label 'Posting date must be specified';
        cuFE: Codeunit "Factura Electronica";
        txtResp: array[7] of Text[1024];
}

