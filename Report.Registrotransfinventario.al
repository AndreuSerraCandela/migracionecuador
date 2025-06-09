report 56100 "Registro transf inventario"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Registrotransfinventario.rdlc';
    Caption = 'Item Register';

    dataset
    {
        dataitem("Item Register"; "Item Register")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Source Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(TIME; Time)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }

            column(USERID; UserId)
            {
            }
            column(ItemRegFilter; ItemRegFilter)
            {
            }
            column(Item_Register__Item_Register___User_ID_; "Item Register"."User ID")
            {
            }
            column(Item_RegisterCaption; Item_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Registrado_por_Caption; Registrado_por_CaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Posting_Date_Caption; "Item Ledger Entry".FieldCaption("Posting Date"))
            {
            }
            column(Item_Ledger_Entry__Entry_Type_Caption; Item_Ledger_Entry__Entry_Type_CaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Item_No__Caption; "Item Ledger Entry".FieldCaption("Item No."))
            {
            }
            column(Item_Ledger_Entry__Location_Code_Caption; "Item Ledger Entry".FieldCaption("Location Code"))
            {
            }
            column(Item_Ledger_Entry_QuantityCaption; Item_Ledger_Entry_QuantityCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Document_No__Caption; "Item Ledger Entry".FieldCaption("Document No."))
            {
            }
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__External_Document_No__Caption; "Item Ledger Entry".FieldCaption("External Document No."))
            {
            }
            column(Item_Register_No_; "No.")
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.");
                RequestFilterFields = "Item No.", "Entry Type", "Location Code", "Posting Date";
                column(Item_Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Item_Ledger_Entry__Entry_Type_; "Entry Type")
                {
                }
                column(Item_Ledger_Entry__Item_No__; "Item No.")
                {
                }
                column(Item_Ledger_Entry__Location_Code_; "Location Code")
                {
                    //Comentado DecimalPlaces = 0 : 5;
                }
                column(Item_Ledger_Entry_Quantity; Quantity)
                {
                }
                column(Item_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Item_Description; Item.Description)
                {
                }
                column(Item_Ledger_Entry__External_Document_No__; "External Document No.")
                {
                }
                column(Entregado_Por_______________________________Caption; Entregado_Por_______________________________CaptionLbl)
                {
                }
                column(Recibido_Por_______________________________Caption; Recibido_Por_______________________________CaptionLbl)
                {
                }
                column(Item_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //ItemDescription := Description; //-#139
                    //IF ItemDescription = '' THEN BEGIN //-#139
                    if not Item.Get("Item No.") then
                        Item.Init;
                    //  ItemDescription := Item.Description; //-#139
                    //END; //-#139

                    CalcFields("Cost Amount (Actual)");
                    if "Invoiced Quantity" = 0 then
                        LineUnitAmount := 0
                    else
                        LineUnitAmount := "Cost Amount (Actual)" / "Invoiced Quantity";
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.", "Item Register"."From Entry No.", "Item Register"."To Entry No.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Source Code" = '' then begin
                    SourceCodeText := '';
                    SourceCode.Init;
                end else begin
                    SourceCodeText := FieldCaption("Source Code") + ': ' + "Source Code";
                    if not SourceCode.Get("Source Code") then
                        SourceCode.Init;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintItemDescriptions; PrintItemDescriptions)
                    {
                    ApplicationArea = All;
                        Caption = 'Print Item Descriptions';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        ItemRegFilter := "Item Register".GetFilters;
        ItemEntryFilter := "Item Ledger Entry".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        SourceCode: Record "Source Code";
        Item: Record Item;
        PrintItemDescriptions: Boolean;
        ItemRegFilter: Text[250];
        ItemEntryFilter: Text[250];
        SourceCodeText: Text[30];
        Text000: Label 'Register No: %1';
        LineUnitAmount: Decimal;
        Item_RegisterCaptionLbl: Label 'Item Register';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Registrado_por_CaptionLbl: Label 'Registrado por:';
        Item_Ledger_Entry__Entry_Type_CaptionLbl: Label 'Entry Type';
        Item_Ledger_Entry_QuantityCaptionLbl: Label 'Cost Amount (Actual)';
        "DescripciónCaptionLbl": Label 'Descripción';
        Entregado_Por_______________________________CaptionLbl: Label 'Entregado Por: _____________________________';
        Recibido_Por_______________________________CaptionLbl: Label 'Recibido Por: _____________________________';
}

