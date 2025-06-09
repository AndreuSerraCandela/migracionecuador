table 76315 "Conf. Rutas Imp/Exp. Ventas"
{
    Caption = 'Sales Import Path Setup';

    fields
    {
        field(1; "Cod. Tienda"; Code[20])
        {
            Caption = 'Store Code';
            NotBlank = true;
            TableRelation = "Bancos tienda";
        }
        field(2; "Ruta Importa Ventas"; Text[200])
        {
            Caption = 'Sales Import Path';
        }
        field(3; Direccion; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Export,Import';
            OptionMembers = Exporta,Importa;
        }
        field(4; "Cod. Tienda Destino"; Code[20])
        {
            Caption = 'Object Store Code';
            TableRelation = "Bancos tienda";
        }
    }

    keys
    {
        key(Key1; "Cod. Tienda", Direccion)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

