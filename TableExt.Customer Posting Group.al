tableextension 50173 tableextension50173 extends "Customer Posting Group"
{
    fields
    {
        modify("Payment Disc. Debit Acc.")
        {
            Caption = 'Payment Disc. Debit Acc.';
        }
        field(51000; "Cliente Interno"; Boolean)
        {
            Caption = 'Internal Customer';
            DataClassification = ToBeClassified;
        }
        field(56000; "Invoice Report ID"; Integer)
        {
            Caption = 'Invoice Report ID';
            DataClassification = ToBeClassified;
            // TableRelation = Object.ID WHERE (Type = CONST (Report)); // Error: No se permite TableRelation a Object.ID en extensiones estándar
        }
        field(56001; "Invoice Report Name"; Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("Invoice Report ID")));
            Caption = 'Invoice Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(56002; "Credit Memo Report ID"; Integer)
        {
            Caption = 'Credit memo Report ID';
            DataClassification = ToBeClassified;
            // TableRelation = Object.ID WHERE (Type = CONST (Report)); // Error: No se permite TableRelation a Object.ID en extensiones estándar
        }
        field(56003; "Credit Memo Report Name"; Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("Credit Memo Report ID")));
            Caption = 'Invoice Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(56004; "No aplica Derechos de Autor"; Boolean)
        {
            Caption = 'Apply Author Copyright';
            DataClassification = ToBeClassified;
        }
        field(56005; Promocion; Boolean)
        {
            Caption = 'Promotion';
            DataClassification = ToBeClassified;
        }
        field(56010; "Cta. Dotacion Provision insolv"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '#144';
            TableRelation = "G/L Account";
        }
        field(76041; "Permite emitir NCF"; Boolean)
        {
            Caption = 'Allow to issue NCF';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76079; "No. Serie NCF Factura Venta"; Code[20])
        {
            Caption = 'Sales Inv. NCF Serial No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series";
        }
        field(76080; "No. Serie NCF Abonos Venta"; Code[20])
        {
            Caption = 'Sales Credit Memo NCF Serial No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series";
        }
        field(76056; "RNC/Cedula no Requerido"; Boolean)
        {
            Caption = 'VRN/Doc. ID not Required';
            DataClassification = ToBeClassified;
            Enabled = false; // Error: 'Enabled' no es una propiedad válida para campos en AL
        }
        field(76058; Internacional; Boolean)
        {
            Caption = 'International';
            DataClassification = ToBeClassified;
            Description = 'DSLoc2.0';
        }
    }
}