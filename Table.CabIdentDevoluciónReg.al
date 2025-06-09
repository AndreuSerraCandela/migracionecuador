table 56018 "Cab. Ident. Devolución Reg."
{

    fields
    {
        field(1; "No. Ident. Devolucion"; Code[20])
        {
            Caption = 'Return Identifier No.';
        }
        field(2; "Id. Usuario"; Code[50])
        {
            Caption = 'User ID';
        }
        field(3; "Cod. Cliente"; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;
        }
        field(4; "Nombre Cliente"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(5; "Cantidad de Bultos"; Integer)
        {
            Caption = 'Number of Packages';
        }
        field(6; Comentarios; Text[250])
        {
            Caption = 'Comments';
        }
        field(7; "Fecha Recepcion"; Date)
        {
            Caption = 'Receipt Date';
        }
        field(8; "Fecha Registro"; Date)
        {
            Caption = 'Posting Date';
        }
        field(9; "Agencia Transporte"; Text[100])
        {
            Caption = 'Transportation Agency';
        }
        field(10; "Tipo de Producto"; Option)
        {
            Caption = 'Product Type';
            OptionCaption = ' ,Text,Not Text,Mixed';
            OptionMembers = " ",Texto,"No Texto",Mixta;
        }
        field(11; Ubicacion; Text[250])
        {
            Caption = 'Place';
        }
        field(12; Almacen; Code[20])
        {
            Caption = 'Location';
        }
        field(13; Procesada; Boolean)
        {
            Caption = 'Processed';
        }
    }

    keys
    {
        key(Key1; "No. Ident. Devolucion")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

