tableextension 50117 tableextension50117 extends "Transfer Receipt Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".

        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 23)".


        //Unsupported feature: Property Modification (Data type) on ""Transfer-from Code"(Field 29)".


        //Unsupported feature: Property Modification (Data type) on ""Transfer-to Code"(Field 30)".

        modify("Item Rcpt. Entry No.")
        {
            Caption = 'Item Rcpt. Entry No.';
        }
        field(50000; "Precio Venta Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Descuento % Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Importe Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; ISBN; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item.ISBN;
        }
        field(50010; "No. Pedido Consignacion"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "No. Linea Pedido Consignacion"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "No. Mov. Prod. Cosg. a Liq."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Cantidad Consg. Aplicada"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Cantidad Devuelta"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Grupo registro IVA prod."; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }
        field(50016; "Grupo registro IVA neg."; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";
        }
        field(50017; "% IVA"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Importe IVA"; Decimal)
        {
            Caption = 'VAT Amount';
            DataClassification = ToBeClassified;
        }
        field(50020; "Cantidad Aprobada"; Decimal)
        {
            Caption = 'Approved Qty.';
            DataClassification = ToBeClassified;
        }
        field(50021; "Cantidad pendiente BO"; Decimal)
        {
            Caption = 'BO Pending Qty.';
            DataClassification = ToBeClassified;
        }
        field(50022; "Cantidad a Anular"; Decimal)
        {
            Caption = 'Qty. to Void';
            DataClassification = ToBeClassified;
        }
        field(50023; "Cantidad Solicitada"; Decimal)
        {
            Caption = 'Requested Qty.';
            DataClassification = ToBeClassified;
        }
        field(50024; "Cantidad a Ajustar"; Decimal)
        {
            Caption = 'Qty. To Adjust';
            DataClassification = ToBeClassified;
        }
        field(50025; "Porcentaje Cant. Aprobada"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Error_L001: Label 'Porcentage must be between 0 and 100';
            begin
            end;
        }
        field(50029; "Cantidad Anulada"; Decimal)
        {
            Caption = 'Qty. Canceled';
            DataClassification = ToBeClassified;
        }
        field(56028; Disponible; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(76012; "Cantidad Alumnos"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Description = 'APS';
            Editable = false;
        }
        field(76034; Adopcion; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            Editable = false;
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(76014; "Cod. Colegio"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            Editable = false;
            TableRelation = Contact;
        }
    }
    keys
    {
        key(Key3; "Transfer-to Code")
        {
        }
    }
}

