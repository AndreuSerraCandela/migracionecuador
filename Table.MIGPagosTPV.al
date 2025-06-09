table 82515 "MIG Pagos TPV"
{
    Caption = 'Tender POS';
    LookupPageID = "Dimension Set Entries TPV";

    fields
    {
        field(1; "Forma pago TPV"; Code[20])
        {
            Caption = 'Tender Type POS';
        }
        field(2; "Cod. divisa"; Code[10])
        {
            Caption = 'Currency code';
        }
        field(3; "Importe (DL)"; Decimal)
        {
            Caption = 'Amount';
        }
        field(4; Importe; Decimal)
        {
        }
        field(5; "No. pedido"; Code[20])
        {
            Caption = 'Order no.';
        }
        field(6; Cajero; Code[20])
        {
            Caption = 'Cashier';
        }
        field(7; Fecha; Date)
        {
            Caption = 'Date';
        }
        field(8; Hora; Time)
        {
            Caption = 'Time';
        }
        field(9; "No. Factura"; Code[20])
        {
            TableRelation = "Sales Invoice Header";
        }
        field(10; "No. Mov. Nota Credito"; Integer)
        {
        }
        field(11; "Tipo Tarjeta"; Option)
        {
            OptionMembers = " ",VISA,MASTERCARD,ATH,"AMERICAN EXPRESS";
        }
        field(12; "No. Tarjeta"; Text[50])
        {
        }
        field(13; "No. Cheque"; Text[30])
        {
        }
        field(14; "Banco Cheque"; Option)
        {
            OptionMembers = " ","Banco Popular",BHD,Banreservas,Progreso,ScotiaBank,Proamerica;
        }
        field(15; "No. Factura Devolucion"; Code[20])
        {
            Caption = 'Return Invoice No.';
            TableRelation = "Sales Invoice Header";
        }
        field(16; Tienda; Code[20])
        {
            Caption = 'Store';
            TableRelation = "Bancos tienda";
        }
        field(17; TPV; Code[20])
        {
            Caption = 'POS';
        }
        field(18; "No. Exencion IVA"; Code[30])
        {
            Caption = 'VAT Exemption';
        }
        field(99999; Renumerado; Code[20])
        {
            Description = 'Para proceso de corregir replica';
        }
    }

    keys
    {
        key(Key1; "Forma pago TPV", "No. pedido")
        {
            Clustered = true;
        }
        key(Key2; "No. Factura Devolucion")
        {
        }
    }

    fieldgroups
    {
    }
}

