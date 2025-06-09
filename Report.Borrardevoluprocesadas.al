report 56038 "Borrar devolu. procesadas"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Delete Returns classification';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(PreDev; "Cab. clas. devolucion")
        {
            DataItemTableView = SORTING("No.") WHERE(Closed = CONST(true), Procesada = CONST(true));
            RequestFilterFields = "No.", "Customer no.", "Receipt date";

            trigger OnAfterGetRecord()
            begin
                dlgProgreso.Update(2, "No.");

                BorrarLineas;
                BorrarDocsClas;
                Delete;

                intProcesados += 1;
                dlgProgreso.Update(3, Round(intProcesados / intTotal * 10000, 1));
            end;

            trigger OnPostDataItem()
            begin
                dlgProgreso.Close;
            end;

            trigger OnPreDataItem()
            begin
                dlgProgreso.Open(Text003 + Text004 + Text005);
                dlgProgreso.Update(1, Text002);

                intTotal := Count;
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

    trigger OnPreReport()
    begin
        if not Confirm(Text006, false) then
            CurrReport.Quit;
    end;

    var
        recDocClas: Record "Docs. clas. devoluciones";
        dlgProgreso: Dialog;
        dtImpresion: DateTime;
        intTotal: Integer;
        intProcesados: Integer;
        Text001: Label 'Automatic return from customer %1';
        Text002: Label 'Clasificando devoluciones';
        Text003: Label '#############################1\\';
        Text004: Label 'Devolución    ###############2\\';
        Text005: Label '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3';
        Text006: Label '¿Esta seguro de que des eliminar las devoluciones procesadas?';


    procedure BorrarLineas()
    var
        recLinDev: Record "Lin. clas. devoluciones";
    begin
        recLinDev.Reset;
        recLinDev.SetRange("No. Documento", PreDev."No.");
        recLinDev.DeleteAll;
    end;


    procedure BorrarDocsClas()
    begin
        recDocClas.Reset;
        recDocClas.SetRange("No. clas. devoluciones", PreDev."No.");
        recDocClas.DeleteAll;
    end;
}

