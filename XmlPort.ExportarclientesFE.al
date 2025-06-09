xmlport 55015 "Exportar clientes FE"
{
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Legacy;

    schema
    {
        tableelement(Customer; Customer)
        {
            XmlName = 'Cliente';
            fieldelement(RUC; Customer."VAT Registration No.")
            {
            }
            fieldelement(Nombre; Customer.Name)
            {
            }
            fieldelement(Apellido; Customer."Name 2")
            {
            }
            fieldelement(Ciudad; Customer.City)
            {
            }
            fieldelement(Direccion; Customer.Address)
            {
            }
            fieldelement(Telefono; Customer."Phone No.")
            {
            }
            fieldelement(Celular; Customer."Fax No.")
            {
            }
            fieldelement(Email; Customer."E-Mail")
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

