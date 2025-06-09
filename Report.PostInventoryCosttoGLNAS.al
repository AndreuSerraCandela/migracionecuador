report 56040 "Post Inventory Cost to G/L_NAS"
{
    Caption = 'Post Inventory Cost to G/L';
    Permissions = TableData "Item Ledger Entry" = r,
                  TableData "Invt. Posting Buffer" = r,
                  TableData "Prod. Order Line" = r,
                  TableData "Value Entry" = rm,
                  TableData "Post Value Entry to G/L" = rd,
                  TableData "Capacity Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PageLoop; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            dataitem(PerEntryLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                PrintOnlyIfDetail = true;
                dataitem(PostValueEntryToGL; "Post Value Entry to G/L")
                {
                    DataItemTableView = SORTING("Item No.", "Posting Date");
                    RequestFilterFields = "Item No.", "Posting Date";

                    trigger OnAfterGetRecord()
                    begin
                        ItemValueEntry.Get("Value Entry No.");
                        if ItemValueEntry."Item Ledger Entry No." = 0 then begin
                            TempCapValueEntry."Entry No." := ItemValueEntry."Entry No.";
                            TempCapValueEntry."Order Type" := ItemValueEntry."Order Type";
                            TempCapValueEntry."Order No." := ItemValueEntry."Order No.";
                            TempCapValueEntry.Insert;
                        end;

                        if (ItemValueEntry."Item Ledger Entry No." = 0) or not ItemValueEntry.Inventoriable or
                           ((ItemValueEntry."Cost Amount (Actual)" = 0) and (ItemValueEntry."Cost Amount (Expected)" = 0) and
                            (ItemValueEntry."Cost Amount (Actual) (ACY)" = 0) and (ItemValueEntry."Cost Amount (Expected) (ACY)" = 0))
                        then
                            CurrReport.Skip;

                        if not InvtPost.BufferInvtPosting(ItemValueEntry) then begin
                            InsertValueEntryNoBuf(ItemValueEntry);
                            CurrReport.Skip;
                        end;

                        UpdateAmounts;
                        Mark(true);
                        if Post and (PostMethod = PostMethod::"per Entry") then
                            PostEntryToGL(ItemValueEntry);

                        if not Item.Get("Item No.") then
                            Item.Description := Text005;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if Post then begin
                            MarkedOnly(true);
                            DeleteAll;
                        end;
                    end;

                    trigger OnPreDataItem()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        if Post then begin
                            GLEntry.LockTable;
                            if GLEntry.FindLast then;
                        end;
                    end;
                }
                dataitem(CapValueEntry; "Value Entry")
                {
                    DataItemTableView = SORTING("Entry No.");

                    trigger OnAfterGetRecord()
                    begin
                        if TempCapValueEntry.Next = 0 then
                            Clear(TempCapValueEntry);
                        SetRange("Order Type", TempCapValueEntry."Order Type");
                        SetRange("Order No.", TempCapValueEntry."Order No.");
                        SetRange("Entry No.", TempCapValueEntry."Entry No.");

                        if not InvtPost.BufferInvtPosting(CapValueEntry) then begin
                            InsertValueEntryNoBuf(CapValueEntry);
                            CurrReport.Skip;
                        end;

                        UpdateAmounts;
                        PostValueEntryToGL.Get("Entry No.");
                        PostValueEntryToGL.Mark(true);
                        if Post and (PostMethod = PostMethod::"per Entry") then
                            PostEntryToGL(CapValueEntry);
                    end;

                    trigger OnPostDataItem()
                    begin
                        TempCapValueEntry.DeleteAll;
                        if Post then begin
                            PostValueEntryToGL.MarkedOnly(true);
                            PostValueEntryToGL.DeleteAll;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if TempCapValueEntry.IsEmpty then
                            CurrReport.Break;

                        SetCurrentKey("Order Type", "Order No.");
                        TempCapValueEntry.SetCurrentKey("Order Type", "Order No.");
                        if TempCapValueEntry.Find('-') then
                            SetRange("Order Type", TempCapValueEntry."Order Type");
                        SetRange("Order No.", TempCapValueEntry."Order No.");
                        SetRange("Entry No.", TempCapValueEntry."Entry No.");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    case PostMethod of
                        PostMethod::"per Posting Group":
                            if DocNo = '' then
                                Error(
                                  Text000, ItemValueEntry.FieldCaption("Document No."), SelectStr(PostMethod + 1, Text012));
                        PostMethod::"per Entry":
                            if DocNo <> '' then
                                Error(
                                  Text001, ItemValueEntry.FieldCaption("Document No."), SelectStr(PostMethod + 1, Text012));
                    end;
                    GLSetup.Get;
                end;
            }
            dataitem(InvtPostingBufferLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        if not InvtPostBuf.FindSet then
                            CurrReport.Break;
                    end else
                        if InvtPostBuf.Next = 0 then
                            CurrReport.Break;

                    InvtPostExt.GetDimBuf(InvtPostBuf."Dimension Set ID", TempDimBuf);
                    GetDimText;

                    if InvtPostBuf.UseInvtPostSetup then
                        GenPostingSetupTxt :=
                          StrSubstNo('%1,%2', InvtPostBuf."Location Code", InvtPostBuf."Inventory Posting Group")
                    else
                        GenPostingSetupTxt :=
                          StrSubstNo('%1,%2', InvtPostBuf."Gen. Bus. Posting Group", InvtPostBuf."Gen. Prod. Posting Group");
                end;

                trigger OnPostDataItem()
                var
                    ValueEntry: Record "Value Entry";
                begin
                    if Post and (PostMethod = PostMethod::"per Posting Group") then begin
                        ValueEntry."Document No." := DocNo;
                        PostEntryToGL(ValueEntry);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if PostMethod = PostMethod::"per Posting Group" then
                        InvtPost.GetInvtPostBuf(InvtPostBuf);
                    InvtPostBuf.Reset;
                end;
            }
            dataitem(SkippedValueEntry; "Value Entry")
            {
                DataItemTableView = SORTING("Item No.");

                trigger OnAfterGetRecord()
                begin
                    if TempValueEntry.Next = 0 then
                        Clear(TempValueEntry);

                    SetRange("Item No.", TempValueEntry."Item No.");
                    SetRange("Entry No.", TempValueEntry."Entry No.");

                    if Item.Get("Item No.") then;
                    if "Expected Cost" then
                        CostAmt := "Cost Amount (Expected)"
                    else
                        CostAmt := "Cost Amount (Actual)";
                end;

                trigger OnPreDataItem()
                begin
                    TempValueEntry.SetCurrentKey("Item No.");
                    if not TempValueEntry.FindSet then
                        CurrReport.Break;

                    SetRange("Item No.", TempValueEntry."Item No.");
                    SetRange("Entry No.", TempValueEntry."Entry No.");
                end;
            }

            trigger OnPreDataItem()
            begin
                PostMethodInt := PostMethod;
            end;
        }
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
                    field(PostMethod; PostMethod)
                    {
                    ApplicationArea = All;
                        Caption = 'Posting Method';
                        OptionCaption = 'Per Posting Group,Per Entry';
                    }
                    field(DocumentNo; DocNo)
                    {
                    ApplicationArea = All;
                        Caption = 'Document No.';
                    }
                    field(Post; Post)
                    {
                    ApplicationArea = All;
                        Caption = 'Post';
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

    trigger OnPostReport()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        if Post then
            UpdateAnalysisView.UpdateAll(0, true);
    end;

    trigger OnPreReport()
    begin
        ValueEntryFilter := ItemValueEntry.GetFilters;
        InvtSetup.Get;

        //AMS
        PostMethod := 1;
        Post := true;
        //AMS

        TempTable."No." := '1';
        if not TempTable.Insert then
            TempTable.Modify;
    end;

    var
        Text000: Label 'Please enter a %1 when posting %2.';
        Text001: Label 'Do not enter a %1 when posting %2.';
        Text002: Label 'Posted %1';
        Text003: Label 'Processing items             #1##########';
        Text005: Label 'The item no. no longer exists.';
        Text99000000: Label 'Processing production order  #1##########';
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
        InvtSetup: Record "Inventory Setup";
        InvtPostBuf: Record "Invt. Posting Buffer" temporary;
        TempDimBuf: Record "Dimension Buffer" temporary;
        TempCapValueEntry: Record "Value Entry" temporary;
        TempValueEntry: Record "Value Entry" temporary;
        ItemValueEntry: Record "Value Entry";
        InvtPost: Codeunit "Inventory Posting To G/L";
        InvtPostExt: Codeunit "Inventory Posting To G/L Ext";
        DocNo: Code[20];
        GenPostingSetupTxt: Text[250];
        ValueEntryFilter: Text;
        DimText: Text[120];
        PostMethod: Option "per Posting Group","per Entry";
        COGSAmt: Decimal;
        InvtAdjmtAmt: Decimal;
        DirCostAmt: Decimal;
        OvhdCostAmt: Decimal;
        VarPurchCostAmt: Decimal;
        VarMfgDirCostAmt: Decimal;
        VarMfgOvhdAmt: Decimal;
        WIPInvtAmt: Decimal;
        InvtAmt: Decimal;
        TotalCOGSAmt: Decimal;
        TotalInvtAdjmtAmt: Decimal;
        TotalDirCostAmt: Decimal;
        TotalOvhdCostAmt: Decimal;
        TotalVarPurchCostAmt: Decimal;
        TotalVarMfgDirCostAmt: Decimal;
        TotalVarMfgOvhdCostAmt: Decimal;
        TotalWIPInvtAmt: Decimal;
        TotalInvtAmt: Decimal;
        CostAmt: Decimal;
        Post: Boolean;
        Text012: Label 'per Posting Group,per Entry';
        PostMethodInt: Integer;
        TempTable: Record "G/L Account2";
        PageNoCaptionLbl: Label 'Page';
        PostInvCosttoGLCaptionLbl: Label 'Post Inventory Cost to G/L';
        TestReportnotpostedCaptionLbl: Label 'Test Report (Not Posted)';
        DocNoCaptionLbl: Label 'Document No.';
        EntryNoCaptionLbl: Label 'Entry No.';
        ItemLedgerEntryTypeCaptionLbl: Label 'Item Ledger Entry Type';
        SourceNoCaptionLbl: Label 'Source No.';
        InvPostingGroupCaptionLbl: Label 'Inventory Posting Group';
        PostingDateCaptionLbl: Label 'Posting Date';
        COGSCaptionLbl: Label 'COGS', Comment = 'Cost of goods sold';
        InventoryAdjustmentCaptionLbl: Label 'Inventory Adjustment';
        DirectCostAppliedCaptionLbl: Label 'Direct Cost Applied';
        OverheadAppliedCaptionLbl: Label 'Overhead Applied';
        PurchaseVarianceCaptionLbl: Label 'Purchase Variance';
        VarMfgDirectCostAppliedCaptionLbl: Label 'Mfg. Direct Cost Variance';
        MfgOvhdVarianceCaptionLbl: Label 'Manufacturing Ovhd Variance';
        WIPInventoryCaptionLbl: Label 'WIP Inventory';
        InventoryCaptionLbl: Label 'Inventory';
        ExpectedCostCaptionLbl: Label 'Expected Cost';
        InventoryCostPostedtoGLCaptionLbl: Label 'Inventory Cost Posted to G/L';
        ItemCaptionLbl: Label 'Item';
        EntryTypeCaptionLbl: Label 'Entry Type';
        DimTextCaptionLbl: Label 'Line Dimensions';
        GenPostingSetupTxtCaptionLbl: Label 'General Posting Setup';
        TotalCaptionLbl: Label 'Total';
        InvtPostBufAmountCaptionLbl: Label 'Amount';
        CostAmtCaptionLbl: Label 'Cost Amount';
        ExpectedCost_SkippedValueEntryCaptionLbl: Label 'Skipped Value Entries';
        SkippedItemsCaptionLbl: Label 'Skipped Items';


    procedure InitializeRequest(NewPostMethod: Option; NewDocNo: Code[20]; NewPost: Boolean)
    begin
        PostMethod := NewPostMethod;
        DocNo := NewDocNo;
        Post := NewPost;
    end;


    procedure GetDimText()
    var
        OldDimText: Text[75];
    begin
        DimText := '';

        if TempDimBuf.FindSet then
            repeat
                OldDimText := DimText;
                if DimText = '' then
                    DimText := StrSubstNo('%1 - %2', TempDimBuf."Dimension Code", TempDimBuf."Dimension Value Code")
                else
                    DimText :=
                      StrSubstNo(
                        '%1; %2 - %3', DimText, TempDimBuf."Dimension Code", TempDimBuf."Dimension Value Code");
                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                    DimText := OldDimText;
                    exit;
                end;
            until TempDimBuf.Next = 0;
    end;

    local procedure PostEntryToGL(ValueEntry: Record "Value Entry")
    begin
        InvtPost.Initialize(PostMethod = PostMethod::"per Posting Group");
        InvtPost.Run(ValueEntry);
    end;

    local procedure UpdateAmounts()
    begin
        InvtPost.GetAmtToPost(
          COGSAmt, InvtAdjmtAmt, DirCostAmt,
          OvhdCostAmt, VarPurchCostAmt, VarMfgDirCostAmt, VarMfgOvhdAmt,
          WIPInvtAmt, InvtAmt, false);

        InvtPost.GetAmtToPost(
          TotalCOGSAmt, TotalInvtAdjmtAmt, TotalDirCostAmt,
          TotalOvhdCostAmt, TotalVarPurchCostAmt, TotalVarMfgDirCostAmt, TotalVarMfgOvhdCostAmt,
          TotalWIPInvtAmt, TotalInvtAmt, true);
    end;

    local procedure InsertValueEntryNoBuf(ValueEntry: Record "Value Entry")
    begin
        TempValueEntry.Init;
        TempValueEntry := ValueEntry;
        TempValueEntry.Insert;
    end;
}

