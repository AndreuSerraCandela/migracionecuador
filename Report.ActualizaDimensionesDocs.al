report 75000 "Actualiza Dimensiones Docs"
{
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'Update Dimensions Docs';
    ProcessingOnly = true;
    ShowPrintStatus = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = WHERE(Type = CONST(Item));

            trigger OnAfterGetRecord()
            begin


                /*   CreateDim(
                    DimMgt.TypeToTableID3(Type), "No.",
                    DATABASE::Job, "Job No.",
                    DATABASE::"Responsibility Center", "Responsibility Center"); */
                Modify;
                UpdateDia;
            end;

            trigger OnPreDataItem()
            begin
                wDia.Update(1, 'Ventas');
                wTotal := Count;
                wCont := 0;
                wStep := wTotal div 100;
                if wStep = 0 then
                    wStep := 1;
            end;
        }
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = WHERE(Type = CONST(Item));

            trigger OnAfterGetRecord()
            begin
                /* CreateDim(
                  DimMgt.TypeToTableID3(Type), "No.",
                  DATABASE::Job, "Job No.",
                  DATABASE::"Responsibility Center", "Responsibility Center",
                  DATABASE::"Work Center", "Work Center No."); */
                Modify;
                UpdateDia;
            end;

            trigger OnPreDataItem()
            begin
                wDia.Update(1, 'Compras');
                wTotal := Count;
                wCont := 0;
                wStep := wTotal div 100;
                if wStep = 0 then
                    wStep := 1;
                wTotal := Count;
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

    trigger OnPostReport()
    begin
        wDia.Close;
        Message(Text001);
    end;

    trigger OnPreReport()
    begin
        wDia.Open('#1###########\@2@@@@@@@@@@@')
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        Text001: Label 'Proceso Terminado';
        wDia: Dialog;
        wTotal: Integer;
        wCont: Integer;
        wStep: Integer;


    procedure UpdateDia()
    begin
        // UpdateDia
        wCont += 1;
        if wCont mod wStep = 0 then
            wDia.Update(2, Round(wCont / wTotal * 10000, 1));
    end;
}

