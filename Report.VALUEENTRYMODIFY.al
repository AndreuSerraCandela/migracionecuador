report 55525 "VALUE ENTRY MODIFY"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item Ledger Entry No." = FIELD ("Entry No.");

                trigger OnAfterGetRecord()
                begin

                    if ("Value Entry"."Order Type" = "Value Entry"."Order Type"::" ") and ("Value Entry"."Order No." = '') and ("Value Entry"."Order Line No." = 0) then begin
                        "Value Entry"."Order Type" := "Item Ledger Entry"."Order Type";
                        "Value Entry"."Order No." := "Item Ledger Entry"."Order No.";
                        "Value Entry"."Order Line No." := "Item Ledger Entry"."Order Line No.";
                        "Value Entry".Modify;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Ventana.Update(1, "Item Ledger Entry"."Entry No.");
            end;

            trigger OnPostDataItem()
            begin
                Ventana.Close;
                Message('FIN');
            end;

            trigger OnPreDataItem()
            begin
                Ventana.Open(Text0001);
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
        if not Confirm(CompanyName) then
            exit;
    end;

    var
        Text0001: Label 'No. Movimiento #1#############';
        Ventana: Dialog;
}

