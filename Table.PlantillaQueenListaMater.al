table 70007 "Plantilla Queen Lista Mater."
{

    fields
    {
        field(1; "Codigo Santillana combo"; Code[20])
        {
            Description = 'CAMPO CLAVE';
        }
        field(2; "Codigo Santillana componente"; Code[20])
        {
            Description = 'CAMPO CLAVE';
        }
        field(3; "ISBN Combo"; Code[30])
        {
            Description = 'CAMPO CLAVE';
        }
        field(4;"ISBN Componente";Code[20])
        {
            Description = 'CAMPO CLAVE';
        }
        field(5;"Unidades Componente";Decimal)
        {
        }
        field(6;"Unidad Medida Base";Code[10])
        {
        }
    }

    keys
    {
        key(Key1;"Codigo Santillana combo","Codigo Santillana componente","ISBN Combo","ISBN Componente")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

