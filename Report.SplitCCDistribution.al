report 76058 "Split CC Distribution"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = CONST("G/L Account"), "No." = FILTER(<> ''));

            trigger OnAfterGetRecord()
            begin

                Counter += 1;
                Clear(wImporteAsignar);

                PurchLine2.Reset;
                PurchLine2.SetRange("Document Type", "Document Type");
                PurchLine2.SetRange("Document No.", "Document No.");
                PurchLine2.SetRange(Type, Type);
                PurchLine2.SetRange("No.", "No.");
                PurchLine2.FindFirst;

                ConfCC.SetRange("Cta. Contable", "No.");
                ConfCC.FindSet;
                repeat
                    Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                    NoLin += 1000;
                    PurchLine2.TransferFields("Purchase Line");
                    PurchLine2."Line No." := NoLin;
                    PurchLine2.Validate("Direct Unit Cost", PurchLine2."Direct Unit Cost" * ConfCC."% a distribuir" / 100);
                    PurchLine2.Insert;
                    AssignDimension;
                until ConfCC.Next = 0;

                Delete(true);
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin

                PurchLine2.Reset;
                PurchLine2.SetFilter("Document Type", GetFilter("Document Type"));
                PurchLine2.SetFilter("Document No.", GetFilter("Document No."));
                PurchLine2.FindLast;
                NoLin := PurchLine2."Line No.";

                CounterTotal := Count;
                Window.Open(Text001);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ConfCC: Record "Config. Distrib. CC";
        PuchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        NoLin: Integer;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        TipoDoc: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt";
        rItem: Record Item;
        wImporteAsignar: Decimal;
        rGenLedgerSetUp: Record "General Ledger Setup";
        rPurchInvLine: Record "Purch. Inv. Line";
        rPurchHeader: Record "Purchase Header";
        wCantTotalCajas: Decimal;
        wCantTotalLitros: Decimal;
        Cont: Boolean;
        wAcum: Decimal;
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        Err001: Label 'There is not assigment of Item Charge %1 for %2 %3';
        Err002: Label 'There are lines with zero amount in Item Charge %1 for %2 %3';


    procedure AssignDimension()
    var
        DimMgt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
    begin

        DimMgt.GetDimensionSet(TempDimSetEntry, PurchLine2."Dimension Set ID");
        if TempDimSetEntry.Get(PurchLine2."Dimension Set ID", ConfCC."Dimension Code") then
            TempDimSetEntry.Delete;
        DimVal.Get(ConfCC."Dimension Code", ConfCC.Codigo);
        TempDimSetEntry.Init;
        TempDimSetEntry."Dimension Set ID" := PurchLine2."Dimension Set ID";
        TempDimSetEntry."Dimension Code" := ConfCC."Dimension Code";
        TempDimSetEntry."Dimension Value Code" := ConfCC.Codigo;
        TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
        TempDimSetEntry.Insert;
        PurchLine2."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        PurchLine2.Modify;
    end;
}

