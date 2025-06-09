table 82500 "MIG Configuracion TPV"
{
    Caption = 'POS General Setup';

    fields
    {
        field(1; "Clave primaria"; Code[10])
        {
        }
        field(2; "Imagenes en TPV"; Boolean)
        {
            Caption = 'POS Pictures';
        }
        field(3; "Sumar lineas"; Boolean)
        {
            Caption = 'Add Lines';
        }
        field(4; "Nombre libro diario"; Code[20])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(5; "Nombre sección diario"; Code[20])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name" = FIELD ("Nombre libro diario"));
        }
        field(6; "No. Tarjeta editable en TPV"; Boolean)
        {
            Caption = 'Card ID editable in POS';
        }
        field(7; "Funcionalidad NCF TPV Activa"; Boolean)
        {
            Caption = 'NCF Function Active';
        }
        field(8; "No. serie NCF Factura unica"; Code[20])
        {
            Caption = 'NCF No. series';
            TableRelation = "No. Series";
        }
        field(9; "Banco pago factura comprimida"; Code[20])
        {
            Caption = 'Compressed invoice bank';
            TableRelation = "Bank Account";
        }
        field(10; "Compresion de ventas"; Boolean)
        {
            Caption = 'Sales Compress';
        }
        field(11; "Registro en linea"; Boolean)
        {
            Caption = 'Online Post';
        }
        field(12; "Cod. Tienda"; Code[20])
        {
            Caption = 'Store Code';
            TableRelation = "Bancos tienda";
        }
        field(13; "Imprime Remision Venta"; Boolean)
        {
            Caption = 'Print Sales Shipment';
        }
        field(14; "BD Central"; Boolean)
        {
            Caption = 'Central DB';
        }
        field(15; "No. Factura por TPV"; Boolean)
        {
            Caption = 'Invoice No. By POS';
        }
        field(17; "Tipo Seguridad"; Option)
        {
            Caption = 'Security Type';
            OptionCaption = ' ,Password,Key,Mag Stripe';
            OptionMembers = " ","Contraseña",Llave,"Banda Magnética";
        }
        field(55000; "Inserta Lineas Cupon"; Boolean)
        {
            Caption = 'Insert Coupons Lines';
        }
        field(55001; "Cantidad de Lineas en Pedido"; Integer)
        {
            Caption = 'Lines Qty.';
        }
    }

    keys
    {
        key(Key1; "Clave primaria")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

