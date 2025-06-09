report 56078 "Productos sin movimientos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Productossinmovimientos.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(ArtikelCaption; ArtikelCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item__No__Caption; FieldCaption("No."))
            {
            }
            column(Item_DescriptionCaption; FieldCaption(Description))
            {
            }

            trigger OnAfterGetRecord()
            begin
                rItemLedgerEntry.Reset;
                rItemLedgerEntry.SetCurrentKey("Entry Type", "Item No.", "Variant Code", "Source Type", "Source No.", "Posting Date");
                rItemLedgerEntry.SetRange(rItemLedgerEntry."Entry Type", 0, 1);
                rItemLedgerEntry.SetRange(rItemLedgerEntry."Item No.", Item."No.");
                rItemLedgerEntry.SetRange(rItemLedgerEntry."Posting Date", FechaDesde, FechaHasta);
                if rItemLedgerEntry.Find('-') then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                FechaDesde := Item.GetRangeMin("Date Filter");
                FechaHasta := Item.GetRangeMax("Date Filter");
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
        rItemLedgerEntry: Record "Item Ledger Entry";
        FechaDesde: Date;
        FechaHasta: Date;
        ArtikelCaptionLbl: Label 'Item';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
}

