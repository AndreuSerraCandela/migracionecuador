report 56005 "Adjust Cost - Item Ent. - NAS"
{
    Caption = 'Adjust Cost - Item Entries';
    Permissions = TableData "Item Ledger Entry" = rimd,
                  TableData "Item Application Entry" = r,
                  TableData "Value Entry" = rimd,
                  TableData "Avg. Cost Adjmt. Entry Point" = rimd;
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FilterItemNo; ItemNoFilter)
                    {
                    ApplicationArea = All;
                        Caption = 'Item No. Filter';
                        Editable = FilterItemNoEditable;
                        TableRelation = Item;

                        trigger OnValidate()
                        begin
                            ItemNoFilterOnAfterValidate;
                        end;
                    }
                    field(FilterItemCategory; ItemCategoryFilter)
                    {
                    ApplicationArea = All;
                        Caption = 'Item Category Filter';
                        Editable = FilterItemCategoryEditable;
                        TableRelation = "Item Category";

                        trigger OnValidate()
                        begin
                            ItemCategoryFilterOnAfterValid;
                        end;
                    }
                    field(Post; PostToGL)
                    {
                    ApplicationArea = All;
                        Caption = 'Post to G/L';
                        Enabled = PostEnable;

                        trigger OnValidate()
                        var
                            ObjTransl: Record "Object Translation";
                        begin
                            if not PostToGL then
                                Message(
                                  Text003,
                                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Report, REPORT::"Post Inventory Cost to G/L"));
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            FilterItemCategoryEditable := true;
            FilterItemNoEditable := true;
            PostEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InvtSetup.Get;
            PostToGL := InvtSetup."Automatic Cost Posting";
            PostEnable := PostToGL;

            UpdateFilterControls;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        ItemApplnEntry: Record "Item Application Entry";
        AvgCostAdjmtEntryPoint: Record "Avg. Cost Adjmt. Entry Point";
        Item: Record Item;
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
    begin
        PostToGL := true;
        ItemApplnEntry.LockTable;
        if not ItemApplnEntry.Find('+') then
            exit;
        ItemLedgEntry.LockTable;
        if not ItemLedgEntry.Find('+') then
            exit;
        AvgCostAdjmtEntryPoint.LockTable;
        if AvgCostAdjmtEntryPoint.Find('+') then;
        ValueEntry.LockTable;
        if not ValueEntry.Find('+') then
            exit;

        if (ItemNoFilter <> '') and (ItemCategoryFilter <> '') then
            Error(Text005);

        if ItemNoFilter <> '' then
            Item.SetFilter("No.", ItemNoFilter);
        if ItemCategoryFilter <> '' then
            Item.SetFilter("Item Category Code", ItemCategoryFilter);

        InvtAdjmt.SetProperties(false, PostToGL);
        InvtAdjmt.SetFilterItem(Item);
        InvtAdjmt.MakeMultiLevelAdjmt;

        UpdateItemAnalysisView.UpdateAll(0, true);
    end;

    var
        Text003: Label 'Be aware that your general and item ledgers will no longer be synchronized after running the cost adjustment! You must run the %1 report to synchronize them again.';
        InvtSetup: Record "Inventory Setup";
        InvtAdjmt: Codeunit "Inventory Adjustment";
        ItemNoFilter: Text[250];
        ItemCategoryFilter: Text[250];
        Text005: Label 'You must not use Item No. Filter and Item Category Filter at the same time.';
        PostToGL: Boolean;
        PostEnable: Boolean;
        FilterItemNoEditable: Boolean;
        FilterItemCategoryEditable: Boolean;

    local procedure UpdateFilterControls()
    begin
            PageUpdateFilterControls;
    end;


    procedure InitializeRequest(NewItemNoFilter: Text[250]; NewItemCategoryFilter: Text[250])
    begin
        ItemNoFilter := NewItemNoFilter;
        ItemCategoryFilter := NewItemCategoryFilter;
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        UpdateFilterControls;
    end;

    local procedure ItemCategoryFilterOnAfterValid()
    begin
        UpdateFilterControls;
    end;

    local procedure PageUpdateFilterControls()
    begin
    end;
}

