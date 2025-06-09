table 82514 "MIG Formas de Pago TPV"
{
    Caption = 'Tender Types POS';
    LookupPageID = "Dimension Defecto Almacen";

    fields
    {
        field(1; "ID Pago"; Code[20])
        {
            Caption = 'Payment ID';
            NotBlank = true;
        }
        field(2; Descripcion; Text[250])
        {
            Caption = 'Description';
        }
        field(3; Activo; Boolean)
        {
            Caption = 'Active';
        }
        field(4; Tipo; Option)
        {
            Caption = 'Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = Cuenta,Cliente,Proveedor,Banco;
        }
        field(5; "No."; Code[20])
        {
            TableRelation = IF (Tipo = CONST (Cuenta)) "G/L Account"
            ELSE
            IF (Tipo = CONST (Cliente)) Customer
            ELSE
            IF (Tipo = CONST (Proveedor)) Vendor
            ELSE
            IF (Tipo = CONST (Banco)) "Bank Account";
        }
        field(6; "Cod. divisa"; Code[10])
        {
            Caption = 'Currency code';
            TableRelation = Currency;
        }
        field(7; Cambio; Boolean)
        {
            Caption = 'Change';
        }
        field(8; "Abre cajon"; Boolean)
        {
            Caption = 'Open Drawer';
        }
        field(9; "Filtro Cajero"; Code[20])
        {
            Caption = 'Cashier Filter';
        }
        field(10; "Filtro Fecha"; Date)
        {
            Caption = 'Date Filter';
        }
        field(11; "Filtro Hora"; Time)
        {
            Caption = 'Time Filter';
        }
        field(12; "Notas de Credito"; Boolean)
        {
        }
        field(13; "Tarjeta Credito"; Boolean)
        {
        }
        field(14; Devolucion; Boolean)
        {
            Caption = 'Return';
        }
        field(15; "Exencion IVA"; Boolean)
        {
            Caption = 'VAT exemption';
        }
        field(25; Otros; Boolean)
        {
            Caption = 'Others';
        }
        field(26; Agrupa; Boolean)
        {
        }
        field(27; "Forma Pago Agrupacion"; Option)
        {
            Caption = 'Group Payment method';
            OptionCaption = ',Cash,Check,Credit Card,Debit Card';
            OptionMembers = " ",Efectivo,Cheque,"Tarjeta de Credito","Tarjeta de Debito";
        }
    }

    keys
    {
        key(Key1; "ID Pago")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*
        //Replicador
        rRec.GETTABLE(Rec);
        cuReplicatorFun.OnDelete(rRec);
        //Replicador
        */

    end;

    var
        error001: Label 'Already exist a Change tender type';
}

