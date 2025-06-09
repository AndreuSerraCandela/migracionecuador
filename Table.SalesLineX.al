table 76441 "Sales Line X"
{

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Pre Order';
            //OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Pre Order";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            DataClassification = ToBeClassified;
            Description = '#34448';
            Editable = false;
            TableRelation = Customer WHERE(Inactivo = CONST(false));
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";

            trigger OnValidate()
            var
                TempSalesLine: Record "Sales Line" temporary;
            begin
            end;
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            Description = '#34448, 018';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account"),
                                     "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                                               "Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account"),
                                                                                                        "System-Created Entry" = CONST(true)) "G/L Account"
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" WHERE(Inactive = CONST(false))
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Item),
                                                                                                                 "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item WHERE(Blocked = CONST(false),
                                                                                                                                                                                       "Sales Blocked" = CONST(false),
                                                                                                                                                                                       Inactivo = CONST(false))
            ELSE
            IF (Type = CONST(Item),
                                                                                                                                                                                                "Document Type" = FILTER("Credit Memo" | "Return Order")) Item WHERE(Blocked = CONST(false),
                                                                                                                                                                                                                                                                  Inactivo = CONST(false));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                TempSalesLine: Record "Sales Line" temporary;
                IsHandled: Boolean;
                AdopcionesDetalle: Record "Colegio - Adopciones Detalle";
                ColNivel: Record "Colegio - Nivel";
                PromotorRuta: Record "Promotor - Rutas";
            begin
            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            Description = '#34448';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            Inactivo = CONST(false));

            trigger OnValidate()
            var
                Item: Record Item;
                IsHandled: Boolean;
            begin
            end;
        }
        field(8; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF (Type = CONST(Item)) "Inventory Posting Group"
            ELSE
            IF (Type = CONST("Fixed Asset")) "FA Posting Group";
        }
        field(10; "Shipment Date"; Date)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Shipment Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
            begin
            end;
        }
        field(11; Description; Text[160])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST("G/L Account"),
                                "System-Created Entry" = CONST(false)) "G/L Account".Name WHERE("Direct Posting" = CONST(true),
                                                                                               "Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account"),
                                                                                                        "System-Created Entry" = CONST(true)) "G/L Account".Name
            ELSE
            IF (Type = CONST(Item),
                                                                                                                 "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item.Description WHERE(Blocked = CONST(false),
                                                                                                                                                                                                   "Sales Blocked" = CONST(false))
            ELSE
            IF (Type = CONST(Item),
                                                                                                                                                                                                            "Document Type" = FILTER("Credit Memo" | "Return Order")) Item.Description WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST(Resource)) Resource.Name
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset".Description
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge".Description;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Item: Record Item;
                ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
                FindRecordMgt: Codeunit "Find Record Management";
                ReturnValue: Text[50];
                DescriptionIsNo: Boolean;
                DefaultCreate: Boolean;
                IsHandled: Boolean;
            begin
            end;
        }
        field(12; "Description 2"; Text[60])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(13; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = FILTER(<> " ")) "Unit of Measure".Description;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                Item: Record Item;
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
            end;
        }
        field(16; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(17; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(18; "Qty. to Ship"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Qty. to Ship';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
                IsHandled: Boolean;
            begin
            end;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost ($)';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
            end;
        }
        field(25; "VAT %"; Decimal)
        {
            Caption = 'Tax %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
            DataClassification = ToBeClassified;
        }
        field(29; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including Tax';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(34; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(35; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(36; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(37; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(38; "Appl.-to Item Entry"; Integer)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Appl.-to Item Entry';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
                ItemTrackingLines: Page "Item Tracking Lines";
            begin
            end;
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }
        field(42; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Customer Price Group";
        }
        field(45; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Job;
        }
        field(52; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Work Type";

            trigger OnValidate()
            var
                WorkType: Record "Work Type";
            begin
            end;
        }
        field(56; "Recalculate Invoice Disc."; Boolean)
        {
            Caption = 'Recalculate Invoice Disc.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(57; "Outstanding Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Outstanding Amount';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
            end;
        }
        field(58; "Qty. Shipped Not Invoiced"; Decimal)
        {
            Caption = 'Qty. Shipped Not Invoiced';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(59; "Shipped Not Invoiced"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Shipped Not Invoiced';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
            end;
        }
        field(60; "Quantity Shipped"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Quantity Shipped';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(61; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(63; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(64; "Shipment Line No."; Integer)
        {
            Caption = 'Shipment Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(67; "Profit %"; Decimal)
        {
            Caption = 'Profit %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = ToBeClassified;
            Description = '#34448';
            Editable = false;
            TableRelation = Customer WHERE(Inactivo = CONST(false));
        }
        field(69; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(71; "Purchase Order No."; Code[20])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Purchase Order No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF ("Drop Shipment" = CONST(true)) "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(72; "Purch. Order Line No."; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Purch. Order Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF ("Drop Shipment" = CONST(true)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                                                               "Document No." = FIELD("Purchase Order No."));
        }
        field(73; "Drop Shipment"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(77; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge Tax,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(78; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            DataClassification = ToBeClassified;
            TableRelation = "Transaction Type";
        }
        field(79; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            DataClassification = ToBeClassified;
            TableRelation = "Transport Method";
        }
        field(80; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("Document No."));
        }
        field(81; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            DataClassification = ToBeClassified;
            TableRelation = "Entry/Exit Point";
        }
        field(82; "Area"; Code[10])
        {
            Caption = 'Area';
            DataClassification = ToBeClassified;
            TableRelation = Area;
        }
        field(83; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            DataClassification = ToBeClassified;
            TableRelation = "Transaction Specification";
        }
        field(84; "Tax Category"; Code[10])
        {
            Caption = 'Tax Category';
            DataClassification = ToBeClassified;
        }
        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Area";

            trigger OnValidate()
            var
                TaxArea: Record "Tax Area";
                HeaderTaxArea: Record "Tax Area";
            begin
            end;
        }
        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(87; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Group";
        }
        field(88; "VAT Clause Code"; Code[20])
        {
            Caption = 'Tax Clause Code';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Clause";
        }
        field(89; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";
        }
        field(90; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
            end;
        }
        field(91; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Currency;
        }
        field(92; "Outstanding Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Outstanding Amount ($)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(93; "Shipped Not Invoiced (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Shipped Not Invoiced ($) Incl. Tax';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(94; "Shipped Not Inv. (LCY) No VAT"; Decimal)
        {
            Caption = 'Shipped Not Invoiced ($)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(95; "Reserved Quantity"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = - Sum("Reservation Entry".Quantity WHERE("Source ID" = FIELD("Document No."),
                                                                   "Source Ref. No." = FIELD("Line No."),
                                                                   "Source Type" = CONST(37),
                                                                   "Source Subtype" = FIELD("Document Type"),
                                                                   "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(96; Reserve; Option)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Reserve';
            DataClassification = ToBeClassified;
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
            end;
        }
        field(97; "Blanket Order No."; Code[20])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Blanket Order No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST("Blanket Order"));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(98; "Blanket Order Line No."; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Blanket Order Line No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = CONST("Blanket Order"),
                                                           "Document No." = FIELD("Blanket Order No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(99; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Tax Base Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(100; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(101; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MaxLineAmount: Decimal;
            begin
            end;
        }
        field(104; "VAT Difference"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Tax Difference';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(105; "Inv. Disc. Amount to Invoice"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(106; "VAT Identifier"; Code[20])
        {
            Caption = 'Tax Identifier';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(107; "IC Partner Ref. Type"; Option)
        {
            AccessByPermission = TableData "IC G/L Account" = R;
            Caption = 'IC Partner Ref. Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.';
            OptionMembers = " ","G/L Account",Item,,,"Charge (Item)","Cross Reference","Common Item No.";

            trigger OnValidate()
            var
                Item: Record Item;
            begin
            end;
        }
        field(108; "IC Partner Reference"; Code[20])
        {
            AccessByPermission = TableData "IC G/L Account" = R;
            Caption = 'IC Partner Reference';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                ICGLAccount: Record "IC G/L Account";
                Item: Record Item;
                ItemCrossReference: Record "Item Reference";
            begin
            end;
        }
        field(109; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(110; "Prepmt. Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Prepmt. Line Amount';
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(111; "Prepmt. Amt. Inv."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Inv.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(112; "Prepmt. Amt. Incl. VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Incl. Tax';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(113; "Prepayment Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(114; "Prepmt. VAT Base Amt."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Tax Base Amt.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(115; "Prepayment VAT %"; Decimal)
        {
            Caption = 'Prepayment Tax %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(116; "Prepmt. VAT Calc. Type"; Option)
        {
            Caption = 'Prepmt. Tax Calc. Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge Tax,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(117; "Prepayment VAT Identifier"; Code[20])
        {
            Caption = 'Prepayment Tax Identifier';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(118; "Prepayment Tax Area Code"; Code[20])
        {
            Caption = 'Prepayment Tax Area Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Area";
        }
        field(119; "Prepayment Tax Liable"; Boolean)
        {
            Caption = 'Prepayment Tax Liable';
            DataClassification = ToBeClassified;
        }
        field(120; "Prepayment Tax Group Code"; Code[20])
        {
            Caption = 'Prepayment Tax Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Group";
        }
        field(121; "Prepmt Amt to Deduct"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Amt to Deduct';
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(122; "Prepmt Amt Deducted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Amt Deducted';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(123; "Prepayment Line"; Boolean)
        {
            Caption = 'Prepayment Line';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(124; "Prepmt. Amount Inv. Incl. VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. Incl. Tax';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(129; "Prepmt. Amount Inv. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. ($)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(130; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            DataClassification = ToBeClassified;
            TableRelation = "IC Partner";
        }
        field(132; "Prepmt. VAT Amount Inv. (LCY)"; Decimal)
        {
            Caption = 'Prepmt. Tax Amount Inv. ($)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(135; "Prepayment VAT Difference"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Tax Difference';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(136; "Prepmt VAT Diff. to Deduct"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Tax Diff. to Deduct';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(137; "Prepmt VAT Diff. Deducted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Tax Diff. Deducted';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(145; "Pmt. Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Pmt. Discount Amount';
            DataClassification = ToBeClassified;
        }
        field(180; "Line Discount Calculation"; Option)
        {
            Caption = 'Line Discount Calculation';
            DataClassification = ToBeClassified;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(900; "Qty. to Assemble to Order"; Decimal)
        {
            AccessByPermission = TableData "BOM Component" = R;
            Caption = 'Qty. to Assemble to Order';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                SalesLineReserve: Codeunit "Sales Line-Reserve";
            begin
            end;
        }
        field(901; "Qty. to Asm. to Order (Base)"; Decimal)
        {
            Caption = 'Qty. to Asm. to Order (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(902; "ATO Whse. Outstanding Qty."; Decimal)
        {
            AccessByPermission = TableData "BOM Component" = R;
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding" WHERE("Source Type" = CONST(37),
                                                                                  "Source Subtype" = FIELD("Document Type"),
                                                                                  "Source No." = FIELD("Document No."),
                                                                                  "Source Line No." = FIELD("Line No."),
                                                                                  "Assemble to Order" = FILTER(true)));
            Caption = 'ATO Whse. Outstanding Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(903; "ATO Whse. Outstd. Qty. (Base)"; Decimal)
        {
            AccessByPermission = TableData "BOM Component" = R;
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE("Source Type" = CONST(37),
                                                                                         "Source Subtype" = FIELD("Document Type"),
                                                                                         "Source No." = FIELD("Document No."),
                                                                                         "Source Line No." = FIELD("Line No."),
                                                                                         "Assemble to Order" = FILTER(true)));
            Caption = 'ATO Whse. Outstd. Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1001; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(1002; "Job Contract Entry No."; Integer)
        {
            AccessByPermission = TableData Job = R;
            Caption = 'Job Contract Entry No.';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
            end;
        }
        field(1300; "Posting Date"; Date)
        {
            CalcFormula = Lookup("Sales Header"."Posting Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                      "No." = FIELD("Document No.")));
            Caption = 'Posting Date';
            FieldClass = FlowField;
        }
        field(1700; "Deferral Code"; Code[10])
        {
            Caption = 'Deferral Code';
            DataClassification = ToBeClassified;
            TableRelation = "Deferral Template"."Deferral Code";

            trigger OnValidate()
            var
                DeferralPostDate: Date;
            begin
            end;
        }
        field(1702; "Returns Deferral Start Date"; Date)
        {
            Caption = 'Returns Deferral Start Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                DeferralHeader: Record "Deferral Header";
            begin
            end;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Document Type" = FILTER(Order | Invoice),
                                Quantity = FILTER(>= 0),
                                "Qty. to Asm. to Order (Base)" = CONST(0)) "Bin Content"."Bin Code" WHERE("Location Code" = FIELD("Location Code"),
                                                                                                         "Item No." = FIELD("No."),
                                                                                                         "Variant Code" = FIELD("Variant Code"))
            ELSE
            IF ("Document Type" = FILTER("Return Order" | "Credit Memo"),
                                                                                                                  Quantity = FILTER(< 0)) "Bin Content"."Bin Code" WHERE("Location Code" = FIELD("Location Code"),
                                                                                                                                                                       "Item No." = FIELD("No."),
                                                                                                                                                                       "Variant Code" = FIELD("Variant Code"))
            ELSE
            Bin.Code WHERE("Location Code" = FIELD("Location Code"));

            trigger OnLookup()
            var
                WMSManagement: Codeunit "WMS Management";
                BinCode: Code[20];
            begin
            end;

            trigger OnValidate()
            var
                WMSManagement: Codeunit "WMS Management";
            begin
            end;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5405; Planned; Boolean)
        {
            Caption = 'Planned';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Item),
                                "No." = FILTER(<> '')) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            IF (Type = CONST(Resource),
                                         "No." = FILTER(<> '')) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."))
            ELSE
            "Unit of Measure";

            trigger OnValidate()
            var
                Item: Record Item;
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
                GLSetup: Record "General Ledger Setup";
                IdentityManagement: Codeunit "Identity Management";
            begin
            end;
        }
        field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(5416; "Outstanding Qty. (Base)"; Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5417; "Qty. to Invoice (Base)"; Decimal)
        {
            Caption = 'Qty. to Invoice (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5418; "Qty. to Ship (Base)"; Decimal)
        {
            Caption = 'Qty. to Ship (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(5458; "Qty. Shipped Not Invd. (Base)"; Decimal)
        {
            Caption = 'Qty. Shipped Not Invd. (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5460; "Qty. Shipped (Base)"; Decimal)
        {
            Caption = 'Qty. Shipped (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5461; "Qty. Invoiced (Base)"; Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5495; "Reserved Qty. (Base)"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = - Sum("Reservation Entry"."Quantity (Base)" WHERE("Source ID" = FIELD("Document No."),
                                                                            "Source Ref. No." = FIELD("Line No."),
                                                                            "Source Type" = CONST(37),
                                                                            "Source Subtype" = FIELD("Document Type"),
                                                                            "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5600; "FA Posting Date"; Date)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'FA Posting Date';
            DataClassification = ToBeClassified;
        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            DataClassification = ToBeClassified;
            TableRelation = "Depreciation Book";
        }
        field(5605; "Depr. until FA Posting Date"; Boolean)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'Depr. until FA Posting Date';
            DataClassification = ToBeClassified;
        }
        field(5612; "Duplicate in Depreciation Book"; Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            DataClassification = ToBeClassified;
            TableRelation = "Depreciation Book";
        }
        field(5613; "Use Duplication List"; Boolean)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'Use Duplication List';
            DataClassification = ToBeClassified;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(5701; "Out-of-Stock Substitution"; Boolean)
        {
            Caption = 'Out-of-Stock Substitution';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5702; "Substitution Available"; Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE(Type = CONST(Item),
                                                           "No." = FIELD("No."),
                                                           "Substitute Type" = CONST(Item)));
            Caption = 'Substitution Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5703; "Originally Ordered No."; Code[20])
        {
            AccessByPermission = TableData "Item Substitution" = R;
            Caption = 'Originally Ordered No.';
            DataClassification = ToBeClassified;
            Description = '#34448';
            TableRelation = IF (Type = CONST(Item)) Item WHERE(Inactivo = CONST(false));
        }
        field(5704; "Originally Ordered Var. Code"; Code[10])
        {
            AccessByPermission = TableData "Item Substitution" = R;
            Caption = 'Originally Ordered Var. Code';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("Originally Ordered No."));
        }
        field(5705; "Cross-Reference No."; Code[20])
        {
            AccessByPermission = TableData "Item Reference" = R;
            Caption = 'Cross-Reference No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ItemCrossReference: Record "Item Reference";
            begin
            end;
        }
        field(5706; "Unit of Measure (Cross Ref.)"; Code[10])
        {
            AccessByPermission = TableData "Item Reference" = R;
            Caption = 'Unit of Measure (Cross Ref.)';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(5707; "Cross-Reference Type"; Option)
        {
            Caption = 'Cross-Reference Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Customer,Vendor,Bar Code';
            OptionMembers = " ",Customer,Vendor,"Bar Code";
        }
        field(5708; "Cross-Reference Type No."; Code[30])
        {
            Caption = 'Cross-Reference Type No.';
            DataClassification = ToBeClassified;
        }
        field(5709; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(5710; Nonstock; Boolean)
        {
            AccessByPermission = TableData "Nonstock Item" = R;
            Caption = 'Catalog';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5711; "Purchasing Code"; Code[10])
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Purchasing Code';
            DataClassification = ToBeClassified;
            TableRelation = Purchasing;

            trigger OnValidate()
            var
                PurchasingCode: Record Purchasing;
                ShippingAgentServices: Record "Shipping Agent Services";
            begin
            end;
        }
        field(5712; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            DataClassification = ToBeClassified;
            ObsoleteReason = 'Product Groups became first level children of Item Categories.';
            ObsoleteState = Removed;
            /*   TableRelation = "Product Group".Code WHERE ("Item Category Code" = FIELD ("Item Category Code")); */
            /*          ValidateTableRelation = false; */
        }
        field(5713; "Special Order"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Special Order';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5714; "Special Order Purchase No."; Code[20])
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Special Order Purchase No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Special Order" = CONST(true)) "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(5715; "Special Order Purch. Line No."; Integer)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Special Order Purch. Line No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Special Order" = CONST(true)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                                                               "Document No." = FIELD("Special Order Purchase No."));
        }
        field(5749; "Whse. Outstanding Qty."; Decimal)
        {
            AccessByPermission = TableData Location = R;
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding" WHERE("Source Type" = CONST(37),
                                                                                  "Source Subtype" = FIELD("Document Type"),
                                                                                  "Source No." = FIELD("Document No."),
                                                                                  "Source Line No." = FIELD("Line No.")));
            Caption = 'Whse. Outstanding Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5750; "Whse. Outstanding Qty. (Base)"; Decimal)
        {
            AccessByPermission = TableData Location = R;
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE("Source Type" = CONST(37),
                                                                                         "Source Subtype" = FIELD("Document Type"),
                                                                                         "Source No." = FIELD("Document No."),
                                                                                         "Source Line No." = FIELD("Line No.")));
            Caption = 'Whse. Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752; "Completely Shipped"; Boolean)
        {
            Caption = 'Completely Shipped';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            AccessByPermission = TableData "Order Promising Line" = R;
            Caption = 'Promised Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            AccessByPermission = TableData "Order Promising Line" = R;
            Caption = 'Shipping Time';
            DataClassification = ToBeClassified;
        }
        field(5793; "Outbound Whse. Handling Time"; DateFormula)
        {
            AccessByPermission = TableData Location = R;
            Caption = 'Outbound Whse. Handling Time';
            DataClassification = ToBeClassified;
        }
        field(5794; "Planned Delivery Date"; Date)
        {
            AccessByPermission = TableData "Order Promising Line" = R;
            Caption = 'Planned Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(5795; "Planned Shipment Date"; Date)
        {
            AccessByPermission = TableData "Order Promising Line" = R;
            Caption = 'Planned Shipment Date';
            DataClassification = ToBeClassified;
        }
        field(5796; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Agent";
        }
        field(5797; "Shipping Agent Service Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Service Code';
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));

            trigger OnValidate()
            var
                ShippingAgentServices: Record "Shipping Agent Services";
            begin
            end;
        }
        field(5800; "Allow Item Charge Assignment"; Boolean)
        {
            AccessByPermission = TableData "Item Charge" = R;
            Caption = 'Allow Item Charge Assignment';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(5801; "Qty. to Assign"; Decimal)
        {
            CalcFormula = Sum("Item Charge Assignment (Sales)"."Qty. to Assign" WHERE("Document Type" = FIELD("Document Type"),
                                                                                       "Document No." = FIELD("Document No."),
                                                                                       "Document Line No." = FIELD("Line No.")));
            Caption = 'Qty. to Assign';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5802; "Qty. Assigned"; Decimal)
        {
            CalcFormula = Sum("Item Charge Assignment (Sales)"."Qty. Assigned" WHERE("Document Type" = FIELD("Document Type"),
                                                                                      "Document No." = FIELD("Document No."),
                                                                                      "Document Line No." = FIELD("Line No.")));
            Caption = 'Qty. Assigned';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5803; "Return Qty. to Receive"; Decimal)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            Caption = 'Return Qty. to Receive';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
                IsHandled: Boolean;
            begin
            end;
        }
        field(5804; "Return Qty. to Receive (Base)"; Decimal)
        {
            Caption = 'Return Qty. to Receive (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(5805; "Return Qty. Rcd. Not Invd."; Decimal)
        {
            Caption = 'Return Qty. Rcd. Not Invd.';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5806; "Ret. Qty. Rcd. Not Invd.(Base)"; Decimal)
        {
            Caption = 'Ret. Qty. Rcd. Not Invd.(Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5807; "Return Rcd. Not Invd."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Return Rcd. Not Invd.';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
            end;
        }
        field(5808; "Return Rcd. Not Invd. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Return Rcd. Not Invd. ($)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5809; "Return Qty. Received"; Decimal)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            Caption = 'Return Qty. Received';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5810; "Return Qty. Received (Base)"; Decimal)
        {
            Caption = 'Return Qty. Received (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5811; "Appl.-from Item Entry"; Integer)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Appl.-from Item Entry';
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
            end;
        }
        field(5909; "BOM Item No."; Code[20])
        {
            Caption = 'BOM Item No.';
            DataClassification = ToBeClassified;
            Description = '#34448';
            TableRelation = Item WHERE(Inactivo = CONST(false));
        }
        field(6600; "Return Receipt No."; Code[20])
        {
            Caption = 'Return Receipt No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6601; "Return Receipt Line No."; Integer)
        {
            Caption = 'Return Receipt Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6608; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "Return Reason";
        }
        field(6610; "Copied From Posted Doc."; Boolean)
        {
            Caption = 'Copied From Posted Doc.';
            DataClassification = ToBeClassified;
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(7002; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            DataClassification = ToBeClassified;
            TableRelation = "Customer Discount Group";
        }
        field(7003; Subtype; Option)
        {
            Caption = 'Subtype';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Item - Inventory,Item - Service,Comment';
            OptionMembers = " ","Item - Inventory","Item - Service",Comment;
        }
        field(7004; "Price description"; Text[80])
        {
            Caption = 'Price description';
            DataClassification = ToBeClassified;
        }
        field(7010; "Attached Doc Count"; Integer)
        {
            BlankNumbers = DontBlank;
            CalcFormula = Count("Document Attachment" WHERE("Table ID" = CONST(37),
                                                             "No." = FIELD("Document No."),
                                                             "Document Type" = FIELD("Document Type"),
                                                             "Line No." = FIELD("Line No.")));
            Caption = 'Attached Doc Count';
            FieldClass = FlowField;
            InitValue = 0;
        }
        field(10000; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';
            DataClassification = ToBeClassified;
        }
        field(50000; "Cod. Procedencia"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Procedencia;
        }
        field(50001; "Cod. Edicion"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = Table50131;
        }
        field(50002; Areas; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = Table50132;
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
            TableRelation = "Nivel Educativo APS";
        }
        field(50007; Cursos; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Cursos;
        }
        field(50008; "Cantidad Inv. en Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Cantidad Consignacion Devuelta"; Decimal)
        {
            DataClassification = ToBeClassified;
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
        field(50013; "No. Estante"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
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
        field(50047; "Clas Dev"; Boolean)
        {
            Caption = 'Clas Dev';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-936 ClasDev';
        }
        field(55012; "Parte del IVA"; Boolean)
        {
            Caption = 'VAT part';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(56001; "Disponible BackOrder"; Boolean)
        {
            Caption = 'Available';
            DataClassification = ToBeClassified;
            Description = 'Gestion BackOrder';
        }
        field(56002; "Cod. Oferta"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(76046; "Anulada en TPV"; Boolean)
        {
            Caption = 'POS Void';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76029; "Precio anulacion TPV"; Decimal)
        {
            Caption = 'Void POS Price';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76011; "Cantidad anulacion TPV"; Decimal)
        {
            Caption = 'Void POS Qty.';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76016; "Cantidad agregada"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76018; "Cod. Vendedor"; Code[10])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
            TableRelation = Vendedores.Codigo;
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
        field(76022; "Devuelve a Documento"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76027; "Devuelve a Linea Documento"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76017; "Registrado TPV"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard,#305288';
        }
        field(76021; "Posting No."; Code[20])
        {
            CalcFormula = Lookup("Sales Header"."Posting No." WHERE("Document Type" = FIELD("Document Type"),
                                                                     "No." = FIELD("Document No.")));
            Description = 'DsPOS Standard,#355717';
            FieldClass = FlowField;
        }
        field(76030; "Cantidad devuelta TPV"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard,#355717';
        }
        field(76295; "Cantidad dev. TPV (calc)"; Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type" = FILTER("Credit Memo"),
                                                           "Devuelve a Documento" = FIELD("Posting No."),
                                                           "Devuelve a Linea Documento" = FIELD("Line No."),
                                                           "Registrado TPV" = FILTER(true)));
            Description = 'DsPOS Standard,#355717';
            FieldClass = FlowField;
        }
        field(76227; "% Dto por forma de pago"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard,#373762';
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

            trigger OnValidate()
            var
                ColAdop: Record "Colegio - Log - Adopciones";
            begin
            end;
        }
        field(76422; Presupuesto; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

