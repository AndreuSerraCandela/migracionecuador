report 56008 "Genera Certificado Digital"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                if CAE <> '' then
                    CurrReport.Skip;

                if CAEC <> '' then
                    CurrReport.Skip;


                cuFE.Factura("Sales Invoice Header");
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
        if "Sales Invoice Header".GetFilter("No.") = '' then
            Error(Error001);

        /*
        IF "Sales Invoice Header".GETFILTER("Posting Date") = '' THEN
          ERROR(Error002);
        */

    end;

    var
        Error001: Label 'Invoice No. Must be specified';
        Error002: Label 'Posting date must be specified';
        cuFE: Codeunit "Factura Electronica";
        txtResp: array[7] of Text[1024];
}

