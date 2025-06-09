report 50020 "Batch Post Assembly Orders EC"
{
    // Proyecto: Implementacion Microsoft Business central
    // 
    // LDP: Luis Jose De La Cruz Paredes
    // ------------------------------------------------------------------------
    // No.       Firma    Fecha           Descripcion
    // ------------------------------------------------------------------------
    // 001     LDP      10-04-2024      SANTINAV-5892: Pedidos de Ensamblado - fecha final - cambio masivo

    Caption = 'Batch Post Assembly Orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Assembly Header"; "Assembly Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            var
                BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
                /*   BatchPostParameterTypes: Codeunit "Batch Post Parameter Types"; */
                RecRef: RecordRef;
            begin
                if ReplacePostingDate and (PostingDateReq = 0D) then
                    Error(Text000);

                BatchProcessingMgt.SetProcessingCodeunit(CODEUNIT::"Assembly-Post");
                //BatchProcessingMgt.AddParameter(BatchPostParameterTypes.ReplacePostingDate, ReplacePostingDate); //Comentado
                //BatchProcessingMgt.AddParameter(BatchPostParameterTypes.PostingDate, PostingDateReq);

                //001+
                if ReplaceEndingDate and (EndingDateReq = 0D) then
                    Error(Text001);

                if (ReplaceEndingDate) and (EndingDateReq <> 0D) then begin
                    BatchProcessingMgt.SetProcessingCodeunit(CODEUNIT::"Assembly-Post");
                    //BatchProcessingMgt.AddParameter(BatchPostParameterTypes.ReplaceEndingDate, ReplaceEndingDate); //Comentado
                    //BatchProcessingMgt.AddParameter(BatchPostParameterTypes.EndingDate, EndingDateReq); 
                end;
                //001-

                RecRef.GetTable("Assembly Header");
                BatchProcessingMgt.BatchProcess(RecRef);
                RecRef.SetTable("Assembly Header");

                CurrReport.Break;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDateReq)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date that you want to use as the document date or the posting date when you post. ';
                    }
                    field(ReplacePostingDate; ReplacePostingDate)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Replace Posting Date';
                        ToolTip = 'Specifies if you want to replace the posting date of the orders with the date that is entered in the Posting Date field.';
                    }
                    field(EndingDate; EndingDateReq)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date that you want to use as the document date or the posting date when you post. ';
                    }
                    field(ReplaceEndingDate; ReplaceEndingDate)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Replace Ending Date';
                        ToolTip = 'Specifies if you want to replace the posting date of the orders with the date that is entered in the Posting Date field.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ReplacePostingDate := false;
        end;
    }

    labels
    {
    }

    var
        Text000: Label 'Enter the posting date.';
        PostingDateReq: Date;
        ReplacePostingDate: Boolean;
        Text001: Label 'Enter the ending date.';
        EndingDateReq: Date;
        ReplaceEndingDate: Boolean;

    procedure InitializeRequest(NewPostingDateReq: Date; NewReplacePostingDate: Boolean)
    begin
        PostingDateReq := NewPostingDateReq;
        ReplacePostingDate := NewReplacePostingDate;
    end;
}

