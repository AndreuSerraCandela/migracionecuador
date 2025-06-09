table 70512 "Precios por Cliente_Producto"
{
    Caption = 'Sales Price';
    LookupPageID = "Price List Lines";

    fields
    {
        field(1; "No. producto"; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;
        }
        field(2; "Codigo ventas"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF ("Tipo Venta" = CONST("Customer Price Group")) "Customer Price Group"
            ELSE
            IF ("Tipo Venta" = CONST(Customer)) Customer
            ELSE
            IF ("Tipo Venta" = CONST(Campaign)) Campaign;
        }
        field(3; "Cod. Divisa"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Fecha Inicial"; Date)
        {
            Caption = 'Starting Date';
        }
        field(5; Precio; Decimal)
        {
            AutoFormatExpression = "Cod. Divisa";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(13; "Tipo Venta"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign;
        }
        field(15; "Fecha Final"; Date)
        {
            Caption = 'Ending Date';
        }
    }

    keys
    {
        key(Key1; "No. producto", "Tipo Venta", "Codigo ventas", "Fecha Inicial", "Cod. Divisa", Precio)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        CustPriceGr: Record "Customer Price Group";
        Text000: Label '%1 cannot be after %2';
        Cust: Record Customer;
        Text001: Label '%1 must be blank.';
        Campaign: Record Campaign;
        Item: Record Item;
        Text002: Label 'You can only change the %1 and %2 from the Campaign Card when %3 = %4';
}

