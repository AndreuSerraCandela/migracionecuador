table 90000 "G/L Account2"
{
    Caption = 'G/L Account';
    DataCaptionFields = "No.", Name;
    DrillDownPageID = "Chart of Accounts";
    LookupPageID = "G/L Account List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            SQLDataType = Variant;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(3; "Search Name"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";

            trigger OnValidate()
            var
                GLEntry: Record "G/L Entry";
                GLBudgetEntry: Record "G/L Budget Entry";
            begin
            end;
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(9; "Income/Balance"; Option)
        {
            Caption = 'Income/Balance';
            OptionCaption = 'Income Statement,Balance Sheet';
            OptionMembers = "Income Statement","Balance Sheet";
        }
        field(10; "Debit/Credit"; Option)
        {
            Caption = 'Debit/Credit';
            OptionCaption = 'Both,Debit,Credit';
            OptionMembers = Both,Debit,Credit;
        }
        field(11; "No. 2"; Code[20])
        {
            Caption = 'No. 2';
        }
        field(12; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST("G/L Account"),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(14; "Direct Posting"; Boolean)
        {
            Caption = 'Direct Posting';
            InitValue = true;
        }
        field(16; "Reconciliation Account"; Boolean)
        {
            Caption = 'Reconciliation Account';
        }
        field(17; "New Page"; Boolean)
        {
            Caption = 'New Page';
        }
        field(18; "No. of Blank Lines"; Integer)
        {
            Caption = 'No. of Blank Lines';
            MinValue = 0;
        }
        field(19; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(26; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(28; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(29; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(31; "Balance at Date"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            Caption = 'Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Budgeted Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                               "G/L Account No." = FIELD(FILTER(Totaling)),
                                                               "Business Unit Code" = FIELD("Business Unit Filter"),
                                                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                               Date = FIELD("Date Filter"),
                                                               "Budget Name" = FIELD("Budget Filter")));
            Caption = 'Budgeted Amount';
            FieldClass = FlowField;
        }
        field(34; Totaling; Text[250])
        {
            Caption = 'Totaling';
            TableRelation = "G/L Account";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(35; "Budget Filter"; Code[10])
        {
            Caption = 'Budget Filter';
            FieldClass = FlowFilter;
            TableRelation = "G/L Budget Name";
        }
        field(36; Balance; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "Budget at Date"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                               "G/L Account No." = FIELD(FILTER(Totaling)),
                                                               "Business Unit Code" = FIELD("Business Unit Filter"),
                                                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                               Date = FIELD(UPPERLIMIT("Date Filter")),
                                                               "Budget Name" = FIELD("Budget Filter")));
            Caption = 'Budget at Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Consol. Translation Method"; Option)
        {
            Caption = 'Consol. Translation Method';
            OptionCaption = 'Average Rate (Manual),Closing Rate,Historical Rate,Composite Rate,Equity Rate';
            OptionMembers = "Average Rate (Manual)","Closing Rate","Historical Rate","Composite Rate","Equity Rate";

            trigger OnValidate()
            var
                ConflictGLAcc: Record "G/L Account";
            begin
            end;
        }
        field(40; "Consol. Debit Acc."; Code[20])
        {
            Caption = 'Consol. Debit Acc.';

            trigger OnValidate()
            var
                ConflictGLAcc: Record "G/L Account";
            begin
            end;
        }
        field(41; "Consol. Credit Acc."; Code[20])
        {
            Caption = 'Consol. Credit Acc.';

            trigger OnValidate()
            var
                ConflictGLAcc: Record "G/L Account";
            begin
            end;
        }
        field(42; "Business Unit Filter"; Code[10])
        {
            Caption = 'Business Unit Filter';
            FieldClass = FlowFilter;
            TableRelation = "Business Unit";
        }
        field(43; "Gen. Posting Type"; Option)
        {
            Caption = 'Gen. Posting Type';
            OptionCaption = ' ,Purchase,Sale';
            OptionMembers = " ",Purchase,Sale;
        }
        field(44; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            var
                GenBusPostingGrp: Record "Gen. Business Posting Group";
            begin
            end;
        }
        field(45; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            var
                GenProdPostingGrp: Record "Gen. Product Posting Group";
            begin
            end;
        }
        field(46; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(47; "Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("G/L Entry"."Debit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                "Posting Date" = FIELD("Date Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(48; "Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("G/L Entry"."Credit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                 "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                 "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(49; "Automatic Ext. Texts"; Boolean)
        {
            Caption = 'Automatic Ext. Text';
        }
        field(52; "Budgeted Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankNumbers = BlankNegAndZero;
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                               "G/L Account No." = FIELD(FILTER(Totaling)),
                                                               "Business Unit Code" = FIELD("Business Unit Filter"),
                                                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                               Date = FIELD("Date Filter"),
                                                               "Budget Name" = FIELD("Budget Filter")));
            Caption = 'Budgeted Debit Amount';
            FieldClass = FlowField;
        }
        field(53; "Budgeted Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankNumbers = BlankNegAndZero;
            CalcFormula = - Sum("G/L Budget Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                                "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                Date = FIELD("Date Filter"),
                                                                "Budget Name" = FIELD("Budget Filter")));
            Caption = 'Budgeted Credit Amount';
            FieldClass = FlowField;
        }
        field(54; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(55; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(56; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(57; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Tax Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(58; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Tax Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(60; "Additional-Currency Net Change"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Posting Date" = FIELD("Date Filter")));
            Caption = 'Additional-Currency Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Add.-Currency Balance at Date"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            Caption = 'Add.-Currency Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Additional-Currency Balance"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter")));
            Caption = 'Additional-Currency Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Exchange Rate Adjustment"; Option)
        {
            Caption = 'Exchange Rate Adjustment';
            OptionCaption = 'No Adjustment,Adjust Amount,Adjust Additional-Currency Amount';
            OptionMembers = "No Adjustment","Adjust Amount","Adjust Additional-Currency Amount";
        }
        field(64; "Add.-Currency Debit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Add.-Currency Debit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Posting Date" = FIELD("Date Filter")));
            Caption = 'Add.-Currency Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Add.-Currency Credit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Add.-Currency Credit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                               "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                               "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                               "Posting Date" = FIELD("Date Filter")));
            Caption = 'Add.-Currency Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "Default IC Partner G/L Acc. No"; Code[20])
        {
            Caption = 'Default IC Partner G/L Acc. No';
            TableRelation = "IC G/L Account"."No.";
        }
        // field(10001; "GIFI Code"; Code[10])
        // {
        //     Caption = 'GIFI Code';
        //     TableRelation = "GIFI Code";
        // }
        field(76041; "NCF Obligatorio"; Boolean)
        {
            Caption = 'NCF Requested';
        }
        field(76058; "Cod. Clasificacion Gasto"; Code[2])
        {
            Caption = 'Expense Clasification Code';
            TableRelation = "Clasificacion Gastos";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; "Reconciliation Account")
        {
        }
        key(Key4; "Gen. Bus. Posting Group")
        {
        }
        key(Key5; "Gen. Prod. Posting Group")
        {
        }
        key(Key6; "Consol. Debit Acc.", "Consol. Translation Method")
        {
            Enabled = false;
        }
        key(Key7; "Consol. Credit Acc.", "Consol. Translation Method")
        {
            Enabled = false;
        }
        key(Key8; Name)
        {
        }
        // key(Key9; "GIFI Code")
        // {
        // }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, "Income/Balance", Blocked, "Direct Posting")
        {
        }
    }

    trigger OnDelete()
    var
        GLBudgetEntry: Record "G/L Budget Entry";
        CommentLine: Record "Comment Line";
        ExtTextHeader: Record "Extended Text Header";
        AnalysisViewEntry: Record "Analysis View Entry";
        AnalysisViewBudgetEntry: Record "Analysis View Budget Entry";
        MoveEntries: Codeunit MoveEntries;
    begin
    end;

    var
        Text000: Label 'You cannot change %1 because there are one or more ledger entries associated with this account.';
        Text001: Label 'You cannot change %1 because this account is part of one or more budgets.';
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        GLSetupRead: Boolean;
        Text002: Label 'There is another %1: %2; which refers to the same %3, but with a different %4: %5.';


    procedure GetCurrencyCode(): Code[10]
    begin
        if not GLSetupRead then begin
            GLSetup.Get;
            GLSetupRead := true;
        end;
        exit(GLSetup."Additional Reporting Currency");
    end;
}

