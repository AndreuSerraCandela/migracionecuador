xmlport 55016 "Exportar prov. FE"
{
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Legacy;

    schema
    {
        tableelement(Vendor; Vendor)
        {
            XmlName = 'Proveedor';
            fieldelement(RUC; Vendor."VAT Registration No.")
            {
            }
            fieldelement(Nombre; Vendor.Name)
            {
            }
            fieldelement(Apellido; Vendor."Name 2")
            {
            }
            fieldelement(Ciudad; Vendor.City)
            {
            }
            fieldelement(Direccion; Vendor.Address)
            {
            }
            fieldelement(Telefono; Vendor."Phone No.")
            {
            }
            fieldelement(Celular; Vendor."Fax No.")
            {
            }
            fieldelement(Email; Vendor."E-Mail")
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
}

