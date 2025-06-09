report 76012 "Copia productos"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Global Dimension 1 Code", Edicion, "Sub Familia";

            trigger OnAfterGetRecord()
            begin
                if Promotor = '' then
                    Error(Err001);
                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                case TipoPresupuesto of
                    0: //Ventas
                        begin
                            PptoVentas.Init;
                            PptoVentas.Validate("Cod. Promotor", Promotor);
                            PptoVentas.Validate("Cod. Producto", "No.");
                            if PptoVentas.Insert then;
                        end;
                    1: //Muestras
                        begin
                            PptoMuestras.Init;
                            PptoMuestras.Validate("Cod. Promotor", Promotor);
                            PptoMuestras.Validate("Cod. Producto", "No.");
                            if PptoMuestras.Insert then;
                        end;
                end;
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
        Text001: Label 'Reading item  #1########## @2@@@@@@@@@@@@@';
        PptoVentas: Record "Promotor - Ppto Vtas";
        PptoMuestras: Record "Promotor - Ppto Muestras";
        Promotor: Code[20];
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Err001: Label 'You must specify a Salesperson Code';
        TipoPresupuesto: Option Ventas,Muestras;


    procedure RecibeDatos(CodPromotor: Code[20]; TipoPpto: Option Ventas,Muestras)
    begin
        Promotor := CodPromotor;
        TipoPresupuesto := TipoPpto;
    end;
}

