report 55029 "Productos Datos Incompletos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ProductosDatosIncompletos.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
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
            column(Falta; Falta)
            {
            }
            column(ItemCaption; ItemCaptionLbl)
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
                Falta := false;

                if (Description = '') or ("Base Unit of Measure" = '') or (Item."Inventory Posting Group" = '') or (Item."Item Disc. Group" = '') or
                (Item."VAT Prod. Posting Group" = '') or (Item."Item Category Code" = '') or (Item."Item Category Code" = '') or
                (Item."No. Paginas" = 0) or (Item.Tipos = '') or (Item.Sello = '') or (Item.Autor = '') or (Item."Gramaje Hoja" = '') then
                    Falta := true
                else
                    Falta := false;

                if not DefDim.Get(27, Item."No.", 'EDICION_COLECCION') then
                    Falta := true;
                if not DefDim.Get(27, Item."No.", 'LINEA_NEGOCIO') then
                    Falta := true;
                if not DefDim.Get(27, Item."No.", 'TIPO_COSTO') then
                    Falta := true;


                if Falta = false then
                    CurrReport.Skip;
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
        Falta: Boolean;
        DefDim: Record "Default Dimension";
        ItemCaptionLbl: Label 'Item';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
}

