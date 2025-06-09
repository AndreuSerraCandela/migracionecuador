table 82503 "MIG TPV"
{
    Caption = 'TPV';
    LookupPageID = "Lista Grupo Cajeros";

    fields
    {
        field(1; "TPV ID"; Code[50])
        {

            trigger OnValidate()
            begin
                /*
                IF "Tipo Conexion" = "Tipo Conexion"::Windows THEN
                  BEGIN
                    WinLogIn.RESET;
                    WinLogIn.SETRANGE(WinLogIn.ID,"TPV ID");
                    IF NOT WinLogIn.FINDFIRST THEN
                      ERROR(Error001,"TPV ID");
                  END;
                */

            end;
        }
        field(2; Descripcion; Text[200])
        {
        }
        field(3; "No. serie Pedidos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "Menu de acciones"; Code[20])
        {
            TableRelation = "Menu ventas TPV";
        }
        field(5; "Menu de productos"; Code[20])
        {
            TableRelation = "Menu ventas TPV";
        }
        field(6; "Menu de formas de pago"; Code[20])
        {
            TableRelation = "Menu ventas TPV";
        }
        field(7; "ID Reporte contado"; Integer)
        {
            Caption = 'Cash Receipt ID';
            TableRelation = AllObj."Object ID" WHERE ("Object Type" = CONST (Report));
        }
        field(8; "ID Reporte venta a credito"; Integer)
        {
            Caption = 'Credit sales report ID';
            TableRelation = AllObj."Object ID" WHERE ("Object Type" = CONST (Report));
        }
        field(9; "NCF Consumidor final"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "NCF Credito fiscal"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Texto 1"; Text[250])
        {
            Caption = 'Text 1';
        }
        field(12; "Texto 2"; Text[250])
        {
            Caption = 'Text 2';
        }
        field(13; "Texto 3"; Text[250])
        {
            Caption = 'Text 3';
        }
        field(14; "Texto 4"; Text[250])
        {
            Caption = 'Text 4';
        }
        field(15; Tienda; Code[20])
        {
            Caption = 'Store';
            TableRelation = "Bancos tienda";
        }
        field(16; "ID Reporte cuadre"; Integer)
        {
            Caption = 'Balancing report ID';
            TableRelation = AllObj."Object ID" WHERE ("Object Type" = CONST (Report));
        }
        field(17; "NCF Gubernamentales"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(18; "NCF Regimenes especiales"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(19; Comment; Boolean)
        {
        }
        field(20; "Cantidad de Copias Contado"; Integer)
        {
        }
        field(21; "Cantidad de Copias Credito"; Integer)
        {
        }
        field(22; "No. Serie Impresora/Maquina"; Code[50])
        {
        }
        field(47; "Tipo Scanner"; Option)
        {
            Caption = 'Escanner Type';
            OptionCaption = 'Keyboard,OPOS';
            OptionMembers = Teclado,OPOS;
        }
        field(48; "Tipo LineDisplay"; Option)
        {
            Caption = 'LineDisplay Type';
            OptionCaption = 'None,OCX';
            OptionMembers = Ninguno,OCX;
        }
        field(49; "Numero de Logo"; Text[2])
        {
        }
        field(50; "Tipo Cajon"; Option)
        {
            Caption = 'Cashdrawer Type';
            OptionCaption = 'Nothing,OCX';
            OptionMembers = Ninguno,OCX;
        }
        field(51; "Tipo MSR"; Option)
        {
            Caption = 'MSR Type';
            OptionMembers = Manual,MSR;
        }
        field(52; "No. Serie Fact. Reg."; Code[20])
        {
            Caption = 'Posted Inv. No. Series';
            TableRelation = "No. Series";
        }
        field(53; "No. Serie NCR. Reg."; Code[20])
        {
            Caption = 'Credit Memo Posting No. Series';
            TableRelation = "No. Series";
        }
        field(54; "NCF Consumidor final NCR"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(55; "NCF Credito fiscal NCR"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(56; Serie; Code[3])
        {
        }
        field(57; Pantalla; Integer)
        {
            Caption = 'Screen';
        }
        field(58; "Nombre Pantalla"; Text[100])
        {
            CalcFormula = Lookup (AllObjWithCaption."Object Name" WHERE ("Object Type" = CONST (Page),
                                                                        "Object ID" = FIELD (Pantalla)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Tipo Conexion"; Option)
        {
            Caption = 'Connection Type';
            OptionCaption = 'Database,Windows';
            OptionMembers = "Base de datos",Windows;
        }
        field(70; "No. Serie Borrador Nota Cr."; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "TPV ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

