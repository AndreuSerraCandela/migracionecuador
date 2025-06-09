report 56021 "Calcula Inventario Movil."
{
    ApplicationArea = Basic, Suite;
    Caption = 'Calculate Mobile Inventory';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Location Filter";

            trigger OnAfterGetRecord()
            begin
                if GuiAllowed then begin
                    Counter := Counter + 1;
                    Window.Update(1, Item."No.");
                    Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                end;

                Loc.Reset;
                if Loc.FindSet then
                    repeat
                        Item1.Get("No.");
                        Item1.SetFilter("Location Filter", Loc.Code);
                        Item1.CalcFields(Inventory);
                        DispInv.Init;
                        DispInv.Validate("Cod. Producto", Item1."No.");
                        DispInv.Validate(Descripcion, Item1.Description);
                        DispInv.Validate("Cod. Almancen", Loc.Code);
                        DispInv.Validate(Inventario, Item1.Inventory);
                        DispInv.Validate("Fecha Ult. Actualizacion", WorkDate);
                        DispInv.Validate("Linea de Negocio", "Global Dimension 1 Code");
                        if ICC.Get(Item."Item Category Code") then begin
                            DispInv.Validate("Cod. Categoria Producto", ICC.Code);
                            DispInv.Validate("Nombre Categoria Producto", ICC.Description);
                        end;

                        if Item1.Inventory <> 0 then
                            if not DispInv.Insert then
                                DispInv.Modify;
                    until Loc.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                DispInv.DeleteAll(true);

                if GuiAllowed then begin
                    CounterTotal := Count;
                    Window.Open(Text001);
                end;
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
        if GuiAllowed then
            Window.Close;
    end;

    var
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        DispInv: Record "Inventario Disp. Movil.";
        Loc: Record Location;
        Item1: Record Item;
        Inventario: Decimal;
        ICC: Record "Item Category";
}

