tableextension 50057 tableextension50057 extends "Item Ledger Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".

        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Cost Amount (Actual) (ACY)")
        {
            Caption = 'Cost Amount (Actual) (ACY)';
        }
        modify("Shipped Qty. Not Returned")
        {
            Caption = 'Shipped Qty. Not Returned';
        }
        modify("Prod. Order Comp. Line No.")
        {
            Caption = 'Prod. Order Comp. Line No.';
        }
        field(50000; "Cod. Procedencia"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Procedencia;
        }
        field(50001; "Cod. Edición"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Edicion; //Table50131 Validar Tabla
        }
        field(50002; Areas; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Area; //Table50132; Validar Tabla
        }
        field(50003; "No. Paginas"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; ISBN; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Componentes Prod."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Componentes Prod.";
        }
        field(50006; "Nivel Educativo"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Nivel Educativo"; //Table50133;Validar Tabla
        }
        field(50007; Cursos; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Cursos;
        }
        field(50008; "Precio Unitario Cons. Inicial"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Descuento % Cons. Inicial"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Importe Cons. bruto Inicial"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Antes de descuento';
        }
        field(50011; "Importe Cons. Neto Inicial"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Despues de descuento';
        }
        field(50012; "Cant. Consignacion Pendiente"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "No. Mov. Prod. Cosg. a Liq."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Pedido Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Devolucion Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Descripcion Producto"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50017; "Precio Unitario Cons. Act."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Descuento % Cons. Actualizado"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Importe Cons. bruto Act."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Importe Cons. Neto Act."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Ult. Fecha Act. Imp. Consig."; Date)
        {
            Caption = 'Consig. Amount Last update';
            DataClassification = ToBeClassified;
        }
        field(56020; "No aplica Derechos de Autor"; Boolean)
        {
            Caption = 'Apply Author Copyright';
            DataClassification = ToBeClassified;
        }
        field(56021; Promocion; Boolean)
        {
            Caption = 'Promotion';
            DataClassification = ToBeClassified;
        }
        field(76014; "Cod. Colegio"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            Editable = false;
            TableRelation = Contact;
        }
        field(76422; "Cod. Vendedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Salesperson/Purchaser";
        }
    }
    keys
    {
        key(CustomKey24; "Location Code", Open)
        {
            //SumIndexFields = "Importe Cons. Neto Inicial", "Importe Cons. Neto Act.";
        }
        key(Key25; "Pedido Consignacion")
        {
        }
        key(Key26; "Posting Date", "Location Code")
        {
            //SumIndexFields = "Importe Cons. bruto Inicial", "Importe Cons. Neto Inicial";
        }
        key(Key27; "Source No.")
        {
        }
        key(KeyReports; "Expiration Date", "Item Category Code")
        {
        }
    }

    //Unsupported feature: Variable Insertion (Variable: ValueEntry) (VariableCollection) on "CalculateRemInventoryValue(PROCEDURE 12)".


    //Unsupported feature: Variable Insertion (Variable: AdjustedCost) (VariableCollection) on "CalculateRemInventoryValue(PROCEDURE 12)".


    //Unsupported feature: Variable Insertion (Variable: TotalQty) (VariableCollection) on "CalculateRemInventoryValue(PROCEDURE 12)".



    //Unsupported feature: Code Modification on "CalculateRemInventoryValue(PROCEDURE 12)".

    //procedure CalculateRemInventoryValue();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    exit(
      CalculateRemainingInventoryValue(ItemLedgEntryNo,ItemLedgEntryQty,RemQty,IncludeExpectedCost,PostingDate,0D));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ValueEntry.SetCurrentKey("Item Ledger Entry No.");
    ValueEntry.SetRange("Item Ledger Entry No.",ItemLedgEntryNo);
    ValueEntry.SetFilter("Valuation Date",'<=%1',PostingDate);
    if not IncludeExpectedCost then
      ValueEntry.SetRange("Expected Cost",false);
    if ValueEntry.FindSet then
      repeat
        if ValueEntry."Entry Type" = ValueEntry."Entry Type"::Revaluation then
          TotalQty := ValueEntry."Valued Quantity"
        else
          TotalQty := ItemLedgEntryQty;
        if ValueEntry."Entry Type" <> ValueEntry."Entry Type"::Rounding then
          if IncludeExpectedCost then
            AdjustedCost += RemQty / TotalQty * (ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)")
          else
            AdjustedCost += RemQty / TotalQty * ValueEntry."Cost Amount (Actual)";
      until ValueEntry.Next = 0;
    exit(AdjustedCost);
    */
    //end;
}

