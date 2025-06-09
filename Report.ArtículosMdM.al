report 75001 "Artículos MdM"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ArtículosMdM.rdlc';
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'MdM Articles';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Gestionado MdM";
            column(fItemNo; Item."No.")
            {
                IncludeCaption = true;
            }
            column(fItemDescription; Item.Description)
            {
                IncludeCaption = true;
            }
            column(fItemEstado; Item.Estado)
            {
                IncludeCaption = true;
            }
            column(fItemFechaAlmacen; Item."Fecha Almacen")
            {
                IncludeCaption = true;
            }
            column(fItemFechaComerc; Item."Fecha Comercializacion")
            {
                IncludeCaption = true;
            }
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
}

