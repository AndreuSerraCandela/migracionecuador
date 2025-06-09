tableextension 50028 tableextension50028 extends "Cust. Ledger Entry"
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Closed by Entry No.")
        {
            Caption = 'Closed by Entry No.';
        }
        modify("Closed by Amount (LCY)")
        {
            Caption = 'Closed by Amount ($)';
        }
        modify("Remaining Pmt. Disc. Possible")
        {
            Caption = 'Remaining Pmt. Disc. Possible';
        }
        modify("Reversed by Entry No.")
        {
            Caption = 'Reversed by Entry No.';
        }
        modify("Applies-to Ext. Doc. No.")
        {
            Caption = 'Applies-to Ext. Doc. No.';
        }
        modify("Direct Debit Mandate ID")
        {
            Caption = 'Direct Debit Mandate ID';
        }
        field(50013; "Forma de Pago"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(55000; "ID Retencion Venta"; Code[30])
        {
            Caption = 'Sales Retention ID';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55001; "Cheque Posfechado"; Boolean)
        {
            Caption = 'Future Check';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55002; "Cheque Protestado"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55003; Agencia; Code[20])
        {
            Caption = 'Agency';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55004; "Importe Retencion Venta"; Decimal)
        {
            Caption = 'Sales Retention Amount';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55005; "Importe Ret. Renta a liquidar"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
            Description = '#34822';

            trigger OnValidate()
            begin
                //+#34822
                TestField("ID Retencion Venta");
                Validate("Amount to Apply", "Importe Ret. Renta a liquidar" + "Importe Ret. IVA a liquidar");
                //-#34822
            end;
        }
        field(55006; "Importe Ret. IVA a liquidar"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
            Description = '#34822';

            trigger OnValidate()
            begin
                //+#34822
                TestField("ID Retencion Venta");
                Validate("Amount to Apply", "Importe Ret. Renta a liquidar" + "Importe Ret. IVA a liquidar");
                //-#34822
            end;
        }
        field(55007; "Tipo Retención"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '#34822';
            OptionCaption = ' ,Renta,IVA';
            OptionMembers = " ",Renta,IVA;
        }
        field(55008; "No. Comprobante Liq. retencion"; Code[19])
        {
            DataClassification = ToBeClassified;
            Description = '#43533';
        }
        field(56000; "Collector Code"; Code[10])
        {
            Caption = 'Collector code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = FILTER(Cobrador));
        }
        field(56005; "Nombre Cliente"; Text[200])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Description = 'Ecuador,#56924';
            FieldClass = FlowField;
        }
        field(56026; "Importe provisionado"; Decimal)
        {
            CalcFormula = - Sum("G/L Entry".Amount WHERE("No. Mov. cliente provisionado" = FIELD("Entry No."),
                                                         "Document Date" = FIELD("Date Filter")));
            Description = '#144';
            Editable = false;
            FieldClass = FlowField;
        }
        field(56027; "Fecha ult. provision"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '#144';
            Editable = false;
        }
        field(56028; "Provisionado por insolvencia"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#144';
            Editable = false;
        }
        field(56030; "No. Comprobante Fiscal Rel."; Code[19])
        {
            DataClassification = ToBeClassified;
            Description = '#30531';
        }
        field(56100; "Sales by Dimension"; Decimal)
        {
            CalcFormula = Sum("Sales Invoice Line"."Line Amount" WHERE("Document No." = FIELD("Document No."),
                                                                        "Bill-to Customer No." = FIELD("Customer No."),
                                                                        "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                        "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter")));
            Description = 'Ecuador (Claudiu)';
            FieldClass = FlowField;
        }
        field(56101; "Global Dimension 1 Filter"; Code[20])
        {
            Description = 'Ecuador (Claudiu)';
            FieldClass = FlowFilter;
        }
        field(56102; "Global Dimension 2 Filter"; Code[20])
        {
            Description = 'Ecuador (Claudiu)';
            FieldClass = FlowFilter;
        }
        field(76014; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            DataClassification = ToBeClassified;
            TableRelation = Contact WHERE(Type = FILTER(Company));
        }
        field(76041; "No. Comprobante Fiscal"; Code[30])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76079; "No. Comprobante Fiscal DPP"; Code[19])
        {
            Caption = 'Fiscal Document No. DPP';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.04';
        }
        field(76058; "Fecha vencimiento NCF DPP"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.04';
        }
    }

    keys
    {
        key(KeyReports; "Provisionado por insolvencia")
        {
        }
    }

    procedure ImporteaAprovisionar(parFecha: Date; var parPorcentaje: Decimal): Decimal
    var
        rProv: Record "% Provisión";
        FechaVenc: Date;
    begin

        //+#144
        parPorcentaje := 0;
        FechaVenc := "Due Date";
        if FechaVenc = 0D then
            FechaVenc := "Posting Date";
        CalcFields("Remaining Amt. (LCY)");
        rProv.SetRange("Desde día", 0, parFecha - FechaVenc);
        if rProv.FindLast then begin
            parPorcentaje := rProv."% Provisión";
            exit(Round("Remaining Amt. (LCY)" * rProv."% Provisión" / 100));
        end;
        exit(0);
    end;

}

