report 56012 "Actualiza Importe Consignacion"
{
    Caption = 'Update Consignment Amount';
    Permissions = TableData "Item Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending);
            RequestFilterFields = "No.";
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD ("No.");
                DataItemTableView = SORTING ("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date") ORDER(Ascending) WHERE (Open = FILTER (true));

                trigger OnAfterGetRecord()
                begin
                    //IF "Pedido Consignacion" OR "Devolucion Consignacion" THEN
                    Counter := Counter + 1;
                    Window.Update(1, "Item Ledger Entry"."Document No.");
                    Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                    "Precio Unitario Cons. Act." := cuFunSan.CalcrPrecio("Item No.", "Location Code", "Unit of Measure Code", WorkDate);
                    "Descuento % Cons. Actualizado" := cuFunSan.CalcDesc("Item No.", "Location Code", "Unit of Measure Code", WorkDate);

                    "Importe Cons. bruto Act." := (Quantity * "Precio Unitario Cons. Act.");
                    wImpDesc := ((Quantity * "Precio Unitario Cons. Act.") * "Descuento % Cons. Actualizado") / 100;
                    "Importe Cons. Neto Act." := ((Quantity * "Precio Unitario Cons. Act.") - wImpDesc);
                    "Ult. Fecha Act. Imp. Consig." := WorkDate;
                    Modify;
                end;

                trigger OnPostDataItem()
                begin
                    Window.Close;
                end;

                trigger OnPreDataItem()
                begin
                    CounterTotal := Count;
                    Window.Open(Text001);
                end;
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

    var
        cuFunSan: Codeunit "Funciones Santillana";
        wImpDesc: Decimal;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
}

