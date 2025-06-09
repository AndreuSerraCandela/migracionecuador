table 82507 "MIG Botones"
{
    Caption = 'Buttons';
    LookupPageID = "Lista Acciones";

    fields
    {
        field(1; "ID boton"; Integer)
        {
            Caption = 'Boton ID';
            NotBlank = true;
        }
        field(2; Descripcion; Text[250])
        {
            Caption = 'Description';
        }
        field(3; "ID Menu"; Code[10])
        {
            Caption = 'Menu ID';
        }
        field(4; Accion; Code[20])
        {
            Caption = 'Action';
            TableRelation = "Log procesos TPV";
        }
        field(5; Etiqueta; Text[30])
        {
            Caption = 'Caption';
        }
        field(6; Color; Code[20])
        {
            TableRelation = "Menus TPV";
        }
        field(7; Activo; Boolean)
        {
            Caption = 'Active';
        }
        field(8; "Descuento %"; Decimal)
        {
            Caption = 'Discount %';

            trigger OnValidate()
            begin
                "Descuento general" := false;
            end;
        }
        field(9; Seguridad; Option)
        {
            Caption = 'Password';
            OptionCaption = ' ,Password,Key,Magnetic Stripe';
            OptionMembers = " ","Contraseña",Llave," Banda Magnetica";
        }
        field(10; "Menu pagos"; Boolean)
        {
            Caption = 'Tender Menu';
        }
        field(11; Pago; Code[20])
        {
            Caption = 'Tender';
            TableRelation = "Formas de Pago TPV";
        }
        field(12; Tipo; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset";
        }
        field(13; "No."; Code[20])
        {
            TableRelation = IF (Tipo = CONST ("G/L Account")) "G/L Account"
            ELSE
            IF (Tipo = CONST (Item)) Item
            ELSE
            IF (Tipo = CONST (Resource)) Resource
            ELSE
            IF (Tipo = CONST ("Fixed Asset")) "Fixed Asset";
        }
        field(14; "Menu anterior"; Boolean)
        {
            Caption = 'Previous Menu';
        }
        field(15; "Descuento general"; Boolean)
        {
            Caption = 'General Disc.';

            trigger OnValidate()
            begin
                "Descuento %" := 0;
            end;
        }
        field(16; "Descuento general %"; Decimal)
        {
            Caption = 'General Disc. %';
        }
        field(50000; "Source Counter"; BigInteger)
        {
        }
    }

    keys
    {
        key(Key1; "ID boton", "ID Menu")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

