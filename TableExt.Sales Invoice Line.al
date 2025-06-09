tableextension 50008 tableextension50008 extends "Sales Invoice Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 12)".

        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Attached to Line No.")
        {
            Caption = 'Attached to Line No.';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        modify("IC Partner Ref. Type")
        {
            Caption = 'IC Partner Ref. Type';
        }
        modify("Job Contract Entry No.")
        {
            Caption = 'Job Contract Entry No.';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Depr. until FA Posting Date")
        {
            Caption = 'Depr. until FA Posting Date';
        }
        modify("Duplicate in Depreciation Book")
        {
            Caption = 'Duplicate in Depreciation Book';
        }

        //Unsupported feature: Deletion (FieldCollection) on ""Retention Attached to Line No."(Field 10001)".


        //Unsupported feature: Deletion (FieldCollection) on ""Retention VAT %"(Field 10002)".

        field(50014; "Cod. Cupon"; Code[20])
        {
            Caption = 'Coupon Code';
            DataClassification = ToBeClassified;
        }
        field(50015; "No. Linea Cupon"; Integer)
        {
            Caption = 'Coupon Line No.';
            DataClassification = ToBeClassified;
        }
        field(50016; "Cantidad Aprobada"; Decimal)
        {
            Caption = 'Approved Qty.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
            begin
            end;
        }
        field(50017; "Cantidad pendiente BO"; Decimal)
        {
            Caption = 'BO Pending Qty.';
            DataClassification = ToBeClassified;
        }
        field(50018; "Cantidad a Anular"; Decimal)
        {
            Caption = 'Qty. to Void';
            DataClassification = ToBeClassified;
        }
        field(50019; "Cantidad Solicitada"; Decimal)
        {
            Caption = 'Requested Qty.';
            DataClassification = ToBeClassified;
        }
        field(50020; Temporal; Boolean)
        {
            Caption = 'Temp';
            DataClassification = ToBeClassified;
        }
        field(50021; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(50022; "Cantidad Anulada"; Decimal)
        {
            Caption = 'Qty. Canceled';
            DataClassification = ToBeClassified;
        }
        field(50040; "Cantidad a Ajustar"; Decimal)
        {
            Caption = 'Qty. To Adjust';
            DataClassification = ToBeClassified;
        }
        field(50041; "Porcentaje Cant. Aprobada"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Error_L001: Label 'Porcentage must be between 0 and 100';
            begin
            end;
        }
        field(50046; "Cantidad Devuelta"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ClasDev';
        }
        field(50047; ClasDev; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ClasDev';
        }
        field(50110; "No. Documento SIC"; Code[40])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(55012; "Parte del IVA"; Boolean)
        {
            Caption = 'VAT part';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(56001; Disponible; Boolean)
        {
            Caption = 'Available';
            DataClassification = ToBeClassified;
            Description = 'Gestion BackOrder';
        }
        field(76015; Devuelto; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76026; "Devuelto en Documento"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76020; "Devuelto en Linea Documento"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76030; "Cantidad devuelta TPV"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard,#355717';
        }
        field(76295; "Cantidad dev. TPV (calc)"; Decimal)
        {
            CalcFormula = Sum("Sales Cr.Memo Line".Quantity WHERE("Devuelve a Documento" = FIELD("Document No."),
                                                                   "Devuelve a Linea Documento" = FIELD("Line No.")));
            Description = 'DsPOS Standard,#355717';
            FieldClass = FlowField;
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
        field(76042; "Tipo de bien-servicio"; Option)
        {
            Caption = 'Type of Good/Service';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            OptionCaption = 'Good,Service,Selective,Tips,Other';
            OptionMembers = Bienes,Servicios,"Selectivo al consumo","Propina legal",Otros;
        }
    }
    keys
    {
        /*  key(Key10; "Document No.", Type, "No.")
         {
         } */
        key(Key20; "Document No.", "Posting Date", Type, "No.")
        {
        }
        key(Key30; "Cod. Cupon")
        {
        }
        key(Key40; "Document No.", "Bill-to Customer No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        {
            SumIndexFields = "Line Amount";
        }
        key(Key50; Devuelto)
        {
        }
        key(Key60; "Document No.", Type, Quantity)
        {
        }
        key(Key70; "Cantidad Devuelta", ClasDev)
        {
        }
    }
}

