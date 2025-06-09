table 50006 Vendor2
{
    // Proyecto: Implementacion Microsoft Dynamics Nav
    // AMS     : Agustin Mendez
    // GRN     : Guillermo Roman
    // -----------------------------------------------------------------------------------------
    // No.     Fecha                Firma         Descripcion
    // -----------------------------------------------------------------------------------------
    // 001     17-Sept.-12          AMS           Al insertar un proveedor se crearan bloqueadas
    // 002     25-Enero-12          AMS           Para desbloquear un proveedor que no sea ocasional
    //                                            debe tener al menos un banco asociado.
    // 003     28-Enero-13          AMS           Ecuador - Se controla que la retencion pertenezca al mismo
    //                                            tipo de contribuyente que el proveedor.
    // 004     28-Enero-13          AMS           Se controla la estructura del RUC.
    // 005     05-Feb-13            AMS           Ecuador - Se controla el Tipo Documento y
    //                                            Tipo Ruc/Cedula de acuerdo al Tipo de Contribuyente
    // 
    // #14564  24/03/2015           FAA           Se añade campo 55006.
    // 
    // #16454  09/04/2015           FAA           Se modifican controles.
    // 
    // #22846  11/06/2015           CAT           Control duplicidad RUC/RNC/NIT
    // 
    // #30654  09/09/2015           FAA           Se modifica un contro existente.
    // #7314   09/10/2015      MOI       Se añade el campo Inactivo.
    //                                   En el caso de que se dispongan de los permisos necesarios no se podrá Activar/Desactivar el Vendedor.
    // 
    // 001 #36266 RRT, 28.06.17: Revisión de la gestión del campo INACTIVO.

    Caption = 'Vendor';
    DataCaptionFields = "No.", Name;
    DrillDownPageID = "Vendor List";
    LookupPageID = "Vendor List";
    Permissions = TableData "Vendor Ledger Entry" = r;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    PurchSetup.Get;
                    NoSeriesMgt.TestManual(PurchSetup."Vendor Nos.");
                    "No. Series" := '';
                end;
                if "Invoice Disc. Code" = '' then
                    "Invoice Disc. Code" := "No.";
            end;
        }
        field(2; Name; Text[70])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3; "Search Name"; Code[70])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[80])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[80])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[60])
        {
            Caption = 'City';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(8; Contact; Text[50])
        {
            Caption = 'Contact';

            trigger OnValidate()
            begin
                if RMSetup.Get then
                    if RMSetup."Bus. Rel. Code for Vendors" <> '' then
                        if (xRec.Contact = '') and (xRec."Primary Contact No." = '') then begin
                            Modify;
                            //UpdateContFromVend.OnModify(Rec);
                            //UpdateContFromVend.InsertNewContactPerson(Rec,FALSE);
                            Modify(true);
                        end
            end;
        }
        field(9; "Phone No."; Text[90])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Telex No."; Text[90])
        {
            Caption = 'Telex No.';
        }
        field(14; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
        }
        field(15; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(19; "Budgeted Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Budgeted Amount';
        }
        field(21; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";
        }
        field(22; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(24; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(26; "Statistics Group"; Integer)
        {
            Caption = 'Statistics Group';
        }
        field(27; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(28; "Fin. Charge Terms Code"; Code[10])
        {
            Caption = 'Fin. Charge Terms Code';
            TableRelation = "Finance Charge Terms";
        }
        field(29; "Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(30; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(31; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(33; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(38; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Vendor),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; Blocked; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Payment,All';
            OptionMembers = " ",Payment,All;

            trigger OnValidate()
            begin
                //001
                if UserSetUp.Get(UserId) then begin
                    if not UserSetUp."Desbloquea Proveedores" then
                        Error(Error001);
                    if Blocked = Blocked::" " then begin
                        ValidaCampos.Maestros(23, "No.");
                        ValidaCampos.Dimensiones(23, "No.", 0, 0);
                    end;

                    if not "Proveedor Ocasional" then begin
                        VBA.Reset;
                        VBA.SetRange("Vendor No.", "No.");
                        if not VBA.FindFirst then
                            Error(Error002);
                    end;
                end
                else
                    Error(Error001);
                //001
            end;
        }
        field(45; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(46; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(47; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(55; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(56; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(57; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(58; Balance; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Net Change"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Net Change ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Purchases (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Vendor Ledger Entry"."Purchase (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                             "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Purchases ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Inv. Discounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Vendor Ledger Entry"."Inv. Discount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Inv. Discounts ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Pmt. Discounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Entry Type" = FILTER("Payment Discount" .. "Payment Discount (VAT Adjustment)"),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Pmt. Discounts ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "Balance Due"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("No."),
                                                                           "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                           "Initial Entry Due Date" = FIELD("Date Filter"),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance Due';
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "Balance Due (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                   "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                                   "Initial Entry Due Date" = FIELD("Date Filter"),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance Due ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; Payments; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Payment),
                                                                          "Entry Type" = CONST("Initial Entry"),
                                                                          "Vendor No." = FIELD("No."),
                                                                          "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                          "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Payments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Invoice Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Invoice),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Invoice Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Cr. Memo Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST("Credit Memo"),
                                                                          "Entry Type" = CONST("Initial Entry"),
                                                                          "Vendor No." = FIELD("No."),
                                                                          "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                          "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Cr. Memo Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(72; "Finance Charge Memo Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST("Finance Charge Memo"),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Finance Charge Memo Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(74; "Payments (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Payment),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Payments ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75; "Inv. Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Invoice),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Inv. Amounts ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "Cr. Memo Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST("Credit Memo"),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Cr. Memo Amounts ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(77; "Fin. Charge Memo Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST("Finance Charge Memo"),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Fin. Charge Memo Amounts ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "Outstanding Orders"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount" WHERE("Document Type" = CONST(Order),
                                                                          "Pay-to Vendor No." = FIELD("No."),
                                                                          "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                          "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79; "Amt. Rcd. Not Invoiced"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Amt. Rcd. Not Invoiced" WHERE("Document Type" = CONST(Order),
                                                                              "Pay-to Vendor No." = FIELD("No."),
                                                                              "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Amt. Rcd. Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Application Method"; Option)
        {
            Caption = 'Application Method';
            OptionCaption = 'Manual,Apply to Oldest';
            OptionMembers = Manual,"Apply to Oldest";
        }
        field(82; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                PurchPrice: Record "Price List Line";
                Item: Record Item;
                VATPostingSetup: Record "VAT Posting Setup";
                Currency: Record Currency;
            begin
                PurchPrice.SetCurrentKey("Assign-to No.");
                PurchPrice.SetRange("Source Type", PurchPrice."Source Type"::Vendor);
                PurchPrice.SetRange("Assign-to No.", "No.");
                if PurchPrice.Find('-') then begin
                    if VATPostingSetup.Get('', '') then;
                    if Confirm(
                         StrSubstNo(
                           Text002,
                           FieldCaption("Prices Including VAT"), "Prices Including VAT", PurchPrice.TableCaption), true)
                    then
                        repeat
                            if PurchPrice."Product No." <> Item."No." then
                                Item.Get(PurchPrice."Product No.");
                            if ("VAT Bus. Posting Group" <> VATPostingSetup."VAT Bus. Posting Group") or
                               (Item."VAT Prod. Posting Group" <> VATPostingSetup."VAT Prod. Posting Group")
                            then
                                VATPostingSetup.Get("VAT Bus. Posting Group", Item."VAT Prod. Posting Group");
                            if PurchPrice."Currency Code" = '' then
                                Currency.InitRoundingPrecision
                            else
                                if PurchPrice."Currency Code" <> Currency.Code then
                                    Currency.Get(PurchPrice."Currency Code");
                            if VATPostingSetup."VAT %" <> 0 then begin
                                if "Prices Including VAT" then
                                    PurchPrice."Direct Unit Cost" :=
                                      Round(
                                        PurchPrice."Direct Unit Cost" * (1 + VATPostingSetup."VAT %" / 100),
                                        Currency."Unit-Amount Rounding Precision")
                                else
                                    PurchPrice."Direct Unit Cost" :=
                                      Round(
                                        PurchPrice."Direct Unit Cost" / (1 + VATPostingSetup."VAT %" / 100),
                                        Currency."Unit-Amount Rounding Precision");
                                PurchPrice.Modify;
                            end;
                        until PurchPrice.Next = 0;
                end;
            end;
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(85; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(86; "VAT Registration No."; Text[30])
        {
            Caption = 'Tax Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
                rVendor: Record Vendor;
                Err001: Label 'El valor ingresado ya existe en el proveedor %1.';
            begin

                //+#22846
                if "VAT Registration No." <> '' then begin
                    rVendor.SetRange("VAT Registration No.", "VAT Registration No.");
                    rVendor.SetFilter("No.", '<>%1', "No.");
                    if rVendor.FindSet then
                        Error(StrSubstNo(Err001, rVendor."No."));
                end;
                //-#22846

                if "Tipo Ruc/Cedula" = "Tipo Ruc/Cedula"::PASAPORTE then
                    exit;

                //VATRegNoFormat.Test_Santillana("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor);  //#16454
                //VATRegNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor);

                if "Tipo Ruc/Cedula" <> "Tipo Ruc/Cedula"::"R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA" then
                    VATRegNoFormat.Test_Santillana("VAT Registration No.", "Country/Region Code", "No.", DATABASE::Vendor);  //#16454
            end;
        }
        field(88; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(89; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(92; County; Text[30])
        {
            Caption = 'State';
        }
        field(97; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Debit Amount" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Entry Type" = FILTER(<> Application),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Credit Amount" WHERE("Vendor No." = FIELD("No."),
                                                                                   "Entry Type" = FILTER(<> Application),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                        "Entry Type" = FILTER(<> Application),
                                                                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                        "Posting Date" = FIELD("Date Filter"),
                                                                                        "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Debit Amount ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                         "Entry Type" = FILTER(<> Application),
                                                                                         "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                         "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                         "Posting Date" = FIELD("Date Filter"),
                                                                                         "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Credit Amount ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(104; "Reminder Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Reminder),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Reminder Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Reminder Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Reminder),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Reminder Amounts ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(109; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(110; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Tax Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(111; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(113; "Outstanding Orders (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Order),
                                                                                "Pay-to Vendor No." = FIELD("No."),
                                                                                "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Orders ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(114; "Amt. Rcd. Not Invoiced (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" WHERE("Document Type" = CONST(Order),
                                                                                    "Pay-to Vendor No." = FIELD("No."),
                                                                                    "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                    "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                    "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Amt. Rcd. Not Invoiced ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(116; "Block Payment Tolerance"; Boolean)
        {
            Caption = 'Block Payment Tolerance';
        }
        field(117; "Pmt. Disc. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Entry Type" = FILTER("Payment Discount Tolerance" | "Payment Discount Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)"),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Pmt. Disc. Tolerance ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(118; "Pmt. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Entry Type" = FILTER("Payment Tolerance" | "Payment Tolerance (VAT Adjustment)" | "Payment Tolerance (VAT Excl.)"),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Pmt. Tolerance ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(119; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";

            trigger OnValidate()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
                AccountingPeriod: Record "Accounting Period";
                ICPartner: Record "IC Partner";
            begin
                if xRec."IC Partner Code" <> "IC Partner Code" then begin
                    VendLedgEntry.SetCurrentKey("Vendor No.", "Posting Date");
                    VendLedgEntry.SetRange("Vendor No.", "No.");
                    AccountingPeriod.SetRange(Closed, false);
                    if AccountingPeriod.FindFirst then
                        VendLedgEntry.SetFilter("Posting Date", '>=%1', AccountingPeriod."Starting Date");
                    if VendLedgEntry.FindFirst then
                        if not Confirm(Text009, false, TableCaption) then
                            "IC Partner Code" := xRec."IC Partner Code";

                    VendLedgEntry.Reset;
                    if not VendLedgEntry.SetCurrentKey("Vendor No.", Open) then
                        VendLedgEntry.SetCurrentKey("Vendor No.");
                    VendLedgEntry.SetRange("Vendor No.", "No.");
                    VendLedgEntry.SetRange(Open, true);
                    if VendLedgEntry.FindLast then
                        Error(Text010, FieldCaption("IC Partner Code"), TableCaption);
                end;

                if "IC Partner Code" <> '' then begin
                    ICPartner.Get("IC Partner Code");
                    if (ICPartner."Vendor No." <> '') and (ICPartner."Vendor No." <> "No.") then
                        Error(Text008, FieldCaption("IC Partner Code"), "IC Partner Code", TableCaption, ICPartner."Vendor No.");
                    ICPartner."Vendor No." := "No.";
                    ICPartner.Modify;
                end;

                if (xRec."IC Partner Code" <> "IC Partner Code") and ICPartner.Get(xRec."IC Partner Code") then begin
                    ICPartner."Vendor No." := '';
                    ICPartner.Modify;
                end;
            end;
        }
        field(120; Refunds; Decimal)
        {
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Refund),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Refunds';
            FieldClass = FlowField;
        }
        field(121; "Refunds (LCY)"; Decimal)
        {
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Refund),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Refunds ($)';
            FieldClass = FlowField;
        }
        field(122; "Other Amounts"; Decimal)
        {
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(" "),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Other Amounts';
            FieldClass = FlowField;
        }
        field(123; "Other Amounts (LCY)"; Decimal)
        {
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(" "),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Other Amounts ($)';
            FieldClass = FlowField;
        }
        field(124; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(125; "Outstanding Invoices"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount" WHERE("Document Type" = CONST(Invoice),
                                                                          "Pay-to Vendor No." = FIELD("No."),
                                                                          "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                          "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(126; "Outstanding Invoices (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Invoice),
                                                                                "Pay-to Vendor No." = FIELD("No."),
                                                                                "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Invoices ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130; "Pay-to No. Of Archived Doc."; Integer)
        {
            CalcFormula = Count("Purchase Header Archive" WHERE("Document Type" = CONST(Order),
                                                                 "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. Of Archived Doc.';
            FieldClass = FlowField;
        }
        field(131; "Buy-from No. Of Archived Doc."; Integer)
        {
            CalcFormula = Count("Purchase Header Archive" WHERE("Document Type" = CONST(Order),
                                                                 "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'Buy-from No. Of Archived Doc.';
            FieldClass = FlowField;
        }
        field(132; "Partner Type"; Option)
        {
            Caption = 'Partner Type';
            OptionCaption = ' ,Company,Person';
            OptionMembers = " ",Company,Person;
        }
        field(170; "Creditor No."; Code[20])
        {
            Caption = 'Creditor No.';
            Numeric = true;
        }
        field(288; "Preferred Bank Account"; Code[10])
        {
            Caption = 'Preferred Bank Account';
            TableRelation = "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("No."));
        }
        field(840; "Cash Flow Payment Terms Code"; Code[10])
        {
            Caption = 'Cash Flow Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(5049; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
                ContBusRel.SetCurrentKey("Link to Table", "No.");
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
                ContBusRel.SetRange("No.", "No.");
                if ContBusRel.FindFirst then
                    Cont.SetRange("Company No.", ContBusRel."Contact No.")
                else
                    Cont.SetRange("No.", '');

                if "Primary Contact No." <> '' then
                    if Cont.Get("Primary Contact No.") then;
                if PAGE.RunModal(0, Cont) = ACTION::LookupOK then
                    Validate("Primary Contact No.", Cont."No.");
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
                Contact := '';
                if "Primary Contact No." <> '' then begin
                    Cont.Get("Primary Contact No.");

                    ContBusRel.SetCurrentKey("Link to Table", "No.");
                    ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
                    ContBusRel.SetRange("No.", "No.");
                    ContBusRel.FindFirst;

                    if Cont."Company No." <> ContBusRel."Contact No." then
                        Error(Text004, Cont."No.", Cont.Name, "No.", Name);

                    if Cont.Type = Cont.Type::Person then
                        Contact := Cont.Name
                end;
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5701; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(5790; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(7177; "No. of Pstd. Receipts"; Integer)
        {
            CalcFormula = Count("Purch. Rcpt. Header" WHERE("Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7178; "No. of Pstd. Invoices"; Integer)
        {
            CalcFormula = Count("Purch. Inv. Header" WHERE("Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7179; "No. of Pstd. Return Shipments"; Integer)
        {
            CalcFormula = Count("Return Shipment Header" WHERE("Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Return Shipments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7180; "No. of Pstd. Credit Memos"; Integer)
        {
            CalcFormula = Count("Purch. Cr. Memo Hdr." WHERE("Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7181; "Pay-to No. of Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Order),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7182; "Pay-to No. of Invoices"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Invoice),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7183; "Pay-to No. of Return Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Return Order"),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7184; "Pay-to No. of Credit Memos"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7185; "Pay-to No. of Pstd. Receipts"; Integer)
        {
            CalcFormula = Count("Purch. Rcpt. Header" WHERE("Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Pstd. Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7186; "Pay-to No. of Pstd. Invoices"; Integer)
        {
            CalcFormula = Count("Purch. Inv. Header" WHERE("Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7187; "Pay-to No. of Pstd. Return S."; Integer)
        {
            CalcFormula = Count("Return Shipment Header" WHERE("Pay-to Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Return S.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7188; "Pay-to No. of Pstd. Cr. Memos"; Integer)
        {
            CalcFormula = Count("Purch. Cr. Memo Hdr." WHERE("Pay-to Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Cr. Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7189; "No. of Quotes"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Quote),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7190; "No. of Blanket Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Blanket Order"),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Blanket Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7191; "No. of Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Order),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Orders';
            FieldClass = FlowField;
        }
        field(7192; "No. of Invoices"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Invoice),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7193; "No. of Return Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Return Order"),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7194; "No. of Credit Memos"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7195; "No. of Order Addresses"; Integer)
        {
            CalcFormula = Count("Order Address" WHERE("Vendor No." = FIELD("No.")));
            Caption = 'No. of Order Addresses';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7196; "Pay-to No. of Quotes"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Quote),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7197; "Pay-to No. of Blanket Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Blanket Order"),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Blanket Orders';
            FieldClass = FlowField;
        }
        field(7600; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
        }
        field(10004; "UPS Zone"; Code[2])
        {
            Caption = 'UPS Zone';
        }
        field(10016; "Federal ID No."; Text[30])
        {
            Caption = 'Federal ID No.';
        }
        field(10017; "Bank Communication"; Option)
        {
            Caption = 'Bank Communication';
            OptionCaption = 'E English,F French,S Spanish';
            OptionMembers = "E English","F French","S Spanish";
        }
        field(10018; "Check Date Format"; Option)
        {
            Caption = 'Check Date Format';
            OptionCaption = ' ,MM DD YYYY,DD MM YYYY,YYYY MM DD';
            OptionMembers = " ","MM DD YYYY","DD MM YYYY","YYYY MM DD";
        }
        field(10019; "Check Date Separator"; Option)
        {
            Caption = 'Check Date Separator';
            OptionCaption = ' ,-,.,/';
            OptionMembers = " ","-",".","/";
        }
        field(10020; "IRS 1099 Code"; Code[10])
        {
            Caption = 'IRS 1099 Code';
            //TableRelation = "IRS 1099 Form-Box";
        }
        field(10021; "Balance on Date"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("No."),
                                                                           "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance on Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10022; "Balance on Date (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                   "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance on Date ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10023; "RFC No."; Code[13])
        {
            Caption = 'RFC No.';

            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                case "Tax Identification Type" of
                    "Tax Identification Type"::"Legal Entity":
                        ValidateRFCNo(12);
                    "Tax Identification Type"::"Natural Person":
                        ValidateRFCNo(13);
                end;
                Vendor.Reset;
                //Vendor.SetRange("RFC No.", "RFC No.");
                //Vendor.SetFilter("No.", '<>%1', "No.");
                //if Vendor.FindFirst then
                //    Message(Text10002, "RFC No.");
            end;
        }
        field(10024; "CURP No."; Code[18])
        {
            Caption = 'CURP No.';

            trigger OnValidate()
            begin
                if StrLen("CURP No.") <> 18 then
                    Error(Text10001, "CURP No.");
            end;
        }
        field(10025; "State Inscription"; Text[30])
        {
            Caption = 'State Inscription';
        }
        field(14020; "Tax Identification Type"; Option)
        {
            Caption = 'Tax Identification Type';
            OptionCaption = 'Legal Entity,Natural Person';
            OptionMembers = "Legal Entity","Natural Person";
        }
        field(55000; "Proveedor Ocasional"; Boolean)
        {
            Caption = 'Occasional supplier';
        }
        field(55001; "Tipo Contribuyente"; Code[20])
        {
            Caption = 'Contributor Type';
            Description = 'Ecuador';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = CONST("TIPOS AGENTE DE RETENCION"));

            trigger OnValidate()
            begin

                if Confirm(txt001, false) then begin
                    //003
                    ProvRet.Reset;
                    ProvRet.SetRange(ProvRet."Cód. Proveedor", "No.");
                    ProvRet.SetFilter("Tipo Contribuyente", '<>%1', "Tipo Contribuyente");
                    if ProvRet.FindFirst then
                        Error(Error003, ProvRet.TableCaption);
                    //003


                    //005
                    SRIParam.Reset;
                    SRIParam.SetRange("Tipo Registro", SRIParam."Tipo Registro"::"TIPOS AGENTE DE RETENCION");
                    SRIParam.SetRange(SRIParam.Code, "Tipo Contribuyente");
                    if SRIParam.FindFirst then begin
                        Validate("Tipo Documento", SRIParam."Tipo Documento");
                        Validate("Tipo Ruc/Cedula", SRIParam."Tipo Ruc/Cedula");
                    end;
                    //005
                end
                else
                    "Tipo Contribuyente" := xRec."Tipo Contribuyente";
            end;
        }
        field(55002; "Tipo Ruc/Cedula"; Option)
        {
            Caption = 'RUC/ID Type';
            Description = 'Ecuador';
            OptionCaption = ' ,R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA,R.U.C. PUBLICOS,RUC PERSONA NATURAL,ID';
            OptionMembers = " ","R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA,PASAPORTE;
        }
        field(55003; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            Description = 'Ecuador';
            OptionCaption = 'VAT,ID,Passport';
            OptionMembers = RUC,Cedula,Pasaporte;

            trigger OnValidate()
            begin
                Validate("VAT Registration No.", '');
            end;
        }
        field(55004; "Desc. Tipo Contribuyente"; Text[170])
        {
            CalcFormula = Lookup("SRI - Tabla Parametros".Description WHERE("Tipo Registro" = FILTER("TIPOS AGENTE DE RETENCION"),
                                                                             Code = FIELD("Tipo Contribuyente")));
            Caption = 'Contributor Type Descr.';
            Description = 'Ecuador';
            FieldClass = FlowField;
        }
        field(55005; "Desc. Tipo Ruc/Cedula"; Text[150])
        {
            Caption = 'RUC Type';
            Description = 'Ecuador';
        }
        field(55006; "Parte Relacionada"; Boolean)
        {
            Caption = 'Parte Relacionada';
            Description = '#14564 Ecuador';
        }
        field(55007; "Excluir Informe ATS"; Boolean)
        {
            Description = '#14564 Ecuador';
        }
        field(55008; "Tipo Contrib. Extranjero"; Option)
        {
            OptionCaption = ' ,Persona Natural,Sociedad';
            OptionMembers = " ","Persona Natural",Sociedad;
        }
        field(56000; Inactivo; Boolean)
        {
            Caption = 'Inactivo';
            Description = '#7314';

            trigger OnValidate()
            var
                lErrorPermiso: Label 'No dispone de los permisos necesario para Activar/Desactivar el Vendedor';
                lErrorSaldo: Label 'No es posible Inactivar el vendedor, puesto que su saldo es diferente de 0.';
                UserSetup: Record "User Setup";
            begin
                //#7314:Inicio
                if not (UserSetup.Get(UserId) and UserSetup."Activa/Inactiva Maestros") then
                    Error(lErrorPermiso);

                //Verificar que el saldo es 0
                CalcFields("Balance (LCY)");
                if "Balance (LCY)" <> 0 then
                    Error(lErrorSaldo);
                //#7314:Fin
            end;
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
        key(Key3; "Vendor Posting Group")
        {
        }
        key(Key4; "Currency Code")
        {
        }
        key(Key5; Priority)
        {
        }
        key(Key6; "Country/Region Code")
        {
        }
        key(Key7; "Gen. Bus. Posting Group")
        {
        }
        key(Key8; "VAT Registration No.")
        {
        }
        key(Key9; Name)
        {
        }
        key(Key10; City)
        {
        }
        key(Key11; "Post Code")
        {
        }
        key(Key12; "Phone No.")
        {
        }
        key(Key13; Contact)
        {
        }
        key(Key14; "Purchaser Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, "VAT Registration No.", City, "Post Code", "Phone No.", Contact)
        {
        }
    }

    trigger OnDelete()
    var
        ItemVendor: Record "Item Vendor";
        PurchPrice: Record "Price List Line";
        PurchLineDiscount: Record "Price List Line";
        PurchPrepmtPct: Record "Purchase Prepayment %";
    begin
        //MoveEntries.MoveVendorEntries(Rec);

        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Vendor);
        CommentLine.SetRange("No.", "No.");
        CommentLine.DeleteAll;

        VendBankAcc.SetRange("Vendor No.", "No.");
        VendBankAcc.DeleteAll;

        OrderAddr.SetRange("Vendor No.", "No.");
        OrderAddr.DeleteAll;

        ItemCrossReference.SetCurrentKey("Reference Type", "Reference Type No.");
        ItemCrossReference.SetRange("Reference Type", ItemCrossReference."Reference Type"::Vendor);
        ItemCrossReference.SetRange("Reference Type No.", "No.");
        ItemCrossReference.DeleteAll;

        PurchOrderLine.SetCurrentKey("Document Type", "Pay-to Vendor No.");
        PurchOrderLine.SetFilter(
          "Document Type", '%1|%2',
          PurchOrderLine."Document Type"::Order,
          PurchOrderLine."Document Type"::"Return Order");
        PurchOrderLine.SetRange("Pay-to Vendor No.", "No.");
        if PurchOrderLine.FindFirst then
            Error(
              Text000,
              TableCaption, "No.",
              PurchOrderLine."Document Type");

        PurchOrderLine.SetRange("Pay-to Vendor No.");
        PurchOrderLine.SetRange("Buy-from Vendor No.", "No.");
        if PurchOrderLine.FindFirst then
            Error(
              Text000,
              TableCaption, "No.");

        //UpdateContFromVend.OnDelete(Rec);

        DimMgt.DeleteDefaultDim(DATABASE::Vendor, "No.");

        ServiceItem.SetRange("Vendor No.", "No.");
        ServiceItem.ModifyAll("Vendor No.", '');

        ItemVendor.SetRange("Vendor No.", "No.");
        ItemVendor.DeleteAll(true);

        PurchPrice.SetCurrentKey("Assign-to No.");
        PurchPrice.SetRange("Source Type", PurchPrice."Source Type"::Vendor);
        PurchPrice.SetRange("Assign-to No.", "No.");
        PurchPrice.DeleteAll(true);

        PurchLineDiscount.SetCurrentKey("Assign-to No.");
        PurchLineDiscount.SetRange("Amount Type", PurchLineDiscount."Amount Type"::Discount);
        PurchLineDiscount.SetRange("Source Type", PurchLineDiscount."Source Type"::Vendor);
        PurchLineDiscount.SetRange("Assign-to No.", "No.");
        PurchLineDiscount.DeleteAll(true);

        PurchPrepmtPct.SetCurrentKey("Vendor No.");
        PurchPrepmtPct.SetRange("Vendor No.", "No.");
        PurchPrepmtPct.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            PurchSetup.Get;
            PurchSetup.TestField("Vendor Nos.");
            //NoSeriesMgt.InitSeries(PurchSetup."Vendor Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            Rec."No. series" := PurchSetup."Vendor Nos.";
            if NoSeriesMgt.AreRelated(PurchSetup."Vendor Nos.", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Series");
        end;
        if "Invoice Disc. Code" = '' then
            "Invoice Disc. Code" := "No.";

        if not InsertFromContact then
            //UpdateContFromVend.OnInsert(Rec);

            DimMgt.UpdateDefaultDim(
          DATABASE::Vendor, "No.",
          "Global Dimension 1 Code", "Global Dimension 2 Code");

        //001
        ConfSant.Get;
        if ConfSant."Proveedor Bloqueado al crear" then
            Blocked := Blocked::All;
        //001

        //ATS
        ValidaTipoContribExt;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;

        //ATS
        ValidaTipoContribExt;

        if (Name <> xRec.Name) or
           ("Search Name" <> xRec."Search Name") or
           ("Name 2" <> xRec."Name 2") or
           (Address <> xRec.Address) or
           ("Address 2" <> xRec."Address 2") or
           (City <> xRec.City) or
           ("Phone No." <> xRec."Phone No.") or
           ("Telex No." <> xRec."Telex No.") or
           ("Territory Code" <> xRec."Territory Code") or
           ("Currency Code" <> xRec."Currency Code") or
           ("Language Code" <> xRec."Language Code") or
           ("Purchaser Code" <> xRec."Purchaser Code") or
           ("Country/Region Code" <> xRec."Country/Region Code") or
           ("Fax No." <> xRec."Fax No.") or
           ("Telex Answer Back" <> xRec."Telex Answer Back") or
           ("VAT Registration No." <> xRec."VAT Registration No.") or
           ("Post Code" <> xRec."Post Code") or
           (County <> xRec.County) or
           ("E-Mail" <> xRec."E-Mail") or
           ("Home Page" <> xRec."Home Page")
        then begin
            Modify;
            //UpdateContFromVend.OnModify(Rec);
            Find;
        end;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Purchase %3 for this vendor.';
        Text002: Label 'You have set %1 to %2. Do you want to update the %3 price list accordingly?';
        Text003: Label 'Do you wish to create a contact for %1 %2?';
        PurchSetup: Record "Purchases & Payables Setup";
        CommentLine: Record "Comment Line";
        PurchOrderLine: Record "Purchase Line";
        PostCode: Record "Post Code";
        VendBankAcc: Record "Vendor Bank Account";
        OrderAddr: Record "Order Address";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        ItemCrossReference: Record "Item Reference";
        RMSetup: Record "Marketing Setup";
        ServiceItem: Record "Service Item";
        NoSeriesMgt: Codeunit "No. Series";
        MoveEntries: Codeunit MoveEntries;
        UpdateContFromVend: Codeunit "VendCont-Update";
        DimMgt: Codeunit DimensionManagement;
        InsertFromContact: Boolean;
        Text004: Label 'Contact %1 %2 is not related to vendor %3 %4.';
        Text005: Label 'post';
        Text006: Label 'create';
        Text007: Label 'You cannot %1 this type of document when Vendor %2 is blocked with type %3';
        Text008: Label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3.';
        Text009: Label 'Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
        Text010: Label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
        Text011: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text10000: Label '%1 is not a valid RFC No.';
        Text10001: Label '%1 is not a valid CURP No.';
        Text10002: Label 'The RFC No. %1 is used by another company.';
        ConfSant: Record "Config. Empresa";
        UserSetUp: Record "User Setup";
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        Error001: Label 'User cannot unlock Vendors';
        VBA: Record "Vendor Bank Account";
        Error002: Label 'Occasional Vendor must have at least one Bank created';
        ProvRet: Record "Proveedor - Retencion";
        Error003: Label 'Records in the table %1 must be deleted for this Vendor before change the Retention Type';
        SRIParam: Record "SRI - Tabla Parametros";
        txt001: Label 'If modify Contributor Type it will delete Vat Reg. No., Confirm that you want to proceed';


    procedure AssistEdit(OldVend: Record Vendor2): Boolean
    var
        Vend: Record Vendor2;
    begin
        Vend := Rec;
        PurchSetup.Get;
        PurchSetup.TestField("Vendor Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(PurchSetup."Vendor Nos.", OldVend."No. Series", "No. Series") then begin
            PurchSetup.Get;
            PurchSetup.TestField("Vendor Nos.");
            NoSeriesMgt.GetNextNo(Vend."No.");
            Rec := Vend;
            exit(true);
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Vendor, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Vendor, "No.", FieldNumber, ShortcutDimCode);
    end;


    procedure ShowContact()
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
    begin
        if "No." = '' then
            exit;

        ContBusRel.SetCurrentKey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
        ContBusRel.SetRange("No.", "No.");
        if not ContBusRel.FindFirst then begin
            if not Confirm(Text003, false, TableCaption, "No.") then
                exit;
            //UpdateContFromVend.InsertNewContact(Rec,FALSE);
            ContBusRel.FindFirst;
        end;
        Commit;

        Cont.SetCurrentKey("Company Name", "Company No.", Type, Name);
        Cont.SetRange("Company No.", ContBusRel."Contact No.");
        PAGE.Run(PAGE::"Contact List", Cont);
    end;


    procedure SetInsertFromContact(FromContact: Boolean)
    begin
        InsertFromContact := FromContact;
    end;


    procedure CheckBlockedVendOnDocs(Vend2: Record Vendor; Transaction: Boolean)
    begin
        if Vend2.Blocked = Vend2.Blocked::All then
            VendBlockedErrorMessage(Vend2, Transaction);
    end;


    procedure CheckBlockedVendOnJnls(Vend2: Record Vendor; DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; Transaction: Boolean)
    begin
        if (Vend2.Blocked = Vend2.Blocked::All) or
           (Vend2.Blocked = Vend2.Blocked::Payment) and (DocType = DocType::Payment)
        then
            VendBlockedErrorMessage(Vend2, Transaction);
    end;


    procedure CreateAndShowNewInvoice()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        PurchaseHeader.SetRange("Buy-from Vendor No.", "No.");
        PurchaseHeader.Insert(true);
        Commit;
        //PAGE.RUNMODAL(PAGE::"Mini Purchase Invoice",PurchaseHeader)
    end;


    procedure CreateAndShowNewCreditMemo()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
        PurchaseHeader.SetRange("Buy-from Vendor No.", "No.");
        PurchaseHeader.Insert(true);
        Commit;
        //PAGE.RUNMODAL(PAGE::"Mini Purchase Credit Memo",PurchaseHeader)
    end;


    procedure VendBlockedErrorMessage(Vend2: Record Vendor; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        if Transaction then
            Action := Text005
        else
            Action := Text006;
        Error(Text007, Action, Vend2."No.", Vend2.Blocked);
    end;


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.FindFirst then
            MapMgt.MakeSelection(DATABASE::Vendor, GetPosition)
        else
            Message(Text011);
    end;


    procedure GetDefaultBankAcc(var VendorBankAccount: Record "Vendor Bank Account")
    begin
        if "Preferred Bank Account" <> '' then
            VendorBankAccount.Get("No.", "Preferred Bank Account")
        else begin
            VendorBankAccount.SetRange("Vendor No.", "No.");
            if not VendorBankAccount.FindFirst then
                Clear(VendorBankAccount);
        end;
    end;


    procedure CalcOverDueBalance() OverDueBalance: Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        VendLedgEntryRemainAmtQuery: Query "Vend. Ledg. Entry Remain. Amt.";
    begin
        VendLedgEntryRemainAmtQuery.SetRange(Vendor_No, "No.");
        VendLedgEntryRemainAmtQuery.SetRange(IsOpen, true);
        VendLedgEntryRemainAmtQuery.SetFilter(Due_Date, '<%1', WorkDate);
        VendLedgEntryRemainAmtQuery.Open;

        if VendLedgEntryRemainAmtQuery.Read then
            OverDueBalance := VendLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    end;


    procedure ValidateRFCNo(Length: Integer)
    begin
        if StrLen("RFC No.") <> Length then
            Error(Text10000, "RFC No.");
    end;


    procedure GetInvoicedPrepmtAmountLCY(): Decimal
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetCurrentKey("Document Type", "Pay-to Vendor No.");
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Pay-to Vendor No.", "No.");
        PurchLine.CalcSums("Prepmt. Amount Inv. (LCY)", "Prepmt. VAT Amount Inv. (LCY)");
        exit(PurchLine."Prepmt. Amount Inv. (LCY)" + PurchLine."Prepmt. VAT Amount Inv. (LCY)");
    end;


    procedure GetTotalAmountLCY(): Decimal
    begin
        CalcFields(
          "Balance (LCY)", "Outstanding Orders (LCY)", "Amt. Rcd. Not Invoiced (LCY)", "Outstanding Invoices (LCY)");

        exit(
          "Balance (LCY)" + "Outstanding Orders (LCY)" +
          "Amt. Rcd. Not Invoiced (LCY)" + "Outstanding Invoices (LCY)" - GetInvoicedPrepmtAmountLCY);
    end;


    procedure ValidaTipoContribExt()
    var
        Text001: Label 'En los contribuyentes extranjeros es obligatorio ingresar un valor en el campo Tipo de Contrib. extranjero.';
    begin
        //ATS
        //IF (("Tipo Contribuyente" = 'EX') OR ("Tipo Contribuyente" = 'EX RUC')) AND ("Tipo Contrib. Extranjero" = "Tipo Contrib. Extranjero"::" ")THEN
        //  ERROR(Text001);

        //#30564
        if ("Tipo Contribuyente" = 'EX') and ("Tipo Contrib. Extranjero" = "Tipo Contrib. Extranjero"::" ") then
            Error(Text001);
    end;
}

