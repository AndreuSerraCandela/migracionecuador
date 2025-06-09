tableextension 50115 tableextension50115 extends "Transfer Shipment Line"
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

        modify("Item Shpt. Entry No.")
        {
            Caption = 'Item Shpt. Entry No.';
        }

        //Unsupported feature: Deletion (FieldCollection) on ""Custom Transit Number"(Field 10003)".

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
        field(50019; "Nombre Almacen Desde"; Text[100])
        {
            CalcFormula = Lookup (Location.Name WHERE (Code = FIELD ("Transfer-from Code")));
            Caption = 'From Location Code';
            Description = '#2080';
            FieldClass = FlowField;
        }
        field(50020; "Nombre Almacen Hasta"; Text[100])
        {
            CalcFormula = Lookup (Location.Name WHERE (Code = FIELD ("Transfer-to Code")));
            Caption = 'To Location Name';
            Description = '#2080';
            FieldClass = FlowField;
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
        field(50029; "Cantidad Anulada"; Decimal)
        {
            Caption = 'Qty. Canceled';
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


    //Unsupported feature: Code Modification on "CopyFromTransferLine(PROCEDURE 1)".

    //procedure CopyFromTransferLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Line No." := TransLine."Line No.";
    "Item No." := TransLine."Item No.";
    Description := TransLine.Description;
    #4..27
    "Shipping Time" := TransLine."Shipping Time";
    "Item Category Code" := TransLine."Item Category Code";

    OnAfterCopyFromTransferLine(Rec,TransLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..30
    //002
    "Precio Venta Consignacion"     := TransLine."Precio Venta Consignacion";
    "Descuento % Consignacion"      := TransLine."Descuento % Consignacion";
    "Importe Consignacion"          := TransLine."Importe Consignacion";
    "No. Mov. Prod. Cosg. a Liq."   := TransLine."No. Mov. Prod. Cosg. a Liq.";
    "No. Linea Pedido Consignacion" := TransLine."No. Linea Pedido Consignacion";
    "No. Pedido Consignacion"       := TransLine."No. Pedido Consignacion";
    //002

    ISBN := TransLine.ISBN; //008

    OnAfterCopyFromTransferLine(Rec,TransLine);
    */
    //end;
}

