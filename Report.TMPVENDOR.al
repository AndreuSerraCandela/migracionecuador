report 56044 "TMP VENDOR"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TMPVENDOR.rdlc';

    dataset
    {
        dataitem(Vendor; Vendor)
        {

            trigger OnAfterGetRecord()
            begin

                if Vendor."Tipo Documento" = Vendor."Tipo Documento"::RUC then begin
                    Vendor."Tipo Documento" := Vendor."Tipo Documento"::Pasaporte;
                    Vendor.Modify;
                end;

                if Vendor."Tipo Ruc/Cedula" <> Vendor."Tipo Ruc/Cedula"::" " then begin
                    Vendor."Tipo Ruc/Cedula" := Vendor."Tipo Ruc/Cedula"::" ";
                    Vendor.Modify;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('fin');
            end;

            trigger OnPreDataItem()
            begin
                Vendor.SetRange(Vendor."Tipo Contribuyente", 'EX');
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
}

