table 76428 "_Clientes TPV"
{
    // #81410  17/07/2017  PLB: Renumerado a 76314


    fields
    {
        field(1; Identificacion; Code[20])
        {
            Caption = 'Vat Reg. No.';
        }
        field(2; Nombre; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Direccion; Text[100])
        {
            Caption = 'Address';
        }
        field(4; Telefono; Code[30])
        {
            Caption = 'Phone';
        }
        field(5; "Tipo ID"; Option)
        {
            OptionMembers = ,"R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA;
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103; "Tipo Comprobante"; Option)
        {
            Caption = 'Fiscal Type';
            OptionCaption = ' ,Consumidor Final,Crédito Fiscal,Régimen Especial ,Gubernamental';
            OptionMembers = " ","Consumidor Final","Credito Fiscal","Regimen Especial",Gubernamental;
        }
    }

    keys
    {
        key(Key1; Identificacion)
        {
            Clustered = true;
        }
        key(Key2; "Tipo ID")
        {
        }
    }

    fieldgroups
    {
    }
}

