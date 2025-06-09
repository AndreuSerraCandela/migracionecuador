report 56134 "Reporte Consignación x cliente"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReporteConsignaciónxcliente.rdlc';
    ApplicationArea = Suite, Basic;
    Caption = 'Consignment x client report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Location Code");
            RequestFilterFields = "Location Code", "Pedido Consignacion";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }

            column(USERID; UserId)
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__bruto_Inicial_; "Importe Cons. bruto Inicial")
            {
            }
            column(Item_Ledger_Entry_Quantity; Quantity)
            {
            }
            column(Item_Ledger_Entry__Location_Code_; "Location Code")
            {
            }
            column(Item_Ledger_EntryCaption; Item_Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Control1000000012Caption; Control1000000012CaptionLbl)
            {
            }
            column(Control1000000015Caption; Control1000000015CaptionLbl)
            {
            }
            column(Control1000000018Caption; Control1000000018CaptionLbl)
            {
            }
            column(Control1000000021Caption; Control1000000021CaptionLbl)
            {
            }
            column(Control1000000024Caption; Control1000000024CaptionLbl)
            {
            }
            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Location Code");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total for ';
        Item_Ledger_EntryCaptionLbl: Label 'Item Ledger Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Control1000000012CaptionLbl: Label 'Label1000000012';
        Control1000000015CaptionLbl: Label 'Label1000000015';
        Control1000000018CaptionLbl: Label 'Label1000000018';
        Control1000000021CaptionLbl: Label 'Label1000000021';
        Control1000000024CaptionLbl: Label 'Label1000000024';
}

