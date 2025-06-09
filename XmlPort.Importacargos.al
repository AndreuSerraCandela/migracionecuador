xmlport 76044 "Importa cargos"
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(ImportaCargos)
        {
            tableelement("Puestos laborales"; "Puestos laborales")
            {
                XmlName = 'PuestosLaborales';
                fieldelement(Codigo; "Puestos laborales".Codigo)
                {
                }
                fieldelement(Descripcion; "Puestos laborales".Descripcion)
                {
                }
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

