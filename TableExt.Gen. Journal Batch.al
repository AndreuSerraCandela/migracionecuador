tableextension 50034 tableextension50034 extends "Gen. Journal Batch"
{
    fields
    {
        modify("Copy VAT Setup to Jnl. Lines")
        {
            Caption = 'Copy Tax Setup to Jnl. Lines';
        }

        //Unsupported feature: Deletion (FieldCollection) on ""Pending Approval"(Field 28)".

        field(50000; "Seccion POS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55000; "Seccion Cheques Posfechados"; Boolean)
        {
            Caption = 'Future Checks Batch';
            DataClassification = ToBeClassified;
        }
        field(55001; "Seccion Cheques Protestado"; Boolean)
        {
            Caption = 'Check protested Section';
            DataClassification = ToBeClassified;
        }
        field(55002; "Seccion Caja Chica"; Boolean)
        {
            Caption = 'Petty Cash Batch';
            DataClassification = ToBeClassified;
        }
        field(55003; "Seccion Retencion Venta"; Boolean)
        {
            Caption = 'Sales Retention Batch';
            DataClassification = ToBeClassified;
        }
    }
}

