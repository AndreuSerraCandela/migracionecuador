report 76011 "DsPOS - Etiquetas gondolas"
{
    DefaultLayout = RDLC;
    RDLCLayout = './DsPOSEtiquetasgondolas.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(Addr_1__1_; Addr[1] [1])
            {
            }
            column(Addr_1__2_; Addr[1] [2])
            {
            }
            column(Addr_2__1_; Addr[2] [1])
            {
            }
            column(Addr_2__2_; Addr[2] [2])
            {
            }
            column(Addr_3__1_; Addr[3] [1])
            {
            }
            column(Addr_3__2_; Addr[3] [2])
            {
            }
            column(Addr_1__3_; Addr[1] [3])
            {
            }
            column(Addr_2__3_; Addr[2] [3])
            {
            }
            column(Addr_3__3_; Addr[3] [3])
            {
            }
            column(ColumnNo; ColumnNo)
            {
            }
            column(Item_No_; "No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecordNo := RecordNo + 1;
                ColumnNo := ColumnNo + 1;

                Clear(Addr[ColumnNo] [3]);

                rItemCrossref.Reset;
                rItemCrossref.SetRange(rItemCrossref."Item No.", "No.");
                rItemCrossref.SetRange(rItemCrossref."Unit of Measure", "Sales Unit of Measure");
                if rItemCrossref.Find('-') then
                    Addr[ColumnNo] [3] := Format(rItemCrossref."Reference No.")
                else
                    Addr[ColumnNo] [3] := Format('');


                Addr[ColumnNo] [1] := Format("No.");
                Addr[ColumnNo] [2] := Format(Description);



                CompressArray(Addr[ColumnNo]);

                if RecordNo = NoOfRecords then begin
                    for i := ColumnNo + 1 to NoOfColumns do
                        Clear(Addr[i]);
                    ColumnNo := 0;
                end else begin
                    if ColumnNo = NoOfColumns then
                        ColumnNo := 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                NoOfRecords := Count;
                NoOfColumns := 3;
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
        Addr: array[3, 3] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        rItemCrossref: Record "Item Reference";
}

